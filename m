Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936374CE04;
	Mon,  4 Mar 2024 21:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587602; cv=none; b=S50CuLw4ZqN4CulcsIM053aNxeb1Ti6ZjF6/VeQRMW+fIvHiaPkSGMMqThgrfX9hJTlmzE4MCrkBcwZeJ0WKvszsQyXa3KMBWypWTx6785dY1rsbss2yf96QjYbEJgpX/FXmsvIIpD/pT0roYFxFBjITTA6TiVo5+LMe4CAGkHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587602; c=relaxed/simple;
	bh=Sbr/NbroOoiAWVPbfYO33NgTDp48UIkuMROCVY3af2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8u9QsrNeSxJ8qJ/ssyKCaiDi40SsOP6AxiGUQ4LB0BxzYLh4JD9L23y5lLHLW7cMuCCZTpP8ciqL54W5xxwBI1WGvAgPTZsEOzgYK/jxAbDCbJHNIMa28//1aB/XG8hftryI4oAPYhEDw75V1SXxYJQ9dK8+pB0GhrwQ0CjGU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1YriBl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1YriBl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9594C433F1;
	Mon,  4 Mar 2024 21:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587602;
	bh=Sbr/NbroOoiAWVPbfYO33NgTDp48UIkuMROCVY3af2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1YriBl0cCIwSpKhz4KOjX/f+oN4PpCl8qkxvTYeNbn/tyqoqlDUD7IlGllAHe50Q
	 cybMOEXn6mumZgArNwOXSNgbjuxdlc7/Og/ganuGHn06mdqHYDsby89c6s8AOLO5fa
	 jypxTDsBgOQ40XdSkt4nWKSB9qumN4kzIUKdV2Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 019/162] lan78xx: enable auto speed configuration for LAN7850 if no EEPROM is detected
Date: Mon,  4 Mar 2024 21:21:24 +0000
Message-ID: <20240304211552.449119422@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5add4145d9fc1..2e6d423f3a016 100644
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



