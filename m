Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289B33CD9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXhK8Sem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D67AC433C8;
	Wed, 15 Nov 2023 19:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076676;
	bh=7nUzrjnsXfso+XpOryzO7NbBTzGaNc/0dgxBnA+nuHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXhK8SemBNH+0M2bua2n+gp03z1JRoP6Nm/7oO53ltcTCEkxO5ga2CJOomX2bsYSb
	 8xP7yvSKF7tebq1vEGpDFYFsMxCxoLWfyksA/Rg0hlZVaJXyixk9vlhSFFue1ODiXv
	 j6csPYotSI5VEYrhfiH7rThhWThkfQgDgpLXUBck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 378/550] iio: frequency: adf4350: Use device managed functions and fix power down issue.
Date: Wed, 15 Nov 2023 14:16:02 -0500
Message-ID: <20231115191627.031218800@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 9979cc64853b598518a485c2e554657d5c7a00c8 ]

The devm_clk_get_enabled() helper:
    - calls devm_clk_get()
    - calls clk_prepare_enable() and registers what is needed in order to
      call clk_disable_unprepare() when needed, as a managed resource.

Also replace devm_regulator_get() and regulator_enable() with
devm_regulator_get_enable() helper and remove regulator_disable().

Replace iio_device_register() with devm_iio_device_register() and remove
iio_device_unregister().

And st->reg is not used anymore, so remove it.

As Jonathan pointed out, couple of things that are wrong:

1) The device is powered down 'before' we unregister it with the
   subsystem and as such userspace interfaces are still exposed which
   probably won't do the right thing if the chip is powered down.

2) This isn't done in the error paths in probe.

To solve this problem, register a new callback adf4350_power_down()
with devm_add_action_or_reset(), to enable software power down in both
error and device detach path. So the remove function can be removed.

Remove spi_set_drvdata() from the probe function, since spi_get_drvdata()
is not used anymore.

Fixes: e31166f0fd48 ("iio: frequency: New driver for Analog Devices ADF4350/ADF4351 Wideband Synthesizers")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230828062717.2310219-1-ruanjinjie@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adf4350.c | 75 ++++++++++-----------------------
 1 file changed, 23 insertions(+), 52 deletions(-)

diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
index 85e289700c3c5..4abf80f75ef5d 100644
--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -33,7 +33,6 @@ enum {
 
 struct adf4350_state {
 	struct spi_device		*spi;
-	struct regulator		*reg;
 	struct gpio_desc		*lock_detect_gpiod;
 	struct adf4350_platform_data	*pdata;
 	struct clk			*clk;
@@ -469,6 +468,15 @@ static struct adf4350_platform_data *adf4350_parse_dt(struct device *dev)
 	return pdata;
 }
 
+static void adf4350_power_down(void *data)
+{
+	struct iio_dev *indio_dev = data;
+	struct adf4350_state *st = iio_priv(indio_dev);
+
+	st->regs[ADF4350_REG2] |= ADF4350_REG2_POWER_DOWN_EN;
+	adf4350_sync_config(st);
+}
+
 static int adf4350_probe(struct spi_device *spi)
 {
 	struct adf4350_platform_data *pdata;
@@ -491,31 +499,21 @@ static int adf4350_probe(struct spi_device *spi)
 	}
 
 	if (!pdata->clkin) {
-		clk = devm_clk_get(&spi->dev, "clkin");
+		clk = devm_clk_get_enabled(&spi->dev, "clkin");
 		if (IS_ERR(clk))
-			return -EPROBE_DEFER;
-
-		ret = clk_prepare_enable(clk);
-		if (ret < 0)
-			return ret;
+			return PTR_ERR(clk);
 	}
 
 	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
-	if (indio_dev == NULL) {
-		ret =  -ENOMEM;
-		goto error_disable_clk;
-	}
+	if (indio_dev == NULL)
+		return -ENOMEM;
 
 	st = iio_priv(indio_dev);
 
-	st->reg = devm_regulator_get(&spi->dev, "vcc");
-	if (!IS_ERR(st->reg)) {
-		ret = regulator_enable(st->reg);
-		if (ret)
-			goto error_disable_clk;
-	}
+	ret = devm_regulator_get_enable(&spi->dev, "vcc");
+	if (ret)
+		return ret;
 
-	spi_set_drvdata(spi, indio_dev);
 	st->spi = spi;
 	st->pdata = pdata;
 
@@ -544,47 +542,21 @@ static int adf4350_probe(struct spi_device *spi)
 
 	st->lock_detect_gpiod = devm_gpiod_get_optional(&spi->dev, NULL,
 							GPIOD_IN);
-	if (IS_ERR(st->lock_detect_gpiod)) {
-		ret = PTR_ERR(st->lock_detect_gpiod);
-		goto error_disable_reg;
-	}
+	if (IS_ERR(st->lock_detect_gpiod))
+		return PTR_ERR(st->lock_detect_gpiod);
 
 	if (pdata->power_up_frequency) {
 		ret = adf4350_set_freq(st, pdata->power_up_frequency);
 		if (ret)
-			goto error_disable_reg;
+			return ret;
 	}
 
-	ret = iio_device_register(indio_dev);
+	ret = devm_add_action_or_reset(&spi->dev, adf4350_power_down, indio_dev);
 	if (ret)
-		goto error_disable_reg;
-
-	return 0;
-
-error_disable_reg:
-	if (!IS_ERR(st->reg))
-		regulator_disable(st->reg);
-error_disable_clk:
-	clk_disable_unprepare(clk);
-
-	return ret;
-}
-
-static void adf4350_remove(struct spi_device *spi)
-{
-	struct iio_dev *indio_dev = spi_get_drvdata(spi);
-	struct adf4350_state *st = iio_priv(indio_dev);
-	struct regulator *reg = st->reg;
-
-	st->regs[ADF4350_REG2] |= ADF4350_REG2_POWER_DOWN_EN;
-	adf4350_sync_config(st);
-
-	iio_device_unregister(indio_dev);
-
-	clk_disable_unprepare(st->clk);
+		return dev_err_probe(&spi->dev, ret,
+				     "Failed to add action to managed power down\n");
 
-	if (!IS_ERR(reg))
-		regulator_disable(reg);
+	return devm_iio_device_register(&spi->dev, indio_dev);
 }
 
 static const struct of_device_id adf4350_of_match[] = {
@@ -607,7 +579,6 @@ static struct spi_driver adf4350_driver = {
 		.of_match_table = adf4350_of_match,
 	},
 	.probe		= adf4350_probe,
-	.remove		= adf4350_remove,
 	.id_table	= adf4350_id,
 };
 module_spi_driver(adf4350_driver);
-- 
2.42.0



