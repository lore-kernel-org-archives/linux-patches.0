Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3F3522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59950C433C8;
	Sun,  9 Jul 2023 11:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902198;
	bh=7IsLcgyZWkABgduqNenDFnyhy/pC7IyJFNC9AJYdvoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSHTuadQQWkxQQS+HoPk/Ae4gUg7su3p4b8BcFQ5xChmIvNpdh4V/NSq41LCNUWNH
	 EWU0k47KVcAJm8noADDu40oZbUPrrRsyp1fDhiPVZb3oB2+KzDJ3WZfHhu9xgFCsCV
	 31yiPtKhEhTwParBIdQtOhb4sjzaC0vNwsa6jGII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxing Liu <lyx2022@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 291/431] clk: imx: clk-imx8mp: improve error handling in imx8mp_clocks_probe()
Date: Sun,  9 Jul 2023 13:13:59 +0200
Message-ID: <20230709111457.968596166@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuxing Liu <lyx2022@hust.edu.cn>

[ Upstream commit 878b02d5f3b56cb090dbe2c70c89273be144087f ]

Replace of_iomap() and kzalloc() with devm_of_iomap() and devm_kzalloc()
which can automatically release the related memory when the device
or driver is removed or unloaded to avoid potential memory leak.

In this case, iounmap(anatop_base) in line 427,433 are removed
as manual release is not required.

Besides, referring to clk-imx8mq.c, check the return code of
of_clk_add_hw_provider, if it returns negtive, print error info
and unregister hws, which makes the program more robust.

Fixes: 9c140d992676 ("clk: imx: Add support for i.MX8MP clock driver")
Signed-off-by: Yuxing Liu <lyx2022@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230503070607.2462-1-lyx2022@hust.edu.cn
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 3253589851ffb..de7d2d2176bea 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -414,25 +414,22 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np;
 	void __iomem *anatop_base, *ccm_base;
+	int err;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mp-anatop");
-	anatop_base = of_iomap(np, 0);
+	anatop_base = devm_of_iomap(dev, np, 0, NULL);
 	of_node_put(np);
-	if (WARN_ON(!anatop_base))
-		return -ENOMEM;
+	if (WARN_ON(IS_ERR(anatop_base)))
+		return PTR_ERR(anatop_base);
 
 	np = dev->of_node;
 	ccm_base = devm_platform_ioremap_resource(pdev, 0);
-	if (WARN_ON(IS_ERR(ccm_base))) {
-		iounmap(anatop_base);
+	if (WARN_ON(IS_ERR(ccm_base)))
 		return PTR_ERR(ccm_base);
-	}
 
-	clk_hw_data = kzalloc(struct_size(clk_hw_data, hws, IMX8MP_CLK_END), GFP_KERNEL);
-	if (WARN_ON(!clk_hw_data)) {
-		iounmap(anatop_base);
+	clk_hw_data = devm_kzalloc(dev, struct_size(clk_hw_data, hws, IMX8MP_CLK_END), GFP_KERNEL);
+	if (WARN_ON(!clk_hw_data))
 		return -ENOMEM;
-	}
 
 	clk_hw_data->num = IMX8MP_CLK_END;
 	hws = clk_hw_data->hws;
@@ -721,7 +718,12 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 
 	imx_check_clk_hws(hws, IMX8MP_CLK_END);
 
-	of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
+	err = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
+	if (err < 0) {
+		dev_err(dev, "failed to register hws for i.MX8MP\n");
+		imx_unregister_hw_clocks(hws, IMX8MP_CLK_END);
+		return err;
+	}
 
 	imx_register_uart_clocks();
 
-- 
2.39.2



