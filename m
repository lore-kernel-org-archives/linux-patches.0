Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623785;
	b=nc8yiVFLIOzRdGHG8w8r1WCKXmSZIWvRk+BCElgRhxAPHMxOJGsIOBwR8wFIx8hpzyj9
	 1flUvdTiQIF+D7w4AM3stYDNbq3iPQ1HUouq20BI8Dqlbj3NaoXmWbRw9Ycl7R5K3XFUT
	 iQN2cW9FZGX5iOeVXdwg3/lgM8zJNavKWiwwHuaAGNqaa67gGt0mS27KGszRCYXHoeL2A
	 7UXFRf3k+04zUPyW/Fr+Yb5ouk1HejkYRLdZh7z4VxfjUIFZyH855HwGrqcrYpuvD8QBc
	 EthMHYKJ1sIpahciSJnSRkP6HlbPQRE01YAhBd4RZgGgrUdANmbw0TrDmT5xw6Rp89w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GTtr1+jmhNDpBUsv8RYfruVGgTGgpmFaBufFgESy79M=;
	b=sKCyjm4ShyiyjbG4umIlxNWFcJJsfFAmXcHpq3g9INjkZ/xpcbQhuYI+LbkGTlAA87wE
	 VtbKBmtVlQZR84N+QioRxSsFxktm00lehKZDcUqZ11i949wQKfcbPAXvIWjn4+3cjTuJB
	 ASlVaP0u4iKLiT44rep7Tj0yfH6i/cr++HBODnPUAfvjntFjriJiCEqRyatKN8e4p8v9B
	 mRH+BOqKgtW961UMiznWUsvjCQUsPyHRffj4XXsIk3ZAKvlVjEw9jbp4QgoBVFHSVt4EV
	 GbwrgE4w2DQ9AnEz0bKwll5sYfGwt2kCLbN5A589iLuCikTdMr5XuzAQdMgIKEmpJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzYkJobn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E46606A31E;
	Wed, 25 Nov 2026 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzYkJobn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9CD1F000C6;
	Wed, 25 Nov 2026 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623784;
	bh=GTtr1+jmhNDpBUsv8RYfruVGgTGgpmFaBufFgESy79M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzYkJobn5ZqOjy7yI6RN1ZxfovfI4t3ihZzy8T03t4tNKUiUVB7+a7S3U82ZT+kQs
	 qE6EkltqU/Go0xS9q5Dt7y/KQ9QpKg72BB5HZVAs/ONy0NLv/9ovVII38XiRbDIID8
	 nIiAAu5lqxF/tG01haqs6E1Rs9mX64qjRA5Hu6N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 968/990] fou: reserve headroom before pushing the encap header
Date: Wed, 25 Nov 2026 15:38:55 +0100
Message-ID: <20261125143844.656715916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

commit bcb42672751a8786dce871a35bde363b041cb2f7 upstream.

ip_tunnel_xmit() and ip_md_tunnel_xmit() push the encap header before
reserving headroom. A packet redirected into the tunnel (tc mirred, nft
fwd/dup) keeps the headroom of its original device, so fou_build_udp()
panics:

  kernel BUG at net/core/skbuff.c:214!
  Call Trace:
   skb_push+0xcc/0xf0
   fou_build_udp+0x2f/0x380
   gue_build_header+0xfa/0x150
   ip_tunnel_xmit+0x87f/0x21c0

With a mirred mirror, the push overwrites the original packet instead.
Reachable with CAP_NET_ADMIN in a user namespace.

Reserve the headroom in fou_build_header() and gue_build_header(); GUE
sizes and builds the header from one copy of the encap fields. The skb
head may move, so reload inner_iph after ip_tunnel_encap() and read
tnl_params, which points into the head for GRE with header_ops, before
the call. sit's ipip6_tunnel_xmit() holds no head pointer across it.

Fixes: 56328486539d ("net: Changes to ip_tunnel to support foo-over-udp encapsulation")
Fixes: ac931d4cdec3 ("ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices")
Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Closes: https://lore.kernel.org/netdev/20260801060115.3538849-1-nicoyip.dev@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261116113845.166280-1-theodorlarionov@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou_core.c  |   19 +++++++++++++++----
 net/ipv4/ip_tunnel.c |    6 ++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -1074,6 +1074,9 @@ static int fou_build_header(struct sk_bu
 	__be16 sport;
 	int err;
 
+	if (skb_cow_head(skb, fou_encap_hlen(e)))
+		return -ENOMEM;
+
 	err = __fou_build_header(skb, e, protocol, &sport, type);
 	if (err)
 		return err;
@@ -1086,16 +1089,24 @@ static int fou_build_header(struct sk_bu
 static int gue_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
 			    u8 *protocol, struct flowi4 *fl4)
 {
-	int type = e->flags & TUNNEL_ENCAP_FLAG_CSUM ? SKB_GSO_UDP_TUNNEL_CSUM :
-						       SKB_GSO_UDP_TUNNEL;
+	struct ip_tunnel_encap encap = {
+		.flags = READ_ONCE(e->flags),
+		.sport = READ_ONCE(e->sport),
+		.dport = READ_ONCE(e->dport),
+	};
+	int type = encap.flags & TUNNEL_ENCAP_FLAG_CSUM ?
+		   SKB_GSO_UDP_TUNNEL_CSUM : SKB_GSO_UDP_TUNNEL;
 	__be16 sport;
 	int err;
 
-	err = __gue_build_header(skb, e, protocol, &sport, type);
+	if (skb_cow_head(skb, gue_encap_hlen(&encap)))
+		return -ENOMEM;
+
+	err = __gue_build_header(skb, &encap, protocol, &sport, type);
 	if (err)
 		return err;
 
-	fou_build_udp(skb, e, fl4, protocol, sport);
+	fou_build_udp(skb, &encap, fl4, protocol, sport);
 
 	return 0;
 }
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -604,6 +604,7 @@ void ip_md_tunnel_xmit(struct sk_buff *s
 
 	if (ip_tunnel_encap(skb, &tun_info->encap, &proto, &fl4) < 0)
 		goto tx_error;
+	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
 	if (use_cache)
@@ -746,6 +747,8 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	tos = tnl_params->tos;
+	df = tnl_params->frag_off;
+	ttl = tnl_params->ttl;
 	if (tos & 0x1) {
 		tos &= ~0x1;
 		if (payload_protocol == htons(ETH_P_IP)) {
@@ -764,6 +767,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 
 	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
 		goto tx_error;
+	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
 
 	if (connected && md) {
 		use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
@@ -796,7 +800,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 		goto tx_error;
 	}
 
-	df = tnl_params->frag_off;
 	if (payload_protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
 		df |= (inner_iph->frag_off & htons(IP_DF));
 
@@ -816,7 +819,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	tos = ip_tunnel_ecn_encap(tos, inner_iph, skb);
-	ttl = tnl_params->ttl;
 	if (ttl == 0) {
 		if (payload_protocol == htons(ETH_P_IP))
 			ttl = inner_iph->ttl;


