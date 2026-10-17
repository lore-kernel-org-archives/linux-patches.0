Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F9C38C2C0;
	Sat, 17 Oct 2026 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253544; cv=none; b=Zot+eWgzXGz6UoX8XA1YsBBq+0kRwtkEdTs1m/hP3IeOPUQdCQigD0InCrczVU2Sl4ty8g5mQT5OY+Jo0pjh0KgZCQ+YsBIQU+iUsJDI9Yrj+xljMNxl/MBeJ2qXWIZn70R1X/gbyHte1GA2OQgcDpGmLNPag8/7WSI4yTnpldY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253544; c=relaxed/simple;
	bh=i0Dl7wJ5UmPyovgYJ5l6VO9U/Gs9TjSf9JlTbUxGQNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXINVnjGMj8LWUD2vW5QrVkFp7+Qxj/jm0hne2LSGVoX6yKeyM2/2C1DMnjr3O1/e4iq5coWJ+KKifGRkfIY7vF/bOBdhWITI0ImRj3VKXlCZzy3QAmHRXAKbUOalFZuO+kw9PG0oY3JYwklFNLStdxs0WH7FANOty5p+6b+yXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5oFkA+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5oFkA+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7431F000C5;
	Sat, 17 Oct 2026 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253543;
	bh=SjEiVbh050IXyDzh6clGvxVpI9BpWhRdVTblUlch52Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5oFkA+XUIToD3SYz/IAh8T0LXsOS5Tg1TjhfAsOkaEs0cUdiYgJEM7Bsp6Ey1eoU
	 Bi3XVr1kpiFrWYNi/UVYWDag2fWldV6caAitxqhCaZLh4NL9BnsIWjMRsFacHjt5nH
	 R9U+egbF4OM8SES8FRscFkN2kdDmGltlhhSJ93EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Drew Fustini <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/869] clk: thead: th1520-ap: set all AXI clocks to CLK_IS_CRITICAL
Date: Sat, 17 Oct 2026 17:49:52 +0200
Message-ID: <20261017160040.910911931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit c567bc5fc68c4388c00e11fc65fd14fe86b52070 ]

The AXI crossbar of TH1520 has no proper timeout handling, which means
gating AXI clocks can easily lead to bus timeout and thus system hang.

Set all AXI clock gates to CLK_IS_CRITICAL. All these clock gates are
ungated by default on system reset.

In addition, convert all current CLK_IGNORE_UNUSED usage to
CLK_IS_CRITICAL to prevent unwanted clock gating.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index c8ebacc6934ab..510670b9c983e 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -493,7 +493,7 @@ static struct ccu_div axi4_cpusys2_aclk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_HW("axi4-cpusys2-aclk",
 					      gmac_pll_clk_parent,
 					      &ccu_div_ops,
-					      0),
+					      CLK_IS_CRITICAL),
 	},
 };
 
@@ -515,7 +515,7 @@ static struct ccu_div axi_aclk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_DATA("axi-aclk",
 						      axi_parents,
 						      &ccu_div_ops,
-						      0),
+						      CLK_IS_CRITICAL),
 	},
 };
 
@@ -664,7 +664,7 @@ static struct ccu_div apb_pclk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_DATA("apb-pclk",
 						      apb_parents,
 						      &ccu_div_ops,
-						      CLK_IGNORE_UNUSED),
+						      CLK_IS_CRITICAL),
 	},
 };
 
@@ -695,7 +695,7 @@ static struct ccu_div vi_clk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_HW("vi",
 					      video_pll_clk_parent,
 					      &ccu_div_ops,
-					      0),
+					      CLK_IS_CRITICAL),
 	},
 };
 
@@ -720,7 +720,7 @@ static struct ccu_div vo_axi_clk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_HW("vo-axi",
 					      video_pll_clk_parent,
 					      &ccu_div_ops,
-					      0),
+					      CLK_IS_CRITICAL),
 	},
 };
 
