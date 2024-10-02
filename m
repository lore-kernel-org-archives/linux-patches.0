Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7134F1D0488;
	Wed,  2 Oct 2024 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878141; cv=none; b=P4Hr5ZvR9nL7dudDVz3kM+cw0aB4Nbl8BxIghONspQEZ8O/01wqcYBcr0PylEPZFUpHoIsbjsM00T3JR8/iCl66uJ52IwWxkRqDd/ceevIP1XzH95LOQddIv56ZHXzJ8VuVKIQMKx1GfyldDcNzuGfj1tbd/leFiAWfuHN5BwCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878141; c=relaxed/simple;
	bh=w99OtR9hPYGOvhNtm6EBqFTNzQymOg3nRjD8uGEYPvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0yTGTsMQU4hHnlmVRrAnbFJeM8sk9fhOkqJPfEt88fNus7aI2yK6UyZJ5FzZqVF3EiOQ9dNMqLkwqYFuKPCuDTAQ7eICgBfPL1gy5NOsPiVX7we6cfuSiWJfMqWdrEUGonwYYn5hrk0x1DTwtUwSpwKrkgu1jerumrNyfrTouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jagsnwSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jagsnwSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3D5C4CEC2;
	Wed,  2 Oct 2024 14:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878141;
	bh=w99OtR9hPYGOvhNtm6EBqFTNzQymOg3nRjD8uGEYPvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jagsnwSM0glZzQCJRcX5bCdtYJ+P8HjmZb4YOPPzW2kcXF82G769AZsNygvDVg2qy
	 jSXo8zenAhrNNsotCXVCw9yAfDTTQ4qDvB5LeOUXwLKozPpJpha5DAF+AcLmt4rcmq
	 D5CxPemSWCgrSqA40jWZ/fyk3PorsS6ka6Ac3/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 316/634] clk: imx: imx8qxp: Parent should be initialized earlier than the clock
Date: Wed,  2 Oct 2024 14:56:56 +0200
Message-ID: <20241002125823.578353469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 16710eef641ba..83f2e8bd6d506 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -170,8 +170,8 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 	imx_clk_scu("pwm_clk",   IMX_SC_R_LCD_0_PWM_0, IMX_SC_PM_CLK_PER);
 	imx_clk_scu("elcdif_pll", IMX_SC_R_ELCDIF_PLL, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu2("lcd_clk", lcd_sels, ARRAY_SIZE(lcd_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_PER);
-	imx_clk_scu2("lcd_pxl_clk", lcd_pxl_sels, ARRAY_SIZE(lcd_pxl_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_MISC0);
 	imx_clk_scu("lcd_pxl_bypass_div_clk", IMX_SC_R_LCD_0, IMX_SC_PM_CLK_BYPASS);
+	imx_clk_scu2("lcd_pxl_clk", lcd_pxl_sels, ARRAY_SIZE(lcd_pxl_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_MISC0);
 
 	/* Audio SS */
 	imx_clk_scu("audio_pll0_clk", IMX_SC_R_AUDIO_PLL_0, IMX_SC_PM_CLK_PLL);
@@ -213,11 +213,11 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
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



