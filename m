Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73462877DC;
	Mon, 18 Aug 2025 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524837; cv=none; b=S5PVaJU1GyepsbK1Wfm+tnI7oFaoVmkgy0Ma7kQGy38aykthBhLt+I111JNoPvZK20APs5HTbcuhKwquTmIs1nv4rE9hqKm61G2VP9bbgg6Rt5RGXNMIJ+tD4JeL3nygDQWES9PndV13EF1XuDlt2iqanlQK3my71h/bpUjVqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524837; c=relaxed/simple;
	bh=bvKwc4mdSdByBi//GNkexbkI4A7UKe/G7GfvRPELI88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t43oSoX1rMQOu8vrnyZ+KfMA9BZu3QrItDufcLeWkosek8H09hS8ev/0omQIhwXwOHr/uy3/dn6PGF+wN3UReI2mAWDDXN9eHsd/S/0dSdJR9Uygt0C474xj4S77ESQM3+0hH1Y4coMTc7uyZ5+bN8a/Uw8eRcS4V8zbFoEQyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSP7rLQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSP7rLQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF4DC4CEEB;
	Mon, 18 Aug 2025 13:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524837;
	bh=bvKwc4mdSdByBi//GNkexbkI4A7UKe/G7GfvRPELI88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSP7rLQINdhTm5/UTdeFBOlEyhdU/fFCqEU+FW6phC+QuLiKm8gUgrgpXDNLtMvGy
	 XG8je+yOZnCqCggn4DM8LzOJPH+h26w3dezgLeB3XLgbuuoyzpPqfekQEckHvw6X+E
	 mskkOksFB0WP1qNLTfFPd7s2fNG/rH0/AbANnV0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 079/570] net: phy: nxp-c45-tja11xx: fix the PHY ID mismatch issue when using C45
Date: Mon, 18 Aug 2025 14:41:06 +0200
Message-ID: <20250818124508.865229045@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 8ee90742cf29427683294a6a80f1e2b7f4af1cff ]

TJA1103/04/20/21 support both C22 and C45 accessing methods.

The TJA11xx driver has implemented the match_phy_device() API.
However, it does not handle the C45 ID. If C45 was used to access
TJA11xx, match_phy_device() would always return false due to
phydev->phy_id only used by C22 being empty, resulting in the
generic phy driver being used for TJA11xx PHYs.

Therefore, check phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] when
using C45.

Fixes: 1b76b2497aba ("net: phy: nxp-c45-tja11xx: simplify .match_phy_device OP")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Link: https://patch.msgid.link/20250807040832.2455306-1-xiaoning.wang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 4c6d905f0a9f..87adb6508017 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1965,24 +1965,27 @@ static int nxp_c45_macsec_ability(struct phy_device *phydev)
 	return macsec_ability;
 }
 
+static bool tja11xx_phy_id_compare(struct phy_device *phydev,
+				   const struct phy_driver *phydrv)
+{
+	u32 id = phydev->is_c45 ? phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] :
+				  phydev->phy_id;
+
+	return phy_id_compare(id, phydrv->phy_id, phydrv->phy_id_mask);
+}
+
 static int tja11xx_no_macsec_match_phy_device(struct phy_device *phydev,
 					      const struct phy_driver *phydrv)
 {
-	if (!phy_id_compare(phydev->phy_id, phydrv->phy_id,
-			    phydrv->phy_id_mask))
-		return 0;
-
-	return !nxp_c45_macsec_ability(phydev);
+	return tja11xx_phy_id_compare(phydev, phydrv) &&
+	       !nxp_c45_macsec_ability(phydev);
 }
 
 static int tja11xx_macsec_match_phy_device(struct phy_device *phydev,
 					   const struct phy_driver *phydrv)
 {
-	if (!phy_id_compare(phydev->phy_id, phydrv->phy_id,
-			    phydrv->phy_id_mask))
-		return 0;
-
-	return nxp_c45_macsec_ability(phydev);
+	return tja11xx_phy_id_compare(phydev, phydrv) &&
+	       nxp_c45_macsec_ability(phydev);
 }
 
 static const struct nxp_c45_regmap tja1120_regmap = {
-- 
2.50.1



