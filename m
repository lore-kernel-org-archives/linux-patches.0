Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6051C5799;
	Sat, 30 May 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162418; cv=none; b=ig7+CD80e8yycbn9jLPQ51ObsI4mc8oL8TcVKehpBBhqrj3IScp6fIZq1RXKlwJTpegWC9n47reURc0UQbYIZlqIuWRu/V5XezUWeg8VcLPwaeXMf2aVg1ktabggaMBSaGQENtAsOVhkGWjeOJnHlVQzXxjqZ5PdTzHC/wTf4ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162418; c=relaxed/simple;
	bh=kAMrejntGwgDU6Ehq0f8VjI6HzGTMU5iulOIhc25lNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp9ztM/lpojlRoYlKYsu/VjsD8b1g7aDxpXiJ9iSLCsAS5cZC80fmwDNMCg4cOcs5Jvh/Nbw6SfZwJOsytbOCyRRd3ffEugu8I8MCw3KsZelD1XPP94t13INSmfOLnPZHf9476fkOtcxdqoU1Oa6bmHbr326DdnT8lqD7H9llYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3pla5DV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3pla5DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B342F1F00893;
	Sat, 30 May 2026 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162417;
	bh=p5vieFwv3HNVCtzUKLtPSkWj1zLKbk5GSOfvqZqZl04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3pla5DVPOzXMEcibOoLpBDT7UWnlXDIk4BMREm0qjyOOkb/xF9sKOWo8UrTLgzfT
	 2K0m+eozzbXhlZpzkgphQcWwF7KyvcfUvRaTITk2jy1kz7LlThqlz1F0ECh5fMBduB
	 dBT/azauR4AFu84lQkwvNkOpTcLA2WFN9zsD9Mt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 916/969] netfilter: ebtables: move to two-stage removal scheme
Date: Sat, 30 May 2026 18:07:20 +0200
Message-ID: <20260530160326.028215185@linuxfoundation.org>
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

[ Upstream commit b7f0544d86d439cb946515d2ef6a0a75e8626710 ]

Like previous patches for x_tables, follow same pattern in ebtables.
We can't reuse xt helpers: ebt_table struct layout is incompatible.

table->ops assignment is now done while still holding the ebt mutex
to make sure we never expose partially-filled table struct.

Fixes: 87663c39f898 ("netfilter: ebtables: do not hook tables by default")
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtable_broute.c |  2 +-
 net/bridge/netfilter/ebtable_filter.c |  2 +-
 net/bridge/netfilter/ebtable_nat.c    |  2 +-
 net/bridge/netfilter/ebtables.c       | 60 +++++++++++++++++----------
 4 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 8f19253024b0a..33d8640d21ac1 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -128,8 +128,8 @@ static int __init ebtable_broute_init(void)
 
 static void __exit ebtable_broute_fini(void)
 {
-	unregister_pernet_subsys(&broute_net_ops);
 	ebt_unregister_template(&broute_table);
+	unregister_pernet_subsys(&broute_net_ops);
 }
 
 module_init(ebtable_broute_init);
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 278f324e67524..fdb988c24916a 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -109,8 +109,8 @@ static int __init ebtable_filter_init(void)
 
 static void __exit ebtable_filter_fini(void)
 {
-	unregister_pernet_subsys(&frame_filter_net_ops);
 	ebt_unregister_template(&frame_filter);
+	unregister_pernet_subsys(&frame_filter_net_ops);
 }
 
 module_init(ebtable_filter_init);
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 9066f7f376d57..8b981b2041b5d 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -109,8 +109,8 @@ static int __init ebtable_nat_init(void)
 
 static void __exit ebtable_nat_fini(void)
 {
-	unregister_pernet_subsys(&frame_nat_net_ops);
 	ebt_unregister_template(&frame_nat);
+	unregister_pernet_subsys(&frame_nat_net_ops);
 }
 
 module_init(ebtable_nat_init);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f99e348c8f37f..ec286e54229b7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -42,6 +42,7 @@
 
 struct ebt_pernet {
 	struct list_head tables;
+	struct list_head dead_tables;
 };
 
 struct ebt_template {
@@ -1162,11 +1163,6 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 
 static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 {
-	mutex_lock(&ebt_mutex);
-	list_del(&table->list);
-	mutex_unlock(&ebt_mutex);
-	audit_log_nfcfg(table->name, AF_BRIDGE, table->private->nentries,
-			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
 	EBT_ENTRY_ITERATE(table->private->entries, table->private->entries_size,
 			  ebt_cleanup_entry, net, NULL);
 	if (table->private->nentries)
@@ -1267,13 +1263,15 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	for (i = 0; i < num_ops; i++)
 		ops[i].priv = table;
 
-	list_add(&table->list, &ebt_net->tables);
-	mutex_unlock(&ebt_mutex);
-
 	table->ops = ops;
 	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret)
+	if (ret) {
+		synchronize_rcu();
 		__ebt_unregister_table(net, table);
+	} else {
+		list_add(&table->list, &ebt_net->tables);
+	}
+	mutex_unlock(&ebt_mutex);
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
 			AUDIT_XT_OP_REGISTER, GFP_KERNEL);
@@ -1339,7 +1337,7 @@ void ebt_unregister_template(const struct ebt_table *t)
 }
 EXPORT_SYMBOL(ebt_unregister_template);
 
