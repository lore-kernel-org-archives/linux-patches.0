Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6CD2C11F9;
	Thu, 28 May 2026 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999476; cv=none; b=i6BTs4xqvG6ScAR2sq0cx8LmzN1a1SArRPyDf6ba6jFWh5/3zGzmEWyzqbvaktUTf1pjPczQc2EN1Tb0raBkjnhgCm1kaarMWFmObzgOAi3Of8m6PySTw7VIUyE3CrfmJdsPTgngJ0v0TT1eP3xwRhNSodDsDMIQKXocx21QaYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999476; c=relaxed/simple;
	bh=+dijsxdvTUJYXqQXXOfQf2UXrj8t2ffa/5xsXu6H0p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYyvE3h3G2uq0dTm0kA7+TLW5RTEQ+rJzfkW9D9GnqV+SXzL88i7/265JguBn7BNq95vLSHJp7dFWBBCA2VAcmNUskHlInTmfzS0s14Ik1Ff97ci1QfRhZlB9hzxNqoNXKePv5YdJ84UEqj8eG5PuduXjaDL6wdWJlYctAhnIT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm0thQnX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm0thQnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7549D1F00A3A;
	Thu, 28 May 2026 20:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999475;
	bh=lvtaA0q0psWlSmC8eNriOejvCiBA2ETeqyG5yTDV5fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm0thQnX5mepHAtYLRdbiY4PPknCoXy4qrV0hzdWeCueDN9KyCBGLjaslDhyvxCXl
	 K9kxbrnwC1OOj+7Xa1V2JdIssmaocGnsQMzM8Xy25wM2TM0ZJhj1Gr/utSliGrZ5sC
	 ceNi+qmrpObBfB3rEk1WOJhnkwIKdc0VFSduMviA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/377] tracing/fprobe: Avoid kcalloc() in rcu_read_lock section
Date: Thu, 28 May 2026 21:45:11 +0200
Message-ID: <20260528194640.479942037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit aa72812b49104bb5a38272fc9541feb62ca6fd32 ]

fprobe_remove_node_in_module() is called under RCU read locked, but
this invokes kcalloc() if there are more than 8 fprobes installed
on the module. Sashiko warns it because kcalloc() can sleep [1].

 [1] https://sashiko.dev/#/patchset/177552432201.853249.5125045538812833325.stgit%40mhiramat.tok.corp.google.com

To fix this issue, expand the batch size to 128 and do not expand
the fprobe_addr_list, but just cancel walking on fprobe_ip_table,
update fgraph/ftrace_ops and retry the loop again.

Link: https://lore.kernel.org/all/177669367206.132053.1493637946869032744.stgit@mhiramat.tok.corp.google.com/

Fixes: 0de4c70d04a4 ("tracing: fprobe: use rhltable for fprobe_ip_table")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 0ac0058a74ac ("tracing/fprobe: Check the same type fprobe on table as the unregistered one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   92 ++++++++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 47 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -344,11 +344,10 @@ static bool fprobe_is_ftrace(struct fpro
 }
 
 #ifdef CONFIG_MODULES
-static void fprobe_set_ips(unsigned long *ips, unsigned int cnt, int remove,
-			   int reset)
+static void fprobe_remove_ips(unsigned long *ips, unsigned int cnt)
 {
-	ftrace_set_filter_ips(&fprobe_graph_ops.ops, ips, cnt, remove, reset);
-	ftrace_set_filter_ips(&fprobe_ftrace_ops, ips, cnt, remove, reset);
+	ftrace_set_filter_ips(&fprobe_graph_ops.ops, ips, cnt, 1, 0);
+	ftrace_set_filter_ips(&fprobe_ftrace_ops, ips, cnt, 1, 0);
 }
 #endif
 #else
@@ -367,10 +366,9 @@ static bool fprobe_is_ftrace(struct fpro
 }
 
 #ifdef CONFIG_MODULES
-static void fprobe_set_ips(unsigned long *ips, unsigned int cnt, int remove,
-			   int reset)
+static void fprobe_remove_ips(unsigned long *ips, unsigned int cnt)
 {
-	ftrace_set_filter_ips(&fprobe_graph_ops.ops, ips, cnt, remove, reset);
+	ftrace_set_filter_ips(&fprobe_graph_ops.ops, ips, cnt, 1, 0);
 }
 #endif
 #endif /* !CONFIG_DYNAMIC_FTRACE_WITH_ARGS && !CONFIG_DYNAMIC_FTRACE_WITH_REGS */
