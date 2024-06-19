Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E94612FB31;
	Wed, 19 Jun 2024 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802409; cv=none; b=mkQPaN6VOeShhsiMReI0Mw43Jda/7nn8ueULZG212EL1LQjljXEIhFyHZVKrvEczeK0rMA+F4cXadOS1BcghiPIE2X3H477RyMj3ls/s9uYx1/rfzAa2L1KlVen7vw9+4Dn6zRFdDVHaWCgkHuFwMuN2exmZ+0oRHwACTj4CGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802409; c=relaxed/simple;
	bh=AUwBEpHYClO8wrEswkgxDSvaQrkXQu2OFXyNuvIx4ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEt5fRfJlOPPhglVYtKqUBtJtTOEL/hrufUtiSbxGsxAmlLBk1Un7+tLf90WiYBrOM8upoVfc5CO41Tnh50cPydsSpl5j/aOcAFCwQRqidLRIgFbjlu2aAiwSRU+KD7PphMS7Txz6o5//wTyZ17fzM5GQG9Y3YG/kW3xwFW9tZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjWt9uup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjWt9uup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A1EC2BBFC;
	Wed, 19 Jun 2024 13:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802409;
	bh=AUwBEpHYClO8wrEswkgxDSvaQrkXQu2OFXyNuvIx4ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjWt9uupGgXJFoG+HfQBko+aCWmIlSHn2akhOsLtTtystacGqAu/KDFNtRxkJk/TP
	 iSWDhHsPk26uyFOmUvn3E+CD0paK+6TJFTQpC0X0xgFcQYy88YBDIC9WUTXwz5bZWo
	 qUcCrRvUKBfjfdXKutmZwznHm0mYkzCopAZIG9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lion Ackermann <nnamrec@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/267] netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type
Date: Wed, 19 Jun 2024 14:55:07 +0200
Message-ID: <20240619125612.331843461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 4e7aaa6b82d63e8ddcbfb56b4fd3d014ca586f10 ]

Lion Ackermann reported that there is a race condition between namespace cleanup
in ipset and the garbage collection of the list:set type. The namespace
cleanup can destroy the list:set type of sets while the gc of the set type is
waiting to run in rcu cleanup. The latter uses data from the destroyed set which
thus leads use after free. The patch contains the following parts:

- When destroying all sets, first remove the garbage collectors, then wait
  if needed and then destroy the sets.
- Fix the badly ordered "wait then remove gc" for the destroy a single set
  case.
- Fix the missing rcu locking in the list:set type in the userspace test
  case.
- Use proper RCU list handlings in the list:set type.

The patch depends on c1193d9bbbd3 (netfilter: ipset: Add list flush to cancel_gc).

Fixes: 97f7cf1cd80e (netfilter: ipset: fix performance regression in swap operation)
Reported-by: Lion Ackermann <nnamrec@gmail.com>
Tested-by: Lion Ackermann <nnamrec@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c     | 81 +++++++++++++++------------
 net/netfilter/ipset/ip_set_list_set.c | 30 +++++-----
 2 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3184cc6be4c9d..c7ae4d9bf3d24 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1172,23 +1172,50 @@ ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] = {
 				    .len = IPSET_MAXNAMELEN - 1 },
 };
 
+/* In order to return quickly when destroying a single set, it is split
+ * into two stages:
+ * - Cancel garbage collector
+ * - Destroy the set itself via call_rcu()
+ */
+
 static void
-ip_set_destroy_set(struct ip_set *set)
+ip_set_destroy_set_rcu(struct rcu_head *head)
 {
-	pr_debug("set: %s\n",  set->name);
+	struct ip_set *set = container_of(head, struct ip_set, rcu);
 
-	/* Must call it without holding any lock */
 	set->variant->destroy(set);
 	module_put(set->type->me);
 	kfree(set);
 }
 
 static void
-ip_set_destroy_set_rcu(struct rcu_head *head)
+_destroy_all_sets(struct ip_set_net *inst)
 {
-	struct ip_set *set = container_of(head, struct ip_set, rcu);
+	struct ip_set *set;
+	ip_set_id_t i;
+	bool need_wait = false;
 
-	ip_set_destroy_set(set);
+	/* First cancel gc's: set:list sets are flushed as well */
+	for (i = 0; i < inst->ip_set_max; i++) {
+		set = ip_set(inst, i);
+		if (set) {
+			set->variant->cancel_gc(set);
+			if (set->type->features & IPSET_TYPE_NAME)
+				need_wait = true;
+		}
+	}
+	/* Must wait for flush to be really finished  */
+	if (need_wait)
+		rcu_barrier();
+	for (i = 0; i < inst->ip_set_max; i++) {
+		set = ip_set(inst, i);
+		if (set) {
+			ip_set(inst, i) = NULL;
+			set->variant->destroy(set);
+			module_put(set->type->me);
+			kfree(set);
+		}
+	}
 }
 
 static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
@@ -1202,11 +1229,10 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 	if (unlikely(protocol_min_failed(attr)))
 		return -IPSET_ERR_PROTOCOL;
 
