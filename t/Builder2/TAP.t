#!/usr/bin/perl -w

use strict;
use Test::Builder2::Output::TAP;
use lib 't/lib';

use Test::More;

my $output = new_ok("Test::Builder2::Output::TAP");

# Test the defaults
{
    is $output->output_fh,  *STDOUT;
    is $output->failure_fh, *STDERR;
    is $output->error_fh,   *STDERR;
}

$output->trap_output;

# Test that begin does nothing with no args
{
    $output->begin;
    is $output->read, "TAP version 13\n", "begin() with no args";
}

# Test begin
{
    $output->begin( tests => 99 );
    is $output->read, <<'END', "begin( tests => # )";
TAP version 13
1..99
END

}

# Test end
{
    $output->end();
    is $output->read, "", "end() does nothing";

    $output->end( tests => 42 );
    is $output->read, <<END, "end( tests => # )";
1..42
END
}

done_testing();