Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D4B13AA40;
	Wed, 19 Jun 2024 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802326; cv=none; b=lEse6JWO00VNgbFas2CCAg2mG6Bkv/CNoJ+ZgIel6JhFPxtdnSTkk5C+dFwNgf7FqrZ1roX7Cr/Le7RWWNWhiqD0BKLI8vs5ZGJo85TAF5/tk4Tr2xL7LmfMEXjbpHpSk2qxqrSDu/eGcQzLdawYqK7dxBmx81Zy8An4ewwWrbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802326; c=relaxed/simple;
	bh=XfcBgua++sSfL3bs1kQtnh1caKxJXkXkPSDUDKWQbQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPB10jzFB/T9wZdtRHTK0Nawyy+2S7H7Oi38CzyBJLjuoergRCXNR+pu0NLScB6rPGezL0ZS0VM97NJOHkEBZdGpnl3pKvABQGKHnEtjsI/NmRuD7/rTT/a2hd9KJrbHFwZN2HFN6OTR6vxhAknSv6hgMp6WMgxvDdU06aftlvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwZSEcZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwZSEcZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8656FC2BBFC;
	Wed, 19 Jun 2024 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802325;
	bh=XfcBgua++sSfL3bs1kQtnh1caKxJXkXkPSDUDKWQbQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwZSEcZD8aAxW2Cp0tqAHbb32J7fuzbcgGIwOtWNESw765xkv9TzS20M/64KWDioR
	 4mTIXQr6wD+9Dwhv4NHGq8IqbrTBauKZQ6kK6CJ7JQUDSP7pcoU4deIHgaUMzaipgq
	 qDzPj64mvNTGn+3dELdtm6q2seoGnPveTf1sczKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/267] geneve: Fix incorrect inner network header offset when innerprotoinherit is set
Date: Wed, 19 Jun 2024 14:55:02 +0200
Message-ID: <20240619125612.141822478@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c     | 10 ++++++----
 include/net/ip_tunnels.h |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 0a18b67d0d669..8333a5620deff 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -915,6 +915,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			   struct geneve_dev *geneve,
 			   const struct ip_tunnel_info *info)
 {
+	bool inner_proto_inherit = geneve->cfg.inner_proto_inherit;
 	bool xnet = !net_eq(geneve->net, dev_net(geneve->dev));
 	struct geneve_sock *gs4 = rcu_dereference(geneve->sock4);
 	const struct ip_tunnel_key *key = &info->key;
@@ -926,7 +927,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb))
+	if (!skb_vlan_inet_prepare(skb, inner_proto_inherit))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -999,7 +1000,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
-			       geneve->cfg.inner_proto_inherit);
+			       inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
@@ -1015,6 +1016,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			    struct geneve_dev *geneve,
 			    const struct ip_tunnel_info *info)
 {
+	bool inner_proto_inherit = geneve->cfg.inner_proto_inherit;
 	bool xnet = !net_eq(geneve->net, dev_net(geneve->dev));
 	struct geneve_sock *gs6 = rcu_dereference(geneve->sock6);
 	const struct ip_tunnel_key *key = &info->key;
@@ -1024,7 +1026,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb))
+	if (!skb_vlan_inet_prepare(skb, inner_proto_inherit))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -1079,7 +1081,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		ttl = ttl ? : ip6_dst_hoplimit(dst);
 	}
 	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
-			       geneve->cfg.inner_proto_inherit);
+			       inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 822f0fad39623..4e69f52a51177 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -362,9 +362,10 @@ static inline bool pskb_inet_may_pull(struct sk_buff *skb)
 
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



