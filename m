Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0174126C05;
	Mon,  6 Jan 2025 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176783; cv=none; b=Jo25P+9RMh00hIYTP1V/5zbsyfj6ctaBFABWFsq0bhIJCPjMzwQmzGgQR5ShswNpAZLnOzqxHe2oWSpLLuJ79AH6Mg+YidcvsJ+jsoYYeuk0T0Abh1YQ9F+W6S+EZVkCWXU/p2oPcFTJv3l2w/x06bBWFmwmk9id9AEX17wGmHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176783; c=relaxed/simple;
	bh=EDT1iShB3RdI4amnnh9dYTEIBtzQlPH6ag6z/enN5VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkVd/s4po1kyDwMme2AKVSaEN4Rmd2SVpy1aHyB1C8SuMSXkdhL6etgjJGHuSuwny6C7r4oM1x+zrkmQKK1VSnG86NntIXYTuFYqe3BfzFGHhHrmpdL32FT70nd7HxAF+L6DzZyHIZmbj/lOneADB5gsA/JSQiEBuhjWotH0wEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd8ANuVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd8ANuVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E3EC4CED6;
	Mon,  6 Jan 2025 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176782;
	bh=EDT1iShB3RdI4amnnh9dYTEIBtzQlPH6ag6z/enN5VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd8ANuVTCtR4HZaGi459plKlE3iQA1xWkgUyCkQCpgfVMaBfB4Uz24KI0XXYu0pl+
	 6gJlXyqGMktPOXZYiN15EAAlr45/p6/b/mn+GYonlq2KB54wcc9/H/ln9NP3Ukvdy3
	 5fbfTgW3lCoFvlT74rO2YJeIrN5JUsMRFx0KHImo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Ehrig <cehrig@cloudflare.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/81] ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices
Date: Mon,  6 Jan 2025 16:16:02 +0100
Message-ID: <20250106151130.576363524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

From: Christian Ehrig <cehrig@cloudflare.com>

[ Upstream commit ac931d4cdec3df8b6eac3bc40a6871123021f078 ]

Today ipip devices in collect-metadata mode don't allow for sending FOU
or GUE encapsulated packets. This patch lifts the restriction by adding
a struct ip_tunnel_encap to the tunnel metadata.

On the egress path, the members of this struct can be set by the
bpf_skb_set_fou_encap kfunc via a BPF tc-hook. Instead of dropping packets
wishing to use additional UDP encapsulation, ip_md_tunnel_xmit now
evaluates the contents of this struct and adds the corresponding FOU or
GUE header. Furthermore, it is making sure that additional header bytes
are taken into account for PMTU discovery.

On the ingress path, an ipip device in collect-metadata mode will fill this
struct and a BPF tc-hook can obtain the information via a call to the
bpf_skb_get_fou_encap kfunc.

The minor change to ip_tunnel_encap, which now takes a pointer to
struct ip_tunnel_encap instead of struct ip_tunnel, allows us to control
FOU encap type and parameters on a per packet-level.

Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
Link: https://lore.kernel.org/r/cfea47de655d0f870248abf725932f851b53960a.1680874078.git.cehrig@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: b5a7b661a073 ("net: Fix netns for ip_tunnel_init_flow()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_tunnels.h | 28 +++++++++++++++-------------
 net/ipv4/ip_tunnel.c     | 22 ++++++++++++++++++++--
 net/ipv4/ipip.c          |  1 +
 net/ipv6/sit.c           |  2 +-
 4 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index f1ba369306fe..84751313b826 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -57,6 +57,13 @@ struct ip_tunnel_key {
 	__u8			flow_flags;
 };
 
+struct ip_tunnel_encap {
+	u16			type;
+	u16			flags;
+	__be16			sport;
+	__be16			dport;
+};
+
 /* Flags for ip_tunnel_info mode. */
 #define IP_TUNNEL_INFO_TX	0x01	/* represents tx tunnel parameters */
 #define IP_TUNNEL_INFO_IPV6	0x02	/* key contains IPv6 addresses */
