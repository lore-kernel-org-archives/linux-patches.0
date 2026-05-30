Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2608233A9DA;
	Sat, 30 May 2026 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162415; cv=none; b=HxBIj6t9PTD7I/gFkrCuvci/86yB3EXXn6xDJCswd6jdVVPqrWi4qog1etKLeHHlg5RCKpd/5z4u01DkV6fQP1iBrgAoXVYuNntmn6EWiSpbBx4Sb1jO2PuTWmQbuwH6jxgBj0Cdzbprp2YMijLkMokU5dh3+n/e6rZNPaKo3FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162415; c=relaxed/simple;
	bh=6E5in5iEOYX7YyH5f7sKtAkpx9ngx9XMfnMQl3sHsCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrTGUCbLLpU/WnJC1GuquIJq6CtKjVMos6gcz4OyY7oN0jQD34lNlheOJoOCXpOc5fEr0M5W3zocfcoEALF0uVDI/FxnyvLDrQgdjg1v8qUQx4TeMLjQIByG4BHu97boGliIAY5G2ofn18JKHV2Uy4pEcEnayo4KRDqYVC6U1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5xlaRew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5xlaRew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DE81F00899;
	Sat, 30 May 2026 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162414;
	bh=clQT0kxfpm95uU2fntkKRAcaluWXJlUM3ze7TzuyYIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5xlaRewiW6IO8deKKWT8Q3d3ktQPqKBEo0AlXH1bBQMkTK2mY2K3sEpd2J1Qizw1
	 QZV23tdUjpuuvLWqlX3Asd/zAclxzPxY5gdP1/qnpptIyMk+NhOfy/x2cThaql+Zvc
	 TeHnCx1UX53cGXSNgOVMTrC8136/yrKCIMiI1jX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 915/969] netfilter: x_tables: add and use xtables_unregister_table_exit
Date: Sat, 30 May 2026 18:07:19 +0200
Message-ID: <20260530160325.998493458@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b4597d5fd7d2f8cebfffd40dffb5e003cc78964c ]

Previous change added xtables_unregister_table_pre_exit to detach the
table from the packetpath and to unlink it from the active table list.
In case of rmmod, userspace that is doing set/getsockopt for this table
will not be able to re-instantiate the table:
 1. The larval table has been removed already
 2. existing instantiated table is no longer on the xt pernet table list.

This adds the second stage helper:

unlink the table from the dying list, free the hook ops (if any) and do
the audit notification.  It replaces xt_unregister_table().

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
Closes: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/x_tables.h |  2 +-
 net/ipv4/netfilter/arp_tables.c    |  9 ++--
 net/ipv4/netfilter/ip_tables.c     |  9 ++--
 net/ipv4/netfilter/iptable_nat.c   |  5 +-
 net/ipv6/netfilter/ip6_tables.c    |  9 ++--
 net/ipv6/netfilter/ip6table_nat.c  |  5 +-
 net/netfilter/x_tables.c           | 81 +++++++++++++++++++++++-------
 7 files changed, 83 insertions(+), 37 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index df2022fe440b0..706f08839050a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -309,8 +309,8 @@ struct xt_table *xt_register_table(struct net *net,
 				   const struct xt_table *table,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo);
-void *xt_unregister_table(struct xt_table *table);
 void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name);
