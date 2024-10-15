Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBE41C07C2;
	Tue, 15 Oct 2024 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997086; cv=none; b=ubdbjGhWkR58r98fe6YJ9GEt5i7K7UNEQM5iHexgIGnsdzWdadB86KXkzqWIyzXy+K0+uoUMaWYQg1eC8Q73CdMIQ9/iByNGv9hIE8KnCTyTl4lQr7soP43pQmX2Przgzs46bzdyLmTPcqKHmTY5M+lPquz30uQrj8yRom7GQ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997086; c=relaxed/simple;
	bh=RD2K+rxfPBShygmIO6+ZO8AG1oWFBFUd98EGbibVn9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9ThrRwKWDZhEcukBCa+AQdOyEf6Cn0JmDmIhpVIDCnNp89B7mX0ZIP/LQQoa9wQ6B1QZyBKJ5lenPSmWpaKjJobaU2XpcRu4yd1cABUeEgCs+qR9Q2pQ3Bg9fsk3bFEeN/ugspRuqtdBEJr2bNnV9v0bUOQDZLoXVwyGAXS2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxwfF7EG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxwfF7EG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C138C4CEC6;
	Tue, 15 Oct 2024 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997085;
	bh=RD2K+rxfPBShygmIO6+ZO8AG1oWFBFUd98EGbibVn9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxwfF7EG656kFUgoSGE96auGuxibEUdOpqf422n4WzD37BIrmadXDA2ZTChDKK4/+
	 Zua+QAKe5ofDFp+FYBKRTXSYI3X7ygfwnYpwlDA3veHnH+oUMW0Ughl9UwZMgDfY/v
	 4+E0wBqVnH5pAZCIiiZJ3H84h9MyZLwrvQsYLmHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/518] net: geneve: support IPv4/IPv6 as inner protocol
Date: Tue, 15 Oct 2024 14:39:47 +0200
Message-ID: <20241015123920.208232260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 435fe1c0c1f74b682dba85641406abf4337aade6 ]

This patch adds support for encapsulating IPv4/IPv6 within GENEVE.

In order to use this, a new IFLA_GENEVE_INNER_PROTO_INHERIT flag needs
to be provided at device creation. This property cannot be changed for
the time being.

In case IP traffic is received on a non-tun device the drop count is
increased.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Link: https://lore.kernel.org/r/20220316061557.431872-1-eyal.birger@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c471236b2359 ("bareudp: Pull inner IP header on xmit.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c         | 82 +++++++++++++++++++++++++++---------
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 08b479f04ed06..88c3805978f2c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -54,6 +54,7 @@ struct geneve_config {
 	bool			use_udp6_rx_checksums;
 	bool			ttl_inherit;
 	enum ifla_geneve_df	df;
+	bool			inner_proto_inherit;
 };
 
 /* Pseudo network device */
@@ -249,17 +250,24 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		}
 	}
 
-	skb_reset_mac_header(skb);
-	skb->protocol = eth_type_trans(skb, geneve->dev);
-	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
-
 	if (tun_dst)
 		skb_dst_set(skb, &tun_dst->dst);
 
-	/* Ignore packet loops (and multicast echo) */
-	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
-		geneve->dev->stats.rx_errors++;
-		goto drop;
+	if (gnvh->proto_type == htons(ETH_P_TEB)) {
+		skb_reset_mac_header(skb);
+		skb->protocol = eth_type_trans(skb, geneve->dev);
+		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
+
+		/* Ignore packet loops (and multicast echo) */
+		if (ether_addr_equal(eth_hdr(skb)->h_source,
+				     geneve->dev->dev_addr)) {
+			geneve->dev->stats.rx_errors++;
+			goto drop;
+		}
+	} else {
+		skb_reset_mac_header(skb);
+		skb->dev = geneve->dev;
+		skb->pkt_type = PACKET_HOST;
 	}
 
 	/* Save offset of outer header relative to skb->head,
@@ -357,6 +365,7 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	struct genevehdr *geneveh;
 	struct geneve_dev *geneve;
 	struct geneve_sock *gs;
+	__be16 inner_proto;
 	int opts_len;
 
 	/* Need UDP and Geneve header to be present */
@@ -368,7 +377,11 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(geneveh->ver != GENEVE_VER))
 		goto drop;
 
