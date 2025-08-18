Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98000335BB3;
	Mon, 18 Aug 2025 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523662; cv=none; b=jFWRiJK0hcI4JURrc4+3PKmPXp42jmDsqq1MT9uUXUUpqse/vP+FrUbqY5tpZqXfg4bWfgzTjk7LVEiK6t/Msp55z7C8ag8k+r5r+kOoEXIJkh7kAgjdeakHfg1E93mUTTWt4qX5nZH/rJhH5g4rN46dBA+J7cOj1cvvmj1Eflk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523662; c=relaxed/simple;
	bh=iN5JbU0gVcLXs/eAqDYgvriX5sc13ibbc579KDbZjvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T54fo466WVClBnb+AbuHoNKVhQ/AUC+869PRPkvDn7PC2UBSfuOGQGbB/LgkbqBnQQXDCjYxsr54SnS93bt51fAxbXgXHNkQJ1dFQthMiPoAGHdjMnQyoelC96dDolF7zan5VyzXV4U3TDobK0hFM9dnk7w2FjzIZpJnhsaZffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUeFtkLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUeFtkLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067ECC4CEEB;
	Mon, 18 Aug 2025 13:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523662;
	bh=iN5JbU0gVcLXs/eAqDYgvriX5sc13ibbc579KDbZjvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUeFtkLhtcY7BWP/6MCuIOMXSNywhCX1G4vNysmkJ1PQUj+/T1/tHGRee6I7HSviT
	 m/yi8PKYDcDj+FUlhLGy2+YddIzqDQJwTKUfKYzp62b7q1t3czTCgb44U1EU0uEewa
	 emrV5D7dfN+otN+mlLRVxnuO85MuQ3C+Z2XSZc3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kamil=20Hor=C3=A1k=20-=202N?= <kamilh@axis.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 240/515] net: phy: bcm54811: PHY initialization
Date: Mon, 18 Aug 2025 14:43:46 +0200
Message-ID: <20250818124507.626254756@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamil Horák - 2N <kamilh@axis.com>

[ Upstream commit 3117a11fff5af9e74f4946f07cb3ca083cbbdf4b ]

Reset the bit 12 in PHY's LRE Control register upon initialization.
According to the datasheet, this bit must be written to zero after
every device reset.

Signed-off-by: Kamil Horák - 2N <kamilh@axis.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250708090140.61355-5-kamilh@axis.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 9b1de54fd483..f871f11d1921 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -655,7 +655,7 @@ static int bcm5481x_read_abilities(struct phy_device *phydev)
 {
 	struct device_node *np = phydev->mdio.dev.of_node;
 	struct bcm54xx_phy_priv *priv = phydev->priv;
-	int i, val, err;
+	int i, val, err, aneg;
 
 	for (i = 0; i < ARRAY_SIZE(bcm54811_linkmodes); i++)
 		linkmode_clear_bit(bcm54811_linkmodes[i], phydev->supported);
@@ -676,9 +676,19 @@ static int bcm5481x_read_abilities(struct phy_device *phydev)
 		if (val < 0)
 			return val;
 
+		/* BCM54811 is not capable of LDS but the corresponding bit
+		 * in LRESR is set to 1 and marked "Ignore" in the datasheet.
+		 * So we must read the bcm54811 as unable to auto-negotiate
+		 * in BroadR-Reach mode.
+		 */
+		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
+			aneg = 0;
+		else
+			aneg = val & LRESR_LDSABILITY;
+
 		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 				 phydev->supported,
-				 val & LRESR_LDSABILITY);
+				 aneg);
 		linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
 				 phydev->supported,
 				 val & LRESR_100_1PAIR);
@@ -735,8 +745,15 @@ static int bcm54811_config_aneg(struct phy_device *phydev)
 
 	/* Aneg firstly. */
 	if (priv->brr_mode) {
-		/* BCM54811 is only capable of autonegotiation in IEEE mode */
-		phydev->autoneg = 0;
+		/* BCM54811 is only capable of autonegotiation in IEEE mode.
+		 * In BroadR-Reach mode, disable the Long Distance Signaling,
+		 * the BRR mode autoneg as supported in other Broadcom PHYs.
+		 * This bit is marked as "Reserved" and "Default 1, must be
+		 *  written to 0 after every device reset" in the datasheet.
+		 */
+		ret = phy_modify(phydev, MII_BCM54XX_LRECR, LRECR_LDSEN, 0);
+		if (ret < 0)
+			return ret;
 		ret = bcm_config_lre_aneg(phydev, false);
 	} else {
 		ret = genphy_config_aneg(phydev);
-- 
2.39.5



