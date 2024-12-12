Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6E422A7F0;
	Thu, 12 Dec 2024 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020752; cv=none; b=lxUPMmubzxR7tCLsettcQ2KZzrEpaBfn9InkQHVd9+E34runw6+zFQl1dLIc3MVs42oX4Uo0ajahkiCDUV1gGSOERqvWKqSQcQRHXsH6MvpGGDmswbp9tZqYV/Q6c2A/prRgrG2bXc6sEtLPEwPD5DAWIDh18BX51aWhcOeycP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020752; c=relaxed/simple;
	bh=pkEdl3NmVHsUSpgNTh1A+8wyc8aYE3nj/iEcECK1lkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBp645RJnrZ0nptyfgD2PTxj16yUJ4+p0D98RMuH5mFK62jr36V+EjO//i6E6OD3FxGdndB5IuNUNhBkWhUyqP98G19w4L7cdQFdSyPQHu3io9ykFWYvT8XaV1nbN5Z6L66VQVXML25dL89RNGIAFvY/3mDQCQpYqg8t23oCUlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1ezf3iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1ezf3iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45876C4CED3;
	Thu, 12 Dec 2024 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020751;
	bh=pkEdl3NmVHsUSpgNTh1A+8wyc8aYE3nj/iEcECK1lkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1ezf3ivmNPBFouitlyPlcdg9EQoTATfulAd9AcAUVR0gXcQshQ/CpHwfg5bhgea+
	 6AI6F0wZOSb8LywMm47OT0QHPZDVc8r33ofQkPfqtdb5n13LsXQk3AbLqPv5Zj9/hj
	 f7MgvnXC0ytzn3syFq08LbBOd8cwlzCP+T6kzBcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 521/772] can: sja1000: sja1000_err(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:57:46 +0100
Message-ID: <20241212144411.494298098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 2c4ef3af4b028a0eaaf378df511d3b425b1df61f ]

The sja1000_err() function only incremented the receive error counter
and never the transmit error counter, even if the ECC_DIR flag reported
that an error had occurred during transmission.

Increment the receive/transmit error counter based on the value of the
ECC_DIR flag.

Fixes: 429da1cc841b ("can: Driver for the SJA1000 CAN controller")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-10-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/sja1000.c | 67 ++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index aac5956e4a532..26ec3c4e41100 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -399,8 +399,6 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 	uint8_t ecc, alc;
 
 	skb = alloc_can_err_skb(dev, &cf);
-	if (skb == NULL)
-		return -ENOMEM;
 
 	txerr = priv->read_reg(priv, SJA1000_TXERR);
 	rxerr = priv->read_reg(priv, SJA1000_RXERR);
@@ -408,8 +406,11 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 	if (isrc & IRQ_DOI) {
 		/* data overrun interrupt */
 		netdev_dbg(dev, "data overrun interrupt\n");
-		cf->can_id |= CAN_ERR_CRTL;
-		cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+		if (skb) {
+			cf->can_id |= CAN_ERR_CRTL;
+			cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+		}
+
 		stats->rx_over_errors++;
 		stats->rx_errors++;
 		sja1000_write_cmdreg(priv, CMD_CDO);	/* clear bit */
@@ -426,7 +427,7 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		else
 			state = CAN_STATE_ERROR_ACTIVE;
 	}
-	if (state != CAN_STATE_BUS_OFF) {
+	if (state != CAN_STATE_BUS_OFF && skb) {
 		cf->can_id |= CAN_ERR_CNT;
 		cf->data[6] = txerr;
 		cf->data[7] = rxerr;
@@ -434,33 +435,38 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 	if (isrc & IRQ_BEI) {
 		/* bus error interrupt */
 		priv->can.can_stats.bus_error++;
-		stats->rx_errors++;
 
 		ecc = priv->read_reg(priv, SJA1000_ECC);
+		if (skb) {
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
-
-		/* set error type */
-		switch (ecc & ECC_MASK) {
-		case ECC_BIT:
-			cf->data[2] |= CAN_ERR_PROT_BIT;
-			break;
-		case ECC_FORM:
-			cf->data[2] |= CAN_ERR_PROT_FORM;
-			break;
-		case ECC_STUFF:
-			cf->data[2] |= CAN_ERR_PROT_STUFF;
-			break;
-		default:
-			break;
-		}
+			/* set error type */
+			switch (ecc & ECC_MASK) {
+			case ECC_BIT:
+				cf->data[2] |= CAN_ERR_PROT_BIT;
+				break;
+			case ECC_FORM:
+				cf->data[2] |= CAN_ERR_PROT_FORM;
+				break;
+			case ECC_STUFF:
+				cf->data[2] |= CAN_ERR_PROT_STUFF;
+				break;
+			default:
+				break;
+			}
 
-		/* set error location */
-		cf->data[3] = ecc & ECC_SEG;
+			/* set error location */
+			cf->data[3] = ecc & ECC_SEG;
+		}
 
 		/* Error occurred during transmission? */
-		if ((ecc & ECC_DIR) == 0)
-			cf->data[2] |= CAN_ERR_PROT_TX;
+		if ((ecc & ECC_DIR) == 0) {
+			stats->tx_errors++;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_TX;
+		} else {
+			stats->rx_errors++;
+		}
 	}
 	if (isrc & IRQ_EPI) {
 		/* error passive interrupt */
@@ -476,8 +482,10 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		netdev_dbg(dev, "arbitration lost interrupt\n");
 		alc = priv->read_reg(priv, SJA1000_ALC);
 		priv->can.can_stats.arbitration_lost++;
-		cf->can_id |= CAN_ERR_LOSTARB;
-		cf->data[0] = alc & 0x1f;
+		if (skb) {
+			cf->can_id |= CAN_ERR_LOSTARB;
+			cf->data[0] = alc & 0x1f;
+		}
 	}
 
 	if (state != priv->can.state) {
@@ -490,6 +498,9 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 			can_bus_off(dev);
 	}
 
+	if (!skb)
+		return -ENOMEM;
+
 	netif_rx(skb);
 
 	return 0;
-- 
2.43.0



