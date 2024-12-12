Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3E9229665;
	Thu, 12 Dec 2024 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020740; cv=none; b=Ze9FZnhZNaawQfR9O3TWBTDAhcMp73Z4iAqUrMpsCB/S8WYdMxvNXanPVhHE2IW+vTlfs3+hKlxHTcHyzdGbikS4kQphCRAfl2QVwxmuLcrRwtat+EneFqOUtDflREhD9jFy4Y2guJdns8MMjUlgp/mrYnUdzq53hysMygQ/pLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020740; c=relaxed/simple;
	bh=RMfvk7U8uL0opvXdUvW3mGQHFUGSPuFl5nAzMMHS0nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLmn6EgfBGXh7OgJxt+4Ijw7YnQRES1WG2WvKIDd7k04nWCYuv+Ek/FoeGi/WjToPvL7I9/3Jk/MMkh3FKE9QZMCRCpjdwuj8zO4NntdBXZryuwVGO5qi2/oQy2bXLddhsyu84ULAjdXfb9CeyxP681mNU1/YnI6mH/WGh2+3Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlBiL9np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlBiL9np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E147C4CECE;
	Thu, 12 Dec 2024 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020740;
	bh=RMfvk7U8uL0opvXdUvW3mGQHFUGSPuFl5nAzMMHS0nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlBiL9npXas1PufNZELjK2GYZa9PWmfYWNqbSY2w3rP8r+bLX3Xn+6F978E6E4LX2
	 nk9CnUzYWeyVQuHIXgyxPEWEYzXvIpRdGdJf/gFvX44jGkzOkD4Q8Ij2ksm9ckOV4p
	 n5P0hWk7Fa8sos+C910nQLjERkKlecT38nIfMSz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 520/772] can: hi311x: hi3110_can_ist(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:57:45 +0100
Message-ID: <20241212144411.453922544@linuxfoundation.org>
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

[ Upstream commit 3e4645931655776e757f9fb5ae29371cd7cb21a2 ]

The hi3110_can_ist() function was incorrectly incrementing only the
receive error counter, even in cases of bit or acknowledgment errors that
occur during transmission.

The fix the issue by incrementing the appropriate counter based on the
type of error.

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-9-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 47 ++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index fb58e294f7b79..b757555ed4c4f 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -697,27 +697,38 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 			/* Check for protocol errors */
 			if (eflag & HI3110_ERR_PROTOCOL_MASK) {
 				skb = alloc_can_err_skb(net, &cf);
-				if (!skb)
-					break;
+				if (skb)
+					cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-				cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 				priv->can.can_stats.bus_error++;
-				priv->net->stats.rx_errors++;
-				if (eflag & HI3110_ERR_BITERR)
-					cf->data[2] |= CAN_ERR_PROT_BIT;
-				else if (eflag & HI3110_ERR_FRMERR)
-					cf->data[2] |= CAN_ERR_PROT_FORM;
-				else if (eflag & HI3110_ERR_STUFERR)
-					cf->data[2] |= CAN_ERR_PROT_STUFF;
-				else if (eflag & HI3110_ERR_CRCERR)
-					cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ;
-				else if (eflag & HI3110_ERR_ACKERR)
-					cf->data[3] |= CAN_ERR_PROT_LOC_ACK;
-
-				cf->data[6] = hi3110_read(spi, HI3110_READ_TEC);
-				cf->data[7] = hi3110_read(spi, HI3110_READ_REC);
+				if (eflag & HI3110_ERR_BITERR) {
+					priv->net->stats.tx_errors++;
+					if (skb)
+						cf->data[2] |= CAN_ERR_PROT_BIT;
+				} else if (eflag & HI3110_ERR_FRMERR) {
+					priv->net->stats.rx_errors++;
+					if (skb)
+						cf->data[2] |= CAN_ERR_PROT_FORM;
+				} else if (eflag & HI3110_ERR_STUFERR) {
+					priv->net->stats.rx_errors++;
+					if (skb)
+						cf->data[2] |= CAN_ERR_PROT_STUFF;
+				} else if (eflag & HI3110_ERR_CRCERR) {
+					priv->net->stats.rx_errors++;
+					if (skb)
+						cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ;
+				} else if (eflag & HI3110_ERR_ACKERR) {
+					priv->net->stats.tx_errors++;
+					if (skb)
+						cf->data[3] |= CAN_ERR_PROT_LOC_ACK;
+				}
+
 				netdev_dbg(priv->net, "Bus Error\n");
-				netif_rx(skb);
+				if (skb) {
+					cf->data[6] = hi3110_read(spi, HI3110_READ_TEC);
+					cf->data[7] = hi3110_read(spi, HI3110_READ_REC);
+					netif_rx(skb);
+				}
 			}
 		}
 
-- 
2.43.0



