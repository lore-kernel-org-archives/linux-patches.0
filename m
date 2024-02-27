Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF013A26F;
	Tue, 27 Feb 2024 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042865; cv=none; b=NANDWwV5fid+r1zAEzEFfOG0bh2N+NXSpPo+3q2MfXBtb3S9dNhLNokPLfFrCH55AbPevmbM3YY0AjshoWZgk85ILsUr73Avg3OrXNUFJAziS3QbHeTMrJLGMbacT6orkSsbeptbyd0pHFlArPRTa5g03m3mFAq46b9zgpti2Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042865; c=relaxed/simple;
	bh=k5YHenF/TkGz+yuyYqMCVvRCC0BlB/qaFyLmNmour0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA+gtROvlqOe5pjFcIm2rxuGuXO4w7JRv8SRRbypjjpjIfxltM9psDLZ4buHfKIDqyE5Gs5VnHJxk+AIeDibkVl7q6NBkzArNadFngOcRKXFf4rs2yeAdCJAGUUIDpQ48xkursRKaBjFkKTih1fKR9jfR3HWdF9LBV/094PzxT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm3euMCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm3euMCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC786C433F1;
	Tue, 27 Feb 2024 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042865;
	bh=k5YHenF/TkGz+yuyYqMCVvRCC0BlB/qaFyLmNmour0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm3euMCEcfAbxr1BukEQf92UZ4/GB7dHOV85EFW9Q3ts2VgbD+x+KHiB3z/U2m/YU
	 ADbNKTX+5e9DJC/lBn3OyuXWyYg+EdG/D7rW9/kJF1jyvcKBa/eZxzEM0Kc0aoWvpf
	 2SI89e/5I/iLey8DsebtXQTDZo6PtlR2eZaDF28o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Abel Vesa <abel.vesa@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/245] clk: imx8mp: add clkout1/2 support
Date: Tue, 27 Feb 2024 14:25:36 +0100
Message-ID: <20240227131620.024285823@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 43896f56b59eeaf08687fa976257ae7083d01b41 ]

clkout1 and clkout2 allow to supply clocks from the SoC to the board,
which is used by some board designs to provide reference clocks.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220427162131.3127303-1-l.stach@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Stable-dep-of: 5c1f7f109094 ("dt-bindings: clocks: imx8mp: Add ID for usb suspend clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c             | 14 ++++++++++++++
 include/dt-bindings/clock/imx8mp-clock.h |  9 +++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index b1c83f9809123..cdeacdc143b5c 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -396,6 +396,11 @@ static const char * const imx8mp_sai7_sels[] = {"osc_24m", "audio_pll1_out", "au
 
 static const char * const imx8mp_dram_core_sels[] = {"dram_pll_out", "dram_alt_root", };
 
+static const char * const imx8mp_clkout_sels[] = {"audio_pll1_out", "audio_pll2_out", "video_pll1_out",
+						  "dummy", "dummy", "gpu_pll_out", "vpu_pll_out",
+						  "arm_pll_out", "sys_pll1", "sys_pll2", "sys_pll3",
+						  "dummy", "dummy", "osc_24m", "dummy", "osc_32k"};
+
 static struct clk_hw **hws;
 static struct clk_hw_onecell_data *clk_hw_data;
 
@@ -514,6 +519,15 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_SYS_PLL2_500M] = imx_clk_hw_fixed_factor("sys_pll2_500m", "sys_pll2_500m_cg", 1, 2);
 	hws[IMX8MP_SYS_PLL2_1000M] = imx_clk_hw_fixed_factor("sys_pll2_1000m", "sys_pll2_out", 1, 1);
 
+	hws[IMX8MP_CLK_CLKOUT1_SEL] = imx_clk_hw_mux2("clkout1_sel", anatop_base + 0x128, 4, 4,
+						      imx8mp_clkout_sels, ARRAY_SIZE(imx8mp_clkout_sels));
+	hws[IMX8MP_CLK_CLKOUT1_DIV] = imx_clk_hw_divider("clkout1_div", "clkout1_sel", anatop_base + 0x128, 0, 4);
+	hws[IMX8MP_CLK_CLKOUT1] = imx_clk_hw_gate("clkout1", "clkout1_div", anatop_base + 0x128, 8);
+	hws[IMX8MP_CLK_CLKOUT2_SEL] = imx_clk_hw_mux2("clkout2_sel", anatop_base + 0x128, 20, 4,
+						      imx8mp_clkout_sels, ARRAY_SIZE(imx8mp_clkout_sels));
+	hws[IMX8MP_CLK_CLKOUT2_DIV] = imx_clk_hw_divider("clkout2_div", "clkout2_sel", anatop_base + 0x128, 16, 4);
+	hws[IMX8MP_CLK_CLKOUT2] = imx_clk_hw_gate("clkout2", "clkout2_div", anatop_base + 0x128, 24);
+
 	hws[IMX8MP_CLK_A53_DIV] = imx8m_clk_hw_composite_core("arm_a53_div", imx8mp_a53_sels, ccm_base + 0x8000);
 	hws[IMX8MP_CLK_A53_SRC] = hws[IMX8MP_CLK_A53_DIV];
 	hws[IMX8MP_CLK_A53_CG] = hws[IMX8MP_CLK_A53_DIV];
diff --git a/include/dt-bindings/clock/imx8mp-clock.h b/include/dt-bindings/clock/imx8mp-clock.h
index 4fff3e57f460b..a02fd723168cc 100644
--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -318,10 +318,15 @@
 #define IMX8MP_CLK_AUDIO_AXI			310
 #define IMX8MP_CLK_HSIO_AXI			311
 #define IMX8MP_CLK_MEDIA_ISP			312
-
 #define IMX8MP_CLK_MEDIA_DISP2_PIX		313
+#define IMX8MP_CLK_CLKOUT1_SEL			314
+#define IMX8MP_CLK_CLKOUT1_DIV			315
+#define IMX8MP_CLK_CLKOUT1			316
+#define IMX8MP_CLK_CLKOUT2_SEL			317
+#define IMX8MP_CLK_CLKOUT2_DIV			318
+#define IMX8MP_CLK_CLKOUT2			319
 
-#define IMX8MP_CLK_END				314
+#define IMX8MP_CLK_END				320
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1
-- 
2.43.0



