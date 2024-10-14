Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D9B4A24;
	Mon, 14 Oct 2024 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916548; cv=none; b=hQLfyFpvUuFn3oR9paqUGjnWwSubtqNm3nvmBLowkl1jTfi6ZmDXu9gomd8QX6kFzKYa8AaTjaVXcOqgKlbBjkwfMuudbrVquo55i4kgUmmO9LnUXEFCqA44Mih0cApo7c1NtJuh976C/Xc7jixhKnoUpILwBFv18+xu6AcZ6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916548; c=relaxed/simple;
	bh=LRAXUBwPH7szKZWWXidJbipFUticwpYV15V0gFKJKv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4VZ//Fp6bb68BSyUUOzKbdbPSKWsgsa/aTsik8pMO5iM7ayeuzTviHBkZcj5UV5ShJNWdvQBsXwyLuCaQ0fBoOnAYxPIoBBuv8M+I1bMOHq7yb5CN7IgMozXcvstum5nWDFBl/+bF1S7ybYNOY9m+sJq2PP7mQklRHJ3VT4G9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0ZuNEqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0ZuNEqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD837C4CEC3;
	Mon, 14 Oct 2024 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916548;
	bh=LRAXUBwPH7szKZWWXidJbipFUticwpYV15V0gFKJKv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0ZuNEqu6ih9CP++SHpTg49uAOHMWSKK9UFYETGkWmVEKnMQtJT5m1tFe9gTFAv+M
	 Zzmj0fagPTmDN4ydBb+qrC6qugeQOYhf0NVw5vRCrZZnFmdLRmnAcIwFaHS7gVBoY2
	 z+xOku/mv6Fj0jQr+vCiAFX028uOG3PPWN5iWJqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.11 196/214] net: phy: realtek: Fix MMD access on RTL8126A-integrated PHY
Date: Mon, 14 Oct 2024 16:20:59 +0200
Message-ID: <20241014141052.625422046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit a6ad589c1d118f9d5b1bc4c6888d42919f830340 upstream.

All MMD reads return 0 for the RTL8126A-integrated PHY. Therefore phylib
assumes it doesn't support EEE, what results in higher power consumption,
and a significantly higher chip temperature in my case.
To fix this split out the PHY driver for the RTL8126A-integrated PHY
and set the read_mmd/write_mmd callbacks to read from vendor-specific
registers.

Fixes: 5befa3728b85 ("net: phy: realtek: add support for RTL8126A-integrated 5Gbps PHY")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/realtek.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index c15d2f66ef0d..166f6a728373 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1081,6 +1081,16 @@ static int rtl8221b_vn_cg_c45_match_phy_device(struct phy_device *phydev)
 	return rtlgen_is_c45_match(phydev, RTL_8221B_VN_CG, true);
 }
 
+static int rtl8251b_c22_match_phy_device(struct phy_device *phydev)
+{
+	return rtlgen_is_c45_match(phydev, RTL_8251B, false);
+}
+
+static int rtl8251b_c45_match_phy_device(struct phy_device *phydev)
+{
+	return rtlgen_is_c45_match(phydev, RTL_8251B, true);
+}
+
 static int rtlgen_resume(struct phy_device *phydev)
 {
 	int ret = genphy_resume(phydev);
@@ -1418,7 +1428,7 @@ static struct phy_driver realtek_drvs[] = {
 		.suspend        = genphy_c45_pma_suspend,
 		.resume         = rtlgen_c45_resume,
 	}, {
-		PHY_ID_MATCH_EXACT(0x001cc862),
+		.match_phy_device = rtl8251b_c45_match_phy_device,
 		.name           = "RTL8251B 5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
@@ -1427,6 +1437,18 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+	}, {
+		.match_phy_device = rtl8251b_c22_match_phy_device,
+		.name           = "RTL8126A-internal 5Gbps PHY",
+		.get_features   = rtl822x_get_features,
+		.config_aneg    = rtl822x_config_aneg,
+		.read_status    = rtl822x_read_status,
+		.suspend        = genphy_suspend,
+		.resume         = rtlgen_resume,
+		.read_page      = rtl821x_read_page,
+		.write_page     = rtl821x_write_page,
+		.read_mmd	= rtl822x_read_mmd,
+		.write_mmd	= rtl822x_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001ccad0),
 		.name		= "RTL8224 2.5Gbps PHY",
-- 
2.47.0



