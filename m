Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D847127A;
	Tue, 21 Jul 2026 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659898; cv=none; b=B0leis3VNUx3rSNAIHBUjnB29Dq48AoEfDkUj2kW/hYuVUmpCjMQmYKG8qsh5PrRhMVuQdKcPfUTo6/nJ+yn6tMnYQyh1CsWu7XYo5Fy0KT1TkRZLLUzgJPdYNLUcxPqMkVQHvJhs4d6cyu6qVcaypSOs4ogFREJfsD93YMQHoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659898; c=relaxed/simple;
	bh=gZgeXd26PO7+XjFUekphY72626wU5GA5ydTmNGVk+Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwxPCG6H3+bPO8+QPvkeRlV7ZRe/4IFv72orDvzKqRogg8P05D/NcT38wnSl7iKBy7SN4TVAWmqGBei+bEgHlVH72fOCQnpsfgyjSxdFqKcEkQF+GEG7EJnD36r6V20a5bPdmmgXDaYTPFi7n/ecQhseyex+XtgTRvWh0uzbGr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP5alzeZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP5alzeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3040E1F000E9;
	Tue, 21 Jul 2026 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659897;
	bh=dvhXn8ZK334Zt0cwjmiiD8srz5VNL+pH7nirwEJaivo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VP5alzeZ3SYuQcpkcUgdKyX4HhZvmzTTCGMun5Z56PJUuZv22Wn2rFtwHPscyQaK/
	 UMLgo/BzM3vS0Y7pLqHlmKo3chZjqWfi2Id1tr5ywsmapKVvpZOCl2hNlPRpZH9/Jp
	 syuPQoSUI+PrkydHTxf+geXEduS4OD7lU94ifLek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0773/2077] netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them
Date: Tue, 21 Jul 2026 17:07:26 +0200
Message-ID: <20260721152611.027253167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

[ Upstream commit 2354e975932dabb06fad239f07a3b68fd1809737 ]

Update nft_dup and nft_fwd to use the nf_dev_xmit_recursion() helpers.
This patch also disables BH when transmitting the skb to address a
possible migration to different CPU leading to imbalanced decrementation
of the recursion counters.

This is modeled after Florian Westphal's dev_xmit_recursion*() API
available since commit 97cdcf37b57e ("net: place xmit recursion in
softnet data") according to its current state in the tree.

Fixes: 1d47b55b36d2 ("netfilter: nft_fwd_netdev: use recursion counter in neigh egress path")
Fixes: f37ad9127039 ("netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_dup_netdev.h | 34 +++++++++++++++++++++++----
 net/netfilter/nf_dup_netdev.c         | 15 ++++++------
 net/netfilter/nft_fwd_netdev.c        | 17 ++++++++------
 3 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 609bcf422a9b31..f6b05bd80c3fe3 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -11,15 +11,39 @@ void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
 #define NF_RECURSION_LIMIT	2
 
-static inline u8 *nf_get_nf_dup_skb_recursion(void)
-{
 #ifndef CONFIG_PREEMPT_RT
-	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
+			NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
+}
 #else
-	return &current->net_xmit.nf_dup_skb_recursion;
-#endif
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	current->net_xmit.nf_dup_skb_recursion++;
 }
 
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	current->net_xmit.nf_dup_skb_recursion--;
+}
+#endif
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 3d88ef927f31cb..c6bd5c29bed66d 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -16,11 +16,6 @@
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
-	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
-
-	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
-		goto err;
-
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
 		if (skb_cow_head(skb, skb->mac_len))
 			goto err;
@@ -30,9 +25,15 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	(*nf_dup_skb_recursion)++;
+	local_bh_disable();
+	if (nf_dev_xmit_recursion()) {
+		local_bh_enable();
+		goto err;
+	}
+	nf_dev_xmit_recursion_inc();
 	dev_queue_xmit(skb);
-	(*nf_dup_skb_recursion)--;
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 	return;
 err:
 	kfree_skb(skb);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index b9e88d7cf3081a..a48c2f765bbaad 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -95,7 +95,6 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs,
 			      const struct nft_pktinfo *pkt)
 {
-	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
 	void *addr = &regs->data[priv->sreg_addr];
 	int oif = regs->data[priv->sreg_dev];
@@ -154,13 +153,15 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT) {
+	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
+	if (!dev) {
 		verdict = NF_DROP;
 		goto out;
 	}
 
-	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL) {
+	local_bh_disable();
+	if (nf_dev_xmit_recursion()) {
+		local_bh_enable();
 		verdict = NF_DROP;
 		goto out;
 	}
@@ -169,16 +170,18 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
-			verdict = NF_STOLEN;
+			local_bh_enable();
 			goto out;
 		}
 	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	(*nf_dup_skb_recursion)++;
+
+	nf_dev_xmit_recursion_inc();
 	neigh_xmit(neigh_table, dev, addr, skb);
-	(*nf_dup_skb_recursion)--;
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.53.0



