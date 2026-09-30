Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6118B34E75A;
	Wed, 30 Sep 2026 19:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795590; cv=none; b=fMDvR25wrPwWuzCzmgq7UBpeYZGYHkXxswDsLLUCXWCPiw6KD/I6l0K7iocfwgXJpUa08Hl7iZmTAgToCHCRfsZVSTVNvNVVSJMp1cWrRjjOv4fQYGprUsRrPlfbcxFtI5aMYZsP3T+tMrE/3/UPEB9vCI0R4lcW39uOsL5n1P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795590; c=relaxed/simple;
	bh=RSdvXjvAh15ZaF25I+HMF5fBk0WfbhSQSpsNnJrK9Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRSC/XpZPz8AaabXn0oNMGFcWve+Ibwj4oi8DXxkt7cnylkfsxx6LawTQmlXOiBrGyihX1LyZ56F0u3QzCgDhE5CbgmQI7XR4+kV+L9Py9/bH+OUg8H7xZW9IVq48cZfA32G0IHE0Q9kxmpzc0FffvTOkdtfdpc4K8j94piDsd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uugYZcG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uugYZcG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9BC1F000FF;
	Wed, 30 Sep 2026 19:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795589;
	bh=2wgUgoDVYx9XOG6BIq4M6E12h5zs9KaKRtfG2tpExLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uugYZcG3OacnUQAHB7aRJVoKb7by6AQG6aGb84Jvz+y56SGhxWeEpiLsUKrpnJVX1
	 ND8mjKK6dAcKl2yYo6auFWVQLTMGxLvsdxxrifiGp4UJ/glwj9uRVux4PdkcXBRg+e
	 X7h+Mip20KHkUskJaW6G/iwbexHRa12XJbVGItzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0569/1193] vxlan: use generic function for tunnel IPv4 route lookup
Date: Wed, 30 Sep 2026 17:20:53 +0200
Message-ID: <20260930152446.882374741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beniamino Galvani <b.galvani@gmail.com>

[ Upstream commit 6f19b2c136d98a84d79030b53e23d405edfdc783 ]

The route lookup can be done now via generic function
udp_tunnel_dst_lookup() to replace the custom implementations in
vxlan_get_route().

Note that this patch only touches IPv4, while IPv6 still uses
vxlan6_get_route(). After IPv6 route lookup gets converted as well,
vxlan_xmit_one() can be simplified by removing local variables that
will be passed via "struct ip_tunnel_key", such as remote_ip,
local_ip, flow_flags, label.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: be83178bfc44 ("vxlan: initialize _md in vxlan_xmit_one()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 114 ++++++++++++---------------------
 1 file changed, 41 insertions(+), 73 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 199f393bad9da..ab14e260d5bfe 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2266,57 +2266,6 @@ static int vxlan_build_skb(struct sk_buff *skb, struct dst_entry *dst,
 	return 0;
 }
 
-static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device *dev,
-				      struct vxlan_sock *sock4,
-				      struct sk_buff *skb, int oif, u8 tos,
-				      __be32 daddr, __be32 *saddr, __be16 dport, __be16 sport,
-				      __u8 flow_flags, struct dst_cache *dst_cache,
-				      const struct ip_tunnel_info *info)
-{
-	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
-	struct rtable *rt = NULL;
-	struct flowi4 fl4;
-
-	if (!sock4)
-		return ERR_PTR(-EIO);
-
-	if (tos && !info)
-		use_cache = false;
-	if (use_cache) {
-		rt = dst_cache_get_ip4(dst_cache, saddr);
-		if (rt)
-			return rt;
-	}
-
-	memset(&fl4, 0, sizeof(fl4));
-	fl4.flowi4_oif = oif;
-	fl4.flowi4_tos = RT_TOS(tos);
-	fl4.flowi4_mark = skb->mark;
-	fl4.flowi4_proto = IPPROTO_UDP;
-	fl4.daddr = daddr;
-	fl4.saddr = *saddr;
-	fl4.fl4_dport = dport;
-	fl4.fl4_sport = sport;
-	fl4.flowi4_flags = flow_flags;
-
-	rt = ip_route_output_key(vxlan->net, &fl4);
-	if (!IS_ERR(rt)) {
-		if (rt->dst.dev == dev) {
-			netdev_dbg(dev, "circular route to %pI4\n", &daddr);
-			ip_rt_put(rt);
-			return ERR_PTR(-ELOOP);
-		}
-
-		*saddr = fl4.saddr;
-		if (use_cache)
-			dst_cache_set_ip4(dst_cache, &rt->dst, fl4.saddr);
-	} else {
-		netdev_dbg(dev, "no route to %pI4\n", &daddr);
-		return ERR_PTR(-ENETUNREACH);
-	}
-	return rt;
-}
-
 #if IS_ENABLED(CONFIG_IPV6)
 static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 					  struct net_device *dev,
