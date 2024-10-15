Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984AD1AF0B1;
	Tue, 15 Oct 2024 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998498; cv=none; b=lSjeDjwCfxudBPlVmfHFL7+IzL40kZznxLnPhkIykPZ8ShS25F5jq4zNsVZEPFmeuF1CJZG8wzFC50s+K9PoYTp/yQhDnX+3swGHYeTeIczvaS8M5JTBkQ5ylU+CwbEOfGAgtlhYgh4QzMPvUgNDXpZSTn2D3UpVc3yZRG1fB5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998498; c=relaxed/simple;
	bh=4n2c/BMQPdu2b5xQB0oAslbSgRtq092urHNaf2BFfHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLRYZ4SXDZ1jynrtJ3eQ5tnimikI56/I0MeHzVnkt6i+pZXYANu3JmczVd6oAqbe2ip64cArypFoie9T6hCfk0J7xK9llpZHc8Zrvtq5D6s/dLP62s0S+tZNdtEHuTVv1Gb1Y6Cvzw6RYw0TlUF2SyB2i4iEjRZVUtNkgm6HyRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k35y7CWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k35y7CWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F80C4CEC6;
	Tue, 15 Oct 2024 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998498;
	bh=4n2c/BMQPdu2b5xQB0oAslbSgRtq092urHNaf2BFfHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k35y7CWMqqQcbCJmuPgNv9kZ7qgqm19zMBcLh/kEkvMgmAcr2uFFS/EZ9kedTFmgz
	 ezaYFaVOgEts3+/Gf2g6cx57w98flV4gz6beVfly1K+G6yp0KMNxcgaCGyIOF1fjIH
	 zGIzf0j5530KUI2iRUDBh/UdroONKSdu03/8FeJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	David Ahern <dsahern@kernel.org>,
	Guillaume Nault <gnault@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/518] netfilter: rpfilter/fib: Populate flowic_l3mdev field
Date: Tue, 15 Oct 2024 14:46:38 +0200
Message-ID: <20241015123936.064342234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit acc641ab95b66b813c1ce856c377a2bbe71e7f52 ]

Use the introduced field for correct operation with VRF devices instead
of conditionally overwriting flowic_oif. This is a partial revert of
commit b575b24b8eee3 ("netfilter: Fix rpfilter dropping vrf packets by
mistake"), implementing a simpler solution.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 05ef7055debc ("netfilter: fib: check correct rtable in vrf setups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c  | 2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c | 9 +++------
 net/ipv6/netfilter/nft_fib_ipv6.c  | 5 ++---
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8cd3224d913e0..63f3e8219dd5a 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -78,7 +78,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
 	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
-	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
+	flow.flowi4_l3mdev = l3mdev_master_ifindex_rcu(xt_in(par));
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9e6f0f1275e2c..22168f12b3819 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -84,7 +84,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		oif = NULL;
 
 	if (priv->flags & NFTA_FIB_F_IIF)
-		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+		fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(oif);
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index d800801a5dd27..69d86b040a6af 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -37,6 +37,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	bool ret = false;
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
+		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev),
 		.flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,
 		.flowi6_proto = iph->nexthdr,
 		.daddr = iph->saddr,
@@ -55,9 +56,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	if (rpfilter_addr_linklocal(&iph->saddr)) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6.flowi6_oif = dev->ifindex;
-	/* Set flowi6_oif for vrf devices to lookup route in l3mdev domain. */
-	} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
-		  (flags & XT_RPFILTER_LOOSE) == 0)
+	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
@@ -72,9 +71,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev ||
-	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
-	    (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 602743f6dcee0..72a9a04920ab2 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -37,9 +37,8 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
-	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
-		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
-		fl6->flowi6_oif = dev->ifindex;
+	} else if (priv->flags & NFTA_FIB_F_IIF) {
+		fl6->flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
-- 
2.43.0



