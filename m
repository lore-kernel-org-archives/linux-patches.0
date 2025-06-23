Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F9915ADB4;
	Mon, 23 Jun 2025 22:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717360; cv=none; b=HRprA1+NGIccUgjXA9JeJ0jkdWPWafmqTCPEG4Y2daOO5ss39zp4T6o8dpay2URlvz4ax4ZD6axamBqfDoNnwUgCvojJwIJB61oZF7kceN4RyM9HGRvNZ6HNiSmIxlUYF5+sOKB/UwLUx08eoF6nG505mw4bRIiCdFqKeCglKpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717360; c=relaxed/simple;
	bh=r6ui5DVz54ZfUamJrWUyN1EIhUvW7OtLnukWWrmvkUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlE0c12V9+Touszc/IGTp9A6nAInsgwf6cgKaUnvus/LzTEzWOjnmDNgdCrcWbO5AjlEZu5CvbzdSU+BbAUaulv6apc9rGb9hgxNuMjEPrmeTi0OjVIuGQmwlkZsjNj1H7w307LrxBpDNCWqEawMuVnY2YTNPYbMvNxcWx/FeUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hROw3CBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hROw3CBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16863C4CEEA;
	Mon, 23 Jun 2025 22:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717360;
	bh=r6ui5DVz54ZfUamJrWUyN1EIhUvW7OtLnukWWrmvkUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hROw3CByQgDsTHLLLZuJHR5olfZmY83HHhy6GeAPMRywX4W3g1sAcDW5sGxv6u6HY
	 MYUpnV0TVxtC+oefNDSTIZijVXFz5/uK0mYTJGH3lj1ZhhGE06h52DkBJApfI5mwcY
	 no7JDxodRGnqtuzLQY7/yv4gjWOiWrSOdob5PBMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 411/508] net: vertexcom: mse102x: Return code for mse102x_rx_pkt_spi
Date: Mon, 23 Jun 2025 15:07:36 +0200
Message-ID: <20250623130655.332067460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

[ Upstream commit 4ecf56f4b66011b583644bf9a62188d05dfcd78c ]

The MSE102x doesn't provide any interrupt register, so the only way
to handle the level interrupt is to fetch the whole packet from
the MSE102x internal buffer via SPI. So in cases the interrupt
handler fails to do this, it should return IRQ_NONE. This allows
the core to disable the interrupt in case the issue persists
and prevent an interrupt storm.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20250509120435.43646-6-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 060a566bc6aae..c902f8761d5d4 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -306,7 +306,7 @@ static void mse102x_dump_packet(const char *msg, int len, const char *data)
 		       data, len, true);
 }
 
-static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
+static irqreturn_t mse102x_rx_pkt_spi(struct mse102x_net *mse)
 {
 	struct sk_buff *skb;
 	unsigned int rxalign;
@@ -327,7 +327,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 		mse102x_tx_cmd_spi(mse, CMD_CTR);
 		ret = mse102x_rx_cmd_spi(mse, (u8 *)&rx);
 		if (ret)
-			return;
+			return IRQ_NONE;
 
 		cmd_resp = be16_to_cpu(rx);
 		if ((cmd_resp & CMD_MASK) != CMD_RTS) {
@@ -360,7 +360,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 	rxalign = ALIGN(rxlen + DET_SOF_LEN + DET_DFT_LEN, 4);
 	skb = netdev_alloc_skb_ip_align(mse->ndev, rxalign);
 	if (!skb)
-		return;
+		return IRQ_NONE;
 
 	/* 2 bytes Start of frame (before ethernet header)
 	 * 2 bytes Data frame tail (after ethernet frame)
@@ -370,7 +370,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 	if (mse102x_rx_frame_spi(mse, rxpkt, rxlen, drop)) {
 		mse->ndev->stats.rx_errors++;
 		dev_kfree_skb(skb);
-		return;
+		return IRQ_HANDLED;
 	}
 
 	if (netif_msg_pktdata(mse))
@@ -381,6 +381,8 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 
 	mse->ndev->stats.rx_packets++;
 	mse->ndev->stats.rx_bytes += rxlen;
+
+	return IRQ_HANDLED;
 }
 
 static int mse102x_tx_pkt_spi(struct mse102x_net *mse, struct sk_buff *txb,
@@ -512,12 +514,13 @@ static irqreturn_t mse102x_irq(int irq, void *_mse)
 {
 	struct mse102x_net *mse = _mse;
 	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
+	irqreturn_t ret;
 
 	mutex_lock(&mses->lock);
-	mse102x_rx_pkt_spi(mse);
+	ret = mse102x_rx_pkt_spi(mse);
 	mutex_unlock(&mses->lock);
 
-	return IRQ_HANDLED;
+	return ret;
 }
 
 static int mse102x_net_open(struct net_device *ndev)
-- 
2.39.5



