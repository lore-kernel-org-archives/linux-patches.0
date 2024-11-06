Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAE81D5AD7;
	Wed,  6 Nov 2024 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895106; cv=none; b=aKUHD39oQt+mLPgiM2lxOpahYXp0DbexBUR8tCzQop/JIwHpAdVVcxTFC2werrHyRw9qeRu2NjY6kDL+eOPHBI7L5BRQ/YfHrh2eYM1ni1edffeub1PxaRK3+4dIOx1J3Q7Koi39mBtf4fmnGLG6Sm9OlgSWe+gsF6t4JYODo7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895106; c=relaxed/simple;
	bh=+lyHFEhDT3+qg2EHfr8P7ZAQ5LL5zBZOAXUgeBq1OmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J36B25ToVz3wmzvVupI2jExpKHBkCCTjDMJgwOFAVT3cQF9HTIebUPrZE3TG9CDSEtAatsQKmxamJgPDgF/FhsIonkmMFsnG4JgjOg6yDkeMVmsTN6rrEgLR9GaZwmz7wqIPC5LiBbqJa1KytsD8qqoaHlggWqlucwhtfWbOJWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvVWZ61/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvVWZ61/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C64C4CECD;
	Wed,  6 Nov 2024 12:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895106;
	bh=+lyHFEhDT3+qg2EHfr8P7ZAQ5LL5zBZOAXUgeBq1OmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvVWZ61/wJW0+3WQVcM8kl9gEfL5nqupadrGiYTT1dstTYw/4eDhkYALa0Ay3osKs
	 lAEMFShP5J4Gl17lNjB/sgMRNSrtKHkt7ENB9MZnKwt/2Rd6ygTIKNcQFCF2hN+jB5
	 6u4m1Dzt9XBlfpP62CfOZgMf/97t7xHLa3MheL7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/350] pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function
Date: Wed,  6 Nov 2024 13:00:18 +0100
Message-ID: <20241106120323.124038848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Jianzheng <wangjianzheng@vivo.com>

[ Upstream commit c25478419f6fd3f74c324a21ec007cf14f2688d7 ]

When an error occurs during the execution of the function
__devinit_dove_pinctrl_probe, the clk is not properly disabled.

Fix this by calling clk_disable_unprepare before return.

Fixes: ba607b6238a1 ("pinctrl: mvebu: make pdma clock on dove mandatory")
Signed-off-by: Wang Jianzheng <wangjianzheng@vivo.com>
Link: https://lore.kernel.org/20240829064823.19808-1-wangjianzheng@vivo.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 42 +++++++++++++++++++---------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 2c5032d0def52..8a77289fe96fb 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -773,7 +773,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 		of_match_device(dove_pinctrl_of_match, &pdev->dev);
 	struct mvebu_mpp_ctrl_data *mpp_data;
 	void __iomem *base;
-	int i;
+	int i, ret;
 
 	pdev->dev.platform_data = (void *)match->data;
 
@@ -789,13 +789,17 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	clk_prepare_enable(clk);
 
 	base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		goto err_probe;
+	}
 
 	mpp_data = devm_kcalloc(&pdev->dev, dove_pinctrl_info.ncontrols,
 				sizeof(*mpp_data), GFP_KERNEL);
-	if (!mpp_data)
-		return -ENOMEM;
+	if (!mpp_data) {
+		ret = -ENOMEM;
+		goto err_probe;
+	}
 
 	dove_pinctrl_info.control_data = mpp_data;
 	for (i = 0; i < ARRAY_SIZE(dove_mpp_controls); i++)
@@ -814,8 +818,10 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	mpp4_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(mpp4_base))
-		return PTR_ERR(mpp4_base);
+	if (IS_ERR(mpp4_base)) {
+		ret = PTR_ERR(mpp4_base);
+		goto err_probe;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	if (!res) {
@@ -826,8 +832,10 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	pmu_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(pmu_base))
-		return PTR_ERR(pmu_base);
+	if (IS_ERR(pmu_base)) {
+		ret = PTR_ERR(pmu_base);
+		goto err_probe;
+	}
 
 	gconfmap = syscon_regmap_lookup_by_compatible("marvell,dove-global-config");
 	if (IS_ERR(gconfmap)) {
@@ -837,12 +845,17 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 		adjust_resource(&fb_res,
 			(mpp_res->start & INT_REGS_MASK) + GC_REGS_OFFS, 0x14);
 		gc_base = devm_ioremap_resource(&pdev->dev, &fb_res);
-		if (IS_ERR(gc_base))
-			return PTR_ERR(gc_base);
+		if (IS_ERR(gc_base)) {
+			ret = PTR_ERR(gc_base);
+			goto err_probe;
+		}
+
 		gconfmap = devm_regmap_init_mmio(&pdev->dev,
 						 gc_base, &gc_regmap_config);
-		if (IS_ERR(gconfmap))
-			return PTR_ERR(gconfmap);
+		if (IS_ERR(gconfmap)) {
+			ret = PTR_ERR(gconfmap);
+			goto err_probe;
+		}
 	}
 
 	/* Warn on any missing DT resource */
@@ -850,6 +863,9 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, FW_BUG "Missing pinctrl regs in DTB. Please update your firmware.\n");
 
 	return mvebu_pinctrl_probe(pdev);
+err_probe:
+	clk_disable_unprepare(clk);
+	return ret;
 }
 
 static struct platform_driver dove_pinctrl_driver = {
-- 
2.43.0



