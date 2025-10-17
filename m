Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B802F12B0;
	Fri, 17 Oct 2025 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714979; cv=none; b=FR5lkKHTlBqUn7ZXyMukaaiFUZ8VKs8p5ym2jE7LmYMt6ONczsgfnmdae9rFRIsKx99QZs8hlqVFFkU8GrgIshcbfSDhYeFdviAmQMGxk3CdfMXVMuI1g32vvyDzIFJAO44DG/VZ7aWOC1/wJmqn0YRv+RRb3Sol950p/zAaNi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714979; c=relaxed/simple;
	bh=ic3y6EOy1qVU5mauFnu7X8TAG/SgmZi2w0uVQhg7y4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k42k6J9G4A2dulL7ZTefdm+Y1FUPMeGgT0hHxTDWYVIioNmeW5MOfYuFV6UYq1mHWhUnpq8uvgXjctBe6+MOTY9uq7kCg1pFQxIU/EnwG1bZ1WJi9ioktF0Dg89/xDC6fU4/ezHtLlP2iTPMDRUNvc5C4v+T6O4e8XiVLstj/v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rD3rRJhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rD3rRJhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05B4C113D0;
	Fri, 17 Oct 2025 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714979;
	bh=ic3y6EOy1qVU5mauFnu7X8TAG/SgmZi2w0uVQhg7y4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rD3rRJhBLZx0jqTuUZqddmAkI5PwHg4A2raOsmlQWFtd2E0AmiXOOGtjw7K+TwMLQ
	 RRTzVbXsqei0tKwC4QiSFU8GntCPr8L1grKDNN1mkzW2iiPrntSBWiNSQfGl34MVsl
	 x7FxTcCKp5/XGrx6Q64yIZJw4t9IIpvqF98tIcrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Drew Fustini <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 023/371] clk: thead: Correct parent for DPU pixel clocks
Date: Fri, 17 Oct 2025 16:49:58 +0200
Message-ID: <20251017145202.636502913@linuxfoundation.org>
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

From: Michal Wilczynski <m.wilczynski@samsung.com>

[ Upstream commit c51a37ffea3813374a8f7955abbba6da25357388 ]

The dpu0_pixelclk and dpu1_pixelclk gates were incorrectly parented to
the video_pll_clk.

According to the TH1520 TRM, the "dpu0_pixelclk" should be sourced from
"DPU0 PLL DIV CLK". In this driver, "DPU0 PLL DIV CLK" corresponds to
the `dpu0_clk` clock, which is a divider whose parent is the
`dpu0_pll_clk`.

This patch corrects the clock hierarchy by reparenting `dpu0_pixelclk`
to `dpu0_clk`. By symmetry, `dpu1_pixelclk` is also reparented to its
correct source, `dpu1_clk`.

Fixes: 50d4b157fa96 ("clk: thead: Add clock support for VO subsystem in T-HEAD TH1520 SoC")
Reported-by: Icenowy Zheng <uwu@icenowy.me>
Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
[Icenowy: add Drew's R-b and rebased atop ccu_gate refactor]
Reviewed-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 8a5d699638379..ec52726fbea95 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -761,6 +761,10 @@ static struct ccu_div dpu0_clk = {
 	},
 };
 
+static const struct clk_parent_data dpu0_clk_pd[] = {
+	{ .hw = &dpu0_clk.common.hw }
+};
+
 static struct ccu_div dpu1_clk = {
 	.div		= TH_CCU_DIV_FLAGS(0, 8, CLK_DIVIDER_ONE_BASED),
 	.common		= {
@@ -773,6 +777,10 @@ static struct ccu_div dpu1_clk = {
 	},
 };
 
+static const struct clk_parent_data dpu1_clk_pd[] = {
+	{ .hw = &dpu1_clk.common.hw }
+};
+
 static CLK_FIXED_FACTOR_HW(emmc_sdio_ref_clk, "emmc-sdio-ref",
 			   &video_pll_clk.common.hw, 4, 1, 0);
 
@@ -853,9 +861,9 @@ static CCU_GATE(CLK_GPU_CORE, gpu_core_clk, "gpu-core-clk", video_pll_clk_pd,
 static CCU_GATE(CLK_GPU_CFG_ACLK, gpu_cfg_aclk, "gpu-cfg-aclk",
 		video_pll_clk_pd, 0x0, 4, 0);
 static CCU_GATE(CLK_DPU_PIXELCLK0, dpu0_pixelclk, "dpu0-pixelclk",
-		video_pll_clk_pd, 0x0, 5, 0);
+		dpu0_clk_pd, 0x0, 5, 0);
 static CCU_GATE(CLK_DPU_PIXELCLK1, dpu1_pixelclk, "dpu1-pixelclk",
-		video_pll_clk_pd, 0x0, 6, 0);
+		dpu1_clk_pd, 0x0, 6, 0);
 static CCU_GATE(CLK_DPU_HCLK, dpu_hclk, "dpu-hclk", video_pll_clk_pd, 0x0,
 		7, 0);
 static CCU_GATE(CLK_DPU_ACLK, dpu_aclk, "dpu-aclk", video_pll_clk_pd, 0x0,
-- 
2.51.0



