Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20091EE001;
	Tue,  3 Dec 2024 15:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240503; cv=none; b=QI9e7hIpY52KS5MQeSejXL6R9rlECgdc807zQpxQjTju9/60CAffaZBUKwPzETyOmfSkgbtoYrBC79T+IQvK3J+sQvSzie8o88eO0fqz8Rz+mZ6doYlLVNpsOew6lfxAQ4iM47EsDH0b2Th/FX7b3XCPQ8B55nsCwHrU7eXdmnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240503; c=relaxed/simple;
	bh=vSsfiB8NjEv79jM0l7BEd3zU4MMO1n/Ii84xpv19dSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzIu0H7D+KxMt0EQV8S+OmlkF4veCo86+iBAR72q37KZOpwxy+XAwCoujpOgsaFARcDe8lNbGhtulQP41GT9E1Yco1nOK7/TYZlcXXdXvScSfUKsO8KSllBFmLKIvViU+WkNxl1xjMTatpKjcYEZtJuLdNFuTNX4/L012W8BIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbSi0MUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbSi0MUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C635C4CED6;
	Tue,  3 Dec 2024 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240502;
	bh=vSsfiB8NjEv79jM0l7BEd3zU4MMO1n/Ii84xpv19dSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbSi0MUn+XQLFrkkRu8dMEidpznrwJLTRpAvXbLc2Fg9o7vYh/hTxx6ircrQYGqkX
	 bw0CySu+89mv8Jy6Odr2xTRVHf3sWGaXBrWMeBz8smhjuOX0m5ZkI02llzHO1cDBKd
	 +3sIobrUxbnERGe0Mgz1TNcFWIxSqXmCD3lPxuHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/826] regulator: rk808: Restrict DVS GPIOs to the RK808 variant only
Date: Tue,  3 Dec 2024 15:37:44 +0100
Message-ID: <20241203144749.087393560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 0d214f27c0e3d9694284c95bac1502c2d247355b ]

The rk808-regulator driver supports multiple PMIC variants from the Rockckip
RK80x and RK81x series, but the DVS GPIOs are supported on the RK808 variant
only, according to the DT bindings [1][2][3][4][5][6] and the datasheets for
the supported PMIC variants. [7][8][9][10][11][12]

Thus, change the probe path so the "dvs-gpios" property is checked for and
its value possibly used only when the handled PMIC variant is RK808.  There's
no point in doing that on the other PMIC variants, because they don't support
the DVS GPIOs, and it goes against the DT bindings to allow a possible out-
of-place "dvs-gpios" property to actually be handled in the driver.

This eliminates the following messages, emitted when the "dvs-gpios" property
isn't found in the DT, from the kernel log on boards that actually don't use
the RK808 variant, which may have provided a source of confusion:

  rk808-regulator rk808-regulator.2.auto: there is no dvs0 gpio
  rk808-regulator rk808-regulator.2.auto: there is no dvs1 gpio

Furthermore, demote these kernel messages to debug messages, because they are
useful during the board bringup phase only.  Emitting them afterwards, on the
boards that use the RK808 variant, but actually don't use the DVS0/1 GPIOs,
clutters the kernel log a bit, while they provide no value and may actually
cause false impression that some PMIC-related issues are present.

[1] Documentation/devicetree/bindings/mfd/rockchip,rk805.yaml
[2] Documentation/devicetree/bindings/mfd/rockchip,rk806.yaml
[3] Documentation/devicetree/bindings/mfd/rockchip,rk808.yaml
[4] Documentation/devicetree/bindings/mfd/rockchip,rk816.yaml
[5] Documentation/devicetree/bindings/mfd/rockchip,rk817.yaml
[6] Documentation/devicetree/bindings/mfd/rockchip,rk818.yaml
[7] https://rockchip.fr/RK805%20datasheet%20V1.2.pdf
[8] https://wmsc.lcsc.com/wmsc/upload/file/pdf/v2/lcsc/2401261533_Rockchip-RK806-1_C5156483.pdf
[9] https://rockchip.fr/RK808%20datasheet%20V1.4.pdf
[10] https://rockchip.fr/RK816%20datasheet%20V1.3.pdf
[11] https://rockchip.fr/RK817%20datasheet%20V1.01.pdf
[12] https://rockchip.fr/RK818%20datasheet%20V1.0.pdf

Fixes: 11375293530b ("regulator: rk808: Add regulator driver for RK818")
Reported-by: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://patch.msgid.link/9a415c59699e76fc7b88a2552520a4ca2538f44e.1728902488.git.dsimic@manjaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rk808-regulator.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 01a8d04879184..37476d2558fda 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -1853,7 +1853,7 @@ static int rk808_regulator_dt_parse_pdata(struct device *dev,
 		}
 
 		if (!pdata->dvs_gpio[i]) {
-			dev_info(dev, "there is no dvs%d gpio\n", i);
+			dev_dbg(dev, "there is no dvs%d gpio\n", i);
 			continue;
 		}
 
@@ -1889,12 +1889,6 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENOMEM;
 
-	ret = rk808_regulator_dt_parse_pdata(&pdev->dev, regmap, pdata);
-	if (ret < 0)
-		return ret;
-
-	platform_set_drvdata(pdev, pdata);
-
 	switch (rk808->variant) {
 	case RK805_ID:
 		regulators = rk805_reg;
@@ -1905,6 +1899,11 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 		nregulators = ARRAY_SIZE(rk806_reg);
 		break;
 	case RK808_ID:
+		/* DVS0/1 GPIOs are supported on the RK808 only */
+		ret = rk808_regulator_dt_parse_pdata(&pdev->dev, regmap, pdata);
+		if (ret < 0)
+			return ret;
+
 		regulators = rk808_reg;
 		nregulators = RK808_NUM_REGULATORS;
 		break;
@@ -1930,6 +1929,8 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	platform_set_drvdata(pdev, pdata);
+
 	config.dev = &pdev->dev;
 	config.driver_data = pdata;
 	config.regmap = regmap;
-- 
2.43.0