@@ -66,9 +73,9 @@ struct ip_tunnel_key {
 #define IP_TUNNEL_OPTS_MAX					\
 	GENMASK((sizeof_field(struct ip_tunnel_info,		\
 			      options_len) * BITS_PER_BYTE) - 1, 0)
-
 struct ip_tunnel_info {
 	struct ip_tunnel_key	key;
+	struct ip_tunnel_encap	encap;
 #ifdef CONFIG_DST_CACHE
 	struct dst_cache	dst_cache;
 #endif
@@ -86,13 +93,6 @@ struct ip_tunnel_6rd_parm {
 };
 #endif
 
-struct ip_tunnel_encap {
-	u16			type;
-	u16			flags;
-	__be16			sport;
-	__be16			dport;
-};
-
 struct ip_tunnel_prl_entry {
 	struct ip_tunnel_prl_entry __rcu *next;
 	__be32				addr;
@@ -293,6 +293,7 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 				   __be32 remote, __be32 local,
 				   __be32 key);
 
+void ip_tunnel_md_udp_encap(struct sk_buff *skb, struct ip_tunnel_info *info);
 int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		  const struct tnl_ptk_info *tpi, struct metadata_dst *tun_dst,
 		  bool log_ecn_error);
@@ -405,22 +406,23 @@ static inline int ip_encap_hlen(struct ip_tunnel_encap *e)
 	return hlen;
 }
 
-static inline int ip_tunnel_encap(struct sk_buff *skb, struct ip_tunnel *t,
+static inline int ip_tunnel_encap(struct sk_buff *skb,
+				  struct ip_tunnel_encap *e,
 				  u8 *protocol, struct flowi4 *fl4)
 {
 	const struct ip_tunnel_encap_ops *ops;
 	int ret = -EINVAL;
 
-	if (t->encap.type == TUNNEL_ENCAP_NONE)
+	if (e->type == TUNNEL_ENCAP_NONE)
 		return 0;
 
-	if (t->encap.type >= MAX_IPTUN_ENCAP_OPS)
+	if (e->type >= MAX_IPTUN_ENCAP_OPS)
 		return -EINVAL;
 
 	rcu_read_lock();
-	ops = rcu_dereference(iptun_encaps[t->encap.type]);
+	ops = rcu_dereference(iptun_encaps[e->type]);
 	if (likely(ops && ops->build_header))
-		ret = ops->build_header(skb, &t->encap, protocol, fl4);
+		ret = ops->build_header(skb, e, protocol, fl4);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 3445e576b05b..d56cfb6c3da4 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -359,6 +359,20 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	return ERR_PTR(err);
 }
 
+void ip_tunnel_md_udp_encap(struct sk_buff *skb, struct ip_tunnel_info *info)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct udphdr *udph;
+
+	if (iph->protocol != IPPROTO_UDP)
+		return;
+
+	udph = (struct udphdr *)((__u8 *)iph + (iph->ihl << 2));
+	info->encap.sport = udph->source;
+	info->encap.dport = udph->dest;
+}
+EXPORT_SYMBOL(ip_tunnel_md_udp_encap);
+
 int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		  const struct tnl_ptk_info *tpi, struct metadata_dst *tun_dst,
 		  bool log_ecn_error)
@@ -599,7 +613,11 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
 			    dev_net(dev), 0, skb->mark, skb_get_hash(skb),
 			    key->flow_flags);
-	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
+
+	if (!tunnel_hlen)
+		tunnel_hlen = ip_encap_hlen(&tun_info->encap);
+
+	if (ip_tunnel_encap(skb, &tun_info->encap, &proto, &fl4) < 0)
 		goto tx_error;
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
@@ -759,7 +777,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			    dev_net(dev), tunnel->parms.link,
 			    tunnel->fwmark, skb_get_hash(skb), 0);
 
-	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)
+	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
 		goto tx_error;
 
 	if (connected && md) {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 180f9daf5bec..1cf35c50cdf4 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -241,6 +241,7 @@ static int ipip_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 			tun_dst = ip_tun_rx_dst(skb, 0, 0, 0);
 			if (!tun_dst)
 				return 0;
+			ip_tunnel_md_udp_encap(skb, &tun_dst->u.tun_info);
 		}
 		skb_reset_mac_header(skb);
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 3ffb6a5b1f82..cc24cefdb85c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1024,7 +1024,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		ttl = iph6->hop_limit;
 	tos = INET_ECN_encapsulate(tos, ipv6_get_dsfield(iph6));
 
-	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0) {
+	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0) {
 		ip_rt_put(rt);
 		goto tx_error;
 	}
-- 
2.39.5



