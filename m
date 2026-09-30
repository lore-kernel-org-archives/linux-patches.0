Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6B2BEFEF;
	Wed, 30 Sep 2026 19:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795468; cv=none; b=syHFaIUB/XZV/JhpgDY8K/0iS37qAsmN/KFE0Q2QmmrvaHj8zVMlAUKVuAPhVsNyuWZFYdnfRtUbNw4RQvDEtPWuw401OCOOOVpLdFtyg78zWBhu0q4xYoFm2cFWuuxuorIISfGApgxw5eTeYneQb4GasrdVTI4n+dlabrX2T08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795468; c=relaxed/simple;
	bh=cgScACcC5yr1OgpkwT0elm6lVxwKvJq1rhQa/KmEvEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcPLk0Z4pjrbPrIFN7t3akGX6K6oa8criSiJq79038vgfp+9v4iWymZB6+YkAihSYDV8xqlI+05DRPygukKLezc6WLssK54QxB3xyWkMC8L5LmeLS1cjjidBKiMIBR15o+oqIEd4g2n1ZC/INCnZfFjOpUg+TXZAH2GY+Cr+9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9xC7r1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9xC7r1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAB91F000FF;
	Wed, 30 Sep 2026 19:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795467;
	bh=UWB5HyD8Egyw1n8Ec+dYl7TduzNKGjWmA2zI5ZFVbIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9xC7r1wsZE8U1Yfg56s3mieZLACoRYPE382ctX8GhZWLClMT60c4T/1y0Z0UooWa
	 dkob/Z86jrsd0L9ouApW44erVUzeUjGq4FHVsmGaSPBrVVpLD1eZ7Ho9zIMw2IxkW6
	 LpEW9fyeB0GwW4mo/GoIJzgIG+WGm/lGDodVDCMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0573/1193] vxlan: Pull inner IP header in vxlan_xmit_one().
Date: Wed, 30 Sep 2026 17:20:57 +0200
Message-ID: <20260930152446.971135250@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 31392048f55f98cb01ca709d32d06d926ab9760a ]

Ensure the inner IP header is part of the skb's linear data before
setting old_iph. Otherwise, on a non-linear skb, old_iph could point
outside of the packet data.

Unlike classical VXLAN, which always encapsulates Ethernet packets,
VXLAN-GPE can transport IP packets directly. In that case, we need to
look at skb->protocol to figure out if an Ethernet header is present.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/2aa75f6fa62ac9dbe4f16ad5ba75dd04a51d4b99.1718804000.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: be83178bfc44 ("vxlan: initialize _md in vxlan_xmit_one()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 82e49cf06d52e..bbffd73772362 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2364,7 +2364,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct ip_tunnel_key *pkey;
 	struct ip_tunnel_key key;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	const struct iphdr *old_iph = ip_hdr(skb);
+	const struct iphdr *old_iph;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
 	unsigned int pkt_len = skb->len;
@@ -2378,8 +2378,15 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	bool use_cache;
 	bool udp_sum = false;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
+	bool no_eth_encap;
 	__be32 vni = 0;
 
+	no_eth_encap = flags & VXLAN_F_GPE && skb->protocol != htons(ETH_P_TEB);
+	if (!skb_vlan_inet_prepare(skb, no_eth_encap))
+		goto drop;
+
+	old_iph = ip_hdr(skb);
+
 	info = skb_tunnel_info(skb);
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-- 
2.53.0



