Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BC8BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AD2C433EF;
	Tue,  7 Mar 2023 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213010;
	bh=hNvETghRVz4SEq0n1aQcQLBjG7OwrPLlrJwjTSqg3J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEYHo5mvfmiCIH+NY0suiuCbyX/VCXTRh6v4El4EnHDF6SVvDxdK8kUX+sFHgdOrx
	 GYYydSBoymjLEWvuWERjOO8sdaeYHhmM83Mk3GkqocVbVVjnZKoi+Khn4x6Xx+tH4H
	 /eN5BKNhe6apWHW/Efjuw7e2UWhZsYBzkOAviLUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Neanne <jneanne@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/885] regulator: tps65219: use generic set_bypass()
Date: Tue,  7 Mar 2023 17:54:36 +0100
Message-Id: <20230307170017.079788528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerome Neanne <jneanne@baylibre.com>

[ Upstream commit 0365df81145a4cfaae5f4da896160de512256e6d ]

Due to wrong interpretation of the specification,
custom implementation was used instead of standard regmap helper.
LINK: https://lore.kernel.org/all/c2014039-f1e8-6976-33d6-52e2dd4e7b66@baylibre.com/

Fixes: c12ac5fc3e0a ("regulator: drivers: Add TI TPS65219 PMIC regulators support")

Regulator does NOT require to be off to be switched to bypass mode.

Signed-off-by: Jerome Neanne <jneanne@baylibre.com>
Link: https://lore.kernel.org/r/20230203140119.13029-1-jneanne@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65219-regulator.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/regulator/tps65219-regulator.c b/drivers/regulator/tps65219-regulator.c
index 070159cb5f094..58f6541b6417b 100644
--- a/drivers/regulator/tps65219-regulator.c
+++ b/drivers/regulator/tps65219-regulator.c
@@ -173,24 +173,6 @@ static unsigned int tps65219_get_mode(struct regulator_dev *dev)
 		return REGULATOR_MODE_NORMAL;
 }
 
-/*
- * generic regulator_set_bypass_regmap does not fully match requirements
- * TPS65219 Requires explicitly that regulator is disabled before switch
- */
-static int tps65219_set_bypass(struct regulator_dev *dev, bool enable)
-{
-	struct tps65219 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
-
-	if (dev->desc->ops->is_enabled(dev)) {
-		dev_err(tps->dev,
-			"%s LDO%d enabled, must be shut down to set bypass ",
-			__func__, rid);
-		return -EBUSY;
-	}
-	return regulator_set_bypass_regmap(dev, enable);
-}
-
 /* Operations permitted on BUCK1/2/3 */
 static const struct regulator_ops tps65219_bucks_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
@@ -217,7 +199,7 @@ static const struct regulator_ops tps65219_ldos_1_2_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= regulator_list_voltage_linear_range,
 	.map_voltage		= regulator_map_voltage_linear_range,
-	.set_bypass		= tps65219_set_bypass,
+	.set_bypass		= regulator_set_bypass_regmap,
 	.get_bypass		= regulator_get_bypass_regmap,
 };
 
-- 
2.39.2



