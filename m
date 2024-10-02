Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235B01D0DCB;
	Wed,  2 Oct 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879996; cv=none; b=Tz45qjIMrZvE+B+1h3hCwRaCNoNNqahGP8S17gxYFyO6UFDr21LZ9qQb4F5WOBGe9rFsAhrgJ7AupKnliJJQ0BtXR8rsYqr/dgPeaWKa0T6nbbbJRMt8aYdWF5EtsGpdyBnMBIZF8udeH/zS8H6/L+5KLW8Dhz5VQXGxqUL4lH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879996; c=relaxed/simple;
	bh=WIQuiSE5pcmHo3fCGqT3qbVHnBoWIHuC5jAl39x81cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7tgOQx/cfEgI3qLSYK0b4o3BwLsykrBBKPiPugiP4sdI3PMiNmvyJRDxs4k1Dovq1X0jnjSOUKzhQRCCgX1tIOLQvFmX6dT5YK3SGojswTgSWdiccNwIjMiMGWcsZq78vAgdAl9e4iqpaqU+QaNNqlLE4eH99zYKpPjf8S+eoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbtT/xYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbtT/xYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEA6C4CEC2;
	Wed,  2 Oct 2024 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879995;
	bh=WIQuiSE5pcmHo3fCGqT3qbVHnBoWIHuC5jAl39x81cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbtT/xYuKGB8PKooQcNHgQVvVKBhxSGRwNm7kJpjtgBT2E+P0rLta7jxf9ycNoZLA
	 eWWiJ8zN4O8g+C18Q4fFCeFO3w5JdPKwuSS4oiMJeAOMkd99LmRa1FpS/Wqc6aSeog
	 jP8fO6gEGgqB8oTLiIqwIr98tnDIdhRAVuACPPeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/538] pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function
Date: Wed,  2 Oct 2024 14:59:08 +0200
Message-ID: <20241002125804.614845330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 1947da73e5121..dce601d993728 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -767,7 +767,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	struct resource fb_res;
 	struct mvebu_mpp_ctrl_data *mpp_data;
 	void __iomem *base;
-	int i;
+	int i, ret;
 
 	pdev->dev.platform_data = (void *)device_get_match_data(&pdev->dev);
 
@@ -783,13 +783,17 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -808,8 +812,10 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -820,8 +826,10 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -831,12 +839,17 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
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
@@ -844,6 +857,9 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, FW_BUG "Missing pinctrl regs in DTB. Please update your firmware.\n");
 
 	return mvebu_pinctrl_probe(pdev);
+err_probe:
+	clk_disable_unprepare(clk);
+	return ret;
 }
 
 static struct platform_driver dove_pinctrl_driver = {
-- 
2.43.0



