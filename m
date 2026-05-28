Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB0032AAA8;
	Thu, 28 May 2026 20:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998533; cv=none; b=hjiZzdElQvAp2tKToLE2yz33nbFZcgG0nJljV517XeMgzkA2t3sBd9qxudYkh1Y0PkpyY2sMPrXz/s1RB7paQZpqcvFoXfiCWnOUpJrNjfsoZLlghmFqJnC9UZJS3hU4Y0fYJarXMz14yzA23noVkDRWIeVBeZLRsf6aREAyuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998533; c=relaxed/simple;
	bh=7IehKXRGWKWkAY3Nv6+3l8GiU2YsfLcfyZ7KrzijfcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUQw55v8r8BM4s7A6cpQlhRsxA2rnpWkSlE9smMKbjFkMiSMYGyznMoCpSw51noTqhpUkplTPrqKajL/4F5TZ0Q4mFpiQVBsSnRoGR4azYVEKTVz6z6CM0RUkG9hC/YklOdp+12quBAH4wumSBVVu0hNNe0PP30y8uxSCkL6+dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nD9WHyis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nD9WHyis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8441F00A3A;
	Thu, 28 May 2026 20:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998532;
	bh=tv7mqpLfDAr9amLi1CrRsz92GcMJx9T/cPJQ+auKpfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nD9WHyisS3nfHqG9Jg6Z0VI62j3w+ePv+3T8l9Va1qyj1A2FoI/dUL/OoMkm9K3NK
	 I8MBNv4LDXOaTrTEt0+ql3K7LrUwOThhggh75MQCxwYLrxfE/Eghd+thHAlzQgX8hQ
	 lsd2ode8AM0taAE2VgHqT4+e0qvk3jBKQkWH5Z9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 208/461] netfilter: x_tables: allocate hook ops while under mutex
Date: Thu, 28 May 2026 21:45:37 +0200
Message-ID: <20260528194653.135057708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b62eb8dcf2c47d4d676a434efbd57c4f776f7829 ]

arp/ip(6)t_register_table() add the table to the per-netns list via
xt_register_table() before allocating the per-netns hook ops copy
via kmemdup_array().  This leaves a window where the table is
visible in the list with ops=NULL.

If the pernet exit happens runs concurrently the pre_exit callback finds
the table via xt_find_table() and passes the NULL ops pointer to
nf_unregister_net_hooks(), causing a NULL dereference:

  general protection fault in nf_unregister_net_hooks+0xbc/0x150
  RIP: nf_unregister_net_hooks (net/netfilter/core.c:613)
  Call Trace:
    ipt_unregister_table_pre_exit
    iptable_mangle_net_pre_exit
    ops_pre_exit_list
    cleanup_net

Fix by moving the ops allocation into the xtables core so the table is
never in the list without valid ops.  Also ensure the table is no longer
processing packets before its torn down on error unwind.
nf_register_net_hooks might have published at least one hook; call
synchronize_rcu() if there was an error.

audit log register message gets deferred until all operations have
passed, this avoids need to emit another ureg message in case of
error unwinding.

Based on earlier patch by Tristan Madani.

Fixes: f9006acc8dfe5 ("netfilter: arp_tables: pass table pointer via nf_hook_ops")
Fixes: ee177a54413a ("netfilter: ip6_tables: pass table pointer via nf_hook_ops")
Fixes: ae689334225f ("netfilter: ip_tables: pass table pointer via nf_hook_ops")
Link: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/x_tables.h |  1 +
 net/ipv4/netfilter/arp_tables.c    | 35 +++------------------
 net/ipv4/netfilter/ip_tables.c     | 41 +++---------------------
 net/ipv6/netfilter/ip6_tables.c    | 38 +++--------------------
 net/netfilter/x_tables.c           | 50 +++++++++++++++++++++++++-----
 5 files changed, 55 insertions(+), 110 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 77c778d84d4cb..b1235098db87c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -297,6 +297,7 @@ struct xt_counters *xt_counters_alloc(unsigned int counters);
 
 struct xt_table *xt_register_table(struct net *net,
 				   const struct xt_table *table,
+				   const struct nf_hook_ops *template_ops,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo);
 void *xt_unregister_table(struct xt_table *table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 97ead883e4a13..c02e46a0271a0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1522,13 +1522,11 @@ int arpt_register_table(struct net *net,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *template_ops)
 {
-	struct nf_hook_ops *ops;
-	unsigned int num_ops;
-	int ret, i;
-	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
-	void *loc_cpu_entry;
+	struct xt_table_info *newinfo;
 	struct xt_table *new_table;
+	void *loc_cpu_entry;
+	int ret;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
@@ -1543,7 +1541,7 @@ int arpt_register_table(struct net *net,
 		return ret;
 	}
 
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, template_ops, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct arpt_entry *iter;
 
@@ -1553,31 +1551,6 @@ int arpt_register_table(struct net *net,
 		return PTR_ERR(new_table);
 	}
 
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	for (i = 0; i < num_ops; i++)
-		ops[i].priv = new_table;
-
-	new_table->ops = ops;
-
-	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret != 0)
-		goto out_free;
-
-	return ret;
-
-out_free:
-	__arpt_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 23c8deff8095a..488c5945ebb23 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1724,13 +1724,11 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *template_ops)
 {
-	struct nf_hook_ops *ops;
-	unsigned int num_ops;
-	int ret, i;
-	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
-	void *loc_cpu_entry;
+	struct xt_table_info *newinfo;
 	struct xt_table *new_table;
+	void *loc_cpu_entry;
+	int ret;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
@@ -1745,7 +1743,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		return ret;
 	}
 
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, template_ops, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct ipt_entry *iter;
 
