Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88572609EE;
	Fri, 15 May 2026 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862279; cv=none; b=tQaD1Vzoxmuqjiomp6xqF1s9Pkex3+EgrCXZrxOHvlByw7K/9LpxvFx9GLpkFDjUVRD7LVFCOtWOr9MzsspptSS3nrTFBMOtkJet0+tN3Pgi+4jp+/V2rSerKryMdrBzCkf3OXGxtqpKO7A0dyZDi9EYDZLRVB69J99qoIhA/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862279; c=relaxed/simple;
	bh=KWgGCbdTP9P4srN16/aJ2mT44ggwHFXW8j049yQgFtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3q0IeTQjubrn3duJzO5ELT0q3CtKwc7UaVVKKMEZK5nJRxAjbeztZ0OLyRV49/lSD4wxMXkTXIgIr0Vib9YL5xIn8YqxVPrY64sU2fWDxnzJz45A4QvI/EJegGbu8YxEJidukJxRcG0i5zmxzYBUIXBYR6luiSthkJQk/zlYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcF7uDuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcF7uDuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE88C2BCC7;
	Fri, 15 May 2026 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862279;
	bh=KWgGCbdTP9P4srN16/aJ2mT44ggwHFXW8j049yQgFtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcF7uDucXxq1uMlu8lNXwo6eikOQrfUzaMiMSHd4hHH6pfbi9C4h+2WI9cG+cZy1d
	 ceNb6sk1Gp0UeW7t8VjCYRy8cGUCuA0zCqlYQKz9rf9npQRgQKWZ3fHPbw2CVHpq2B
	 FM/TQuj3DFNBZj+IN+QIq2dEjROam/AvtkcEMvCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/188] tracing: fprobe: use rhltable for fprobe_ip_table
Date: Fri, 15 May 2026 17:49:54 +0200
Message-ID: <20260515154701.179659773@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 0de4c70d04a46a3c266547dd4275ce25f623796a ]

For now, all the kernel functions who are hooked by the fprobe will be
added to the hash table "fprobe_ip_table". The key of it is the function
address, and the value of it is "struct fprobe_hlist_node".

The budget of the hash table is FPROBE_IP_TABLE_SIZE, which is 256. And
this means the overhead of the hash table lookup will grow linearly if
the count of the functions in the fprobe more than 256. When we try to
hook all the kernel functions, the overhead will be huge.

Therefore, replace the hash table with rhltable to reduce the overhead.

