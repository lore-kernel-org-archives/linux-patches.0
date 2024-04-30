Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C60812C490;
	Tue, 30 Apr 2024 11:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475303; cv=none; b=st5E8zmdpE7vyJPYwxyBH9h+1IT0d+Xy2mNmLlzpCWzqy+Bj4OFNXx7nShE7oDd6W4W44GXlOmknDfkszzfAyDh3pbeTbJ7i7d8s46as8VDL5jhlrTJNDuQ5f1fpdQK3prhX5RS3U/Q6Wr32j5Nnm6tM0+t+VXPjjPusIL/WvMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475303; c=relaxed/simple;
	bh=jWMRoEfma6T1owyML03AsWhQcJ96NXZJKzD/nuKJeis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCqPx0TDluQwxo0Y+GwkQg1+w+Iv4J9tgc0d2VKQ0h/8cm6JaSuUtbgEnnzVx4GFQKlg0pqlMVFqihSZaFUneg/8jh4xrqTvpYxPqW4iEHcY4Tebl06bfSuEaptpxYcnfyPC2wSlOeM0+0pcgZLak4uQMBi6kIjRO19EpE+GExU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6FsjlP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6FsjlP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8891C2BBFC;
	Tue, 30 Apr 2024 11:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475303;
	bh=jWMRoEfma6T1owyML03AsWhQcJ96NXZJKzD/nuKJeis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6FsjlP41voeI7SM5kGC/G2F4myoQ8G508gXRxSmDVuIcFbz8W3lBa8fk/gFnD7P6
	 VwLu6i5afo9FWMIg54oXvAg/3t9fFHK4Dic2eV/9E5XeibQAETCo9oiHiz8UhN2e6R
	 0xYy5m0vFSa986JHz8DK9w1GnXiI0R6J5AX/onOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul_geurts@live.nl>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/186] NFC: trf7970a: disable all regulators on removal
Date: Tue, 30 Apr 2024 12:38:28 +0200
Message-ID: <20240430103059.666675892@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Geurts <paul_geurts@live.nl>

[ Upstream commit 6bea4f03c6a4e973ef369e15aac88f37981db49e ]

During module probe, regulator 'vin' and 'vdd-io' are used and enabled,
but the vdd-io regulator overwrites the 'vin' regulator pointer. During
remove, only the vdd-io is disabled, as the vin regulator pointer is not
available anymore. When regulator_put() is called during resource
cleanup a kernel warning is given, as the regulator is still enabled.

Store the two regulators in separate pointers and disable both the
regulators on module remove.

