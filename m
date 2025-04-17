Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600532571CA;
	Thu, 17 Apr 2025 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912515; cv=none; b=W+KrkE3ImuA2YT8i6OqAIHAuSQ2Gs7dYSog/7+B+xuWwrh8NjzqTepTkgF1TkaSj8D4sVG4CjgGnMWE8Sw1ieQX2hnxX2J2rnlNxp5+qa8JaQUV3ED5oW/dxhqNr9u09BUO5c4egC2MeG7bFDrW0aidqyl9bcYkDHMND7JzZqM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912515; c=relaxed/simple;
	bh=nUrRsklfUFzvfIBd+b7Ko80DbHeeqVuuWThiqQjjY8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNAEbJtrn2PUkgYRs9S4oTiorxqgstbgC4/fYg/ZHfe9uyZ6Fu/HAjewLYd3sBSfdsUnM7QQK/+eM90fxSnxJZ5oTGbTPfdKbAAqHpliTJZCtwPdSZK8YZoCMZ9Mq28xd4QkfwMtsCvpXem0EjzDL2nS+Yw975xTN0uoPkRqmko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiSUfgOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiSUfgOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58E0C4CEE4;
	Thu, 17 Apr 2025 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912515;
	bh=nUrRsklfUFzvfIBd+b7Ko80DbHeeqVuuWThiqQjjY8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiSUfgOLicnNf+/ME8HIs9bhGJSQEvypzSBMB21iAGcw+NHn5MenT2idDR4h9Sz/7
	 7zYvRiy3bllFoxdfcB+1Tl8WFElThUAjQSb2mMIADDiIQ1HeYomA8oghUV8BENAbGf
	 K2hg7fm2RPHUzqhAg8+N1nYf2niZ2NEH57GpMLcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 005/449] tracing: fprobe: Cleanup fprobe hash when module unloading
Date: Thu, 17 Apr 2025 19:44:53 +0200
Message-ID: <20250417175118.201795605@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit a3dc2983ca7b90fd35f978502de6d4664d965cfb ]

Cleanup fprobe address hash table on module unloading because the
target symbols will be disappeared when unloading module and not
sure the same symbol is mapped on the same address.

Note that this is at least disables the fprobes if a part of target
symbols on the unloaded modules. Unlike kprobes, fprobe does not
re-enable the probe point by itself. To do that, the caller should
take care register/unregister fprobe when loading/unloading modules.
This simplifies the fprobe state managememt related to the module
loading/unloading.

Link: https://lore.kernel.org/all/174343534473.843280.13988101014957210732.stgit@devnote2/

Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 103 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 33082c4e8154e..c4bf59d625f75 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -89,8 +89,11 @@ static bool delete_fprobe_node(struct fprobe_hlist_node *node)
 {
 	lockdep_assert_held(&fprobe_mutex);
 
-	WRITE_ONCE(node->fp, NULL);
-	hlist_del_rcu(&node->hlist);
+	/* Avoid double deleting */
+	if (READ_ONCE(node->fp) != NULL) {
+		WRITE_ONCE(node->fp, NULL);
+		hlist_del_rcu(&node->hlist);
+	}
 	return !!find_first_fprobe_node(node->addr);
 }
 
@@ -411,6 +414,102 @@ static void fprobe_graph_remove_ips(unsigned long *addrs, int num)
 		ftrace_set_filter_ips(&fprobe_graph_ops.ops, addrs, num, 1, 0);
 }
 
+#ifdef CONFIG_MODULES
+
+#define FPROBE_IPS_BATCH_INIT 8
+/* instruction pointer address list */
+struct fprobe_addr_list {
+	int index;
+	int size;
+	unsigned long *addrs;
+};
+
+static int fprobe_addr_list_add(struct fprobe_addr_list *alist, unsigned long addr)
+{
+	unsigned long *addrs;
+
+	if (alist->index >= alist->size)
+		return -ENOMEM;
+
+	alist->addrs[alist->index++] = addr;
+	if (alist->index < alist->size)
+		return 0;
+
+	/* Expand the address list */
+	addrs = kcalloc(alist->size * 2, sizeof(*addrs), GFP_KERNEL);
+	if (!addrs)
+		return -ENOMEM;
+
+	memcpy(addrs, alist->addrs, alist->size * sizeof(*addrs));
+	alist->size *= 2;
+	kfree(alist->addrs);
+	alist->addrs = addrs;
+
+	return 0;
+}
+
+static void fprobe_remove_node_in_module(struct module *mod, struct hlist_head *head,
+					struct fprobe_addr_list *alist)
+{
+	struct fprobe_hlist_node *node;
+	int ret = 0;
+
+	hlist_for_each_entry_rcu(node, head, hlist) {
+		if (!within_module(node->addr, mod))
+			continue;
+		if (delete_fprobe_node(node))
+			continue;
+		/*
+		 * If failed to update alist, just continue to update hlist.
+		 * Therefore, at list user handler will not hit anymore.
+		 */
+		if (!ret)
+			ret = fprobe_addr_list_add(alist, node->addr);
+	}
+}
+
+/* Handle module unloading to manage fprobe_ip_table. */
+static int fprobe_module_callback(struct notifier_block *nb,
+				  unsigned long val, void *data)
+{
+	struct fprobe_addr_list alist = {.size = FPROBE_IPS_BATCH_INIT};
+	struct module *mod = data;
+	int i;
+
+	if (val != MODULE_STATE_GOING)
+		return NOTIFY_DONE;
+
+	alist.addrs = kcalloc(alist.size, sizeof(*alist.addrs), GFP_KERNEL);
+	/* If failed to alloc memory, we can not remove ips from hash. */
+	if (!alist.addrs)
+		return NOTIFY_DONE;
+
+	mutex_lock(&fprobe_mutex);
+	for (i = 0; i < FPROBE_IP_TABLE_SIZE; i++)
+		fprobe_remove_node_in_module(mod, &fprobe_ip_table[i], &alist);
+
+	if (alist.index < alist.size && alist.index > 0)
+		ftrace_set_filter_ips(&fprobe_graph_ops.ops,
+				      alist.addrs, alist.index, 1, 0);
+	mutex_unlock(&fprobe_mutex);
+
+	kfree(alist.addrs);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block fprobe_module_nb = {
+	.notifier_call = fprobe_module_callback,
+	.priority = 0,
+};
+
+static int __init init_fprobe_module(void)
+{
+	return register_module_notifier(&fprobe_module_nb);
+}
+early_initcall(init_fprobe_module);
+#endif
+
 static int symbols_cmp(const void *a, const void *b)
 {
 	const char **str_a = (const char **) a;
-- 
2.39.5



