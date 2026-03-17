Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0F2FFDEA;
	Tue, 17 Mar 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767538; cv=none; b=p4mohg/JR82zTS//wlmv/kA+SqNMIb7fGiuSeYpn1Vg3KUCGycdsfJMtRF2j9Z32VvSP+nnIzs9BT/HxyT15xm7TwxE11kenTuhlmzQJ4saCdp+PWBgf09tEm1Hn8EcVultimmks1eNo7LbMz3S/3chhKznAHvqZ4txXLQGt3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767538; c=relaxed/simple;
	bh=Lrpve8x1iUlwSV9aG+96a7+Wt+fUmMnCE5HUUsvep30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7k9L6ZHVmmbD1wqGk5evsbMSYCTHJjwFrsjOxbMspLcaxMuZRx1+kdzup4zKq4Z6qYmdmn6p22c1rfA0xAHae7bsgDX1oDe6Bc0m2GrLnbyubDUNNuM6427NciJgyRJxMfYfxcgvE/hl1Ye1ijwrj7zJPQXDThOl5eeUK5OF/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHEnsF+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHEnsF+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46493C4CEF7;
	Tue, 17 Mar 2026 17:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767538;
	bh=Lrpve8x1iUlwSV9aG+96a7+Wt+fUmMnCE5HUUsvep30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHEnsF+Lmi+qWGjaGOSjee0xR0RdIK5SPAlUC5zrXagIdN9uQwKWVkMOFIeeSL29F
	 hPr/+x4iasism9n/ZWZh+/Ez3j701qS92BPRYMfqf9Fk/NRv9LgDiacNpVZ452hPaD
	 mKqVS57oE2H4kN7kxx/O4rsvgyog/8AC13ZIWWOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/333] regulator: pca9450: Add support for setting debounce settings
Date: Tue, 17 Mar 2026 17:31:44 +0100
Message-ID: <20260317163002.157355107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>

[ Upstream commit d9d0be59be2580f2c5e4b7217aafb980e8c371cf ]

Make the different debounce timers configurable from the devicetree.
Depending on the board design, these have to be set different than the
default register values.

Signed-off-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Link: https://patch.msgid.link/20251117202215.1936139-2-martijn.de.gouw@prodrive-technologies.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 21b3fb7dc19c ("regulator: pca9450: Correct probed name for PCA9452")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 158 ++++++++++++++++++++++----
 include/linux/regulator/pca9450.h     |  32 ++++++
 2 files changed, 171 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 086ea88413828..95632b1e8ce4c 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -1117,6 +1117,143 @@ static int pca9450_i2c_restart_handler(struct sys_off_data *data)
 	return 0;
 }
 
