Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B3424C07D;
	Wed,  5 Mar 2025 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197358; cv=none; b=FHZCKvl7I6B3QSHxiXHtDob4jzGFfx8dCv01mLmcw9hW9lYvsDyh3U+KJGShJCAh/lAR/6kitGWySAx5T1RdaJVG5NyxtvAz52tE5/n7Icx6E2MKplR9NkXkw1GRMaeMN0vsi3pZMbwjTFQTjEt7Zd17OqW4IDNJM/J7C35d6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197358; c=relaxed/simple;
	bh=W0C9+t1uGIPscLcXRELlFQKaKupFPHcIEA6XiVa0OUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZytQW0Dm4vClOkcSE9OB7Gq1AWZ/MaoBAihaBTNziQdEJ2yPLHhaQsQ9plgE0TVRL9OeXnN/kpsPOpAaUkOc44uX5tDqX0lxkWPT66g8WJc6QDOownA0PKbjFg/lHXppwVujMW1MuqffD6MeabEkaYyaYJ9HLhtg7SzzpYAP1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZtr8jYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZtr8jYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE1DC4CED1;
	Wed,  5 Mar 2025 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197358;
	bh=W0C9+t1uGIPscLcXRELlFQKaKupFPHcIEA6XiVa0OUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZtr8jYBS5a69EwxfL4VwTJYMN+pfx5RlMwyjvjRNQDYs65s1QLAj7omfOuBEVRQV
	 QuRobvRnfV0a/OrW364uGuavFn8YYXzFw+sHF8vndAp/Ise0omCDyJSviCmrz5TaLZ
	 aks7jVUb457DwCtgp6Bsm/AZIZX1l3MqLs8498k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/176] ipv4: Convert ip_route_input() to dscp_t.
Date: Wed,  5 Mar 2025 18:48:17 +0100
Message-ID: <20250305174510.590075609@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d754c4a53002..4ee23eb0814a3 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -409,6 +409,11 @@ int ip_decrease_ttl(struct iphdr *iph)
 	return --iph->ttl;
 }
 
+static inline dscp_t ip4h_dscp(const struct iphdr *ip4h)
+{
+	return inet_dsfield_to_dscp(ip4h->tos);
+}
+
 static inline int ip_mtu_locked(const struct dst_entry *dst)
 {
 	const struct rtable *rt = (const struct rtable *)dst;
diff --git a/include/net/route.h b/include/net/route.h
index f396176022377..4185e6da9ef85 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -203,12 +203,13 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
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
index 5c6ed1d49b92c..b4d661fe7886d 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -366,9 +366,9 @@ br_nf_ipv4_daddr_was_changed(const struct sk_buff *skb,
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
 
@@ -386,7 +386,9 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
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
index 855fcef829e2c..94501bb30c431 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -549,7 +549,7 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     inet_dscp_to_dsfield(dscp), rt2->dst.dev);
+				     dscp, rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index a9e22a098872f..b4c59708fc095 100644
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
index f3324f2a40466..a82d382193e41 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -628,8 +628,8 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
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



