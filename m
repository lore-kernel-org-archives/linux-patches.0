Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93200126BEE;
	Wed,  8 Jan 2025 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736297937; cv=none; b=MdCpRw5mioAfgsrH8oyBIUjmZQlG+cGl4E2X0+DwVODfPcwE2jGh+XlGbDjW2cxMKLXePHn45BcOvO/wKzjagayqYtGaTndixrKvAHrT0S+QhgnsepXVjVulU8YnNz7wT4siBQgbm/Ym38iIVUl2nI5MpfXn9ugDRiT/c4kJSk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736297937; c=relaxed/simple;
	bh=YFVVlulGLUTVHXMPc1opVRj7WKpmAFMKYCC8IdVDVTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0xndx2iwUXtV8OXibTFcd6YO2cFJ5+d2reEkLnYQclpvieI8KH536UNdUU9gwqFF9C1BqAM4tr1rMUms8+lnVlvJclmUqGyfhDTeRo7RJvm0B8xc0n5iWPppagWqzQuGauKdRto9VrUQIu92OENKqg1zo+U+WbeE7KMUiW27Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAOHAgVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAOHAgVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7E5C4CED6;
	Wed,  8 Jan 2025 00:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736297937;
	bh=YFVVlulGLUTVHXMPc1opVRj7WKpmAFMKYCC8IdVDVTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAOHAgVuTT7889gmFlt2NRoKS4IcrNkj2uqWu3yfHqIlARgdF8SasGYwTXCE7jSi4
	 W8YBwcWeMAVRX7yUWEvRFBKwjjA4ShprbuS93oxfuq4vawiSurnuifaPUcCgaRDXDR
	 Ai+M0nArNerCKO+dsEtXTrxIr3GOXKAEwB+ndNcETNu9A7TejbsJcV1sxCvp0bfUqT
	 TryUpV0Bjt0xP+BkG7zT25WWP1T8RZuvkbUe3nR28N/e7P3jdVC271j48p/TaHeoFD
	 S1536rJ0xpfGHBVuD7GsDcyACLFtFZUkOjk6Qrlz9SjCZIZtlwoSMkhHwRGHsAqmFx
	 DCHQM5HzrGpyw==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 4/4] clk: Make debugfs code into a loadable kernel module
Date: Tue,  7 Jan 2025 16:58:49 -0800
Message-ID: <20250108005854.2973184-5-sboyd@kernel.org>
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

Split the debugfs code for the clk framework into a separate loadable
kernel module. This allows the debugfs code to be loaded later, or not
at all.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/Kconfig     |   8 +
 drivers/clk/Makefile    |   1 +
 drivers/clk/clk-debug.c | 529 ++++++++++++++++++++++++++++++++++
 drivers/clk/clk-debug.h |  33 +++
 drivers/clk/clk.c       | 607 +++++-----------------------------------
 5 files changed, 643 insertions(+), 535 deletions(-)
 create mode 100644 drivers/clk/clk-debug.c
 create mode 100644 drivers/clk/clk-debug.h

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 713573b6c86c..fb84c2698cbd 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -33,6 +33,14 @@ menuconfig COMMON_CLK
 
 if COMMON_CLK
 
+config COMMON_CLK_DEBUG
+	tristate "Common Clock Framework debug support"
+	depends on DEBUG_FS || COMPILE_TEST
+	default COMMON_CLK
+	help
+	  Say yes here to enable debugging support for the common clock
+	  framework.
+
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index bf4bd45adc3a..10e1dab55cc9 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -2,6 +2,7 @@
 # common clock types
 obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o clk-bulk.o clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o
+obj-$(CONFIG_COMMON_CLK_DEBUG)	+= clk-debug.o
 obj-$(CONFIG_CLK_KUNIT_TEST)	+= clk-test.o
 clk-test-y			:= clk_test.o \
 				   kunit_clk_assigned_rates_u64_one.dtbo.o \
