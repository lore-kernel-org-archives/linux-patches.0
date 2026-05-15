Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09E83FF1DA;
	Fri, 15 May 2026 15:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860531; cv=none; b=Eova6IkzPb72rd4JfmGP+3Lukk82rB26+jg9uCGhvasYsd+JWMBuMDIeh9FsfkrhkD2tLxkgRtlug+vwUK+jn0XqptCrZX4EaeudvscmuyHd5cAUkVQWpxAm+cGG9lE5TuamgJ1tRKfNtUiBn3F+/0QY8BQUOjTpqkvVfUbtO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860531; c=relaxed/simple;
	bh=SmvS9378pP0kT/YyJKCw7R/vgKYPP4YGezMi4Dm1D10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFZrtSz7GJuMLwSyiz4Zj1b6r8jbxw17w7e1JfCJjCI4Skj4WwxemH0WW93BskZ6LfCDHSPwWnwqxyCwfr6UlxxdyX4qwlvL8nQozaJ6ufEzJEuJ4/k7Xk9EdcwniFmramTN5yImR/CRz1raIfNNHqbRbEDGm2Ymf9kPiRBVqw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hZ6y1E+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hZ6y1E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508A8C2BCB0;
	Fri, 15 May 2026 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860531;
	bh=SmvS9378pP0kT/YyJKCw7R/vgKYPP4YGezMi4Dm1D10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hZ6y1E+IYBuO2I+Of5oI2HuNrWo3+PKUWQm8FUlRzBdHmjFWfRoJsdxHWQ39zr/t
	 /0Kk1a6k0b3H3b0QhD74W4crcME2e7ItcvbQAMAqkipIKq5aw7qo3EsIV/2JV0i3ej
	 goI1S5mi49U4DoFoPndO4L/5FCvda7DmMSHBecTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 125/144] mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
Date: Fri, 15 May 2026 17:49:11 +0200
Message-ID: <20260515154656.406153925@linuxfoundation.org>
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

commit b98b7ff6025ae82570d4915e083f0cbd8d48b3cf upstream.

DAMON_LRU_SORT updates 'enabled' and 'kdamond_pid' parameter values, which
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
DAMON_LRU_SORT avoids unnecessary damon_start() and damon_stop() calls
based on the 'enabled' parameter value.  And the update of 'enabled'
parameter value depends on the damon_start() and damon_stop() call
results.  Hence, once the kdamond has stopped by the unintentional events,
the user cannot restart the kdamond before the system reboot.  For
example, the issue can be reproduced via below steps.

    # cd /sys/module/damon_lru_sort/parameters
    #
    # # start DAMON_LRU_SORT
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

Link: https://lore.kernel.org/20260419161003.79176-3-sj@kernel.org
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Co-developed-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    1 
 mm/damon/core.c       |   16 +++++++++
 mm/damon/lru_sort.c   |   88 +++++++++++++++++++++++++++++++-------------------
 3 files changed, 73 insertions(+), 32 deletions(-)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -778,6 +778,7 @@ static inline unsigned int damon_max_nr_
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+bool damon_is_running(struct damon_ctx *ctx);
 int damon_kdamond_pid(struct damon_ctx *ctx);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1164,6 +1164,22 @@ int damon_stop(struct damon_ctx **ctxs,
 }
 
 /**
+ * damon_is_running() - Returns if a given DAMON context is running.
+ * @ctx:	The DAMON context to see if running.
+ *
+ * Return: true if @ctx is running, false otherwise.
+ */
+bool damon_is_running(struct damon_ctx *ctx)
+{
+	bool running;
+
+	mutex_lock(&ctx->kdamond_lock);
+	running = ctx->kdamond != NULL;
+	mutex_unlock(&ctx->kdamond_lock);
+	return running;
+}
+
+/**
  * damon_kdamond_pid() - Return pid of a given DAMON context's worker thread.
  * @ctx:	The DAMON context of the question.
  *
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -111,15 +111,6 @@ module_param(monitor_region_start, ulong
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
 
-/*
- * PID of the DAMON thread
- *
- * If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.
- * Else, -1.
- */
-static int kdamond_pid __read_mostly = -1;
-module_param(kdamond_pid, int, 0400);
-
 static struct damos_stat damon_lru_sort_hot_stat;
 DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_lru_sort_hot_stat,
 		lru_sort_tried_hot_regions, lru_sorted_hot_regions,
@@ -239,60 +230,93 @@ static int damon_lru_sort_turn(bool on)
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
 
 	err = damon_lru_sort_apply_parameters();
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
+static bool damon_lru_sort_enabled(void)
+{
+	if (!ctx)
+		return false;
+	return damon_is_running(ctx);
 }
 
 static int damon_lru_sort_enabled_store(const char *val,
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
+	if (damon_lru_sort_enabled() == enabled)
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
 	if (!ctx)
-		goto set_param_out;
+		return 0;
 
-	err = damon_lru_sort_turn(enable);
-	if (err)
-		return err;
+	return damon_lru_sort_turn(enabled);
+}
 
-set_param_out:
-	enabled = enable;
-	return err;
+static int damon_lru_sort_enabled_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_lru_sort_enabled() ? 'Y' : 'N');
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_lru_sort_enabled_store,
-	.get = param_get_bool,
+	.get = damon_lru_sort_enabled_load,
 };
 
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_LRU_SORT (default: disabled)");
 
+static int damon_lru_sort_kdamond_pid_store(const char *val,
+		const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
+static int damon_lru_sort_kdamond_pid_load(char *buffer,
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
+	.set = damon_lru_sort_kdamond_pid_store,
+	.get = damon_lru_sort_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+
 static int damon_lru_sort_handle_commit_inputs(void)
 {
 	int err;


