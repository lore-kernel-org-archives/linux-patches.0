Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9133806C6;
	Sat, 12 Sep 2026 07:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197283; cv=none; b=eiFf9NO/u5ieCH2dzqUqGqzc7r/gduok4hIxBqqR/hgK/yyuoX04fLQwxjo+mMcT2CQzInRS2XaWYDTRvQZBaWhnWErspdpX5A/8CtD+nKCA2VYkPraZejj+OO77/3SFpmjdM2lJsiuwK5v4PnxMS77HCxlFb+/0vBxELEpm3Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197283; c=relaxed/simple;
	bh=opP0WG6pyg5I3st1m1pt2Y09Uu5tazd3QMC2tK72B1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6csBSUuGxw7kQO0KwTCk/6pxqpfyxbfQ+MAJseXACOAmy1JYFLrGDuhh66zM3xUa2uM4zhvwHuOet9c3W68T6lP5IGULUJ5x8xmW/xybq9LtXESxvfiWkfOtjyxdUkJGEHuJqzz2yLGNPLSP0kSmQU0tlSBjZVtGM91WE7OimM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K69yCdc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K69yCdc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507D91F000FF;
	Sat, 12 Sep 2026 07:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197281;
	bh=yFAIDZfJS5KPzGZRvEqg5B0tdf13BNaXEYSa5HJbYmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K69yCdc4+8Vkjf9J8/slcMcs0iO8nAsEOpPG54kqR66r/O9lxbkjYVFHMKAzw6NIK
	 176z1ydms9Q4TQQ5raYshUDL97E8TScYqr8OTgd4eQhs6+BaJfsFL3JzFEOtlooicz
	 fNPk81S7vpL20Ns+kTnE6JZSj8QpByFcwb45Ccm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0135/1815] perf tests: Add robust record retry helper and use subsecond workloads
Date: Sat, 12 Sep 2026 08:31:25 +0200
Message-ID: <20260912065652.185423272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 74dba58222f0d34cf8bd3eba1a6926e9654d4b6b ]

Introduce `perf_record_with_retry` and `perf_record_cleanup` in a shared
library `tests/shell/lib/perf_record.sh` to prevent record test failures
caused by transient recording or workload delays.

