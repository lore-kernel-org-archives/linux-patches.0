Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6111ABEAD;
	Mon, 14 Oct 2024 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918073; cv=none; b=ePCugagdHuJEzki9QJ2A9dutWBHiphF3fsCj63c9pb+/S0nRHY1R9lYdH5GBBVkUUqj6ua9BtG7rSHrRoxGLa1wygbXwSGrFMaL9/y5BSnpfCtJFnLrCDzA+1eh4zHy51+fXhHtG0mI3ZOZc8DarRvOiUvwTr1xeNM9FZnW+ulg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918073; c=relaxed/simple;
	bh=FWDz4j3yXBi0ZV7Q0+hq7KDcooZlT8USJWCiS7LnpY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx9U+AkvzvGO2ABX07Ksv5RzQIHoEbveigzJwC3Qv0zJKY4U52LI1asVeMc8LiPWzuIYNd3yEszRCLAmuv3I59/B0DgK9bX/ObLcaorGIBrdd1LR8/3qtH78sf/ZziJcMXoi6plkBtADjodFQretpD7bNPGPYE1zOunGoX96yV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTDYB/kM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTDYB/kM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8761C4CEC3;
	Mon, 14 Oct 2024 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918073;
	bh=FWDz4j3yXBi0ZV7Q0+hq7KDcooZlT8USJWCiS7LnpY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTDYB/kMDJ7N281kJBM/Y7QYUvxUJZDh4PS/i7S2kCzc5g4ZoxuN1EI4R4m+mUu34
	 kDQZswP1L6ZOLiNaIQ04fdchYQsSdy8uAHemFVqZMhE6WPeKnMiHh20Dg2whDdQRu6
	 LX4KiTeya58zxNGK4AaFCRT/lD1WkxGG6+2yHB1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/798] pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function
Date: Mon, 14 Oct 2024 16:12:48 +0200
Message-ID: <20241014141226.340400841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd74daa9ed666..c84326dfe371c 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -769,7 +769,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 		of_match_device(dove_pinctrl_of_match, &pdev->dev);
 	struct mvebu_mpp_ctrl_data *mpp_data;
 	void __iomem *base;
-	int i;
+	int i, ret;
 
 	pdev->dev.platform_data = (void *)match->data;
 
@@ -785,13 +785,17 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -810,8 +814,10 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -822,8 +828,10 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -833,12 +841,17 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -846,6 +859,9 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, FW_BUG "Missing pinctrl regs in DTB. Please update your firmware.\n");
 
 	return mvebu_pinctrl_probe(pdev);
+err_probe:
+	clk_disable_unprepare(clk);
+	return ret;
 }
 
 static struct platform_driver dove_pinctrl_driver = {
-- 
2.43.0



