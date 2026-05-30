Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8786814A60F;
	Sat, 30 May 2026 18:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166851; cv=none; b=sytDeZ2L6raelKVcse91unYZ4TVF1zPZ9D28zLY1ARwreZQ8qnJcSLHlunnDfLdDsjerzSXyvTlKoRukXbsKsz4WLCOjPBSVkW2XZn1gQi5Uj9hcyY1lH2JK2UWEoxV60kTU9AiI2Z2IW4+lV82Rt6N9BiiK+Gd6Nzg4eKNDPV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166851; c=relaxed/simple;
	bh=Wh7VxMoY+To/Fn+pYnTy7P0Jhk67AIzEdLQfKpy4g8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKSRgqloTo4uUjmPNuDqg5ziHaFJO+NYjidPnqGSuS3SrhluEhQ4fWlwhZWDi1MzXf2U3jUQhJSWQpPgrewbC3i5x85vznV04tK8bdQS7t4TyBpUPS1jYLGw2IPyUknsVBPSeL2rPPQZ7t+Jh8jtOZcEJtMv71s/gDQQOd9pfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JluCAlUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JluCAlUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C294B1F00893;
	Sat, 30 May 2026 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166850;
	bh=20Kzbltt5FOXC46aQaxd6sLR3CzjE7W5lTy5162nJB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JluCAlUpQv+IiPEx6LTuSyxZ/7EK7u6/FbxyeH1w/xURiDCGsGmlIV2rcHDFwr4Th
	 KOJQczcO5WmJRj0h59OIcB7qo5Ctso+Y2kwpfEcnTmwfELySjh5M8cKJWZj8qZpvWh
	 N41xW8gUyP4MG8+HKs7EZk6XF46k0A+SRVcev9wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 491/589] ipv6: rename and move ip6_dst_lookup_tunnel()
Date: Sat, 30 May 2026 18:06:12 +0200
Message-ID: <20260530160237.536745016@linuxfoundation.org>
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

[ Upstream commit fc47e86dbfb75a864c0c9dd8e78affb6506296bb ]

At the moment ip6_dst_lookup_tunnel() is used only by bareudp.
Ideally, other UDP tunnel implementations should use it, but to do so
the function needs to accept new parameters that are specific for UDP
tunnels, such as the ports.

Prepare for these changes by renaming the function to
udp_tunnel6_dst_lookup() and move it to file
net/ipv6/ip6_udp_tunnel.c.

This is similar to what already done for IPv4 in commit bf3fcbf7e7a0
("ipv4: rename and move ip_route_output_tunnel()").

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aa6c6d9ee064 ("bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c     | 10 +++---
 include/net/ipv6.h        |  6 ----
 include/net/udp_tunnel.h  |  7 ++++
 net/ipv6/ip6_output.c     | 68 --------------------------------------
 net/ipv6/ip6_udp_tunnel.c | 69 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 79 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 5c8412d835792..d5210b5b8cbf8 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -385,8 +385,8 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (!sock)
 		return -ESHUTDOWN;
 
-	dst = ip6_dst_lookup_tunnel(skb, dev, bareudp->net, sock, &saddr, info,
-				    IPPROTO_UDP, use_cache);
+	dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock, &saddr, info,
+				     IPPROTO_UDP, use_cache);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
@@ -512,9 +512,9 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 		struct in6_addr saddr;
 		struct socket *sock = rcu_dereference(bareudp->sock);
 
-		dst = ip6_dst_lookup_tunnel(skb, dev, bareudp->net, sock,
-					    &saddr, info, IPPROTO_UDP,
-					    use_cache);
+		dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock,
+					     &saddr, info, IPPROTO_UDP,
+					     use_cache);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d7b0710d0d9c1..c597596738754 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1025,12 +1025,6 @@ struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, st
 struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 					 const struct in6_addr *final_dst,
 					 bool connected);
-struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
-					struct net_device *dev,
-					struct net *net, struct socket *sock,
-					struct in6_addr *saddr,
-					const struct ip_tunnel_info *info,
-					u8 protocol, bool use_cache);
 struct dst_entry *ip6_blackhole_route(struct net *net,
 				      struct dst_entry *orig_dst);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index ad92ae0dd9863..6a296bb88b974 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -160,6 +160,13 @@ struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 				     const struct ip_tunnel_key *key,
 				     __be16 sport, __be16 dport, u8 tos,
 				     struct dst_cache *dst_cache);
+struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
+					 struct net_device *dev,
+					 struct net *net,
+					 struct socket *sock,
+					 struct in6_addr *saddr,
+					 const struct ip_tunnel_info *info,
+					 u8 protocol, bool use_cache);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
 				    __be16 flags, __be64 tunnel_id,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 99ee18b3a953e..764c003f98249 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1262,74 +1262,6 @@ struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 }
 EXPORT_SYMBOL_GPL(ip6_sk_dst_lookup_flow);
 
