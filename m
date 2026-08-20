Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BC3381AFF;
	Thu, 20 Aug 2026 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239215; cv=none; b=RmhhytIXIRY4n+0Ni/S9fXIdclLbKWm7pbPKBVEMNUDxbluZ6ZJ46EcvU9oHxZsPe4+fwB3fxdo3h9qD57QZm2tDvezRcvrZ785S0qdeFr4Ih4dMc055nnikzmuIkVMflgbPzXETmJBbcTwoEbBLcFpWGRKtjBvqxaVeohXNnm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239215; c=relaxed/simple;
	bh=5ZPh+HotmM4NWrPSZoPw5D5DWEn+TwjxOCHHyTlBaRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2h+pwZ9Stx6Cfr2g75ZQMkwSUh9g9PqMWhdfyl/weBsUTkwMBcaXf8MvvZYwaHCNj4o4qioSscGM+VmrfcPGROWCq4PgBdZN9ils9aW99XSYdYDJGrj+B4PVE7bruQSvXBtEDNx4z8YAhH6i3uZbErDTucPwL9Tw6tnJ5oo+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbVZHb7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbVZHb7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4D11F000E9;
	Thu, 20 Aug 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239214;
	bh=OBi80wwqjcgKNPLqyFjSDN8unOll3WdSJljKGXP1R9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbVZHb7qlNADsIT7CgsnDx4iKI30ke6PYpfUUU2quxI45o5oxj4aCnJijW8Z2QFQ4
	 pJn3a6IO31JeeqT0/i6zYeFH5nX9U9DaKv44pP1zuBQD/eKxZ1DvZa04ck0xFGreu7
	 MT6SaB0fX9UFFEWize4ovphubQ74bnO5iNYun4io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/217] net: phy: realtek: fix EEE advertisement write on the internal PHY MMD path
Date: Thu, 20 Aug 2026 16:55:57 +0200
Message-ID: <20260820145243.406792006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 05df1a33b0e20..ef8c3b23bee88 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -1164,7 +1164,7 @@ static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	if (devnum == MDIO_MMD_VEND2)
 		ret = rtlgen_write_vend2(phydev, regnum, val);
 	else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV)
-		ret = rtlgen_write_vend2(phydev, regnum, RTL_MDIO_AN_EEE_ADV);
+		ret = rtlgen_write_vend2(phydev, RTL_MDIO_AN_EEE_ADV, val);
 	else
 		ret = -EOPNOTSUPP;
 
-- 
2.53.0



