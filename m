Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40873143753;
	Thu, 13 Jun 2024 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278994; cv=none; b=jYSo8vtHOHH1oWjLD9C0EPafJeAjnHa1zamMVk7Lek5aieUwtR+o++v+dZS1GufSU/b7nwh6u/UoUGwYIgyNk/0sFg/5qL3DsFo7nCg0QQo/pwEfZ6QT7FrDIUBn1dULdK73i9RmflJgj+G2QJ7SdDwWMc/dc1kSppljGo7LrGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278994; c=relaxed/simple;
	bh=3mvIF2VV5QNVVPynXNP8DXLmT0l0uxxHcUeM9mgcgt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj1JIzsF9zO/VaBdXoRJDqMwUzyYRaOs+uIqFLHG3LZcUMz+N0hNpzmEH1ABP6j41PvELz4/zlT2jF/vZ8QWPwP47N1CsGXpq+peSWMy+PQPpnZ+BKsrZktYFefe9Yqg4/FhNqvCnALPTIUdjIIS+GK+/Nx4b8MfRpBTMIT7yYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1wukbjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1wukbjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF91C2BBFC;
	Thu, 13 Jun 2024 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278993;
	bh=3mvIF2VV5QNVVPynXNP8DXLmT0l0uxxHcUeM9mgcgt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1wukbjD+8FYpscsp2ARrB00QobVAxGTg4ve2zk4KKMp722cy07Kz8rcpc9NVAS6V
	 vf3/yOdvzy1cvd8JNN1mOfce4zcXLyKKpzLQTKAznUgYLJo40KBOMXZu6DF0Og5m/M
	 Jbpe7hZr6GI2C2mOiAvoG+VmYURyc3jtAxt9iY5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Woojung Huh <woojung.huh@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/213] net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM
Date: Thu, 13 Jun 2024 13:33:07 +0200
Message-ID: <20240613113233.357486247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ec233d033f5cd..22c1eac73f2c4 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1036,7 +1036,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 static int smsc95xx_reset(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	u32 read_buf, write_buf, burst_cap;
+	u32 read_buf, burst_cap;
 	int ret = 0, timeout;
 
 	netif_dbg(dev, ifup, dev->net, "entering smsc95xx_reset\n");
@@ -1178,10 +1178,13 @@ static int smsc95xx_reset(struct usbnet *dev)
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



