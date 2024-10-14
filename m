Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC11B4F08;
	Mon, 14 Oct 2024 15:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919959; cv=none; b=eaHpUUgWtKcjhEC/SS345cyM2SUWo/8hUVUrt3oe3FaYd1RMuiVexHhD+j7izifnnRgp8H1rYk/lBzpMiT1HZSBwHrkZ80Vk6uxzMRcDWW+CjcR5W+aXDcb2k/kxBfV5NX5WZYlmAEigvwy+JwYiI24cnWRJSqeRMRuF0JEHjyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919959; c=relaxed/simple;
	bh=I68Ozh+cb+UH1yjWOzesXAQnmRLNyfJ146mOflYea/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVJBrGufOeikvQX7Sr+g7brFzomygGV/iNIsjwWnOsslHEnPw92vfFeT9Qjur6EeHcQaFIzxgQJsNswUSZkl/1GCCjZ8sy93HePMeABWUFACldX/2DTwPMw5Zl2Nht3jb76oWm63RwOjBm2pLtOWXMvkXwN9vqrRVb8UYuIFkQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcuhPLt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcuhPLt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E76C4CEC3;
	Mon, 14 Oct 2024 15:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919959;
	bh=I68Ozh+cb+UH1yjWOzesXAQnmRLNyfJ146mOflYea/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcuhPLt+lAv2y6MTdLUVttZiCxK78mKyjzmMCgO3NQWn7b5fUeAI0P+UtIqOCtogG
	 P4raSi0nw60Riqs4Q50mUdVLvf7qxPyrDdFmHVs37Zru/BO66tZmmfkBe6AnDG8K5J
	 YiSLjv1mxkC162k6bbG0HvQZglyjQ1kx7NubiFXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 757/798] netfilter: fib: check correct rtable in vrf setups
Date: Mon, 14 Oct 2024 16:21:51 +0200
Message-ID: <20241014141247.809212711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 05ef7055debc804e8083737402127975e7244fc4 ]

We need to init l3mdev unconditionally, else main routing table is searched
and incorrect result is returned unless strict (iif keyword) matching is
requested.

Next patch adds a selftest for this.

Fixes: 2a8a7c0eaa87 ("netfilter: nft_fib: Fix for rpath check with VRF devices")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1761
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
 net/ipv6/netfilter/nft_fib_ipv6.c | 5 +++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index fc65d69f23e16..edec5c8f59ac8 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -66,6 +66,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
 		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
+		.flowi4_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
@@ -84,9 +85,6 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
-	if (priv->flags & NFTA_FIB_F_IIF)
-		fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(oif);
-
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
 		nft_fib_store_result(dest, priv, nft_in(pkt));
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 36dc14b34388c..c9f1634b3838a 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -41,8 +41,6 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
-	} else if (priv->flags & NFTA_FIB_F_IIF) {
-		fl6->flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
@@ -75,6 +73,8 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	else if (priv->flags & NFTA_FIB_F_OIF)
 		dev = nft_out(pkt);
 
+	fl6.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
+
 	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
 
 	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
@@ -165,6 +165,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
 		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
+		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
-- 
2.43.0