Link: https://lore.kernel.org/all/20250819031825.55653-1-dongml2@chinatelecom.cn/

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 845947aca681 ("tracing/fprobe: Remove fprobe from hash in failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fprobe.h |    3 
 kernel/trace/fprobe.c  |  157 ++++++++++++++++++++++++++++---------------------
 2 files changed, 93 insertions(+), 67 deletions(-)

--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -7,6 +7,7 @@
 #include <linux/ftrace.h>
 #include <linux/rcupdate.h>
 #include <linux/refcount.h>
+#include <linux/rhashtable.h>
 #include <linux/slab.h>
 
 struct fprobe;
@@ -26,7 +27,7 @@ typedef void (*fprobe_exit_cb)(struct fp
  * @fp: The fprobe which owns this.
  */
 struct fprobe_hlist_node {
-	struct hlist_node	hlist;
+	struct rhlist_head	hlist;
 	unsigned long		addr;
 	struct fprobe		*fp;
 };
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -11,6 +11,7 @@
 #include <linux/kprobes.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rhashtable.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 
@@ -42,60 +43,67 @@
  *  - RCU hlist traversal under disabling preempt
  */
 static struct hlist_head fprobe_table[FPROBE_TABLE_SIZE];
-static struct hlist_head fprobe_ip_table[FPROBE_IP_TABLE_SIZE];
+static struct rhltable fprobe_ip_table;
 static DEFINE_MUTEX(fprobe_mutex);
 
-/*
- * Find first fprobe in the hlist. It will be iterated twice in the entry
- * probe, once for correcting the total required size, the second time is
- * calling back the user handlers.
- * Thus the hlist in the fprobe_table must be sorted and new probe needs to
- * be added *before* the first fprobe.
- */
-static struct fprobe_hlist_node *find_first_fprobe_node(unsigned long ip)
+static u32 fprobe_node_hashfn(const void *data, u32 len, u32 seed)
 {
-	struct fprobe_hlist_node *node;
-	struct hlist_head *head;
+	return hash_ptr(*(unsigned long **)data, 32);
+}
 
-	head = &fprobe_ip_table[hash_ptr((void *)ip, FPROBE_IP_HASH_BITS)];
-	hlist_for_each_entry_rcu(node, head, hlist,
-				 lockdep_is_held(&fprobe_mutex)) {
-		if (node->addr == ip)
-			return node;
-	}
-	return NULL;
+static int fprobe_node_cmp(struct rhashtable_compare_arg *arg,
+			   const void *ptr)
+{
+	unsigned long key = *(unsigned long *)arg->key;
+	const struct fprobe_hlist_node *n = ptr;
+
+	return n->addr != key;
 }
-NOKPROBE_SYMBOL(find_first_fprobe_node);
 
-/* Node insertion and deletion requires the fprobe_mutex */
-static void insert_fprobe_node(struct fprobe_hlist_node *node)
+static u32 fprobe_node_obj_hashfn(const void *data, u32 len, u32 seed)
 {
-	unsigned long ip = node->addr;
-	struct fprobe_hlist_node *next;
-	struct hlist_head *head;
+	const struct fprobe_hlist_node *n = data;
+
+	return hash_ptr((void *)n->addr, 32);
+}
+
+static const struct rhashtable_params fprobe_rht_params = {
+	.head_offset		= offsetof(struct fprobe_hlist_node, hlist),
+	.key_offset		= offsetof(struct fprobe_hlist_node, addr),
+	.key_len		= sizeof_field(struct fprobe_hlist_node, addr),
+	.hashfn			= fprobe_node_hashfn,
+	.obj_hashfn		= fprobe_node_obj_hashfn,
+	.obj_cmpfn		= fprobe_node_cmp,
+	.automatic_shrinking	= true,
+};
 
+/* Node insertion and deletion requires the fprobe_mutex */
+static int insert_fprobe_node(struct fprobe_hlist_node *node)
+{
 	lockdep_assert_held(&fprobe_mutex);
 
-	next = find_first_fprobe_node(ip);
-	if (next) {
-		hlist_add_before_rcu(&node->hlist, &next->hlist);
-		return;
-	}
-	head = &fprobe_ip_table[hash_ptr((void *)ip, FPROBE_IP_HASH_BITS)];
-	hlist_add_head_rcu(&node->hlist, head);
+	return rhltable_insert(&fprobe_ip_table, &node->hlist, fprobe_rht_params);
 }
 
 /* Return true if there are synonims */
 static bool delete_fprobe_node(struct fprobe_hlist_node *node)
 {
 	lockdep_assert_held(&fprobe_mutex);
+	bool ret;
 
 	/* Avoid double deleting */
 	if (READ_ONCE(node->fp) != NULL) {
 		WRITE_ONCE(node->fp, NULL);
-		hlist_del_rcu(&node->hlist);
+		rhltable_remove(&fprobe_ip_table, &node->hlist,
+				fprobe_rht_params);
 	}
-	return !!find_first_fprobe_node(node->addr);
+
+	rcu_read_lock();
+	ret = !!rhltable_lookup(&fprobe_ip_table, &node->addr,
+				fprobe_rht_params);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 /* Check existence of the fprobe */
@@ -247,9 +255,10 @@ static inline int __fprobe_kprobe_handle
 static int fprobe_entry(struct ftrace_graph_ent *trace, struct fgraph_ops *gops,
 			struct ftrace_regs *fregs)
 {
-	struct fprobe_hlist_node *node, *first;
 	unsigned long *fgraph_data = NULL;
 	unsigned long func = trace->func;
+	struct fprobe_hlist_node *node;
+	struct rhlist_head *head, *pos;
 	unsigned long ret_ip;
 	int reserved_words;
 	struct fprobe *fp;
@@ -258,14 +267,11 @@ static int fprobe_entry(struct ftrace_gr
 	if (WARN_ON_ONCE(!fregs))
 		return 0;
 
-	first = node = find_first_fprobe_node(func);
-	if (unlikely(!first))
-		return 0;
-
+	head = rhltable_lookup(&fprobe_ip_table, &func, fprobe_rht_params);
 	reserved_words = 0;
-	hlist_for_each_entry_from_rcu(node, hlist) {
+	rhl_for_each_entry_rcu(node, pos, head, hlist) {
 		if (node->addr != func)
-			break;
+			continue;
 		fp = READ_ONCE(node->fp);
 		if (!fp || !fp->exit_handler)
 			continue;
@@ -276,13 +282,12 @@ static int fprobe_entry(struct ftrace_gr
 		reserved_words +=
 			FPROBE_HEADER_SIZE_IN_LONG + SIZE_IN_LONG(fp->entry_data_size);
 	}
-	node = first;
 	if (reserved_words) {
 		fgraph_data = fgraph_reserve_data(gops->idx, reserved_words * sizeof(long));
 		if (unlikely(!fgraph_data)) {
-			hlist_for_each_entry_from_rcu(node, hlist) {
+			rhl_for_each_entry_rcu(node, pos, head, hlist) {
 				if (node->addr != func)
-					break;
+					continue;
 				fp = READ_ONCE(node->fp);
 				if (fp && !fprobe_disabled(fp))
 					fp->nmissed++;
@@ -297,12 +302,12 @@ static int fprobe_entry(struct ftrace_gr
 	 */
 	ret_ip = ftrace_regs_get_return_address(fregs);
 	used = 0;
-	hlist_for_each_entry_from_rcu(node, hlist) {
+	rhl_for_each_entry_rcu(node, pos, head, hlist) {
 		int data_size;
 		void *data;
 
 		if (node->addr != func)
-			break;
+			continue;
 		fp = READ_ONCE(node->fp);
 		if (!fp || fprobe_disabled(fp))
 			continue;
@@ -447,25 +452,21 @@ static int fprobe_addr_list_add(struct f
 	return 0;
 }
 
-static void fprobe_remove_node_in_module(struct module *mod, struct hlist_head *head,
-					struct fprobe_addr_list *alist)
+static void fprobe_remove_node_in_module(struct module *mod, struct fprobe_hlist_node *node,
+					 struct fprobe_addr_list *alist)
 {
-	struct fprobe_hlist_node *node;
 	int ret = 0;
 
-	hlist_for_each_entry_rcu(node, head, hlist,
-				 lockdep_is_held(&fprobe_mutex)) {
-		if (!within_module(node->addr, mod))
-			continue;
-		if (delete_fprobe_node(node))
-			continue;
-		/*
-		 * If failed to update alist, just continue to update hlist.
-		 * Therefore, at list user handler will not hit anymore.
-		 */
-		if (!ret)
-			ret = fprobe_addr_list_add(alist, node->addr);
-	}
+	if (!within_module(node->addr, mod))
+		return;
+	if (delete_fprobe_node(node))
+		return;
+	/*
+	 * If failed to update alist, just continue to update hlist.
+	 * Therefore, at list user handler will not hit anymore.
+	 */
+	if (!ret)
+		ret = fprobe_addr_list_add(alist, node->addr);
 }
 
 /* Handle module unloading to manage fprobe_ip_table. */
@@ -473,8 +474,9 @@ static int fprobe_module_callback(struct
 				  unsigned long val, void *data)
 {
 	struct fprobe_addr_list alist = {.size = FPROBE_IPS_BATCH_INIT};
+	struct fprobe_hlist_node *node;
+	struct rhashtable_iter iter;
 	struct module *mod = data;
-	int i;
 
 	if (val != MODULE_STATE_GOING)
 		return NOTIFY_DONE;
@@ -485,8 +487,16 @@ static int fprobe_module_callback(struct
 		return NOTIFY_DONE;
 
 	mutex_lock(&fprobe_mutex);
-	for (i = 0; i < FPROBE_IP_TABLE_SIZE; i++)
-		fprobe_remove_node_in_module(mod, &fprobe_ip_table[i], &alist);
+	rhltable_walk_enter(&fprobe_ip_table, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((node = rhashtable_walk_next(&iter)) && !IS_ERR(node))
+			fprobe_remove_node_in_module(mod, node, &alist);
+
+		rhashtable_walk_stop(&iter);
+	} while (node == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
 
 	if (alist.index > 0)
 		ftrace_set_filter_ips(&fprobe_graph_ops.ops,
@@ -728,8 +738,16 @@ int register_fprobe_ips(struct fprobe *f
 	ret = fprobe_graph_add_ips(addrs, num);
 	if (!ret) {
 		add_fprobe_hash(fp);
-		for (i = 0; i < hlist_array->size; i++)
-			insert_fprobe_node(&hlist_array->array[i]);
+		for (i = 0; i < hlist_array->size; i++) {
+			ret = insert_fprobe_node(&hlist_array->array[i]);
+			if (ret)
+				break;
+		}
+		/* fallback on insert error */
+		if (ret) {
+			for (i--; i >= 0; i--)
+				delete_fprobe_node(&hlist_array->array[i]);
+		}
 	}
 
 	if (ret)
@@ -824,3 +842,10 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_fprobe);
+
+static int __init fprobe_initcall(void)
+{
+	rhltable_init(&fprobe_ip_table, &fprobe_rht_params);
+	return 0;
+}
+late_initcall(fprobe_initcall);


