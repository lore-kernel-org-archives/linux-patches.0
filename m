Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD5A200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFCEC433D9;
	Fri, 21 Jul 2023 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965947;
	bh=InLgY5R1yt5ltAgfUQ4NB+agLhLp3iCfPX7N5DSB5kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZgIV6MLPTREz2Jwyc27FuG/JCk1KHhQQrzNbQFVaRM4vhorNXrro9hEp5QO1uZLz
	 qu7PwTDnlicaYko6OQ2NwbmY/atGbLcNsBJCOBRUkygtkeho4EkylaaiI3K/PQNt3w
	 2gdAv8c9wK8aySzJPTJ0vatwUm88/MOlgcjQnSVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Luo <m202171776@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/532] clk: imx: clk-imx8mn: fix memory leak in imx8mn_clocks_probe
Date: Fri, 21 Jul 2023 18:01:15 +0200
Message-ID: <20230721160623.677479455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Luo <m202171776@hust.edu.cn>

[ Upstream commit 188d070de9132667956f5aadd98d2bd87d3eac89 ]

Use devm_of_iomap() instead of of_iomap() to automatically handle
the unused ioremap region.

If any error occurs, regions allocated by kzalloc() will leak,
but using devm_kzalloc() instead will automatically free the memory
using devm_kfree().

Fixes: daeb14545514 ("clk: imx: imx8mn: Switch to clk_hw based API")
Fixes: 96d6392b54db ("clk: imx: Add support for i.MX8MN clock driver")
Signed-off-by: Hao Luo <m202171776@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20230411015107.2645-1-m202171776@hust.edu.cn
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 52903146fdbaf..4499da4154f06 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -299,7 +299,7 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int ret;
 
-	clk_hw_data = kzalloc(struct_size(clk_hw_data, hws,
+	clk_hw_data = devm_kzalloc(dev, struct_size(clk_hw_data, hws,
 					  IMX8MN_CLK_END), GFP_KERNEL);
 	if (WARN_ON(!clk_hw_data))
 		return -ENOMEM;
@@ -316,10 +316,10 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MN_CLK_EXT4] = imx_obtain_fixed_clk_hw(np, "clk_ext4");
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mn-anatop");
-	base = of_iomap(np, 0);
+	base = devm_of_iomap(dev, np, 0, NULL);
 	of_node_put(np);
-	if (WARN_ON(!base)) {
-		ret = -ENOMEM;
+	if (WARN_ON(IS_ERR(base))) {
+		ret = PTR_ERR(base);
 		goto unregister_hws;
 	}
 
-- 
2.39.2



