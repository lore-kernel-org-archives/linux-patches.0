Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB77717DFFD;
	Fri, 15 Nov 2024 06:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653712; cv=none; b=YgKqy7QcIgBt/i/WKyEJ3Qu6GjJ81H6HUX6cUTC2EU0KgT3uMWrwr/E4lZeRDMjcrlfonHYY2y6JcgDJ0IW165EB7g4oQxi/ZtDats3a6bOAinjOt1I8uukoHdZQrwSHo1f01/rd3DxIxz6sO5prgpwHaVndBA/bL7q2YpeduvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653712; c=relaxed/simple;
	bh=0ZvqN8e+QyS/VGAW9e3Zn+1v6Y9TiXAXXRp55HlbsF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do8u+vEDwD8H0e5XVJs9GyBTDToiwlSlYJYJGPJv/+x84gl6dHHAVcb5gas+J0OyaUB16FDPfO9FH5nN6w8uBjJNMe6Dznf2PR+A1eRri0syFyTTRSAWzlIbcEfhf5K+xKvUfS9S7hRiHEDd7PdKtRA6slpVA9pTsAhj53RRXs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKDt+ham; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKDt+ham"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F207C4CECF;
	Fri, 15 Nov 2024 06:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653712;
	bh=0ZvqN8e+QyS/VGAW9e3Zn+1v6Y9TiXAXXRp55HlbsF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKDt+hamWa+49VZ/g83fd29L7QsKGSxoLfnydGrJ5T6n4fFHYZSrvhZPh8mPQdj26
	 EEwmyYp9MFIE4fWJ7h0W/x8kSDAiPlGuwGkywsc0C1r3kqvX7CY6LXoS0OIoz8igNM
	 bM9WwR2sJxGslcuPloswgzBIs3hBp/10VQrLo/rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/82] can: c_can: fix {rx,tx}_errors statistics
Date: Fri, 15 Nov 2024 07:37:52 +0100
Message-ID: <20241115063726.113995449@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 4d6d26537940f3b3e17138987ed9e4a334780bf7 ]

The c_can_handle_bus_err() function was incorrectly incrementing only the
receive error counter, even in cases of bit or acknowledgment errors that
occur during transmission. The patch fixes the issue by incrementing the
appropriate counter based on the type of error.

Fixes: 881ff67ad450 ("can: c_can: Added support for Bosch C_CAN controller")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241014135319.2009782-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 6c75e5897620d..6cdb28f1f2e23 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -992,7 +992,6 @@ static int c_can_handle_bus_err(struct net_device *dev,
 
 	/* common for all type of bus errors */
 	priv->can.can_stats.bus_error++;
-	stats->rx_errors++;
 
 	/* propagate the error condition to the CAN stack */
 	skb = alloc_can_err_skb(dev, &cf);
@@ -1009,26 +1008,32 @@ static int c_can_handle_bus_err(struct net_device *dev,
 	case LEC_STUFF_ERROR:
 		netdev_dbg(dev, "stuff error\n");
 		cf->data[2] |= CAN_ERR_PROT_STUFF;
+		stats->rx_errors++;
 		break;
 	case LEC_FORM_ERROR:
 		netdev_dbg(dev, "form error\n");
 		cf->data[2] |= CAN_ERR_PROT_FORM;
+		stats->rx_errors++;
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
 		cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+		stats->tx_errors++;
 		break;
 	case LEC_BIT1_ERROR:
 		netdev_dbg(dev, "bit1 error\n");
 		cf->data[2] |= CAN_ERR_PROT_BIT1;
+		stats->tx_errors++;
 		break;
 	case LEC_BIT0_ERROR:
 		netdev_dbg(dev, "bit0 error\n");
 		cf->data[2] |= CAN_ERR_PROT_BIT0;
+		stats->tx_errors++;
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
 		cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+		stats->rx_errors++;
 		break;
 	default:
 		break;
-- 
2.43.0



