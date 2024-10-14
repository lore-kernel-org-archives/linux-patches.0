Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32C41798C;
	Mon, 14 Oct 2024 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916275; cv=none; b=irp/6A04XA2s1BClxUs3rZGiIPCBnRDRb7XbK43nYUCGSH+gBh4NN09ykKY5NqwZ9iH2Bp+J3flhA24Fd3F6UHTFEjfCwUN/hb/R5r2Nwg2S1Ka7BQa3+BHwFCSYhMjgSMWk1V/qb8dHxD+GRdSE1/4T/it/WdiX9+NAFaAjW1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916275; c=relaxed/simple;
	bh=VdvsoEi3J5sShsz78p8R+HxCEV+32s+hW44cmIdoRZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2F/OAFivT7DH4FV0MKH7eMFOQcQYa42cXmK+HMcSI8PlzT01momVh7wXN7qQg6cKA2YiTiBXoWDIQRN9mjNKKK49yp7tnkBH96tf+i8oQm/boXXPyv/YJAvBS0gRyg116sh60gR+IK1rULaARU3qtsnQ7iqib06yI3hRL5gJv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBjk/8bK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBjk/8bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EB8C4CEC3;
	Mon, 14 Oct 2024 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916275;
	bh=VdvsoEi3J5sShsz78p8R+HxCEV+32s+hW44cmIdoRZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBjk/8bKxm0xMsHdOw0o524MbUxKkXwcQaVHbGa4UaRwrtpIZc03NlzHq4mpKLxi/
	 NqOJPy1QK+HyFp+qaWbc/eHWDIsQm3gp9JuHslWdpBb4E5bPHTWlyL2G1MJA4nE0f/
	 KIs30FqQHR03FsPaUGrq6taHd6wf/+YrVqAVlrhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 135/214] netfilter: fib: check correct rtable in vrf setups
Date: Mon, 14 Oct 2024 16:19:58 +0200
Message-ID: <20241014141050.261020877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9eee535c64dd4..ba233fdd81886 100644
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



