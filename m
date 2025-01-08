Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB467DA6A;
	Wed,  8 Jan 2025 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736297937; cv=none; b=MmyuirKgiMHIIfxRKRkpsP22QESOjgADAju84NTQNqR9pM+hsL0eMtiK5ssr560vr8ptxga58JOGaX6HguvKlpsv588iPTaXCIECQNAD7ndUxyFvTFi2V1dt2hU78ke9+js4mDRg4A8FAdBamTQKKZybyaUjhYz0j5byXv8qa9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736297937; c=relaxed/simple;
	bh=dYnYqamwA1aPKPYpUg7a2HmrnCCIu9jg59bQu0adTtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1c5G/Rx1uOyZ0AnCPaOBIb1Ugo6Dugi1nzpCO+Rhk1q893zXykLqT9If5uw++Ld8C5bJ5O4eN45MEhAjqkDcHX3tKAn0qPUudlg9ZcyZc69PcXLdkJSuU+yhENSThTlDOjQz53ydlnYNtpOlfmIWGBvMpjff3BD8a+9JyEE8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oum/x20E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oum/x20E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D205C4CEE2;
	Wed,  8 Jan 2025 00:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736297936;
	bh=dYnYqamwA1aPKPYpUg7a2HmrnCCIu9jg59bQu0adTtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oum/x20EyJrWP/zYXv7zodBTgTuPlNS729x3TVTWkfqNLJhoDdvMTR0rCGLV8s5tq
	 jX9YKUIi6ujkbkt0fPAyNoOm8n1iPl6QRf40F2D6qfpHpHs+Se9Fkq89lnaeB0q35c
	 V8RSPNloC0vymsMxX8BPs3NdJmu1+pJ+dEcPY88vnuJrkzVoKfZZB7LK0XjpegjC5Y
	 ZVPHhK0rM4ZCJLBN4QPiDZNReT+fN2Vyaz5UT/mMS4yjPQwZ6XFQb50b73qMjOeZIW
	 U8jXVru+LOpFn0YszDSgOvaTD1DBnhOYUc2V9qiT8bN6b9tw8xEL9ymaIytS13ErAe
	 Vflqey9CE4GqQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 3/4] clk: Iterate instead of recurse for debugfs printing
Date: Tue,  7 Jan 2025 16:58:48 -0800
Message-ID: <20250108005854.2973184-4-sboyd@kernel.org>
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

The implementation for clk debugfs files like clk_summary and clk_dump
are recursive and entangled with the tree walking logic to the point
that it's not easy to split out the code that walks the clk tree from
the code that prints details of a clk. Harmonize the clk_dump_show() and
clk_summary_show() clk tree walking details by linking all the clks to
be shown onto a linked list in the order that the clks are walked and
then iterate the list calling a "show" function supplied by the caller.

Replacing recursion with iteration avoids exceeding limited kernel
stacks as well as allows us to split the "show" function out to a
loadable kernel module. The downside is the code is more complicated.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 171 +++++++++++++++++++++++++---------------------
 1 file changed, 95 insertions(+), 76 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index e2f8fcbc1d4f..37c7963d685f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -89,6 +89,7 @@ struct clk_core {
 	struct hlist_node	child_node;
 	struct hlist_head	clks;
 	unsigned int		notifier_count;
+	struct hlist_node	iterate_node;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
 	struct hlist_node	debug_node;
@@ -3314,11 +3315,6 @@ static int inited = 0;
 static DEFINE_MUTEX(clk_debug_lock);
 static HLIST_HEAD(clk_debug_list);
 
-static struct hlist_head *orphan_list[] = {
-	&clk_orphan_list,
-	NULL,
-};
-
 /*
  * 1: Enabled in hardware
  * 0: Disabled in hardware
@@ -3369,9 +3365,85 @@ static struct clk *clk_hw_next_consumer(struct clk_hw *hw, struct clk *prev)
 	return hlist_entry_safe(hw->core->clks.first, struct clk, clks_node);
 }
 
-static void clk_summary_show_one(struct seq_file *s, struct clk_hw *hw,
-				 int level)
+static void clk_walk_trees(struct hlist_head *list, bool only_orphans)
 {
+	struct clk_core *root, *core, *child;
+	struct clk_core *last = NULL;
+	const struct hlist_head **lists = all_lists;
+
+	if (only_orphans)
+		lists++;
+
+	for (; *lists; lists++) {
+		hlist_for_each_entry(root, *lists, child_node) {
+			if (last)
+				hlist_add_behind(&root->iterate_node, &last->iterate_node);
+			else
+				hlist_add_head(&root->iterate_node, list);
+
+			core = root;
+			hlist_for_each_entry_from(core, iterate_node) {
+				last = core;
+				hlist_for_each_entry(child, &core->children, child_node) {
+					hlist_add_behind(&child->iterate_node, &last->iterate_node);
+					last = child;
+				}
+			}
+		}
+	}
+}
+
+static int clk_show_tree(void (*show_fn)(struct clk_hw *hw, int level,
+					 int next_level, bool first,
+					 void *data),
+			 void *data, bool orphan_only)
+{
+	struct clk_core *core, *parent;
+	struct hlist_node *tmp;
+	HLIST_HEAD(list);
+	int ret;
+	int level = 0;
+	int next_level;
+	bool first = true;
+
+	ret = clk_pm_runtime_get_all();
+	if (ret)
+		return ret;
+
+	clk_prepare_lock();
+
+	clk_walk_trees(&list, orphan_only);
+	hlist_for_each_entry_safe(core, tmp, &list, iterate_node) {
+		next_level = level;
+		parent = core;
+		/*
+		 * If this is the right most (i.e. last) clk at this level
+		 * figure out how many levels lower the next clk will be by
+		 * finding the next left side of the tree.
+		 */
+		while (!parent->child_node.next && (parent = parent->parent))
+			next_level--;
+		/* If the clk has children the next node is at the next level */
+		if (!hlist_empty(&core->children))
+			next_level = level + 1;
+
+		show_fn(core->hw, level, next_level, first, data);
+		first = false;
+
+		hlist_del_init(&core->iterate_node);
+		level = next_level;
+	}
+
+	clk_prepare_unlock();
+	clk_pm_runtime_put_all();
+
+	return 0;
+}
+
+static void clk_summary_show_one(struct clk_hw *hw, int level, int next_level,
+				 bool first, void *data)
+{
+	struct seq_file *s = data;
 	int enable;
 	int phase;
 	struct clk *clk_user = NULL;
@@ -3410,51 +3482,29 @@ static void clk_summary_show_one(struct seq_file *s, struct clk_hw *hw,
 	}
 }
 
