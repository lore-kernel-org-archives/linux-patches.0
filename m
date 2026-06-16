Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33251E8320;
	Tue, 16 Jun 2026 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627022; cv=none; b=tgczjpvaynPj5gslk6owqzcLBDpt6EyJgiyxhCwD5wpDEDtDaDyVdSPMTivlZEWVp8K5NtXSCtxlP7yrbQHkAEkCuHhLYvW/m0ll7L3AUcEWc62GaS27s6g7hxbJmp1VaD6e4QuJhi8lsyvuRr1r8kV2A5Qu/csNXAuIDHxkqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627022; c=relaxed/simple;
	bh=d0kgvPDrst4wyULrA/zXa74PQvgFiWKBG33QfzMRBNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StJBbqmvXgk0iz8i1fPp5nfQfQvUSxppoTeHDH2QjrrIwDAtAAJxfZrMiSAGUg9TFjdoMZLINnGqWMxgcSLpM1zthXqVLlVEZBzqJhivem1TmXG+9q0YCVhT8CpdodjkyMNvXVZj+rCqp7gKMjxynpQvFlSx55jQ3fceK34sU3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRz8fWqh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRz8fWqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9898C1F000E9;
	Tue, 16 Jun 2026 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627020;
	bh=KC950CIoc20OHTxw66T6yaE3Y82+WyC13zW4+OXIq+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRz8fWqhl4Mrnr+QAzGDVu9xcS0gPc9O4K09GpRVV0P2ufpcW1wxBQHrR87BoDIbj
	 hol0GRKHV8T92oLALRwGnhAK0h5IWQ/MJzdf05Qn87FBFtG3owPagCT3hJ7X9g0Jcu
	 trsmDPNSGO5KBfe86dTXhm/9CRG07/RUtQK9m5h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Mark Bundschuh <mkbund@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/261] netfilter: ctnetlink: ensure safe access to master conntrack
Date: Tue, 16 Jun 2026 20:29:06 +0530
Message-ID: <20260616145050.063454212@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit bffcaad9afdfe45d7fc777397d3b83c1e3ebffe5 ]

Holding reference on the expectation is not sufficient, the master
conntrack object can just go away, making exp->master invalid.

To access exp->master safely:

- Grab the nf_conntrack_expect_lock, this gets serialized with
  clean_from_lists() which also holds this lock when the master
  conntrack goes away.

- Hold reference on master conntrack via nf_conntrack_find_get().
  Not so easy since the master tuple to look up for the master conntrack
  is not available in the existing problematic paths.

This patch goes for extending the nf_conntrack_expect_lock section
to address this issue for simplicity, in the cases that are described
below this is just slightly extending the lock section.

The add expectation command already holds a reference to the master
conntrack from ctnetlink_create_expect().

However, the delete expectation command needs to grab the spinlock
before looking up for the expectation. Expand the existing spinlock
section to address this to cover the expectation lookup. Note that,
the nf_ct_expect_iterate_net() calls already grabs the spinlock while
iterating over the expectation table, which is correct.

The get expectation command needs to grab the spinlock to ensure master
conntrack does not go away. This also expands the existing spinlock
section to cover the expectation lookup too. I needed to move the
netlink skb allocation out of the spinlock to keep it GFP_KERNEL.

For the expectation events, the IPEXP_DESTROY event is already delivered
under the spinlock, just move the delivery of IPEXP_NEW under the
spinlock too because the master conntrack event cache is reached through
exp->master.

While at it, add lockdep notations to help identify what codepaths need
to grab the spinlock.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ fix timer_delete -> del_timer in diff context lines since 8fa7292
("treewide: Switch/rename to timer_delete[_sync]()") landed in 6.15 ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_core.h |  5 ++++
 net/netfilter/nf_conntrack_ecache.c       |  2 ++
 net/netfilter/nf_conntrack_expect.c       | 10 +++++++-
 net/netfilter/nf_conntrack_netlink.c      | 28 +++++++++++++++--------
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3384859a892101..8883575adcc1e7 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -83,6 +83,11 @@ void nf_conntrack_lock(spinlock_t *lock);
 
 extern spinlock_t nf_conntrack_expect_lock;
 
+static inline void lockdep_nfct_expect_lock_held(void)
+{
+	lockdep_assert_held(&nf_conntrack_expect_lock);
+}
+
 /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
 
 static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 69948e1d6974e3..6526bdcca580fd 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -237,6 +237,8 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
+	lockdep_nfct_expect_lock_held();
+
 	rcu_read_lock();
 	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
 	if (!notify)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f5c45989df5736..bb8b87f9ee50da 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -51,6 +51,7 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	struct net *net = nf_ct_exp_net(exp);
 	struct nf_conntrack_net *cnet;
 
+	lockdep_nfct_expect_lock_held();
 	WARN_ON(!master_help);
 	WARN_ON(timer_pending(&exp->timeout));
 
@@ -118,6 +119,8 @@ nf_ct_exp_equal(const struct nf_conntrack_tuple *tuple,
 
 bool nf_ct_remove_expect(struct nf_conntrack_expect *exp)
 {
+	lockdep_nfct_expect_lock_held();
+
 	if (del_timer(&exp->timeout)) {
 		nf_ct_unlink_expect(exp);
 		nf_ct_expect_put(exp);
@@ -177,6 +180,8 @@ nf_ct_find_expectation(struct net *net,
 	struct nf_conntrack_expect *i, *exp = NULL;
 	unsigned int h;
 
+	lockdep_nfct_expect_lock_held();
+
 	if (!cnet->expect_count)
 		return NULL;
 
@@ -459,6 +464,8 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 	unsigned int h;
 	int ret = 0;
 
+	lockdep_nfct_expect_lock_held();
+
 	if (!master_help) {
 		ret = -ESHUTDOWN;
 		goto out;
@@ -515,8 +522,9 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 
 	nf_ct_expect_insert(expect);
 
-	spin_unlock_bh(&nf_conntrack_expect_lock);
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
 	return 0;
 out:
 	spin_unlock_bh(&nf_conntrack_expect_lock);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f51cdfba68fbdb..507f17722f375b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3332,31 +3332,37 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
+	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb2)
+		return -ENOMEM;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
 	exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
-	if (!exp)
+	if (!exp) {
+		spin_unlock_bh(&nf_conntrack_expect_lock);
+		kfree_skb(skb2);
 		return -ENOENT;
+	}
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 
 		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
+			spin_unlock_bh(&nf_conntrack_expect_lock);
+			kfree_skb(skb2);
 			return -ENOENT;
 		}
 	}
 
-	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb2) {
-		nf_ct_expect_put(exp);
-		return -ENOMEM;
-	}
-
 	rcu_read_lock();
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      exp);
 	rcu_read_unlock();
 	nf_ct_expect_put(exp);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
 	if (err <= 0) {
 		kfree_skb(skb2);
 		return -ENOMEM;
@@ -3403,22 +3409,26 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 		if (err < 0)
 			return err;
 
+		spin_lock_bh(&nf_conntrack_expect_lock);
+
 		/* bump usage count to 2 */
 		exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
-		if (!exp)
+		if (!exp) {
+			spin_unlock_bh(&nf_conntrack_expect_lock);
 			return -ENOENT;
+		}
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 
 			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
+				spin_unlock_bh(&nf_conntrack_expect_lock);
 				return -ENOENT;
 			}
 		}
 
 		/* after list removal, usage count == 1 */
-		spin_lock_bh(&nf_conntrack_expect_lock);
 		if (del_timer(&exp->timeout)) {
 			nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
 						   nlmsg_report(info->nlh));
-- 
2.53.0



