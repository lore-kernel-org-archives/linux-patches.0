Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DCB319614;
	Sat, 25 Oct 2025 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409602; cv=none; b=DbghV0Mka2EUw2hYhwfjXIWW/Fc8gd4UOv6PthKq6A5tZUoVNKG4WZkZNsOV1SbNBtSSFNW1qx2ya9NcVjqtnlxuMrbgia19Um4DBN6jPpeQgQEXqQVPOY6BABPgdeXLbJVPN/K/GnZoS5puE5nGq5aaqqoNQ+W1s74vxQRKYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409602; c=relaxed/simple;
	bh=A7pXHFb+mkrxKsjLPjcWCcNHdzrZOCEXo8XF2+O0/sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZ3kceoregRrfUMeN7+rHNQi0ewoDPFtNm68vSm/W8WER38KqSTvTRhFzX/fORICNw3chrkrd382gzrct8tQOMK4L3jdamNOCi1rKB3H12xw8eo/+2E16MgRlfijwMFOx6eEYmUo+DVSS7QtFkcv53kD8anBnFbums2t5d46rLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxzHrB9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxzHrB9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF31C4AF0B;
	Sat, 25 Oct 2025 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409601;
	bh=A7pXHFb+mkrxKsjLPjcWCcNHdzrZOCEXo8XF2+O0/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxzHrB9L1Cqb+6UVYVmzizlJkQnAF0BQIDlANBWoRkrwcWBhy2RG9A1M2lvLFwhwO
	 SpOB8XRdPV9JRv8ElHI7I+G6vC4+9CnSlYXYtZI+rAqy/5p3GDRC4pNPyk/jqUbT66
	 az1nVfz9Db5RIijpIME9RYpOk3gSRhJejGfct/8xwijo9A2tvXrqS9On17oDozCiAj
	 yLA7/aOzZ2/w8H1dAZiC8fpKWw1oGyB4LycGgiXfwBxfklAHMoV+eHZXDa4Gg8ImdE
	 QEbwqM9JE+7x4eM8krB7yjZM9QauPzcNO1Jq6OrT+S1cPDJA6+DgsIsBU1qWpwIS2w
	 WnROPmRPyT+tA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] selftests: traceroute: Return correct value on failure
Date: Sat, 25 Oct 2025 12:00:17 -0400
Message-ID: <20251025160905.3857885-386-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit c068ba9d3ded56cb1ba4d5135ee84bf8039bd563 ]

The test always returns success even if some tests were modified to
fail. Fix by converting the test to use the appropriate library
functions instead of using its own functions.

Before:

 # ./traceroute.sh
 TEST: IPV6 traceroute                                               [FAIL]
 TEST: IPV4 traceroute                                               [ OK ]

 Tests passed:   1
 Tests failed:   1
 $ echo $?
 0

After:

 # ./traceroute.sh
 TEST: IPv6 traceroute                                               [FAIL]
         traceroute6 did not return 2000:102::2
 TEST: IPv4 traceroute                                               [ OK ]
 $ echo $?
 1

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250908073238.119240-5-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real test bug: Previously the script always exited 0 even when
  subtests failed, making CI and automation miss failures. The commit
  switches the test to the common kselftest lib flow so a failing
  subtest yields a non‑zero exit.
  - Before: the script had its own `log_test()` that bumped
    `nsuccess`/`nfail` and set a `ret=1`, but the script ended by only
    printing counts, not propagating failure via exit status.
    - Removed custom `log_test()` and the `nsuccess`/`nfail` counters
      block at the end. See deletions in
      `tools/testing/selftests/net/traceroute.sh` where the local
      `log_test()` function and the final prints are removed.
  - After: uses standard helpers and exit path from `lib.sh`, so
    failures are reflected in the exit status.
    - Adds per‑test `RET=0` initializations and converts checks to
      `check_err`/`log_test`:
      - `tools/testing/selftests/net/traceroute.sh:171` sets `RET=0` at
        the start of `run_traceroute6()`, then:
        - Replaces `log_test $? 0 "IPV6 traceroute"` with `check_err $?
          "traceroute6 did not return 2000:102::2"` followed by
          `log_test "IPv6 traceroute"`.
      - `tools/testing/selftests/net/traceroute.sh:239` sets `RET=0` at
        the start of `run_traceroute()`, then:
        - Replaces `log_test $? 0 "IPV4 traceroute"` with `check_err $?
          "traceroute did not return 1.0.1.1"` followed by `log_test
          "IPv4 traceroute"`.
    - Returns the aggregated status via kselftest’s exit variable:
      `tools/testing/selftests/net/traceroute.sh:...` changes the tail
      to `exit "${EXIT_STATUS}"` instead of printing counters.
    - These helpers are provided by the shared library already sourced
      at the top (`source lib.sh`), which defines `EXIT_STATUS`, `RET`,
      `check_err`, and `log_test` (e.g.,
      `tools/testing/selftests/net/lib.sh:1`,
      `tools/testing/selftests/net/lib.sh:...`).