diff --git a/drivers/clk/clk-debug.c b/drivers/clk/clk-debug.c
new file mode 100644
index 000000000000..47af5f25c4e3
--- /dev/null
+++ b/drivers/clk/clk-debug.c
@@ -0,0 +1,529 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ * Copyright (C) 2011-2012 Linaro Ltd <mturquette@linaro.org>
+ *
+ * Debugfs functionality for the common clock framework.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/debugfs.h>
+#include <linux/kstrtox.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/seq_file.h>
+
+#include "clk-debug.h"
+
+MODULE_IMPORT_NS("clk-debug");
+
+static struct dentry *rootdir;
+
+static void clk_summary_show_one(struct clk_hw *hw, int level, int next_level,
+				 bool first, void *data)
+{
+	struct seq_file *s = data;
+	int enable;
+	int phase;
+	struct clk *clk_user = NULL;
+	int multi_node = 0;
+
+	seq_printf(s, "%*s%-*s %-7d %-8d %-8d %-11lu %-10lu ",
+		   level * 3 + 1, "",
+		   35 - level * 3, clk_hw_get_name(hw),
+		   clk_hw_enable_count(hw), clk_hw_prepare_count(hw),
+		   clk_hw_protect_count(hw),
+		   clk_hw_get_rate_recalc(hw),
+		   clk_hw_get_accuracy_recalc(hw));
+
+	phase = clk_hw_get_phase(hw);
+	if (phase >= 0)
+		seq_printf(s, "%-5d", phase);
+	else
+		seq_puts(s, "-----");
+
+	seq_printf(s, " %-6d", clk_hw_get_scaled_duty_cycle(hw, 100000));
+
+	enable = clk_hw_enable_state(hw);
+	if (enable >= 0)
+		seq_printf(s, " %5c ", enable ? 'Y' : 'N');
+	else
+		seq_printf(s, " %5c ", '?');
+
+	while ((clk_user = clk_hw_next_consumer(hw, clk_user))) {
+		seq_printf(s, "%*s%-*s  %-25s\n",
+			   level * 3 + 2 + 105 * multi_node, "",
+			   30,
+			   clk_dev_id(clk_user) ? : "deviceless",
+			   clk_con_id(clk_user) ? : "no_connection_id");
+
+		multi_node = 1;
+	}
+}
+
+static int clk_summary_show(struct seq_file *s, void *data)
+{
+	bool orphan_only = s->private;
+
+	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware                            connection\n");
+	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable   consumer                         id\n");
+	seq_puts(s, "---------------------------------------------------------------------------------------------------------------------------------------------\n");
+
+	return clk_show_tree(clk_summary_show_one, s, orphan_only);
+}
+DEFINE_SHOW_ATTRIBUTE(clk_summary);
+
+static void clk_dump_one(struct clk_hw *hw, int level, int next_level, bool first, void *data)
+{
+	struct seq_file *s = data;
+	int phase;
+	unsigned long min_rate, max_rate;
+
+	clk_hw_get_rate_range(hw, &min_rate, &max_rate);
+
+	if (!first)
+		seq_putc(s, ',');
+
+	/* This should be JSON format, i.e. elements separated with a comma */
+	seq_printf(s, "\"%s\": { ", clk_hw_get_name(hw));
+	seq_printf(s, "\"enable_count\": %d,", clk_hw_enable_count(hw));
+	seq_printf(s, "\"prepare_count\": %d,", clk_hw_prepare_count(hw));
+	seq_printf(s, "\"protect_count\": %d,", clk_hw_protect_count(hw));
+	seq_printf(s, "\"rate\": %lu,", clk_hw_get_rate_recalc(hw));
+	seq_printf(s, "\"min_rate\": %lu,", min_rate);
+	seq_printf(s, "\"max_rate\": %lu,", max_rate);
+	seq_printf(s, "\"accuracy\": %lu,", clk_hw_get_accuracy_recalc(hw));
+	phase = clk_hw_get_phase(hw);
+	if (phase >= 0)
+		seq_printf(s, "\"phase\": %d,", phase);
+	seq_printf(s, "\"duty_cycle\": %u",
+		   clk_hw_get_scaled_duty_cycle(hw, 100000));
+
+	while (level-- >= next_level)
+		seq_putc(s, '}');
+}
+
+static int clk_dump_show(struct seq_file *s, void *data)
+{
+	bool orphan_only = s->private;
+
+	seq_putc(s, '{');
+	clk_show_tree(clk_dump_one, s, orphan_only);
+	seq_puts(s, "}\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_dump);
+
+/*
+ * This can be dangerous, therefore don't provide any real compile time
+ * configuration option for this feature.
+ * People who want to use this will need to modify the source code directly.
+ */
+#undef CLOCK_ALLOW_WRITE_DEBUGFS
+#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
+static int clk_rate_set(void *data, u64 val)
+{
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_rate_set");
+	int ret;
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	ret = clk_set_rate(clk, val);
+	clk_put(clk);
+
+	return ret;
+}
+
+#define clk_rate_mode	0644
+
+static int clk_phase_set(void *data, u64 val)
+{
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_phase_set");
+	int degrees = do_div(val, 360);
+	int ret;
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	ret = clk_set_phase(clk, degrees);
+	clk_put(clk);
+
+	return ret;
+}
+
+#define clk_phase_mode	0644
+
+static int clk_prepare_enable_set(void *data, u64 val)
+{
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_prepare_enable_set");
+	int ret = 0;
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	if (val)
+		ret = clk_prepare_enable(clk);
+	else
+		clk_disable_unprepare(clk);
+	clk_put(clk);
+
+	return ret;
+}
+
+static int clk_prepare_enable_get(void *data, u64 *val)
+{
+	struct clk_hw *hw = data;
+
+	*val = clk_hw_is_prepared(hw) && clk_hw_is_enabled(hw);
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(clk_prepare_enable_fops, clk_prepare_enable_get,
+			 clk_prepare_enable_set, "%llu\n");
+
+#else
+#define clk_rate_set	NULL
+#define clk_rate_mode	0444
+
+#define clk_phase_set	NULL
+#define clk_phase_mode	0644
+#endif
+
+static int clk_rate_get(void *data, u64 *val)
+{
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_rate_get");
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	*val = clk_get_rate(clk);
+	clk_put(clk);
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(clk_rate_fops, clk_rate_get, clk_rate_set, "%llu\n");
+
+static int clk_phase_get(void *data, u64 *val)
+{
+	struct clk_hw *hw = data;
+	struct clk *clk = clk_hw_get_clk(hw, "debugfs_phase_get");
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	*val = clk_get_phase(clk);
+	clk_put(clk);
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(clk_phase_fops, clk_phase_get, clk_phase_set, "%llu\n");
+
+static const struct {
+	unsigned long flag;
+	const char *name;
+} clk_flags[] = {
+#define ENTRY(f) { f, #f }
+	ENTRY(CLK_SET_RATE_GATE),
+	ENTRY(CLK_SET_PARENT_GATE),
+	ENTRY(CLK_SET_RATE_PARENT),
+	ENTRY(CLK_IGNORE_UNUSED),
+	ENTRY(CLK_GET_RATE_NOCACHE),
+	ENTRY(CLK_SET_RATE_NO_REPARENT),
+	ENTRY(CLK_GET_ACCURACY_NOCACHE),
+	ENTRY(CLK_RECALC_NEW_RATES),
+	ENTRY(CLK_SET_RATE_UNGATE),
+	ENTRY(CLK_IS_CRITICAL),
+	ENTRY(CLK_OPS_PARENT_ENABLE),
+	ENTRY(CLK_DUTY_CYCLE_PARENT),
+#undef ENTRY
+};
+
+static int clk_flags_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	unsigned long flags = clk_hw_get_flags(hw);
+	unsigned int i;
+
+	for (i = 0; flags && i < ARRAY_SIZE(clk_flags); i++) {
+		if (flags & clk_flags[i].flag) {
+			seq_printf(s, "%s\n", clk_flags[i].name);
+			flags &= ~clk_flags[i].flag;
+		}
+	}
+	if (flags) {
+		/* Unknown flags */
+		seq_printf(s, "0x%lx\n", flags);
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_flags);
+
+static int possible_parents_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	int i;
+
+	for (i = 0; i < clk_hw_get_num_parents(hw) - 1; i++)
+		clk_hw_show_parent_by_index(s, hw, i, ' ');
+
+	clk_hw_show_parent_by_index(s, hw, i, '\n');
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(possible_parents);
+
+static int current_parent_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	struct clk_hw *parent = clk_hw_get_parent(hw);
+
+	if (parent)
+		seq_printf(s, "%s\n", clk_hw_get_name(parent));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(current_parent);
+
+#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
+static ssize_t current_parent_write(struct file *file, const char __user *ubuf,
+				    size_t count, loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct clk *clk, *parent;
+	struct clk_hw *hw = s->private;
+	struct clk_hw *parent_hw;
+	u8 idx;
+	int ret;
+
+	ret = kstrtou8_from_user(ubuf, count, 0, &idx);
+	if (ret < 0)
+		return ret;
+
+	parent_hw = clk_hw_get_parent_by_index(hw, idx);
+	if (!parent_hw)
+		return -ENOENT;
+
+	clk = clk_hw_get_clk(hw, "debugfs_write");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
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
+}
+
+static const struct file_operations current_parent_rw_fops = {
+	.open		= current_parent_open,
+	.write		= current_parent_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
+static int clk_duty_cycle_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	struct clk_duty duty = { };
+
+	clk_hw_get_duty(hw, &duty);
+
+	seq_printf(s, "%u/%u\n", duty.num, duty.den);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_duty_cycle);
+
+static int clk_min_rate_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	unsigned long min_rate, max_rate;
+
+	clk_debug_get_rate_range(hw, &min_rate, &max_rate);
+	seq_printf(s, "%lu\n", min_rate);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_min_rate);
+
+static int clk_max_rate_show(struct seq_file *s, void *data)
+{
+	struct clk_hw *hw = s->private;
+	unsigned long min_rate, max_rate;
+
+	clk_debug_get_rate_range(hw, &min_rate, &max_rate);
+	seq_printf(s, "%lu\n", max_rate);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(clk_max_rate);
+
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
+{
+	struct dentry *root;
+
+	root = debugfs_create_dir(clk_hw_get_name(hw), rootdir);
+
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
+#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
+	debugfs_create_file("clk_prepare_enable", 0644, root, hw,
+			    &clk_prepare_enable_fops);
+
+	if (clk_hw_get_num_parents(hw) > 1)
+		debugfs_create_file("clk_parent", 0644, root, hw,
+				    &current_parent_rw_fops);
+	else
+#endif
+	if (clk_hw_get_num_parents(hw) > 0)
+		debugfs_create_file("clk_parent", 0444, root, hw,
+				    &current_parent_fops);
+
+	if (clk_hw_get_num_parents(hw) > 1)
+		debugfs_create_file("clk_possible_parents", 0444, root, hw,
+				    &possible_parents_fops);
+
+	return root;
+}
+
+/**
+ * clk_debug_init - lazily populate the debugfs clk directory
+ *
+ * clks are often initialized very early during boot before memory can be
+ * dynamically allocated and well before debugfs is setup. This function
+ * populates the debugfs clk directory once at boot-time when we know that
+ * debugfs is setup. It should only be called once at boot-time, all other clks
+ * added dynamically will be done so with clk_debug_register.
+ */
+static int __init clk_debug_init(void)
+{
+#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
+	pr_warn("\n");
+	pr_warn("********************************************************************\n");
+	pr_warn("**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE           **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("**  WRITEABLE clk DebugFS SUPPORT HAS BEEN ENABLED IN THIS KERNEL **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("** This means that this kernel is built to expose clk operations  **\n");
+	pr_warn("** such as parent or rate setting, enabling, disabling, etc.      **\n");
+	pr_warn("** to userspace, which may compromise security on your system.    **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("** If you see this message and you are not debugging the          **\n");
+	pr_warn("** kernel, report this immediately to your vendor!                **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE           **\n");
+	pr_warn("********************************************************************\n");
+#endif
+
+	rootdir = debugfs_create_dir("clk", NULL);
+
+	debugfs_create_file("clk_summary", 0444, rootdir, (void *)0UL,
+			    &clk_summary_fops);
+	debugfs_create_file("clk_dump", 0444, rootdir, (void *)0UL,
+			    &clk_dump_fops);
+	debugfs_create_file("clk_orphan_summary", 0444, rootdir, (void *)1UL,
+			    &clk_summary_fops);
+	debugfs_create_file("clk_orphan_dump", 0444, rootdir, (void *)1UL,
+			    &clk_dump_fops);
+
+	clk_hw_debug_for_each_init(clk_hw_debug_create_one);
+
+	return 0;
+}
+late_initcall(clk_debug_init);
+
+static void __exit clk_debug_exit(void)
+{
+	clk_hw_debug_exit();
+	debugfs_remove_recursive(rootdir);
+}
+module_exit(clk_debug_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/clk/clk-debug.h b/drivers/clk/clk-debug.h
new file mode 100644
index 000000000000..007fa32237c0
--- /dev/null
+++ b/drivers/clk/clk-debug.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+struct clk;
+struct clk_duty;
+struct clk_hw;
+struct seq_file;
+
+extern int clk_hw_enable_state(struct clk_hw *hw);
+extern unsigned int clk_hw_enable_count(struct clk_hw *hw);
+extern unsigned int clk_hw_prepare_count(struct clk_hw *hw);
+extern unsigned int clk_hw_protect_count(struct clk_hw *hw);
+extern int clk_hw_get_phase(struct clk_hw *hw);
+extern int clk_hw_get_scaled_duty_cycle(struct clk_hw *hw, unsigned int scale);
+extern void clk_hw_get_duty(struct clk_hw *hw, struct clk_duty *duty);
+extern unsigned long clk_hw_get_rate_recalc(struct clk_hw *hw);
+extern long clk_hw_get_accuracy_recalc(struct clk_hw *hw);
+extern void clk_debug_get_rate_range(struct clk_hw *hw, unsigned long *min_rate,
+				     unsigned long *max_rate);
+extern unsigned int clk_hw_notifier_count(struct clk_hw *hw);
+
+extern const char *clk_con_id(struct clk *clk);
+extern const char *clk_dev_id(struct clk *clk);
+extern struct clk *clk_hw_next_consumer(struct clk_hw *hw, struct clk *prev);
+extern void clk_hw_show_parent_by_index(struct seq_file *s, struct clk_hw *hw,
+					unsigned int i, char terminator);
+
+extern int clk_show_tree(void (*show_fn)(struct clk_hw *hw, int level,
+					 int next_level, bool first,
+					 void *data),
+			 void *data, bool orphan_only);
+
+extern void clk_hw_debug_for_each_init(struct dentry *(*fn)(struct clk_hw *hw));
+extern void clk_hw_debug_exit(void);
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 37c7963d685f..a3529595e71b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -23,6 +23,7 @@
 #include <linux/clkdev.h>
 
 #include "clk.h"
+#include "clk-debug.h"
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
@@ -819,13 +820,14 @@ void clk_hw_get_rate_range(struct clk_hw *hw, unsigned long *min_rate,
 }
 EXPORT_SYMBOL_GPL(clk_hw_get_rate_range);
 
-static void clk_debug_get_rate_range(struct clk_hw *hw, unsigned long *min_rate,
-				     unsigned long *max_rate)
+void clk_debug_get_rate_range(struct clk_hw *hw, unsigned long *min_rate,
+			      unsigned long *max_rate)
 {
 	clk_prepare_lock();
 	clk_hw_get_rate_range(hw, min_rate, max_rate);
 	clk_prepare_unlock();
 }
+EXPORT_SYMBOL_NS_GPL(clk_debug_get_rate_range, "clk-debug");
 
 static bool clk_core_check_boundaries(struct clk_core *core,
 				      unsigned long min_rate,
@@ -1906,10 +1908,11 @@ static long clk_core_get_accuracy_recalc(struct clk_core *core)
 	return clk_core_get_accuracy_no_lock(core);
 }
 
-static long clk_hw_get_accuracy_recalc(struct clk_hw *hw)
+long clk_hw_get_accuracy_recalc(struct clk_hw *hw)
 {
 	return clk_core_get_accuracy_recalc(hw->core);
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_get_accuracy_recalc, "clk-debug");
 
 /**
  * clk_get_accuracy - return the accuracy of clk
@@ -1997,10 +2000,11 @@ static unsigned long clk_core_get_rate_recalc(struct clk_core *core)
 	return clk_core_get_rate_nolock(core);
 }
 
-static unsigned long clk_hw_get_rate_recalc(struct clk_hw *hw)
+unsigned long clk_hw_get_rate_recalc(struct clk_hw *hw)
 {
 	return clk_core_get_rate_recalc(hw->core);
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_get_rate_recalc, "clk-debug");
 
 /**
  * clk_get_rate - return the rate of clk
@@ -3078,10 +3082,11 @@ static int clk_core_get_phase(struct clk_core *core)
 	return ret;
 }
 
-static int clk_hw_get_phase(struct clk_hw *hw)
+int clk_hw_get_phase(struct clk_hw *hw)
 {
 	return clk_core_get_phase(hw->core);
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_get_phase, "clk-debug");
 
 /**
  * clk_get_phase - return the phase shift of a clock signal
@@ -3250,11 +3255,11 @@ static int clk_core_get_scaled_duty_cycle(struct clk_core *core,
 	return ret;
 }
 
-static int clk_hw_get_scaled_duty_cycle(struct clk_hw *hw,
-					unsigned int scale)
+int clk_hw_get_scaled_duty_cycle(struct clk_hw *hw, unsigned int scale)
 {
 	return clk_core_get_scaled_duty_cycle(hw->core, scale);
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_get_scaled_duty_cycle, "clk-debug");
 
 /**
  * clk_get_scaled_duty_cycle - return the duty cycle ratio of a clock signal
@@ -3307,11 +3312,9 @@ EXPORT_SYMBOL_GPL(clk_is_match);
 
 /***        debugfs support        ***/
 
-#ifdef CONFIG_DEBUG_FS
+#if IS_ENABLED(CONFIG_COMMON_CLK_DEBUG)
 #include <linux/debugfs.h>
 
-static struct dentry *rootdir;
-static int inited = 0;
 static DEFINE_MUTEX(clk_debug_lock);
 static HLIST_HEAD(clk_debug_list);
 
@@ -3320,7 +3323,7 @@ static HLIST_HEAD(clk_debug_list);
  * 0: Disabled in hardware
  * -1: Unknown enable state
  */
-static int clk_hw_enable_state(struct clk_hw *hw)
+int clk_hw_enable_state(struct clk_hw *hw)
 {
 	struct clk_core *core = hw->core;
 
@@ -3331,39 +3334,58 @@ static int clk_hw_enable_state(struct clk_hw *hw)
 
 	return -1;
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_enable_state, "clk-debug");
 
-static unsigned int clk_hw_enable_count(struct clk_hw *hw)
+unsigned int clk_hw_enable_count(struct clk_hw *hw)
 {
 	return hw->core->enable_count;
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_enable_count, "clk-debug");
 
-static unsigned int clk_hw_prepare_count(struct clk_hw *hw)
+unsigned int clk_hw_prepare_count(struct clk_hw *hw)
 {
 	return hw->core->prepare_count;
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_prepare_count, "clk-debug");
 
-static unsigned int clk_hw_protect_count(struct clk_hw *hw)
+unsigned int clk_hw_protect_count(struct clk_hw *hw)
 {
 	return hw->core->protect_count;
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_protect_count, "clk-debug");
 
-static const char *clk_con_id(struct clk *clk)
+const char *clk_con_id(struct clk *clk)
 {
 	return clk->con_id;
 }
+EXPORT_SYMBOL_NS_GPL(clk_con_id, "clk-debug");
 
-static const char *clk_dev_id(struct clk *clk)
+const char *clk_dev_id(struct clk *clk)
 {
 	return clk->dev_id;
 }
+EXPORT_SYMBOL_NS_GPL(clk_dev_id, "clk-debug");
 
-static struct clk *clk_hw_next_consumer(struct clk_hw *hw, struct clk *prev)
+struct clk *clk_hw_next_consumer(struct clk_hw *hw, struct clk *prev)
 {
 	if (prev)
 		return hlist_entry_safe(prev->clks_node.next, struct clk, clks_node);
 
 	return hlist_entry_safe(hw->core->clks.first, struct clk, clks_node);
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_next_consumer, "clk-debug");
+
+void clk_hw_get_duty(struct clk_hw *hw, struct clk_duty *duty)
+{
+	memcpy(duty, &hw->core->duty, sizeof(*duty));
+}
+EXPORT_SYMBOL_NS_GPL(clk_hw_get_duty, "clk-debug");
+
+unsigned int clk_hw_notifier_count(struct clk_hw *hw)
+{
+	return hw->core->notifier_count;
+}
+EXPORT_SYMBOL_NS_GPL(clk_hw_notifier_count, "clk-debug");
 
 static void clk_walk_trees(struct hlist_head *list, bool only_orphans)
 {
@@ -3393,10 +3415,9 @@ static void clk_walk_trees(struct hlist_head *list, bool only_orphans)
 	}
 }
 
-static int clk_show_tree(void (*show_fn)(struct clk_hw *hw, int level,
-					 int next_level, bool first,
-					 void *data),
-			 void *data, bool orphan_only)
+int clk_show_tree(void (*show_fn)(struct clk_hw *hw, int level, int next_level,
+				  bool first, void *data),
+		  void *data, bool orphan_only)
 {
 	struct clk_core *core, *parent;
 	struct hlist_node *tmp;
@@ -3439,257 +3460,10 @@ static int clk_show_tree(void (*show_fn)(struct clk_hw *hw, int level,
 
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(clk_show_tree, "clk-debug");
 
-static void clk_summary_show_one(struct clk_hw *hw, int level, int next_level,
-				 bool first, void *data)
-{
-	struct seq_file *s = data;
-	int enable;
-	int phase;
-	struct clk *clk_user = NULL;
-	int multi_node = 0;
-
-	seq_printf(s, "%*s%-*s %-7d %-8d %-8d %-11lu %-10lu ",
-		   level * 3 + 1, "",
-		   35 - level * 3, clk_hw_get_name(hw),
-		   clk_hw_enable_count(hw), clk_hw_prepare_count(hw),
-		   clk_hw_protect_count(hw),
-		   clk_hw_get_rate_recalc(hw),
-		   clk_hw_get_accuracy_recalc(hw));
-
-	phase = clk_hw_get_phase(hw);
-	if (phase >= 0)
-		seq_printf(s, "%-5d", phase);
-	else
-		seq_puts(s, "-----");
-
-	seq_printf(s, " %-6d", clk_hw_get_scaled_duty_cycle(hw, 100000));
-
-	enable = clk_hw_enable_state(hw);
-	if (enable >= 0)
-		seq_printf(s, " %5c ", enable ? 'Y' : 'N');
-	else
-		seq_printf(s, " %5c ", '?');
-
-	while ((clk_user = clk_hw_next_consumer(hw, clk_user))) {
-		seq_printf(s, "%*s%-*s  %-25s\n",
-			   level * 3 + 2 + 105 * multi_node, "",
-			   30,
-			   clk_dev_id(clk_user) ? : "deviceless",
-			   clk_con_id(clk_user) ? : "no_connection_id");
-
-		multi_node = 1;
-	}
-}
-
-static int clk_summary_show(struct seq_file *s, void *data)
-{
-	bool orphan_only = s->private;
-
-	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware                            connection\n");
-	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable   consumer                         id\n");
-	seq_puts(s, "---------------------------------------------------------------------------------------------------------------------------------------------\n");
-
-	return clk_show_tree(clk_summary_show_one, s, orphan_only);
-}
-DEFINE_SHOW_ATTRIBUTE(clk_summary);
-
-static void clk_dump_one(struct clk_hw *hw, int level, int next_level, bool first, void *data)
-{
-	struct seq_file *s = data;
-	int phase;
-	unsigned long min_rate, max_rate;
-
-	clk_hw_get_rate_range(hw, &min_rate, &max_rate);
-
-	if (!first)
-		seq_putc(s, ',');
-
-	/* This should be JSON format, i.e. elements separated with a comma */
-	seq_printf(s, "\"%s\": { ", clk_hw_get_name(hw));
-	seq_printf(s, "\"enable_count\": %d,", clk_hw_enable_count(hw));
-	seq_printf(s, "\"prepare_count\": %d,", clk_hw_prepare_count(hw));
-	seq_printf(s, "\"protect_count\": %d,", clk_hw_protect_count(hw));
-	seq_printf(s, "\"rate\": %lu,", clk_hw_get_rate_recalc(hw));
-	seq_printf(s, "\"min_rate\": %lu,", min_rate);
-	seq_printf(s, "\"max_rate\": %lu,", max_rate);
-	seq_printf(s, "\"accuracy\": %lu,", clk_hw_get_accuracy_recalc(hw));
-	phase = clk_hw_get_phase(hw);
-	if (phase >= 0)
-		seq_printf(s, "\"phase\": %d,", phase);
-	seq_printf(s, "\"duty_cycle\": %u",
-		   clk_hw_get_scaled_duty_cycle(hw, 100000));
-
-	while (level-- >= next_level)
-		seq_putc(s, '}');
-}
-
-static int clk_dump_show(struct seq_file *s, void *data)
-{
-	bool orphan_only = s->private;
-
-	seq_putc(s, '{');
-	clk_show_tree(clk_dump_one, s, orphan_only);
-	seq_puts(s, "}\n");
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_dump);
-
-/*
- * This can be dangerous, therefore don't provide any real compile time
- * configuration option for this feature.
- * People who want to use this will need to modify the source code directly.
- */
-#undef CLOCK_ALLOW_WRITE_DEBUGFS
-#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
-static int clk_rate_set(void *data, u64 val)
-{
-	struct clk_hw *hw = data;
-	struct clk *clk = clk_hw_get_clk(hw, "debugfs_rate_set");
-	int ret;
-
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	ret = clk_set_rate(clk, val);
-	clk_put(clk);
-
-	return ret;
-}
-
-#define clk_rate_mode	0644
-
-static int clk_phase_set(void *data, u64 val)
-{
-	struct clk_hw *hw = data;
-	struct clk *clk = clk_hw_get_clk(hw, "debugfs_phase_set");
-	int degrees = do_div(val, 360);
-	int ret;
-
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	ret = clk_set_phase(clk, degrees);
-	clk_put(clk);
-
-	return ret;
-}
-
-#define clk_phase_mode	0644
-
-static int clk_prepare_enable_set(void *data, u64 val)
-{
-	struct clk_hw *hw = data;
-	struct clk *clk = clk_hw_get_clk(hw, "debugfs_prepare_enable_set");
-	int ret = 0;
-
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	if (val)
-		ret = clk_prepare_enable(clk);
-	else
-		clk_disable_unprepare(clk);
-	clk_put(clk);
-
-	return ret;
-}
-
-static int clk_prepare_enable_get(void *data, u64 *val)
-{
-	struct clk_hw *hw = data;
-
-	*val = clk_hw_is_prepared(hw) && clk_hw_is_enabled(hw);
-	return 0;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(clk_prepare_enable_fops, clk_prepare_enable_get,
-			 clk_prepare_enable_set, "%llu\n");
-
-#else
-#define clk_rate_set	NULL
-#define clk_rate_mode	0444
-
-#define clk_phase_set	NULL
-#define clk_phase_mode	0644
-#endif
-
-static int clk_rate_get(void *data, u64 *val)
-{
-	struct clk_hw *hw = data;
-	struct clk *clk = clk_hw_get_clk(hw, "debugfs_rate_get");
-
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	*val = clk_get_rate(clk);
-	clk_put(clk);
-
-	return 0;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(clk_rate_fops, clk_rate_get, clk_rate_set, "%llu\n");
-
-static int clk_phase_get(void *data, u64 *val)
-{
-	struct clk_hw *hw = data;
-	struct clk *clk = clk_hw_get_clk(hw, "debugfs_phase_get");
-
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	*val = clk_get_phase(clk);
-	clk_put(clk);
-
-	return 0;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(clk_phase_fops, clk_phase_get, clk_phase_set, "%llu\n");
-
-static const struct {
-	unsigned long flag;
-	const char *name;
-} clk_flags[] = {
-#define ENTRY(f) { f, #f }
-	ENTRY(CLK_SET_RATE_GATE),
-	ENTRY(CLK_SET_PARENT_GATE),
-	ENTRY(CLK_SET_RATE_PARENT),
-	ENTRY(CLK_IGNORE_UNUSED),
-	ENTRY(CLK_GET_RATE_NOCACHE),
-	ENTRY(CLK_SET_RATE_NO_REPARENT),
-	ENTRY(CLK_GET_ACCURACY_NOCACHE),
-	ENTRY(CLK_RECALC_NEW_RATES),
-	ENTRY(CLK_SET_RATE_UNGATE),
-	ENTRY(CLK_IS_CRITICAL),
-	ENTRY(CLK_OPS_PARENT_ENABLE),
-	ENTRY(CLK_DUTY_CYCLE_PARENT),
-#undef ENTRY
-};
-
-static int clk_flags_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	unsigned long flags = clk_hw_get_flags(hw);
-	unsigned int i;
-
-	for (i = 0; flags && i < ARRAY_SIZE(clk_flags); i++) {
-		if (flags & clk_flags[i].flag) {
-			seq_printf(s, "%s\n", clk_flags[i].name);
-			flags &= ~clk_flags[i].flag;
-		}
-	}
-	if (flags) {
-		/* Unknown flags */
-		seq_printf(s, "0x%lx\n", flags);
-	}
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_flags);
-
-static void clk_hw_show_parent_by_index(struct seq_file *s, struct clk_hw *hw,
-					unsigned int i, char terminator)
+void clk_hw_show_parent_by_index(struct seq_file *s, struct clk_hw *hw,
+				 unsigned int i, char terminator)
 {
 	struct clk_hw *parent;
 	struct clk_core *core = hw->core;
@@ -3725,227 +3499,15 @@ static void clk_hw_show_parent_by_index(struct seq_file *s, struct clk_hw *hw,
 
 	seq_putc(s, terminator);
 }
+EXPORT_SYMBOL_NS_GPL(clk_hw_show_parent_by_index, "clk-debug");
 
-static int possible_parents_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	int i;
-
-	for (i = 0; i < clk_hw_get_num_parents(hw) - 1; i++)
-		clk_hw_show_parent_by_index(s, hw, i, ' ');
-
-	clk_hw_show_parent_by_index(s, hw, i, '\n');
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(possible_parents);
-
-static int current_parent_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	struct clk_hw *parent = clk_hw_get_parent(hw);
-
-	if (parent)
-		seq_printf(s, "%s\n", clk_hw_get_name(parent));
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(current_parent);
-
-#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
-static ssize_t current_parent_write(struct file *file, const char __user *ubuf,
-				    size_t count, loff_t *ppos)
-{
-	struct seq_file *s = file->private_data;
-	struct clk *clk, *parent;
-	struct clk_hw *hw = s->private;
-	struct clk_hw *parent_hw;
-	u8 idx;
-	int ret;
-
-	ret = kstrtou8_from_user(ubuf, count, 0, &idx);
-	if (ret < 0)
-		return ret;
-
-	parent_hw = clk_hw_get_parent_by_index(hw, idx);
-	if (!parent_hw)
-		return -ENOENT;
-
-	clk = clk_hw_get_clk(hw, "debugfs_write");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	parent = clk_hw_get_clk(parent_hw, "debugfs_write");
-	if (IS_ERR(parent)) {
-		ret = PTR_ERR(parent);
-		goto err;
-	}
-
-	ret = clk_set_parent(clk, parent);
-	if (!ret)
-		ret = count;
-
-	clk_put(parent);
-err:
-	clk_put(clk);
-	return ret;
-}
-
-static const struct file_operations current_parent_rw_fops = {
-	.open		= current_parent_open,
-	.write		= current_parent_write,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif
-
-static void clk_hw_get_duty(struct clk_hw *hw, struct clk_duty *duty)
-{
-	memcpy(duty, &hw->core->duty, sizeof(*duty));
-}
-
-static int clk_duty_cycle_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	struct clk_duty duty = { };
-
-	clk_hw_get_duty(hw, &duty);
-
-	seq_printf(s, "%u/%u\n", duty.num, duty.den);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_duty_cycle);
-
-static int clk_min_rate_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	unsigned long min_rate, max_rate;
-
-	clk_debug_get_rate_range(hw, &min_rate, &max_rate);
-	seq_printf(s, "%lu\n", min_rate);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_min_rate);
-
-static int clk_max_rate_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	unsigned long min_rate, max_rate;
-
-	clk_debug_get_rate_range(hw, &min_rate, &max_rate);
-	seq_printf(s, "%lu\n", max_rate);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_max_rate);
-
-static int clk_accuracy_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-	struct clk *clk = clk_hw_get_clk(hw, "debugfs_accuracy");
-	unsigned long accuracy;
-
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	accuracy = clk_get_accuracy(clk);
-	seq_printf(s, "%lu\n", accuracy);
-	clk_put(clk);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_accuracy);
-
-static int clk_prepare_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-
-	seq_printf(s, "%u\n", clk_hw_prepare_count(hw));
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_prepare);
-
-static int clk_enable_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-
-	seq_printf(s, "%u\n", clk_hw_enable_count(hw));
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_enable);
-
-static int clk_protect_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-
-	seq_printf(s, "%u\n", clk_hw_protect_count(hw));
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_protect);
-
-static unsigned int clk_hw_notifier_count(struct clk_hw *hw)
-{
-	return hw->core->notifier_count;
-}
-
-static int clk_notifier_show(struct seq_file *s, void *data)
-{
-	struct clk_hw *hw = s->private;
-
-	seq_printf(s, "%u\n", clk_hw_notifier_count(hw));
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(clk_notifier);
-
-static struct dentry *clk_hw_debug_create_one(struct clk_hw *hw)
-{
-	struct dentry *root;
-
-	root = debugfs_create_dir(clk_hw_get_name(hw), rootdir);
-
-	debugfs_create_file("clk_rate", clk_rate_mode, root, hw, &clk_rate_fops);
-	debugfs_create_file("clk_min_rate", 0444, root, hw, &clk_min_rate_fops);
-	debugfs_create_file("clk_max_rate", 0444, root, hw, &clk_max_rate_fops);
-	debugfs_create_file("clk_accuracy", 0444, root, hw, &clk_accuracy_fops);
-	debugfs_create_file("clk_phase", clk_phase_mode, root, hw, &clk_phase_fops);
-	debugfs_create_file("clk_flags", 0444, root, hw, &clk_flags_fops);
-	debugfs_create_file("clk_prepare_count", 0444, root, hw, &clk_prepare_fops);
-	debugfs_create_file("clk_enable_count", 0444, root, hw, &clk_enable_fops);
-	debugfs_create_file("clk_protect_count", 0444, root, hw, &clk_protect_fops);
-	debugfs_create_file("clk_notifier_count", 0444, root, hw, &clk_notifier_fops);
-	debugfs_create_file("clk_duty_cycle", 0444, root, hw, &clk_duty_cycle_fops);
-#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
-	debugfs_create_file("clk_prepare_enable", 0644, root, hw,
-			    &clk_prepare_enable_fops);
-
-	if (clk_hw_get_num_parents(hw) > 1)
-		debugfs_create_file("clk_parent", 0644, root, hw,
-				    &current_parent_rw_fops);
-	else
-#endif
-	if (clk_hw_get_num_parents(hw) > 0)
-		debugfs_create_file("clk_parent", 0444, root, hw,
-				    &current_parent_fops);
-
-	if (clk_hw_get_num_parents(hw) > 1)
-		debugfs_create_file("clk_possible_parents", 0444, root, hw,
-				    &possible_parents_fops);
-
-	return root;
-}
+static struct dentry *(*clk_hw_debug_create_one)(struct clk_hw *hw);
 
 static void clk_core_debug_create_one(struct clk_core *core)
 {
 	struct clk_hw *hw = core->hw;
 
-	if (!inited)
+	if (!clk_hw_debug_create_one)
 		return;
 
 	core->dentry = clk_hw_debug_create_one(hw);
@@ -3969,6 +3531,13 @@ static void clk_debug_register(struct clk_core *core)
 	mutex_unlock(&clk_debug_lock);
 }
 
+static void clk_core_debug_remove_one(struct clk_core *core)
+{
+	hlist_del_init(&core->debug_node);
+	debugfs_remove_recursive(core->dentry);
+	core->dentry = NULL;
+}
+
  /**
  * clk_debug_unregister - remove a clk node from the debugfs clk directory
  * @core: the clk being removed from the debugfs clk directory
@@ -3980,68 +3549,36 @@ static void clk_debug_register(struct clk_core *core)
 static void clk_debug_unregister(struct clk_core *core)
 {
 	mutex_lock(&clk_debug_lock);
-	hlist_del_init(&core->debug_node);
-	debugfs_remove_recursive(core->dentry);
-	core->dentry = NULL;
+	clk_core_debug_remove_one(core);
 	mutex_unlock(&clk_debug_lock);
 }
 
-/**
- * clk_debug_init - lazily populate the debugfs clk directory
- *
- * clks are often initialized very early during boot before memory can be
- * dynamically allocated and well before debugfs is setup. This function
- * populates the debugfs clk directory once at boot-time when we know that
- * debugfs is setup. It should only be called once at boot-time, all other clks
- * added dynamically will be done so with clk_debug_register.
- */
-static int __init clk_debug_init(void)
+void clk_hw_debug_for_each_init(struct dentry *(*fn)(struct clk_hw *hw))
 {
 	struct clk_core *core;
 
-#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
-	pr_warn("\n");
-	pr_warn("********************************************************************\n");
-	pr_warn("**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE           **\n");
-	pr_warn("**                                                                **\n");
-	pr_warn("**  WRITEABLE clk DebugFS SUPPORT HAS BEEN ENABLED IN THIS KERNEL **\n");
-	pr_warn("**                                                                **\n");
-	pr_warn("** This means that this kernel is built to expose clk operations  **\n");
-	pr_warn("** such as parent or rate setting, enabling, disabling, etc.      **\n");
-	pr_warn("** to userspace, which may compromise security on your system.    **\n");
-	pr_warn("**                                                                **\n");
-	pr_warn("** If you see this message and you are not debugging the          **\n");
-	pr_warn("** kernel, report this immediately to your vendor!                **\n");
-	pr_warn("**                                                                **\n");
-	pr_warn("**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE           **\n");
-	pr_warn("********************************************************************\n");
-#endif
-
-	rootdir = debugfs_create_dir("clk", NULL);
-
-	debugfs_create_file("clk_summary", 0444, rootdir, (void *)0UL,
-			    &clk_summary_fops);
-	debugfs_create_file("clk_dump", 0444, rootdir, (void *)0UL,
-			    &clk_dump_fops);
-	debugfs_create_file("clk_orphan_summary", 0444, rootdir, (void *)1UL,
-			    &clk_summary_fops);
-	debugfs_create_file("clk_orphan_dump", 0444, rootdir, (void *)1UL,
-			    &clk_dump_fops);
-
 	mutex_lock(&clk_debug_lock);
-	inited = 1;
+	clk_hw_debug_create_one = fn;
 	hlist_for_each_entry(core, &clk_debug_list, debug_node)
 		clk_core_debug_create_one(core);
 	mutex_unlock(&clk_debug_lock);
-
-	return 0;
 }
-late_initcall(clk_debug_init);
+EXPORT_SYMBOL_NS_GPL(clk_hw_debug_for_each_init, "clk-debug");
+
+void clk_hw_debug_exit(void)
+{
+	struct clk_core *core;
+
+	mutex_lock(&clk_debug_lock);
+	clk_hw_debug_create_one = NULL;
+	hlist_for_each_entry(core, &clk_debug_list, debug_node)
+		clk_core_debug_remove_one(core);
+	mutex_unlock(&clk_debug_lock);
+}
+EXPORT_SYMBOL_NS_GPL(clk_hw_debug_exit, "clk-debug");
 #else
 static inline void clk_debug_register(struct clk_core *core) { }
-static inline void clk_debug_unregister(struct clk_core *core)
-{
-}
+static inline void clk_debug_unregister(struct clk_core *core) { }
 #endif
 
 static void clk_core_reparent_orphans_nolock(void)
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

