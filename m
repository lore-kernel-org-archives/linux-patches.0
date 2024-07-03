Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48777142E8E;
	Wed,  3 Jul 2024 10:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003908; cv=none; b=EYTj2q60qCDUp53ljiMC0RXhFBv47dSvnI7a8CD7PXPabHcWlIRkEeSOV6svwrUTUYlYLOylbMlfKfn5t4V67cCazlb7endcrp9T0bVFp7G3UfEtrLIXIgR2NPHoABNP6g1HARalIpgOEOku9stSGZUX9GFFfvSOSWtJw+bb8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003908; c=relaxed/simple;
	bh=ejpKI254iS63CXCCUdPEvgSzFl5KBwKaiCKziIkKYZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAzdd5i80Zv56SPgLyWulBnbDFOrb9w1Pq8HH64t5nPeY71CunqkgQ5VZ2THSfsPJxwFDZxWV/uuV9I6PY/ajU04GA8kMIjEoSH0XKPFavVWJRvwBKbx/sKzA2j30ZBQKivZ+csTPICQTCAzabslCV6zrybyG9asqS9+K9uIVRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXEByKiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXEByKiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8974C2BD10;
	Wed,  3 Jul 2024 10:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003908;
	bh=ejpKI254iS63CXCCUdPEvgSzFl5KBwKaiCKziIkKYZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXEByKiw0cd3P/kWq3FarnF70jwggGcPpT2s0v8bHRqu8hC3hN+Il33LufnXd3r9V
	 xMGC6wZI74AUUedf9KiGyLi/l2f/I8e6qBG3Uy9VgxfAJI7LR26LfebptmKIqSYhVz
	 UMnWfhXyoOQ28gX+f4kLihtl28Ocqw51Poex+fTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/189] ASoC: ti: davinci-mcasp: Handle missing required DT properties
Date: Wed,  3 Jul 2024 12:38:10 +0200
Message-ID: <20240703102842.607094279@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 1b4fb70e5b28a477478417a7958e0228460ffe68 ]

McASP needs three required properties to be usable for audio:
op-mode, tdm-slots and the serial-dir array.

Instead of probing the driver even without the needed information we should
make sure that all the parameters are provided for operation.

The fact that McASP can act as a GPIO controller for it's pins complicates
this a bit, but as a general rule we can:
- we fail the probe if McASP is not configured to be used as gpiochip
- we will not register the DAI (and PCM) if gpiochip is defined

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201106072551.689-5-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d18ca8635db2 ("ASoC: ti: davinci-mcasp: Fix race condition during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 77 +++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 637c26cad2e6e..633cd7fd3dcf3 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -82,6 +82,9 @@ struct davinci_mcasp {
 	struct snd_pcm_substream *substreams[2];
 	unsigned int dai_fmt;
 
+	/* Audio can not be enabled due to missing parameter(s) */
+	bool	missing_audio_param;
+
 	/* McASP specific data */
 	int	tdm_slots;
 	u32	tdm_mask[2];
@@ -1723,6 +1726,17 @@ static int mcasp_reparent_fck(struct platform_device *pdev)
 	return ret;
 }
 
