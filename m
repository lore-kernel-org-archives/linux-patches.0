Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C4612D7;
	Tue, 20 Feb 2024 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463255; cv=none; b=k/9MN6A1k65i8X0SCbNm5k0ow+WIx0XZqoEHXMgSQ07xvbh6ppLZ3U9QbsK3p3NtuQsv3WJQpeCGaZPBZyKeaRz83Ihyd5AcWlzEJx3aYh+9tz5+wC/Xf5ooXc62CG+PHgEkn9DInJZm1r2RozzgLQCWbrm32ZHHaWpSUyL5EkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463255; c=relaxed/simple;
	bh=yfiJ5wdBVZJ+2ey8lFuihiVCpA7HZI3IRRshZJbeKcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH3m+rvZiWGxR/1tyNYft7T9En5NLEm/hVwgIEw+cpKPW9HyfozjZmUQvl47b98gmV8bCwUDbEUYaYJFRXgiTK49wH4n9LDmS8AWFU4B0Y7VwaBNGjYSzNlxQejc/6EM9qvHFzjH71aazcB8KbZ9MPKjBsACmG2xxWlMOdGcGN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR6AdLsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR6AdLsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83898C433F1;
	Tue, 20 Feb 2024 21:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463255;
	bh=yfiJ5wdBVZJ+2ey8lFuihiVCpA7HZI3IRRshZJbeKcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fR6AdLspQ8UdWsV4s8SPW0CkSFBCyT97tPamR12aDz7pYruEoL7dW+h9w0mznmpNj
	 m9GIzFt1PJHvdKrvXW8SNQb2Z77R4pGPPVA0/btLfF60DfCKEwUfWvWLeb2GMU2YKD
	 7X+15eRvfzLDAi6SIm8iFvfK5i7eLewCJBQTUemo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 184/197] netfilter: ipset: fix performance regression in swap operation
Date: Tue, 20 Feb 2024 21:52:23 +0100
Message-ID: <20240220204846.582344339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

commit 97f7cf1cd80eeed3b7c808b7c12463295c751001 upstream.

The patch "netfilter: ipset: fix race condition between swap/destroy
and kernel side add/del/test", commit 28628fa9 fixes a race condition.
But the synchronize_rcu() added to the swap function unnecessarily slows
it down: it can safely be moved to destroy and use call_rcu() instead.

Eric Dumazet pointed out that simply calling the destroy functions as
rcu callback does not work: sets with timeout use garbage collectors
which need cancelling at destroy which can wait. Therefore the destroy
functions are split into two: cancelling garbage collectors safely at
executing the command received by netlink and moving the remaining
part only into the rcu callback.

Link: https://lore.kernel.org/lkml/C0829B10-EAA6-4809-874E-E1E9C05A8D84@automattic.com/
Fixes: 28628fa952fe ("netfilter: ipset: fix race condition between swap/destroy and kernel side add/del/test")
Reported-by: Ale Crismani <ale.crismani@automattic.com>
Reported-by: David Wang <00107082@163.com>
Tested-by: David Wang <00107082@163.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netfilter/ipset/ip_set.h  |    4 +++
 net/netfilter/ipset/ip_set_bitmap_gen.h |   14 +++++++++---
 net/netfilter/ipset/ip_set_core.c       |   37 ++++++++++++++++++++++++--------
 net/netfilter/ipset/ip_set_hash_gen.h   |   15 ++++++++++--
 net/netfilter/ipset/ip_set_list_set.c   |   13 ++++++++---
 5 files changed, 65 insertions(+), 18 deletions(-)

--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -186,6 +186,8 @@ struct ip_set_type_variant {
 	/* Return true if "b" set is the same as "a"
 	 * according to the create set parameters */
 	bool (*same_set)(const struct ip_set *a, const struct ip_set *b);
+	/* Cancel ongoing garbage collectors before destroying the set*/
+	void (*cancel_gc)(struct ip_set *set);
 	/* Region-locking is used */
 	bool region_lock;
 };
