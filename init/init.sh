#!/bin/bash

set -e
set -u

#!/bin/bash
set -e

function create_user() {
  echo "Creating user '$POSTGRES_DEV_USER'"
	psql -v ON_ERROR_STOP=1 <<-EOSQL
      CREATE USER $POSTGRES_DEV_USER WITH ENCRYPTED PASSWORD '$POSTGRES_DEV_PASSWORD';
EOSQL
}

function create_user_and_database() {
	local database=$1
	echo "  Creating database '$database'"
	psql -v ON_ERROR_STOP=1 <<-EOSQL
	    CREATE DATABASE $database;
      GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRES_DEV_USER;
EOSQL
}

if [ -n "$POSTGRES_DEV_DATABASES" ]; then
  create_user
	echo "database creation requested for: $POSTGRES_DEV_DATABASES"
	for db in $(echo "$POSTGRES_DEV_DATABASES" | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "databases created"
fi

