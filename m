Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92B820B3E;
	Tue, 23 Apr 2024 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908481; cv=none; b=MNRptV4C2bLHH1i3jh1INX27cuVxfVVJnK2dsG/tRg/d6kpoY+GAhshuCZir1LQ3WA3tHx4j22A7fzxKF+2JCd0noPkdPFKFxlf07Vq2EHc7sMoVK5tNmPkyVHUI1yrJA2YPOWiBX1s2vXKCkBKurc6UvO+IcQjSeibKB7TO7Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908481; c=relaxed/simple;
	bh=rh0EPYZYL7MHCpy9Z2Z2MiqnZU5m1v4BJKtvespapMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDzjeYU5g8Ct0H0iAHVUdILQpEGJRROpMAiPQeg5m6efWP6ln72DS+OyRtx1r32pVd9M2lnUy0bcR0mghPA0Toii/1qS6d8gioo4ofiUUWcAdlvl0tBdScL0nsAW5F1d5zymugXG2xkCMYYVVsMtUX9CXutPIPcbTm3P0UheHrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlJ+guMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlJ+guMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F073C32781;
	Tue, 23 Apr 2024 21:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908481;
	bh=rh0EPYZYL7MHCpy9Z2Z2MiqnZU5m1v4BJKtvespapMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlJ+guMz2PciBZzkF7XWDwqXIHt9/aOyabRNm9U1eibWpctvXiwp1fwjls/NOoYTZ
	 SVSVYc5nDHCMhOM0w7mU3dXFx3FGv4ZTNwL1HiKQRDW+KMgdVVt3t+AH0TkzhnKyAy
	 CseWAunZHEXZGq83kR/hycEjLzhbI0eB71EOtgSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 051/158] net: ravb: Count packets instead of descriptors in R-Car RX path
Date: Tue, 23 Apr 2024 14:37:53 -0700
Message-ID: <20240423213857.577261381@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit def52db470df28d6f43cacbd21137f03b9502073 ]

The units of "work done" in the RX path should be packets instead of
descriptors.

Descriptors which are used by the hardware to record error conditions or
are empty in the case of a DMA mapping error should not count towards
our RX work budget.

Also make the limit variable unsigned as it can never be negative.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e97c98d5eb19c..60c1cfc501304 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -895,29 +895,24 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
-	int boguscnt = (priv->dirty_rx[q] + priv->num_rx_ring[q]) -
-			priv->cur_rx[q];
 	struct net_device_stats *stats = &priv->stats[q];
 	struct ravb_ex_rx_desc *desc;
+	unsigned int limit, i;
 	struct sk_buff *skb;
 	dma_addr_t dma_addr;
 	struct timespec64 ts;
+	int rx_packets = 0;
 	u8  desc_status;
 	u16 pkt_len;
-	int limit;
 
-	boguscnt = min(boguscnt, *quota);
-	limit = boguscnt;
+	limit = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
 	desc = &priv->rx_ring[q].ex_desc[entry];
-	while (desc->die_dt != DT_FEMPTY) {
+	for (i = 0; i < limit && rx_packets < *quota && desc->die_dt != DT_FEMPTY; i++) {
 		/* Descriptor type must be checked before all other reads */
 		dma_rmb();
 		desc_status = desc->msc;
 		pkt_len = le16_to_cpu(desc->ds_cc) & RX_DS;
 
-		if (--boguscnt < 0)
-			break;
-
 		/* We use 0-byte descriptors to mark the DMA mapping errors */
 		if (!pkt_len)
 			continue;
@@ -963,7 +958,7 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 			if (ndev->features & NETIF_F_RXCSUM)
 				ravb_rx_csum(skb);
 			napi_gro_receive(&priv->napi[q], skb);
-			stats->rx_packets++;
+			rx_packets++;
 			stats->rx_bytes += pkt_len;
 		}
 
@@ -999,9 +994,9 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 		desc->die_dt = DT_FEMPTY;
 	}
 
-	*quota -= limit - (++boguscnt);
-
-	return boguscnt <= 0;
+	stats->rx_packets += rx_packets;
+	*quota -= rx_packets;
+	return *quota == 0;
 }
 
 /* Packet receive function for Ethernet AVB */
-- 
2.43.0



