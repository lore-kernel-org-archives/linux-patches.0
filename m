Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C4B4964F;
	Wed,  8 Jan 2025 00:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736297936; cv=none; b=Efi65bMJF7RLlBieLMmicguGy6IksfIBibpMUjjH6WusisQI1z9QNCdCT3CLRhPDCAb77m3Z56CWsLjDz9okMfUkAb4RHqOJfeiqY+Z/XIe9jQWJeFfCOPQnACAdVToInRlUx3pW4sc37k9KuYy4d1r82WnchWFfXvso/qZKdAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736297936; c=relaxed/simple;
	bh=kPgLOQweT9CS4WFiS7RRBYHt5H6n1zD1v4nqNrenwUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud6fHn9aKnaHHB7yhdmCnHHTnPPYtmPRzuaDwRpYWHnJmRa1etsiRdJQz3uBaPG4jeAjfoLnSv9OZWkv7LROCylKFGLqhZuvaPGyy41XIVQ25+jU41GvqYxO4tdo5KquL2nGDavokc9QxSAUkP8GmHWbvGUtmGycyoWmzhNQknM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsL14DjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsL14DjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276EFC4CEE0;
	Wed,  8 Jan 2025 00:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736297936;
	bh=kPgLOQweT9CS4WFiS7RRBYHt5H6n1zD1v4nqNrenwUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsL14DjS4HP86gf8eHfAzLuwBIlEhTu/8pgMM91Kxx2BGayKenigyU9i1WzkrTAvH
	 cu2xyjf9u/jWDvQbKKnZBZImjq48RG20OM39DgeXxNYIcA7hQ/NtLcZvG11ABrVkCE
	 VvSJmXZ+vOR7rngEig/c6PAk9/74uP553CbOLjSDUSqTW7CA6SyMxFVgxcF6chn5Bu
	 G+rQyjzBlKH0Czdvqfp+J8ulof5u3uQiddHCWU2xbWA0739QO2DlrcYiYexpyiaPVQ
	 OCzDjGSvmk+VUlenE8IQXMRt5XaS3ZLkMiPx0LyfBgHotUSDW0duPUOyrngUtGi5H+
	 rIJkrf4ukewXw==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/4] clk: Use struct clk_hw instead of struct clk_core for debugfs
Date: Tue,  7 Jan 2025 16:58:47 -0800
Message-ID: <20250108005854.2973184-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
In-Reply-To: <20250108005854.2973184-1-sboyd@kernel.org>
References: <20250108005854.2973184-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The clk debugfs code uses struct clk_core because it is part of the core
framework file where the struct isn't opaque. Introduce helpers that use
struct clk_hw and use them in the clk debugfs code so that a later patch
can split out the clk debugfs code to a loadable kernel module while
keeping struct clk_core opaque.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 412 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 294 insertions(+), 118 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1a94a27194c9..e2f8fcbc1d4f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -818,6 +818,14 @@ void clk_hw_get_rate_range(struct clk_hw *hw, unsigned long *min_rate,
 }
 EXPORT_SYMBOL_GPL(clk_hw_get_rate_range);
 
+static void clk_debug_get_rate_range(struct clk_hw *hw, unsigned long *min_rate,
+				     unsigned long *max_rate)
+{
+	clk_prepare_lock();
+	clk_hw_get_rate_range(hw, min_rate, max_rate);
+	clk_prepare_unlock();
+}
+
 static bool clk_core_check_boundaries(struct clk_core *core,
 				      unsigned long min_rate,
 				      unsigned long max_rate)
@@ -1897,6 +1905,11 @@ static long clk_core_get_accuracy_recalc(struct clk_core *core)
 	return clk_core_get_accuracy_no_lock(core);
 }
 
