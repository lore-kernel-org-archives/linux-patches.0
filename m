Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A411385D7B;
	Sat, 17 Oct 2026 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258933; cv=none; b=EORogPb0/RaZCaj3kSzbdWBANB2yeFLaRmqpJOOrPvKavkhIffA15bAMRJbpopa7kL2SAkTSzkVzhxU2MNlMGZ928hzkE+RC0ndbP6OV4YkM5mFwjS3C1BMZcdprXNCg2XShSeUzTLXW1Vy+H9kR50UQ1enpdLD9qBryGf4uta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258933; c=relaxed/simple;
	bh=K5Y2mLJvIOWBlmhaOg1zcxZ3o029VC1Ns9pgNieSImU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdPj4UFfuUT5bnW9dB7Ts59RyW1aef3ix7iT2cB85axiuLFv/BJjeHOvWybzak/ILkRJwlhix4G6cFfaHgAcoiUurhHuYKDpNRZ3RYBv/VcSIidFMA4LDN+tGtfaYcTQ2JMJNz+W3ewygMC5YoUfMQqCuqZDd+9Pl1H4fKJ3zI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+JTMeu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+JTMeu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C21F000C4;
	Sat, 17 Oct 2026 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258932;
	bh=Dz7HBjh7x0JmnE0kVzp7zxPwq5pie3/Oma7re2MiFgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+JTMeu/hG6m3eopMNOnxnPjHuK1r3hDMeGqNBmwzd52B2KwJsVAkdnSe66Vxfegk
	 5Fl0keAY1eay+4dny/PMCCKsTjpdGftirBcSACDEvCkafgweP5YugrhKjlXwqygKvs
	 gsa/UYiulxGh/5YtNrEiYzutY7rnT//9JZv8Pw5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1046/1674] netfilter: ebtables: move to two-stage removal scheme
Date: Sat, 17 Oct 2026 17:55:18 +0200
Message-ID: <20261017160457.981689589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca6f0b7710823..b1846d5c879a5 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -42,6 +42,7 @@
 
 struct ebt_pernet {
 	struct list_head tables;
+	struct list_head dead_tables;
 };
 
 struct ebt_template {
@@ -1164,11 +1165,6 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 
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
@@ -1269,13 +1265,15 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
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
@@ -1341,7 +1339,7 @@ void ebt_unregister_template(const struct ebt_table *t)
 }
 EXPORT_SYMBOL(ebt_unregister_template);
 
-static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
+void ebt_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 	struct ebt_table *t;
@@ -1350,30 +1348,36 @@ static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
 
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
@@ -2594,11 +2598,21 @@ static int __net_init ebt_pernet_init(struct net *net)
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



