Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589761519B4;
	Wed,  5 Feb 2025 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768168; cv=none; b=sq57lsewXwH/XZJlZN0oo2l9Rms3YW+8B1p7bbGA6zuQ/mOdbjYsIO0n0NSJ9FsV1c/NX9ExSd2t6espgMDcZ+ctCqjVfeFmGW4l0kBYjJZhGU8nlJtgR7uFUG73FfQgXt7I//7mcrKi4Pni28x5FQcPBIVU9cZDDCOHhoGd+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768168; c=relaxed/simple;
	bh=lczxkPYquTk2UYZdy4iU52CvK5AdF0Nk+DejiedzTlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NglrUJFkSU+PbFiA5rpFInn5V3uDfBXmoDNlCzP6hpZBmZmqoKLd2hJO2TcA9m4jMaZEhl7SIzmFoIv2SWv5n0AyOndnjtXFk8zXvTsRsOxfpeVm1qN/ltjGIVa33v8v4y4s3zuGf4+Un1mO01g73sKUfkLrEWtNcwrFbornr5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5pN9NHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5pN9NHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4E8C4CED1;
	Wed,  5 Feb 2025 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768168;
	bh=lczxkPYquTk2UYZdy4iU52CvK5AdF0Nk+DejiedzTlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5pN9NHJMRcP04LY9f6VccpfTO4H19PdeUuHFL3VCqhA5mpIV2qI/DyuDjkGcFSpQ
	 ZFv/+o6ZRTUzv5EJMD0AzPYatVPhq3r4bMWjcTqo6PFhrSaF+K1D03NvsV0a2ojdvP
	 p1LQGRnBot1w1BhlBnCAHXfEvjtRXDSzRk7fw3fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Dimitri Fedrau <dima.fedrau@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 507/623] net: phy: marvell-88q2xxx: Fix temperature measurement with reset-gpios
Date: Wed,  5 Feb 2025 14:44:09 +0100
Message-ID: <20250205134515.615199779@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Fedrau <dima.fedrau@gmail.com>

[ Upstream commit a197004cf3c2e6c8cc0695c787a97e62e3229754 ]

When using temperature measurement on Marvell 88Q2XXX devices and the
reset-gpios property is set in DT, the device does a hardware reset when
interface is brought down and up again. That means that the content of
the register MDIO_MMD_PCS_MV_TEMP_SENSOR2 is reset to default and that
leads to permanent deactivation of the temperature measurement, because
activation is done in mv88q2xxx_probe. To fix this move activation of
temperature measurement to mv88q222x_config_init.

Fixes: a557a92e6881 ("net: phy: marvell-88q2xxx: add support for temperature sensor")
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250118-marvell-88q2xxx-fix-hwmon-v2-1-402e62ba2dcb@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell-88q2xxx.c | 33 ++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/marvell-88q2xxx.c b/drivers/net/phy/marvell-88q2xxx.c
index 5107f58338aff..376b499d6e8eb 100644
--- a/drivers/net/phy/marvell-88q2xxx.c
+++ b/drivers/net/phy/marvell-88q2xxx.c
@@ -95,6 +95,10 @@
 
 #define MDIO_MMD_PCS_MV_TDR_OFF_CUTOFF			65246
 
+struct mv88q2xxx_priv {
+	bool enable_temp;
+};
+
 struct mmd_val {
 	int devad;
 	u32 regnum;
@@ -710,17 +714,12 @@ static const struct hwmon_chip_info mv88q2xxx_hwmon_chip_info = {
 
 static int mv88q2xxx_hwmon_probe(struct phy_device *phydev)
 {
+	struct mv88q2xxx_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	struct device *hwmon;
 	char *hwmon_name;
-	int ret;
-
-	/* Enable temperature sense */
-	ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, MDIO_MMD_PCS_MV_TEMP_SENSOR2,
-			     MDIO_MMD_PCS_MV_TEMP_SENSOR2_DIS_MASK, 0);
-	if (ret < 0)
-		return ret;
 
+	priv->enable_temp = true;
 	hwmon_name = devm_hwmon_sanitize_name(dev, dev_name(dev));
 	if (IS_ERR(hwmon_name))
 		return PTR_ERR(hwmon_name);
@@ -743,6 +742,14 @@ static int mv88q2xxx_hwmon_probe(struct phy_device *phydev)
 
 static int mv88q2xxx_probe(struct phy_device *phydev)
 {
+	struct mv88q2xxx_priv *priv;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
 	return mv88q2xxx_hwmon_probe(phydev);
 }
 
@@ -810,6 +817,18 @@ static int mv88q222x_revb1_revb2_config_init(struct phy_device *phydev)
 
 static int mv88q222x_config_init(struct phy_device *phydev)
 {
+	struct mv88q2xxx_priv *priv = phydev->priv;
+	int ret;
+
+	/* Enable temperature sense */
+	if (priv->enable_temp) {
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
+				     MDIO_MMD_PCS_MV_TEMP_SENSOR2,
+				     MDIO_MMD_PCS_MV_TEMP_SENSOR2_DIS_MASK, 0);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] == PHY_ID_88Q2220_REVB0)
 		return mv88q222x_revb0_config_init(phydev);
 	else
-- 
2.39.5



