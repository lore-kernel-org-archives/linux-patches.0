Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9901E00AB;
	Wed,  6 Nov 2024 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898564; cv=none; b=qAGL9wXoYjxk9G9aOCSVf9hGZeeYAKckqYZSlsmpQDtC4L2zQWpbuP5HIcEsmM6wQ3EHRtQYK8t+/90iRhTYyC8kMY7B8WwOAK2M1I1D4uxtEz4g7kXTpJJPrzge0XkDiYniSJ+UUJRdI+woQ8uEMRJkBrZJ4pOs64JEWJrPTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898564; c=relaxed/simple;
	bh=YM+E02G8X4zevT5YHgKUZkQ45l0si8PhMsOg9+OR9FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q94Yk6Gu9izVQazRThOnEh6QMUJXPkbInm0566N+sfwO3V3TJ+zmqMGB930+XZteaTDmXxQlC/n7RfFsSKyPzMF+BYbpGaqbOMUdeJzaHzkXOBQ82Ls719L9sGfQnr/Y0/3qQg4FvyMPONbWQFs1qxmIPNlU68kel2Oz+mGQORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcsxvT3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcsxvT3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9808C4CED3;
	Wed,  6 Nov 2024 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898564;
	bh=YM+E02G8X4zevT5YHgKUZkQ45l0si8PhMsOg9+OR9FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcsxvT3R8gnFAuMTLmna23y7m8rJ6hmhqUd4au8gW2n1J/9Lt3nXnVAnGJ7c0D4He
	 eEkeXgOXr0EzTpF+SSJsB3dm39dKmC5oBLWQWXF6lbFMEzd67dGn3ObzJ6O4flU/lV
	 tasx8ci/6jF32bTtP9lGjlSTov2fJw7SjbLiJSFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Brendan Higgins <brendanhiggins@google.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Amit Kucheria <amit.kucheria@linaro.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 281/462] i2c: qcom-geni: Grow a dev pointer to simplify code
Date: Wed,  6 Nov 2024 13:02:54 +0100
Message-ID: <20241106120338.465692113@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 3b7d81f08a6a2bdd406df4355b08d39def8104aa ]

Some lines are long here. Use a struct dev pointer to shorten lines and
simplify code. The clk_get() call can fail because of EPROBE_DEFER
problems too, so just remove the error print message because it isn't
useful. Finally, platform_get_irq() already prints an error so just
remove that error message.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Stable-dep-of: e2c85d85a05f ("i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 57 ++++++++++++++----------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 6b87061ac81d1..e16c38fb37900 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -529,45 +529,40 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	struct resource *res;
 	u32 proto, tx_depth;
 	int ret;
+	struct device *dev = &pdev->dev;
 
-	gi2c = devm_kzalloc(&pdev->dev, sizeof(*gi2c), GFP_KERNEL);
+	gi2c = devm_kzalloc(dev, sizeof(*gi2c), GFP_KERNEL);
 	if (!gi2c)
 		return -ENOMEM;
 
-	gi2c->se.dev = &pdev->dev;
-	gi2c->se.wrapper = dev_get_drvdata(pdev->dev.parent);
+	gi2c->se.dev = dev;
+	gi2c->se.wrapper = dev_get_drvdata(dev->parent);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	gi2c->se.base = devm_ioremap_resource(&pdev->dev, res);
+	gi2c->se.base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(gi2c->se.base))
 		return PTR_ERR(gi2c->se.base);
 
-	gi2c->se.clk = devm_clk_get(&pdev->dev, "se");
-	if (IS_ERR(gi2c->se.clk) && !has_acpi_companion(&pdev->dev)) {
-		ret = PTR_ERR(gi2c->se.clk);
-		dev_err(&pdev->dev, "Err getting SE Core clk %d\n", ret);
-		return ret;
-	}
+	gi2c->se.clk = devm_clk_get(dev, "se");
+	if (IS_ERR(gi2c->se.clk) && !has_acpi_companion(dev))
+		return PTR_ERR(gi2c->se.clk);
 
-	ret = device_property_read_u32(&pdev->dev, "clock-frequency",
-							&gi2c->clk_freq_out);
+	ret = device_property_read_u32(dev, "clock-frequency",
+				       &gi2c->clk_freq_out);
 	if (ret) {
-		dev_info(&pdev->dev,
-			"Bus frequency not specified, default to 100kHz.\n");
+		dev_info(dev, "Bus frequency not specified, default to 100kHz.\n");
 		gi2c->clk_freq_out = KHZ(100);
 	}
 