+static long clk_hw_get_accuracy_recalc(struct clk_hw *hw)
+{
+	return clk_core_get_accuracy_recalc(hw->core);
+}
+
 /**
  * clk_get_accuracy - return the accuracy of clk
  * @clk: the clk whose accuracy is being returned
@@ -1983,6 +1996,11 @@ static unsigned long clk_core_get_rate_recalc(struct clk_core *core)
 	return clk_core_get_rate_nolock(core);
 }
 
+static unsigned long clk_hw_get_rate_recalc(struct clk_hw *hw)
+{
+	return clk_core_get_rate_recalc(hw->core);
+}
+
 /**
  * clk_get_rate - return the rate of clk
  * @clk: the clk whose rate is being returned
@@ -3059,6 +3077,11 @@ static int clk_core_get_phase(struct clk_core *core)
 	return ret;
 }
 
+static int clk_hw_get_phase(struct clk_hw *hw)
+{
+	return clk_core_get_phase(hw->core);
+}
+
 /**
  * clk_get_phase - return the phase shift of a clock signal
  * @clk: clock signal source
@@ -3219,17 +3242,19 @@ static int clk_core_get_scaled_duty_cycle(struct clk_core *core,
 	struct clk_duty *duty = &core->duty;
 	int ret;
 
-	clk_prepare_lock();
-
 	ret = clk_core_update_duty_cycle_nolock(core);
 	if (!ret)
 		ret = mult_frac(scale, duty->num, duty->den);
 
-	clk_prepare_unlock();
-
 	return ret;
 }
 
+static int clk_hw_get_scaled_duty_cycle(struct clk_hw *hw,
+					unsigned int scale)
+{
+	return clk_core_get_scaled_duty_cycle(hw->core, scale);
+}
+
 /**
  * clk_get_scaled_duty_cycle - return the duty cycle ratio of a clock signal
  * @clk: clock signal source
@@ -3240,10 +3265,16 @@ static int clk_core_get_scaled_duty_cycle(struct clk_core *core,
  */
 int clk_get_scaled_duty_cycle(struct clk *clk, unsigned int scale)
 {
+	int ret;
+
 	if (!clk)
 		return 0;
 
-	return clk_core_get_scaled_duty_cycle(clk->core, scale);
+	clk_prepare_lock();
+	ret = clk_core_get_scaled_duty_cycle(clk->core, scale);
+	clk_prepare_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_get_scaled_duty_cycle);
 
@@ -3288,45 +3319,95 @@ static struct hlist_head *orphan_list[] = {
 	NULL,
 };
 
-static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
+/*
+ * 1: Enabled in hardware
+ * 0: Disabled in hardware
+ * -1: Unknown enable state
+ */
+static int clk_hw_enable_state(struct clk_hw *hw)
+{
+	struct clk_core *core = hw->core;
+
+	if (core->ops->is_enabled)
+		return clk_hw_is_enabled(hw) ? 1 : 0;
+	if (!core->ops->enable)
+		return 1;
+
+	return -1;
+}
+
+static unsigned int clk_hw_enable_count(struct clk_hw *hw)
+{
+	return hw->core->enable_count;
+}
+
+static unsigned int clk_hw_prepare_count(struct clk_hw *hw)
+{
+	return hw->core->prepare_count;
+}
+
+static unsigned int clk_hw_protect_count(struct clk_hw *hw)
+{
+	return hw->core->protect_count;
+}
+
+static const char *clk_con_id(struct clk *clk)
+{
+	return clk->con_id;
+}
+
+static const char *clk_dev_id(struct clk *clk)
+{
+	return clk->dev_id;
+}
+
+static struct clk *clk_hw_next_consumer(struct clk_hw *hw, struct clk *prev)
+{
+	if (prev)
+		return hlist_entry_safe(prev->clks_node.next, struct clk, clks_node);
+
+	return hlist_entry_safe(hw->core->clks.first, struct clk, clks_node);
+}
+
+static void clk_summary_show_one(struct seq_file *s, struct clk_hw *hw,
 				 int level)
 {
+	int enable;
 	int phase;
-	struct clk *clk_user;
+	struct clk *clk_user = NULL;
 	int multi_node = 0;
 
 	seq_printf(s, "%*s%-*s %-7d %-8d %-8d %-11lu %-10lu ",
 		   level * 3 + 1, "",
-		   35 - level * 3, c->name,
-		   c->enable_count, c->prepare_count, c->protect_count,
-		   clk_core_get_rate_recalc(c),
-		   clk_core_get_accuracy_recalc(c));
+		   35 - level * 3, clk_hw_get_name(hw),
+		   clk_hw_enable_count(hw), clk_hw_prepare_count(hw),
+		   clk_hw_protect_count(hw),
+		   clk_hw_get_rate_recalc(hw),
+		   clk_hw_get_accuracy_recalc(hw));
 
