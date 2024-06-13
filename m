Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E3A148855;
	Thu, 13 Jun 2024 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280234; cv=none; b=m1L/aJxx/A5gmKJTHRz6wd/RcotEDmq3Ku8zTCfmGt3t1IZrxJjW1Q86WfbMuY6CLzSIj775Qn2mRuhMTt+8PHPqC0CZgDbFhYrz4tTpxE2XqaILUP7QzgWUQjMGIx8kOa7DV1JAONBzrwO8r2gS0yrw0Kse+1Ccwr1f2QnkJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280234; c=relaxed/simple;
	bh=uDxAlWZFgAxCuuiarw2+pYhxwBtZ0Fp5+LeDJoDK+cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7P3V4nRfD4TpzzLrLvuhdYVUi6fWO9nNaszI+atq2+D1tnn6+0VpRkYSeSBvxC47UHwLkwLSGDhD4ib+AmuMNTFOS8crMWr5Crojid3JODeC9XuSxVC4FoX0Rticq9iL+6xi+mtq8Gs3fMG53XfZeeynOZ0sSIrpkKYGeHLJq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tF61csxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tF61csxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70636C2BBFC;
	Thu, 13 Jun 2024 12:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280233;
	bh=uDxAlWZFgAxCuuiarw2+pYhxwBtZ0Fp5+LeDJoDK+cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tF61csxx/UnN1hU4xWSKcj+GHl2Gm3EYFrTXH4ioEsoeYr2FMKY2nQx7MMMDEtBEb
	 SgOztJU5l8jzdKK2AjXa7YFBSr7zReWD+YMB93tsKQS0Kaz0OMAc9ZDJtgpfJKTipp
	 uXu0ttjDFRwvuVI4cXgFf3BAyBV8Xqb1Hk5qL/Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Woojung Huh <woojung.huh@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/202] net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM
Date: Thu, 13 Jun 2024 13:34:14 +0200
Message-ID: <20240613113233.770783517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>

[ Upstream commit 52a2f0608366a629d43dacd3191039c95fef74ba ]

LED Select (LED_SEL) bit in the LED General Purpose IO Configuration
register is used to determine the functionality of external LED pins
(Speed Indicator, Link and Activity Indicator, Full Duplex Link
Indicator). The default value for this bit is 0 when no EEPROM is
present. If a EEPROM is present, the default value is the value of the
LED Select bit in the Configuration Flags of the EEPROM. A USB Reset or
Lite Reset (LRST) will cause this bit to be restored to the image value
last loaded from EEPROM, or to be set to 0 if no EEPROM is present.

While configuring the dual purpose GPIO/LED pins to LED outputs in the
LED General Purpose IO Configuration register, the LED_SEL bit is changed
as 0 and resulting the configured value from the EEPROM is cleared. The
issue is fixed by using read-modify-write approach.

Fixes: f293501c61c5 ("smsc95xx: configure LED outputs")
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Woojung Huh <woojung.huh@microchip.com>
Link: https://lore.kernel.org/r/20240523085314.167650-1-Parthiban.Veerasooran@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 7fe5673e256e6..2dd4c78f5465b 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1022,7 +1022,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 static int smsc95xx_reset(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	u32 read_buf, write_buf, burst_cap;
+	u32 read_buf, burst_cap;
 	int ret = 0, timeout;
 
 	netif_dbg(dev, ifup, dev->net, "entering smsc95xx_reset\n");
@@ -1164,10 +1164,13 @@ static int smsc95xx_reset(struct usbnet *dev)
 		return ret;
 	netif_dbg(dev, ifup, dev->net, "ID_REV = 0x%08x\n", read_buf);
 
+	ret = smsc95xx_read_reg(dev, LED_GPIO_CFG, &read_buf);
+	if (ret < 0)
+		return ret;
 	/* Configure GPIO pins as LED outputs */
-	write_buf = LED_GPIO_CFG_SPD_LED | LED_GPIO_CFG_LNK_LED |
-		LED_GPIO_CFG_FDX_LED;
-	ret = smsc95xx_write_reg(dev, LED_GPIO_CFG, write_buf);
+	read_buf |= LED_GPIO_CFG_SPD_LED | LED_GPIO_CFG_LNK_LED |
+		    LED_GPIO_CFG_FDX_LED;
+	ret = smsc95xx_write_reg(dev, LED_GPIO_CFG, read_buf);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0