Fixes: 49d22c70aaf0 ("NFC: trf7970a: Add device tree option of 1.8 Volt IO voltage")
Signed-off-by: Paul Geurts <paul_geurts@live.nl>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/DB7PR09MB26847A4EBF88D9EDFEB1DA0F950E2@DB7PR09MB2684.eurprd09.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/trf7970a.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 7eb17f46a8153..9e1a34e23af26 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -424,7 +424,8 @@ struct trf7970a {
 	enum trf7970a_state		state;
 	struct device			*dev;
 	struct spi_device		*spi;
-	struct regulator		*regulator;
+	struct regulator		*vin_regulator;
+	struct regulator		*vddio_regulator;
 	struct nfc_digital_dev		*ddev;
 	u32				quirks;
 	bool				is_initiator;
@@ -1883,7 +1884,7 @@ static int trf7970a_power_up(struct trf7970a *trf)
 	if (trf->state != TRF7970A_ST_PWR_OFF)
 		return 0;
 
-	ret = regulator_enable(trf->regulator);
+	ret = regulator_enable(trf->vin_regulator);
 	if (ret) {
 		dev_err(trf->dev, "%s - Can't enable VIN: %d\n", __func__, ret);
 		return ret;
@@ -1926,7 +1927,7 @@ static int trf7970a_power_down(struct trf7970a *trf)
 	if (trf->en2_gpiod && !(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW))
 		gpiod_set_value_cansleep(trf->en2_gpiod, 0);
 
-	ret = regulator_disable(trf->regulator);
+	ret = regulator_disable(trf->vin_regulator);
 	if (ret)
 		dev_err(trf->dev, "%s - Can't disable VIN: %d\n", __func__,
 			ret);
@@ -2065,37 +2066,37 @@ static int trf7970a_probe(struct spi_device *spi)
 	mutex_init(&trf->lock);
 	INIT_DELAYED_WORK(&trf->timeout_work, trf7970a_timeout_work_handler);
 
-	trf->regulator = devm_regulator_get(&spi->dev, "vin");
-	if (IS_ERR(trf->regulator)) {
-		ret = PTR_ERR(trf->regulator);
+	trf->vin_regulator = devm_regulator_get(&spi->dev, "vin");
+	if (IS_ERR(trf->vin_regulator)) {
+		ret = PTR_ERR(trf->vin_regulator);
 		dev_err(trf->dev, "Can't get VIN regulator: %d\n", ret);
 		goto err_destroy_lock;
 	}
 
-	ret = regulator_enable(trf->regulator);
+	ret = regulator_enable(trf->vin_regulator);
 	if (ret) {
 		dev_err(trf->dev, "Can't enable VIN: %d\n", ret);
 		goto err_destroy_lock;
 	}
 
-	uvolts = regulator_get_voltage(trf->regulator);
+	uvolts = regulator_get_voltage(trf->vin_regulator);
 	if (uvolts > 4000000)
 		trf->chip_status_ctrl = TRF7970A_CHIP_STATUS_VRS5_3;
 
-	trf->regulator = devm_regulator_get(&spi->dev, "vdd-io");
-	if (IS_ERR(trf->regulator)) {
-		ret = PTR_ERR(trf->regulator);
+	trf->vddio_regulator = devm_regulator_get(&spi->dev, "vdd-io");
+	if (IS_ERR(trf->vddio_regulator)) {
+		ret = PTR_ERR(trf->vddio_regulator);
 		dev_err(trf->dev, "Can't get VDD_IO regulator: %d\n", ret);
-		goto err_destroy_lock;
+		goto err_disable_vin_regulator;
 	}
 
-	ret = regulator_enable(trf->regulator);
+	ret = regulator_enable(trf->vddio_regulator);
 	if (ret) {
 		dev_err(trf->dev, "Can't enable VDD_IO: %d\n", ret);
-		goto err_destroy_lock;
+		goto err_disable_vin_regulator;
 	}
 
-	if (regulator_get_voltage(trf->regulator) == 1800000) {
+	if (regulator_get_voltage(trf->vddio_regulator) == 1800000) {
 		trf->io_ctrl = TRF7970A_REG_IO_CTRL_IO_LOW;
 		dev_dbg(trf->dev, "trf7970a config vdd_io to 1.8V\n");
 	}
@@ -2108,7 +2109,7 @@ static int trf7970a_probe(struct spi_device *spi)
 	if (!trf->ddev) {
 		dev_err(trf->dev, "Can't allocate NFC digital device\n");
 		ret = -ENOMEM;
-		goto err_disable_regulator;
+		goto err_disable_vddio_regulator;
 	}
 
 	nfc_digital_set_parent_dev(trf->ddev, trf->dev);
@@ -2137,8 +2138,10 @@ static int trf7970a_probe(struct spi_device *spi)
 	trf7970a_shutdown(trf);
 err_free_ddev:
 	nfc_digital_free_device(trf->ddev);
-err_disable_regulator:
-	regulator_disable(trf->regulator);
+err_disable_vddio_regulator:
+	regulator_disable(trf->vddio_regulator);
+err_disable_vin_regulator:
+	regulator_disable(trf->vin_regulator);
 err_destroy_lock:
 	mutex_destroy(&trf->lock);
 	return ret;
@@ -2157,7 +2160,8 @@ static void trf7970a_remove(struct spi_device *spi)
 	nfc_digital_unregister_device(trf->ddev);
 	nfc_digital_free_device(trf->ddev);
 
-	regulator_disable(trf->regulator);
+	regulator_disable(trf->vddio_regulator);
+	regulator_disable(trf->vin_regulator);
 
 	mutex_destroy(&trf->lock);
 }
-- 
2.43.0