- Small and contained: Only modifies
  `tools/testing/selftests/net/traceroute.sh`. No in‑kernel code or
  interfaces change. Behavior of the tests themselves (what they check)
  remains the same; only the reporting/exit semantics are corrected and
  standardized.

- Minimal regression risk: Test-only change. Aligns with established
  kselftest patterns, improves reliability of test outcomes. Output
  format is standardized (e.g., “IPv6” casing), and failures now print a
  clear reason via `check_err`.

- Stable criteria fit:
  - Fixes an important usability bug in the test suite (exit status),
    which affects automated testing and validation workflows.
  - No new features or architectural changes; purely a correctness fix
    to selftests.
  - Touches a noncritical area (selftests), so risk is negligible.
  - Even though the commit message does not explicitly Cc stable,
    selftest fixes of this nature are commonly accepted to stabilize
    testing in stable trees.

Conclusion: Backporting improves CI fidelity for stable kernels with no
kernel runtime risk.

 tools/testing/selftests/net/traceroute.sh | 38 ++++++-----------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/net/traceroute.sh b/tools/testing/selftests/net/traceroute.sh
index b50e52afa4f49..1ac91eebd16f5 100755
--- a/tools/testing/selftests/net/traceroute.sh
+++ b/tools/testing/selftests/net/traceroute.sh
@@ -10,28 +10,6 @@ PAUSE_ON_FAIL=no
 
 ################################################################################
 #
-log_test()
-{
-	local rc=$1
-	local expected=$2
-	local msg="$3"
-
-	if [ ${rc} -eq ${expected} ]; then
-		printf "TEST: %-60s  [ OK ]\n" "${msg}"
-		nsuccess=$((nsuccess+1))
-	else
-		ret=1
-		nfail=$((nfail+1))
-		printf "TEST: %-60s  [FAIL]\n" "${msg}"
-		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
-			echo
-			echo "hit enter to continue, 'q' to quit"
-			read a
-			[ "$a" = "q" ] && exit 1
-		fi
-	fi
-}
-
 run_cmd()
 {
 	local ns
@@ -205,9 +183,12 @@ run_traceroute6()
 {
 	setup_traceroute6
 
+	RET=0
+
 	# traceroute6 host-2 from host-1 (expects 2000:102::2)
 	run_cmd $h1 "traceroute6 2000:103::4 | grep -q 2000:102::2"
-	log_test $? 0 "IPV6 traceroute"
+	check_err $? "traceroute6 did not return 2000:102::2"
+	log_test "IPv6 traceroute"
 
 	cleanup_traceroute6
 }
@@ -265,9 +246,12 @@ run_traceroute()
 {
 	setup_traceroute
 
+	RET=0
+
 	# traceroute host-2 from host-1 (expects 1.0.1.1). Takes a while.
 	run_cmd $h1 "traceroute 1.0.2.4 | grep -q 1.0.1.1"
-	log_test $? 0 "IPV4 traceroute"
+	check_err $? "traceroute did not return 1.0.1.1"
+	log_test "IPv4 traceroute"
 
 	cleanup_traceroute
 }
@@ -284,9 +268,6 @@ run_tests()
 ################################################################################
 # main
 
-declare -i nfail=0
-declare -i nsuccess=0
-
 while getopts :pv o
 do
 	case $o in
@@ -301,5 +282,4 @@ require_command traceroute
 
 run_tests
 
-printf "\nTests passed: %3d\n" ${nsuccess}
-printf "Tests failed: %3d\n"   ${nfail}
+exit "${EXIT_STATUS}"
-- 
2.51.0

