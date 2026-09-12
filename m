Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CA31DE4EF;
	Sat, 12 Sep 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222500; cv=none; b=MA7MLbiPXD0pr6eqp3HNsTk26gNtSjdr4maDZRKsKHv6sRBLMkm/Oo4q5WWtHsNps+Ak9Jekt6QBSdZj3WDLGq4YU20Vetvdg6uGn5lAUYGI4O1T/zSWFgjZRr7Ec+EezC8tRGIX4tgnfjZ4Rt6Bwi8MXCh3AOu9Cj4cg5tmQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222500; c=relaxed/simple;
	bh=+zcEN06PFHV0YOVbHP6AQZnZVJ+lQOn8IKnsxZ5suqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua0LdpcrorAXMX6hYOo/YIXormrDbsiiGXmdyAAybB2lU+CVJoNXwv5LsK6EnIW91GjeHjdgoiXOiKXztkne3CvBbepu0BQLED5HR3FKN0nWfZIY2z8WEczHQQhRTWW42eCoN5mDL4xigt4jXlAumoPuI2LNWjAtBfLeJQ+Wbag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtRB+ylh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtRB+ylh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC401F000FF;
	Sat, 12 Sep 2026 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222499;
	bh=EA1ZpdCsDrzNdx1t0rQ348CGADCgOQkNL5JOP4fyIus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtRB+ylhsETHy410wmpuKrpl6yRAGh7c2iHOUsG3XOxMbkAA3foyDomnarjfma5mR
	 SlRTOmNN0f/pKf6EpQ5tYJtzuks86jvlRuHsD2qfGO4pdqfKrjf1s8rkcAEiEqIIRf
	 U1V+P0uu44wxT83pMk5+KUMtIKhmuE+IxXXJ5EgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0600/1424] perf test all metrics: Fully ignore Default metric failures
Date: Sat, 12 Sep 2026 08:50:32 +0200
Message-ID: <20260912065620.729494036@linuxfoundation.org>
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

[ Upstream commit 41b67ab3d2f5be9d0b6e5ba9cbec97c820fc50e8 ]

Determine if a metric is default from `perf list --raw-dump $m` eg:
```
$ perf list --raw-dump l1_prefetch_miss_rate
Default4 l1_prefetch_miss_rate
```
If a metric has "not supported" or "no supported events" then ignore
these failures for default metrics. Tidy up the skip/fail messages in
the output to make them easier to spot/read.

```
$ perf list -vv "all metrics"
...
Testing llc_miss_rate
[Ignored llc_miss_rate] failed but as a Default metric this can be expected
Error: No supported events found. The LLC-loads event is not supported.
...
```

Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Closes: https://lore.kernel.org/linux-perf-users/20251119104751.51960-1-tmricht@linux.ibm.com/
Reported-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: James Clark <james.clark@linaro.org>
Closes: https://lore.kernel.org/lkml/aRi9xnwdLh3Dir9f@google.com/
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 8953bfd8820b ("perf tests: Skip metrics validation if system-wide recording lacks permission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_metrics.sh | 27 ++++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index a7edf01b39433..3dabb39c7cc8c 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -27,19 +27,20 @@ for m in $(perf list --raw-dump metrics); do
   fi
   if [[ "$result" =~ "Cannot resolve IDs for" || "$result" =~ "No supported events found" ]]
   then
-    if [[ "$m" == @(l1_prefetch_miss_rate|stalled_cycles_per_instruction) ]]
+    if [[ $(perf list --raw-dump $m) == "Default"* ]]
     then
-      # Default metrics that may use unsupported events.
+      echo "[Ignored $m] failed but as a Default metric this can be expected"
+      echo $result
       continue
     fi
-    echo "Metric contains missing events"
+    echo "[Failed $m] Metric contains missing events"
     echo $result
     err=1 # Fail
     continue
   elif [[ "$result" =~ \
         "Access to performance monitoring and observability operations is limited" ]]
   then
-    echo "Permission failure"
+    echo "[Skipped $m] Permission failure"
     echo $result
     if [[ $err -eq 0 ]]
     then
@@ -48,7 +49,7 @@ for m in $(perf list --raw-dump metrics); do
     continue
   elif [[ "$result" =~ "in per-thread mode, enable system wide" ]]
   then
-    echo "Permissions - need system wide mode"
+    echo "[Skipped $m] Permissions - need system wide mode"
     echo $result
     if [[ $err -eq 0 ]]
     then
@@ -57,7 +58,13 @@ for m in $(perf list --raw-dump metrics); do
     continue
   elif [[ "$result" =~ "<not supported>" ]]
   then
-    echo "Not supported events"
+    if [[ $(perf list --raw-dump $m) == "Default"* ]]
+    then
+      echo "[Ignored $m] failed but as a Default metric this can be expected"
+      echo $result
+      continue
+    fi
+    echo "[Skipped $m] Not supported events"
     echo $result
     if [[ $err -eq 0 ]]
     then
@@ -66,7 +73,7 @@ for m in $(perf list --raw-dump metrics); do
     continue
   elif [[ "$result" =~ "<not counted>" ]]
   then
-    echo "Not counted events"
+    echo "[Skipped $m] Not counted events"
     echo $result
     if [[ $err -eq 0 ]]
     then
@@ -75,7 +82,7 @@ for m in $(perf list --raw-dump metrics); do
     continue
   elif [[ "$result" =~ "FP_ARITH" || "$result" =~ "AMX" ]]
   then
-    echo "FP issues"
+    echo "[Skipped $m] FP issues"
     echo $result
     if [[ $err -eq 0 ]]
     then
@@ -84,7 +91,7 @@ for m in $(perf list --raw-dump metrics); do
     continue
   elif [[ "$result" =~ "PMM" ]]
   then
-    echo "Optane memory issues"
+    echo "[Skipped $m] Optane memory issues"
     echo $result
     if [[ $err -eq 0 ]]
     then
@@ -101,7 +108,7 @@ for m in $(perf list --raw-dump metrics); do
     # No error result and metric shown.
     continue
   fi
-  echo "Metric '$m' has non-zero error '$result_err' or not printed in:"
+  echo "[Failed $m] has non-zero error '$result_err' or not printed in:"
   echo "$result"
   err=1
 done
-- 
2.53.0



