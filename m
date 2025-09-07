Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F4E1CDFAC;
	Sun,  7 Sep 2025 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275952; cv=none; b=Zk+xV+6Eo5oXD92/Y+LYtGCEcvj3VWcz901EghtoQp0bB9JQtUoF8AyXMLYbNYeEn9h9CSNhVDcNC6LUt1K5jX3emkz9MKHrEK5NmHjfgWdlvh9n7H2ui75K+RzTVwIbjRLdGuRSRAELG+rfoMbCyIF8OZz+dxuhfiPyVgskxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275952; c=relaxed/simple;
	bh=gWYuooB2mcUaiQJ5UWCvyxpNlNxCs/c2nKRPDaHcHYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEC5SjsaXcEyxGObGvOJOvA8/bCeSckakURquy4b4dcpDPQg/YBxtqjxlMS5aKN8jJQdwF6bkrzrT+42GBd3cnaGrxRaWco7Of1WM2Cen8hS7U9HCFfUhWoy8rIajZk6ZvACcRwYLvWqx2xsBELhYcyVjCy81gF5Tbo6GplVs8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb4gVz1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb4gVz1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3B9C4CEF0;
	Sun,  7 Sep 2025 20:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275952;
	bh=gWYuooB2mcUaiQJ5UWCvyxpNlNxCs/c2nKRPDaHcHYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb4gVz1Yqa0xc872rz1WxhQwpy0gt2ncD2A6LF7GjdDLNXEI2rPf1F+kHY7dY5Ldz
	 f2GUeAzZ93ImpEbZB5qsVhlGEshP0QGyEGVPVuoK3qOi/nFg1EhzFFBu9rJpAd/rXH
	 cVn4AKbx9d+DCyzzm/RDneyNG0h9y5RoMCdpuoGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thibaut VARENE <hacks@slashdirt.org>,
	Felix Fietkau <nbd@nbd.name>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/64] net: ethernet: mtk_eth_soc: fix tx vlan tag for llc packets
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195603.877601842@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d4736737110ffa83d29f1c5d17b26113864205f6 ]

When sending llc packets with vlan tx offload, the hardware fails to
actually add the tag. Deal with this by fixing it up in software.

Fixes: 656e705243fd ("net-next: mediatek: add support for MT7623 ethernet")
Reported-by: Thibaut VARENE <hacks@slashdirt.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250831182007.51619-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 711acc6059a4f..4d7a72bcee614 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1196,6 +1196,13 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool gso = false;
 	int tx_num;
 
+	if (skb_vlan_tag_present(skb) &&
+	    !eth_proto_is_802_3(eth_hdr(skb)->h_proto)) {
+		skb = __vlan_hwaccel_push_inside(skb);
+		if (!skb)
+			goto dropped;
+	}
+
 	/* normally we can rely on the stack not calling this more than once,
 	 * however we have 2 queues running on the same ring so we need to lock
 	 * the ring access
@@ -1241,8 +1248,9 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 drop:
 	spin_unlock(&eth->page_lock);
-	stats->tx_dropped++;
 	dev_kfree_skb_any(skb);
+dropped:
+	stats->tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
-- 
2.50.1



