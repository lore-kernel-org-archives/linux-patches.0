Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569234BEE54;
	Sat, 12 Sep 2026 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206195; cv=none; b=NK9fRCAyscr+VZ797b0pNnoynpk5ZU2x8IR/gX89mjmVPH2S6g51IGOzXvm8M6LOdvdKUPL4UNPhA/0gjbtmkMTO+56QgvYnY1W/PRb2ETVNETzdLBbyxmNQ99/H7y8NlBFtzcTezywAtTVZByODolJWEDCGpcpMM4bus+Wt4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206195; c=relaxed/simple;
	bh=QHlfcnzpYGDjCW/czWa/o8tQMAdWsWVJG6H9DGzJYM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHh4S5XDF98ztbaqChJLs7sy850ARNlm9KqS7FRy7aah+MxQ7z7khCsWGGVwyp7+9zaEgrfQCBYYoqnNFbRZuwYFbAcNVkJT3nysufUy8ms+vxDLl01g5n4ysiF0hHgu2VDXZn7lXkilyWhOUVsQOYmGIQVkouFARCVZr0KK0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG5lxijw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG5lxijw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8B81F000FF;
	Sat, 12 Sep 2026 09:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206194;
	bh=Ct8+Xip6QOb4JgjqRpkotHPPcfNlvKgwZeMMeq6dGGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qG5lxijwkEUMD/MmWwQeyQ/RHAm+sMxE+y86r/Ka/QsMuI0zTxwRXyMVVL35VuxD7
	 VEZI6ih4lMDIgR1BKt3kVPTr14ac/I9MBAhylBkgGf08VPBNKQUtx/Dy4UwCRPZRpQ
	 lKUcsy44IGAblKUyoTLhyjfJLpU7dNJ/QhESo28w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0157/1518] perf test all metrics: Fully ignore Default metric failures
Date: Sat, 12 Sep 2026 08:38:46 +0200
Message-ID: <20260912065627.044602420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



