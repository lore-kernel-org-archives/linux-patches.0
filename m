Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AD63242DF;
	Sun,  7 Jun 2026 10:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829967; cv=none; b=QYob/PGK71RotTiq6Te+RuLgwVz0VGQQEEQi/t7J5xbklhgfDOXWa4dNjq+ZF+4bj/ky4SDg64jF+azbGzihn0A20OpG0v4yOfLnMj3jTaKykszWJ2yyCbpPBcDtSo5P1ZQm9We/AT84L6eSyegZPmfXInR0WFgUEqf6hjqTJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829967; c=relaxed/simple;
	bh=RFpnZP6Vk/gxBAtR7kpO08VGMKcBWNXuSpiFAYV6sck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc4IXl4+3lNESlDA78CyEuQFVC8j1zfYiu/mLitC7S4io+FhsBCxW259TA5E3citP5EE9ykKsUPN/NPZDX4HJpo+E1LEkM1t4r1MZetPnJtkLoFa26n3LEkz1J717x2Z4sI7KZ7vNuTh4aDy3gBKRe4LZsIEM67CGudjv2kQEp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCOnQBOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCOnQBOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30CD1F00893;
	Sun,  7 Jun 2026 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829966;
	bh=7FtK+LHRnpnemWEg7sobGDiQSA4+UotDG/gQiQBZm9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCOnQBOFyNxdTkqAZBdYceFLzBmkNiR8WPXV4z770xLyAAtz2KZXOPvBHKr98+m3L
	 nq7XSqWMHrDoqeljF+J3mx5No2siULUPZpNvOoF4Jp0btZF59UX1Vu5FiTcJwXHpw7
	 D6+VljeG4o9ymJvQtOp8TITeP7gY1NSU104yAHfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 330/332] net: phy: micrel: fix LAN8814 QSGMII soft reset
Date: Sun,  7 Jun 2026 12:01:39 +0200
Message-ID: <20260607095740.253443213@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit e027c218c482c6a0ae1948129ccda3b0a2033368 ]

LAN8814 QSGMII soft reset was moved into the probe function to avoid
triggering it for each of 4 PHY-s in the package.

However, that broke QSGMII link between the MAC and PHY on most LAN8814
PHY-s, specificaly for us on the Microchip LAN969x switch.
Reading the QSGMII status registers it was visible that lanes were only
partially synced.

It looks like the reset timing is crucial, so lets move the reset back
into the .config_init function but guard it with phy_package_init_once()
to avoid it being triggered on each of 4 PHY-s in the package.
Change the probe function to use phy_package_probe_once() for coma and PtP
setup.

Fixes: 96a9178a29a6 ("net: phy: micrel: lan8814 fix reset of the QSGMII interface")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://patch.msgid.link/20260428134138.1741253-1-robert.marko@sartura.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c6b011a9d63698..23305be8c7fac7 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4548,6 +4548,13 @@ static int lan8814_config_init(struct phy_device *phydev)
 	struct kszphy_priv *lan8814 = phydev->priv;
 	int ret;
 
+	if (phy_package_init_once(phydev))
+		/* Reset the PHY */
+		lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
+				       LAN8814_QSGMII_SOFT_RESET,
+				       LAN8814_QSGMII_SOFT_RESET_BIT,
+				       LAN8814_QSGMII_SOFT_RESET_BIT);
+
 	/* Based on the interface type select how the advertise ability is
 	 * encoded, to set as SGMII or as USGMII.
 	 */
@@ -4655,13 +4662,7 @@ static int lan8814_probe(struct phy_device *phydev)
 	priv->is_ptp_available = err == LAN8814_REV_LAN8814 ||
 				 err == LAN8814_REV_LAN8818;
 
-	if (phy_package_init_once(phydev)) {
-		/* Reset the PHY */
-		lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
-				       LAN8814_QSGMII_SOFT_RESET,
-				       LAN8814_QSGMII_SOFT_RESET_BIT,
-				       LAN8814_QSGMII_SOFT_RESET_BIT);
-
+	if (phy_package_probe_once(phydev)) {
 		err = lan8814_release_coma_mode(phydev);
 		if (err)
 			return err;
-- 
2.53.0



