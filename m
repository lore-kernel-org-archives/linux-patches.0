Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAC320A5E5;
	Fri, 17 Oct 2025 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714963; cv=none; b=JS5PgQjLjBaoRd8LUOydYYjDJwGPRXAw13AmWg1AOb7R4mHEKRhQ3LSh+FzJV8r8i43193s5SdNbJxcBOxZ0D0QteLsN89P/A3F2QM4Uy3InSAlGbAmSWRLdJkAM3YuhCV/z40gjF+EYyxISPTLZoaXU/sM/Jv0rHJUz0T7gTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714963; c=relaxed/simple;
	bh=q+9UjL2QzOa0SB77uyAPrLANhdob7kUwwi3oNv+gD7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XM3saD42s40VnNuUNpt76TyPwfkPZhrv2sYhCAfk/qVZP/C5cuNDpg1ME8v22E6iD75QrJV/2q0elcvvabdC0N+aCcZgv5hcE1ldPUVZ8VBKzkrVT2Duocgv/41MnM6kOSbC54vKMbabTWeyF9MU1UmX1ftp5dMDwJfhJMwYnnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFeowqdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFeowqdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED8BC4CEE7;
	Fri, 17 Oct 2025 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714962;
	bh=q+9UjL2QzOa0SB77uyAPrLANhdob7kUwwi3oNv+gD7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFeowqdMKlInXUMNdoAt0Ii9uwpKjoL3eFRA4lLuTlBOD+aZQMIvy4B6E7kZxYKod
	 KceAKwFEoQ8Xy7/Q9FxX7N64itV/qTq6briOxA7dauk1NG4Whj9J0WiryPEA5uo2Vn
	 edQQbDz13TaZIi4vCMIVan0Itu2NWU7/zb4tmHAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/371] perf test: Avoid uncore_imc/clockticks in uniquification test
Date: Fri, 17 Oct 2025 16:50:23 +0200
Message-ID: <20251017145203.538840350@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit edaeb4bcf1511fe4e464fff9dd4a3abf6b0096da ]

The detection of uncore_imc may happen for free running PMUs and the
clockticks event may be present on uncore_clock. Rewrite the test to
detect duplicated/deduplicated events from perf list, not hardcoded to
uncore_imc.

If perf stat fails then assume it is permissions and skip the test.

Committer testing:

