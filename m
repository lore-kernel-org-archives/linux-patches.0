Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018C37E5CB;
	Thu, 20 Aug 2026 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238593; cv=none; b=gbzAmGPtxQ8xoWJyOND/x0B4v0yzFRvTU8L+USbiVh83/RflVSaAcJMr0fH8kUwAQxomfSI/NRoTLPfN0/KZlDLU8jGeO9bZ7ATjJz+caDG19J914sdgInYu695nnKX8wAPQVHVoFSmksK1zoQrAD9wic98A3nc4HykENj4xzxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238593; c=relaxed/simple;
	bh=0P8njLRvOL7gyWreNFElooKC3PmbWb03EAg/ONWoZhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ep9AEDcGrtwcgtT2kukYHlWGCcxhWTJ9r3nQcNsO2cIFeee6/q9Kg8lalTyorZu+M9S+qnHm2b3Eu31uZCPHwaenu3hW/Bg0oR5tY1cZ6BLtcj3EmeZL9d3P0CPYUGqXMV9Zxeto0UC/GidH8C7j5Et9yEL244ntIYerh4pN728=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyrH1t/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyrH1t/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465E1F000E9;
	Thu, 20 Aug 2026 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238589;
	bh=s6HAoA55uDLPVSEOD53tL8/9FEflmfOVnSXCgweymMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyrH1t/dehWNnvlw4er4uyi4fha4KunLQIPGBBgr0InLRBUFKwZEeQAzqyBHPNti3
	 84Zc3sO8e+8Hw7idSn/BHrkpLJbR0RNECW+n3VSiUQU2B3RIZWldk56FiTjznKkEJ5
	 zYu8II+9OULP4f7uN3IdqJOKAgJ0bRICjDr/7BKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 201/228] net: phy: realtek: fix EEE advertisement write on the internal PHY MMD path
Date: Thu, 20 Aug 2026 16:55:43 +0200
Message-ID: <20260820145251.145692301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 202fef9bbbf5784487eec27581389c6fb97c350d ]

In rtlgen_write_mmd(), the MDIO_AN_EEE_ADV case swaps the arguments to
rtlgen_write_vend2(): it passes the MMD register number as the OCP address
and the OCP address constant as the value. The caller's value is discarded
and the write lands on the wrong register, so the EEE advertisement cannot
be configured on the affected PHYs.

Mirror rtlgen_read_mmd() and write the value to RTL_MDIO_AN_EEE_ADV.

Fixes: da681ed73fb9 ("net: phy: realtek: improve mmd register access for internal PHY's")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260806134716.3511821-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 01bbddeb4a306..cfd81990d3677 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -1338,7 +1338,7 @@ static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	if (devnum == MDIO_MMD_VEND2)
 		ret = rtlgen_write_vend2(phydev, regnum, val);
 	else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV)
-		ret = rtlgen_write_vend2(phydev, regnum, RTL_MDIO_AN_EEE_ADV);
+		ret = rtlgen_write_vend2(phydev, RTL_MDIO_AN_EEE_ADV, val);
 	else
 		ret = -EOPNOTSUPP;
 
-- 
2.53.0



