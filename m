Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C182080FC;
	Thu, 12 Dec 2024 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015666; cv=none; b=TTExp6aXQoLX+sVFyzao8KgsbCaZf0Rz9F5+4nu929HJYLcFAfi8L3ei9hDxKwPyEM7yrMs8blO0xZ/icsXQSSiEhn1ECOhPZBb1XcU+aSTIKSQhNSFmUONYQZZU4Vxa7yaH173L6WRxEqdSy2sEnvYBUzpOKHTOOeE67cUEmuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015666; c=relaxed/simple;
	bh=ImPRe1eM8E1t7S99VS/r3MWLiY6MP0G2B4kT958p4g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiNOr1VHOQdYwNBS4H3vnGxUT/dtjIdDxtYJ0bXpg4UPzzfxzM7Su2eR9DkNFk5FwWsH+C2Rea+cLq6psdP7UKZG/FKac9da36xSzKBOqLqEqvL0QGRNQfv5q01+R8htaY0HiWHlVuV0AOHt1qkFlHH3ZGLv2H66fgu3pdOcrZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHid7VLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHid7VLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60B2C4CECE;
	Thu, 12 Dec 2024 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015666;
	bh=ImPRe1eM8E1t7S99VS/r3MWLiY6MP0G2B4kT958p4g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHid7VLs9g1yF1OIiEJ7IpOmyNjCx8WMiGl6RDqDDtAt22FI3aZDSnnNff9pHwTRm
	 lAQbQ+0fQQvB6urqvqB0z0xCCkRxxNnjENdZRhrszCtVxb50j0N/0EBTZ8N0wPA6ZO
	 Rn7KaDo6QIAYe+7vcfmydRO+ZBiNLn1mX4454oYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/466] can: sja1000: sja1000_err(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:53:01 +0100
Message-ID: <20241212144307.154600894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ddb3247948ad2..4d245857ef1ce 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -416,8 +416,6 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 	int ret = 0;
 
 	skb = alloc_can_err_skb(dev, &cf);
-	if (skb == NULL)
-		return -ENOMEM;
 
 	txerr = priv->read_reg(priv, SJA1000_TXERR);
 	rxerr = priv->read_reg(priv, SJA1000_RXERR);
@@ -425,8 +423,11 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
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
@@ -452,7 +453,7 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		else
 			state = CAN_STATE_ERROR_ACTIVE;
 	}
-	if (state != CAN_STATE_BUS_OFF) {
+	if (state != CAN_STATE_BUS_OFF && skb) {
 		cf->can_id |= CAN_ERR_CNT;
 		cf->data[6] = txerr;
 		cf->data[7] = rxerr;
@@ -460,33 +461,38 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
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
@@ -502,8 +508,10 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
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
@@ -516,6 +524,9 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 			can_bus_off(dev);
 	}
 
+	if (!skb)
+		return -ENOMEM;
+
 	netif_rx(skb);
 
 	return ret;
-- 
2.43.0



