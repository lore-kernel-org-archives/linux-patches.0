Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D19328369
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftjr1VwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAF5C4E778;
	Wed, 15 Nov 2023 20:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081660;
	bh=sT3GwJ7i8Jnoxs23vTgGbj4bznyS6GpoVpde9IyO0YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftjr1VwUXdF4PfandPhtnKIr6WW8kZnl50jXczxCyHHm6C/ZWdNQjQQJYFGHQBAQh
	 AJvMZF+b2ey8oA59Ocl7XOfGVQiFYO53VmOFS6q7pYfFhr2P0G1tw3RiE6NRloVMwF
	 tYAHjyja09wuxl4iTirH9AOhvlboCsoLuwtdFRVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/191] clk: imx: imx8mq: correct error handling path
Date: Wed, 15 Nov 2023 15:45:20 -0500
Message-ID: <20231115204647.299010835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 577ad169966e6e75b10e004389a3f79813e84b5d ]

Avoid memory leak in error handling path. It does not make
much sense for the SoC without clk driver, to make program behavior
correct, let's fix it.

Fixes: b80522040cd3 ("clk: imx: Add clock driver for i.MX8MQ CCM")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202309240551.e46NllPa-lkp@intel.com/
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20231001122618.194498-1-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mq.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mq.c b/drivers/clk/imx/clk-imx8mq.c
index f679e5cc320b5..89313dd7a57f6 100644
--- a/drivers/clk/imx/clk-imx8mq.c
+++ b/drivers/clk/imx/clk-imx8mq.c
@@ -280,8 +280,7 @@ static int imx8mq_clocks_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int err;
 
-	clk_hw_data = kzalloc(struct_size(clk_hw_data, hws,
-					  IMX8MQ_CLK_END), GFP_KERNEL);
+	clk_hw_data = devm_kzalloc(dev, struct_size(clk_hw_data, hws, IMX8MQ_CLK_END), GFP_KERNEL);
 	if (WARN_ON(!clk_hw_data))
 		return -ENOMEM;
 
@@ -298,10 +297,12 @@ static int imx8mq_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MQ_CLK_EXT4] = imx_obtain_fixed_clk_hw(np, "clk_ext4");
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mq-anatop");
-	base = of_iomap(np, 0);
+	base = devm_of_iomap(dev, np, 0, NULL);
 	of_node_put(np);
-	if (WARN_ON(!base))
-		return -ENOMEM;
+	if (WARN_ON(IS_ERR(base))) {
+		err = PTR_ERR(base);
+		goto unregister_hws;
+	}
 
 	hws[IMX8MQ_ARM_PLL_REF_SEL] = imx_clk_hw_mux("arm_pll_ref_sel", base + 0x28, 16, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
 	hws[IMX8MQ_GPU_PLL_REF_SEL] = imx_clk_hw_mux("gpu_pll_ref_sel", base + 0x18, 16, 2, pll_ref_sels, ARRAY_SIZE(pll_ref_sels));
@@ -373,8 +374,10 @@ static int imx8mq_clocks_probe(struct platform_device *pdev)
 
 	np = dev->of_node;
 	base = devm_platform_ioremap_resource(pdev, 0);
-	if (WARN_ON(IS_ERR(base)))
-		return PTR_ERR(base);
+	if (WARN_ON(IS_ERR(base))) {
+		err = PTR_ERR(base);
+		goto unregister_hws;
+	}
 
 	/* CORE */
 	hws[IMX8MQ_CLK_A53_DIV] = imx8m_clk_hw_composite_core("arm_a53_div", imx8mq_a53_sels, base + 0x8000);
-- 
2.42.0