-	if (has_acpi_companion(&pdev->dev))
-		ACPI_COMPANION_SET(&gi2c->adap.dev, ACPI_COMPANION(&pdev->dev));
+	if (has_acpi_companion(dev))
+		ACPI_COMPANION_SET(&gi2c->adap.dev, ACPI_COMPANION(dev));
 
 	gi2c->irq = platform_get_irq(pdev, 0);
-	if (gi2c->irq < 0) {
-		dev_err(&pdev->dev, "IRQ error for i2c-geni\n");
+	if (gi2c->irq < 0)
 		return gi2c->irq;
-	}
 
 	ret = geni_i2c_clk_map_idx(gi2c);
 	if (ret) {
-		dev_err(&pdev->dev, "Invalid clk frequency %d Hz: %d\n",
+		dev_err(dev, "Invalid clk frequency %d Hz: %d\n",
 			gi2c->clk_freq_out, ret);
 		return ret;
 	}
@@ -576,29 +571,29 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	init_completion(&gi2c->done);
 	spin_lock_init(&gi2c->lock);
 	platform_set_drvdata(pdev, gi2c);
-	ret = devm_request_irq(&pdev->dev, gi2c->irq, geni_i2c_irq, 0,
-			       dev_name(&pdev->dev), gi2c);
+	ret = devm_request_irq(dev, gi2c->irq, geni_i2c_irq, 0,
+			       dev_name(dev), gi2c);
 	if (ret) {
-		dev_err(&pdev->dev, "Request_irq failed:%d: err:%d\n",
+		dev_err(dev, "Request_irq failed:%d: err:%d\n",
 			gi2c->irq, ret);
 		return ret;
 	}
 	/* Disable the interrupt so that the system can enter low-power mode */
 	disable_irq(gi2c->irq);
 	i2c_set_adapdata(&gi2c->adap, gi2c);
-	gi2c->adap.dev.parent = &pdev->dev;
-	gi2c->adap.dev.of_node = pdev->dev.of_node;
+	gi2c->adap.dev.parent = dev;
+	gi2c->adap.dev.of_node = dev->of_node;
 	strlcpy(gi2c->adap.name, "Geni-I2C", sizeof(gi2c->adap.name));
 
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
-		dev_err(&pdev->dev, "Error turning on resources %d\n", ret);
+		dev_err(dev, "Error turning on resources %d\n", ret);
 		return ret;
 	}
 	proto = geni_se_read_proto(&gi2c->se);
 	tx_depth = geni_se_get_tx_fifo_depth(&gi2c->se);
 	if (proto != GENI_SE_I2C) {
-		dev_err(&pdev->dev, "Invalid proto %d\n", proto);
+		dev_err(dev, "Invalid proto %d\n", proto);
 		geni_se_resources_off(&gi2c->se);
 		return -ENXIO;
 	}
@@ -608,11 +603,11 @@ static int geni_i2c_probe(struct platform_device *pdev)
 							true, true, true);
 	ret = geni_se_resources_off(&gi2c->se);
 	if (ret) {
-		dev_err(&pdev->dev, "Error turning off resources %d\n", ret);
+		dev_err(dev, "Error turning off resources %d\n", ret);
 		return ret;
 	}
 
-	dev_dbg(&pdev->dev, "i2c fifo/se-dma mode. fifo depth:%d\n", tx_depth);
+	dev_dbg(dev, "i2c fifo/se-dma mode. fifo depth:%d\n", tx_depth);
 
 	gi2c->suspended = 1;
 	pm_runtime_set_suspended(gi2c->se.dev);
@@ -622,12 +617,12 @@ static int geni_i2c_probe(struct platform_device *pdev)
 
 	ret = i2c_add_adapter(&gi2c->adap);
 	if (ret) {
-		dev_err(&pdev->dev, "Error adding i2c adapter %d\n", ret);
+		dev_err(dev, "Error adding i2c adapter %d\n", ret);
 		pm_runtime_disable(gi2c->se.dev);
 		return ret;
 	}
 
-	dev_dbg(&pdev->dev, "Geni-I2C adaptor successfully added\n");
+	dev_dbg(dev, "Geni-I2C adaptor successfully added\n");
 
 	return 0;
 }
-- 
2.43.0



