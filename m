Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796F879F2;
	Tue,  5 Dec 2023 03:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL8qWE0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB935C433C7;
	Tue,  5 Dec 2023 03:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746652;
	bh=s34zcpHh/y/duxlwENANycMnpQvSr9o4CzwiEeCkz+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL8qWE0jw2McQ4VNovCqyavqgHFjcM8sm1tMAXW1k93jk9WddmN992w3VjFBxAZHV
	 1wyOwvtoXYtYzfrDU+qdRlFofqneWwnkvbITNLtPHf1lGn8NGiFfJY82RZ7eX5eJQ4
	 HEBmHnSriYm1/OVgMVLdfQXk2Ju0wOlMvpPn9DAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/134] net: rswitch: Fix missing dev_kfree_skb_any() in error path
Date: Tue,  5 Dec 2023 12:15:53 +0900
Message-ID: <20231205031540.604892731@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 782486af9b5b76493012711413c141509ac45dec ]

Before returning the rswitch_start_xmit() in the error path,
dev_kfree_skb_any() should be called. So, fix it.

Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 3ccf93184c9b2..ae9d8722b76f7 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1514,10 +1514,8 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 		return ret;
 
 	dma_addr = dma_map_single(ndev->dev.parent, skb->data, skb->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(ndev->dev.parent, dma_addr)) {
-		dev_kfree_skb_any(skb);
-		return ret;
-	}
+	if (dma_mapping_error(ndev->dev.parent, dma_addr))
+		goto err_kfree;
 
 	gq->skbs[gq->cur] = skb;
 	desc = &gq->tx_ring[gq->cur];
@@ -1530,10 +1528,8 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 		struct rswitch_gwca_ts_info *ts_info;
 
 		ts_info = kzalloc(sizeof(*ts_info), GFP_ATOMIC);
-		if (!ts_info) {
-			dma_unmap_single(ndev->dev.parent, dma_addr, skb->len, DMA_TO_DEVICE);
-			return ret;
-		}
+		if (!ts_info)
+			goto err_unmap;
 
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		rdev->ts_tag++;
@@ -1555,6 +1551,14 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	gq->cur = rswitch_next_queue_index(gq, true, 1);
 	rswitch_modify(rdev->addr, GWTRC(gq->index), 0, BIT(gq->index % 32));
 
+	return ret;
+
+err_unmap:
+	dma_unmap_single(ndev->dev.parent, dma_addr, skb->len, DMA_TO_DEVICE);
+
+err_kfree:
+	dev_kfree_skb_any(skb);
+
 	return ret;
 }
 
-- 
2.42.0