-	phase = clk_core_get_phase(c);
+	phase = clk_hw_get_phase(hw);
 	if (phase >= 0)
 		seq_printf(s, "%-5d", phase);
 	else
 		seq_puts(s, "-----");
 
-	seq_printf(s, " %-6d", clk_core_get_scaled_duty_cycle(c, 100000));
+	seq_printf(s, " %-6d", clk_hw_get_scaled_duty_cycle(hw, 100000));
 
-	if (c->ops->is_enabled)
-		seq_printf(s, " %5c ", clk_core_is_enabled(c) ? 'Y' : 'N');
-	else if (!c->ops->enable)
-		seq_printf(s, " %5c ", 'Y');
+	enable = clk_hw_enable_state(hw);
+	if (enable >= 0)
+		seq_printf(s, " %5c ", enable ? 'Y' : 'N');
 	else
 		seq_printf(s, " %5c ", '?');
 
-	hlist_for_each_entry(clk_user, &c->clks, clks_node) {
+	while ((clk_user = clk_hw_next_consumer(hw, clk_user))) {
 		seq_printf(s, "%*s%-*s  %-25s\n",
 			   level * 3 + 2 + 105 * multi_node, "",
 			   30,
-			   clk_user->dev_id ? clk_user->dev_id : "deviceless",
-			   clk_user->con_id ? clk_user->con_id : "no_connection_id");
+			   clk_dev_id(clk_user) ? : "deviceless",
+			   clk_con_id(clk_user) ? : "no_connection_id");
 
 		multi_node = 1;
 	}
-
 }
 
 static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