@@ -745,7 +745,7 @@ static struct ccu_div vp_axi_clk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_HW("vp-axi",
 					      video_pll_clk_parent,
 					      &ccu_div_ops,
-					      CLK_IGNORE_UNUSED),
+					      CLK_IS_CRITICAL),
 	},
 };
 
@@ -796,23 +796,23 @@ static const struct clk_parent_data emmc_sdio_ref_clk_pd[] = {
 static CCU_GATE(CLK_BROM, brom_clk, "brom", ahb2_cpusys_hclk_pd, 0x100, BIT(4), 0);
 static CCU_GATE(CLK_BMU, bmu_clk, "bmu", axi4_cpusys2_aclk_pd, 0x100, BIT(5), 0);
 static CCU_GATE(CLK_AON2CPU_A2X, aon2cpu_a2x_clk, "aon2cpu-a2x", axi4_cpusys2_aclk_pd,
-		0x134, BIT(8), 0);
+		0x134, BIT(8), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_X2X_CPUSYS, x2x_cpusys_clk, "x2x-cpusys", axi4_cpusys2_aclk_pd,
-		0x134, BIT(7), 0);
+		0x134, BIT(7), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_CPU2AON_X2H, cpu2aon_x2h_clk, "cpu2aon-x2h", axi_aclk_pd,
-		0x138, BIT(8), CLK_IGNORE_UNUSED);
+		0x138, BIT(8), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_CPU2PERI_X2H, cpu2peri_x2h_clk, "cpu2peri-x2h", axi4_cpusys2_aclk_pd,
-		0x140, BIT(9), CLK_IGNORE_UNUSED);
+		0x140, BIT(9), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_PERISYS_APB1_HCLK, perisys_apb1_hclk, "perisys-apb1-hclk", perisys_ahb_hclk_pd,
-		0x150, BIT(9), CLK_IGNORE_UNUSED);
+		0x150, BIT(9), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_PERISYS_APB2_HCLK, perisys_apb2_hclk, "perisys-apb2-hclk", perisys_ahb_hclk_pd,
-		0x150, BIT(10), CLK_IGNORE_UNUSED);
+		0x150, BIT(10), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_PERISYS_APB3_HCLK, perisys_apb3_hclk, "perisys-apb3-hclk", perisys_ahb_hclk_pd,
-		0x150, BIT(11), CLK_IGNORE_UNUSED);
+		0x150, BIT(11), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_PERISYS_APB4_HCLK, perisys_apb4_hclk, "perisys-apb4-hclk", perisys_ahb_hclk_pd,
 		0x150, BIT(12), 0);
-static CCU_GATE(CLK_NPU_AXI, npu_axi_clk, "npu-axi", axi_aclk_pd, 0x1c8, BIT(5), 0);
-static CCU_GATE(CLK_CPU2VP, cpu2vp_clk, "cpu2vp", axi_aclk_pd, 0x1e0, BIT(13), 0);
+static CCU_GATE(CLK_NPU_AXI, npu_axi_clk, "npu-axi", axi_aclk_pd, 0x1c8, BIT(5), CLK_IS_CRITICAL);
+static CCU_GATE(CLK_CPU2VP, cpu2vp_clk, "cpu2vp", axi_aclk_pd, 0x1e0, BIT(13), CLK_IS_CRITICAL);
 static CCU_GATE(CLK_EMMC_SDIO, emmc_sdio_clk, "emmc-sdio", emmc_sdio_ref_clk_pd, 0x204, BIT(30), 0);
 static CCU_GATE(CLK_GMAC1, gmac1_clk, "gmac1", gmac_pll_clk_pd, 0x204, BIT(26), 0);
 static CCU_GATE(CLK_PADCTRL1, padctrl1_clk, "padctrl1", perisys_apb_pclk_pd, 0x204, BIT(24), 0);
-- 
2.53.0



