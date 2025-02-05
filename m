Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD821E89C;
	Wed,  5 Feb 2025 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767568; cv=none; b=JrUWM5RgBe7TU/5/UXql8zYI4Ywb61JmKvce3U+LLI9fUONg6CSeP8q1/cewiVHcQLaIuB6l6kep634eOo/meabNDrDapUc4Rm2606Y/1j094jPU8BMo6iqYSaCkcfb1dHPPoXTHnRUpp7Rhcn+NkRuQbjZ1yKuSy2c+qwtWi+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767568; c=relaxed/simple;
	bh=PrJVfebRKprNtM6Ry/4/9JkAhmWm0khLBASmV9FvY0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DIbT+bDzXF9FfbsIJMcuN083Q04Mk+/ubYhTPV+K8Mkehsfk0TCeQcWe/qSCkFsvxMcYKnCKGPsDPpMjEqa8lZoj5to/LFCNvd3CZUDXiLnZtaNOcxYvQtIG10FBXgmddfbeKwmMmSPOnNfR1pKMG2b5H9uwC33mufoQuBR4Vio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn6zfz6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn6zfz6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D44C4CEE2;
	Wed,  5 Feb 2025 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767568;
	bh=PrJVfebRKprNtM6Ry/4/9JkAhmWm0khLBASmV9FvY0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn6zfz6gU/yNcJNbmseQ5K0mu2sfeUAhAqen0FTO4/AtmggPpb93EbaJWtd5E8m7y
	 pNAW8kfZVEJ8IF4umnPVQZJJoqkHF57Yxp46S8kCBmX3conTB/m9OBKwl83GYwPGJO
	 1DKGtiEf0DcWtNTUkhS49z+oe0b9i9Nd6qs4Tnq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Dimitri Fedrau <dima.fedrau@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 476/590] net: phy: marvell-88q2xxx: Fix temperature measurement with reset-gpios
Date: Wed,  5 Feb 2025 14:43:51 +0100
Message-ID: <20250205134513.469661915@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c812f16eaa3a8..b3a5a0af19da6 100644
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
@@ -669,17 +673,12 @@ static const struct hwmon_chip_info mv88q2xxx_hwmon_chip_info = {
 
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
@@ -702,6 +701,14 @@ static int mv88q2xxx_hwmon_probe(struct phy_device *phydev)
 
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
 
@@ -792,6 +799,18 @@ static int mv88q222x_revb1_revb2_config_init(struct phy_device *phydev)
 
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