-/**
- *      ip6_dst_lookup_tunnel - perform route lookup on tunnel
- *      @skb: Packet for which lookup is done
- *      @dev: Tunnel device
- *      @net: Network namespace of tunnel device
- *      @sock: Socket which provides route info
- *      @saddr: Memory to store the src ip address
- *      @info: Tunnel information
- *      @protocol: IP protocol
- *      @use_cache: Flag to enable cache usage
- *      This function performs a route lookup on a tunnel
- *
- *      It returns a valid dst pointer and stores src address to be used in
- *      tunnel in param saddr on success, else a pointer encoded error code.
- */
-
-struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
-					struct net_device *dev,
-					struct net *net,
-					struct socket *sock,
-					struct in6_addr *saddr,
-					const struct ip_tunnel_info *info,
-					u8 protocol,
-					bool use_cache)
-{
-	struct dst_entry *dst = NULL;
-#ifdef CONFIG_DST_CACHE
-	struct dst_cache *dst_cache;
-#endif
-	struct flowi6 fl6;
-	__u8 prio;
-
-#ifdef CONFIG_DST_CACHE
-	dst_cache = (struct dst_cache *)&info->dst_cache;
-	if (use_cache) {
-		dst = dst_cache_get_ip6(dst_cache, saddr);
-		if (dst)
-			return dst;
-	}
-#endif
-	memset(&fl6, 0, sizeof(fl6));
-	fl6.flowi6_mark = skb->mark;
-	fl6.flowi6_proto = protocol;
-	fl6.daddr = info->key.u.ipv6.dst;
-	fl6.saddr = info->key.u.ipv6.src;
-	prio = info->key.tos;
-	fl6.flowlabel = ip6_make_flowinfo(prio, info->key.label);
-
-	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
-					      NULL);
-	if (IS_ERR(dst)) {
-		netdev_dbg(dev, "no route to %pI6\n", &fl6.daddr);
-		return ERR_PTR(-ENETUNREACH);
-	}
-	if (dst->dev == dev) { /* is this necessary? */
-		netdev_dbg(dev, "circular route to %pI6\n", &fl6.daddr);
-		dst_release(dst);
-		return ERR_PTR(-ELOOP);
-	}
-#ifdef CONFIG_DST_CACHE
-	if (use_cache)
-		dst_cache_set_ip6(dst_cache, dst, &fl6.saddr);
-#endif
-	*saddr = fl6.saddr;
-	return dst;
-}
-EXPORT_SYMBOL_GPL(ip6_dst_lookup_tunnel);
-
 static inline struct ipv6_opt_hdr *ip6_opt_dup(struct ipv6_opt_hdr *src,
 					       gfp_t gfp)
 {
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index cdc4d4ee24206..7aef559e60ec5 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -1,3 +1,4 @@
+
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -111,4 +112,72 @@ int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(udp_tunnel6_xmit_skb);
 
+/**
+ *      udp_tunnel6_dst_lookup - perform route lookup on UDP tunnel
+ *      @skb: Packet for which lookup is done
+ *      @dev: Tunnel device
+ *      @net: Network namespace of tunnel device
+ *      @sock: Socket which provides route info
+ *      @saddr: Memory to store the src ip address
+ *      @info: Tunnel information
+ *      @protocol: IP protocol
+ *      @use_cache: Flag to enable cache usage
+ *      This function performs a route lookup on a UDP tunnel
+ *
+ *      It returns a valid dst pointer and stores src address to be used in
+ *      tunnel in param saddr on success, else a pointer encoded error code.
+ */
+
+struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
+					 struct net_device *dev,
+					 struct net *net,
+					 struct socket *sock,
+					 struct in6_addr *saddr,
+					 const struct ip_tunnel_info *info,
+					 u8 protocol,
+					 bool use_cache)
+{
+	struct dst_entry *dst = NULL;
+#ifdef CONFIG_DST_CACHE
+	struct dst_cache *dst_cache;
+#endif
+	struct flowi6 fl6;
+	__u8 prio;
+
+#ifdef CONFIG_DST_CACHE
+	dst_cache = (struct dst_cache *)&info->dst_cache;
+	if (use_cache) {
+		dst = dst_cache_get_ip6(dst_cache, saddr);
+		if (dst)
+			return dst;
+	}
+#endif
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.flowi6_mark = skb->mark;
+	fl6.flowi6_proto = protocol;
+	fl6.daddr = info->key.u.ipv6.dst;
+	fl6.saddr = info->key.u.ipv6.src;
+	prio = info->key.tos;
+	fl6.flowlabel = ip6_make_flowinfo(prio, info->key.label);
+
+	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
+					      NULL);
+	if (IS_ERR(dst)) {
+		netdev_dbg(dev, "no route to %pI6\n", &fl6.daddr);
+		return ERR_PTR(-ENETUNREACH);
+	}
+	if (dst->dev == dev) { /* is this necessary? */
+		netdev_dbg(dev, "circular route to %pI6\n", &fl6.daddr);
+		dst_release(dst);
+		return ERR_PTR(-ELOOP);
+	}
+#ifdef CONFIG_DST_CACHE
+	if (use_cache)
+		dst_cache_set_ip6(dst_cache, dst, &fl6.saddr);
+#endif
+	*saddr = fl6.saddr;
+	return dst;
+}
+EXPORT_SYMBOL_GPL(udp_tunnel6_dst_lookup);
+
 MODULE_LICENSE("GPL");
-- 
2.53.0



