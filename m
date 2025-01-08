Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF502AE8D;
	Wed,  8 Jan 2025 00:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736297936; cv=none; b=RHenNgvVOV6wtFZOBudlRpC0vB3+oKDWeZRfsxLDENIsyrULkDxnHDLPVWhYehDpoY8OSU40TpR7jJW9Xj/n3gPEQawT8Q/7tEidRDn2GlHuSn1AgFJnX47uK2e74dCeh5UPzC0wrb+hY0TIrF52GSFDb2ANW936p4JLOB19Sew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736297936; c=relaxed/simple;
	bh=tc1+ZtikjJOS4fHNg80I6c5UnBanl3/atrx9Cnr9TWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuK5PiE700Tjj/GJSpqzT8oaCF5jCo7t49p1e55gDSYGK6X/B/b/FhpNDzJDvjxV5mSoCNUkb5FlI1/iyAoRNgwcm49jLsjDUn4oOLNC7RGw/6v5Gr5YAVkRcO6Ib2pJnlyL13CdZZaSq3iLw71PRKGmRvZXFyWrAJ0RO9fnfO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmlutyXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmlutyXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A3C4CEDF;
	Wed,  8 Jan 2025 00:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736297936;
	bh=tc1+ZtikjJOS4fHNg80I6c5UnBanl3/atrx9Cnr9TWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmlutyXb68mKdGKRjQa61Iljjt3TC610fyIponekRDr2icx7GQN7ljaXZ4OWvwzgI
	 DATeF4aDGYiR+ljCVIO8unCjUjS4JHDTYq4E1YubqjGrngF6U9EqGZZLNPBZjgQKuz
	 53CnwYJGtxqo4tNVDD4ZK89EJyVi1nAgW0GJ7ILbNMSNMtREuapKcwU6Z0SBX7dHTe
	 nMZ7smNYlDiY8kbIBGVy1LnQxulvxGvV1nlaAkJEAFjc5D3BPnjQjY14wLtwwZUaHb
	 qWJIkELS5qVZ96AQ/i422D+/rQ4RV/ICsrr0lXCnoz+3M9eyljFIcLcpt2D4prcIPu
	 gIEcNe/AUyNZQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/4] clk: Prepare clk_debug_create_one() to be split off
Date: Tue,  7 Jan 2025 16:58:46 -0800
Message-ID: <20250108005854.2973184-2-sboyd@kernel.org>
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

In a later patch we're going to move clk_debug_create_one() to a
loadable kernel module. Prepare for that step by returning the dentry
created in there from the function and wrap that all up in a new
function, clk_core_debug_create_one(), that we can call in both places
the dentry is created. Similarly, don't pass the 'pdentry' argument to
clk_debug_create_one() because it's always the global 'rootdir', so just
use that where it is used instead of passing it. We can remove the NULL
checks too because we know the pointers are always valid.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bdc6e5b90da5..1a94a27194c9 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3705,14 +3705,11 @@ static int clk_max_rate_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(clk_max_rate);
 
-static void clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
+static struct dentry *clk_debug_create_one(struct clk_core *core)
 {
 	struct dentry *root;
 
-	if (!core || !pdentry)
-		return;
-
-	root = debugfs_create_dir(core->name, pdentry);
+	root = debugfs_create_dir(core->name, rootdir);
 	core->dentry = root;
 
 	debugfs_create_file("clk_rate", clk_rate_mode, root, core,
@@ -3746,8 +3743,19 @@ static void clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
 		debugfs_create_file("clk_possible_parents", 0444, root, core,
 				    &possible_parents_fops);
 
+	return root;
+}
+
+static void clk_core_debug_create_one(struct clk_core *core)
+{
+	struct clk_hw *hw = core->hw;
+
+	if (!inited)
+		return;
+
+	core->dentry = clk_debug_create_one(core);
 	if (core->ops->debug_init)
-		core->ops->debug_init(core->hw, core->dentry);
+		core->ops->debug_init(hw, core->dentry);
 }
 
 /**
@@ -3762,8 +3770,7 @@ static void clk_debug_register(struct clk_core *core)
 {
 	mutex_lock(&clk_debug_lock);
 	hlist_add_head(&core->debug_node, &clk_debug_list);
-	if (inited)
-		clk_debug_create_one(core, rootdir);
+	clk_core_debug_create_one(core);
 	mutex_unlock(&clk_debug_lock);
 }
 
@@ -3827,10 +3834,9 @@ static int __init clk_debug_init(void)
 			    &clk_dump_fops);
 
 	mutex_lock(&clk_debug_lock);
-	hlist_for_each_entry(core, &clk_debug_list, debug_node)
-		clk_debug_create_one(core, rootdir);
-
 	inited = 1;
+	hlist_for_each_entry(core, &clk_debug_list, debug_node)
+		clk_core_debug_create_one(core);
 	mutex_unlock(&clk_debug_lock);
 
 	return 0;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