@@ -242,6 +244,8 @@ extern void ip_set_type_unregister(struc
 
 /* A generic IP set */
 struct ip_set {
+	/* For call_cru in destroy */
+	struct rcu_head rcu;
 	/* The name of the set */
 	char name[IPSET_MAXNAMELEN];
 	/* Lock protecting the set data */
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -28,6 +28,7 @@
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_list		IPSET_TOKEN(MTYPE, _list)
 #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
+#define mtype_cancel_gc		IPSET_TOKEN(MTYPE, _cancel_gc)
 #define mtype			MTYPE
 
 #define get_ext(set, map, id)	((map)->extensions + ((set)->dsize * (id)))
@@ -57,9 +58,6 @@ mtype_destroy(struct ip_set *set)
 {
 	struct mtype *map = set->data;
 
-	if (SET_WITH_TIMEOUT(set))
-		del_timer_sync(&map->gc);
-
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
 	ip_set_free(map->members);
@@ -288,6 +286,15 @@ mtype_gc(struct timer_list *t)
 	add_timer(&map->gc);
 }
 
+static void
+mtype_cancel_gc(struct ip_set *set)
+{
+	struct mtype *map = set->data;
+
+	if (SET_WITH_TIMEOUT(set))
+		del_timer_sync(&map->gc);
+}
+
 static const struct ip_set_type_variant mtype = {
 	.kadt	= mtype_kadt,
 	.uadt	= mtype_uadt,
@@ -301,6 +308,7 @@ static const struct ip_set_type_variant
 	.head	= mtype_head,
 	.list	= mtype_list,
 	.same_set = mtype_same_set,
+	.cancel_gc = mtype_cancel_gc,
 };
 
 #endif /* __IP_SET_BITMAP_IP_GEN_H */
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1184,6 +1184,14 @@ ip_set_destroy_set(struct ip_set *set)
 	kfree(set);
 }
 
+static void
+ip_set_destroy_set_rcu(struct rcu_head *head)
+{
+	struct ip_set *set = container_of(head, struct ip_set, rcu);
+
+	ip_set_destroy_set(set);
+}
+
 static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 			  const struct nlattr * const attr[])
 {
@@ -1195,8 +1203,6 @@ static int ip_set_destroy(struct sk_buff
 	if (unlikely(protocol_min_failed(attr)))
 		return -IPSET_ERR_PROTOCOL;
 
-	/* Must wait for flush to be really finished in list:set */
-	rcu_barrier();
 
 	/* Commands are serialized and references are
 	 * protected by the ip_set_ref_lock.
@@ -1208,8 +1214,10 @@ static int ip_set_destroy(struct sk_buff
 	 * counter, so if it's already zero, we can proceed
 	 * without holding the lock.
 	 */
-	read_lock_bh(&ip_set_ref_lock);
 	if (!attr[IPSET_ATTR_SETNAME]) {
+		/* Must wait for flush to be really finished in list:set */
+		rcu_barrier();
+		read_lock_bh(&ip_set_ref_lock);
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
 			if (s && (s->ref || s->ref_netlink)) {
@@ -1223,6 +1231,8 @@ static int ip_set_destroy(struct sk_buff
 			s = ip_set(inst, i);
 			if (s) {
 				ip_set(inst, i) = NULL;
+				/* Must cancel garbage collectors */
+				s->variant->cancel_gc(s);
 				ip_set_destroy_set(s);
 			}
 		}
@@ -1230,6 +1240,9 @@ static int ip_set_destroy(struct sk_buff
 		inst->is_destroyed = false;
 	} else {
 		u32 flags = flag_exist(info->nlh);
+		u16 features = 0;
+
+		read_lock_bh(&ip_set_ref_lock);
 		s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 				    &i);
 		if (!s) {
@@ -1240,10 +1253,16 @@ static int ip_set_destroy(struct sk_buff
 			ret = -IPSET_ERR_BUSY;
 			goto out;
 		}
+		features = s->type->features;
 		ip_set(inst, i) = NULL;
 		read_unlock_bh(&ip_set_ref_lock);
-
-		ip_set_destroy_set(s);
+		if (features & IPSET_TYPE_NAME) {
+			/* Must wait for flush to be really finished  */
+			rcu_barrier();
+		}
+		/* Must cancel garbage collectors */
+		s->variant->cancel_gc(s);
+		call_rcu(&s->rcu, ip_set_destroy_set_rcu);
 	}
 	return 0;
 out:
@@ -1396,9 +1415,6 @@ static int ip_set_swap(struct sk_buff *s
 	ip_set(inst, to_id) = from;
 	write_unlock_bh(&ip_set_ref_lock);
 
-	/* Make sure all readers of the old set pointers are completed. */
-	synchronize_rcu();
-
 	return 0;
 }
 
@@ -2411,8 +2427,11 @@ ip_set_fini(void)
 {
 	nf_unregister_sockopt(&so_set);
 	nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
-
 	unregister_pernet_subsys(&ip_set_net_ops);
+
+	/* Wait for call_rcu() in destroy */
+	rcu_barrier();
+
 	pr_debug("these are the famous last words\n");
 }
 
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -210,6 +210,7 @@ htable_size(u8 hbits)
 #undef mtype_gc_do
 #undef mtype_gc
 #undef mtype_gc_init
+#undef mtype_cancel_gc
 #undef mtype_variant
 #undef mtype_data_match
 
@@ -254,6 +255,7 @@ htable_size(u8 hbits)
 #define mtype_gc_do		IPSET_TOKEN(MTYPE, _gc_do)
 #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
 #define mtype_gc_init		IPSET_TOKEN(MTYPE, _gc_init)
+#define mtype_cancel_gc		IPSET_TOKEN(MTYPE, _cancel_gc)
 #define mtype_variant		IPSET_TOKEN(MTYPE, _variant)
 #define mtype_data_match	IPSET_TOKEN(MTYPE, _data_match)
 
@@ -437,9 +439,6 @@ mtype_destroy(struct ip_set *set)
 	struct htype *h = set->data;
 	struct list_head *l, *lt;
 
-	if (SET_WITH_TIMEOUT(set))
-		cancel_delayed_work_sync(&h->gc.dwork);
-
 	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
 	list_for_each_safe(l, lt, &h->ad) {
 		list_del(l);
@@ -586,6 +585,15 @@ mtype_gc_init(struct htable_gc *gc)
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, HZ);
 }
 
+static void
+mtype_cancel_gc(struct ip_set *set)
+{
+	struct htype *h = set->data;
+
+	if (SET_WITH_TIMEOUT(set))
+		cancel_delayed_work_sync(&h->gc.dwork);
+}
+
 static int
 mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	  struct ip_set_ext *mext, u32 flags);
@@ -1416,6 +1424,7 @@ static const struct ip_set_type_variant
 	.uref	= mtype_uref,
 	.resize	= mtype_resize,
 	.same_set = mtype_same_set,
+	.cancel_gc = mtype_cancel_gc,
 	.region_lock = true,
 };
 
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -426,9 +426,6 @@ list_set_destroy(struct ip_set *set)
 	struct list_set *map = set->data;
 	struct set_elem *e, *n;
 
-	if (SET_WITH_TIMEOUT(set))
-		del_timer_sync(&map->gc);
-
 	list_for_each_entry_safe(e, n, &map->members, list) {
 		list_del(&e->list);
 		ip_set_put_byindex(map->net, e->id);
@@ -545,6 +542,15 @@ list_set_same_set(const struct ip_set *a
 	       a->extensions == b->extensions;
 }
 
+static void
+list_set_cancel_gc(struct ip_set *set)
+{
+	struct list_set *map = set->data;
+
+	if (SET_WITH_TIMEOUT(set))
+		del_timer_sync(&map->gc);
+}
+
 static const struct ip_set_type_variant set_variant = {
 	.kadt	= list_set_kadt,
 	.uadt	= list_set_uadt,
@@ -558,6 +564,7 @@ static const struct ip_set_type_variant
 	.head	= list_set_head,
 	.list	= list_set_list,
 	.same_set = list_set_same_set,
+	.cancel_gc = list_set_cancel_gc,
 };
 
 static void