@@ -2469,30 +2418,38 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 {
 	struct dst_cache *dst_cache;
 	struct ip_tunnel_info *info;
+	struct ip_tunnel_key *pkey;
+	struct ip_tunnel_key key;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	const struct iphdr *old_iph = ip_hdr(skb);
 	union vxlan_addr *dst;
-	union vxlan_addr remote_ip, local_ip;
+	union vxlan_addr remote_ip;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
 	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
-	__u8 tos, ttl, flow_flags = 0;
+	__u8 tos, ttl;
 	int ifindex;
 	int err;
 	u32 flags = vxlan->cfg.flags;
+	bool use_cache;
 	bool udp_sum = false;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
 	__be32 vni = 0;
 #if IS_ENABLED(CONFIG_IPV6)
+	union vxlan_addr local_ip;
 	__be32 label;
 #endif
 
 	info = skb_tunnel_info(skb);
+	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
 	if (rdst) {
 		dst = &rdst->remote_ip;
+		memset(&key, 0, sizeof(key));
+		pkey = &key;
+
 		if (vxlan_addr_any(dst)) {
 			if (did_rsc) {
 				/* short-circuited back to local bridge */
@@ -2506,7 +2463,15 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		dst_port = rdst->remote_port ? rdst->remote_port : vxlan->cfg.dst_port;
 		vni = (rdst->remote_vni) ? : default_vni;
 		ifindex = rdst->remote_ifindex;
-		local_ip = vxlan->cfg.saddr;
+
+		if (dst->sa.sa_family == AF_INET) {
+			key.u.ipv4.src = vxlan->cfg.saddr.sin.sin_addr.s_addr;
+			key.u.ipv4.dst = rdst->remote_ip.sin.sin_addr.s_addr;
+		} else {
+			key.u.ipv6.src = vxlan->cfg.saddr.sin6.sin6_addr;
+			key.u.ipv6.dst = rdst->remote_ip.sin6.sin6_addr;
+		}
+
 		dst_cache = &rdst->dst_cache;
 		md->gbp = skb->mark;
 		if (flags & VXLAN_F_TTL_INHERIT) {
@@ -2520,12 +2485,15 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		tos = vxlan->cfg.tos;
 		if (tos == 1)
 			tos = ip_tunnel_get_dsfield(old_iph, skb);
+		if (tos && !info)
+			use_cache = false;
 
 		if (dst->sa.sa_family == AF_INET)
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM_TX);
 		else
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
 #if IS_ENABLED(CONFIG_IPV6)
+		local_ip = vxlan->cfg.saddr;
 		label = vxlan->cfg.label;
 #endif
 	} else {
@@ -2537,14 +2505,15 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		remote_ip.sa.sa_family = ip_tunnel_info_af(info);
 		if (remote_ip.sa.sa_family == AF_INET) {
 			remote_ip.sin.sin_addr.s_addr = info->key.u.ipv4.dst;
-			local_ip.sin.sin_addr.s_addr = info->key.u.ipv4.src;
 		} else {
 			remote_ip.sin6.sin6_addr = info->key.u.ipv6.dst;
+#if IS_ENABLED(CONFIG_IPV6)
 			local_ip.sin6.sin6_addr = info->key.u.ipv6.src;
+#endif
 		}
 		dst = &remote_ip;
+		pkey = &info->key;
 		dst_port = info->key.tp_dst ? : vxlan->cfg.dst_port;
-		flow_flags = info->key.flow_flags;
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
@@ -2568,15 +2537,14 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		struct vxlan_sock *sock4 = rcu_dereference(vxlan->vn4_sock);
 		struct rtable *rt;
 		__be16 df = 0;
+		__be32 saddr;
 
 		if (!ifindex)
 			ifindex = sock4->sock->sk->sk_bound_dev_if;
 
-		rt = vxlan_get_route(vxlan, dev, sock4, skb, ifindex, tos,
-				     dst->sin.sin_addr.s_addr,
-				     &local_ip.sin.sin_addr.s_addr,
-				     dst_port, src_port, flow_flags,
-				     dst_cache, info);
+		rt = udp_tunnel_dst_lookup(skb, dev, vxlan->net, ifindex,
+					   &saddr, pkey, src_port, dst_port,
+					   tos, use_cache ? dst_cache : NULL);
 		if (IS_ERR(rt)) {
 			err = PTR_ERR(rt);
 			goto tx_error;
@@ -2612,16 +2580,13 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		} else if (err) {
 			if (info) {
 				struct ip_tunnel_info *unclone;
-				struct in_addr src, dst;
 
 				unclone = skb_tunnel_info_unclone(skb);
 				if (unlikely(!unclone))
 					goto tx_error;
 
-				src = remote_ip.sin.sin_addr;
-				dst = local_ip.sin.sin_addr;
-				unclone->key.u.ipv4.src = src.s_addr;
-				unclone->key.u.ipv4.dst = dst.s_addr;
+				unclone->key.u.ipv4.src = pkey->u.ipv4.dst;
+				unclone->key.u.ipv4.dst = saddr;
 			}
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
 			dst_release(ndst);
@@ -2635,8 +2600,8 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		if (err < 0)
 			goto tx_error;
 
-		udp_tunnel_xmit_skb(rt, sock4->sock->sk, skb, local_ip.sin.sin_addr.s_addr,
-				    dst->sin.sin_addr.s_addr, tos, ttl, df,
+		udp_tunnel_xmit_skb(rt, sock4->sock->sk, skb, saddr,
+				    pkey->u.ipv4.dst, tos, ttl, df,
 				    src_port, dst_port, xnet, !udp_sum);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
@@ -3146,11 +3111,14 @@ static int vxlan_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		struct vxlan_sock *sock4 = rcu_dereference(vxlan->vn4_sock);
 		struct rtable *rt;
 
-		rt = vxlan_get_route(vxlan, dev, sock4, skb, 0, info->key.tos,
-				     info->key.u.ipv4.dst,
-				     &info->key.u.ipv4.src, dport, sport,
-				     info->key.flow_flags, &info->dst_cache,
-				     info);
+		if (!sock4)
+			return -EIO;
+
+		rt = udp_tunnel_dst_lookup(skb, dev, vxlan->net, 0,
+					   &info->key.u.ipv4.src,
+					   &info->key,
+					   sport, dport, info->key.tos,
+					   &info->dst_cache);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 		ip_rt_put(rt);
-- 
2.53.0



