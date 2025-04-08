Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD01F2690DB;
	Tue,  8 Apr 2025 10:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109770; cv=none; b=AjpcL/dVMJr7FKh5cGDqhluXDk9PHdhGhBVtJFAzv6QamlI00Fzx/kBKBht9v6NCF/oYKiT80tKDmf33cDDlOWZCTGMzylGySvX1zofLwDXvUaJNSTiQgl965aeHDKC7orCfqd0myHQL/HV/DnUwCAAMXJZlR0DLY6fsOzQho5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109770; c=relaxed/simple;
	bh=rK1lN46eAakVNTJKqbpjMrnTPaxF3bfOuEEIiuPay7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3JF6Ux++/ie+DPelu+Ah5xfJgVYXjuaouvfQIX31sMQCZ5xz7BWcrDOu1M277mv3t66uA2MZuowZ+7Zo/yCJQylR60v/EC8G1lq1a6J1Gses4aXFf8xX7uDXHUUJ9LeJdowaUBD4lM4YyEIR8vZRJS/o4f2gzE/wKWpn7B/wlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5PJ623l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5PJ623l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0E1C4CEE5;
	Tue,  8 Apr 2025 10:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109770;
	bh=rK1lN46eAakVNTJKqbpjMrnTPaxF3bfOuEEIiuPay7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5PJ623lS0ia5DOR7C1zJOI7m8zyxRcUxlKK9xQJua0D6Ib3HZhPvTEUteHNp5gFs
	 FoX5RG+MDYKQ5pnLQE1dA6vEMIiSb74cdbnCjA3wD6AByOfkg93DtSlGz5CAkAQoKt
	 BokrNSjNjM99HoOlu+gOjhEV5u/A5d8x0kteDwIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/227] netfilter: conntrack: convert to refcount_t api
Date: Tue,  8 Apr 2025 12:46:27 +0200
Message-ID: <20250408104820.666485724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 719774377622bc4025d2a74f551b5dc2158c6c30 ]

Convert nf_conn reference counting from atomic_t to refcount_t based api.
refcount_t api provides more runtime sanity checks and will warn on
certain constructs, e.g. refcount_inc() on a zero reference count, which
usually indicates use-after-free.

For this reason template allocation is changed to init the refcount to
1, the subsequenct add operations are removed.

Likewise, init_conntrack() is changed to set the initial refcount to 1
instead refcount_inc().

