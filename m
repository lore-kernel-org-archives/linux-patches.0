Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C444336891;
	Tue, 12 May 2026 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609494; cv=none; b=lAmsWv+nB/Un141BFISOKqtTpHxoa7yyXlhGQo+R1zURik8+/3SljIR+dDN4DOITBaWXWFZWyhXAhYD89/Mn9pNfihfnFoRhoqHH08dzmKos/QIOHL1IJYLbIqWzzXbMRGFE8yB1prOwlVMLLI4Q/VIt9l1e/EEkr8R0nD01LMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609494; c=relaxed/simple;
	bh=veC6dauVX7paheoe4nnl2hjCPtdHrRp7gt9MbhWzPvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ2R+UZWk9uND/kOwPPsJ2rparHbC3HfQZuHE0R3JyjbBaYjeg7n27bW6wK52Asg8rQeO/ivsqXwsJ1zohxTABhi48nJCXWnv6gyTRee8rqO1p27NRcAtal3GGHeMDlgMjL8wH9CejLUdRgjp77kC5QXohhWtdTohDDa7wydGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr9vRWLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr9vRWLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2287FC2BCC7;
	Tue, 12 May 2026 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609494;
	bh=veC6dauVX7paheoe4nnl2hjCPtdHrRp7gt9MbhWzPvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr9vRWLWrUOclY/rftE9S/np8F/CUERSf/sCq1k8QWg129dN6Vy2EfWUr2RlFIHmu
	 RlmveOOLjdk/OLGYbJS/JA7ewd/WXs0UUZfzDkwEXIlCaXSCrUga7pFPqiLgc/Px+E
	 bKEdEPAvJrLxqaZHeNSiIwJMNABn3vqYxZeJDNxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 218/307] mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
Date: Tue, 12 May 2026 19:40:13 +0200
Message-ID: <20260512173944.717396238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/reclaim.c |   85 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 30 deletions(-)

--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -144,15 +144,6 @@ static unsigned long addr_unit __read_mo
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
@@ -293,12 +284,8 @@ static int damon_reclaim_turn(bool on)
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
@@ -307,9 +294,6 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	kdamond_pid = damon_kdamond_pid(ctx);
-	if (kdamond_pid < 0)
-		return kdamond_pid;
 	return damon_call(ctx, &call_control);
 }
 
@@ -337,42 +321,83 @@ module_param_cb(addr_unit, &addr_unit_pa
 MODULE_PARM_DESC(addr_unit,
 	"Scale factor for DAMON_RECLAIM to ops address conversion (default: 1)");
 
+static bool damon_reclaim_enabled(void)
+{
+	if (!ctx)
+		return false;
+	return damon_is_running(ctx);
+}
+
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
 	if (!damon_initialized())
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
 static int __init damon_reclaim_init(void)
 {
 	int err;