Before:

  root@x1:~# perf test -vv uniquifyi
   96: perf stat events uniquifying:
  --- start ---
  test child forked, pid 220851
  stat event uniquifying test
  grep: Unmatched [, [^, [:, [., or [=
  Event is not uniquified [Failed]
  perf stat -e clockticks -A -o /tmp/__perf_test.stat_output.X7ChD -- true
  # started on Fri Sep 19 16:48:38 2025

   Performance counter stats for 'system wide':

  CPU0            2,310,956      uncore_clock/clockticks/

         0.001746771 seconds time elapsed

  ---- end(-1) ----
   96: perf stat events uniquifying                                    : FAILED!
  root@x1:~#

After:

  root@x1:~# perf test -vv uniquifyi
   96: perf stat events uniquifying:
  --- start ---
  test child forked, pid 222366
  Uniquification of PMU sysfs events test
  Testing event uncore_imc_free_running/data_read/ is uniquified to uncore_imc_free_running_0/data_read/
  Testing event uncore_imc_free_running/data_total/ is uniquified to uncore_imc_free_running_0/data_total/
  Testing event uncore_imc_free_running/data_write/ is uniquified to uncore_imc_free_running_0/data_write/
  Testing event uncore_imc_free_running/data_read/ is uniquified to uncore_imc_free_running_1/data_read/
  Testing event uncore_imc_free_running/data_total/ is uniquified to uncore_imc_free_running_1/data_total/
  Testing event uncore_imc_free_running/data_write/ is uniquified to uncore_imc_free_running_1/data_write/
  ---- end(0) ----
   96: perf stat events uniquifying                                    : Ok
  root@x1:~#

Fixes: 070b315333ee942f ("perf test: Restrict uniquifying test to machines with 'uncore_imc'")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../tests/shell/stat+event_uniquifying.sh     | 109 ++++++++----------
 1 file changed, 49 insertions(+), 60 deletions(-)

diff --git a/tools/perf/tests/shell/stat+event_uniquifying.sh b/tools/perf/tests/shell/stat+event_uniquifying.sh
index bf54bd6c3e2e6..b5dec6b6da369 100755
--- a/tools/perf/tests/shell/stat+event_uniquifying.sh
+++ b/tools/perf/tests/shell/stat+event_uniquifying.sh
@@ -4,74 +4,63 @@
 
 set -e
 
-stat_output=$(mktemp /tmp/__perf_test.stat_output.XXXXX)
-perf_tool=perf
 err=0
+stat_output=$(mktemp /tmp/__perf_test.stat_output.XXXXX)
 
-test_event_uniquifying() {
-  # We use `clockticks` in `uncore_imc` to verify the uniquify behavior.
-  pmu="uncore_imc"
-  event="clockticks"
-
-  # If the `-A` option is added, the event should be uniquified.
-  #
-  # $perf list -v clockticks
-  #
-  # List of pre-defined events (to be used in -e or -M):
-  #
-  #   uncore_imc_0/clockticks/                           [Kernel PMU event]
-  #   uncore_imc_1/clockticks/                           [Kernel PMU event]
-  #   uncore_imc_2/clockticks/                           [Kernel PMU event]
-  #   uncore_imc_3/clockticks/                           [Kernel PMU event]
-  #   uncore_imc_4/clockticks/                           [Kernel PMU event]
-  #   uncore_imc_5/clockticks/                           [Kernel PMU event]
-  #
-  #   ...
-  #
-  # $perf stat -e clockticks -A -- true
-  #
-  #  Performance counter stats for 'system wide':
-  #
-  # CPU0            3,773,018      uncore_imc_0/clockticks/
-  # CPU0            3,609,025      uncore_imc_1/clockticks/
-  # CPU0                    0      uncore_imc_2/clockticks/
-  # CPU0            3,230,009      uncore_imc_3/clockticks/
-  # CPU0            3,049,897      uncore_imc_4/clockticks/
-  # CPU0                    0      uncore_imc_5/clockticks/
-  #
-  #        0.002029828 seconds time elapsed
-
-  echo "stat event uniquifying test"
-  uniquified_event_array=()
+cleanup() {
+  rm -f "${stat_output}"
 
-  # Skip if the machine does not have `uncore_imc` device.
-  if ! ${perf_tool} list pmu | grep -q ${pmu}; then
-    echo "Target does not support PMU ${pmu} [Skipped]"
-    err=2
-    return
-  fi
+  trap - EXIT TERM INT
+}
 
-  # Check how many uniquified events.
-  while IFS= read -r line; do
-    uniquified_event=$(echo "$line" | awk '{print $1}')
-    uniquified_event_array+=("${uniquified_event}")
-  done < <(${perf_tool} list -v ${event} | grep ${pmu})
+trap_cleanup() {
+  echo "Unexpected signal in ${FUNCNAME[1]}"
+  cleanup
+  exit 1
+}
+trap trap_cleanup EXIT TERM INT
 
-  perf_command="${perf_tool} stat -e $event -A -o ${stat_output} -- true"
-  $perf_command
+test_event_uniquifying() {
+  echo "Uniquification of PMU sysfs events test"
 
-  # Check the output contains all uniquified events.
-  for uniquified_event in "${uniquified_event_array[@]}"; do
-    if ! cat "${stat_output}" | grep -q "${uniquified_event}"; then
-      echo "Event is not uniquified [Failed]"
-      echo "${perf_command}"
-      cat "${stat_output}"
-      err=1
-      break
-    fi
+  # Read events from perf list with and without -v. With -v the duplicate PMUs
+  # aren't deduplicated. Note, json events are listed by perf list without a
+  # PMU.
+  read -ra pmu_events <<< "$(perf list --raw pmu)"
+  read -ra pmu_v_events <<< "$(perf list -v --raw pmu)"
+  # For all non-deduplicated events.
+  for pmu_v_event in "${pmu_v_events[@]}"; do
+    # If the event matches an event in the deduplicated events then it musn't
+    # be an event with duplicate PMUs, continue the outer loop.
+    for pmu_event in "${pmu_events[@]}"; do
+      if [[ "$pmu_v_event" == "$pmu_event" ]]; then
+        continue 2
+      fi
+    done
+    # Strip the suffix from the non-deduplicated event's PMU.
+    event=$(echo "$pmu_v_event" | sed -E 's/_[0-9]+//')
+    for pmu_event in "${pmu_events[@]}"; do
+      if [[ "$event" == "$pmu_event" ]]; then
+        echo "Testing event ${event} is uniquified to ${pmu_v_event}"
+        if ! perf stat -e "$event" -A -o ${stat_output} -- true; then
+          echo "Error running perf stat for event '$event'  [Skip]"
+          if [ $err = 0 ]; then
+            err=2
+          fi
+          continue
+        fi
+        # Ensure the non-deduplicated event appears in the output.
+        if ! grep -q "${pmu_v_event}" "${stat_output}"; then
+          echo "Uniquification of PMU sysfs events test [Failed]"
+          cat "${stat_output}"
+          err=1
+        fi
+        break
+      fi
+    done
   done
 }
 
 test_event_uniquifying
-rm -f "${stat_output}"
+cleanup
 exit $err
-- 
2.51.0



