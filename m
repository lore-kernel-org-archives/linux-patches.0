Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907E41F09A5;
	Sun,  7 Sep 2025 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275760; cv=none; b=oEld03ZM2kyNMtPLKL6blZ1IRL9Nt4DYL/SdWA7HeffzOAB918NLKJPOEM0forGRs7IpZ1+uWlNzQYNwOaXLaDLZBm06tT2KV4ZOIpKF/9X94d3j/ay2hulqLTxjOXOLoCkjiK4Dik3yoLytHxoIZEehaxr1a0FltwR3xoU0gsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275760; c=relaxed/simple;
	bh=3IVMwrKeVEC/6UhTNVFxZHMhV5X2WTTamqtG+hqS7gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zj0gLulLSDjDu0afkHvFBqMD0xM/WS8FNBH6q9NsG6RlRjTu54l26O+j4DRv2SOJ/r8gGz5uJ7gbPwE5S6oCmcEYWrIWBrnlQrjKwJwfqNeIRIFs77YG5L4xJx/ZLJJ4MzkgAXGdrvTIN3nJK459v858FenxFL/s4GYNza9M69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzKqXCkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzKqXCkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA6CC4CEF0;
	Sun,  7 Sep 2025 20:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275760;
	bh=3IVMwrKeVEC/6UhTNVFxZHMhV5X2WTTamqtG+hqS7gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzKqXCkJsWJJF5Trd0jp0cc7E1TjrFfex6DjdujxnKb+e4fcglqH4JrYwugreInu3
	 ycDLpHpCHzvA4RdXRKsCMdY+Og857Od8fAF7vl7lwcepGMk3CgEYFT6EiLrCUIGuTP
	 I1pCekNgblgB9563cQS4bNijp410ckOJ67eco+50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	kernel-list@raspberrypi.com,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/52] net: phy: microchip: force IRQ polling mode for lan88xx
Date: Sun,  7 Sep 2025 21:58:04 +0200
Message-ID: <20250907195603.245028455@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fiona Klute <fiona.klute@gmx.de>

[ Upstream commit 30a41ed32d3088cd0d682a13d7f30b23baed7e93 ]

With lan88xx based devices the lan78xx driver can get stuck in an
interrupt loop while bringing the device up, flooding the kernel log
with messages like the following:

lan78xx 2-3:1.0 enp1s0u3: kevent 4 may have been dropped

Removing interrupt support from the lan88xx PHY driver forces the
driver to use polling instead, which avoids the problem.

The issue has been observed with Raspberry Pi devices at least since
4.14 (see [1], bug report for their downstream kernel), as well as
with Nvidia devices [2] in 2020, where disabling interrupts was the
vendor-suggested workaround (together with the claim that phylib
changes in 4.9 made the interrupt handling in lan78xx incompatible).

Iperf reports well over 900Mbits/sec per direction with client in
--dualtest mode, so there does not seem to be a significant impact on
throughput (lan88xx device connected via switch to the peer).

[1] https://github.com/raspberrypi/linux/issues/2447
[2] https://forums.developer.nvidia.com/t/jetson-xavier-and-lan7800-problem/142134/11

Link: https://lore.kernel.org/0901d90d-3f20-4a10-b680-9c978e04ddda@lunn.ch
Fixes: 792aec47d59d ("add microchip LAN88xx phy driver")
Signed-off-by: Fiona Klute <fiona.klute@gmx.de>
Cc: kernel-list@raspberrypi.com
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250416102413.30654-1-fiona.klute@gmx.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/microchip.c |   46 ++------------------------------------------
 1 file changed, 3 insertions(+), 43 deletions(-)

--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -31,47 +31,6 @@ static int lan88xx_write_page(struct phy
 	return __phy_write(phydev, LAN88XX_EXT_PAGE_ACCESS, page);
 }
 
-static int lan88xx_phy_config_intr(struct phy_device *phydev)
-{
-	int rc;
-
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		/* unmask all source and clear them before enable */
-		rc = phy_write(phydev, LAN88XX_INT_MASK, 0x7FFF);
-		rc = phy_read(phydev, LAN88XX_INT_STS);
-		rc = phy_write(phydev, LAN88XX_INT_MASK,
-			       LAN88XX_INT_MASK_MDINTPIN_EN_ |
-			       LAN88XX_INT_MASK_LINK_CHANGE_);
-	} else {
-		rc = phy_write(phydev, LAN88XX_INT_MASK, 0);
-		if (rc)
-			return rc;
-
-		/* Ack interrupts after they have been disabled */
-		rc = phy_read(phydev, LAN88XX_INT_STS);
-	}
-
-	return rc < 0 ? rc : 0;
-}
-
-static irqreturn_t lan88xx_handle_interrupt(struct phy_device *phydev)
-{
-	int irq_status;
-
-	irq_status = phy_read(phydev, LAN88XX_INT_STS);
-	if (irq_status < 0) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	}
-
-	if (!(irq_status & LAN88XX_INT_STS_LINK_CHANGE_))
-		return IRQ_NONE;
-
-	phy_trigger_machine(phydev);
-
-	return IRQ_HANDLED;
-}
-
 static int lan88xx_suspend(struct phy_device *phydev)
 {
 	struct lan88xx_priv *priv = phydev->priv;
@@ -388,8 +347,9 @@ static struct phy_driver microchip_phy_d
 	.config_aneg	= lan88xx_config_aneg,
 	.link_change_notify = lan88xx_link_change_notify,
 
-	.config_intr	= lan88xx_phy_config_intr,
-	.handle_interrupt = lan88xx_handle_interrupt,
+	/* Interrupt handling is broken, do not define related
+	 * functions to force polling.
+	 */
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,


