Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5283806C6;
	Sat, 12 Sep 2026 07:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197259; cv=none; b=T/0KgzTz4WZQ6+tOMIqLEVWaEaURUwKcMOkf/tcOxF2YquPd7yi6vUTDbIBDiOLb0E1ZfVrDqjS0NzfP5NwnTRnjgXBWlaVzsexR9BUKkgmcdm0zoIBT1+6T9mrs5dieuz5N8aZieu9DIGSd6oJtwGjonvk4Abtu5qGhK1I5qyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197259; c=relaxed/simple;
	bh=E3NPcbw3IWHlWHf+BJTs9Q2bksx1UX+FbmW1cYPDCcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcM8S0MLlXmQl1xzzpJQV4XvfeY01UBRopAPjnlY/DtIzKoUICkJZIMS3GJhl8Fr7jY9S88+IHhGyk0Y/WeX0AySZKpOk0woY1uyblWobKJsqx0R6nEmGjhESxgaKy39VZrEQCabmH9136NMorWj7j6e45xplMLH8asko3RQvQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dENJmJwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dENJmJwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D7A1F000FF;
	Sat, 12 Sep 2026 07:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197257;
	bh=gTheaOAY8PVcEmGRC+9kJvOkLUOMvKH6LIDeIuzYJH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dENJmJwUbcmT4otkDbbJLmw1b8Dkb9cEtGF/fSSycyWvHKv3T7GG9O6qWV/n9LM1x
	 BQxhrwnpJItYnmYhgzuEInI/YEWvB+Nx123ycTd5BhyKrkR/oWwr9J2HPza7RPxypa
	 xOJGisuZS3U3q6PYYjHPE7Xv/F2xKUWC0Re5Xsw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0133/1815] perf tests: Skip metrics validation if system-wide recording lacks permission
Date: Sat, 12 Sep 2026 08:31:23 +0200
Message-ID: <20260912065652.140809517@linuxfoundation.org>
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

[ Upstream commit 8953bfd8820b6525032023fda3a420098c1823ae ]

The metrics value validation test requires system-wide recording (`-a`),
which can fail on systems without root permissions or where paranoid
levels restrict tracing. Add a check to skip the test if `-a` is not
supported.

Also fix false negatives during validation by updating parse error string
patterns and resolving issues in metric list generation.

Fixes: 3ad7092f5145 ("perf test: Add metric value validation test")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../tests/shell/lib/perf_metric_validation.py | 11 ++-
 tools/perf/tests/shell/stat_all_metrics.sh    | 75 ++++++++++++-------
 tools/perf/tests/shell/stat_metrics_values.sh |  7 ++
 3 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/tools/perf/tests/shell/lib/perf_metric_validation.py b/tools/perf/tests/shell/lib/perf_metric_validation.py
index dea8ef1977bf6..3d52f94f22b91 100644
--- a/tools/perf/tests/shell/lib/perf_metric_validation.py
+++ b/tools/perf/tests/shell/lib/perf_metric_validation.py
@@ -383,10 +383,13 @@ class Validator:
         wl = workload.split()
         command.extend(wl)
         print(" ".join(command))
-        cmd = subprocess.run(command, stderr=subprocess.PIPE, encoding='utf-8')
-        data = [x+'}' for x in cmd.stderr.split('}\n') if x]
-        if data[0][0] != '{':
-            data[0] = data[0][data[0].find('{'):]
+        cmd = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
+        lines = cmd.stderr.splitlines() + cmd.stdout.splitlines()
+        data = []
+        for line in lines:
+            line = line.strip()
+            if line.startswith('{') and line.endswith('}'):
+                data.append(line)
         return data
 
     def collect_perf(self, workload: str):
diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index b582d23f28c9e..feeb34c6fa6df 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -12,38 +12,65 @@ system_wide_flag="-a"
 if ParanoidAndNotRoot 0
 then
   system_wide_flag=""
-  test_prog="perf test -w noploop"
+  test_prog="perf test -w noploop 0.01"
 fi
 
+check_metric() {
+  local output="$1"
+  local status="$2"
+  local metric="$3"
+
+  if [[ $status -ne 0 || ! "$output" =~ ${metric:0:50} ]]; then
+    return 1
+  fi
+
+  if [[ "$output" =~ "<not counted>" || "$output" =~ "<not supported>" ]]; then
+    return 1
+  fi
+
+  return 0
+}
+
 skip=0
 err=3
 for m in $(perf list --raw-dump metrics); do
   echo "Testing $m"
   result=$(perf stat -M "$m" $system_wide_flag -- $test_prog 2>&1)
   result_err=$?
