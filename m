Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6F714A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF1CC433C7;
	Thu, 24 Aug 2023 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897584;
	bh=G7O8w64I1ejbJPk9foQcyXSwVzVIKu2/J918GJw+pxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px8BrszhwsscLHmp5w6E9LF8bIRa9Mzn/RekVnItDnTsAXQIeFTEo7koZCDVTl7Zr
	 MK6l6lGgfIL9cb86Zlre8t/PyMj/d38hm9g8cYjF1XjmrQa9OeTm6Es3tfk/6MbXkk
	 4ln+G1tANSHJWG1Thz6/tT5Ozeb3c24EKW8HQRdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/135] mmc: meson-gx: use devm_mmc_alloc_host
Date: Thu, 24 Aug 2023 19:08:54 +0200
Message-ID: <20230824170619.882209560@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 418f7c2de1334b70fbee790911a1b46503230137 ]

Use new function devm_mmc_alloc_host() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/728f159b-885f-c78a-1a3d-f55c245250e1@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: b8ada54fa1b8 ("mmc: meson-gx: fix deferred probing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-gx-mmc.c | 52 +++++++++++----------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index e89bd6f4b317c..8a345ee2e6cf5 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1122,7 +1122,7 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	struct mmc_host *mmc;
 	int ret;
 
-	mmc = mmc_alloc_host(sizeof(struct meson_host), &pdev->dev);
+	mmc = devm_mmc_alloc_host(&pdev->dev, sizeof(struct meson_host));
 	if (!mmc)
 		return -ENOMEM;
 	host = mmc_priv(mmc);
@@ -1138,46 +1138,33 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	host->vqmmc_enabled = false;
 	ret = mmc_regulator_get_supply(mmc);
 	if (ret)
-		goto free_host;
+		return ret;
 
 	ret = mmc_of_parse(mmc);
-	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_warn(&pdev->dev, "error parsing DT: %d\n", ret);
-		goto free_host;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "error parsing DT\n");
 
 	host->data = (struct meson_mmc_data *)
 		of_device_get_match_data(&pdev->dev);
-	if (!host->data) {
-		ret = -EINVAL;
-		goto free_host;
-	}
+	if (!host->data)
+		return -EINVAL;
 
 	ret = device_reset_optional(&pdev->dev);
-	if (ret) {
-		dev_err_probe(&pdev->dev, ret, "device reset failed\n");
-		goto free_host;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "device reset failed\n");
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(host->regs)) {
-		ret = PTR_ERR(host->regs);
-		goto free_host;
-	}
+	if (IS_ERR(host->regs))
+		return PTR_ERR(host->regs);
 
 	host->irq = platform_get_irq(pdev, 0);
-	if (host->irq <= 0) {
-		ret = -EINVAL;
-		goto free_host;
-	}
+	if (host->irq <= 0)
+		return -EINVAL;
 
 	host->pinctrl = devm_pinctrl_get(&pdev->dev);
-	if (IS_ERR(host->pinctrl)) {
-		ret = PTR_ERR(host->pinctrl);
-		goto free_host;
-	}
+	if (IS_ERR(host->pinctrl))
+		return PTR_ERR(host->pinctrl);
 
 	host->pins_clk_gate = pinctrl_lookup_state(host->pinctrl,
 						   "clk-gate");
@@ -1188,14 +1175,12 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	}
 
 	host->core_clk = devm_clk_get(&pdev->dev, "core");
-	if (IS_ERR(host->core_clk)) {
-		ret = PTR_ERR(host->core_clk);
-		goto free_host;
-	}
+	if (IS_ERR(host->core_clk))
+		return PTR_ERR(host->core_clk);
 
 	ret = clk_prepare_enable(host->core_clk);
 	if (ret)
-		goto free_host;
+		return ret;
 
 	ret = meson_mmc_clk_init(host);
 	if (ret)
@@ -1290,8 +1275,6 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(host->mmc_clk);
 err_core_clk:
 	clk_disable_unprepare(host->core_clk);
-free_host:
-	mmc_free_host(mmc);
 	return ret;
 }
 
@@ -1315,7 +1298,6 @@ static int meson_mmc_remove(struct platform_device *pdev)
 	clk_disable_unprepare(host->mmc_clk);
 	clk_disable_unprepare(host->core_clk);
 
-	mmc_free_host(host->mmc);
 	return 0;
 }
 
-- 
2.40.1



