Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD8521B90F;
	Thu, 12 Dec 2024 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022342; cv=none; b=Ibfvgb0sgsTeTScQyVElfikvILMhKf9wI1l471ZYyk8jjES9aMPcslk0+9vstKJ0oDmt8KeGeNdKHdIqeP2Q6TfOkoZElPnF+cFBPHgIH8gLXLjYyS7MGOZSRmQ2Y2DPs0GV6XsqM505P0TsHr+lOZSZEG+OMCT9nroXxkhQWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022342; c=relaxed/simple;
	bh=+QTGn8MJuo54yx20h+F3WlwdSB9rN9uv4MQS0WjhsSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjZFvvDf/HEERmXsAj2Fetuj2smGtnshDTwrh9uIcHDVxJyQrdxbKDI6a3YI5sB6guFyQ6Ryrf7x+xQUE9YGgDXE0pOXBuPtIFGKh2voSAdVROQDLdXRbfEWLbHyzJ9urwDJyX2+GBezGP26VkLGhYgs9t11NZIgSwJLjpYUU5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqcPoI1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqcPoI1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F2C4CECE;
	Thu, 12 Dec 2024 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022341;
	bh=+QTGn8MJuo54yx20h+F3WlwdSB9rN9uv4MQS0WjhsSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqcPoI1XRhn1Mwu2PGLVzJ9EWvZrplDJT0GIUnRw5iHSNS2OBWvzNGcSM4usgf1ro
	 TbM2VMMpG2yAzPMRkocuslxhNZk+gm9Y3peI4UAbvaTq6i3iDBtq4RlU40XtwR5Vwh
	 nnafLT8U0CeC50lDoiVG4Px+xNNTxraOpm8q3JUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/565] mfd: intel_soc_pmic_bxtwc: Use dev_err_probe()
Date: Thu, 12 Dec 2024 15:56:49 +0100
Message-ID: <20241212144319.954712418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d30e2c30a43de950cfd3690f24342a39034221c4 ]

Simplify the mux error path a bit by using dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220628221747.33956-4-andriy.shevchenko@linux.intel.com
Stable-dep-of: 686fb77712a4 ("mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c | 86 +++++++++---------------------
 1 file changed, 26 insertions(+), 60 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index bc069c4daa603..8e699844f23ba 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -410,12 +410,9 @@ static int bxtwc_add_chained_irq_chip(struct intel_soc_pmic *pmic,
 	int irq;
 
 	irq = regmap_irq_get_virq(pdata, pirq);
-	if (irq < 0) {
-		dev_err(pmic->dev,
-			"Failed to get parent vIRQ(%d) for chip %s, ret:%d\n",
-			pirq, chip->name, irq);
-		return irq;
-	}
+	if (irq < 0)
+		return dev_err_probe(pmic->dev, irq, "Failed to get parent vIRQ(%d) for chip %s\n",
+				     pirq, chip->name);
 
 	return devm_regmap_add_irq_chip(pmic->dev, pmic->regmap, irq, irq_flags,
 					0, chip, data);
@@ -423,6 +420,7 @@ static int bxtwc_add_chained_irq_chip(struct intel_soc_pmic *pmic,
 
 static int bxtwc_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	int ret;
 	acpi_handle handle;
 	acpi_status status;
@@ -431,15 +429,10 @@ static int bxtwc_probe(struct platform_device *pdev)
 
 	handle = ACPI_HANDLE(&pdev->dev);
 	status = acpi_evaluate_integer(handle, "_HRV", NULL, &hrv);
-	if (ACPI_FAILURE(status)) {
-		dev_err(&pdev->dev, "Failed to get PMIC hardware revision\n");
-		return -ENODEV;
-	}
-	if (hrv != BROXTON_PMIC_WC_HRV) {
-		dev_err(&pdev->dev, "Invalid PMIC hardware revision: %llu\n",
-			hrv);
-		return -ENODEV;
-	}
+	if (ACPI_FAILURE(status))
+		return dev_err_probe(dev, -ENODEV, "Failed to get PMIC hardware revision\n");
+	if (hrv != BROXTON_PMIC_WC_HRV)
+		return dev_err_probe(dev, -ENODEV, "Invalid PMIC hardware revision: %llu\n", hrv);
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)
@@ -459,40 +452,31 @@ static int bxtwc_probe(struct platform_device *pdev)
 
 	pmic->regmap = devm_regmap_init(&pdev->dev, NULL, pmic,
 					&bxtwc_regmap_config);
-	if (IS_ERR(pmic->regmap)) {
-		ret = PTR_ERR(pmic->regmap);
-		dev_err(&pdev->dev, "Failed to initialise regmap: %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(pmic->regmap))
+		return dev_err_probe(dev, PTR_ERR(pmic->regmap), "Failed to initialise regmap\n");
 
 	ret = devm_regmap_add_irq_chip(&pdev->dev, pmic->regmap, pmic->irq,
 				       IRQF_ONESHOT | IRQF_SHARED,
 				       0, &bxtwc_regmap_irq_chip,
 				       &pmic->irq_chip_data);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add IRQ chip\n");
 
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
 					 BXTWC_PWRBTN_LVL1_IRQ,
 					 IRQF_ONESHOT,
 					 &bxtwc_regmap_irq_chip_pwrbtn,
 					 &pmic->irq_chip_data_pwrbtn);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add PWRBTN IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add PWRBTN IRQ chip\n");
 
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
 					 BXTWC_TMU_LVL1_IRQ,
 					 IRQF_ONESHOT,
 					 &bxtwc_regmap_irq_chip_tmu,
 					 &pmic->irq_chip_data_tmu);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add TMU IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add TMU IRQ chip\n");
 
 	/* Add chained IRQ handler for BCU IRQs */
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
@@ -500,12 +484,8 @@ static int bxtwc_probe(struct platform_device *pdev)
 					 IRQF_ONESHOT,
 					 &bxtwc_regmap_irq_chip_bcu,
 					 &pmic->irq_chip_data_bcu);
-
-
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add BUC IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add BUC IRQ chip\n");
 
 	/* Add chained IRQ handler for ADC IRQs */
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
@@ -513,12 +493,8 @@ static int bxtwc_probe(struct platform_device *pdev)
 					 IRQF_ONESHOT,
 					 &bxtwc_regmap_irq_chip_adc,
 					 &pmic->irq_chip_data_adc);
-
-
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add ADC IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add ADC IRQ chip\n");
 
 	/* Add chained IRQ handler for CHGR IRQs */
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
@@ -526,12 +502,8 @@ static int bxtwc_probe(struct platform_device *pdev)
 					 IRQF_ONESHOT,
 					 &bxtwc_regmap_irq_chip_chgr,
 					 &pmic->irq_chip_data_chgr);
-
-
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add CHGR IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add CHGR IRQ chip\n");
 
 	/* Add chained IRQ handler for CRIT IRQs */
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
@@ -539,19 +511,13 @@ static int bxtwc_probe(struct platform_device *pdev)
 					 IRQF_ONESHOT,
 					 &bxtwc_regmap_irq_chip_crit,
 					 &pmic->irq_chip_data_crit);
-
-
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add CRIT IRQ chip\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add CRIT IRQ chip\n");
 
 	ret = devm_mfd_add_devices(&pdev->dev, PLATFORM_DEVID_NONE, bxt_wc_dev,
 				   ARRAY_SIZE(bxt_wc_dev), NULL, 0, NULL);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to add devices\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add devices\n");
 
 	ret = sysfs_create_group(&pdev->dev.kobj, &bxtwc_group);
 	if (ret) {
-- 
2.43.0



