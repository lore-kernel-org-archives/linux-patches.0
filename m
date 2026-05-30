Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175C633B6C4;
	Sat, 30 May 2026 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162004; cv=none; b=CatVBuECB991DBOrzrSzwX8630n+wfmw+N1o84uAL72NsbABjh8pABybcu1/yowBz1ZV0EduirQHVn3gk0xBLes35aJkDXQd9wEx3mZkZoPwQR1riqXMIx6tBdYIh37P3Y8AOxCHvENDHbJYxwLyUiN8ShZUc5HAbikEw1IiGvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162004; c=relaxed/simple;
	bh=skDJ3Ho979EwuoLwbEvpwqxhQkxxvyYf5ivY5+iHgcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOZGrDXZAHniyMbNWMwVy0Od5+MFHL7s0lM09aEuF+utRE6NNTIfHiEYGC649X0fqeB1+VwXEPtJYVUkKWZSShEQ69sD+yFxPAsnSlJjKXFK/PTSUpWqTGe8Vvpzg0e1kNFxua6pWNwhTV5t5LsZNudqQega1hlsOCMhtESnVJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG4t0go/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG4t0go/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4AC1F00893;
	Sat, 30 May 2026 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162002;
	bh=mpKvNKYyg1RyiGooB7n007YSzllsJxNPCKACYjqzVZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZG4t0go/E3n1Xnwh2rBrbNOC60t+gJOP6RORwNhb3i7Splxe/hm/PkxTcLZ1CX566
	 cWtiXF6xjwPRlYFm+/hwnqyH6H+G0kgMVvL83RMfGASEdR4xByV/SXRTk4NcKbmVvQ
	 oC1g5ZgGdQjQaKK9q9GJKlNRYaQsgPyx6GXWLbyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 764/969] ipv4: rename and move ip_route_output_tunnel()
Date: Sat, 30 May 2026 18:04:48 +0200
Message-ID: <20260530160321.666655878@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beniamino Galvani <b.galvani@gmail.com>

[ Upstream commit bf3fcbf7e7a08015d3b169bad6281b29d45c272d ]

At the moment ip_route_output_tunnel() is used only by bareudp.
Ideally, other UDP tunnel implementations should use it, but to do so
the function needs to accept new parameters that are specific for UDP
tunnels, such as the ports.

Prepare for these changes by renaming the function to
udp_tunnel_dst_lookup() and move it to file
net/ipv4/udp_tunnel_core.c.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aa6c6d9ee064 ("bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c      |  8 +++----
 include/net/route.h        |  6 -----
 include/net/udp_tunnel.h   |  6 +++++
 net/ipv4/route.c           | 48 --------------------------------------
 net/ipv4/udp_tunnel_core.c | 48 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index cfbc0240126ef..bbc246d27f88a 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -325,8 +325,8 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (!sock)
 		return -ESHUTDOWN;
 
-	rt = ip_route_output_tunnel(skb, dev, bareudp->net, &saddr, info,
-				    IPPROTO_UDP, use_cache);
+	rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, &saddr, info,
+				   IPPROTO_UDP, use_cache);
 
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
@@ -505,8 +505,8 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 		struct rtable *rt;
 		__be32 saddr;
 
-		rt = ip_route_output_tunnel(skb, dev, bareudp->net, &saddr,
-					    info, IPPROTO_UDP, use_cache);
+		rt = udp_tunnel_dst_lookup(skb, dev, bareudp->net, &saddr,
+					   info, IPPROTO_UDP, use_cache);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
diff --git a/include/net/route.h b/include/net/route.h
index cdca622c5c6fe..568da3b95b06e 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -139,12 +139,6 @@ static inline struct rtable *__ip_route_output_key(struct net *net,
 
 struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
 				    const struct sock *sk);
-struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
-				      struct net_device *dev,
-				      struct net *net, __be32 *saddr,
-				      const struct ip_tunnel_info *info,
-				      u8 protocol, bool use_cache);
-
 struct dst_entry *ipv4_blackhole_route(struct net *net,
 				       struct dst_entry *dst_orig);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index cd2bd3826d168..f9a66a33e958b 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -161,6 +161,12 @@ int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
 
 void udp_tunnel_sock_release(struct socket *sock);
 
+struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
+				     struct net_device *dev,
+				     struct net *net, __be32 *saddr,
+				     const struct ip_tunnel_info *info,
+				     u8 protocol, bool use_cache);
+
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
 				    __be16 flags, __be64 tunnel_id,
 				    int md_size);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 86893963b930d..60516c6ae62e0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2922,54 +2922,6 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
 }
 EXPORT_SYMBOL_GPL(ip_route_output_flow);
 
-struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
-				      struct net_device *dev,
-				      struct net *net, __be32 *saddr,
-				      const struct ip_tunnel_info *info,
-				      u8 protocol, bool use_cache)
-{
-#ifdef CONFIG_DST_CACHE
-	struct dst_cache *dst_cache;
-#endif
-	struct rtable *rt = NULL;
-	struct flowi4 fl4;
-	__u8 tos;
-
-#ifdef CONFIG_DST_CACHE
-	dst_cache = (struct dst_cache *)&info->dst_cache;
-	if (use_cache) {
-		rt = dst_cache_get_ip4(dst_cache, saddr);
-		if (rt)
-			return rt;
-	}
-#endif
-	memset(&fl4, 0, sizeof(fl4));
-	fl4.flowi4_mark = skb->mark;
-	fl4.flowi4_proto = protocol;
-	fl4.daddr = info->key.u.ipv4.dst;
-	fl4.saddr = info->key.u.ipv4.src;
-	tos = info->key.tos;
-	fl4.flowi4_tos = RT_TOS(tos);
-
-	rt = ip_route_output_key(net, &fl4);
-	if (IS_ERR(rt)) {
-		netdev_dbg(dev, "no route to %pI4\n", &fl4.daddr);
-		return ERR_PTR(-ENETUNREACH);
-	}
-	if (rt->dst.dev == dev) { /* is this necessary? */
-		netdev_dbg(dev, "circular route to %pI4\n", &fl4.daddr);
-		ip_rt_put(rt);
-		return ERR_PTR(-ELOOP);
-	}
-#ifdef CONFIG_DST_CACHE
-	if (use_cache)
-		dst_cache_set_ip4(dst_cache, &rt->dst, fl4.saddr);
-#endif
-	*saddr = fl4.saddr;
-	return rt;
-}
-EXPORT_SYMBOL_GPL(ip_route_output_tunnel);
-
 /* called with rcu_read_lock held */
 static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 			struct rtable *rt, u32 table_id, dscp_t dscp,
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 732e21b75ba28..386e983560094 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -204,4 +204,52 @@ struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb,  unsigned short family,
 }
 EXPORT_SYMBOL_GPL(udp_tun_rx_dst);
 
+struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
+				     struct net_device *dev,
+				     struct net *net, __be32 *saddr,
+				     const struct ip_tunnel_info *info,
+				     u8 protocol, bool use_cache)
+{
+#ifdef CONFIG_DST_CACHE
+	struct dst_cache *dst_cache;
+#endif
+	struct rtable *rt = NULL;
+	struct flowi4 fl4;
+	__u8 tos;
+
+#ifdef CONFIG_DST_CACHE
+	dst_cache = (struct dst_cache *)&info->dst_cache;
+	if (use_cache) {
+		rt = dst_cache_get_ip4(dst_cache, saddr);
+		if (rt)
+			return rt;
+	}
+#endif
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.flowi4_mark = skb->mark;
+	fl4.flowi4_proto = protocol;
+	fl4.daddr = info->key.u.ipv4.dst;
+	fl4.saddr = info->key.u.ipv4.src;
+	tos = info->key.tos;
+	fl4.flowi4_tos = RT_TOS(tos);
+
+	rt = ip_route_output_key(net, &fl4);
+	if (IS_ERR(rt)) {
+		netdev_dbg(dev, "no route to %pI4\n", &fl4.daddr);
+		return ERR_PTR(-ENETUNREACH);
+	}
+	if (rt->dst.dev == dev) { /* is this necessary? */
+		netdev_dbg(dev, "circular route to %pI4\n", &fl4.daddr);
+		ip_rt_put(rt);
+		return ERR_PTR(-ELOOP);
+	}
+#ifdef CONFIG_DST_CACHE
+	if (use_cache)
+		dst_cache_set_ip4(dst_cache, &rt->dst, fl4.saddr);
+#endif
+	*saddr = fl4.saddr;
+	return rt;
+}
+EXPORT_SYMBOL_GPL(udp_tunnel_dst_lookup);
+
 MODULE_LICENSE("GPL");
-- 
2.53.0