-	if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
+	inner_proto = geneveh->proto_type;
+
+	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
+		      inner_proto != htons(ETH_P_IP) &&
+		      inner_proto != htons(ETH_P_IPV6))))
 		goto drop;
 
 	gs = rcu_dereference_sk_user_data(sk);
@@ -379,9 +392,14 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!geneve)
 		goto drop;
 
+	if (unlikely((!geneve->cfg.inner_proto_inherit &&
+		      inner_proto != htons(ETH_P_TEB)))) {
+		geneve->dev->stats.rx_dropped++;
+		goto drop;
+	}
+
 	opts_len = geneveh->opt_len * 4;
-	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
-				 htons(ETH_P_TEB),
+	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
 				 !net_eq(geneve->net, dev_net(geneve->dev)))) {
 		geneve->dev->stats.rx_dropped++;
 		goto drop;
@@ -728,7 +746,8 @@ static int geneve_stop(struct net_device *dev)
 }
 
 static void geneve_build_header(struct genevehdr *geneveh,
-				const struct ip_tunnel_info *info)
+				const struct ip_tunnel_info *info,
+				__be16 inner_proto)
 {
 	geneveh->ver = GENEVE_VER;
 	geneveh->opt_len = info->options_len / 4;
@@ -736,7 +755,7 @@ static void geneve_build_header(struct genevehdr *geneveh,
 	geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
 	geneveh->rsvd1 = 0;
 	tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
-	geneveh->proto_type = htons(ETH_P_TEB);
+	geneveh->proto_type = inner_proto;
 	geneveh->rsvd2 = 0;
 
 	if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
@@ -745,10 +764,12 @@ static void geneve_build_header(struct genevehdr *geneveh,
 
 static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 			    const struct ip_tunnel_info *info,
-			    bool xnet, int ip_hdr_len)
+			    bool xnet, int ip_hdr_len,
+			    bool inner_proto_inherit)
 {
 	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	struct genevehdr *gnvh;
+	__be16 inner_proto;
 	int min_headroom;
 	int err;
 
@@ -766,8 +787,9 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 		goto free_dst;
 
 	gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
-	geneve_build_header(gnvh, info);
-	skb_set_inner_protocol(skb, htons(ETH_P_TEB));
+	inner_proto = inner_proto_inherit ? skb->protocol : htons(ETH_P_TEB);
+	geneve_build_header(gnvh, info, inner_proto);
+	skb_set_inner_protocol(skb, inner_proto);
 	return 0;
 
 free_dst:
@@ -973,7 +995,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
-	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
+	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
+			       geneve->cfg.inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
@@ -1052,7 +1075,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			ttl = key->ttl;
 		ttl = ttl ? : ip6_dst_hoplimit(dst);
 	}
-	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
+	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
+			       geneve->cfg.inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
@@ -1401,6 +1425,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 	dst_cache_reset(&geneve->cfg.info.dst_cache);
 	memcpy(&geneve->cfg, cfg, sizeof(*cfg));
 
+	if (geneve->cfg.inner_proto_inherit) {
+		dev->header_ops = NULL;
+		dev->type = ARPHRD_NONE;
+		dev->hard_header_len = 0;
+		dev->addr_len = 0;
+		dev->flags = IFF_NOARP;
+	}
+
 	err = register_netdevice(dev);
 	if (err)
 		return err;
@@ -1574,10 +1606,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 #endif
 	}
 
+	if (data[IFLA_GENEVE_INNER_PROTO_INHERIT]) {
+		if (changelink) {
+			attrtype = IFLA_GENEVE_INNER_PROTO_INHERIT;
+			goto change_notsup;
+		}
+		cfg->inner_proto_inherit = true;
+	}
+
 	return 0;
 change_notsup:
 	NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
-			    "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
+			    "Changing VNI, Port, endpoint IP address family, external, inner_proto_inherit, and UDP checksum attributes are not supported");
 	return -EOPNOTSUPP;
 }
 
@@ -1812,6 +1852,10 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
 		goto nla_put_failure;
 
+	if (geneve->cfg.inner_proto_inherit &&
+	    nla_put_flag(skb, IFLA_GENEVE_INNER_PROTO_INHERIT))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index c4b23f06f69e0..9334f2128bb2e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -761,6 +761,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_INNER_PROTO_INHERIT,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
-- 
2.43.0



