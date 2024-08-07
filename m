Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79A278C67;
	Wed,  7 Aug 2024 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043399; cv=none; b=Y1gjkAHt8tpwt1gga7aENuW0nhUZOyzugZ+2DRLMZRGmkUWhRCDKv9H9MXlRJFVNTpIWAh7sLj1tGDeKWN+Zc1V/yPrQUJoPIsx974VbJJVOvegzkO4/XvbhQmPwYOS4uJwRapp9uCO5j+ssgxkU4m1EDQMlVWEuPQXq3ZqQCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043399; c=relaxed/simple;
	bh=D+MSMBvc+RlJslnCP4VgHh5x+3yDGgzfrpzirU/EDc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq+TDQLi6KC93433EaOFwr69hk3VpPR7VCg6wiXHNuPiudLjeP+jpWnG0f2O5LIwIj0KsDpBgi0/sK5vFmIhoaD0Olrduv66TVdEXAwSDJlFSpSU17+7beCoIy/uwPBNtzEyyZPldVdNnXhVSO7kUwwboKYSRJpkwlPvrF4f7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIWJetrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIWJetrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A55AC32781;
	Wed,  7 Aug 2024 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043399;
	bh=D+MSMBvc+RlJslnCP4VgHh5x+3yDGgzfrpzirU/EDc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIWJetrz6C3kPixdw+EJQv7Zm0iE+Y/MivndyMAcnheU4bsR1e1aM2zR1iIAES22Y
	 m4oIvN/7Qtf3C8+PqQTst1qbi1njQvhOmPziRJTwjxbOGqj589TTbGlZhCzfkFtaUZ
	 cP35HSAB6CLx7CUxXgigQaAqozyfJSb6lhhcg+RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/121] net: phy: micrel: Fix the KSZ9131 MDI-X status issue
Date: Wed,  7 Aug 2024 17:00:08 +0200
Message-ID: <20240807150021.897920408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

[ Upstream commit 84383b5ef4cd21b4a67de92afdc05a03b5247db9 ]

The MDIX status is not accurately reflecting the current state after the link
partner has manually altered its MDIX configuration while operating in forced
mode.

Access information about Auto mdix completion and pair selection from the
KSZ9131's Auto/MDI/MDI-X status register

Fixes: b64e6a8794d9 ("net: phy: micrel: Add PHY Auto/MDI/MDI-X set driver for KSZ9131")
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240725071125.13960-1-Raju.Lakkaraju@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 029c82f88ee38..9a0432145645f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1293,6 +1293,8 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	const struct device *dev_walker;
 	int ret;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	dev_walker = &phydev->mdio.dev;
 	do {
 		of_node = dev_walker->of_node;
@@ -1342,28 +1344,30 @@ static int ksz9131_config_init(struct phy_device *phydev)
 #define MII_KSZ9131_AUTO_MDIX		0x1C
 #define MII_KSZ9131_AUTO_MDI_SET	BIT(7)
 #define MII_KSZ9131_AUTO_MDIX_SWAP_OFF	BIT(6)
+#define MII_KSZ9131_DIG_AXAN_STS	0x14
+#define MII_KSZ9131_DIG_AXAN_STS_LINK_DET	BIT(14)
+#define MII_KSZ9131_DIG_AXAN_STS_A_SELECT	BIT(12)
 
 static int ksz9131_mdix_update(struct phy_device *phydev)
 {
 	int ret;
 
-	ret = phy_read(phydev, MII_KSZ9131_AUTO_MDIX);
-	if (ret < 0)
-		return ret;
-
-	if (ret & MII_KSZ9131_AUTO_MDIX_SWAP_OFF) {
-		if (ret & MII_KSZ9131_AUTO_MDI_SET)
-			phydev->mdix_ctrl = ETH_TP_MDI;
-		else
-			phydev->mdix_ctrl = ETH_TP_MDI_X;
+	if (phydev->mdix_ctrl != ETH_TP_MDI_AUTO) {
+		phydev->mdix = phydev->mdix_ctrl;
 	} else {
-		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
-	}
+		ret = phy_read(phydev, MII_KSZ9131_DIG_AXAN_STS);
+		if (ret < 0)
+			return ret;
 
-	if (ret & MII_KSZ9131_AUTO_MDI_SET)
-		phydev->mdix = ETH_TP_MDI;
-	else
-		phydev->mdix = ETH_TP_MDI_X;
+		if (ret & MII_KSZ9131_DIG_AXAN_STS_LINK_DET) {
+			if (ret & MII_KSZ9131_DIG_AXAN_STS_A_SELECT)
+				phydev->mdix = ETH_TP_MDI;
+			else
+				phydev->mdix = ETH_TP_MDI_X;
+		} else {
+			phydev->mdix = ETH_TP_MDI_INVALID;
+		}
+	}
 
 	return 0;
 }
-- 
2.43.0