-static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
-				     int level)
-{
-	struct clk_core *child;
-
-	clk_summary_show_one(s, c->hw, level);
-
-	hlist_for_each_entry(child, &c->children, child_node)
-		clk_summary_show_subtree(s, child, level + 1);
-}
-
 static int clk_summary_show(struct seq_file *s, void *data)
 {
-	struct clk_core *c;
-	struct hlist_head **lists = s->private;
-	int ret;
+	bool orphan_only = s->private;
 
 	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware                            connection\n");
 	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable   consumer                         id\n");
 	seq_puts(s, "---------------------------------------------------------------------------------------------------------------------------------------------\n");
 
-	ret = clk_pm_runtime_get_all();
-	if (ret)
-		return ret;
-
-	clk_prepare_lock();
-
-	for (; *lists; lists++)
-		hlist_for_each_entry(c, *lists, child_node)
-			clk_summary_show_subtree(s, c, 0);
-
-	clk_prepare_unlock();
-	clk_pm_runtime_put_all();
-
-	return 0;
+	return clk_show_tree(clk_summary_show_one, s, orphan_only);
 }
 DEFINE_SHOW_ATTRIBUTE(clk_summary);
 
-static void clk_dump_one(struct seq_file *s, struct clk_hw *hw, int level)
+static void clk_dump_one(struct clk_hw *hw, int level, int next_level, bool first, void *data)
 {
+	struct seq_file *s = data;
 	int phase;
 	unsigned long min_rate, max_rate;
 
 	clk_hw_get_rate_range(hw, &min_rate, &max_rate);
 
+	if (!first)
+		seq_putc(s, ',');
+
 	/* This should be JSON format, i.e. elements separated with a comma */
 	seq_printf(s, "\"%s\": { ", clk_hw_get_name(hw));
 	seq_printf(s, "\"enable_count\": %d,", clk_hw_enable_count(hw));
@@ -3469,50 +3519,19 @@ static void clk_dump_one(struct seq_file *s, struct clk_hw *hw, int level)
 		seq_printf(s, "\"phase\": %d,", phase);
 	seq_printf(s, "\"duty_cycle\": %u",
 		   clk_hw_get_scaled_duty_cycle(hw, 100000));
-}
 
-static void clk_dump_subtree(struct seq_file *s, struct clk_core *c, int level)
-{
-	struct clk_core *child;
-
-	clk_dump_one(s, c->hw, level);
-
-	hlist_for_each_entry(child, &c->children, child_node) {
-		seq_putc(s, ',');
-		clk_dump_subtree(s, child, level + 1);
-	}
-
-	seq_putc(s, '}');
+	while (level-- >= next_level)
+		seq_putc(s, '}');
 }
 
 static int clk_dump_show(struct seq_file *s, void *data)
 {
-	struct clk_core *c;
-	bool first_node = true;
-	struct hlist_head **lists = s->private;
-	int ret;
-
-	ret = clk_pm_runtime_get_all();
-	if (ret)
-		return ret;
+	bool orphan_only = s->private;
 
 	seq_putc(s, '{');
-
-	clk_prepare_lock();
-
-	for (; *lists; lists++) {
-		hlist_for_each_entry(c, *lists, child_node) {
-			if (!first_node)
-				seq_putc(s, ',');
-			first_node = false;
-			clk_dump_subtree(s, c, 0);
-		}
-	}
-
-	clk_prepare_unlock();
-	clk_pm_runtime_put_all();
-
+	clk_show_tree(clk_dump_one, s, orphan_only);
 	seq_puts(s, "}\n");
+
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(clk_dump);
@@ -4000,13 +4019,13 @@ static int __init clk_debug_init(void)
 
 	rootdir = debugfs_create_dir("clk", NULL);
 
-	debugfs_create_file("clk_summary", 0444, rootdir, &all_lists,
+	debugfs_create_file("clk_summary", 0444, rootdir, (void *)0UL,
 			    &clk_summary_fops);
-	debugfs_create_file("clk_dump", 0444, rootdir, &all_lists,
+	debugfs_create_file("clk_dump", 0444, rootdir, (void *)0UL,
 			    &clk_dump_fops);
-	debugfs_create_file("clk_orphan_summary", 0444, rootdir, &orphan_list,
+	debugfs_create_file("clk_orphan_summary", 0444, rootdir, (void *)1UL,
 			    &clk_summary_fops);
-	debugfs_create_file("clk_orphan_dump", 0444, rootdir, &orphan_list,
+	debugfs_create_file("clk_orphan_dump", 0444, rootdir, (void *)1UL,
 			    &clk_dump_fops);
 
 	mutex_lock(&clk_debug_lock);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

