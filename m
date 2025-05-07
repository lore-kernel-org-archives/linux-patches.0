Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282D9214813;
	Wed,  7 May 2025 18:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644282; cv=none; b=Yz9jfJH4CIkeOjpOhBKa65XOihQgcpNiBY8PJ50L4TVZ8HGaPcF/9MtxFdXXmnw+1DXyAalzjA+bDLfdTzVPgurcRFd6y9rfwT+HNyCsFjix4+SnaJFHb6fSfu/Db2VyOJPPgdOOwRR3TGDTfTlm4Nt4BAyUry3O2baoiW7if28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644282; c=relaxed/simple;
	bh=+DtuhmdZ5sYHQ75kLWdnKZBqIbouvje/vk00aUA3ZLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdcTS18JThpXSpP+IH+MsBBwlA6GfJQS0n1ZSb7YhhzrqYT7grXRAQ2nyjbGtap7UIHn4jphdaXgK/et4gWcUgvreJhJ/oFU+1NmCwmNlr2yCUEGstQryoP9RHblpUHcAf3jxwD7/OVJY/Xj4Qp/q8cBw7EeZda0A2ad5rqUlaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmk9EYt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmk9EYt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3767FC4CEE2;
	Wed,  7 May 2025 18:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644281;
	bh=+DtuhmdZ5sYHQ75kLWdnKZBqIbouvje/vk00aUA3ZLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmk9EYt2qDC9ZGUpHtWUAoyIubCynrd9EsA6BD4JE/S68TGhzFbZ52cALNK0Coq6E
	 YSXaElqBt212Wb+31StLswWyGD/1xiMVTnh3Viv8sy2ytmaM+23pGM8q+gWnoxQwlK
	 onQZ2k87fC2XGR8P5byHrqWlotTkTxC+kdmngfOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 147/183] net: vertexcom: mse102x: Fix RX error handling
Date: Wed,  7 May 2025 20:39:52 +0200
Message-ID: <20250507183830.822499153@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 2c06d1d05164f..e4d993f313740 100644
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



