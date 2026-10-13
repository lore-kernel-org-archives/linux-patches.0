Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47F14FE2E3;
	Tue, 13 Oct 2026 12:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893796; cv=none; b=IEIbnt7uz2vyaV8wJqEUvcFoeEIlPT5C7+3Pb80zSAzzVNy890T/Tcr1rUb/cD3e9RyFafCQ7QfSpJyFU8fhuH+zp6ObF2SBLOiP8yBCk5BwAPVUnyc17hqyQz4khVR5keFcqt58PomdR+8gBcyMtU8ZeTa2LHq2/5a/s9b/b0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893796; c=relaxed/simple;
	bh=sV4PBnNSXxpFtxNf9aT2NIdGbaqTdVtL7iumR39yrtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3sVWqjDGYl44g+GEePHOBwKsnTTZVwWPyys23IxmIH5ya+kaCNCxHDw1twjaJ9ZzhIAervGkWtzMTEl7q5z39IYcK1kleHye1T2FtUnu13YNXQU+gDE6sfPagVVF6GUpFRrZVI+BMPLoVxPAz29fLEVm2K2pUVuq9d/3e25qKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmzwOX88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmzwOX88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAC81F000FF;
	Tue, 13 Oct 2026 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893795;
	bh=4kaAJhu6VyAR8F/h90UXG0mei2uGGcznIX3NfHWxkOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmzwOX88iBQdfEpwotSUlDq4hA2cpf82ciMcPmBabzEgTaAlKIvvSIoU49doHpMXo
	 xdRlxZgmCvwt59GwaJsNRIDrnoQuNhvrqSUNbnX1P0IMBgTwS43Qi1s49JjMAWN10G
	 E9iG03rFaPWFGPob1iwsd2p35N9WGoY7jLIOnYSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/621] netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them
Date: Tue, 13 Oct 2026 13:34:56 +0200
Message-ID: <20261013112927.997345735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 609bcf422a9b3..f6b05bd80c3fe 100644
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
index a958a1b0c5bee..02d1880bab6b3 100644
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
index 14c1ac9f20b6a..eceab479bd8c4 100644
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
@@ -153,13 +152,15 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
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
@@ -168,16 +169,18 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
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



