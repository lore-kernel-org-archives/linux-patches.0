Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624108;
	b=zTa+vbNayA7HsF7/E/ftGfgbRFt9cqULqVS+I/TC4JxQXiRgHakGWdfHLkxOxL7dmuG1
	 NarvKCxGRa/mxOnbI+ioMjaNwKbUGZ0qFcTQFB8++Hfj2LubLnAU4bhbQwwJLaFmG84qD
	 DfIS5iuP27n2cOyCrpf07Xtxw5XpDjckkTAmmBZh6v16HCj8xvNCyTmfkTJi+FNkx/AE1
	 ySX8CdNJvxWQyzIhmpo1/WWv7iAP0bnyXlSDm5vYKgn7GUTQztlu99WW7/1orxwkeAOlS
	 XGhISxd/7d2RAh98a+gCamDibFMot0r+9puPUF1eVfR1uUCAQaLLpBQIvIItqfJLVDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i6m/JgZZ1zk2LF2kfskm/kEzBXI6+sPtWmVx71zUq/w=;
	b=lEF5IsSv8kuNqnuQhWnbPiEsP7ab8LaEhxknTRGqOR9yqmnuQCitNpQS2vmLrrWxKaAD
	 /ZIp9N2EEZ8yCkzjzVoSECVAMV4lMecD4otq9kZFF0KDnK+hjtI4omShPa6M8Doa+CCsp
	 eISIbJLD1m6iIZs6IwZN5H4tJVCk5jcQLkZA+ovLQLldQR7OduElmFnmrDQqoVvuuBYPs
	 CNu9qBsnC9eIx5QS5rYZUf1SQgWkYRhrkVBZK37xs7ZqYdrKCY+w2elc3U41t5Bf9IXfl
	 Q5zcdW3fQGuMVEhwx8Bz13xRKElubBLAt304NCuYlvpVLSwQJ5oepiM7cO+41Nl0fEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnEqz68u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C769606A31E;
	Wed, 25 Nov 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnEqz68u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EB81F000C6;
	Wed, 25 Nov 2026 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624108;
	bh=i6m/JgZZ1zk2LF2kfskm/kEzBXI6+sPtWmVx71zUq/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnEqz68utnZ53sgIpqol/X0xy+GKYpzaifaXorjdWdAUjFGyNzIEGuruyB4AUc1EO
	 O9kwEttlSXO42VdgSO4r2vnR/By42rwMqzzKCHqxL76OoepolbDVPuNtiH/OwF6hBC
	 DdahI9bn6BRqTfBhDbpvj6sFtGVZobWV1YFP8L8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/816] netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them
Date: Wed, 25 Nov 2026 15:27:17 +0100
Message-ID: <20261125143851.281673874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: d6c18cadfc6c ("netfilter: nft_reject: prevent unbounded recursion in output hooks")
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