@@ -1755,37 +1753,6 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		return PTR_ERR(new_table);
 	}
 
-	/* No template? No need to do anything. This is used by 'nat' table, it registers
-	 * with the nat core instead of the netfilter core.
-	 */
-	if (!template_ops)
-		return 0;
-
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	for (i = 0; i < num_ops; i++)
-		ops[i].priv = new_table;
-
-	new_table->ops = ops;
-
-	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret != 0)
-		goto out_free;
-
-	return ret;
-
-out_free:
-	__ipt_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d585ac3c11133..dbe7c7acd702e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1733,13 +1733,11 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *template_ops)
 {
-	struct nf_hook_ops *ops;
-	unsigned int num_ops;
-	int ret, i;
-	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
-	void *loc_cpu_entry;
+	struct xt_table_info *newinfo;
 	struct xt_table *new_table;
+	void *loc_cpu_entry;
+	int ret;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
@@ -1754,7 +1752,7 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		return ret;
 	}
 
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, template_ops, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct ip6t_entry *iter;
 
@@ -1764,34 +1762,6 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		return PTR_ERR(new_table);
 	}
 
-	if (!template_ops)
-		return 0;
-
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	for (i = 0; i < num_ops; i++)
-		ops[i].priv = new_table;
-
-	new_table->ops = ops;
-
-	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret != 0)
-		goto out_free;
-
-	return ret;
-
-out_free:
-	__ip6t_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f694eb72e48db..e5fda8c2fc6cb 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1475,7 +1475,6 @@ xt_replace_table(struct xt_table *table, unsigned int num_counters,
 	private = do_replace_table(table, num_counters, newinfo, error);
 	if (private)
 		audit_log_nfcfg(table->name, table->af, private->number,
-				!private->number ? AUDIT_XT_OP_REGISTER :
 				AUDIT_XT_OP_REPLACE,
 				GFP_KERNEL);
 
@@ -1485,20 +1484,32 @@ EXPORT_SYMBOL_GPL(xt_replace_table);
 
 struct xt_table *xt_register_table(struct net *net,
 				   const struct xt_table *input_table,
+				   const struct nf_hook_ops *template_ops,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo)
 {
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *t, *table = NULL;
+	struct nf_hook_ops *ops = NULL;
 	struct xt_table_info *private;
-	struct xt_table *t, *table;
-	int ret;
+	unsigned int num_ops;
+	int ret = -EINVAL;
+
+	num_ops = hweight32(input_table->valid_hooks);
+	if (num_ops == 0)
+		goto out;
+
+	ret = -ENOMEM;
+	if (template_ops) {
+		ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
+		if (!ops)
+			goto out;
+	}
 
 	/* Don't add one object to multiple lists. */
 	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
-	if (!table) {
-		ret = -ENOMEM;
+	if (!table)
 		goto out;
-	}
 
 	mutex_lock(&xt[table->af].mutex);
 	/* Don't autoload: we'd eat our tail... */
@@ -1512,7 +1523,7 @@ struct xt_table *xt_register_table(struct net *net,
 	/* Simplifies replace_table code. */
 	table->private = bootstrap;
 
-	if (!xt_replace_table(table, 0, newinfo, &ret))
+	if (!do_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
 	private = table->private;
@@ -1521,14 +1532,37 @@ struct xt_table *xt_register_table(struct net *net,
 	/* save number of initial entries */
 	private->initial_entries = private->number;
 
+	if (ops) {
+		int i;
+
+		for (i = 0; i < num_ops; i++)
+			ops[i].priv = table;
+
+		ret = nf_register_net_hooks(net, ops, num_ops);
+		if (ret != 0) {
+			mutex_unlock(&xt[table->af].mutex);
+			/* nf_register_net_hooks() might have published a
+			 * base chain before internal error unwind.
+			 */
+			synchronize_rcu();
+			goto out;
+		}
+
+		table->ops = ops;
+	}
+
+	audit_log_nfcfg(table->name, table->af, private->number,
+			AUDIT_XT_OP_REGISTER, GFP_KERNEL);
+
 	list_add(&table->list, &xt_net->tables[table->af]);
 	mutex_unlock(&xt[table->af].mutex);
 	return table;
 
 unlock:
 	mutex_unlock(&xt[table->af].mutex);
-	kfree(table);
 out:
+	kfree(table);
+	kfree(ops);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(xt_register_table);
-- 
2.53.0



