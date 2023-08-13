Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9809443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EACC433C7;
	Sun, 13 Aug 2023 21:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961980;
	bh=pAeolN8alaRCU84jUPivZxzyrycsbPuf/VD+92SShg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjRpnbrLZEX8Od7tWcsUIZoqSh8MX2A2IB9oPLNs8wneBVWuX9ZEjOXA7Lab5hbiq
	 fsHuV6ja+y3agd3Mh77vy14kQHvzNHRhhwcDHqVuxBSsqLT3LMtBeeW8D95lacU0WN
	 Ja1f/vSUpwt3137IUHn/8UiDLObnqAQsmOayHbXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@sberdevices.ru>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 069/206] iio: adc: meson: fix core clock enable/disable moment
Date: Sun, 13 Aug 2023 23:17:19 +0200
Message-ID: <20230813211727.048805145@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Stark <gnstark@sberdevices.ru>

commit 09738ccbc4148c62d6c8c4644ff4a099d57f49ad upstream.

Enable core clock at probe stage and disable it at remove stage.
Core clock is responsible for turning on/off the entire SoC module so
it should be on before the first module register is touched and be off
at very last moment.

Fixes: 3adbf3427330 ("iio: adc: add a driver for the SAR ADC found in Amlogic Meson SoCs")
Signed-off-by: George Stark <gnstark@sberdevices.ru>
Link: https://lore.kernel.org/r/20230721102413.255726-2-gnstark@sberdevices.ru
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/meson_saradc.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/iio/adc/meson_saradc.c
+++ b/drivers/iio/adc/meson_saradc.c
@@ -916,12 +916,6 @@ static int meson_sar_adc_hw_enable(struc
 		goto err_vref;
 	}
 
-	ret = clk_prepare_enable(priv->core_clk);
-	if (ret) {
-		dev_err(dev, "failed to enable core clk\n");
-		goto err_core_clk;
-	}
-
 	regval = FIELD_PREP(MESON_SAR_ADC_REG0_FIFO_CNT_IRQ_MASK, 1);
 	regmap_update_bits(priv->regmap, MESON_SAR_ADC_REG0,
 			   MESON_SAR_ADC_REG0_FIFO_CNT_IRQ_MASK, regval);
@@ -948,8 +942,6 @@ err_adc_clk:
 	regmap_update_bits(priv->regmap, MESON_SAR_ADC_REG3,
 			   MESON_SAR_ADC_REG3_ADC_EN, 0);
 	meson_sar_adc_set_bandgap(indio_dev, false);
-	clk_disable_unprepare(priv->core_clk);
-err_core_clk:
 	regulator_disable(priv->vref);
 err_vref:
 	meson_sar_adc_unlock(indio_dev);
@@ -977,8 +969,6 @@ static void meson_sar_adc_hw_disable(str
 
 	meson_sar_adc_set_bandgap(indio_dev, false);
 
-	clk_disable_unprepare(priv->core_clk);
-
 	regulator_disable(priv->vref);
 
 	if (!ret)
@@ -1211,7 +1201,7 @@ static int meson_sar_adc_probe(struct pl
 	if (IS_ERR(priv->clkin))
 		return dev_err_probe(dev, PTR_ERR(priv->clkin), "failed to get clkin\n");
 
-	priv->core_clk = devm_clk_get(dev, "core");
+	priv->core_clk = devm_clk_get_enabled(dev, "core");
 	if (IS_ERR(priv->core_clk))
 		return dev_err_probe(dev, PTR_ERR(priv->core_clk), "failed to get core clk\n");
 
@@ -1294,15 +1284,26 @@ static int meson_sar_adc_remove(struct p
 static int meson_sar_adc_suspend(struct device *dev)
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct meson_sar_adc_priv *priv = iio_priv(indio_dev);
 
 	meson_sar_adc_hw_disable(indio_dev);
 
+	clk_disable_unprepare(priv->core_clk);
+
 	return 0;
 }
 
 static int meson_sar_adc_resume(struct device *dev)
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct meson_sar_adc_priv *priv = iio_priv(indio_dev);
+	int ret;
+
+	ret = clk_prepare_enable(priv->core_clk);
+	if (ret) {
+		dev_err(dev, "failed to enable core clk\n");
+		return ret;
+	}
 
 	return meson_sar_adc_hw_enable(indio_dev);
 }


