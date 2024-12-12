Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7A21765E;
	Thu, 12 Dec 2024 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017689; cv=none; b=XWA1uVfjihXxv1VULFW3nvNyCXRV0AQeCYYHsyJBcjN0RcTWIt+GbYfAVGQZL10OL6Bf0Q8YehT4LmrQ2ebUdJ//Dvo1Sm1vz1+rtFcE1YPqL0nO6LdZnC6piXC0kg9JUpycbpnlOYFvXJGjjxBmxX+sdDrddIFkQCDfmymgphQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017689; c=relaxed/simple;
	bh=IXwDMcTJTG/w9Ufa/XIM6MsRHL+03LdQQpcavkNcp/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9Tlv+zibaOLbbV6mhykOnHDQZtdqAt3qPijppw1hr8CdOZZdntVYE+bcT8f/LeR3As+Orwe+ZhRd77FzJwWO1jHMYSuO1XCD77E5Smc9ieq+2X+QFFNWYZTijfzwWy8lzp+bnK2w0kMr2z8Q2Nma2SNc0FFm1sHzr/2LadnQic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv8cvZvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv8cvZvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71057C4CECE;
	Thu, 12 Dec 2024 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017689;
	bh=IXwDMcTJTG/w9Ufa/XIM6MsRHL+03LdQQpcavkNcp/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pv8cvZvzHxFeghhNhpU3qSygnf4jL3nmaI7v6wbCLr8prj8zQafNgCDlFI/wL/rQ1
	 XkXLLMJMtG4Ugq2zuZgGCX7vMlijVoigLNwoJ7t+Cm8oFf/DSDH7TiEn0lCToT7u/A
	 TcHlRh+IrCtYpPsWvx3smMny7esLb8O9zVH5Fhmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/356] mmc: mtk-sd: use devm_mmc_alloc_host
Date: Thu, 12 Dec 2024 15:56:42 +0100
Message-ID: <20241212144247.903467874@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7a2fa8eed936b33b22e49b1d2349cd7d02f22710 ]

Allows removing several gotos.

Also fixed some wrong ones.

Added dev_err_probe where EPROBE_DEFER is possible.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20240930224919.355359-2-rosenp@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 291220451c77 ("mmc: mtk-sd: Fix error handle of probe function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 55 ++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 8b755f1627325..9ebf5aa5d9b18 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2674,20 +2674,18 @@ static int msdc_drv_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate MMC host for this device */
-	mmc = mmc_alloc_host(sizeof(struct msdc_host), &pdev->dev);
+	mmc = devm_mmc_alloc_host(&pdev->dev, sizeof(struct msdc_host));
 	if (!mmc)
 		return -ENOMEM;
 
 	host = mmc_priv(mmc);
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto host_free;
+		return ret;
 
 	host->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(host->base)) {
-		ret = PTR_ERR(host->base);
-		goto host_free;
-	}
+	if (IS_ERR(host->base))
+		return PTR_ERR(host->base);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
@@ -2698,18 +2696,16 @@ static int msdc_drv_probe(struct platform_device *pdev)
 
 	ret = mmc_regulator_get_supply(mmc);
 	if (ret)
-		goto host_free;
+		return ret;
 
 	ret = msdc_of_clock_parse(pdev, host);
 	if (ret)
-		goto host_free;
+		return ret;
 
 	host->reset = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								"hrst");
-	if (IS_ERR(host->reset)) {
-		ret = PTR_ERR(host->reset);
-		goto host_free;
-	}
+	if (IS_ERR(host->reset))
+		return PTR_ERR(host->reset);
 
 	/* only eMMC has crypto property */
 	if (!(mmc->caps2 & MMC_CAP2_NO_MMC)) {
@@ -2721,30 +2717,24 @@ static int msdc_drv_probe(struct platform_device *pdev)
 	}
 
 	host->irq = platform_get_irq(pdev, 0);
-	if (host->irq < 0) {
-		ret = host->irq;
-		goto host_free;
-	}
+	if (host->irq < 0)
+		return host->irq;
 
 	host->pinctrl = devm_pinctrl_get(&pdev->dev);
-	if (IS_ERR(host->pinctrl)) {
-		ret = PTR_ERR(host->pinctrl);
-		dev_err(&pdev->dev, "Cannot find pinctrl!\n");
-		goto host_free;
-	}
+	if (IS_ERR(host->pinctrl))
+		return dev_err_probe(&pdev->dev, PTR_ERR(host->pinctrl),
+				     "Cannot find pinctrl");
 
 	host->pins_default = pinctrl_lookup_state(host->pinctrl, "default");
 	if (IS_ERR(host->pins_default)) {
-		ret = PTR_ERR(host->pins_default);
 		dev_err(&pdev->dev, "Cannot find pinctrl default!\n");
-		goto host_free;
+		return PTR_ERR(host->pins_default);
 	}
 
 	host->pins_uhs = pinctrl_lookup_state(host->pinctrl, "state_uhs");
 	if (IS_ERR(host->pins_uhs)) {
-		ret = PTR_ERR(host->pins_uhs);
 		dev_err(&pdev->dev, "Cannot find pinctrl uhs!\n");
-		goto host_free;
+		return PTR_ERR(host->pins_uhs);
 	}
 
 	/* Support for SDIO eint irq ? */
@@ -2833,14 +2823,14 @@ static int msdc_drv_probe(struct platform_device *pdev)
 					     GFP_KERNEL);
 		if (!host->cq_host) {
 			ret = -ENOMEM;
-			goto host_free;
+			goto release_mem;
 		}
 		host->cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
 		host->cq_host->mmio = host->base + 0x800;
 		host->cq_host->ops = &msdc_cmdq_ops;
 		ret = cqhci_init(host->cq_host, mmc, true);
 		if (ret)
-			goto host_free;
+			goto release_mem;
 		mmc->max_segs = 128;
 		/* cqhci 16bit length */
 		/* 0 size, means 65536 so we don't have to -1 here */
@@ -2877,11 +2867,8 @@ static int msdc_drv_probe(struct platform_device *pdev)
 			host->dma.gpd, host->dma.gpd_addr);
 	if (host->dma.bd)
 		dma_free_coherent(&pdev->dev,
-			MAX_BD_NUM * sizeof(struct mt_bdma_desc),
-			host->dma.bd, host->dma.bd_addr);
-host_free:
-	mmc_free_host(mmc);
-
+				  MAX_BD_NUM * sizeof(struct mt_bdma_desc),
+				  host->dma.bd, host->dma.bd_addr);
 	return ret;
 }
 
@@ -2906,9 +2893,7 @@ static void msdc_drv_remove(struct platform_device *pdev)
 			2 * sizeof(struct mt_gpdma_desc),
 			host->dma.gpd, host->dma.gpd_addr);
 	dma_free_coherent(&pdev->dev, MAX_BD_NUM * sizeof(struct mt_bdma_desc),
-			host->dma.bd, host->dma.bd_addr);
-
-	mmc_free_host(mmc);
+			  host->dma.bd, host->dma.bd_addr);
 }
 
 static void msdc_save_reg(struct msdc_host *host)
-- 
2.43.0



