Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CED919752C;
	Wed,  2 Oct 2024 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879900; cv=none; b=D94LtkBLbJYfgYY6mMlQqW24wOw915y8EK+WtBmVJQz81I+n6+FvTyS2c5AR4eAkRcyJipT1wEQo9ZW8R40pbafILc8eOjb/PGn4jQXoVdABjJd9Hia3Q4Ti+GA1zK0yWK78zr5P7hq+rDInxRNOFAQ91ITLhnkkUkSZbuayhO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879900; c=relaxed/simple;
	bh=XmAU4ZKIqOpMEGSLJrspEfPWnWsGEmPgDZCf5MJwVOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ9lqdSFzYdasIBp+rEoZrcUSqN8qKCPLT3JPpYdPz8RqL50DaIoinjYh6XtyqR41pSOahjbm/z8N7STiW6/YDdI8R/3Y5rxswY3N+r21eGQqegzg8kDWQuALAeLxoAeSDVc1TUl9LGzomCyP2QhSXrkMxvlTuHcgoAurdL0i5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL5BA7S9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL5BA7S9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCF3C4CEC5;
	Wed,  2 Oct 2024 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879899;
	bh=XmAU4ZKIqOpMEGSLJrspEfPWnWsGEmPgDZCf5MJwVOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL5BA7S9uesZn+F4Cbby9gdj67tKWrNSpAsgVXPlQ00ZVEsd/vE8eEDa5zaprTgjK
	 Feh1Qw1+ocgtOXri0RvhBIgbj1inq5l1CR4wZ9/72lKxqA1Q9B9szV/9/mr023xUTK
	 gUMZRc0N7+rHzZdwle5Cj+CMDgY84OLUbgXq59N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/538] pinctrl: ti: iodelay: Use scope based of_node_put() cleanups
Date: Wed,  2 Oct 2024 14:58:36 +0200
Message-ID: <20241002125803.192550716@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 791a8bb202a85f707c20ef04a471519e35f089dc ]

Use scope based of_node_put() cleanup to simplify code.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/20240627131721.678727-2-peng.fan@oss.nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a9f2b249adee ("pinctrl: ti: ti-iodelay: Fix some error handling paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 43 +++++++++----------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index ef97586385019..f5e5a23d22260 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -822,53 +822,48 @@ MODULE_DEVICE_TABLE(of, ti_iodelay_of_match);
 static int ti_iodelay_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = of_node_get(dev->of_node);
+	struct device_node *np __free(device_node) = of_node_get(dev->of_node);
 	struct resource *res;
 	struct ti_iodelay_device *iod;
-	int ret = 0;
+	int ret;
 
 	if (!np) {
-		ret = -EINVAL;
 		dev_err(dev, "No OF node\n");
-		goto exit_out;
+		return -EINVAL;
 	}
 
 	iod = devm_kzalloc(dev, sizeof(*iod), GFP_KERNEL);
-	if (!iod) {
-		ret = -ENOMEM;
-		goto exit_out;
-	}
+	if (!iod)
+		return -ENOMEM;
+
 	iod->dev = dev;
 	iod->reg_data = device_get_match_data(dev);
 	if (!iod->reg_data) {
-		ret = -EINVAL;
 		dev_err(dev, "No DATA match\n");
-		goto exit_out;
+		return -EINVAL;
 	}
 
 	/* So far We can assume there is only 1 bank of registers */
 	iod->reg_base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
-	if (IS_ERR(iod->reg_base)) {
-		ret = PTR_ERR(iod->reg_base);
-		goto exit_out;
-	}
+	if (IS_ERR(iod->reg_base))
+		return PTR_ERR(iod->reg_base);
+
 	iod->phys_base = res->start;
 
 	iod->regmap = devm_regmap_init_mmio(dev, iod->reg_base,
 					    iod->reg_data->regmap_config);
 	if (IS_ERR(iod->regmap)) {
 		dev_err(dev, "Regmap MMIO init failed.\n");
-		ret = PTR_ERR(iod->regmap);
-		goto exit_out;
+		return PTR_ERR(iod->regmap);
 	}
 
 	ret = ti_iodelay_pinconf_init_dev(iod);
 	if (ret)
-		goto exit_out;
+		return ret;
 
 	ret = ti_iodelay_alloc_pins(dev, iod, res->start);
 	if (ret)
-		goto exit_out;
+		return ret;
 
 	iod->desc.pctlops = &ti_iodelay_pinctrl_ops;
 	/* no pinmux ops - we are pinconf */
@@ -879,20 +874,12 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 	ret = devm_pinctrl_register_and_init(dev, &iod->desc, iod, &iod->pctl);
 	if (ret) {
 		dev_err(dev, "Failed to register pinctrl\n");
-		goto exit_out;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, iod);
 
-	ret = pinctrl_enable(iod->pctl);
-	if (ret)
-		goto exit_out;
-
-	return 0;
-
-exit_out:
-	of_node_put(np);
-	return ret;
+	return pinctrl_enable(iod->pctl);
 }
 
 /**
-- 
2.43.0