+static bool davinci_mcasp_have_gpiochip(struct davinci_mcasp *mcasp)
+{
+#ifdef CONFIG_OF_GPIO
+	if (mcasp->dev->of_node &&
+	    of_property_read_bool(mcasp->dev->of_node, "gpio-controller"))
+		return true;
+#endif
+
+	return false;
+}
+
 static int davinci_mcasp_get_config(struct davinci_mcasp *mcasp,
 				    struct platform_device *pdev)
 {
@@ -1747,8 +1761,12 @@ static int davinci_mcasp_get_config(struct davinci_mcasp *mcasp,
 		return -EINVAL;
 	}
 
-	if (of_property_read_u32(np, "op-mode", &val) == 0)
+	if (of_property_read_u32(np, "op-mode", &val) == 0) {
 		pdata->op_mode = val;
+	} else {
+		mcasp->missing_audio_param = true;
+		goto out;
+	}
 
 	if (of_property_read_u32(np, "tdm-slots", &val) == 0) {
 		if (val < 2 || val > 32) {
@@ -1757,6 +1775,9 @@ static int davinci_mcasp_get_config(struct davinci_mcasp *mcasp,
 		}
 
 		pdata->tdm_slots = val;
+	} else if (pdata->op_mode == DAVINCI_MCASP_IIS_MODE) {
+		mcasp->missing_audio_param = true;
+		goto out;
 	}
 
 	of_serial_dir32 = of_get_property(np, "serial-dir", &val);
@@ -1773,6 +1794,9 @@ static int davinci_mcasp_get_config(struct davinci_mcasp *mcasp,
 
 		pdata->num_serializer = val;
 		pdata->serial_dir = of_serial_dir;
+	} else {
+		mcasp->missing_audio_param = true;
+		goto out;
 	}
 
 	if (of_property_read_u32(np, "tx-num-evt", &val) == 0)
@@ -1798,6 +1822,16 @@ static int davinci_mcasp_get_config(struct davinci_mcasp *mcasp,
 out:
 	mcasp->pdata = pdata;
 
+	if (mcasp->missing_audio_param) {
+		if (davinci_mcasp_have_gpiochip(mcasp)) {
+			dev_dbg(&pdev->dev, "Missing DT parameter(s) for audio\n");
+			return 0;
+		}
+
+		dev_err(&pdev->dev, "Insufficient DT parameter(s)\n");
+		return -ENODEV;
+	}
+
 	mcasp->op_mode = pdata->op_mode;
 	/* sanity check for tdm slots parameter */
 	if (mcasp->op_mode == DAVINCI_MCASP_IIS_MODE) {
@@ -2044,7 +2078,7 @@ static const struct gpio_chip davinci_mcasp_template_chip = {
 
 static int davinci_mcasp_init_gpiochip(struct davinci_mcasp *mcasp)
 {
-	if (!of_property_read_bool(mcasp->dev->of_node, "gpio-controller"))
+	if (!davinci_mcasp_have_gpiochip(mcasp))
 		return 0;
 
 	mcasp->gpio_chip = davinci_mcasp_template_chip;
@@ -2083,11 +2117,6 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (!mcasp)
 		return	-ENOMEM;
 
-	mcasp->dev = &pdev->dev;
-	ret = davinci_mcasp_get_config(mcasp, pdev);
-	if (ret)
-		return ret;
-
 	mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpu");
 	if (!mem) {
 		dev_warn(mcasp->dev,
@@ -2103,8 +2132,23 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (IS_ERR(mcasp->base))
 		return PTR_ERR(mcasp->base);
 
+	dev_set_drvdata(&pdev->dev, mcasp);
 	pm_runtime_enable(&pdev->dev);
 
+	mcasp->dev = &pdev->dev;
+	ret = davinci_mcasp_get_config(mcasp, pdev);
+	if (ret)
+		goto err;
+
+	/* All PINS as McASP */
+	pm_runtime_get_sync(mcasp->dev);
+	mcasp_set_reg(mcasp, DAVINCI_MCASP_PFUNC_REG, 0x00000000);
+	pm_runtime_put(mcasp->dev);
+
+	/* Skip audio related setup code if the configuration is not adequat */
+	if (mcasp->missing_audio_param)
+		goto no_audio;
+
 	irq = platform_get_irq_byname_optional(pdev, "common");
 	if (irq > 0) {
 		irq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_common",
@@ -2224,19 +2268,8 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	dev_set_drvdata(&pdev->dev, mcasp);
-
 	mcasp_reparent_fck(pdev);
 
-	/* All PINS as McASP */
-	pm_runtime_get_sync(mcasp->dev);
-	mcasp_set_reg(mcasp, DAVINCI_MCASP_PFUNC_REG, 0x00000000);
-	pm_runtime_put(mcasp->dev);
-
-	ret = davinci_mcasp_init_gpiochip(mcasp);
-	if (ret)
-		goto err;
-
 	ret = devm_snd_soc_register_component(&pdev->dev, &davinci_mcasp_component,
 					      &davinci_mcasp_dai[mcasp->op_mode], 1);
 
@@ -2263,8 +2296,14 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	return 0;
+no_audio:
+	ret = davinci_mcasp_init_gpiochip(mcasp);
+	if (ret) {
+		dev_err(&pdev->dev, "gpiochip registration failed: %d\n", ret);
+		goto err;
+	}
 
+	return 0;
 err:
 	pm_runtime_disable(&pdev->dev);
 	return ret;
-- 
2.43.0



