Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216C22A7F9;
	Thu, 12 Dec 2024 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020756; cv=none; b=miVstQxhN0V+Nk07jEG7M+mZwAp2X3HACLeuhZvarwVG4nRraIHlSGWdbQ3lB/9/NuXfCDrkpeTCmafT9xkbDBgeJmXe/jUXQ3RG1VaS58s2zJiTpw2bifZPU/RPv4zyn6DT4GYFDltTTZLXF+BU7n4byfg7T7rSUGWesn9vzms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020756; c=relaxed/simple;
	bh=ndsjjU1oKHfrVk3TwVlSFqUnU2BXIvBTswpQ1bLsg7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2xXSNjK+DBnOcJypkybN9SkQ7DzePmFdvNwnwpW0ZlhWc1anfb2UzrWS4oOpkmP2L86QQJqm6l78Xd9XIjhQkvpkUQVxDWhGH53c1rqMs07Vd0vB0VH1m5dWIDkQhy3Tc6XEOu/bLUlj0QZeUMTl7/iCcVF5hFa6P+sK4E3x/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJg5vS9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJg5vS9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4705FC4CECE;
	Thu, 12 Dec 2024 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020755;
	bh=ndsjjU1oKHfrVk3TwVlSFqUnU2BXIvBTswpQ1bLsg7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJg5vS9Ska6GgGHXVXMPzR45vC78FaZtNyGI+7hI1YhffwZG3o1kSXx2Df4r5NYu/
	 TfJ8JYZ8YPJAPg/ZbuStVlN1K64AHCxZgtB/UATV4q+uB0WxPTIXHHTGiyZNQtvl8J
	 Nr0oRn5dF31tTe8HOfhkTm0EdJiC1pIBCelXFK/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 522/772] can: sun4i_can: sun4i_can_err(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:57:47 +0100
Message-ID: <20241212144411.533440591@linuxfoundation.org>
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

[ Upstream commit 595a81988a6fe06eb5849e972c8b9cb21c4e0d54 ]

The sun4i_can_err() function only incremented the receive error counter
and never the transmit error counter, even if the STA_ERR_DIR flag
reported that an error had occurred during transmission.

Increment the receive/transmit error counter based on the value of the
STA_ERR_DIR flag.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-11-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sun4i_can.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 6bf721eda65d2..4bec1e7e7b3e3 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -580,11 +580,9 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 		/* bus error interrupt */
 		netdev_dbg(dev, "bus error interrupt\n");
 		priv->can.can_stats.bus_error++;
-		stats->rx_errors++;
+		ecc = readl(priv->base + SUN4I_REG_STA_ADDR);
 
 		if (likely(skb)) {
-			ecc = readl(priv->base + SUN4I_REG_STA_ADDR);
-
 			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 			switch (ecc & SUN4I_STA_MASK_ERR) {
@@ -602,9 +600,15 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 					       >> 16;
 				break;
 			}
-			/* error occurred during transmission? */
-			if ((ecc & SUN4I_STA_ERR_DIR) == 0)
+		}
+
+		/* error occurred during transmission? */
+		if ((ecc & SUN4I_STA_ERR_DIR) == 0) {
+			if (likely(skb))
 				cf->data[2] |= CAN_ERR_PROT_TX;
+			stats->tx_errors++;
+		} else {
+			stats->rx_errors++;
 		}
 	}
 	if (isrc & SUN4I_INT_ERR_PASSIVE) {
-- 
2.43.0



