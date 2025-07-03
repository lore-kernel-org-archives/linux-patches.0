Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BB72E7F0B;
	Thu,  3 Jul 2025 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554539; cv=none; b=YjUH73n1jdNwYuT4TImDZj8hJGBSxHAqdTsCwu/z+9PMO8SZ6GYcr0YPb6Eu0n4+j1Rx+nyD9FrjftMLLMFpXn8TLlnOFnmdREoITlkagEcHWm98UVPOAPuxAHgw5bjOZAAUFUHsHeJKVGrmHykOrmNNGMHbpDHhBVhIPSiJAQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554539; c=relaxed/simple;
	bh=Z5ZRNcbB+bOeaIK5qhr+sPv4b2Kt5lhFYKergde2/LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ngsgkji2odvdhGQoNjKWe3tuaGimvrzd8+6Ejtl2vbtCL0nwvI3XPKxOFCPLjCz3xK1xTBJI3iQatDOwIdmrlsK5SR6VAKS+wNQj8M0+35/+1Q9Z+qs/UbLgX7XceUMntM4SjHh0Hjs54SeF0bYk07LeXKtZpPRHzaBG9gCnEGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp1Hgcc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp1Hgcc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E010C4CEE3;
	Thu,  3 Jul 2025 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554538;
	bh=Z5ZRNcbB+bOeaIK5qhr+sPv4b2Kt5lhFYKergde2/LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp1Hgcc/DThT+ef+/gQlSZ9luBYdhy4P909VvNB5RPUmJMdgQ7BZG1e89Zynoy11N
	 ZTKlR3BbtRY+HY6wfNxfQT3XC1ZbA6tF/nE9YtKOd2kX0wSOMaBu0RAkLta+Sc7ySS
	 nrm+qsDAaxie2xpL9nM0pS6RsrqF8Vt3PGNYtP0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Mathieu Tortuyaux <mtortuyaux@microsoft.com>
Subject: [PATCH 6.12 192/218] net: phy: realtek: merge the drivers for internal NBase-T PHYs
Date: Thu,  3 Jul 2025 16:42:20 +0200
Message-ID: <20250703144003.882708500@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit f87a17ed3b51fba4dfdd8f8b643b5423a85fc551 upstream.

The Realtek RTL8125/RTL8126 NBase-T MAC/PHY chips have internal PHY's
which are register-compatible, at least for the registers we use here.
So let's use just one PHY driver to support all of them.
These internal PHY's exist also as external C45 PHY's, but on the
internal PHY's no access to MMD registers is possible. This can be
used to differentiate between the internal and external version.

As a side effect the drivers for two now external-only drivers don't
require read_mmd/write_mmd hooks any longer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/c57081a6-811f-4571-ab35-34f4ca6de9af@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mathieu Tortuyaux <mtortuyaux@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/realtek.c |   53 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 10 deletions(-)

--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -92,6 +92,7 @@
 
 #define RTL_GENERIC_PHYID			0x001cc800
 #define RTL_8211FVD_PHYID			0x001cc878
+#define RTL_8221B				0x001cc840
 #define RTL_8221B_VB_CG				0x001cc849
 #define RTL_8221B_VN_CG				0x001cc84a
 #define RTL_8251B				0x001cc862
@@ -1040,6 +1041,23 @@ static bool rtlgen_supports_2_5gbps(stru
 	return val >= 0 && val & MDIO_PMA_SPEED_2_5G;
 }
 
+/* On internal PHY's MMD reads over C22 always return 0.
+ * Check a MMD register which is known to be non-zero.
+ */
+static bool rtlgen_supports_mmd(struct phy_device *phydev)
+{
+	int val;
+
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, MII_MMD_CTRL, MDIO_MMD_PCS);
+	__phy_write(phydev, MII_MMD_DATA, MDIO_PCS_EEE_ABLE);
+	__phy_write(phydev, MII_MMD_CTRL, MDIO_MMD_PCS | MII_MMD_CTRL_NOINCR);
+	val = __phy_read(phydev, MII_MMD_DATA);
+	phy_unlock_mdio_bus(phydev);
+
+	return val > 0;
+}
+
 static int rtlgen_match_phy_device(struct phy_device *phydev)
 {
 	return phydev->phy_id == RTL_GENERIC_PHYID &&
@@ -1049,7 +1067,8 @@ static int rtlgen_match_phy_device(struc
 static int rtl8226_match_phy_device(struct phy_device *phydev)
 {
 	return phydev->phy_id == RTL_GENERIC_PHYID &&
-	       rtlgen_supports_2_5gbps(phydev);
+	       rtlgen_supports_2_5gbps(phydev) &&
+	       rtlgen_supports_mmd(phydev);
 }
 
 static int rtlgen_is_c45_match(struct phy_device *phydev, unsigned int id,
@@ -1061,6 +1080,11 @@ static int rtlgen_is_c45_match(struct ph
 		return !is_c45 && (id == phydev->phy_id);
 }
 
+static int rtl8221b_match_phy_device(struct phy_device *phydev)
+{
+	return phydev->phy_id == RTL_8221B && rtlgen_supports_mmd(phydev);
+}
+
 static int rtl8221b_vb_cg_c22_match_phy_device(struct phy_device *phydev)
 {
 	return rtlgen_is_c45_match(phydev, RTL_8221B_VB_CG, false);
@@ -1081,9 +1105,21 @@ static int rtl8221b_vn_cg_c45_match_phy_
 	return rtlgen_is_c45_match(phydev, RTL_8221B_VN_CG, true);
 }
 
-static int rtl8251b_c22_match_phy_device(struct phy_device *phydev)
+static int rtl_internal_nbaset_match_phy_device(struct phy_device *phydev)
 {
-	return rtlgen_is_c45_match(phydev, RTL_8251B, false);
+	if (phydev->is_c45)
+		return false;
+
+	switch (phydev->phy_id) {
+	case RTL_GENERIC_PHYID:
+	case RTL_8221B:
+	case RTL_8251B:
+		break;
+	default:
+		return false;
+	}
+
+	return rtlgen_supports_2_5gbps(phydev) && !rtlgen_supports_mmd(phydev);
 }
 
 static int rtl8251b_c45_match_phy_device(struct phy_device *phydev)
@@ -1345,10 +1381,8 @@ static struct phy_driver realtek_drvs[]
 		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtl822x_read_mmd,
-		.write_mmd	= rtl822x_write_mmd,
 	}, {
-		PHY_ID_MATCH_EXACT(0x001cc840),
+		.match_phy_device = rtl8221b_match_phy_device,
 		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
 		.get_features	= rtl822x_get_features,
 		.config_aneg	= rtl822x_config_aneg,
@@ -1359,8 +1393,6 @@ static struct phy_driver realtek_drvs[]
 		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtl822x_read_mmd,
-		.write_mmd	= rtl822x_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc838),
 		.name           = "RTL8226-CG 2.5Gbps PHY",
@@ -1438,8 +1470,9 @@ static struct phy_driver realtek_drvs[]
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
 	}, {
-		.match_phy_device = rtl8251b_c22_match_phy_device,
-		.name           = "RTL8126A-internal 5Gbps PHY",
+		.match_phy_device = rtl_internal_nbaset_match_phy_device,
+		.name           = "Realtek Internal NBASE-T PHY",
+		.flags		= PHY_IS_INTERNAL,
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
 		.read_status    = rtl822x_read_status,


