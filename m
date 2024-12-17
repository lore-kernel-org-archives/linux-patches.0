Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400D414A4E7;
	Tue, 17 Dec 2024 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456227; cv=none; b=rsDUy2K5cPvHgIJUMLbCV9Y8qhArMuN/+zV1Y2Kqw56nEV/RRJTl96E0ORP/H5jfa//KA6hzJWPB543IoMoFu972uBMho605zfFqMPDqWu065HxbemxA8N4oqzgSkHl6gdgavVjyv1DBJKn0263dewNGLycNnQc5Jtnb5Xxp58o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456227; c=relaxed/simple;
	bh=weGdVn/JvOnnOkAaewpUz5QkjADs+n2bCMI9xViFmmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2J/BLaJLZAQNqMSoPb08R4Von0NnfWVne4WtAQWW7BxSLc8ifeZJZC5IuUk+V4wXM2NgFKM6B13/ifWXAlRAZKF31eC24ghZoBIQA3U5tHj+eS4WB91G8g9ys9ehKX0JOtpufklWvPj2paRMP0/6uqbtzlS2lQu8QIBX8S9Uk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIZUkQEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIZUkQEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52D8C4CED3;
	Tue, 17 Dec 2024 17:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456227;
	bh=weGdVn/JvOnnOkAaewpUz5QkjADs+n2bCMI9xViFmmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIZUkQEWjFc3FY92NPn++KDr4VuRSQWnLRLZorvGyeyUZr+D11gSnes3v3wZfFEGf
	 LgsSj4wnl2rDyDLnff1T75DAYcALC2tc2aK7wfHDxeOCSTi1yhd8REUhe+fwNrm+eT
	 ChK9KqA8ny1jolfZHhUMQgQ2bxTbkxg0H941arho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/109] net: rswitch: Add unmap_addrs instead of dma address in each desc
Date: Tue, 17 Dec 2024 18:07:55 +0100
Message-ID: <20241217170536.350896866@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

[ Upstream commit 271e015b91535dd87fd0f5df0cc3b906c2eddef9 ]

If the driver would like to transmit a jumbo frame like 2KiB or more,
it should be split into multiple queues. In the near future, to support
this, add unmap_addrs array to unmap dma mapping address instead of dma
address in each TX descriptor because the descriptors may not have
the top dma address.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0c9547e6ccf4 ("net: renesas: rswitch: fix race window between tx start and complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 19 +++++++++++--------
 drivers/net/ethernet/renesas/rswitch.h |  1 +
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 989cfc86098f..b008a44ea6ac 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -283,6 +283,8 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 		gq->tx_ring = NULL;
 		kfree(gq->skbs);
 		gq->skbs = NULL;
+		kfree(gq->unmap_addrs);
+		gq->unmap_addrs = NULL;
 	}
 }
 
@@ -321,6 +323,9 @@ static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 		gq->skbs = kcalloc(gq->ring_size, sizeof(*gq->skbs), GFP_KERNEL);
 		if (!gq->skbs)
 			return -ENOMEM;
+		gq->unmap_addrs = kcalloc(gq->ring_size, sizeof(*gq->unmap_addrs), GFP_KERNEL);
+		if (!gq->unmap_addrs)
+			goto out;
 		gq->tx_ring = dma_alloc_coherent(ndev->dev.parent,
 						 sizeof(struct rswitch_ext_desc) *
 						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
@@ -786,9 +791,7 @@ static void rswitch_tx_free(struct net_device *ndev)
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_gwca_queue *gq = rdev->tx_queue;
 	struct rswitch_ext_desc *desc;
-	dma_addr_t dma_addr;
 	struct sk_buff *skb;
-	unsigned int size;
 
 	for (; rswitch_get_num_cur_queues(gq) > 0;
 	     gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
@@ -797,18 +800,17 @@ static void rswitch_tx_free(struct net_device *ndev)
 			break;
 
 		dma_rmb();
-		size = le16_to_cpu(desc->desc.info_ds) & TX_DS;
 		skb = gq->skbs[gq->dirty];
 		if (skb) {
-			dma_addr = rswitch_desc_get_dptr(&desc->desc);
-			dma_unmap_single(ndev->dev.parent, dma_addr,
-					 size, DMA_TO_DEVICE);
+			dma_unmap_single(ndev->dev.parent,
+					 gq->unmap_addrs[gq->dirty],
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(gq->skbs[gq->dirty]);
 			gq->skbs[gq->dirty] = NULL;
+			rdev->ndev->stats.tx_packets++;
+			rdev->ndev->stats.tx_bytes += skb->len;
 		}
 		desc->desc.die_dt = DT_EEMPTY;
-		rdev->ndev->stats.tx_packets++;
-		rdev->ndev->stats.tx_bytes += size;
 	}
 }
 
@@ -1535,6 +1537,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 		goto err_kfree;
 
 	gq->skbs[gq->cur] = skb;
+	gq->unmap_addrs[gq->cur] = dma_addr;
 	desc = &gq->tx_ring[gq->cur];
 	rswitch_desc_set_dptr(&desc->desc, dma_addr);
 	desc->desc.info_ds = cpu_to_le16(skb->len);
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index e62c28a442b9..327873b637d7 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -956,6 +956,7 @@ struct rswitch_gwca_queue {
 		/* For TX */
 		struct {
 			struct sk_buff **skbs;
+			dma_addr_t *unmap_addrs;
 		};
 		/* For RX */
 		struct {
-- 
2.39.5



