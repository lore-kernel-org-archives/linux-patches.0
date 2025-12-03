Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D409341079;
	Wed,  3 Dec 2025 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777429; cv=none; b=N85gq8Y23ISrChQf/nT+T6fFhnzLcdayPdUL4uC9RlAj1RQsQ6fM555NtWdgv6XYdSq3HXAU7bXR7GW5SJd42zycYbCEGnxntXRQ+bcl8eD8On+UO+vp14qo9ogC5324oWngEk7hTNB3k9FMcG6vaLDulWPj4gHiGFTF4zr9Umw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777429; c=relaxed/simple;
	bh=7GwigojykEHuVa85eHpcBqAgIM6TI8XKGtUEklisDmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPlS/OPc8J57b0aq2zQ6YWxat0Kp6mWDj8LzHpjehXptM0g8wSsTQO+N2YpNL05ElHJ0BATofYYiOpPM2RN0Za9zlJNHGKPpm7zFdrkQXEdsi45kMt6BIsA+r+h4onE02q5FWWbka8ujtaFx7ekmAO3CTC+pSmojhk+cxNce7Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlLmjYIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlLmjYIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD07C4CEF5;
	Wed,  3 Dec 2025 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777429;
	bh=7GwigojykEHuVa85eHpcBqAgIM6TI8XKGtUEklisDmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlLmjYIlg8Ko7TEnTed7UumGGTBm2lz+w/olY56rFeWEQk/vIe3JkCur4LgVBMifZ
	 dYnCREITH4XECzJ6HZF9PVCrxVs8+7oZDwL6G68yYvaW/S3TdWmUjrrk3vl877aX8j
	 5T8ozf6wtufAGrkAeqOLPYyBzNgsyGuvMmdbnQe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/392] ravb: Exclude gPTP feature support for RZ/G2L
Date: Wed,  3 Dec 2025 16:23:05 +0100
Message-ID: <20251203152415.394124573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 7e09a052dc4e30ce07fd7b3aa58a7d993f73a9d7 ]

R-Car supports gPTP feature whereas RZ/G2L does not support it.
This patch excludes gtp feature support for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5370c31e84b0 ("net: ravb: Enforce descriptor type ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb_main.c |   87 +++++++++++++++++--------------
 1 file changed, 50 insertions(+), 37 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1321,6 +1321,7 @@ static int ravb_get_ts_info(struct net_d
 			    struct ethtool_ts_info *info)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *hw_info = priv->info;
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_SOFTWARE |
@@ -1334,7 +1335,8 @@ static int ravb_get_ts_info(struct net_d
 		(1 << HWTSTAMP_FILTER_NONE) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 		(1 << HWTSTAMP_FILTER_ALL);
-	info->phc_index = ptp_clock_index(priv->ptp.clock);
+	if (hw_info->gptp || hw_info->ccc_gac)
+		info->phc_index = ptp_clock_index(priv->ptp.clock);
 
 	return 0;
 }
@@ -1565,6 +1567,7 @@ out_unlock:
 static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	unsigned int num_tx_desc = priv->num_tx_desc;
 	u16 q = skb_get_queue_mapping(skb);
 	struct ravb_tstamp_skb *ts_skb;
@@ -1641,28 +1644,30 @@ static netdev_tx_t ravb_start_xmit(struc
 	desc->dptr = cpu_to_le32(dma_addr);
 
 	/* TX timestamp required */
-	if (q == RAVB_NC) {
-		ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
-		if (!ts_skb) {
-			if (num_tx_desc > 1) {
-				desc--;
-				dma_unmap_single(ndev->dev.parent, dma_addr,
-						 len, DMA_TO_DEVICE);
+	if (info->gptp || info->ccc_gac) {
+		if (q == RAVB_NC) {
+			ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
+			if (!ts_skb) {
+				if (num_tx_desc > 1) {
+					desc--;
+					dma_unmap_single(ndev->dev.parent, dma_addr,
+							 len, DMA_TO_DEVICE);
+				}
+				goto unmap;
 			}
-			goto unmap;
+			ts_skb->skb = skb_get(skb);
+			ts_skb->tag = priv->ts_skb_tag++;
+			priv->ts_skb_tag &= 0x3ff;
+			list_add_tail(&ts_skb->list, &priv->ts_skb_list);
+
+			/* TAG and timestamp required flag */
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
+			desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
 		}
-		ts_skb->skb = skb_get(skb);
-		ts_skb->tag = priv->ts_skb_tag++;
-		priv->ts_skb_tag &= 0x3ff;
-		list_add_tail(&ts_skb->list, &priv->ts_skb_list);
-
-		/* TAG and timestamp required flag */
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
-		desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
-	}
 
-	skb_tx_timestamp(skb);
+		skb_tx_timestamp(skb);
+	}
 	/* Descriptor type must be set after all the above writes */
 	dma_wmb();
 	if (num_tx_desc > 1) {
@@ -1781,10 +1786,12 @@ static int ravb_close(struct net_device
 			   "device will be stopped after h/w processes are done.\n");
 
 	/* Clear the timestamp list */
-	list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
-		list_del(&ts_skb->list);
-		kfree_skb(ts_skb->skb);
-		kfree(ts_skb);
+	if (info->gptp || info->ccc_gac) {
+		list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
+			list_del(&ts_skb->list);
+			kfree_skb(ts_skb->skb);
+			kfree(ts_skb);
+		}
 	}
 
 	/* PHY disconnect */
@@ -2116,9 +2123,11 @@ static void ravb_set_config_mode(struct
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
-	} else {
+	} else if (info->ccc_gac) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG |
 			    CCC_GAC | CCC_CSEL_HPB);
+	} else {
+		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 	}
 }
 
@@ -2306,13 +2315,15 @@ static int ravb_probe(struct platform_de
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	error = ravb_set_gti(ndev);
-	if (error)
-		goto out_disable_refclk;
+	if (info->gptp || info->ccc_gac) {
+		/* Set GTI value */
+		error = ravb_set_gti(ndev);
+		if (error)
+			goto out_disable_refclk;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (info->internal_delay) {
 		ravb_parse_delay_mode(np, ndev);
@@ -2509,13 +2520,15 @@ static int __maybe_unused ravb_resume(st
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	ret = ravb_set_gti(ndev);
-	if (ret)
-		return ret;
+	if (info->gptp || info->ccc_gac) {
+		/* Set GTI value */
+		ret = ravb_set_gti(ndev);
+		if (ret)
+			return ret;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (info->internal_delay)
 		ravb_set_delay_mode(ndev);


