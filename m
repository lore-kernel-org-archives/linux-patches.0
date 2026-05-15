Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415A176238;
	Fri, 15 May 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860534; cv=none; b=blBw4hsuDiz18jLRImBh4j6hWaaIp3/PuyBbNBhUWYRxNoA9PZaHKvqXObMo6edbTpCkXouTEMsdN6sXIDw7+LJwPYm7XcZhYW4ypTMCtDg12jSvbeDp382/r8LH0rkqQP1K67bysVPx+MMMMixl8JJHeuLw0L9QbVFjNlx+tZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860534; c=relaxed/simple;
	bh=3eUHf4z1DQl5xb3w+r+fLLNEc8k7y2SLWY3zfgiWFUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCBmhGDHCtTANYCM2k8mnY4KgA3UA61FaDfOO/DSIklqWL0gp2+0OrX2BjLeIRNDsSmXkC6qQx4oua+RjYAXKC6pk5I/vg72E1/5ZKgiXXaf0ig50cMxPiiQR9BIWKWmQ40MBK9O+yaN3Te/+Eq0RiEZFny3qHnWneF1TWgYIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQlw/k8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQlw/k8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC615C2BCB0;
	Fri, 15 May 2026 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860534;
	bh=3eUHf4z1DQl5xb3w+r+fLLNEc8k7y2SLWY3zfgiWFUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQlw/k8hoMwX+eoF9s6T1b5XHxB00bdoMyAuA2C0dzcWzSCU61NByNooe29x7F+Qn
	 buGewUT/o97h7nw7T4zZf7gzuRvUZG3WDIgwH3E5U8XXe+RO0tS/vH91sKYVO3jJPG
	 eb5B9Ih8/vh3jYbhfkjWZBPbmlIhKCPApslXPKdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 126/144] mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
Date: Fri, 15 May 2026 17:49:12 +0200
Message-ID: <20260515154656.430685197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 64a140afa5ed1c6f5ba6d451512cbdbbab1ba339 upstream.

Patch series "mm/damon/modules: detect and use fresh status", v3.

DAMON modules including DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
commonly expose the kdamond running status via their parameters.  Under
certain scenarios including wrong user inputs and memory allocation
failures, those parameter values can be stale.  It can confuse users.  For
DAMON_RECLAIM and DAMON_LRU_SORT, it even makes the kdamond unable to be
restarted before the system reboot.

The problem comes from the fact that there are multiple events for the
status changes and it is difficult to follow up all the scenarios.  Fix
the issue by detecting and using the status on demand, instead of using a
cached status that is difficult to be updated.

Patches 1-3 fix the bugs in DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
in the order.


This patch (of 3):

DAMON_RECLAIM updates 'enabled' and 'kdamond_pid' parameter values, which
represents the running status of its kdamond, when the user explicitly
requests start/stop of the kdamond.  The kdamond can, however, be stopped
in events other than the explicit user request in the following three
events.

1. ctx->regions_score_histogram allocation failure at beginning of the
   execution,
2. damon_commit_ctx() failure due to invalid user input, and
3. damon_commit_ctx() failure due to its internal allocation failures.

Hence, if the kdamond is stopped by the above three events, the values of
the status parameters can be stale.  Users could show the stale values and
be confused.  This is already bad, but the real consequence is worse.
DAMON_RECLAIM avoids unnecessary damon_start() and damon_stop() calls
based on the 'enabled' parameter value.  And the update of 'enabled'
parameter value depends on the damon_start() and damon_stop() call
results.  Hence, once the kdamond has stopped by the unintentional events,
the user cannot restart the kdamond before the system reboot.  For
example, the issue can be reproduced via below steps.

    # cd /sys/module/damon_reclaim/parameters
    #
    # # start DAMON_RECLAIM
    # echo Y > enabled
    # ps -ef | grep kdamond
    root         806       2  0 17:53 ?        00:00:00 [kdamond.0]
    root         808     803  0 17:53 pts/4    00:00:00 grep kdamond
    #
    # # commit wrong input to stop kdamond withou explicit stop request
    # echo 3 > addr_unit
    # echo Y > commit_inputs
    bash: echo: write error: Invalid argument
    #
    # # confirm kdamond is stopped
    # ps -ef | grep kdamond
    root         811     803  0 17:53 pts/4    00:00:00 grep kdamond
    #
    # # users casn now show stable status
    # cat enabled
    Y
    # cat kdamond_pid
    806
    #
    # # even after fixing the wrong parameter,
    # # kdamond cannot be restarted.
    # echo 1 > addr_unit
    # echo Y > enabled
    # ps -ef | grep kdamond
    root         815     803  0 17:54 pts/4    00:00:00 grep kdamond