Update `record.sh`, `record_lbr.sh`, `pipe_test.sh`, `kvm.sh`, and
`stat_all_pfm.sh` to use this robust record retry logic. These tests now
start with very short durations (e.g. 0.01 seconds) and scale up if the
initial recording failed to capture samples, significantly improving test
execution speed on success while remaining resilient to slow systems.

Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 509a2b9a6e14 ("perf tests: Fix flakiness in trace record and replay test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/kvm.sh             |  61 +++++---
 tools/perf/tests/shell/lib/perf_record.sh |  53 +++++++
 tools/perf/tests/shell/pipe_test.sh       |   4 +-
 tools/perf/tests/shell/record.sh          | 173 +++++++++++-----------
 tools/perf/tests/shell/record_lbr.sh      |  50 +++++--
 5 files changed, 214 insertions(+), 127 deletions(-)
 create mode 100644 tools/perf/tests/shell/lib/perf_record.sh

diff --git a/tools/perf/tests/shell/kvm.sh b/tools/perf/tests/shell/kvm.sh
index f88e859025c42..a5396f8e6fe5c 100755
--- a/tools/perf/tests/shell/kvm.sh
+++ b/tools/perf/tests/shell/kvm.sh
@@ -39,17 +39,28 @@ skip() {
 test_kvm_stat() {
 	echo "Testing perf kvm stat"
 
-	echo "Recording kvm events for pid ${qemu_pid}..."
-	if ! perf kvm stat record -p "${qemu_pid}" -o "${perfdata}" sleep 1; then
-		echo "Failed to record kvm events"
-		err=1
-		return
-	fi
+	local duration
+	local success=false
+	for duration in 1 2 4 8; do
+		echo "Recording kvm events for pid ${qemu_pid} (duration ${duration}s)..."
+		rm -f "${perfdata}" "${perfdata}".old
+		if ! perf kvm stat record -p "${qemu_pid}" -o "${perfdata}" \
+			sleep ${duration} >/dev/null 2>&1; then
+			echo "perf kvm stat record failed, retrying..."
+			continue
+		fi
+
+		if [ -e "${perfdata}" ] && \
+			perf kvm -i "${perfdata}" stat report 2>&1 | grep -q "VM-EXIT"; then
+			success=true
+			break
+		fi
+		echo "No VM-EXIT events found, retrying..."
+	done
 
-	echo "Reporting kvm events..."
-	if ! perf kvm -i "${perfdata}" stat report 2>&1 | grep -q "VM-EXIT"; then
+	if [ "$success" = false ]; then
 		echo "Failed to find VM-EXIT in report"
-		perf kvm -i "${perfdata}" stat report 2>&1
+		perf kvm -i "${perfdata}" stat report 2>&1 || true
 		err=1
 		return
 	fi
@@ -60,22 +71,26 @@ test_kvm_stat() {
 test_kvm_record_report() {
 	echo "Testing perf kvm record/report"
 
-	echo "Recording kvm profile for pid ${qemu_pid}..."
-	# Use --host to avoid needing guest symbols/mounts for this simple test
-	# We just want to verify the command runs and produces data
-	# We run in background and kill it because 'perf kvm record' appends options
-	# after the command, which breaks 'sleep' (e.g. it gets '-e cycles').
-	perf kvm --host record -p "${qemu_pid}" -o "${perfdata}" &
-	rec_pid=$!
-	sleep 1
-	kill -INT "${rec_pid}"
-	wait "${rec_pid}" || true
+	local duration
+	local success=false
+	for duration in 1 2 4 8; do
+		echo "Recording kvm profile for pid ${qemu_pid} (duration ${duration}s)..."
+		rm -f "${perfdata}" "${perfdata}".old
+
+		perf kvm --host record -p "${qemu_pid}" -o "${perfdata}" \
+			-e cpu-clock sleep ${duration}
+
+		if [ -e "${perfdata}" ] && \
+			perf kvm -i "${perfdata}" report --stdio 2>&1 | grep -q "Event count"; then
+			success=true
+			break
+		fi
+		echo "No samples or report failed, retrying..."
+	done
 
-	echo "Reporting kvm profile..."
-	# Check for some standard output from report
-	if ! perf kvm -i "${perfdata}" report --stdio 2>&1 | grep -q "Event count"; then
+	if [ "$success" = false ]; then
 		echo "Failed to report kvm profile"
-		perf kvm -i "${perfdata}" report --stdio 2>&1
+		perf kvm -i "${perfdata}" report --stdio 2>&1 || true
 		err=1
 		return
 	fi
diff --git a/tools/perf/tests/shell/lib/perf_record.sh b/tools/perf/tests/shell/lib/perf_record.sh
new file mode 100644
index 0000000000000..e137fa75370de
--- /dev/null
+++ b/tools/perf/tests/shell/lib/perf_record.sh
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: GPL-2.0
+
+PERF_RECORD_LOGS=()
+
+perf_record_with_retry() {
+  local perfdata="$1"
+  local check_cmd="$2"
+  local testprog_base="$3"
+  shift 3
+
+  local logfile
+  logfile=$(mktemp /tmp/__perf_record_retry.XXXXXX)
+  PERF_RECORD_LOGS+=("$logfile")
+
+  # Save the e flag state and disable it
+  local save_e
+  if [[ $- == *e* ]]; then
+    save_e="set -e"
+  else
+    save_e="set +e"
+  fi
+  set +e
+
+  local duration
+  local first_run=true
+  local ret=1
+  for duration in 0.01 0.1 0.3 1.0 2.0; do
+    rm -f "${perfdata}".old
+    perf record "$@" -o "${perfdata}" ${testprog_base} ${duration} > "$logfile" 2>&1
+    local record_exit=$?
+
+    if [ "$first_run" = true ] && [ $record_exit -ne 0 ]; then
+      ret=2
+      break
+    fi
+    first_run=false
+
+    if [ -e "${perfdata}" ] && eval "${check_cmd}"; then
+      ret=0
+      break
+    fi
+  done
+
+  eval "$save_e"
+  return $ret
+}
+
+perf_record_cleanup() {
+  for logfile in "${PERF_RECORD_LOGS[@]}"; do
+    rm -f "$logfile"
+  done
+  PERF_RECORD_LOGS=()
+}
diff --git a/tools/perf/tests/shell/pipe_test.sh b/tools/perf/tests/shell/pipe_test.sh
index e459aa99a9515..ce68d850c9838 100755
--- a/tools/perf/tests/shell/pipe_test.sh
+++ b/tools/perf/tests/shell/pipe_test.sh
@@ -12,8 +12,8 @@ skip_test_missing_symbol ${sym}
 
 data=$(mktemp /tmp/perf.data.XXXXXX)
 data2=$(mktemp /tmp/perf.data2.XXXXXX)
-prog="perf test -w noploop"
-[ "$(uname -m)" = "s390x" ] && prog="$prog 3"
+prog="perf test -w noploop 0.1"
+[ "$(uname -m)" = "s390x" ] && prog="perf test -w noploop 3"
 err=0
 
 set -e
diff --git a/tools/perf/tests/shell/record.sh b/tools/perf/tests/shell/record.sh
index 7cb81cf3444a7..dd90fef2088b1 100755
--- a/tools/perf/tests/shell/record.sh
+++ b/tools/perf/tests/shell/record.sh
@@ -1,10 +1,13 @@
 #!/bin/bash
-# perf record tests (exclusive)
 # SPDX-License-Identifier: GPL-2.0
+# perf record tests
 
 set -e
 
 shelldir=$(dirname "$0")
+. "${shelldir}"/lib/perf_record.sh
+
+
 # shellcheck source=lib/waiting.sh
 . "${shelldir}"/lib/waiting.sh
 
@@ -39,6 +42,7 @@ cleanup() {
   rm -f "${perfdata}"
   rm -f "${perfdata}".old
   rm -f "${script_output}"
+  perf_record_cleanup
 
   trap - EXIT TERM INT
 }
@@ -50,22 +54,20 @@ trap_cleanup() {
 }
 trap trap_cleanup EXIT TERM INT
 
+check_per_thread() {
+  perf report -i "${perfdata}" -q | grep -q "${testsym}"
+}
+
 test_per_thread() {
   echo "Basic --per-thread mode test"
-  if ! perf record -o /dev/null --quiet ${testprog} 2> /dev/null
-  then
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_per_thread" "perf test -w thloop" \
+    --per-thread || ret=$?
+  if [ $ret -eq 2 ]; then
     echo "Per-thread record [Skipped event not supported]"
     return
-  fi
-  if ! perf record --per-thread -o "${perfdata}" ${testprog} 2> /dev/null
-  then
-    echo "Per-thread record [Failed record]"
-    err=1
-    return
-  fi
-  if ! perf report -i "${perfdata}" -q | grep -q "${testsym}"
-  then
-    echo "Per-thread record [Failed missing output]"
+  elif [ $ret -eq 1 ]; then
+    echo "Per-thread record [Failed record or missing output]"
     err=1
     return
   fi
@@ -96,6 +98,10 @@ test_per_thread() {
   echo "Basic --per-thread mode test [Success]"
 }
 
+check_register_capture() {
+  perf script -F ip,sym,iregs -i "${perfdata}" 2>/dev/null | grep -q "DI:"
+}
+
 test_register_capture() {
   echo "Register capture test"
   if ! perf list pmu | grep -q 'br_inst_retired.near_call'
@@ -108,11 +114,12 @@ test_register_capture() {
     echo "Register capture test [Skipped missing registers]"
     return
   fi
-  if ! perf record -o - --intr-regs=di,r8,dx,cx -e br_inst_retired.near_call \
-    -c 1000 --per-thread ${testprog} 2> /dev/null \
-    | perf script -F ip,sym,iregs -i - 2> /dev/null \
-    | grep -q "DI:"
-  then
+
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_register_capture" "perf test -w thloop" \
+    --intr-regs=di,r8,dx,cx -e br_inst_retired.near_call -c 1000 --per-thread || ret=$?
+
+  if [ $ret -ne 0 ]; then
     echo "Register capture test [Failed missing output]"
     err=1
     return
@@ -120,65 +127,66 @@ test_register_capture() {
   echo "Register capture test [Success]"
 }
 
+check_system_wide() {
+  perf report -i "${perfdata}" -q | grep -q "${testsym}"
+}
+
 test_system_wide() {
   echo "Basic --system-wide mode test"
-  if ! perf record -aB --synth=no -o "${perfdata}" ${testprog} 2> /dev/null
-  then
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_system_wide" "perf test -w thloop" \
+    -aB --synth=no || ret=$?
+  if [ $ret -eq 2 ]; then
     echo "System-wide record [Skipped not supported]"
     return
-  fi
-  if ! perf report -i "${perfdata}" -q | grep -q "${testsym}"
-  then
+  elif [ $ret -eq 1 ]; then
     echo "System-wide record [Failed missing output]"
     err=1
     return
   fi
-  if ! perf record -aB --synth=no -e cpu-clock,cs --threads=cpu \
-    -o "${perfdata}" ${testprog} 2> /dev/null
-  then
-    echo "System-wide record [Failed record --threads option]"
-    err=1
-    return
-  fi
-  if ! perf report -i "${perfdata}" -q | grep -q "${testsym}"
-  then
-    echo "System-wide record [Failed --threads missing output]"
+
+  ret=0
+  perf_record_with_retry "${perfdata}" "check_system_wide" "perf test -w thloop" \
+    -aB --synth=no -e cpu-clock,cs --threads=cpu || ret=$?
+  if [ $ret -ne 0 ]; then
+    echo "System-wide record [Failed record --threads option or missing output]"
     err=1
     return
   fi
   echo "Basic --system-wide mode test [Success]"
 }
 
+check_workload() {
+  perf report -i "${perfdata}" -q | grep -q "${testsym}"
+}
+
 test_workload() {
   echo "Basic target workload test"
-  if ! perf record -o "${perfdata}" ${testprog} 2> /dev/null
-  then
-    echo "Workload record [Failed record]"
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_workload" "perf test -w thloop" || ret=$?
+  if [ $ret -ne 0 ]; then
+    echo "Workload record [Failed record or missing output]"
     err=1
     return
   fi
-  if ! perf report -i "${perfdata}" -q | grep -q "${testsym}"
-  then
-    echo "Workload record [Failed missing output]"
-    err=1
-    return
-  fi
-  if ! perf record -e cpu-clock,cs --threads=package \
-    -o "${perfdata}" ${testprog} 2> /dev/null
-  then
-    echo "Workload record [Failed record --threads option]"
-    err=1
-    return
-  fi
-  if ! perf report -i "${perfdata}" -q | grep -q "${testsym}"
-  then
-    echo "Workload record [Failed --threads missing output]"
+
+  ret=0
+  perf_record_with_retry "${perfdata}" "check_workload" "perf test -w thloop" \
+    -e cpu-clock,cs --threads=package || ret=$?
+  if [ $ret -ne 0 ]; then
+    echo "Workload record [Failed record --threads option or missing output]"
     err=1
     return
   fi
   echo "Basic target workload test [Success]"
 }
 
+check_branch_counter() {
+  perf report -i "${perfdata}" -D -q 2>/dev/null | grep -q "$br_cntr_output" && \
+  perf script -i "${perfdata}" -F +brstackinsn,+brcntr 2>/dev/null | \
+    grep -q "$br_cntr_script_output"
+}
+
 test_branch_counter() {
   echo "Branch counter test"
   # Check if the branch counter feature is supported
@@ -190,67 +198,60 @@ test_branch_counter() {
       return
     fi
   done
-  if ! perf record -o "${perfdata}" -e "{branches:p,instructions}" -j any,counter ${testprog} 2> /dev/null
-  then
-    echo "Branch counter record test [Failed record]"
-    err=1
-    return
-  fi
-  if ! perf report -i "${perfdata}" -D -q | grep -q "$br_cntr_output"
-  then
-    echo "Branch counter report test [Failed missing output]"
-    err=1
-    return
-  fi
-  if ! perf script -i "${perfdata}" -F +brstackinsn,+brcntr | grep -q "$br_cntr_script_output"
-  then
-    echo " Branch counter script test [Failed missing output]"
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_branch_counter" "perf test -w thloop" \
+    -e "{branches:p,instructions}" -j any,counter || ret=$?
+  if [ $ret -ne 0 ]; then
+    echo "Branch counter test [Failed record or missing output]"
     err=1
     return
   fi
   echo "Branch counter test [Success]"
 }
 
+check_cgroup() {
+  perf report -i "${perfdata}" -D 2>/dev/null | grep -q "CGROUP" && \
+  perf script -i "${perfdata}" -F cgroup 2>/dev/null | grep -q -v "unknown"
+}
+
 test_cgroup() {
   echo "Cgroup sampling test"
-  if ! perf record -aB --synth=cgroup --all-cgroups -o "${perfdata}" ${testprog} 2> /dev/null
-  then
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_cgroup" "perf test -w thloop" \
+    -aB --synth=cgroup --all-cgroups || ret=$?
+  if [ $ret -eq 2 ]; then
     echo "Cgroup sampling [Skipped not supported]"
     return
-  fi
-  if ! perf report -i "${perfdata}" -D | grep -q "CGROUP"
-  then
+  elif [ $ret -eq 1 ]; then
     echo "Cgroup sampling [Failed missing output]"
     err=1
     return
   fi
-  if ! perf script -i "${perfdata}" -F cgroup | grep -q -v "unknown"
-  then
-    echo "Cgroup sampling [Failed cannot resolve cgroup names]"
-    err=1
-    return
-  fi
   echo "Cgroup sampling test [Success]"
 }
 
+check_uid() {
+  perf report -i "${perfdata}" -q | grep -q "${testsym}"
+}
+
 test_uid() {
   echo "Uid sampling test"
-  if ! perf record -aB --synth=no --uid "$(id -u)" -o "${perfdata}" ${testprog} \
-    > "${script_output}" 2>&1
-  then
-    if grep -q "libbpf.*EPERM" "${script_output}"
+  local ret=0
+  perf_record_with_retry "${perfdata}" "check_uid" "perf test -w thloop" \
+    -aB --synth=no --uid "$(id -u)" || ret=$?
+  if [ $ret -eq 2 ]; then
+    local logfile="${PERF_RECORD_LOGS[${#PERF_RECORD_LOGS[@]}-1]}"
+    if grep -q -E "libbpf.*EPERM|Access to performance monitoring" "$logfile" || \
+       grep -q -E "Permission denied|Failure to open any events" "$logfile"
     then
       echo "Uid sampling [Skipped permissions]"
       return
     else
       echo "Uid sampling [Failed to record]"
       err=1
-      # cat "${script_output}"
       return
     fi
-  fi
-  if ! perf report -i "${perfdata}" -q | grep -q "${testsym}"
-  then
+  elif [ $ret -eq 1 ]; then
     echo "Uid sampling [Failed missing output]"
     err=1
     return
diff --git a/tools/perf/tests/shell/record_lbr.sh b/tools/perf/tests/shell/record_lbr.sh
index 78a02e90ece1e..8d51afeb437ba 100755
--- a/tools/perf/tests/shell/record_lbr.sh
+++ b/tools/perf/tests/shell/record_lbr.sh
@@ -1,9 +1,12 @@
 #!/bin/bash
-# perf record LBR tests (exclusive)
 # SPDX-License-Identifier: GPL-2.0
+# perf record LBR tests
 
 set -e
 
+shelldir=$(dirname "$0")
+. "${shelldir}"/lib/perf_record.sh
+
 ParanoidAndNotRoot() {
   [ "$(id -u)" != 0 ] && [ "$(cat /proc/sys/kernel/perf_event_paranoid)" -gt $1 ]
 }
@@ -22,6 +25,7 @@ cleanup() {
   rm -rf "${perfdata}"
   rm -rf "${perfdata}".old
   rm -rf "${perfdata}".txt
+  perf_record_cleanup
 
   trap - EXIT TERM INT
 }
@@ -34,22 +38,28 @@ trap_cleanup() {
 trap trap_cleanup EXIT TERM INT
 
 
+check_lbr_callgraph() {
+  perf report --stitch-lbr -i "${perfdata}" > "${perfdata}".txt 2>&1
+}
+
 lbr_callgraph_test() {
   test="LBR callgraph"
 
   echo "$test"
-  if ! perf record -e cycles --call-graph lbr -o "${perfdata}" perf test -w thloop
-  then
+  set +e
+  perf_record_with_retry "${perfdata}" "check_lbr_callgraph" "perf test -w thloop" \
+    -e cycles --call-graph lbr
+  local ret=$?
+  set -e
+
+  if [ $ret -eq 2 ]; then
     echo "$test [Failed support missing]"
     if [ $err -eq 0 ]
     then
       err=2
     fi
     return
-  fi
-
-  if ! perf report --stitch-lbr -i "${perfdata}" > "${perfdata}".txt
-  then
+  elif [ $ret -eq 1 ]; then
     cat "${perfdata}".txt
     echo "$test [Failed in perf report]"
     err=1
@@ -59,6 +69,12 @@ lbr_callgraph_test() {
   echo "$test [Success]"
 }
 
+check_lbr_samples() {
+  local out
+  out=$(perf report -D -i "${perfdata}" 2> /dev/null | grep -A1 'PERF_RECORD_SAMPLE')
+  [ "$(echo "$out" | grep -c 'PERF_RECORD_SAMPLE' || true)" -gt 0 ]
+}
+
 lbr_test() {
   local branch_flags=$1
   local test="LBR $2 test"
@@ -70,25 +86,27 @@ lbr_test() {
   local r
 
   echo "$test"
-  if ! perf record -e cycles $branch_flags -o "${perfdata}" perf test -w thloop
-  then
+  set +e
+  perf_record_with_retry "${perfdata}" "check_lbr_samples" "perf test -w thloop" \
+    -e cycles $branch_flags
+  local ret=$?
+  set -e
+
+  if [ $ret -eq 2 ]; then
     echo "$test [Failed support missing]"
-    perf record -e cycles $branch_flags -o "${perfdata}" perf test -w thloop || true
     if [ $err -eq 0 ]
     then
       err=2
     fi
     return
-  fi
-
-  out=$(perf report -D -i "${perfdata}" 2> /dev/null | grep -A1 'PERF_RECORD_SAMPLE')
-  sam_nr=$(echo "$out" | grep -c 'PERF_RECORD_SAMPLE' || true)
-  if [ $sam_nr -eq 0 ]
-  then
+  elif [ $ret -eq 1 ]; then
     echo "$test [Failed no samples captured]"
     err=1
     return
   fi
+
+  out=$(perf report -D -i "${perfdata}" 2> /dev/null | grep -A1 'PERF_RECORD_SAMPLE')
+  sam_nr=$(echo "$out" | grep -c 'PERF_RECORD_SAMPLE' || true)
   echo "$test: $sam_nr samples"
 
   bs_nr=$(echo "$out" | grep -c 'branch stack: nr:' || true)
-- 
2.53.0