This is safe because the new entry is not (yet) visible to other cpus.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 5cfe5612ca95 ("netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/nf_conntrack_common.h |  8 +++---
 net/netfilter/nf_conntrack_core.c             | 26 +++++++++----------
 net/netfilter/nf_conntrack_expect.c           |  4 +--
 net/netfilter/nf_conntrack_netlink.c          |  6 ++---
 net/netfilter/nf_conntrack_standalone.c       |  4 +--
 net/netfilter/nf_flow_table_core.c            |  2 +-
 net/netfilter/nf_synproxy_core.c              |  1 -
 net/netfilter/nft_ct.c                        |  4 +--
 net/netfilter/xt_CT.c                         |  3 +--
 net/openvswitch/conntrack.c                   |  1 -
 net/sched/act_ct.c                            |  1 -
 11 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 0c7d8d1e945dd..ce8a4eb69b5c1 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -2,7 +2,7 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
 struct ip_conntrack_stat {
@@ -24,19 +24,19 @@ struct ip_conntrack_stat {
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
 struct nf_conntrack {
-	atomic_t use;
+	refcount_t use;
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
+	if (nfct && refcount_dec_and_test(&nfct->use))
 		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		atomic_inc(&nfct->use);
+		refcount_inc(&nfct->use);
 }
 
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 99d5d8cd3895f..b8032cc378b8e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -564,7 +564,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 	nf_ct_zone_add(tmpl, zone);
-	atomic_set(&tmpl->ct_general.use, 0);
+	refcount_set(&tmpl->ct_general.use, 1);
 
 	return tmpl;
 }
@@ -597,7 +597,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
 	pr_debug("destroy_conntrack(%p)\n", ct);
-	WARN_ON(atomic_read(&nfct->use) != 0);
+	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -716,7 +716,7 @@ nf_ct_match(const struct nf_conn *ct1, const struct nf_conn *ct2)
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
 	if (nf_ct_should_gc(ct))
@@ -784,7 +784,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		 * in, try to obtain a reference and re-check tuple
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
+		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -853,7 +853,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
-	atomic_set(&ct->ct_general.use, 2);
+	refcount_set(&ct->ct_general.use, 2);
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
@@ -902,7 +902,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 {
 	struct nf_conn_tstamp *tstamp;
 
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	ct->status |= IPS_CONFIRMED;
 
 	/* set conntrack timestamp, if enabled. */
@@ -1281,7 +1281,7 @@ static unsigned int early_drop_list(struct net *net,
 		    nf_ct_is_dying(tmp))
 			continue;
 
-		if (!atomic_inc_not_zero(&tmp->ct_general.use))
+		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
 		/* kill only if still in same netns -- might have moved due to
@@ -1397,7 +1397,7 @@ static void gc_worker(struct work_struct *work)
 				continue;
 
 			/* need to take reference to avoid possible races */
-			if (!atomic_inc_not_zero(&tmp->ct_general.use))
+			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
 			if (gc_worker_skip_ct(tmp)) {
@@ -1498,7 +1498,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
-	atomic_set(&ct->ct_general.use, 0);
+	refcount_set(&ct->ct_general.use, 0);
 	return ct;
 out:
 	atomic_dec(&net->ct.count);
@@ -1522,7 +1522,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
 	 */
-	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
+	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
@@ -1610,8 +1610,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
-	/* Now it is inserted into the unconfirmed list, bump refcount */
-	nf_conntrack_get(&ct->ct_general);
+	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
+	refcount_set(&ct->ct_general.use, 1);
 	nf_ct_add_to_unconfirmed_list(ct);
 
 	local_bh_enable();
@@ -2214,7 +2214,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 
 	return NULL;
 found:
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	spin_unlock(lockp);
 	local_bh_enable();
 	return ct;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 42557d2b6a908..516a9f05a87a7 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -187,12 +187,12 @@ nf_ct_find_expectation(struct net *net,
 	 * about to invoke ->destroy(), or nf_ct_delete() via timeout
 	 * or early_drop().
 	 *
-	 * The atomic_inc_not_zero() check tells:  If that fails, we
+	 * The refcount_inc_not_zero() check tells:  If that fails, we
 	 * know that the ct is being destroyed.  If it succeeds, we
 	 * can be sure the ct cannot disappear underneath.
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
-		     !atomic_inc_not_zero(&exp->master->ct_general.use)))
+		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8c9edad0826ef..705d77dc74b93 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -506,7 +506,7 @@ static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 
 static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
+	if (nla_put_be32(skb, CTA_USE, htonl(refcount_read(&ct->ct_general.use))))
 		goto nla_put_failure;
 	return 0;
 
@@ -1150,7 +1150,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
-				    atomic_inc_not_zero(&ct->ct_general.use))
+				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
 				continue;
 			}
@@ -1701,7 +1701,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 						  ct, dying ? true : false, 0);
 			if (res < 0) {
-				if (!atomic_inc_not_zero(&ct->ct_general.use))
+				if (!refcount_inc_not_zero(&ct->ct_general.use))
 					continue;
 				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b613de96ad855..073d10e212021 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -300,7 +300,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	int ret = 0;
 
 	WARN_ON(!ct);
-	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
 	if (nf_ct_should_gc(ct)) {
@@ -367,7 +367,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	ct_show_zone(s, ct, NF_CT_DEFAULT_ZONE_DIR);
 	ct_show_delta_time(s, ct);
 
-	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	seq_printf(s, "use=%u\n", refcount_read(&ct->ct_general.use));
 
 	if (seq_has_overflowed(s))
 		goto release;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d091d51b5e19f..e05e09c07b971 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -48,7 +48,7 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 	struct flow_offload *flow;
 
 	if (unlikely(nf_ct_is_dying(ct) ||
-	    !atomic_inc_not_zero(&ct->ct_general.use)))
+	    !refcount_inc_not_zero(&ct->ct_general.use)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 3d6d49420db8b..2dfc5dae06563 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -349,7 +349,6 @@ static int __net_init synproxy_net_init(struct net *net)
 		goto err2;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 	snet->tmpl = ct;
 
 	snet->stats = alloc_percpu(struct synproxy_stats);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 2a8dfa68f6e20..78631804e5c53 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -259,7 +259,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(atomic_read(&ct->ct_general.use) == 1)) {
+	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
 		/* previous skb got queued to userspace */
@@ -270,7 +270,6 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 		}
 	}
 
-	atomic_inc(&ct->ct_general.use);
 	nf_ct_set(skb, ct, IP_CT_NEW);
 }
 #endif
@@ -375,7 +374,6 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 			return false;
 		}
 
-		atomic_set(&tmp->ct_general.use, 1);
 		per_cpu(nft_ct_pcpu_template, cpu) = tmp;
 	}
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index d4deee39158ba..ffff1e1f79b91 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -24,7 +24,7 @@ static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 		return XT_CONTINUE;
 
 	if (ct) {
-		atomic_inc(&ct->ct_general.use);
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_set(skb, ct, IP_CT_NEW);
 	} else {
 		nf_ct_set(skb, ct, IP_CT_UNTRACKED);
@@ -202,7 +202,6 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			goto err4;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 out:
 	info->ct = ct;
 	return 0;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 30f5e414018b1..9e8b3b930f926 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1713,7 +1713,6 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 		goto err_free_ct;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct_info.ct->status);
-	nf_conntrack_get(&ct_info.ct->ct_general);
 	return 0;
 err_free_ct:
 	__ovs_ct_free_action(&ct_info);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 4ea7a81707f3f..d9748c917a503 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1235,7 +1235,6 @@ static int tcf_ct_fill_params(struct net *net,
 		return -ENOMEM;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
-	nf_conntrack_get(&tmpl->ct_general);
 	p->tmpl = tmpl;
 
 	return 0;
-- 
2.39.5