The problem will only rarely happen in real and common setups for the
following reasons.  The allocation failures are unlikely in such setups
since those allocations are arguably too small to fail.  Also sane users
on real production environments may not commit wrong input parameters.
But once it happens, the consequence is quite bad.  And the bug is a bug.

The issue stems from the fact that there are multiple events that can
change the status, and following all the events is challenging.
Dynamically detect and use the fresh status for the parameters when those
are requested.

Link: https://lore.kernel.org/20260419161003.79176-1-sj@kernel.org
Link: https://lore.kernel.org/20260419161003.79176-2-sj@kernel.org
Fixes: e035c280f6df ("mm/damon/reclaim: support online inputs update")
Co-developed-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/reclaim.c |   88 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 32 deletions(-)

--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -137,15 +137,6 @@ module_param(monitor_region_end, ulong,
 static bool skip_anon __read_mostly;
 module_param(skip_anon, bool, 0600);
 
-/*
- * PID of the DAMON thread
- *
- * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
- * Else, -1.
- */
-static int kdamond_pid __read_mostly = -1;
-module_param(kdamond_pid, int, 0400);
-
 static struct damos_stat damon_reclaim_stat;
 DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
 		reclaim_tried_regions, reclaimed_regions, quota_exceeds);
@@ -247,60 +238,93 @@ static int damon_reclaim_turn(bool on)
 {
 	int err;
 
-	if (!on) {
-		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
-		return err;
-	}
+	if (!on)
+		return damon_stop(&ctx, 1);
 
 	err = damon_reclaim_apply_parameters();
 	if (err)
 		return err;
 
-	err = damon_start(&ctx, 1, true);
-	if (err)
-		return err;
-	kdamond_pid = ctx->kdamond->pid;
-	return 0;
+	return damon_start(&ctx, 1, true);
+}
+
+static bool damon_reclaim_enabled(void)
+{
+	if (!ctx)
+		return false;
+	return damon_is_running(ctx);
 }
 
 static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-	bool is_enabled = enabled;
-	bool enable;
 	int err;
 
-	err = kstrtobool(val, &enable);
+	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (is_enabled == enable)
+	if (damon_reclaim_enabled() == enabled)
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
 	if (!ctx)
-		goto set_param_out;
+		return 0;
 
-	err = damon_reclaim_turn(enable);
-	if (err)
-		return err;
+	return damon_reclaim_turn(enabled);
+}
 
-set_param_out:
-	enabled = enable;
-	return err;
+static int damon_reclaim_enabled_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_reclaim_enabled() ? 'Y' : 'N');
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_reclaim_enabled_store,
-	.get = param_get_bool,
+	.get = damon_reclaim_enabled_load,
 };
 
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_RECLAIM (default: disabled)");
 
+static int damon_reclaim_kdamond_pid_store(const char *val,
+		const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
+static int damon_reclaim_kdamond_pid_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	int kdamond_pid = -1;
+
+	if (ctx) {
+		kdamond_pid = damon_kdamond_pid(ctx);
+		if (kdamond_pid < 0)
+			kdamond_pid = -1;
+	}
+	return sprintf(buffer, "%d\n", kdamond_pid);
+}
+
+static const struct kernel_param_ops kdamond_pid_param_ops = {
+	.set = damon_reclaim_kdamond_pid_store,
+	.get = damon_reclaim_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+
 static int damon_reclaim_handle_commit_inputs(void)
 {
 	int err;