-static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
+void ebt_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 	struct ebt_table *t;
@@ -1348,30 +1346,36 @@ static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
 
 	list_for_each_entry(t, &ebt_net->tables, list) {
 		if (strcmp(t->name, name) == 0) {
+			list_move(&t->list, &ebt_net->dead_tables);
 			mutex_unlock(&ebt_mutex);
-			return t;
+			nf_unregister_net_hooks(net, t->ops, hweight32(t->valid_hooks));
+			return;
 		}
 	}
 
 	mutex_unlock(&ebt_mutex);
-	return NULL;
-}
-
-void ebt_unregister_table_pre_exit(struct net *net, const char *name)
-{
-	struct ebt_table *table = __ebt_find_table(net, name);
-
-	if (table)
-		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }
 EXPORT_SYMBOL(ebt_unregister_table_pre_exit);
 
 void ebt_unregister_table(struct net *net, const char *name)
 {
-	struct ebt_table *table = __ebt_find_table(net, name);
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+	struct ebt_table *t;
 
-	if (table)
-		__ebt_unregister_table(net, table);
+	mutex_lock(&ebt_mutex);
+
+	list_for_each_entry(t, &ebt_net->dead_tables, list) {
+		if (strcmp(t->name, name) == 0) {
+			list_del(&t->list);
+			audit_log_nfcfg(t->name, AF_BRIDGE, t->private->nentries,
+					AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
+			__ebt_unregister_table(net, t);
+			mutex_unlock(&ebt_mutex);
+			return;
+		}
+	}
+
+	mutex_unlock(&ebt_mutex);
 }
 
 /* userspace just supplied us with counters */
@@ -2556,11 +2560,21 @@ static int __net_init ebt_pernet_init(struct net *net)
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 
 	INIT_LIST_HEAD(&ebt_net->tables);
+	INIT_LIST_HEAD(&ebt_net->dead_tables);
 	return 0;
 }
 
+static void __net_exit ebt_pernet_exit(struct net *net)
+{
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+
+	WARN_ON_ONCE(!list_empty(&ebt_net->tables));
+	WARN_ON_ONCE(!list_empty(&ebt_net->dead_tables));
+}
+
 static struct pernet_operations ebt_net_ops = {
 	.init = ebt_pernet_init,
+	.exit = ebt_pernet_exit,
 	.id   = &ebt_pernet_id,
 	.size = sizeof(struct ebt_pernet),
 };
-- 
2.53.0



