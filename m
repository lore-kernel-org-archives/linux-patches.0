Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860227FB03;
	Fri, 17 Oct 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714976; cv=none; b=Ppnjsw2wqCaigIzZpflf+Cb2T07iPuuw/5ygGfJH6rNMlVU9x3DdUjQWDe1177Fs64/AruHKc5zLrNaJRi1i25C98TwvXPQPFKbMoeoMM9SZVFe2dOYb4JuWQx288d4WKAy5YnSE0121larJaMoWZyabQeBEewOHngIiL8xOfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714976; c=relaxed/simple;
	bh=PgUWCXVytbp7esri0YURpqDlH2EQJPvO4FSNQ+2Spvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4mIgM6/XEIKVMTyohFxRHk4e+Dj2pd7i5avdTO9PGsvHeh81/YFJmpKHfz5M+ks8EwDg6AdgFS74KbHk+THrqY1NzTr6+MiJOjfWIkj4kobFeozE87YfmOjzO3NjZJJ2C+Vu5bUmUZFaZ2KWAjwwW5j5YL8U489vHDFnqg6sfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyRW6ird; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyRW6ird"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B97C113D0;
	Fri, 17 Oct 2025 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714976;
	bh=PgUWCXVytbp7esri0YURpqDlH2EQJPvO4FSNQ+2Spvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyRW6irdpCwzxLbJiTiFB3EAHDDws8KMqdR8QN2FnxEgwGrMiwqSp+zjJmkKVUAJi
	 QpoMLlSOC2nN8cMn8eapgDO++OISXrfk00CHGXu39IVjg6A7+XB7dWovfytyHBV58c
	 eP1W3rqM4rXlGiuopBCAs2bpaPHB2mVxkgWwztQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Drew Fustini <fustini@kernel.org>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 022/371] clk: thead: th1520-ap: fix parent of padctrl0 clock
Date: Fri, 17 Oct 2025 16:49:57 +0200
Message-ID: <20251017145202.600678320@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 9e99b992c8874f323091d50a5e4727bbd138192d ]

The padctrl0 clock seems to be a child of the perisys_apb4_hclk clock,
gating the later makes padctrl0 registers stuck too.

Fix this relationship.

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 4dbd1df9a86d4..8a5d699638379 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -798,13 +798,17 @@ static CCU_GATE(CLK_PERISYS_APB3_HCLK, perisys_apb3_hclk, "perisys-apb3-hclk", p
 		0x150, 11, CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB4_HCLK, perisys_apb4_hclk, "perisys-apb4-hclk", perisys_ahb_hclk_pd,
 		0x150, 12, 0);
+static const struct clk_parent_data perisys_apb4_hclk_pd[] = {
+	{ .hw = &perisys_apb4_hclk.gate.hw },
+};
+
 static CCU_GATE(CLK_NPU_AXI, npu_axi_clk, "npu-axi", axi_aclk_pd, 0x1c8, 5, 0);
 static CCU_GATE(CLK_CPU2VP, cpu2vp_clk, "cpu2vp", axi_aclk_pd, 0x1e0, 13, 0);
 static CCU_GATE(CLK_EMMC_SDIO, emmc_sdio_clk, "emmc-sdio", emmc_sdio_ref_clk_pd, 0x204, 30, 0);
 static CCU_GATE(CLK_GMAC1, gmac1_clk, "gmac1", gmac_pll_clk_pd, 0x204, 26, 0);
 static CCU_GATE(CLK_PADCTRL1, padctrl1_clk, "padctrl1", perisys_apb_pclk_pd, 0x204, 24, 0);
 static CCU_GATE(CLK_DSMART, dsmart_clk, "dsmart", perisys_apb_pclk_pd, 0x204, 23, 0);
-static CCU_GATE(CLK_PADCTRL0, padctrl0_clk, "padctrl0", perisys_apb_pclk_pd, 0x204, 22, 0);
+static CCU_GATE(CLK_PADCTRL0, padctrl0_clk, "padctrl0", perisys_apb4_hclk_pd, 0x204, 22, 0);
 static CCU_GATE(CLK_GMAC_AXI, gmac_axi_clk, "gmac-axi", axi4_cpusys2_aclk_pd, 0x204, 21, 0);
 static CCU_GATE(CLK_GPIO3, gpio3_clk, "gpio3-clk", peri2sys_apb_pclk_pd, 0x204, 20, 0);
 static CCU_GATE(CLK_GMAC0, gmac0_clk, "gmac0", gmac_pll_clk_pd, 0x204, 19, 0);
-- 
2.51.0