+static int pca9450_of_init(struct pca9450 *pca9450)
+{
+	struct i2c_client *i2c = container_of(pca9450->dev, struct i2c_client, dev);
+	int ret;
+	unsigned int val;
+	unsigned int reset_ctrl;
+	unsigned int rstb_deb_ctrl;
+	unsigned int t_on_deb, t_off_deb;
+	unsigned int t_on_step, t_off_step;
+	unsigned int t_restart;
+
+	if (of_property_read_bool(i2c->dev.of_node, "nxp,wdog_b-warm-reset"))
+		reset_ctrl = WDOG_B_CFG_WARM;
+	else
+		reset_ctrl = WDOG_B_CFG_COLD_LDO12;
+
+	/* Set reset behavior on assertion of WDOG_B signal */
+	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
+				 WDOG_B_CFG_MASK, reset_ctrl);
+	if (ret)
+		return dev_err_probe(&i2c->dev, ret, "Failed to set WDOG_B reset behavior\n");
+
+	ret = of_property_read_u32(i2c->dev.of_node, "npx,pmic-rst-b-debounce-ms", &val);
+	if (ret == -EINVAL)
+		rstb_deb_ctrl = T_PMIC_RST_DEB_50MS;
+	else if (ret)
+		return ret;
+	else {
+		switch (val) {
+		case 10: rstb_deb_ctrl = T_PMIC_RST_DEB_10MS; break;
+		case 50: rstb_deb_ctrl = T_PMIC_RST_DEB_50MS; break;
+		case 100: rstb_deb_ctrl = T_PMIC_RST_DEB_100MS; break;
+		case 500: rstb_deb_ctrl = T_PMIC_RST_DEB_500MS; break;
+		case 1000: rstb_deb_ctrl = T_PMIC_RST_DEB_1S; break;
+		case 2000: rstb_deb_ctrl = T_PMIC_RST_DEB_2S; break;
+		case 4000: rstb_deb_ctrl = T_PMIC_RST_DEB_4S; break;
+		case 8000: rstb_deb_ctrl = T_PMIC_RST_DEB_8S; break;
+		default: return -EINVAL;
+		}
+	}
+	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
+				 T_PMIC_RST_DEB_MASK, rstb_deb_ctrl);
+	if (ret)
+		return dev_err_probe(&i2c->dev, ret, "Failed to set PMIC_RST_B debounce time\n");
+
+	ret = of_property_read_u32(i2c->dev.of_node, "nxp,pmic-on-req-on-debounce-us", &val);
+	if (ret == -EINVAL)
+		t_on_deb = T_ON_DEB_20MS;
+	else if (ret)
+		return ret;
+	else {
+		switch (val) {
+		case 120: t_on_deb = T_ON_DEB_120US; break;
+		case 20000: t_on_deb = T_ON_DEB_20MS; break;
+		case 100000: t_on_deb = T_ON_DEB_100MS; break;
+		case 750000: t_on_deb = T_ON_DEB_750MS; break;
+		default: return -EINVAL;
+		}
+	}
+
+	ret = of_property_read_u32(i2c->dev.of_node, "nxp,pmic-on-req-off-debounce-us", &val);
+	if (ret == -EINVAL)
+		t_off_deb = T_OFF_DEB_120US;
+	else if (ret)
+		return ret;
+	else {
+		switch (val) {
+		case 120: t_off_deb = T_OFF_DEB_120US; break;
+		case 2000: t_off_deb = T_OFF_DEB_2MS; break;
+		default: return -EINVAL;
+		}
+	}
+
+	ret = of_property_read_u32(i2c->dev.of_node, "nxp,power-on-step-ms", &val);
+	if (ret == -EINVAL)
+		t_on_step = T_ON_STEP_2MS;
+	else if (ret)
+		return ret;
+	else {
+		switch (val) {
+		case 1: t_on_step = T_ON_STEP_1MS; break;
+		case 2: t_on_step = T_ON_STEP_2MS; break;
+		case 4: t_on_step = T_ON_STEP_4MS; break;
+		case 8: t_on_step = T_ON_STEP_8MS; break;
+		default: return -EINVAL;
+		}
+	}
+
+	ret = of_property_read_u32(i2c->dev.of_node, "nxp,power-down-step-ms", &val);
+	if (ret == -EINVAL)
+		t_off_step = T_OFF_STEP_8MS;
+	else if (ret)
+		return ret;
+	else {
+		switch (val) {
+		case 2: t_off_step = T_OFF_STEP_2MS; break;
+		case 4: t_off_step = T_OFF_STEP_4MS; break;
+		case 8: t_off_step = T_OFF_STEP_8MS; break;
+		case 16: t_off_step = T_OFF_STEP_16MS; break;
+		default: return -EINVAL;
+		}
+	}
+
+	ret = of_property_read_u32(i2c->dev.of_node, "nxp,restart-ms", &val);
+	if (ret == -EINVAL)
+		t_restart = T_RESTART_250MS;
+	else if (ret)
+		return ret;
+	else {
+		switch (val) {
+		case 250: t_restart = T_RESTART_250MS; break;
+		case 500: t_restart = T_RESTART_500MS; break;
+		default: return -EINVAL;
+		}
+	}
+
+	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_PWRCTRL,
+				 T_ON_DEB_MASK | T_OFF_DEB_MASK | T_ON_STEP_MASK |
+				 T_OFF_STEP_MASK | T_RESTART_MASK,
+				 t_on_deb | t_off_deb | t_on_step |
+				 t_off_step | t_restart);
+	if (ret)
+		return dev_err_probe(&i2c->dev, ret,
+				     "Failed to set PWR_CTRL debounce configuration\n");
+
+	if (of_property_read_bool(i2c->dev.of_node, "nxp,i2c-lt-enable")) {
+		/* Enable I2C Level Translator */
+		ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_CONFIG2,
+					 I2C_LT_MASK, I2C_LT_ON_STANDBY_RUN);
+		if (ret)
+			return dev_err_probe(&i2c->dev, ret,
+					     "Failed to enable I2C level translator\n");
+	}
+
+	return 0;
+}
+
 static int pca9450_i2c_probe(struct i2c_client *i2c)
 {
 	enum pca9450_chip_type type = (unsigned int)(uintptr_t)
@@ -1126,7 +1263,6 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	struct regulator_dev *ldo5;
 	struct pca9450 *pca9450;
 	unsigned int device_id, i;
-	unsigned int reset_ctrl;
 	int ret;
 
 	pca9450 = devm_kzalloc(&i2c->dev, sizeof(struct pca9450), GFP_KERNEL);
@@ -1224,25 +1360,9 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	if (ret)
 		return dev_err_probe(&i2c->dev, ret,  "Failed to clear PRESET_EN bit\n");
 
-	if (of_property_read_bool(i2c->dev.of_node, "nxp,wdog_b-warm-reset"))
-		reset_ctrl = WDOG_B_CFG_WARM;
-	else
-		reset_ctrl = WDOG_B_CFG_COLD_LDO12;
-
-	/* Set reset behavior on assertion of WDOG_B signal */
-	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_RESET_CTRL,
-				 WDOG_B_CFG_MASK, reset_ctrl);
+	ret = pca9450_of_init(pca9450);
 	if (ret)
