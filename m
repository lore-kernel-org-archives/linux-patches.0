Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B6574055;
	Wed,  7 Aug 2024 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042997; cv=none; b=pfZjMo76VV82m6aS+evl1hQKa3xpoUtFljxggfdOpkAAuHJpg1cvGJjM4EBz/PS2Nxnommr5UikoSMaDSPOPp9R1i4kKTHRBaV1dCHkr/l+2z0TCeZuTWa6QkZyAnus85b4+KYF+aQpqsmrHnS5vJTUFq1l6BpDSZ7yVzpKMPXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042997; c=relaxed/simple;
	bh=gsiX7ZcRO6HAiQUWJz8tn2lByzVStPoVxvd0AwX9/rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhfXWO4Hou57SSJJdeM1duVI4ewUJr1sM/S2v1zl1X1z25zt+daJNy0XH5FHM2IZl31oRgJj0K421AtgfN75anevwAYUNBJj/QarAkX/MUdzT8kj+zNzpu2cJpzWiEz1BvmqT3Ls6LtMI4Ah/M/WiTF2KMul+2GzlYUIj9aDJGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EW3C8N7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EW3C8N7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C3BC32781;
	Wed,  7 Aug 2024 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042997;
	bh=gsiX7ZcRO6HAiQUWJz8tn2lByzVStPoVxvd0AwX9/rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW3C8N7XbrM+O2lBRFFaZCZgpqxKXPKV08jlccFQuAh3n68LcWfNLlnQgZnD4bzuK
	 4QFCox9w9NaS1HQbPqYmVqndmAZyxlaKK4k6YnTK6Np1s1o7/X4Y6BCzCS1mZz68N1
	 n1uHWdKyx6Ey5lszuETFaijvAbXrzRwmgqe67Xxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 052/123] net: phy: micrel: Fix the KSZ9131 MDI-X status issue
Date: Wed,  7 Aug 2024 16:59:31 +0200
Message-ID: <20240807150022.499952635@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ebafedde0ab74..0803b6e83cf74 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1389,6 +1389,8 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	const struct device *dev_walker;
 	int ret;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	dev_walker = &phydev->mdio.dev;
 	do {
 		of_node = dev_walker->of_node;
@@ -1438,28 +1440,30 @@ static int ksz9131_config_init(struct phy_device *phydev)
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



