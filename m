Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21A2208C0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnNi6f2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8456C433CC;
	Mon,  6 Nov 2023 13:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277495;
	bh=ptXE/2f5sEwoMNNzB9DMbCdAXQRp76Js5DLiNykhwYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnNi6f2JIagwJF2YUHWd1HupXYavKvObs/dc9yumkPGJLVrCdWsQRIuMkYIdTPtX5
	 uTvyhJy4giY3I49h2bbiXUUzBMzKxHFwLXPuQjoNlX+x5za11bYp5bGi1knzc1ysZv
	 50MnWH1RXRDKh8jteUtum9ZGtRSr1x0zywSMCje4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Anand Ashok Dumbre <anandash@xilinx.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/95] iio: adc: xilinx: use more devres helpers and remove remove()
Date: Mon,  6 Nov 2023 14:04:10 +0100
Message-ID: <20231106130306.245557597@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 2a9685d1a3b7644ca08d8355fc238b43faef7c3e ]

In order to simplify resource management and error paths in probe() and
entirely drop the remove() callback - use devres helpers wherever
possible. Define devm actions for cancelling the delayed work and
disabling the clock.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Tested-by: Anand Ashok Dumbre <anandash@xilinx.com>
Reviewed-by: Anand Ashok Dumbre <anandash@xilinx.com>
Link: https://lore.kernel.org/r/20201130142759.28216-4-brgl@bgdev.pl
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8d6b3ea4d9ea ("iio: adc: xilinx-xadc: Don't clobber preset voltage/temperature thresholds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-xadc-core.c | 133 ++++++++++++-----------------
 1 file changed, 55 insertions(+), 78 deletions(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index 6f89a97bb127b..fec266682e91d 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -713,11 +713,12 @@ static const struct iio_trigger_ops xadc_trigger_ops = {
 static struct iio_trigger *xadc_alloc_trigger(struct iio_dev *indio_dev,
 	const char *name)
 {
+	struct device *dev = indio_dev->dev.parent;
 	struct iio_trigger *trig;
 	int ret;
 
-	trig = iio_trigger_alloc("%s%d-%s", indio_dev->name,
-				indio_dev->id, name);
+	trig = devm_iio_trigger_alloc(dev, "%s%d-%s", indio_dev->name,
+				      indio_dev->id, name);
 	if (trig == NULL)
 		return ERR_PTR(-ENOMEM);
 
@@ -725,15 +726,11 @@ static struct iio_trigger *xadc_alloc_trigger(struct iio_dev *indio_dev,
 	trig->ops = &xadc_trigger_ops;
 	iio_trigger_set_drvdata(trig, iio_priv(indio_dev));
 
-	ret = iio_trigger_register(trig);
+	ret = devm_iio_trigger_register(dev, trig);
 	if (ret)
-		goto error_free_trig;
+		return ERR_PTR(ret);
 
 	return trig;
-
-error_free_trig:
-	iio_trigger_free(trig);
-	return ERR_PTR(ret);
 }
 
 static int xadc_power_adc_b(struct xadc *xadc, unsigned int seq_mode)
@@ -1192,6 +1189,20 @@ static int xadc_parse_dt(struct iio_dev *indio_dev, struct device_node *np,
 	return 0;
 }
 
+static void xadc_clk_disable_unprepare(void *data)
+{
+	struct clk *clk = data;
+
+	clk_disable_unprepare(clk);
+}
+
+static void xadc_cancel_delayed_work(void *data)
+{
+	struct delayed_work *work = data;
+
+	cancel_delayed_work_sync(work);
+}
+
 static int xadc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1240,34 +1251,35 @@ static int xadc_probe(struct platform_device *pdev)
 		return ret;
 
 	if (xadc->ops->flags & XADC_FLAGS_BUFFERED) {
-		ret = iio_triggered_buffer_setup(indio_dev,
-			&iio_pollfunc_store_time, &xadc_trigger_handler,
-			&xadc_buffer_ops);
+		ret = devm_iio_triggered_buffer_setup(dev, indio_dev,
+						      &iio_pollfunc_store_time,
+						      &xadc_trigger_handler,
+						      &xadc_buffer_ops);
 		if (ret)
 			return ret;
 
 		xadc->convst_trigger = xadc_alloc_trigger(indio_dev, "convst");
-		if (IS_ERR(xadc->convst_trigger)) {
-			ret = PTR_ERR(xadc->convst_trigger);
-			goto err_triggered_buffer_cleanup;
-		}
+		if (IS_ERR(xadc->convst_trigger))
+			return PTR_ERR(xadc->convst_trigger);
+
 		xadc->samplerate_trigger = xadc_alloc_trigger(indio_dev,
 			"samplerate");
-		if (IS_ERR(xadc->samplerate_trigger)) {
-			ret = PTR_ERR(xadc->samplerate_trigger);
-			goto err_free_convst_trigger;
-		}
+		if (IS_ERR(xadc->samplerate_trigger))
+			return PTR_ERR(xadc->samplerate_trigger);
 	}
 
 	xadc->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(xadc->clk)) {
-		ret = PTR_ERR(xadc->clk);
-		goto err_free_samplerate_trigger;
-	}
+	if (IS_ERR(xadc->clk))
+		return PTR_ERR(xadc->clk);
 
 	ret = clk_prepare_enable(xadc->clk);
 	if (ret)
-		goto err_free_samplerate_trigger;
+		return ret;
+
+	ret = devm_add_action_or_reset(dev,
+				       xadc_clk_disable_unprepare, xadc->clk);
+	if (ret)
+		return ret;
 
 	/*
 	 * Make sure not to exceed the maximum samplerate since otherwise the
@@ -1276,22 +1288,28 @@ static int xadc_probe(struct platform_device *pdev)
 	if (xadc->ops->flags & XADC_FLAGS_BUFFERED) {
 		ret = xadc_read_samplerate(xadc);
 		if (ret < 0)
-			goto err_free_samplerate_trigger;
+			return ret;
+
 		if (ret > XADC_MAX_SAMPLERATE) {
 			ret = xadc_write_samplerate(xadc, XADC_MAX_SAMPLERATE);
 			if (ret < 0)
-				goto err_free_samplerate_trigger;
+				return ret;
 		}
 	}
 
-	ret = request_irq(xadc->irq, xadc->ops->interrupt_handler, 0,
-			  dev_name(dev), indio_dev);
+	ret = devm_request_irq(dev, xadc->irq, xadc->ops->interrupt_handler, 0,
+			       dev_name(dev), indio_dev);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action_or_reset(dev, xadc_cancel_delayed_work,
+				       &xadc->zynq_unmask_work);
 	if (ret)
-		goto err_clk_disable_unprepare;
+		return ret;
 
 	ret = xadc->ops->setup(pdev, indio_dev, xadc->irq);
 	if (ret)
-		goto err_free_irq;
+		return ret;
 
 	for (i = 0; i < 16; i++)
 		xadc_read_adc_reg(xadc, XADC_REG_THRESHOLD(i),
@@ -1299,7 +1317,7 @@ static int xadc_probe(struct platform_device *pdev)
 
 	ret = xadc_write_adc_reg(xadc, XADC_REG_CONF0, conf0);
 	if (ret)
-		goto err_free_irq;
+		return ret;
 
 	bipolar_mask = 0;
 	for (i = 0; i < indio_dev->num_channels; i++) {
@@ -1309,17 +1327,18 @@ static int xadc_probe(struct platform_device *pdev)
 
 	ret = xadc_write_adc_reg(xadc, XADC_REG_INPUT_MODE(0), bipolar_mask);
 	if (ret)
-		goto err_free_irq;
+		return ret;
+
 	ret = xadc_write_adc_reg(xadc, XADC_REG_INPUT_MODE(1),
 		bipolar_mask >> 16);
 	if (ret)
-		goto err_free_irq;
+		return ret;
 
 	/* Disable all alarms */
 	ret = xadc_update_adc_reg(xadc, XADC_REG_CONF1, XADC_CONF1_ALARM_MASK,
 				  XADC_CONF1_ALARM_MASK);
 	if (ret)
-		goto err_free_irq;
+		return ret;
 
 	/* Set thresholds to min/max */
 	for (i = 0; i < 16; i++) {
@@ -1334,59 +1353,17 @@ static int xadc_probe(struct platform_device *pdev)
 		ret = xadc_write_adc_reg(xadc, XADC_REG_THRESHOLD(i),
 			xadc->threshold[i]);
 		if (ret)
-			goto err_free_irq;
+			return ret;
 	}
 
 	/* Go to non-buffered mode */
 	xadc_postdisable(indio_dev);
 
-	ret = iio_device_register(indio_dev);
-	if (ret)
-		goto err_free_irq;
-
-	platform_set_drvdata(pdev, indio_dev);
-
-	return 0;
-
-err_free_irq:
-	free_irq(xadc->irq, indio_dev);
-	cancel_delayed_work_sync(&xadc->zynq_unmask_work);
-err_clk_disable_unprepare:
-	clk_disable_unprepare(xadc->clk);
-err_free_samplerate_trigger:
-	if (xadc->ops->flags & XADC_FLAGS_BUFFERED)
-		iio_trigger_free(xadc->samplerate_trigger);
-err_free_convst_trigger:
-	if (xadc->ops->flags & XADC_FLAGS_BUFFERED)
-		iio_trigger_free(xadc->convst_trigger);
-err_triggered_buffer_cleanup:
-	if (xadc->ops->flags & XADC_FLAGS_BUFFERED)
-		iio_triggered_buffer_cleanup(indio_dev);
-
-	return ret;
-}
-
-static int xadc_remove(struct platform_device *pdev)
-{
-	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
-	struct xadc *xadc = iio_priv(indio_dev);
-
-	iio_device_unregister(indio_dev);
-	if (xadc->ops->flags & XADC_FLAGS_BUFFERED) {
-		iio_trigger_free(xadc->samplerate_trigger);
-		iio_trigger_free(xadc->convst_trigger);
-		iio_triggered_buffer_cleanup(indio_dev);
-	}
-	free_irq(xadc->irq, indio_dev);
-	cancel_delayed_work_sync(&xadc->zynq_unmask_work);
-	clk_disable_unprepare(xadc->clk);
-
-	return 0;
+	return devm_iio_device_register(dev, indio_dev);
 }
 
 static struct platform_driver xadc_driver = {
 	.probe = xadc_probe,
-	.remove = xadc_remove,
 	.driver = {
 		.name = "xadc",
 		.of_match_table = xadc_of_match_table,
-- 
2.42.0