-  if [[ $result_err -eq 0 && "$result" =~ ${m:0:50} ]]
-  then
-    # No error result and metric shown.
+
+  if check_metric "$result" $result_err "$m"; then
     if [[ "$err" -ne 1 ]]
     then
       err=0
     fi
     continue
   fi
-  if [[ "$result" =~ "Cannot resolve IDs for" || "$result" =~ "No supported events found" ]]
+
+  if [[ "$result" =~ "Access to performance monitoring and observability operations is limited" || \
+        "$result" =~ "in per-thread mode, enable system wide" || \
+        "$result" =~ "<not supported>" || \
+        "$result" =~ "Cannot resolve IDs for" || \
+        "$result" =~ "No supported events found" || \
+        "$result" =~ "FP_ARITH" || \
+        "$result" =~ "AMX" || \
+        "$result" =~ "PMM" ]]
   then
-    if [[ $(perf list --raw-dump $m) == "Default"* ]]
-    then
-      echo "[Ignored $m] failed but as a Default metric this can be expected"
-      echo $result
+    true
+  else
+    result=$(perf stat -M "$m" $system_wide_flag -- perf test -w noploop 0.1 2>&1)
+    result_err=$?
+
+    if check_metric "$result" $result_err "$m"; then
+      if [[ "$err" -ne 1 ]]
+      then
+        err=0
+      fi
       continue
     fi
-    echo "[Failed $m] Metric contains missing events"
-    echo $result
-    err=1 # Fail
-    continue
-  elif [[ "$result" =~ \
-        "Access to performance monitoring and observability operations is limited" ]]
+  fi
+
+  # If retry also failed, determine if we skip, ignore, or fail
+  if [[ "$result" =~ "Access to performance monitoring and observability operations is limited" ]]
   then
     echo "[Skipped $m] Permission failure"
     echo $result
@@ -61,7 +88,9 @@ for m in $(perf list --raw-dump metrics); do
       skip=1
     fi
     continue
-  elif [[ "$result" =~ "<not supported>" ]]
+  elif [[ "$result" =~ "<not supported>" || \
+          "$result" =~ "Cannot resolve IDs for" || \
+          "$result" =~ "No supported events found" ]]
   then
     if [[ $(perf list --raw-dump $m) == "Default"* ]]
     then
@@ -105,19 +134,7 @@ for m in $(perf list --raw-dump metrics); do
     continue
   fi
 
-  # Failed, possibly the workload was too small so retry with something longer.
-  result=$(perf stat -M "$m" $system_wide_flag -- perf bench internals synthesize 2>&1)
-  result_err=$?
-  if [[ $result_err -eq 0 && "$result" =~ ${m:0:50} ]]
-  then
-    # No error result and metric shown.
-    if [[ "$err" -ne 1 ]]
-    then
-      err=0
-    fi
-    continue
-  fi
-  echo "[Failed $m] has non-zero error '$result_err' or not printed in:"
+  echo "[Failed $m] has non-zero error '$result_err' or not printed/counted in:"
   echo "$result"
   err=1
 done
diff --git a/tools/perf/tests/shell/stat_metrics_values.sh b/tools/perf/tests/shell/stat_metrics_values.sh
index 30566f0b54279..76f1e99d1273f 100755
--- a/tools/perf/tests/shell/stat_metrics_values.sh
+++ b/tools/perf/tests/shell/stat_metrics_values.sh
@@ -8,6 +8,13 @@ shelldir=$(dirname "$0")
 
 grep -q GenuineIntel /proc/cpuinfo || { echo Skipping non-Intel; exit 2; }
 
+# Skip if no permission to record system-wide events
+if ! perf stat -a -e instructions sleep 0.01 >/dev/null 2>&1; then
+  echo "Skipping: no permission to record system-wide events (-a)"
+  exit 2
+fi
+
+
 pythonvalidator=$(dirname $0)/lib/perf_metric_validation.py
 rulefile=$(dirname $0)/lib/perf_metric_validation_rules.json
 tmpdir=$(mktemp -d /tmp/__perf_test.program.XXXXX)
-- 
2.53.0