-		return dev_err_probe(&i2c->dev, ret, "Failed to set WDOG_B reset behavior\n");
-
-	if (of_property_read_bool(i2c->dev.of_node, "nxp,i2c-lt-enable")) {
-		/* Enable I2C Level Translator */
-		ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_CONFIG2,
-					 I2C_LT_MASK, I2C_LT_ON_STANDBY_RUN);
-		if (ret)
-			return dev_err_probe(&i2c->dev, ret,
-					     "Failed to enable I2C level translator\n");
-	}
+		return dev_err_probe(&i2c->dev, ret, "Unable to parse OF data\n");
 
 	/*
 	 * For LDO5 we need to be able to check the status of the SD_VSEL input in
diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index 85b4fecc10d82..0df8b3c48082f 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -223,12 +223,44 @@ enum {
 #define IRQ_THERM_105			0x02
 #define IRQ_THERM_125			0x01
 
+/* PCA9450_REG_PWRCTRL bits */
+#define T_ON_DEB_MASK			0xC0
+#define T_ON_DEB_120US			(0 << 6)
+#define T_ON_DEB_20MS			(1 << 6)
+#define T_ON_DEB_100MS			(2 << 6)
+#define T_ON_DEB_750MS			(3 << 6)
+#define T_OFF_DEB_MASK			0x20
+#define T_OFF_DEB_120US			(0 << 5)
+#define T_OFF_DEB_2MS			(1 << 5)
+#define T_ON_STEP_MASK			0x18
+#define T_ON_STEP_1MS			(0 << 3)
+#define T_ON_STEP_2MS			(1 << 3)
+#define T_ON_STEP_4MS			(2 << 3)
+#define T_ON_STEP_8MS			(3 << 3)
+#define T_OFF_STEP_MASK			0x06
+#define T_OFF_STEP_2MS			(0 << 1)
+#define T_OFF_STEP_4MS			(1 << 1)
+#define T_OFF_STEP_8MS			(2 << 1)
+#define T_OFF_STEP_16MS			(3 << 1)
+#define T_RESTART_MASK			0x01
+#define T_RESTART_250MS			0
+#define T_RESTART_500MS			1
+
 /* PCA9450_REG_RESET_CTRL bits */
 #define WDOG_B_CFG_MASK			0xC0
 #define WDOG_B_CFG_NONE			0x00
 #define WDOG_B_CFG_WARM			0x40
 #define WDOG_B_CFG_COLD_LDO12		0x80
 #define WDOG_B_CFG_COLD			0xC0
+#define T_PMIC_RST_DEB_MASK		0x07
+#define T_PMIC_RST_DEB_10MS		0x00
+#define T_PMIC_RST_DEB_50MS		0x01
+#define T_PMIC_RST_DEB_100MS		0x02
+#define T_PMIC_RST_DEB_500MS		0x03
+#define T_PMIC_RST_DEB_1S		0x04
+#define T_PMIC_RST_DEB_2S		0x05
+#define T_PMIC_RST_DEB_4S		0x06
+#define T_PMIC_RST_DEB_8S		0x07
 
 /* PCA9450_REG_CONFIG2 bits */
 #define I2C_LT_MASK			0x03
-- 
2.51.0



