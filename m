Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351F1412C05;
	Fri,  7 Aug 2026 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116695; cv=none; b=ZSIfrHMsE2G3UeMokaaYDmIl+9unZ/YSPOfY8zVqg5HYKKU8EhvDQRJGuwyJuVdn06voXDc7mBr7Wj3+xKLiXxRjPqFmPiVnZ+CvH+N90M3FlMEwlGeRExbVLmAvLbKov1mDKpd0LUPnpRKtU4IQ0c7GCyQ+Matw5EIo5dm/+Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116695; c=relaxed/simple;
	bh=PYx0AVOwFixiIgEFIggt/lWc7xG2ny63Zhbap1veih4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4LZGYf9wlH9fhrDL7STVTm+llFwZM0Frr2rPIOkO81SsLeHyo9UKWkfsgfGdJMxI6dA42I0nl/Nxr1OouPBy9rPRDq7FvOYWK6yvUbaAGWTsbuQOmQcWA4+iihkMlHH+eCqIWtc/Swazw4FM0nrz7fBr4SoTOSQpjiEJWVPvZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM6r3ORv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM6r3ORv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915E51F000E9;
	Fri,  7 Aug 2026 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116694;
	bh=AFw3Z7bXQBaphBjMDu9VJ5qsQpQQCm6nM2bBVaNTETs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bM6r3ORvZ62gXkyn4NFyZ8y+ilV/Z+VVq6b1AZno5L5RKwnrx33lcBAcrEuQ4X4i9
	 RxPfXlpy/pV7/UZ9SlD3aj77p3/1F0J1RZxBXkW8nzngN45jxNhnl6uHDzSnw0z+tp
	 EEZ3uOuh5A9KlvXB19Gvon2m3cJ6lYJAMkh0CkVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 057/438] netfilter: nf_tables: make nft_object rhltable per table
Date: Fri,  7 Aug 2026 16:34:13 +0200
Message-ID: <20260807143429.206023798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f4f699790590bd0896c48a71e9232a65198f92f0 ]

The nft_object rhltable is global, this allows for accessing objects
that are being dismangled from lookup path by other existing netns.
Given the nft_obj_destroy() releases the object inmediately, this might
lead to use-after-free of these objects that are being released.
Make the existing rhltable per table to address this issue to deal with
with the nft_rcv_nl_event() path too.

Update nft_obj_lookup() to take the table as non-const, otherwise,
compiler complains when passing the objname_ht to rhltable_lookup().

Fixes: 4d44175aa5bb ("netfilter: nf_tables: handle nft_object lookups via rhltable")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 34 +++++++++++++++----------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d844354c4d95..3be612145c130 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1294,6 +1294,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@objname_ht: hashtable for objects lookup by name
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1313,6 +1314,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	struct rhltable			objname_ht;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
@@ -1400,7 +1402,7 @@ static inline void *nft_obj_data(const struct nft_object *obj)
 #define nft_expr_obj(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e1db3e678656d..c89e55ffc77d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -45,8 +45,6 @@ enum {
 	NFT_VALIDATE_DO,
 };
 
-static struct rhltable nft_objname_ht;
-
 static u32 nft_chain_hash(const void *data, u32 len, u32 seed);
 static u32 nft_chain_hash_obj(const void *data, u32 len, u32 seed);
 static int nft_chain_hash_cmp(struct rhashtable_compare_arg *, const void *);
@@ -1635,6 +1633,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err)
 		goto err_chain_ht;
 
+	err = rhltable_init(&table->objname_ht, &nft_objname_ht_params);
+	if (err < 0)
+		goto err_obj_ht;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -1653,6 +1655,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
+	rhltable_destroy(&table->objname_ht);
+err_obj_ht:
 	rhltable_destroy(&table->chains_ht);
 err_chain_ht:
 	kfree(table->udata);
@@ -1819,6 +1823,7 @@ static void nf_tables_table_destroy(struct nft_table *table)
 		return;
 
 	rhltable_destroy(&table->chains_ht);
+	rhltable_destroy(&table->objname_ht);
 	kfree(table->name);
 	kfree(table->udata);
 	kfree(table);
@@ -8082,7 +8087,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type)
 EXPORT_SYMBOL_GPL(nft_unregister_obj);
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask)
 {
@@ -8098,7 +8103,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 		     !lockdep_commit_lock_is_held(net));
 
 	rcu_read_lock();
-	list = rhltable_lookup(&nft_objname_ht, &k, nft_objname_ht_params);
+	list = rhltable_lookup(&table->objname_ht, &k, nft_objname_ht_params);
 	if (!list)
 		goto out;
 
@@ -8376,7 +8381,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_trans;
 
-	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
+	err = rhltable_insert(&table->objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
 		goto err_obj_ht;
@@ -8561,8 +8566,8 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	const struct nft_table *table;
 	struct net *net = info->net;
+	struct nft_table *table;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
 	u32 objtype;
@@ -10423,9 +10428,9 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
-static void nft_obj_del(struct nft_object *obj)
+static void nft_obj_del(struct nft_table *table, struct nft_object *obj)
 {
-	rhltable_remove(&nft_objname_ht, &obj->rhlhead, nft_objname_ht_params);
+	rhltable_remove(&table->objname_ht, &obj->rhlhead, nft_objname_ht_params);
 	list_del_rcu(&obj->list);
 }
 
@@ -11110,7 +11115,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELOBJ:
 		case NFT_MSG_DESTROYOBJ:
-			nft_obj_del(nft_trans_obj(trans));
+			nft_obj_del(table, nft_trans_obj(trans));
 			nf_tables_obj_notify(&ctx, nft_trans_obj(trans),
 					     trans->msg_type);
 			break;
@@ -11402,7 +11407,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 			} else {
 				nft_use_dec_restore(&table->use);
-				nft_obj_del(nft_trans_obj(trans));
+				nft_obj_del(table, nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
@@ -12025,7 +12030,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
-		nft_obj_del(obj);
+		nft_obj_del(table, obj);
 		nft_use_dec(&table->use);
 		nft_obj_destroy(&ctx, obj);
 	}
@@ -12207,10 +12212,6 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err_netdev_notifier;
 
-	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
-	if (err < 0)
-		goto err_rht_objname;
-
 	err = nft_offload_init();
 	if (err < 0)
 		goto err_offload;
@@ -12233,8 +12234,6 @@ static int __init nf_tables_module_init(void)
 err_netlink_notifier:
 	nft_offload_exit();
 err_offload:
-	rhltable_destroy(&nft_objname_ht);
-err_rht_objname:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 err_netdev_notifier:
 	nf_tables_core_module_exit();
@@ -12256,7 +12255,6 @@ static void __exit nf_tables_module_exit(void)
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_gc_work);
 	rcu_barrier();
-	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
 }
 
-- 
2.53.0



