Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8483330B19;
	Fri, 21 Nov 2025 13:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731225; cv=none; b=fU1Z0NLeNZ3wnI01XT37cuX7nZHDw4vOzdpEQ2xP2AYy+4FOwuGfA0CAoYgWm+iA4MFnKA5CgFY/u2ppo4qenRKUVl7CVHqxMzQn/Jn/jqL5BnYPgQ1dXg0Lx7IsDzXiWj1jNmFah9wkG82sAD2cLvmj5e9RPrv/cr5YU9VJfCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731225; c=relaxed/simple;
	bh=VMC9EZvkeDlkFfKed2bTUQfH570ndegETyNtIzg5E0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiTYVtifJ+uQ8y0XKktIDYdtgPrmwKOVZYMvY2AozmgCFXhN4jgT3gJq0ofCrG/0nP5lZpvesKlp4Rkjr1aIV2KhjqH9gcPPffyjo4941P5Mb3HTBCcuQwhi5O2tCdHeQ13iHuAnMOs/DP03++VKyNXW6zBySRj+rDNkEd6JsdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDdRVGJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDdRVGJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF51DC4CEF1;
	Fri, 21 Nov 2025 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731224;
	bh=VMC9EZvkeDlkFfKed2bTUQfH570ndegETyNtIzg5E0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDdRVGJGTROzQnWejwenO5VyjDydrNLCJjwgZFGcXiDMqcHFSpMZfVEPDWFu/pt5k
	 PZiwkIQl7zcnmsmMgQIAtz+RWWZaB/PO0I/mCb3LC0AalPV4PLAP0UwX5RRH0YCfji
	 1iH1EWjOO1na70kCOn1zQ3AC5p43RTHefA8HHbIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ananth Narayan <ananth.narayan@amd.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/247] perf test: Fix lock contention test
Date: Fri, 21 Nov 2025 14:11:21 +0100
Message-ID: <20251121130159.537433750@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 3c723f449723db2dc2b75b7efe03c2a76e4c09f0 ]

Couple of independent fixes:

1. Wire in SIGSEGV handler that terminates the test with a failure code.

2. Use "--lock-cgroup" instead of "-g"; "-g" was proposed but never
   merged. See commit 4d1792d0a2564caf ("perf lock contention: Add
   --lock-cgroup option")

3. Call cleanup() on every normal exit so trap_cleanup() doesn't mistake
   it for an unexpected signal and emit a false-negative "Unexpected
   signal in main" message.

Before patch:

  # ./perf test -vv "lock contention"
   85: kernel lock contention analysis test:
  --- start ---
  test child forked, pid 610711
  Testing perf lock record and perf lock contention
  Testing perf lock contention --use-bpf
  Testing perf lock record and perf lock contention at the same time
  Testing perf lock contention --threads
  Testing perf lock contention --lock-addr
  Testing perf lock contention --lock-cgroup
  Unexpected signal in test_aggr_cgroup
  ---- end(0) ----
   85: kernel lock contention analysis test                            : Ok

After patch:

  # ./perf test -vv "lock contention"
   85: kernel lock contention analysis test:
  --- start ---
  test child forked, pid 602637
  Testing perf lock record and perf lock contention
  Testing perf lock contention --use-bpf
  Testing perf lock record and perf lock contention at the same time
  Testing perf lock contention --threads
  Testing perf lock contention --lock-addr
  Testing perf lock contention --lock-cgroup
  Testing perf lock contention --type-filter (w/ spinlock)
  Testing perf lock contention --lock-filter (w/ tasklist_lock)
  Testing perf lock contention --callstack-filter (w/ unix_stream)
  [Skip] Could not find 'unix_stream'
  Testing perf lock contention --callstack-filter with task aggregation
  [Skip] Could not find 'unix_stream'
  Testing perf lock contention --cgroup-filter
  Testing perf lock contention CSV output
  ---- end(0) ----
   85: kernel lock contention analysis test                            : Ok

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ananth Narayan <ananth.narayan@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Santosh Shukla <santosh.shukla@amd.com>
Cc: Tycho Andersen <tycho@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/lock_contention.sh | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/shell/lock_contention.sh b/tools/perf/tests/shell/lock_contention.sh
index 7248a74ca2a32..6dd90519f45ce 100755
--- a/tools/perf/tests/shell/lock_contention.sh
+++ b/tools/perf/tests/shell/lock_contention.sh
@@ -13,15 +13,18 @@ cleanup() {
 	rm -f ${perfdata}
 	rm -f ${result}
 	rm -f ${errout}
-	trap - EXIT TERM INT
+	trap - EXIT TERM INT ERR
 }
 
 trap_cleanup() {
+	if (( $? == 139 )); then #SIGSEGV
+		err=1
+	fi
 	echo "Unexpected signal in ${FUNCNAME[1]}"
 	cleanup
 	exit ${err}
 }
-trap trap_cleanup EXIT TERM INT
+trap trap_cleanup EXIT TERM INT ERR
 
 check() {
 	if [ "$(id -u)" != 0 ]; then
@@ -145,7 +148,7 @@ test_aggr_cgroup()
 	fi
 
 	# the perf lock contention output goes to the stderr
-	perf lock con -a -b -g -E 1 -q -- perf bench sched messaging -p > /dev/null 2> ${result}
+	perf lock con -a -b --lock-cgroup -E 1 -q -- perf bench sched messaging -p > /dev/null 2> ${result}
 	if [ "$(cat "${result}" | wc -l)" != "1" ]; then
 		echo "[Fail] BPF result count is not 1:" "$(cat "${result}" | wc -l)"
 		err=1
@@ -271,7 +274,7 @@ test_cgroup_filter()
 		return
 	fi
 
-	perf lock con -a -b -g -E 1 -F wait_total -q -- perf bench sched messaging -p > /dev/null 2> ${result}
+	perf lock con -a -b --lock-cgroup -E 1 -F wait_total -q -- perf bench sched messaging -p > /dev/null 2> ${result}
 	if [ "$(cat "${result}" | wc -l)" != "1" ]; then
 		echo "[Fail] BPF result should have a cgroup result:" "$(cat "${result}")"
 		err=1
@@ -279,7 +282,7 @@ test_cgroup_filter()
 	fi
 
 	cgroup=$(cat "${result}" | awk '{ print $3 }')
-	perf lock con -a -b -g -E 1 -G "${cgroup}" -q -- perf bench sched messaging -p > /dev/null 2> ${result}
+	perf lock con -a -b --lock-cgroup -E 1 -G "${cgroup}" -q -- perf bench sched messaging -p > /dev/null 2> ${result}
 	if [ "$(cat "${result}" | wc -l)" != "1" ]; then
 		echo "[Fail] BPF result should have a result with cgroup filter:" "$(cat "${cgroup}")"
 		err=1
@@ -338,4 +341,5 @@ test_aggr_task_stack_filter
 test_cgroup_filter
 test_csv_output
 
+cleanup
 exit ${err}
-- 
2.51.0