@@ -3334,7 +3415,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
 {
 	struct clk_core *child;
 
-	clk_summary_show_one(s, c, level);
+	clk_summary_show_one(s, c->hw, level);
 
 	hlist_for_each_entry(child, &c->children, child_node)
 		clk_summary_show_subtree(s, child, level + 1);
@@ -3367,34 +3448,34 @@ static int clk_summary_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(clk_summary);
 
-static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
+static void clk_dump_one(struct seq_file *s, struct clk_hw *hw, int level)
 {
 	int phase;
 	unsigned long min_rate, max_rate;
 
-	clk_core_get_boundaries(c, &min_rate, &max_rate);
+	clk_hw_get_rate_range(hw, &min_rate, &max_rate);
 
 	/* This should be JSON format, i.e. elements separated with a comma */
-	seq_printf(s, "\"%s\": { ", c->name);
-	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
-	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
-	seq_printf(s, "\"protect_count\": %d,", c->protect_count);
-	seq_printf(s, "\"rate\": %lu,", clk_core_get_rate_recalc(c));
+	seq_printf(s, "\"%s\": { ", clk_hw_get_name(hw));
+	seq_printf(s, "\"enable_count\": %d,", clk_hw_enable_count(hw));
+	seq_printf(s, "\"prepare_count\": %d,", clk_hw_prepare_count(hw));
+	seq_printf(s, "\"protect_count\": %d,", clk_hw_protect_count(hw));
+	seq_printf(s, "\"rate\": %lu,", clk_hw_get_rate_recalc(hw));
 	seq_printf(s, "\"min_rate\": %lu,", min_rate);
 	seq_printf(s, "\"max_rate\": %lu,", max_rate);
-	seq_printf(s, "\"accuracy\": %lu,", clk_core_get_accuracy_recalc(c));
-	phase = clk_core_get_phase(c);
+	seq_printf(s, "\"accuracy\": %lu,", clk_hw_get_accuracy_recalc(hw));
+	phase = clk_hw_get_phase(hw);
 	if (phase >= 0)
 		seq_printf(s, "\"phase\": %d,", phase);
 	seq_printf(s, "\"duty_cycle\": %u",
-		   clk_core_get_scaled_duty_cycle(c, 100000));
+		   clk_hw_get_scaled_duty_cycle(hw, 100000));
 }
 
 static void clk_dump_subtree(struct seq_file *s, struct clk_core *c, int level)
 {
 	struct clk_core *child;
 
-	clk_dump_one(s, c, level);
+	clk_dump_one(s, c->hw, level);
 
 	hlist_for_each_entry(child, &c->children, child_node) {
 		seq_putc(s, ',');
@@ -3436,21 +3517,24 @@ static int clk_dump_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(clk_dump);
 
-#undef CLOCK_ALLOW_WRITE_DEBUGFS
-#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
 /*
  * This can be dangerous, therefore don't provide any real compile time
  * configuration option for this feature.
  * People who want to use this will need to modify the source code directly.
  */
+#undef CLOCK_ALLOW_WRITE_DEBUGFS
+#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
 static int clk_rate_set(void *data, u64 val)
 {
-	struct clk_core *core = data;
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_rate_set");
 	int ret;
 
-	clk_prepare_lock();
-	ret = clk_core_set_rate_nolock(core, val);
-	clk_prepare_unlock();
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	ret = clk_set_rate(clk, val);
+	clk_put(clk);
 
 	return ret;
 }
@@ -3459,13 +3543,16 @@ static int clk_rate_set(void *data, u64 val)
 
 static int clk_phase_set(void *data, u64 val)
 {
-	struct clk_core *core = data;
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_phase_set");
 	int degrees = do_div(val, 360);
 	int ret;
 
-	clk_prepare_lock();
-	ret = clk_core_set_phase_nolock(core, degrees);
-	clk_prepare_unlock();
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	ret = clk_set_phase(clk, degrees);
+	clk_put(clk);
 
 	return ret;
 }
@@ -3474,22 +3561,27 @@ static int clk_phase_set(void *data, u64 val)
 
 static int clk_prepare_enable_set(void *data, u64 val)
 {
-	struct clk_core *core = data;
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_prepare_enable_set");
 	int ret = 0;
 
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	if (val)
-		ret = clk_prepare_enable(core->hw->clk);
+		ret = clk_prepare_enable(clk);
 	else
-		clk_disable_unprepare(core->hw->clk);
+		clk_disable_unprepare(clk);
+	clk_put(clk);
 
 	return ret;
 }
 
 static int clk_prepare_enable_get(void *data, u64 *val)
 {
-	struct clk_core *core = data;
+	struct clk_hw *hw = data;
 
-	*val = core->enable_count && core->prepare_count;
+	*val = clk_hw_is_prepared(hw) && clk_hw_is_enabled(hw);
 	return 0;
 }
 
@@ -3506,11 +3598,14 @@ DEFINE_DEBUGFS_ATTRIBUTE(clk_prepare_enable_fops, clk_prepare_enable_get,
 
 static int clk_rate_get(void *data, u64 *val)
 {
-	struct clk_core *core = data;
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_rate_get");
 
-	clk_prepare_lock();
-	*val = clk_core_get_rate_recalc(core);
-	clk_prepare_unlock();
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	*val = clk_get_rate(clk);
+	clk_put(clk);
 
 	return 0;
 }
@@ -3519,9 +3614,15 @@ DEFINE_DEBUGFS_ATTRIBUTE(clk_rate_fops, clk_rate_get, clk_rate_set, "%llu\n");
 
 static int clk_phase_get(void *data, u64 *val)
 {
-	struct clk_core *core = data;
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_phase_get");
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	*val = clk_get_phase(clk);
+	clk_put(clk);
 
-	*val = core->phase;
 	return 0;
 }
 
@@ -3549,8 +3650,8 @@ static const struct {
 
 static int clk_flags_show(struct seq_file *s, void *data)
 {
-	struct clk_core *core = s->private;
-	unsigned long flags = core->flags;
+	struct clk_hw *hw = s->private;
+	unsigned long flags = clk_hw_get_flags(hw);
 	unsigned int i;
 
 	for (i = 0; flags && i < ARRAY_SIZE(clk_flags); i++) {
@@ -3568,10 +3669,11 @@ static int clk_flags_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(clk_flags);
 
-static void possible_parent_show(struct seq_file *s, struct clk_core *core,
-				 unsigned int i, char terminator)
+static void clk_hw_show_parent_by_index(struct seq_file *s, struct clk_hw *hw,
+					unsigned int i, char terminator)
 {
-	struct clk_core *parent;
+	struct clk_hw *parent;
+	struct clk_core *core = hw->core;
 	const char *name = NULL;
 
 	/*
@@ -3586,9 +3688,9 @@ static void possible_parent_show(struct seq_file *s, struct clk_core *core,
 	 * specified directly via a struct clk_hw pointer, but it isn't
 	 * registered (yet).
 	 */
-	parent = clk_core_get_parent_by_index(core, i);
+	parent = clk_hw_get_parent_by_index(hw, i);
 	if (parent) {
-		seq_puts(s, parent->name);
+		seq_puts(s, clk_hw_get_name(parent));
 	} else if (core->parents[i].name) {
 		seq_puts(s, core->parents[i].name);
 	} else if (core->parents[i].fw_name) {
@@ -3607,13 +3709,13 @@ static void possible_parent_show(struct seq_file *s, struct clk_core *core,
 
 static int possible_parents_show(struct seq_file *s, void *data)
 {
-	struct clk_core *core = s->private;
+	struct clk_hw *hw = s->private;
 	int i;
 
-	for (i = 0; i < core->num_parents - 1; i++)
-		possible_parent_show(s, core, i, ' ');
+	for (i = 0; i < clk_hw_get_num_parents(hw) - 1; i++)
+		clk_hw_show_parent_by_index(s, hw, i, ' ');
 
-	possible_parent_show(s, core, i, '\n');
+	clk_hw_show_parent_by_index(s, hw, i, '\n');
 
 	return 0;
 }
@@ -3621,10 +3723,11 @@ DEFINE_SHOW_ATTRIBUTE(possible_parents);
 
 static int current_parent_show(struct seq_file *s, void *data)
 {
-	struct clk_core *core = s->private;
+	struct clk_hw *hw = s->private;
+	struct clk_hw *parent = clk_hw_get_parent(hw);
 
-	if (core->parent)
-		seq_printf(s, "%s\n", core->parent->name);
+	if (parent)
+		seq_printf(s, "%s\n", clk_hw_get_name(parent));
 
 	return 0;
 }
@@ -3635,26 +3738,38 @@ static ssize_t current_parent_write(struct file *file, const char __user *ubuf,
 				    size_t count, loff_t *ppos)
 {
 	struct seq_file *s = file->private_data;
-	struct clk_core *core = s->private;
-	struct clk_core *parent;
+	struct clk *clk, *parent;
+	struct clk_hw *hw = s->private;
+	struct clk_hw *parent_hw;
 	u8 idx;
-	int err;
+	int ret;
 
-	err = kstrtou8_from_user(ubuf, count, 0, &idx);
-	if (err < 0)
-		return err;
+	ret = kstrtou8_from_user(ubuf, count, 0, &idx);
+	if (ret < 0)
+		return ret;
 
-	parent = clk_core_get_parent_by_index(core, idx);
-	if (!parent)
+	parent_hw = clk_hw_get_parent_by_index(hw, idx);
+	if (!parent_hw)
 		return -ENOENT;
 
-	clk_prepare_lock();
-	err = clk_core_set_parent_nolock(core, parent);
-	clk_prepare_unlock();
-	if (err)
-		return err;
+	clk = clk_hw_get_clk(hw, "debugfs_write");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 
-	return count;
+	parent = clk_hw_get_clk(parent_hw, "debugfs_write");
+	if (IS_ERR(parent)) {
+		ret = PTR_ERR(parent);
+		goto err;
+	}
+
+	ret = clk_set_parent(clk, parent);
+	if (!ret)
+		ret = count;
+
+	clk_put(parent);
+err:
+	clk_put(clk);
+	return ret;
 }
 
 static const struct file_operations current_parent_rw_fops = {
@@ -3666,12 +3781,19 @@ static const struct file_operations current_parent_rw_fops = {
 };
 #endif
 
+static void clk_hw_get_duty(struct clk_hw *hw, struct clk_duty *duty)
+{
+	memcpy(duty, &hw->core->duty, sizeof(*duty));
+}
+
 static int clk_duty_cycle_show(struct seq_file *s, void *data)
 {
-	struct clk_core *core = s->private;
-	struct clk_duty *duty = &core->duty;
+	struct clk_hw *hw = s->private;
+	struct clk_duty duty = { };
 
-	seq_printf(s, "%u/%u\n", duty->num, duty->den);
+	clk_hw_get_duty(hw, &duty);
+
+	seq_printf(s, "%u/%u\n", duty.num, duty.den);
 
 	return 0;
 }
@@ -3679,12 +3801,10 @@ DEFINE_SHOW_ATTRIBUTE(clk_duty_cycle);
 
 static int clk_min_rate_show(struct seq_file *s, void *data)
 {
-	struct clk_core *core = s->private;
+	struct clk_hw *hw = s->private;
 	unsigned long min_rate, max_rate;
 
-	clk_prepare_lock();
-	clk_core_get_boundaries(core, &min_rate, &max_rate);
-	clk_prepare_unlock();
+	clk_debug_get_rate_range(hw, &min_rate, &max_rate);
 	seq_printf(s, "%lu\n", min_rate);
 
 	return 0;
@@ -3693,54 +3813,110 @@ DEFINE_SHOW_ATTRIBUTE(clk_min_rate);
 
 static int clk_max_rate_show(struct seq_file *s, void *data)
 {
-	struct clk_core *core = s->private;
+	struct clk_hw *hw = s->private;
 	unsigned long min_rate, max_rate;
 
-	clk_prepare_lock();
-	clk_core_get_boundaries(core, &min_rate, &max_rate);
-	clk_prepare_unlock();
+	clk_debug_get_rate_range(hw, &min_rate, &max_rate);
 	seq_printf(s, "%lu\n", max_rate);
 
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(clk_max_rate);
 
-static struct dentry *clk_debug_create_one(struct clk_core *core)
+static int clk_accuracy_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_accuracy");
+	unsigned long accuracy;
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	accuracy = clk_get_accuracy(clk);
+	seq_printf(s, "%lu\n", accuracy);
+	clk_put(clk);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_accuracy);
+
+static int clk_prepare_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+
+	seq_printf(s, "%u\n", clk_hw_prepare_count(hw));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_prepare);
+
+static int clk_enable_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+
+	seq_printf(s, "%u\n", clk_hw_enable_count(hw));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_enable);
+
+static int clk_protect_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+
+	seq_printf(s, "%u\n", clk_hw_protect_count(hw));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_protect);
+
+static unsigned int clk_hw_notifier_count(struct clk_hw *hw)
+{
+	return hw->core->notifier_count;
+}
+
+static int clk_notifier_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+
+	seq_printf(s, "%u\n", clk_hw_notifier_count(hw));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_notifier);
+
+static struct dentry *clk_hw_debug_create_one(struct clk_hw *hw)
 {
 	struct dentry *root;
 
-	root = debugfs_create_dir(core->name, rootdir);
-	core->dentry = root;
+	root = debugfs_create_dir(clk_hw_get_name(hw), rootdir);
 
-	debugfs_create_file("clk_rate", clk_rate_mode, root, core,
-			    &clk_rate_fops);
-	debugfs_create_file("clk_min_rate", 0444, root, core, &clk_min_rate_fops);
-	debugfs_create_file("clk_max_rate", 0444, root, core, &clk_max_rate_fops);
-	debugfs_create_ulong("clk_accuracy", 0444, root, &core->accuracy);
-	debugfs_create_file("clk_phase", clk_phase_mode, root, core,
-			    &clk_phase_fops);
-	debugfs_create_file("clk_flags", 0444, root, core, &clk_flags_fops);
-	debugfs_create_u32("clk_prepare_count", 0444, root, &core->prepare_count);
-	debugfs_create_u32("clk_enable_count", 0444, root, &core->enable_count);
-	debugfs_create_u32("clk_protect_count", 0444, root, &core->protect_count);
-	debugfs_create_u32("clk_notifier_count", 0444, root, &core->notifier_count);
-	debugfs_create_file("clk_duty_cycle", 0444, root, core,
-			    &clk_duty_cycle_fops);
+	debugfs_create_file("clk_rate", clk_rate_mode, root, hw, &clk_rate_fops);
+	debugfs_create_file("clk_min_rate", 0444, root, hw, &clk_min_rate_fops);
+	debugfs_create_file("clk_max_rate", 0444, root, hw, &clk_max_rate_fops);
+	debugfs_create_file("clk_accuracy", 0444, root, hw, &clk_accuracy_fops);
+	debugfs_create_file("clk_phase", clk_phase_mode, root, hw, &clk_phase_fops);
+	debugfs_create_file("clk_flags", 0444, root, hw, &clk_flags_fops);
+	debugfs_create_file("clk_prepare_count", 0444, root, hw, &clk_prepare_fops);
+	debugfs_create_file("clk_enable_count", 0444, root, hw, &clk_enable_fops);
+	debugfs_create_file("clk_protect_count", 0444, root, hw, &clk_protect_fops);
+	debugfs_create_file("clk_notifier_count", 0444, root, hw, &clk_notifier_fops);
+	debugfs_create_file("clk_duty_cycle", 0444, root, hw, &clk_duty_cycle_fops);
 #ifdef CLOCK_ALLOW_WRITE_DEBUGFS
-	debugfs_create_file("clk_prepare_enable", 0644, root, core,
+	debugfs_create_file("clk_prepare_enable", 0644, root, hw,
 			    &clk_prepare_enable_fops);
 
-	if (core->num_parents > 1)
-		debugfs_create_file("clk_parent", 0644, root, core,
+	if (clk_hw_get_num_parents(hw) > 1)
+		debugfs_create_file("clk_parent", 0644, root, hw,
 				    &current_parent_rw_fops);
 	else
 #endif
-	if (core->num_parents > 0)
-		debugfs_create_file("clk_parent", 0444, root, core,
+	if (clk_hw_get_num_parents(hw) > 0)
+		debugfs_create_file("clk_parent", 0444, root, hw,
 				    &current_parent_fops);
 
-	if (core->num_parents > 1)
-		debugfs_create_file("clk_possible_parents", 0444, root, core,
+	if (clk_hw_get_num_parents(hw) > 1)
+		debugfs_create_file("clk_possible_parents", 0444, root, hw,
 				    &possible_parents_fops);
 
 	return root;
@@ -3753,7 +3929,7 @@ static void clk_core_debug_create_one(struct clk_core *core)
 	if (!inited)
 		return;
 
-	core->dentry = clk_debug_create_one(core);
+	core->dentry = clk_hw_debug_create_one(hw);
 	if (core->ops->debug_init)
 		core->ops->debug_init(hw, core->dentry);
 }
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

