Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B70D79DDE;
	Mon,  4 Mar 2024 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588631; cv=none; b=eR/2X70bJpxx4+cb0RsnSidLIjbt2m68KxYVuYKDRZzCcLSIvO6IF/8WYGTi2+euWOcplfMR0EkZPvXo3ov4i493NJPfxkWdZQsk9Mq4ztOHnuOAAYwps+RN1KvVdol+rv57m0gz0QSWT3h/sFKHMYWGeK7Gz2UKCL5vzSTWU+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588631; c=relaxed/simple;
	bh=pRyciyF/bFKCnjG1V46g8SyA2f7ziZ0aQ2eAh6xNpJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eotAdFR4676DlM7sxDXK12LPL12WMc+TFQVx3ggsS97w2fdgKSXKx1N5QFCfwPun80RI+zpJyCNHFRm3T6XF0RKrr3C0hAwtYWYMzCJkW8N2EDFpcQWTbc1pwC6t18dBPugwU1wv5BzhNBWKj6dhqJk7/8Br1DOKI2KUm+E8foA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjDfyfvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjDfyfvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936CEC433C7;
	Mon,  4 Mar 2024 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588630;
	bh=pRyciyF/bFKCnjG1V46g8SyA2f7ziZ0aQ2eAh6xNpJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjDfyfvM27zUCJFDFas7TxOwxD3fpMSW3j5+reiDDNaZlI1SnRGud9wHQVoXAhKN7
	 zUmrXPveFFOarhadgUO2xnOBiUspes4IqoeoyYZs1izGlpMZ3R/uFjQ6j5SrDUyL/f
	 dr24jOplCCY1VTiuJKdgqTAg77NoqOXltY4O+kxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/215] lan78xx: enable auto speed configuration for LAN7850 if no EEPROM is detected
Date: Mon,  4 Mar 2024 21:21:39 +0000
Message-ID: <20240304211558.140855120@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 0e67899abfbfdea0c3c0ed3fd263ffc601c5c157 ]

Same as LAN7800, LAN7850 can be used without EEPROM. If EEPROM is not
present or not flashed, LAN7850 will fail to sync the speed detected by the PHY
with the MAC. In case link speed is 100Mbit, it will accidentally work,
otherwise no data can be transferred.

Better way would be to implement link_up callback, or set auto speed
configuration unconditionally. But this changes would be more intrusive.
So, for now, set it only if no EEPROM is found.

Fixes: e69647a19c87 ("lan78xx: Set ASD in MAC_CR when EEE is enabled.")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20240222123839.2816561-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index c458c030fadf6..7b9d480e44fe4 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3035,7 +3035,8 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	if (dev->chipid == ID_REV_CHIP_ID_7801_)
 		buf &= ~MAC_CR_GMII_EN_;
 
-	if (dev->chipid == ID_REV_CHIP_ID_7800_) {
+	if (dev->chipid == ID_REV_CHIP_ID_7800_ ||
+	    dev->chipid == ID_REV_CHIP_ID_7850_) {
 		ret = lan78xx_read_raw_eeprom(dev, 0, 1, &sig);
 		if (!ret && sig != EEPROM_INDICATOR) {
 			/* Implies there is no external eeprom. Set mac speed */
-- 
2.43.0



