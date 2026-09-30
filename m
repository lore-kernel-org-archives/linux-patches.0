Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B952ED30;
	Wed, 30 Sep 2026 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789720; cv=none; b=ZjQjkibF1TVU/w2QXJW7JKvmW49UHBgFYCVLc9cfIgE2qeZroVQ7SeakBn/6q38Z81lbn4VgYV3YYt0i+toMjD5ru4jXdbjLfiQooVQjOZmf/HkCF/9VB/kvT3CfhWOsx8Pvsap/VjGQbxONFwmj2AeUq3DVmM2cTm+IleansSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789720; c=relaxed/simple;
	bh=nPA08HrPkmLOws5ynjoB53O+dSGqYkROak/9UEnAQwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZENmay8EJJkYBoJAB3o4/uq68j2DMLaFlsj2L8lbr9jAaEOvnl4OqOeT72RaQyP8aELxIN9k8MjapSNkM1iATugkmfkQ8QNt6hIe8++OsKrL7BUx83O9CJ1dnYaXMYW18nyOLrzm34RvdhrClK9coyCJorCfNk9Fzta2KBKj3zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z70+nfvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z70+nfvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787181F008BC;
	Wed, 30 Sep 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789718;
	bh=Fds/wD+oNPr9ZkSyqs4VenPq60Pvm1COc8uoCS7v7mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z70+nfvuiyH1YyOVEicZ/8AvFsWRckmiWzU/OQ56irqxceULGa/Q71rFz/L28kOUv
	 7RJ9onjfqDXEUMGAKS4pdPwyQ5iJfde+7R13AEQzP5id/Hwz00uXl+LPpAsh+W0f/g
	 pW5a+S4MY1ygqhMJ0k8kzsFQpgVbWaLFIaRgsBEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 575/877] iommu/msm: Use helper function devm_clk_get_prepared()
Date: Wed, 30 Sep 2026 17:24:46 +0200
Message-ID: <20260930152427.049539220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit afc0cbc6e25b37dc9ba11d415ea6858902a7f04b ]

Since commit 7ef9651e9792 ("clk: Provide new devm_clk helpers for prepared
and enabled clocks"), devm_clk_get() and clk_prepare() can now be replaced
by devm_clk_get_prepared() when driver prepares the clocks for the whole
lifetime of the device. Moreover, it is no longer necessary to unprepare
the clocks explicitly.

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250103113059.463033-1-zhangheng@kylinos.cn
Signed-off-by: Joerg Roedel <jroedel@suse.de>

Backport to 6.12: remove the .remove_new callback entry used by this
stable tree instead of the upstream .remove entry. The callback only
unprepares clocks, which devm_clk_get_prepared() now handles. Keep
the remaining upstream changes to prepare the probe error paths for
535a200220ca ("iommu/msm: Unwind probe state on registration failure").

Stable-dep-of: 535a200220ca ("iommu/msm: Unwind probe state on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/msm_iommu.c |   51 +++++++++-------------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -725,47 +725,32 @@ static int msm_iommu_probe(struct platfo
 	iommu->dev = &pdev->dev;
 	INIT_LIST_HEAD(&iommu->ctx_list);
 
-	iommu->pclk = devm_clk_get(iommu->dev, "smmu_pclk");
+	iommu->pclk = devm_clk_get_prepared(iommu->dev, "smmu_pclk");
 	if (IS_ERR(iommu->pclk))
 		return dev_err_probe(iommu->dev, PTR_ERR(iommu->pclk),
 				     "could not get smmu_pclk\n");
 
-	ret = clk_prepare(iommu->pclk);
-	if (ret)
-		return dev_err_probe(iommu->dev, ret,
-				     "could not prepare smmu_pclk\n");
-
-	iommu->clk = devm_clk_get(iommu->dev, "iommu_clk");
-	if (IS_ERR(iommu->clk)) {
-		clk_unprepare(iommu->pclk);
+	iommu->clk = devm_clk_get_prepared(iommu->dev, "iommu_clk");
+	if (IS_ERR(iommu->clk))
 		return dev_err_probe(iommu->dev, PTR_ERR(iommu->clk),
 				     "could not get iommu_clk\n");
-	}
-
-	ret = clk_prepare(iommu->clk);
-	if (ret) {
-		clk_unprepare(iommu->pclk);
-		return dev_err_probe(iommu->dev, ret, "could not prepare iommu_clk\n");
-	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	iommu->base = devm_ioremap_resource(iommu->dev, r);
 	if (IS_ERR(iommu->base)) {
 		ret = dev_err_probe(iommu->dev, PTR_ERR(iommu->base), "could not get iommu base\n");
-		goto fail;
+		return ret;
 	}
 	ioaddr = r->start;
 
 	iommu->irq = platform_get_irq(pdev, 0);
-	if (iommu->irq < 0) {
-		ret = -ENODEV;
-		goto fail;
-	}
+	if (iommu->irq < 0)
+		return -ENODEV;
 
 	ret = of_property_read_u32(iommu->dev->of_node, "qcom,ncb", &val);
 	if (ret) {
 		dev_err(iommu->dev, "could not get ncb\n");
-		goto fail;
+		return ret;
 	}
 	iommu->ncb = val;
 
@@ -780,8 +765,7 @@ static int msm_iommu_probe(struct platfo
 
 	if (!par) {
 		pr_err("Invalid PAR value detected\n");
-		ret = -ENODEV;
-		goto fail;
+		return -ENODEV;
 	}
 
 	ret = devm_request_threaded_irq(iommu->dev, iommu->irq, NULL,
@@ -791,7 +775,7 @@ static int msm_iommu_probe(struct platfo
 					iommu);
 	if (ret) {
 		pr_err("Request IRQ %d failed with ret=%d\n", iommu->irq, ret);
-		goto fail;
+		return ret;
 	}
 
 	list_add(&iommu->dev_node, &qcom_iommu_devices);
@@ -800,23 +784,19 @@ static int msm_iommu_probe(struct platfo
 				     "msm-smmu.%pa", &ioaddr);
 	if (ret) {
 		pr_err("Could not add msm-smmu at %pa to sysfs\n", &ioaddr);
-		goto fail;
+		return ret;
 	}
 
 	ret = iommu_device_register(&iommu->iommu, &msm_iommu_ops, &pdev->dev);
 	if (ret) {
 		pr_err("Could not register msm-smmu at %pa\n", &ioaddr);
-		goto fail;
+		return ret;
 	}
 
 	pr_info("device mapped at %p, irq %d with %d ctx banks\n",
 		iommu->base, iommu->irq, iommu->ncb);
 
 	return ret;
-fail:
-	clk_unprepare(iommu->clk);
-	clk_unprepare(iommu->pclk);
-	return ret;
 }
 
 static const struct of_device_id msm_iommu_dt_match[] = {
@@ -824,20 +804,11 @@ static const struct of_device_id msm_iom
 	{}
 };
 
-static void msm_iommu_remove(struct platform_device *pdev)
-{
-	struct msm_iommu_dev *iommu = platform_get_drvdata(pdev);
-
-	clk_unprepare(iommu->clk);
-	clk_unprepare(iommu->pclk);
-}
-
 static struct platform_driver msm_iommu_driver = {
 	.driver = {
 		.name	= "msm_iommu",
 		.of_match_table = msm_iommu_dt_match,
 	},
 	.probe		= msm_iommu_probe,
-	.remove_new	= msm_iommu_remove,
 };
 builtin_platform_driver(msm_iommu_driver);


