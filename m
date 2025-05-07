Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A0273451;
	Wed,  7 May 2025 18:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643650; cv=none; b=eJig6px8ojgpECRLHD6vYV8RK0E4dCApuPseXb92vxprO2oHeZGOfA+rhA5tVRJhMpvVZGsEbBQEy4gPDoU8FiRH9X+wc8DqCBXp3VEAnJYwwHZ75cE0faJoWL/w3xZ8fvH9ZVLL2w72ruyqdGlYByTbgSlLkujmLAtRrJiaMOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643650; c=relaxed/simple;
	bh=AH+NJ0Mq8no7ZhlqiIsmz2OiwFzPIVFk1GdwNTCzlJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7nm5vkusPcJr3CGNhVeTjWSBkhPl0/hrdy+rsGAXk0dudtIXN++Um6U48H59R0htdwGfEYaI3RDfgtfKo5wb+17Q4bheb+tTDUzYaGxEHiOJnUHQPJDbNLJEe/LS+gHpGPATyP2b5ttAj+Xrslg9wA17Aw90FWk8Lw1Vr6nka0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVfFHvul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVfFHvul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0021C4CEE2;
	Wed,  7 May 2025 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643650;
	bh=AH+NJ0Mq8no7ZhlqiIsmz2OiwFzPIVFk1GdwNTCzlJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVfFHvuld5aXgiB4w7nrfy+Nce+ejxov5TRjfg3t18+jnPt45KYN6xbh5bmtcag4H
	 x8VE9hMi0/LuqPKgX7fVE7aCwBSvXYftobT0yRCMXUazsOjDXw+HWXmuq0ANwa9hk2
	 k/jP8IxTr/11CZBXQ3hL9krfm46xLkIAF/SPfvVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 71/97] net: vertexcom: mse102x: Fix RX error handling
Date: Wed,  7 May 2025 20:39:46 +0200
Message-ID: <20250507183809.847788223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit ee512922ddd7d64afe2b28830a88f19063217649 ]

In case the CMD_RTS got corrupted by interferences, the MSE102x
doesn't allow a retransmission of the command. Instead the Ethernet
frame must be shifted out of the SPI FIFO. Since the actual length is
unknown, assume the maximum possible value.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-5-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 2b1aac72601d0..060a566bc6aae 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -263,7 +263,7 @@ static int mse102x_tx_frame_spi(struct mse102x_net *mse, struct sk_buff *txp,
 }
 
 static int mse102x_rx_frame_spi(struct mse102x_net *mse, u8 *buff,
-				unsigned int frame_len)
+				unsigned int frame_len, bool drop)
 {
 	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
 	struct spi_transfer *xfer = &mses->spi_xfer;
@@ -281,6 +281,9 @@ static int mse102x_rx_frame_spi(struct mse102x_net *mse, u8 *buff,
 		netdev_err(mse->ndev, "%s: spi_sync() failed: %d\n",
 			   __func__, ret);
 		mse->stats.xfer_err++;
+	} else if (drop) {
+		netdev_dbg(mse->ndev, "%s: Drop frame\n", __func__);
+		ret = -EINVAL;
 	} else if (*sof != cpu_to_be16(DET_SOF)) {
 		netdev_dbg(mse->ndev, "%s: SPI start of frame is invalid (0x%04x)\n",
 			   __func__, *sof);
@@ -308,6 +311,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 	struct sk_buff *skb;
 	unsigned int rxalign;
 	unsigned int rxlen;
+	bool drop = false;
 	__be16 rx = 0;
 	u16 cmd_resp;
 	u8 *rxpkt;
@@ -330,7 +334,8 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 			net_dbg_ratelimited("%s: Unexpected response (0x%04x)\n",
 					    __func__, cmd_resp);
 			mse->stats.invalid_rts++;
-			return;
+			drop = true;
+			goto drop;
 		}
 
 		net_dbg_ratelimited("%s: Unexpected response to first CMD\n",
@@ -342,9 +347,16 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 		net_dbg_ratelimited("%s: Invalid frame length: %d\n", __func__,
 				    rxlen);
 		mse->stats.invalid_len++;
-		return;
+		drop = true;
 	}
 
+	/* In case of a invalid CMD_RTS, the frame must be consumed anyway.
+	 * So assume the maximum possible frame length.
+	 */
+drop:
+	if (drop)
+		rxlen = VLAN_ETH_FRAME_LEN;
+
 	rxalign = ALIGN(rxlen + DET_SOF_LEN + DET_DFT_LEN, 4);
 	skb = netdev_alloc_skb_ip_align(mse->ndev, rxalign);
 	if (!skb)
@@ -355,7 +367,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 	 * They are copied, but ignored.
 	 */
 	rxpkt = skb_put(skb, rxlen) - DET_SOF_LEN;
-	if (mse102x_rx_frame_spi(mse, rxpkt, rxlen)) {
+	if (mse102x_rx_frame_spi(mse, rxpkt, rxlen, drop)) {
 		mse->ndev->stats.rx_errors++;
 		dev_kfree_skb(skb);
 		return;
-- 
2.39.5



