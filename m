Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E41A33F5A7;
	Sat, 12 Sep 2026 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222515; cv=none; b=NO9QY5wSbnrxYS5N0RoVCMfhERN11vIIHoNrFk85QW2FxfSy3cg6r2fTGvbJ6zuQPmUbVzcz64OmRRUzKRqpA2WP2dajL7VM3d+miLeW8zlag/hF6UkXtTWWB5b7lZerKkcFNtjbvd8kaCpRmx+swOa2SHPyQlffOa4WDnLjpb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222515; c=relaxed/simple;
	bh=KBba4sFCpILRk1BzRYPzaU000niWBug2hdgAjUwjGwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwLqBXo2frSWJ4/DGSri87k1OQz+wWsM6w9BrBWR4hG3Q8UtBMdN3Oqun10nRgznNXZ4xvTUucA0Z1YuFzdWe8LQwHDwRJs3qjCPPg6Q7lwBhLBVyvlspKbtrAOR2w7xFjmt1ilFqQ2fmaK9b8/GpHwt58v1Ywf26pKGygD9sFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaWUYqQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaWUYqQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDB51F000FF;
	Sat, 12 Sep 2026 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222514;
	bh=6W+bhk3dQJmCJjR8Wn2214ewGiHUyI9nCE+HNs6a9+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaWUYqQuEsZThqiahcZnb0PbnEps+LTLBndPtynExxGY/FLXog1H9tnDNvow1W9Jd
	 e3A9BNKM4kAHGJK8cJRoUxWB+Jdc1VlPVNoORipPi23ygfmHbSZF7cF0qutOsNB4jS
	 bV5ja1co83f9Z5VTEUJ6+fwBcbd12y4SFi2QZXzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0602/1424] perf tests: Skip metrics validation if system-wide recording lacks permission
Date: Sat, 12 Sep 2026 08:50:34 +0200
Message-ID: <20260912065620.775890345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a2d235252183b..5f32340b224d1 100644
--- a/tools/perf/tests/shell/lib/perf_metric_validation.py
+++ b/tools/perf/tests/shell/lib/perf_metric_validation.py
@@ -378,10 +378,13 @@ class Validator:
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
index dc93f03a90e63..f3c77b1dd826e 100755
--- a/tools/perf/tests/shell/stat_metrics_values.sh
+++ b/tools/perf/tests/shell/stat_metrics_values.sh
@@ -14,6 +14,13 @@ fi
 
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



