Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DA918FDBD;
	Sat, 30 May 2026 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166848; cv=none; b=HVQmuFn/Eaozy9lCuOU3nqimOHmXPHgMq9p1BbboFWERhJutJDf/SrnfJ7ATVOFw43bk2/8N/3AnEmTs8AwWjTDtyUKLe2IMbr9AnCY1GxmuHqZRHfkA93MqKrN17CsKhfHOvJfac8PetaMPg2lnz++Yy+1g5/DLrhQOstEstSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166848; c=relaxed/simple;
	bh=MWkcytdFjYUkIZSzwEp/ZOYiXdKAcvLZnji0uO1KPoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkA6/TpkZ9mfl18GQLpRC18kdgHcJ51KqywQnc3loR9t6F1bbSuk8yyq825Mb4WOLsnTf1XCG99CGdwsllyK67V4arU9xTACSlzkCKqejIE1JUIMC/l2Jymt1I7HOfJeTka7+cx94TMjzY4RzZrIrJcMbvq/AX7ex0QEekA70NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDMLowIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDMLowIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD0E1F00893;
	Sat, 30 May 2026 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166847;
	bh=jwUFGibqeIC0JStA5hAi6G0N2i+kCnIoZpO5yMR9RKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDMLowIKQUl8Oo5Ay7RW+04u5Y/8xz6zOJ6zn9GWo2NK96+7wNAB5PTytHPZp/Pch
	 1Nw0/gROsnlzmITj6Y/6dXs0kpc8pCACQpOqiEQkxE7iXHU7mKONv++FU4SQrrzrp1
	 hPqgnJ4UOSy3Ry+Z7xx91gD4zkWBgKy41u0dhiqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/589] ipv4: add new arguments to udp_tunnel_dst_lookup()
Date: Sat, 30 May 2026 18:06:11 +0200
Message-ID: <20260530160237.513344484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beniamino Galvani <b.galvani@gmail.com>

[ Upstream commit 72fc68c6356b663a8763f02d9b0ec773d59a4949 ]

We want to make the function more generic so that it can be used by
other UDP tunnel implementations such as geneve and vxlan. To do that,
add the following arguments:

 - source and destination UDP port;
 - ifindex of the output interface, needed by vxlan;
 - the tos, because in some cases it is not taken from struct
   ip_tunnel_info (for example, when it's inherited from the inner
   packet);
 - the dst cache, because not all tunnel types (e.g. vxlan) want to
   use the one from struct ip_tunnel_info.

With these parameters, the function no longer needs the full struct
ip_tunnel_info as argument and we can pass only the relevant part of
it (struct ip_tunnel_key).

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aa6c6d9ee064 ("bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c      | 11 +++++++----
 include/net/udp_tunnel.h   |  8 +++++---
 net/ipv4/udp_tunnel_core.c | 26 +++++++++++++-------------
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 1ed25e1afd246..5c8412d835792 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -317,8 +317,10 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (!sock)
 		return -ESHUTDOWN;
 
-	rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, &saddr, info,
-				   use_cache);
+	rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, 0, &saddr, &info->key,
+				   0, 0, key->tos,
+				   use_cache ?
+				   (struct dst_cache *)&info->dst_cache : NULL);
 
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
@@ -497,8 +499,9 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 		struct rtable *rt;
 		__be32 saddr;
 
-		rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, &saddr,
-					   info, use_cache);
+		rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, 0, &saddr,
+					   &info->key, 0, 0, info->key.tos,
+					   use_cache ? &info->dst_cache : NULL);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 4d4f1a67d4b26..ad92ae0dd9863 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -155,9 +155,11 @@ void udp_tunnel_sock_release(struct socket *sock);
 
 struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 				     struct net_device *dev,
-				     struct net *net, __be32 *saddr,
-				     const struct ip_tunnel_info *info,
-				     bool use_cache);
+				     struct net *net, int oif,
+				     __be32 *saddr,
+				     const struct ip_tunnel_key *key,
+				     __be16 sport, __be16 dport, u8 tos,
+				     struct dst_cache *dst_cache);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
 				    __be16 flags, __be64 tunnel_id,
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 50c83f90487db..4b6f44c481abf 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -224,31 +224,31 @@ EXPORT_SYMBOL_GPL(udp_tun_rx_dst);
 
 struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 				     struct net_device *dev,
-				     struct net *net, __be32 *saddr,
-				     const struct ip_tunnel_info *info,
-				     bool use_cache)
+				     struct net *net, int oif,
+				     __be32 *saddr,
+				     const struct ip_tunnel_key *key,
+				     __be16 sport, __be16 dport, u8 tos,
+				     struct dst_cache *dst_cache)
 {
-#ifdef CONFIG_DST_CACHE
-	struct dst_cache *dst_cache;
-#endif
 	struct rtable *rt = NULL;
 	struct flowi4 fl4;
-	__u8 tos;
 
 #ifdef CONFIG_DST_CACHE
-	dst_cache = (struct dst_cache *)&info->dst_cache;
-	if (use_cache) {
+	if (dst_cache) {
 		rt = dst_cache_get_ip4(dst_cache, saddr);
 		if (rt)
 			return rt;
 	}
 #endif
+
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_mark = skb->mark;
 	fl4.flowi4_proto = IPPROTO_UDP;
-	fl4.daddr = info->key.u.ipv4.dst;
-	fl4.saddr = info->key.u.ipv4.src;
-	tos = info->key.tos;
+	fl4.flowi4_oif = oif;
+	fl4.daddr = key->u.ipv4.dst;
+	fl4.saddr = key->u.ipv4.src;
+	fl4.fl4_dport = dport;
+	fl4.fl4_sport = sport;
 	fl4.flowi4_tos = RT_TOS(tos);
 
 	rt = ip_route_output_key(net, &fl4);
@@ -262,7 +262,7 @@ struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 		return ERR_PTR(-ELOOP);
 	}
 #ifdef CONFIG_DST_CACHE
-	if (use_cache)
+	if (dst_cache)
 		dst_cache_set_ip4(dst_cache, &rt->dst, fl4.saddr);
 #endif
 	*saddr = fl4.saddr;
-- 
2.53.0