@@ -543,7 +541,7 @@ static void fprobe_graph_remove_ips(unsi
 
 #ifdef CONFIG_MODULES
 
-#define FPROBE_IPS_BATCH_INIT 8
+#define FPROBE_IPS_BATCH_INIT 128
 /* instruction pointer address list */
 struct fprobe_addr_list {
 	int index;
@@ -551,45 +549,24 @@ struct fprobe_addr_list {
 	unsigned long *addrs;
 };
 
-static int fprobe_addr_list_add(struct fprobe_addr_list *alist, unsigned long addr)
+static int fprobe_remove_node_in_module(struct module *mod, struct fprobe_hlist_node *node,
+					 struct fprobe_addr_list *alist)
 {
-	unsigned long *addrs;
-
-	/* Previously we failed to expand the list. */
-	if (alist->index == alist->size)
-		return -ENOSPC;
-
-	alist->addrs[alist->index++] = addr;
-	if (alist->index < alist->size)
+	if (!within_module(node->addr, mod))
 		return 0;
 
-	/* Expand the address list */
-	addrs = kcalloc(alist->size * 2, sizeof(*addrs), GFP_KERNEL);
-	if (!addrs)
-		return -ENOMEM;
-
-	memcpy(addrs, alist->addrs, alist->size * sizeof(*addrs));
-	alist->size *= 2;
-	kfree(alist->addrs);
-	alist->addrs = addrs;
+	if (delete_fprobe_node(node))
+		return 0;
+	/* If no address list is available, we can't track this address. */
+	if (!alist->addrs)
+		return 0;
 
+	alist->addrs[alist->index++] = node->addr;
+	if (alist->index == alist->size)
+		return -ENOSPC;
 	return 0;
 }
 
-static void fprobe_remove_node_in_module(struct module *mod, struct fprobe_hlist_node *node,
-					 struct fprobe_addr_list *alist)
-{
-	if (!within_module(node->addr, mod))
-		return;
-	if (delete_fprobe_node(node))
-		return;
-	/*
-	 * If failed to update alist, just continue to update hlist.
-	 * Therefore, at list user handler will not hit anymore.
-	 */
-	fprobe_addr_list_add(alist, node->addr);
-}
-
 /* Handle module unloading to manage fprobe_ip_table. */
 static int fprobe_module_callback(struct notifier_block *nb,
 				  unsigned long val, void *data)
@@ -598,29 +575,50 @@ static int fprobe_module_callback(struct
 	struct fprobe_hlist_node *node;
 	struct rhashtable_iter iter;
 	struct module *mod = data;
+	bool retry;
 
 	if (val != MODULE_STATE_GOING)
 		return NOTIFY_DONE;
 
 	alist.addrs = kcalloc(alist.size, sizeof(*alist.addrs), GFP_KERNEL);
-	/* If failed to alloc memory, we can not remove ips from hash. */
-	if (!alist.addrs)
-		return NOTIFY_DONE;
+	/*
+	 * If failed to alloc memory, ftrace_ops will not be able to remove ips from
+	 * hash, but we can still remove nodes from fprobe_ip_table, so we can avoid
+	 * the potential wrong callback. So just print a warning here and try to
+	 * continue without address list.
+	 */
+	WARN_ONCE(!alist.addrs,
+		"Failed to allocate memory for fprobe_addr_list, ftrace_ops will not be updated");
 
 	mutex_lock(&fprobe_mutex);
+again:
+	retry = false;
+	alist.index = 0;
 	rhltable_walk_enter(&fprobe_ip_table, &iter);
 	do {
 		rhashtable_walk_start(&iter);
 
 		while ((node = rhashtable_walk_next(&iter)) && !IS_ERR(node))
-			fprobe_remove_node_in_module(mod, node, &alist);
+			if (fprobe_remove_node_in_module(mod, node, &alist) < 0) {
+				retry = true;
+				break;
+			}
 
 		rhashtable_walk_stop(&iter);
-	} while (node == ERR_PTR(-EAGAIN));
+	} while (node == ERR_PTR(-EAGAIN) && !retry);
 	rhashtable_walk_exit(&iter);
+	/* Remove any ips from hash table(s) */
+	if (alist.index > 0) {
+		fprobe_remove_ips(alist.addrs, alist.index);
+		/*
+		 * If we break rhashtable walk loop except for -EAGAIN, we need
+		 * to restart looping from start for safety. Anyway, this is
+		 * not a hotpath.
+		 */
+		if (retry)
+			goto again;
+	}
 
-	if (alist.index > 0)
-		fprobe_set_ips(alist.addrs, alist.index, 1, 0);
 	mutex_unlock(&fprobe_mutex);
 
 	kfree(alist.addrs);


