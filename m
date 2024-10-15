Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC11A1E7664;
	Tue, 15 Oct 2024 11:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992480; cv=none; b=hO0tji3wNSYDSdYw9aCMcCVe48Scnf6m/LREko+2QSvVbwAaGjL0whzuAOQ42NtO6xW8IxKzWLICp9uqK4Pmpb8RiFeNVrt7rUc2aJieYukekz/jZsvfuOrEp/T2394KjRvxm95/cgChnmqR6HUB5aLYcWxhuEtSO8StspUrT1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992480; c=relaxed/simple;
	bh=6uIGvYP5UKcUlbcKn9lsQagW03JmxNEQKIS2w9qM8uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmlHOsMJv/8i6dZO4DVDZIqCB9XQkJbijI4ZbrB1t0kvZy/07WKIBsnYbg+p8chD/NzTqiIdPBxmnukMqm/YN6ypEqeHtckDFh8Fx2JxY8+l4h3EKHWPap9DL5LoMUyt9jCebL3fsKptx5dcOpWCRCK8zWSY2NPr43exe1vBKY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEagU7Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEagU7Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3479FC4CEC6;
	Tue, 15 Oct 2024 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992479;
	bh=6uIGvYP5UKcUlbcKn9lsQagW03JmxNEQKIS2w9qM8uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEagU7Fd8SA9FZs43w2CWfsIjSWgapMDc60A4Q/WFjqNV73gJUx5WlbbIiZN2MXmm
	 trYiG7ONU9dtb1l3LjgOv1eiSYNhcS4E93z+6ndIP5qFZ3TAy49wXgKaYS8nIGKLih
	 Br00TnnslBJwNCQkmOIs2n4QZOkEg55ZRKP653e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/691] geneve: Fix incorrect inner network header offset when innerprotoinherit is set
Date: Tue, 15 Oct 2024 13:21:16 +0200
Message-ID: <20241015112445.436551457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit c6ae073f5903f6c6439d0ac855836a4da5c0a701 ]

When innerprotoinherit is set, the tunneled packets do not have an inner
Ethernet header.
Change 'maclen' to not always assume the header length is ETH_HLEN, as
there might not be a MAC header.

This resolves issues with drivers (e.g. mlx5, in
mlx5e_tx_tunnel_accel()) who rely on the skb inner network header offset
to be correct, and use it for TX offloads.

Fixes: d8a6213d70ac ("geneve: fix header validation in geneve[6]_xmit_skb")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c471236b2359 ("bareudp: Pull inner IP header on xmit.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c     | 10 ++++++----
 include/net/ip_tunnels.h |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 6790fec36a6cb..623e139e81fec 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -914,6 +914,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			   struct geneve_dev *geneve,
 			   const struct ip_tunnel_info *info)
 {
+	bool inner_proto_inherit = geneve->cfg.inner_proto_inherit;
 	bool xnet = !net_eq(geneve->net, dev_net(geneve->dev));
 	struct geneve_sock *gs4 = rcu_dereference(geneve->sock4);
 	const struct ip_tunnel_key *key = &info->key;
@@ -925,7 +926,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb))
+	if (!skb_vlan_inet_prepare(skb, inner_proto_inherit))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -998,7 +999,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
-			       geneve->cfg.inner_proto_inherit);
+			       inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
@@ -1014,6 +1015,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			    struct geneve_dev *geneve,
 			    const struct ip_tunnel_info *info)
 {
+	bool inner_proto_inherit = geneve->cfg.inner_proto_inherit;
 	bool xnet = !net_eq(geneve->net, dev_net(geneve->dev));
 	struct geneve_sock *gs6 = rcu_dereference(geneve->sock6);
 	const struct ip_tunnel_key *key = &info->key;
@@ -1023,7 +1025,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb))
+	if (!skb_vlan_inet_prepare(skb, inner_proto_inherit))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -1078,7 +1080,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		ttl = ttl ? : ip6_dst_hoplimit(dst);
 	}
 	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
-			       geneve->cfg.inner_proto_inherit);
+			       inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index eca36edb85570..526b492ebf78d 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -334,9 +334,10 @@ static inline bool pskb_inet_may_pull(struct sk_buff *skb)
 
 /* Variant of pskb_inet_may_pull().
  */
-static inline bool skb_vlan_inet_prepare(struct sk_buff *skb)
+static inline bool skb_vlan_inet_prepare(struct sk_buff *skb,
+					 bool inner_proto_inherit)
 {
-	int nhlen = 0, maclen = ETH_HLEN;
+	int nhlen = 0, maclen = inner_proto_inherit ? 0 : ETH_HLEN;
 	__be16 type = skb->protocol;
 
 	/* Essentially this is skb_protocol(skb, true)
-- 
2.43.0



