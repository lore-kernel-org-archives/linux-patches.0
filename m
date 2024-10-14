Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7031B4F2B;
	Mon, 14 Oct 2024 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918049; cv=none; b=HPkeLTTIqoDp+OR/4Ayenj2xhCnIpgngYfHI+DNnDp7pIsp6Wr63as6u3jaGwDBxYCDxjgW5AC61YDYvevbZaG99Kh05CxydUecdwew4WvYVUk+S/1Q1yvnsYapOuVk48zWReht6Z7Xf2onnG9bBL9Lia+3c2sTmKlvgSTmjFDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918049; c=relaxed/simple;
	bh=6Y1SrdgK5T5DAKl3EwmrlBxi9RUEbMGYDEIDNTjwJ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8DW6e5qhuq1ANiSA0rvU3LT1PfARrg3kxU5Udy3Gw/TOnvG2mN45ptxNq8yWVg2JYZvw64H7/Gckx+EA5kr4SkeRry4CB5IqIYhHpOs9KfzLOim/swJ6OijpyxjSdSy/MMzY3WZng8tv1SjTh8wzYW+HoiGGwABdCr0ej6QAy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gic1jhhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gic1jhhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14571C4CEC3;
	Mon, 14 Oct 2024 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918049;
	bh=6Y1SrdgK5T5DAKl3EwmrlBxi9RUEbMGYDEIDNTjwJ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gic1jhhXpJKsH7giku8aH1dhujrWwyAzZr856gxk6ozMShQaKf53KYvOJx3ueIMft
	 4yObacdlbDJQN56OxmNtd/ov1rcylM/AWh9nIMBBfqkwvPuGtiGl0ViUG63S2slxl7
	 RnV4RaAqrVji57rx3/8i1Zb4utUgi4HewTv7jChs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/798] clk: imx: imx8qxp: Parent should be initialized earlier than the clock
Date: Mon, 14 Oct 2024 16:12:24 +0200
Message-ID: <20241014141225.395821998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 766c386c16c9899461b83573a06380d364c6e261 ]

The initialization order of SCU clocks affects the sequence of SCU clock
resume. If there are no other effects, the earlier the initialization,
the earlier the resume. During SCU clock resume, the clock rate is
restored. As SCFW guidelines, configure the parent clock rate before
configuring the child rate.

Fixes: babfaa9556d7 ("clk: imx: scu: add more scu clocks")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240607133347.3291040-15-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index fd89f0090779f..28265e28856c2 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -166,8 +166,8 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 	imx_clk_scu("pwm_clk",   IMX_SC_R_LCD_0_PWM_0, IMX_SC_PM_CLK_PER);
 	imx_clk_scu("elcdif_pll", IMX_SC_R_ELCDIF_PLL, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu2("lcd_clk", lcd_sels, ARRAY_SIZE(lcd_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_PER);
-	imx_clk_scu2("lcd_pxl_clk", lcd_pxl_sels, ARRAY_SIZE(lcd_pxl_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_MISC0);
 	imx_clk_scu("lcd_pxl_bypass_div_clk", IMX_SC_R_LCD_0, IMX_SC_PM_CLK_BYPASS);
+	imx_clk_scu2("lcd_pxl_clk", lcd_pxl_sels, ARRAY_SIZE(lcd_pxl_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_MISC0);
 
 	/* Audio SS */
 	imx_clk_scu("audio_pll0_clk", IMX_SC_R_AUDIO_PLL_0, IMX_SC_PM_CLK_PLL);
@@ -207,11 +207,11 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 	imx_clk_scu2("dc0_disp1_clk", dc0_sels, ARRAY_SIZE(dc0_sels), IMX_SC_R_DC_0, IMX_SC_PM_CLK_MISC1);
 	imx_clk_scu("dc0_bypass1_clk", IMX_SC_R_DC_0_VIDEO1, IMX_SC_PM_CLK_BYPASS);
 
-	imx_clk_scu2("dc1_disp0_clk", dc1_sels, ARRAY_SIZE(dc1_sels), IMX_SC_R_DC_1, IMX_SC_PM_CLK_MISC0);
-	imx_clk_scu2("dc1_disp1_clk", dc1_sels, ARRAY_SIZE(dc1_sels), IMX_SC_R_DC_1, IMX_SC_PM_CLK_MISC1);
 	imx_clk_scu("dc1_pll0_clk", IMX_SC_R_DC_1_PLL_0, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu("dc1_pll1_clk", IMX_SC_R_DC_1_PLL_1, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu("dc1_bypass0_clk", IMX_SC_R_DC_1_VIDEO0, IMX_SC_PM_CLK_BYPASS);
+	imx_clk_scu2("dc1_disp0_clk", dc1_sels, ARRAY_SIZE(dc1_sels), IMX_SC_R_DC_1, IMX_SC_PM_CLK_MISC0);
+	imx_clk_scu2("dc1_disp1_clk", dc1_sels, ARRAY_SIZE(dc1_sels), IMX_SC_R_DC_1, IMX_SC_PM_CLK_MISC1);
 	imx_clk_scu("dc1_bypass1_clk", IMX_SC_R_DC_1_VIDEO1, IMX_SC_PM_CLK_BYPASS);
 
 	/* MIPI-LVDS SS */
-- 
2.43.0