-
 	/* Commands are serialized and references are
 	 * protected by the ip_set_ref_lock.
 	 * External systems (i.e. xt_set) must call
-	 * ip_set_put|get_nfnl_* functions, that way we
+	 * ip_set_nfnl_get_* functions, that way we
 	 * can safely check references here.
 	 *
 	 * list:set timer can only decrement the reference
@@ -1214,8 +1240,6 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 	 * without holding the lock.
 	 */
 	if (!attr[IPSET_ATTR_SETNAME]) {
-		/* Must wait for flush to be really finished in list:set */
-		rcu_barrier();
 		read_lock_bh(&ip_set_ref_lock);
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
@@ -1226,15 +1250,7 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 		inst->is_destroyed = true;
 		read_unlock_bh(&ip_set_ref_lock);
-		for (i = 0; i < inst->ip_set_max; i++) {
-			s = ip_set(inst, i);
-			if (s) {
-				ip_set(inst, i) = NULL;
-				/* Must cancel garbage collectors */
-				s->variant->cancel_gc(s);
-				ip_set_destroy_set(s);
-			}
-		}
+		_destroy_all_sets(inst);
 		/* Modified by ip_set_destroy() only, which is serialized */
 		inst->is_destroyed = false;
 	} else {
@@ -1255,12 +1271,12 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 		features = s->type->features;
 		ip_set(inst, i) = NULL;
 		read_unlock_bh(&ip_set_ref_lock);
+		/* Must cancel garbage collectors */
+		s->variant->cancel_gc(s);
 		if (features & IPSET_TYPE_NAME) {
 			/* Must wait for flush to be really finished  */
 			rcu_barrier();
 		}
-		/* Must cancel garbage collectors */
-		s->variant->cancel_gc(s);
 		call_rcu(&s->rcu, ip_set_destroy_set_rcu);
 	}
 	return 0;
@@ -2365,30 +2381,25 @@ ip_set_net_init(struct net *net)
 }
 
 static void __net_exit
-ip_set_net_exit(struct net *net)
+ip_set_net_pre_exit(struct net *net)
 {
 	struct ip_set_net *inst = ip_set_pernet(net);
 
-	struct ip_set *set = NULL;
-	ip_set_id_t i;
-
 	inst->is_deleted = true; /* flag for ip_set_nfnl_put */
+}
 
-	nfnl_lock(NFNL_SUBSYS_IPSET);
-	for (i = 0; i < inst->ip_set_max; i++) {
-		set = ip_set(inst, i);
-		if (set) {
-			ip_set(inst, i) = NULL;
-			set->variant->cancel_gc(set);
-			ip_set_destroy_set(set);
-		}
-	}
-	nfnl_unlock(NFNL_SUBSYS_IPSET);
+static void __net_exit
+ip_set_net_exit(struct net *net)
+{
+	struct ip_set_net *inst = ip_set_pernet(net);
+
+	_destroy_all_sets(inst);
 	kvfree(rcu_dereference_protected(inst->ip_set_list, 1));
 }
 
 static struct pernet_operations ip_set_net_ops = {
 	.init	= ip_set_net_init,
+	.pre_exit = ip_set_net_pre_exit,
 	.exit   = ip_set_net_exit,
 	.id	= &ip_set_net_id,
 	.size	= sizeof(struct ip_set_net),
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 54e2a1dd7f5f5..bfae7066936bb 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -79,7 +79,7 @@ list_set_kadd(struct ip_set *set, const struct sk_buff *skb,
 	struct set_elem *e;
 	int ret;
 
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -99,7 +99,7 @@ list_set_kdel(struct ip_set *set, const struct sk_buff *skb,
 	struct set_elem *e;
 	int ret;
 
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -188,9 +188,10 @@ list_set_utest(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct list_set *map = set->data;
 	struct set_adt_elem *d = value;
 	struct set_elem *e, *next, *prev = NULL;
-	int ret;
+	int ret = 0;
 
-	list_for_each_entry(e, &map->members, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -201,6 +202,7 @@ list_set_utest(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 		if (d->before == 0) {
 			ret = 1;
+			goto out;
 		} else if (d->before > 0) {
 			next = list_next_entry(e, list);
 			ret = !list_is_last(&e->list, &map->members) &&
@@ -208,9 +210,11 @@ list_set_utest(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		} else {
 			ret = prev && prev->id == d->refid;
 		}
-		return ret;
+		goto out;
 	}
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static void
@@ -239,7 +243,7 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	/* Find where to add the new entry */
 	n = prev = next = NULL;
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -316,9 +320,9 @@ list_set_udel(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 {
 	struct list_set *map = set->data;
 	struct set_adt_elem *d = value;
-	struct set_elem *e, *next, *prev = NULL;
+	struct set_elem *e, *n, *next, *prev = NULL;
 
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_safe(e, n, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -424,14 +428,8 @@ static void
 list_set_destroy(struct ip_set *set)
 {
 	struct list_set *map = set->data;
-	struct set_elem *e, *n;
 
-	list_for_each_entry_safe(e, n, &map->members, list) {
-		list_del(&e->list);
-		ip_set_put_byindex(map->net, e->id);
-		ip_set_ext_destroy(set, e);
-		kfree(e);
-	}
+	WARN_ON_ONCE(!list_empty(&map->members));
 	kfree(map);
 
 	set->data = NULL;
-- 
2.43.0



