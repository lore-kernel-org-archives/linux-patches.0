Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DE7D507
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B97C433D2;
	Mon, 15 May 2023 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173524;
	bh=XFmwQPBp075IrwiZSMqUh8QW5dwqOujOVStZgkr7jQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b375hxa8FVusLesSRCK543dnvAX7ooZ5o6tR0Ch506+4eTpKuayZAw/ppZb0Ay408
	 lNTK54BNkG0vXwQQVm7S7hSFTSNgww+rNGf/i0tM7zLBuzeh1UjyYZJTFjquUKmWIp
	 8WUfQmb271sfzTbfh8zSMSb1rqe3VO0PQd2Jgyjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/282] spi: imx: enable runtime pm support
Date: Mon, 15 May 2023 18:28:20 +0200
Message-Id: <20230515161725.892619304@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 525c9e5a32bd7951eae3f06d9d077fea51718a6c ]

Enable runtime pm support for spi-imx driver.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Link: https://lore.kernel.org/r/20200727063354.17031-1-xiaoning.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 11951c9e3f36 ("spi: imx: Don't skip cleanup in remove's error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 121 ++++++++++++++++++++++++++++++------------
 1 file changed, 88 insertions(+), 33 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 90793fc321358..95f1746a85d9d 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -13,7 +13,9 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
@@ -30,6 +32,8 @@ static bool use_dma = true;
 module_param(use_dma, bool, 0644);
 MODULE_PARM_DESC(use_dma, "Enable usage of DMA when available (default)");
 
+#define MXC_RPM_TIMEOUT		2000 /* 2000ms */
+
 #define MXC_CSPIRXDATA		0x00
 #define MXC_CSPITXDATA		0x04
 #define MXC_CSPICTRL		0x08
@@ -1532,20 +1536,16 @@ spi_imx_prepare_message(struct spi_master *master, struct spi_message *msg)
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
 	int ret;
 
-	ret = clk_enable(spi_imx->clk_per);
-	if (ret)
-		return ret;
-
-	ret = clk_enable(spi_imx->clk_ipg);
-	if (ret) {
-		clk_disable(spi_imx->clk_per);
+	ret = pm_runtime_get_sync(spi_imx->dev);
+	if (ret < 0) {
+		dev_err(spi_imx->dev, "failed to enable clock\n");
 		return ret;
 	}
 
 	ret = spi_imx->devtype_data->prepare_message(spi_imx, msg);
 	if (ret) {
-		clk_disable(spi_imx->clk_ipg);
-		clk_disable(spi_imx->clk_per);
+		pm_runtime_mark_last_busy(spi_imx->dev);
+		pm_runtime_put_autosuspend(spi_imx->dev);
 	}
 
 	return ret;
@@ -1556,8 +1556,8 @@ spi_imx_unprepare_message(struct spi_master *master, struct spi_message *msg)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
 
-	clk_disable(spi_imx->clk_ipg);
-	clk_disable(spi_imx->clk_per);
+	pm_runtime_mark_last_busy(spi_imx->dev);
+	pm_runtime_put_autosuspend(spi_imx->dev);
 	return 0;
 }
 
@@ -1676,13 +1676,15 @@ static int spi_imx_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
-	ret = clk_prepare_enable(spi_imx->clk_per);
-	if (ret)
-		goto out_master_put;
+	pm_runtime_enable(spi_imx->dev);
+	pm_runtime_set_autosuspend_delay(spi_imx->dev, MXC_RPM_TIMEOUT);
+	pm_runtime_use_autosuspend(spi_imx->dev);
 
