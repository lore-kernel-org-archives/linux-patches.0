Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A233DD51A;
	Sat, 12 Sep 2026 12:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214561; cv=none; b=crrTsdI0WoFx+ThkSVUJRm1rC5Hk9THFktyyW7pMwhSZfTsuLANTN4kCWKIrkEfnceJ7/Bc2nyumvWrpHy/uStrRAZCuPQCoWa02FZfwQMOckLRAQKd7Z0xOw9Op6pnz+MdQFZ3E50c1eIPB/4aYYQpo3XI1Jx74oi9/hlEo8xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214561; c=relaxed/simple;
	bh=cKRz99QBJiVE+NQJlRTMELYtQy7HwBETxQQkQlEWM0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs/+DcFHf7uD+GTQZ6Xwsco7Ig1NvfPQxc3wPpkof5+HAzKDFwUHeLKs3MR0Ll2bwbrplCrWEqEKIGf06WO5sY3um/eAAEHyXo8Vf9dcWuh44bZzVeslbkatdI/IP4ZBX0+zB/cfMTm0ZCkPKxt3cWwsPAOrFvIItL0fGcyInWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gD/xMDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gD/xMDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E401F000FF;
	Sat, 12 Sep 2026 12:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214560;
	bh=qnISGUZsokuPW6b+mFitCl/MRtteSa4en2d3z2zyiQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gD/xMDy5TMEJYxPFLrY+JYIzr4Hv+3P2u7u+an1s7QLj6tvKJgKwxUuosPE1H/6z
	 iewEAfUAyH9iZGfE862PBvuL8P8UrXSS0GOAPM55Lii+yaPXq1p3v9FuDiBAXUQmes
	 YoU4ZGdihFOvKvSawevgoGzTA4j4SOZWWrzXdaok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0351/1376] perf test: Update all metrics test like metricgroups test
Date: Sat, 12 Sep 2026 08:46:17 +0200
Message-ID: <20260912065615.374790442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



