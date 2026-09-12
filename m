Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A136340298;
	Sat, 12 Sep 2026 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222482; cv=none; b=AYWhyhARWLPQor/pTzCchoSBmEhlqpLsJYt314mlhVwqMpV99jk4ApO1+/S8EMibLBBmeo0xKOSv+bvD5rXHpm/wj4n18IaXIeLd9ukrSw6bOGsJmg45WpIC2zMLkTkja12WlHRdKdN3StXQltzszGCsRXxbEH6KD2eCumRY0+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222482; c=relaxed/simple;
	bh=xi61jsjv86zmM0OalwLKUwLwFj9KrmOeWF8e1MtJFag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1mLfXctH63KZ8+taTqdx91tJnHydzCxmNSp9P8dYxX+z+WY3JHpSlT93/pxsdll8cQ+b7q0s6OPO76eZZYYdUKKIZ4m9S14gFrFncnGPM492vMFI5fv/pXlg7vcD7snsgqZ95KG87avcwYhRoH4NAGlsG/wS+5Ecf6PGV28qJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZFQYV25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZFQYV25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F091F1F000FF;
	Sat, 12 Sep 2026 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222480;
	bh=fq4EwNswMv33YRtuwFVkFMI6U3jn00rr+Y1FmDbTM18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZFQYV25/3Tqt7pbmCeIA3xxwUbvCdS+I9FEo+vAqyDlb/YwfH9D4siVebBVMnjd8
	 nAB1Kv2J2EWJOXEcYYrWuqZYdAVgsRkJIJhtg8fP1AWbr84y/xOwoK+6mG6JoeRJrf
	 y84ShRT2gtb0uFK0WaMBvvC56XBX92zeUxSCzGGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0596/1424] perf test: Update all metrics test like metricgroups test
Date: Sat, 12 Sep 2026 08:50:28 +0200
Message-ID: <20260912065620.639273506@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit e2cb1db7daf8b7863aeec07bb574d3fae54518e6 ]

Like in the metricgroup tests, it should check the permission first and
then skip relevant failures accordingly.

Also it needs to try again with the system wide flag properly.  On the
second round, check if the result has the metric name because other
failure cases are checked in the first round already.

Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20241018204306.741972-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 8953bfd8820b ("perf tests: Skip metrics validation if system-wide recording lacks permission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_metrics.sh | 87 ++++++++++++++++------
 1 file changed, 66 insertions(+), 21 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index 54774525e18a7..73e9347e88a96 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -2,42 +2,87 @@
 # perf all metrics test
 # SPDX-License-Identifier: GPL-2.0
 
+ParanoidAndNotRoot()
+{
+  [ "$(id -u)" != 0 ] && [ "$(cat /proc/sys/kernel/perf_event_paranoid)" -gt $1 ]
+}
+
+system_wide_flag="-a"
+if ParanoidAndNotRoot 0
+then
+  system_wide_flag=""
+fi
+
 err=0
 for m in $(perf list --raw-dump metrics); do
   echo "Testing $m"
-  result=$(perf stat -M "$m" true 2>&1)
-  if [[ "$result" =~ ${m:0:50} ]] || [[ "$result" =~ "<not supported>" ]]
+  result=$(perf stat -M "$m" $system_wide_flag -- sleep 0.01 2>&1)
+  result_err=$?
+  if [[ $result_err -gt 0 ]]
   then
-    continue
+    if [[ "$result" =~ \
+          "Access to performance monitoring and observability operations is limited" ]]
+    then
+      echo "Permission failure"
+      echo $result
+      if [[ $err -eq 0 ]]
+      then
+        err=2 # Skip
+      fi
+      continue
+    elif [[ "$result" =~ "in per-thread mode, enable system wide" ]]
+    then
+      echo "Permissions - need system wide mode"
+      echo $result
+      if [[ $err -eq 0 ]]
+      then
+        err=2 # Skip
+      fi
+      continue
+    elif [[ "$result" =~ "<not supported>" ]]
+    then
+      echo "Not supported events"
+      echo $result
+      if [[ $err -eq 0 ]]
+      then
+        err=2 # Skip
+      fi
+      continue
+    elif [[ "$result" =~ "FP_ARITH" || "$result" =~ "AMX" ]]
+    then
+      echo "FP issues"
+      echo $result
+      if [[ $err -eq 0 ]]
+      then
+        err=2 # Skip
+      fi
+      continue
+    elif [[ "$result" =~ "PMM" ]]
+    then
+      echo "Optane memory issues"
+      echo $result
+      if [[ $err -eq 0 ]]
+      then
+        err=2 # Skip
+      fi
+      continue
+    fi
   fi
-  # Failed so try system wide.
-  result=$(perf stat -M "$m" -a sleep 0.01 2>&1)
+
   if [[ "$result" =~ ${m:0:50} ]]
   then
     continue
   fi
-  # Failed again, possibly the workload was too small so retry with something
-  # longer.
-  result=$(perf stat -M "$m" perf bench internals synthesize 2>&1)
+
+  # Failed, possibly the workload was too small so retry with something longer.
+  result=$(perf stat -M "$m" $system_wide_flag -- perf bench internals synthesize 2>&1)
   if [[ "$result" =~ ${m:0:50} ]]
   then
     continue
   fi
   echo "Metric '$m' not printed in:"
   echo "$result"
-  if [[ "$err" != "1" ]]
-  then
-    err=2
-    if [[ "$result" =~ "FP_ARITH" || "$result" =~ "AMX" ]]
-    then
-      echo "Skip, not fail, for FP issues"
-    elif [[ "$result" =~ "PMM" ]]
-    then
-      echo "Skip, not fail, for Optane memory issues"
-    else
-      err=1
-    fi
-  fi
+  err=1
 done
 
 exit "$err"
-- 
2.53.0



