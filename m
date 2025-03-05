Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE0D20C004;
	Wed,  5 Mar 2025 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198018; cv=none; b=prdIyrqE/KbLqlnMZqZhT3MklE9sD4f1Xvcstjfg2oErYvl8kWwwjxP2vgFBLie9JMVWCelJZsvr06JI/i1Oypee6RMdUA6LQsZD7TVrBgmRthPlHc+BZby9UHBtf4SLJLHczCI1jgYvoISWiFh9R9JsEXB8E8+9dANFQWyz7vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198018; c=relaxed/simple;
	bh=KLPQADHbUd/Co8XOeD4wmE/3T2OKnUdK/P/s7xRywo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ko1qoO4axPN7tcRcAoKhGC5QuhRbLHrvobDsIMCPqEXdylEFqmWl13LoQE4pYAHUr0/HAyCuRwkvLCXib21ISng/+V+qIs3LWO+zg3WIW/v7Uf1+LCBbipGsTNPmfNvyD5ymerKdQOHm19pmBIxTbH0pRFdgtI356EwNt+CMWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3HBwfcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3HBwfcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C01C4CED1;
	Wed,  5 Mar 2025 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198018;
	bh=KLPQADHbUd/Co8XOeD4wmE/3T2OKnUdK/P/s7xRywo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3HBwfcAYJO2hWVpKDdu9//eov6jAfPdUv6v5O8pQtRH+KM7xVb6tl0Oh1j2zOQGv
	 nQwliiAicbaj6xABvjaD51PBtJ3ggQe8bdpoijCc6K5dwkDMR21yw57sWCNu5gwPPY
	 oDfl0ZbtN8DU9CZmk13zNN5cfUjOY0ylMQR9m8B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/150] ipv4: Convert ip_route_input() to dscp_t.
Date: Wed,  5 Mar 2025 18:47:45 +0100
Message-ID: <20250305174505.264738736@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 7e863e5db6185b1add0df4cb01b31a4ed1c4b738 ]

Pass a dscp_t variable to ip_route_input(), instead of a plain u8, to
prevent accidental setting of ECN bits in ->flowi4_tos.

Callers of ip_route_input() to consider are:

  * input_action_end_dx4_finish() and input_action_end_dt4() in
    net/ipv6/seg6_local.c. These functions set the tos parameter to 0,
    which is already a valid dscp_t value, so they don't need to be
    adjusted for the new prototype.

  * icmp_route_lookup(), which already has a dscp_t variable to pass as
    parameter. We just need to remove the inet_dscp_to_dsfield()
    conversion.

  * br_nf_pre_routing_finish(), ip_options_rcv_srr() and ip4ip6_err(),
    which get the DSCP directly from IPv4 headers. Define a helper to
    read the .tos field of struct iphdr as dscp_t, so that these
    function don't have to do the conversion manually.

While there, declare *iph as const in br_nf_pre_routing_finish(),
declare its local variables in reverse-christmas-tree order and move
the "err = ip_route_input()" assignment out of the conditional to avoid
checkpatch warning.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/e9d40781d64d3d69f4c79ac8a008b8d67a033e8d.1727807926.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h                | 5 +++++
 include/net/route.h             | 5 +++--
 net/bridge/br_netfilter_hooks.c | 8 +++++---
 net/ipv4/icmp.c                 | 2 +-
 net/ipv4/ip_options.c           | 3 ++-
 net/ipv6/ip6_tunnel.c           | 4 ++--
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index fe4f854381143..bd201278c55a5 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -424,6 +424,11 @@ int ip_decrease_ttl(struct iphdr *iph)
 	return --iph->ttl;
 }
 
+static inline dscp_t ip4h_dscp(const struct iphdr *ip4h)
+{
+	return inet_dsfield_to_dscp(ip4h->tos);
+}
+
 static inline int ip_mtu_locked(const struct dst_entry *dst)
 {
 	const struct rtable *rt = dst_rtable(dst);
diff --git a/include/net/route.h b/include/net/route.h
index da34b6fa9862d..8a11d19f897bb 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -208,12 +208,13 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
 		      const struct sk_buff *hint);
 
 static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 src,
-				 u8 tos, struct net_device *devin)
+				 dscp_t dscp, struct net_device *devin)
 {
 	int err;
 
 	rcu_read_lock();
-	err = ip_route_input_noref(skb, dst, src, tos, devin);
+	err = ip_route_input_noref(skb, dst, src, inet_dscp_to_dsfield(dscp),
+				   devin);
 	if (!err) {
 		skb_dst_force(skb);
 		if (!skb_dst(skb))
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 1d458e9da660c..17a5f5923d615 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -370,9 +370,9 @@ br_nf_ipv4_daddr_was_changed(const struct sk_buff *skb,
  */
 static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct net_device *dev = skb->dev, *br_indev;
-	struct iphdr *iph = ip_hdr(skb);
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
+	struct net_device *dev = skb->dev, *br_indev;
+	const struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt;
 	int err;
 
@@ -390,7 +390,9 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 	}
 	nf_bridge->in_prerouting = 0;
 	if (br_nf_ipv4_daddr_was_changed(skb, nf_bridge)) {
-		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
+		err = ip_route_input(skb, iph->daddr, iph->saddr,
+				     ip4h_dscp(iph), dev);
+		if (err) {
 			struct in_device *in_dev = __in_dev_get_rcu(dev);
 
 			/* If err equals -EHOSTUNREACH the error is due to a
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 0a2f988c4c24e..b8111ec651b54 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -547,7 +547,7 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     inet_dscp_to_dsfield(dscp), rt2->dst.dev);
+				     dscp, rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 68aedb8877b9f..81e86e5defee6 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -617,7 +617,8 @@ int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev)
 
 		orefdst = skb->_skb_refdst;
 		skb_dst_set(skb, NULL);
-		err = ip_route_input(skb, nexthop, iph->saddr, iph->tos, dev);
+		err = ip_route_input(skb, nexthop, iph->saddr, ip4h_dscp(iph),
+				     dev);
 		rt2 = skb_rtable(skb);
 		if (err || (rt2->rt_type != RTN_UNICAST && rt2->rt_type != RTN_LOCAL)) {
 			skb_dst_drop(skb);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b60e13c42bcac..48fd53b989726 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -630,8 +630,8 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		}
 		skb_dst_set(skb2, &rt->dst);
 	} else {
-		if (ip_route_input(skb2, eiph->daddr, eiph->saddr, eiph->tos,
-				   skb2->dev) ||
+		if (ip_route_input(skb2, eiph->daddr, eiph->saddr,
+				   ip4h_dscp(eiph), skb2->dev) ||
 		    skb_dst(skb2)->dev->type != ARPHRD_TUNNEL6)
 			goto out;
 	}
-- 
2.39.5



