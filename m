Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34531EF941;
	Tue, 15 Oct 2024 12:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994406; cv=none; b=AwP3iJNpVFaVsRlVZI254guFQc9uE8Rc9ePxSzzmCQapxI/GU43IayRKCHfGe7XW1i4SVEe6StRweUnd4l5OoU9taWMxzj/TTQ9vvZ9JQWZmydmpMFIslCqKbW7DDM/KAmqcfd0JareYDqIRhfBTdJlLaqlqAmj60EwjCEgZDwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994406; c=relaxed/simple;
	bh=3kcBW1aLqXu/+/tPY8lalSgf2a7DqFgjYmhGo8V07YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYQVVVH84bGns/qSaS3pheTyqI7rl/XdMvalQqtvPya0wxCx7UwjVy00rTxNs2zYAS5aC+z80qSEu0ctREguxLqp8oi7P1m8VfomDTNCT06+wDecDQVi6Rpeq96iQvzHoGe6P0eUyLK4hgS6RnQFYx78EdIpRN0aNwBIBk6D1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcntBoj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcntBoj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C9CC4CECF;
	Tue, 15 Oct 2024 12:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994406;
	bh=3kcBW1aLqXu/+/tPY8lalSgf2a7DqFgjYmhGo8V07YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcntBoj0CAcYrpYsNWcXQoTbgZOMFjGGh6sZdLVKlOF126H61QG0EK0ZlxZQfJhma
	 S1ZB8D3QXvBB4PEcQjl85MBH/kf72vw9/dOroVs/geXBHdVTynnRTF3x7zE1tN7+xd
	 bERNVQ27tVNoA2QZRu20Iz1YMs8fl2ZjIH26aQDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 684/691] net: Handle l3mdev in ip_tunnel_init_flow
Date: Tue, 15 Oct 2024 13:30:32 +0200
Message-ID: <20241015112507.469973668@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

commit db53cd3d88dc328dea2e968c9c8d3b4294a8a674 upstream.

Ido reported that the commit referenced in the Fixes tag broke
a gre use case with dummy devices. Add a check to ip_tunnel_init_flow
to see if the oif is an l3mdev port and if so set the oif to 0 to
avoid the oif comparison in fib_lookup_good_nhc.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c |    2 +-
 include/net/ip_tunnels.h                            |   11 +++++++++--
 net/ipv4/ip_gre.c                                   |    4 ++--
 net/ipv4/ip_tunnel.c                                |    9 +++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -424,7 +424,7 @@ mlxsw_sp_span_gretap4_route(const struct
 
 	parms = mlxsw_sp_ipip_netdev_parms4(to_dev);
 	ip_tunnel_init_flow(&fl4, parms.iph.protocol, *daddrp, *saddrp,
-			    0, 0, parms.link, tun->fwmark, 0);
+			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0);
 
 	rt = ip_route_output_key(tun->net, &fl4);
 	if (IS_ERR(rt))
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -240,11 +240,18 @@ static inline __be32 tunnel_id_to_key32(
 static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 				       int proto,
 				       __be32 daddr, __be32 saddr,
-				       __be32 key, __u8 tos, int oif,
+				       __be32 key, __u8 tos,
+				       struct net *net, int oif,
 				       __u32 mark, __u32 tun_inner_hash)
 {
 	memset(fl4, 0, sizeof(*fl4));
-	fl4->flowi4_oif = oif;
+
+	if (oif) {
+		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index_rcu(net, oif);
+		/* Legacy VRF/l3mdev use case */
+		fl4->flowi4_oif = fl4->flowi4_l3mdev ? 0 : oif;
+	}
+
 	fl4->daddr = daddr;
 	fl4->saddr = saddr;
 	fl4->flowi4_tos = tos;
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -613,8 +613,8 @@ static int gre_fill_metadata_dst(struct
 	key = &info->key;
 	ip_tunnel_init_flow(&fl4, IPPROTO_GRE, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id),
-			    key->tos & ~INET_ECN_MASK, 0, skb->mark,
-			    skb_get_hash(skb));
+			    key->tos & ~INET_ECN_MASK, dev_net(dev), 0,
+			    skb->mark, skb_get_hash(skb));
 	rt = ip_route_output_key(dev_net(dev), &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -294,8 +294,8 @@ static int ip_tunnel_bind_dev(struct net
 
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
-				    RT_TOS(iph->tos), tunnel->parms.link,
-				    tunnel->fwmark, 0);
+				    RT_TOS(iph->tos), dev_net(dev),
+				    tunnel->parms.link, tunnel->fwmark, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
 		if (!IS_ERR(rt)) {
@@ -597,7 +597,7 @@ void ip_md_tunnel_xmit(struct sk_buff *s
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
-			    0, skb->mark, skb_get_hash(skb));
+			    dev_net(dev), 0, skb->mark, skb_get_hash(skb));
 	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		goto tx_error;
 
@@ -753,7 +753,8 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
-			    tunnel->parms.o_key, RT_TOS(tos), tunnel->parms.link,
+			    tunnel->parms.o_key, RT_TOS(tos),
+			    dev_net(dev), tunnel->parms.link,
 			    tunnel->fwmark, skb_get_hash(skb));
 
 	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)


