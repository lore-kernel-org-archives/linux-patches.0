Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901FE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16681C433EF;
	Wed, 28 Dec 2022 15:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242416;
	bh=GiRr8oyJrcGZaaBn7R6VnIGDzjvuXcxVtuODgBd6lJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bW89q0r9ArHJEPKe5mZ7f+IO8C3eg7x44BYm/EnmGUX4fQzfaHdotsJDJsqr3E4/
	 ks3w2bV+P2zIA6YEwIeCEQQXWQHWbqT/bHM9i1dSL8sMee184G0nWu0MythxunUyf6
	 CJkZEys6uq0dL/XJu4GpSe8Nf6s04dI7eBflSyvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0367/1146] clk: imx93: unmap anatop base in error handling path
Date: Wed, 28 Dec 2022 15:31:46 +0100
Message-Id: <20221228144340.134571411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit bda7b7f396f94d8df89ecacc88f2826908e8762c ]

The anatop base is not unmapped during error handling path, fix it.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221028095211.2598312-2-peng.fan@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index 40ecee3b5e78..6c39f3431c79 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -258,7 +258,7 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	const struct imx93_clk_root *root;
 	const struct imx93_clk_ccgr *ccgr;
-	void __iomem *base = NULL;
+	void __iomem *base, *anatop_base;
 	int i, ret;
 
 	clk_hw_data = kzalloc(struct_size(clk_hw_data, hws,
@@ -285,20 +285,22 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 								    "sys_pll_pfd2", 1, 2);
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx93-anatop");
-	base = of_iomap(np, 0);
+	anatop_base = of_iomap(np, 0);
 	of_node_put(np);
-	if (WARN_ON(!base))
+	if (WARN_ON(!anatop_base))
 		return -ENOMEM;
 
-	clks[IMX93_CLK_AUDIO_PLL] = imx_clk_fracn_gppll("audio_pll", "osc_24m", base + 0x1200,
+	clks[IMX93_CLK_AUDIO_PLL] = imx_clk_fracn_gppll("audio_pll", "osc_24m", anatop_base + 0x1200,
 							&imx_fracn_gppll);
-	clks[IMX93_CLK_VIDEO_PLL] = imx_clk_fracn_gppll("video_pll", "osc_24m", base + 0x1400,
+	clks[IMX93_CLK_VIDEO_PLL] = imx_clk_fracn_gppll("video_pll", "osc_24m", anatop_base + 0x1400,
 							&imx_fracn_gppll);
 
 	np = dev->of_node;
 	base = devm_platform_ioremap_resource(pdev, 0);
-	if (WARN_ON(IS_ERR(base)))
+	if (WARN_ON(IS_ERR(base))) {
+		iounmap(anatop_base);
 		return PTR_ERR(base);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(root_array); i++) {
 		root = &root_array[i];
@@ -327,6 +329,7 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 
 unregister_hws:
 	imx_unregister_hw_clocks(clks, IMX93_CLK_END);
+	iounmap(anatop_base);
 
 	return ret;
 }
-- 
2.35.1