-	ret = clk_prepare_enable(spi_imx->clk_ipg);
-	if (ret)
-		goto out_put_per;
+	ret = pm_runtime_get_sync(spi_imx->dev);
+	if (ret < 0) {
+		dev_err(spi_imx->dev, "failed to enable clock\n");
+		goto out_runtime_pm_put;
+	}
 
 	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
 	/*
@@ -1692,7 +1694,7 @@ static int spi_imx_probe(struct platform_device *pdev)
 	if (spi_imx->devtype_data->has_dmamode) {
 		ret = spi_imx_sdma_init(&pdev->dev, spi_imx, master);
 		if (ret == -EPROBE_DEFER)
-			goto out_clk_put;
+			goto out_runtime_pm_put;
 
 		if (ret < 0)
 			dev_err(&pdev->dev, "dma setup error %d, use pio\n",
@@ -1707,19 +1709,20 @@ static int spi_imx_probe(struct platform_device *pdev)
 	ret = spi_bitbang_start(&spi_imx->bitbang);
 	if (ret) {
 		dev_err(&pdev->dev, "bitbang start failed with %d\n", ret);
-		goto out_clk_put;
+		goto out_runtime_pm_put;
 	}
 
 	dev_info(&pdev->dev, "probed\n");
 
-	clk_disable(spi_imx->clk_ipg);
-	clk_disable(spi_imx->clk_per);
+	pm_runtime_mark_last_busy(spi_imx->dev);
+	pm_runtime_put_autosuspend(spi_imx->dev);
+
 	return ret;
 
-out_clk_put:
-	clk_disable_unprepare(spi_imx->clk_ipg);
-out_put_per:
-	clk_disable_unprepare(spi_imx->clk_per);
+out_runtime_pm_put:
+	pm_runtime_dont_use_autosuspend(spi_imx->dev);
+	pm_runtime_put_sync(spi_imx->dev);
+	pm_runtime_disable(spi_imx->dev);
 out_master_put:
 	spi_master_put(master);
 
@@ -1734,30 +1737,82 @@ static int spi_imx_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&spi_imx->bitbang);
 
-	ret = clk_enable(spi_imx->clk_per);
+	ret = pm_runtime_get_sync(spi_imx->dev);
+	if (ret < 0) {
+		dev_err(spi_imx->dev, "failed to enable clock\n");
+		return ret;
+	}
+
+	writel(0, spi_imx->base + MXC_CSPICTRL);
+
+	pm_runtime_dont_use_autosuspend(spi_imx->dev);
+	pm_runtime_put_sync(spi_imx->dev);
+	pm_runtime_disable(spi_imx->dev);
+
+	spi_imx_sdma_exit(spi_imx);
+	spi_master_put(master);
+
+	return 0;
+}
+
+static int __maybe_unused spi_imx_runtime_resume(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct spi_imx_data *spi_imx;
+	int ret;
+
+	spi_imx = spi_master_get_devdata(master);
+
+	ret = clk_prepare_enable(spi_imx->clk_per);
 	if (ret)
 		return ret;
 
-	ret = clk_enable(spi_imx->clk_ipg);
+	ret = clk_prepare_enable(spi_imx->clk_ipg);
 	if (ret) {
-		clk_disable(spi_imx->clk_per);
+		clk_disable_unprepare(spi_imx->clk_per);
 		return ret;
 	}
 
-	writel(0, spi_imx->base + MXC_CSPICTRL);
-	clk_disable_unprepare(spi_imx->clk_ipg);
+	return 0;
+}
+
+static int __maybe_unused spi_imx_runtime_suspend(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct spi_imx_data *spi_imx;
+
+	spi_imx = spi_master_get_devdata(master);
+
 	clk_disable_unprepare(spi_imx->clk_per);
-	spi_imx_sdma_exit(spi_imx);
-	spi_master_put(master);
+	clk_disable_unprepare(spi_imx->clk_ipg);
+
+	return 0;
+}
 
+static int __maybe_unused spi_imx_suspend(struct device *dev)
+{
+	pinctrl_pm_select_sleep_state(dev);
 	return 0;
 }
 
+static int __maybe_unused spi_imx_resume(struct device *dev)
+{
+	pinctrl_pm_select_default_state(dev);
+	return 0;
+}
+
+static const struct dev_pm_ops imx_spi_pm = {
+	SET_RUNTIME_PM_OPS(spi_imx_runtime_suspend,
+				spi_imx_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(spi_imx_suspend, spi_imx_resume)
+};
+
 static struct platform_driver spi_imx_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = spi_imx_dt_ids,
-		   },
+		   .pm = &imx_spi_pm,
+	},
 	.id_table = spi_imx_devtype,
 	.probe = spi_imx_probe,
 	.remove = spi_imx_remove,
-- 
2.39.2



