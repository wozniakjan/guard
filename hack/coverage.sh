#!/usr/bin/env bash
set -eou pipefail

export CGO_ENABLED=0
export GO111MODULE=on
export GOFLAGS="-mod=vendor"

GOPATH=$(go env GOPATH)
REPO_ROOT="$GOPATH/src/github.com/appscode/guard"

pushd $REPO_ROOT

echo "" >coverage.txt

for d in $(go list ./... | grep -v -e vendor -e test); do
  go test -installsuffix "static" -v -coverprofile=profile.out -covermode=atomic "$d"
  if [ -f profile.out ]; then
    cat profile.out >>coverage.txt
    rm profile.out
  fi
done

popd
