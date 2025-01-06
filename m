Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1112F7082A;
	Mon,  6 Jan 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177936; cv=none; b=ALX0eGS7XIWnS4OqWKPQZZcF5x+dl9AeE05v3J2YCM9j0SATry/mzAVFXaFx8StOE8/nURT8osaafU9YRP+XGYHFNLE448pYCYZxCyfWXXF0wQheGJ/8t7nPYcHDNxz4ZuhLK1P4AMXcAhzJoH1IKX3l7yXD4YblZoZMLJZ8mys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177936; c=relaxed/simple;
	bh=JXoQy2ZkmnML1vQr2ytdHEAybVRptx7lCiCxPZfZDiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrQigJ02F5QU+enVup10V4yfYJXStzLjr1+k+7LXbTC6rSG5FvE24YsuL8qb3siXBH+GQOo3sq8jhaIIiL+R7W8VAYNtSqk4s8xj+hYPMZXIEU3nn1zFDeDdvFwIGs7Vks/KMCWQX92aveJZOkmcJHpB+bDGR4LNHJKwQhgXeeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jj4+KwwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jj4+KwwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88166C4CED2;
	Mon,  6 Jan 2025 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177935;
	bh=JXoQy2ZkmnML1vQr2ytdHEAybVRptx7lCiCxPZfZDiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj4+KwwWlg2FXTQ2/l208snq54+c2LMYwOerQ9DEcoRroPXQoNuEax5U/QivTvskb
	 JnF+BLBALXM+YhyjMZdS7EnCami+ZwgZQ9u9Qew2DXMT2Bi36r63B/fBUAXNBnvVJ+
	 ZxHxyZ3yyfEvAh73BBpnuUZiCw3Fx4cx+ayW+4rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Kiselev <bigunclemax@gmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Drew Fustini <dfustini@tenstorrent.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/156] clk: thead: Fix TH1520 emmc and shdci clock rate
Date: Mon,  6 Jan 2025 16:16:32 +0100
Message-ID: <20250106151145.720137573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maksim Kiselev <bigunclemax@gmail.com>

[ Upstream commit f4bf0b909a6bf64a2220a42a7c8b8c2ee1b77b89 ]

In accordance with LicheePi 4A BSP the clock that comes to emmc/sdhci
is 198Mhz which is got through frequency division of source clock
VIDEO PLL by 4 [1].

But now the AP_SUBSYS driver sets the CLK EMMC SDIO to the same
frequency as the VIDEO PLL, equal to 792 MHz. This causes emmc/sdhci
to work 4 times slower.

Let's fix this issue by adding fixed factor clock that divides
VIDEO PLL by 4 for emmc/sdhci.

Link: https://github.com/revyos/thead-kernel/blob/7563179071a314f41cdcdbfd8cf6e101e73707f3/drivers/clk/thead/clk-light-fm.c#L454

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Maksim Kiselev <bigunclemax@gmail.com>
Link: https://lore.kernel.org/r/20241210083029.92620-1-bigunclemax@gmail.com
Tested-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Drew Fustini <dfustini@tenstorrent.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 17e32ae08720..1015fab95251 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -779,6 +779,13 @@ static struct ccu_div dpu1_clk = {
 	},
 };
 
+static CLK_FIXED_FACTOR_HW(emmc_sdio_ref_clk, "emmc-sdio-ref",
+			   &video_pll_clk.common.hw, 4, 1, 0);
+
+static const struct clk_parent_data emmc_sdio_ref_clk_pd[] = {
+	{ .hw = &emmc_sdio_ref_clk.hw },
+};
+
 static CCU_GATE(CLK_BROM, brom_clk, "brom", ahb2_cpusys_hclk_pd, 0x100, BIT(4), 0);
 static CCU_GATE(CLK_BMU, bmu_clk, "bmu", axi4_cpusys2_aclk_pd, 0x100, BIT(5), 0);
 static CCU_GATE(CLK_AON2CPU_A2X, aon2cpu_a2x_clk, "aon2cpu-a2x", axi4_cpusys2_aclk_pd,
@@ -798,7 +805,7 @@ static CCU_GATE(CLK_PERISYS_APB4_HCLK, perisys_apb4_hclk, "perisys-apb4-hclk", p
 		0x150, BIT(12), 0);
 static CCU_GATE(CLK_NPU_AXI, npu_axi_clk, "npu-axi", axi_aclk_pd, 0x1c8, BIT(5), 0);
 static CCU_GATE(CLK_CPU2VP, cpu2vp_clk, "cpu2vp", axi_aclk_pd, 0x1e0, BIT(13), 0);
-static CCU_GATE(CLK_EMMC_SDIO, emmc_sdio_clk, "emmc-sdio", video_pll_clk_pd, 0x204, BIT(30), 0);
+static CCU_GATE(CLK_EMMC_SDIO, emmc_sdio_clk, "emmc-sdio", emmc_sdio_ref_clk_pd, 0x204, BIT(30), 0);
 static CCU_GATE(CLK_GMAC1, gmac1_clk, "gmac1", gmac_pll_clk_pd, 0x204, BIT(26), 0);
 static CCU_GATE(CLK_PADCTRL1, padctrl1_clk, "padctrl1", perisys_apb_pclk_pd, 0x204, BIT(24), 0);
 static CCU_GATE(CLK_DSMART, dsmart_clk, "dsmart", perisys_apb_pclk_pd, 0x204, BIT(23), 0);
@@ -1059,6 +1066,10 @@ static int th1520_clk_probe(struct platform_device *pdev)
 		return ret;
 	priv->hws[CLK_PLL_GMAC_100M] = &gmac_pll_clk_100m.hw;
 
+	ret = devm_clk_hw_register(dev, &emmc_sdio_ref_clk.hw);
+	if (ret)
+		return ret;
+
 	ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_onecell_get, priv);
 	if (ret)
 		return ret;
-- 
2.39.5