+struct xt_table *xt_unregister_table_exit(struct net *net, u8 af, const char *name);
 
 struct xt_table_info *xt_replace_table(struct xt_table *table,
 				       unsigned int num_counters,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 9b905c6562313..f9dd18244f251 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1501,13 +1501,11 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 
 static void __arpt_unregister_table(struct net *net, struct xt_table *table)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
+	struct xt_table_info *private = table->private;
 	struct module *table_owner = table->me;
+	void *loc_cpu_entry;
 	struct arpt_entry *iter;
 
-	private = xt_unregister_table(table);
-
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
@@ -1515,6 +1513,7 @@ static void __arpt_unregister_table(struct net *net, struct xt_table *table)
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
+	kfree(table);
 }
 
 int arpt_register_table(struct net *net,
@@ -1583,7 +1582,7 @@ int arpt_register_table(struct net *net,
 
 void arpt_unregister_table(struct net *net, const char *name)
 {
-	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
+	struct xt_table *table = xt_unregister_table_exit(net, NFPROTO_ARP, name);
 
 	if (table)
 		__arpt_unregister_table(net, table);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7c6b21f8174a3..0ff9b7c9dc59c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1706,12 +1706,10 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 static void __ipt_unregister_table(struct net *net, struct xt_table *table)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
+	struct xt_table_info *private = table->private;
 	struct module *table_owner = table->me;
 	struct ipt_entry *iter;
-
-	private = xt_unregister_table(table);
+	void *loc_cpu_entry;
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
@@ -1720,6 +1718,7 @@ static void __ipt_unregister_table(struct net *net, struct xt_table *table)
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
+	kfree(table);
 }
 
 int ipt_register_table(struct net *net, const struct xt_table *table,
@@ -1793,7 +1792,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 void ipt_unregister_table_exit(struct net *net, const char *name)
 {
-	struct xt_table *table = xt_find_table(net, NFPROTO_IPV4, name);
+	struct xt_table *table = xt_unregister_table_exit(net, NFPROTO_IPV4, name);
 
 	if (table)
 		__ipt_unregister_table(net, table);
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index ca6964b957ead..87d934b12bcb6 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -119,8 +119,11 @@ static int iptable_nat_table_init(struct net *net)
 	}
 
 	ret = ipt_nat_register_lookups(net);
-	if (ret < 0)
+	if (ret < 0) {
+		xt_unregister_table_pre_exit(net, NFPROTO_IPV4, "nat");
+		synchronize_rcu();
 		ipt_unregister_table_exit(net, "nat");
+	}
 
 	kfree(repl);
 	return ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1324413fb29c3..baa1c094faf48 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1715,12 +1715,10 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 static void __ip6t_unregister_table(struct net *net, struct xt_table *table)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
+	struct xt_table_info *private = table->private;
 	struct module *table_owner = table->me;
 	struct ip6t_entry *iter;
-
-	private = xt_unregister_table(table);
+	void *loc_cpu_entry;
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
@@ -1729,6 +1727,7 @@ static void __ip6t_unregister_table(struct net *net, struct xt_table *table)
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
+	kfree(table);
 }
 
 int ip6t_register_table(struct net *net, const struct xt_table *table,
@@ -1799,7 +1798,7 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 void ip6t_unregister_table_exit(struct net *net, const char *name)
 {
-	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
+	struct xt_table *table = xt_unregister_table_exit(net, NFPROTO_IPV6, name);
 
 	if (table)
 		__ip6t_unregister_table(net, table);
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index bef2d309369bc..cf260d8ebdb70 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -121,8 +121,11 @@ static int ip6table_nat_table_init(struct net *net)
 	}
 
 	ret = ip6t_nat_register_lookups(net);
-	if (ret < 0)
+	if (ret < 0) {
+		xt_unregister_table_pre_exit(net, NFPROTO_IPV6, "nat");
+		synchronize_rcu();
 		ip6t_unregister_table_exit(net, "nat");
+	}
 
 	kfree(repl);
 	return ret;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 6a4bca66a0ae6..cba2b8d2f9069 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -55,6 +55,9 @@ static struct list_head xt_templates[NFPROTO_NUMPROTO];
 
 struct xt_pernet {
 	struct list_head tables[NFPROTO_NUMPROTO];
+
+	/* stash area used during netns exit */
+	struct list_head dead_tables[NFPROTO_NUMPROTO];
 };
 
 struct compat_delta {
@@ -1521,23 +1524,6 @@ struct xt_table *xt_register_table(struct net *net,
 }
 EXPORT_SYMBOL_GPL(xt_register_table);
 
-void *xt_unregister_table(struct xt_table *table)
-{
-	struct xt_table_info *private;
-
-	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
-	list_del(&table->list);
-	mutex_unlock(&xt[table->af].mutex);
-	audit_log_nfcfg(table->name, table->af, private->number,
-			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
-	kfree(table->ops);
-	kfree(table);
-
-	return private;
-}
-EXPORT_SYMBOL_GPL(xt_unregister_table);
-
 /**
  * xt_unregister_table_pre_exit - pre-shutdown unregister of a table
  * @net: network namespace
@@ -1547,6 +1533,14 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
  * Unregisters the specified netfilter table from the given network namespace
  * and also unregisters the hooks from netfilter core: no new packets will be
  * processed.
+ *
+ * This must be called prior to xt_unregister_table_exit() from the pernet
+ * .pre_exit callback.  After this call, the table is no longer visible to
+ * the get/setsockopt path.  In case of rmmod, module exit path must have
+ * called xt_unregister_template() prior to unregistering pernet ops to
+ * prevent re-instantiation of the table.
+ *
+ * See also: xt_unregister_table_exit()
  */
 void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
 {
@@ -1556,6 +1550,7 @@ void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt_net->tables[af], list) {
 		if (strcmp(t->name, name) == 0) {
+			list_move(&t->list, &xt_net->dead_tables[af]);
 			mutex_unlock(&xt[af].mutex);
 
 			if (t->ops) /* nat table registers with nat core, t->ops is NULL. */
@@ -1566,6 +1561,50 @@ void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
 	mutex_unlock(&xt[af].mutex);
 }
 EXPORT_SYMBOL(xt_unregister_table_pre_exit);
+
+/**
+ * xt_unregister_table_exit - remove a table during namespace teardown
+ * @net: the network namespace from which to unregister the table
+ * @af: address family (e.g., NFPROTO_IPV4, NFPROTO_IPV6)
+ * @name: name of the table to unregister
+ *
+ * Completes the unregister process for a table. This must be called from
+ * the pernet ops .exit callback. This is the second stage after
+ * xt_unregister_table_pre_exit().
+ *
+ * pair with xt_unregister_table_pre_exit() during namespace shutdown.
+ *
+ * Return: the unregistered table or NULL if the table was never
+ *         instantiated. The caller needs to kfree() the table after it
+ *         has removed the family specific matches/targets.
+ */
+struct xt_table *xt_unregister_table_exit(struct net *net, u8 af, const char *name)
+{
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *table;
+
+	mutex_lock(&xt[af].mutex);
+	list_for_each_entry(table, &xt_net->dead_tables[af], list) {
+		struct nf_hook_ops *ops = NULL;
+
+		if (strcmp(table->name, name) != 0)
+			continue;
+
+		list_del(&table->list);
+
+		audit_log_nfcfg(table->name, table->af, table->private->number,
+				AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
+		swap(table->ops, ops);
+		mutex_unlock(&xt[af].mutex);
+
+		kfree(ops);
+		return table;
+	}
+	mutex_unlock(&xt[af].mutex);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xt_unregister_table_exit);
 #endif
 
 #ifdef CONFIG_PROC_FS
@@ -2012,8 +2051,10 @@ static int __net_init xt_net_init(struct net *net)
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	int i;
 
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		INIT_LIST_HEAD(&xt_net->tables[i]);
+		INIT_LIST_HEAD(&xt_net->dead_tables[i]);
+	}
 	return 0;
 }
 
@@ -2022,8 +2063,10 @@ static void __net_exit xt_net_exit(struct net *net)
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	int i;
 
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		WARN_ON_ONCE(!list_empty(&xt_net->tables[i]));
+		WARN_ON_ONCE(!list_empty(&xt_net->dead_tables[i]));
+	}
 }
 
 static struct pernet_operations xt_net_ops = {
-- 
2.53.0



