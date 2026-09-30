Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85B93264C2;
	Wed, 30 Sep 2026 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785348; cv=none; b=X75unSUVPdc7iiEKW8WGjkjQfqblgaEBkvSCshxcNFoM2nOFa9gPUW5w0LuzK70EQdIyRCTEikid8mlZdHYWDLW0oGdWVdyfhesKICfhquI6zsmwMplWf/O0meE/ByBq4x3mLOC65oCaBEXoYgcRsJvB1yXhLvaUQWXFsF15FSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785348; c=relaxed/simple;
	bh=asIVERVI3RbItWucHgQnmttWqjw+FzMcMYukpHCh6ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucjFLdrug9jMOkNEAJJJr2zo0XhsYN2wYmbd7MeZwaAbCKCnkP5KReYMKnaAR6QugsZH/HoFPzudLh4h/hyae0ilMGiyAG49SGBQiCIXN/08TEeHpcVyqgQsEUkKjGlUMkdqT93ayRzffyYHEQzq5S6KjqspK5mk4ZE0LEj+4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dx64AgPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dx64AgPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B2F1F00893;
	Wed, 30 Sep 2026 16:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785342;
	bh=p9xyMYR7obpUr5TB9h3xGwDqEyUKZxKP2sCSWA/BHBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dx64AgPiNAoWbRK8hDEhkaWKxI7PpwFSla+yCOPTKYL32W0rExFWmGUDYHsolkjmX
	 8JEFd85oV2XBIcCJffeYe/TaqpuXzZAc4ptIfDn49aiGtfETj1PJO860cYPeiGV863
	 MT67ng8Ln+xpbCcU9b9riaIlXpNVzcdnmyBv68Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 474/982] ipv6: add new arguments to udp_tunnel6_dst_lookup()
Date: Wed, 30 Sep 2026 17:20:10 +0200
Message-ID: <20260930152426.963611341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

[ Upstream commit 946fcfdbc5b97e26d31339ebca2d9a51a4f975ff ]

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

This is similar to what already done for IPv4 in commit 72fc68c6356b
("ipv4: add new arguments to udp_tunnel_dst_lookup()").

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: be83178bfc44 ("vxlan: initialize _md in vxlan_xmit_one()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c     | 10 +++++++---
 include/net/udp_tunnel.h  |  7 ++++---
 net/ipv6/ip6_udp_tunnel.c | 33 ++++++++++++++++++---------------
 3 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index eaaa7bf89accf..338958d2c1531 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -393,8 +393,10 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (!sock)
 		return -ESHUTDOWN;
 
-	dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock, &saddr, info,
-				     use_cache);
+	dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock, 0, &saddr,
+				     key, 0, 0, key->tos,
+				     use_cache ?
+				     (struct dst_cache *) &info->dst_cache : NULL);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
@@ -524,7 +526,9 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 			return -ESHUTDOWN;
 
 		dst = udp_tunnel6_dst_lookup(skb, dev, bareudp->net, sock,
-					     &saddr, info, use_cache);
+					     0, &saddr, &info->key,
+					     0, 0, info->key.tos,
+					     use_cache ? &info->dst_cache : NULL);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 8409a5429349b..a5fae599eaa9f 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -171,10 +171,11 @@ struct rtable *udp_tunnel_dst_lookup(struct sk_buff *skb,
 struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 					 struct net_device *dev,
 					 struct net *net,
-					 struct socket *sock,
+					 struct socket *sock, int oif,
 					 struct in6_addr *saddr,
-					 const struct ip_tunnel_info *info,
-					 bool use_cache);
+					 const struct ip_tunnel_key *key,
+					 __be16 sport, __be16 dport, u8 dsfield,
+					 struct dst_cache *dst_cache);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
 				    __be16 flags, __be64 tunnel_id,
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 812fc284cf36e..fe7a92cbbd449 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -118,9 +118,13 @@ EXPORT_SYMBOL_GPL(udp_tunnel6_xmit_skb);
  *      @dev: Tunnel device
  *      @net: Network namespace of tunnel device
  *      @sock: Socket which provides route info
+ *      @oif: Index of the output interface
  *      @saddr: Memory to store the src ip address
- *      @info: Tunnel information
- *      @use_cache: Flag to enable cache usage
+ *      @key: Tunnel information
+ *      @sport: UDP source port
+ *      @dport: UDP destination port
+ *      @dsfield: The traffic class field
+ *      @dst_cache: The dst cache to use for lookup
  *      This function performs a route lookup on a UDP tunnel
  *
  *      It returns a valid dst pointer and stores src address to be used in
@@ -131,20 +135,17 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 					 struct net_device *dev,
 					 struct net *net,
 					 struct socket *sock,
+					 int oif,
 					 struct in6_addr *saddr,
-					 const struct ip_tunnel_info *info,
-					 bool use_cache)
+					 const struct ip_tunnel_key *key,
+					 __be16 sport, __be16 dport, u8 dsfield,
+					 struct dst_cache *dst_cache)
 {
 	struct dst_entry *dst = NULL;
-#ifdef CONFIG_DST_CACHE
-	struct dst_cache *dst_cache;
-#endif
 	struct flowi6 fl6;
-	__u8 prio;
 
 #ifdef CONFIG_DST_CACHE
-	dst_cache = (struct dst_cache *)&info->dst_cache;
-	if (use_cache) {
+	if (dst_cache) {
 		dst = dst_cache_get_ip6(dst_cache, saddr);
 		if (dst)
 			return dst;
@@ -153,10 +154,12 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
-	fl6.daddr = info->key.u.ipv6.dst;
-	fl6.saddr = info->key.u.ipv6.src;
-	prio = info->key.tos;
-	fl6.flowlabel = ip6_make_flowinfo(prio, info->key.label);
+	fl6.flowi6_oif = oif;
+	fl6.daddr = key->u.ipv6.dst;
+	fl6.saddr = key->u.ipv6.src;
+	fl6.fl6_sport = sport;
+	fl6.fl6_dport = dport;
+	fl6.flowlabel = ip6_make_flowinfo(dsfield, key->label);
 
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
 					      NULL);
@@ -170,7 +173,7 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 		return ERR_PTR(-ELOOP);
 	}
 #ifdef CONFIG_DST_CACHE
-	if (use_cache)
+	if (dst_cache)
 		dst_cache_set_ip6(dst_cache, dst, &fl6.saddr);
 #endif
 	*saddr = fl6.saddr;
-- 
2.53.0



