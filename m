Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546683C487
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljKF9FjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB03C433C8;
	Wed, 15 Nov 2023 19:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077224;
	bh=bbBwxq39uQ2ammYEwd5GH4Xxkip/48WJO2qB6lbhzBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljKF9FjNdNLEeXUIKyBHrJwm+JFt3CUjg2K+iIhFFurRbayVAj038pCiCFNcz3Ubc
	 CulULQR3YQX35sVl2tici7srZKAzTysoJPmtNrXfkqpahRf2F4BOUQWaHTWF2C8N7P
	 TmSI7yeW3uwsikhuxlvGorL8fHxe3YQbJYo5mXk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Laurentiu Palcu <laurentiu.palcu@nxp.com>,
	Robert Chiras <robert.chiras@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/603] clk: imx: imx8qxp: Fix elcdif_pll clock
Date: Wed, 15 Nov 2023 14:11:58 -0500
Message-ID: <20231115191625.186272675@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Chiras <robert.chiras@nxp.com>

[ Upstream commit 15cee75dacb82ade710d61bfd536011933ef9bf2 ]

Move the elcdif_pll clock initialization before the lcd_clk, since the
elcdif_clk needs to be initialized ahead of lcd_clk, being its parent.
This change fixes issues with the LCD clocks during suspend/resume.

Fixes: babfaa9556d7 ("clk: imx: scu: add more scu clocks")
Suggested-by: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
Acked-by: Laurentiu Palcu <laurentiu.palcu@nxp.com>
Signed-off-by: Robert Chiras <robert.chiras@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230912-imx8-clk-v1-v1-2-69a34bcfcae1@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index cadcbb318f5cf..4020aa4b79bf2 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -147,10 +147,10 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 	imx_clk_scu("adc0_clk",  IMX_SC_R_ADC_0, IMX_SC_PM_CLK_PER);
 	imx_clk_scu("adc1_clk",  IMX_SC_R_ADC_1, IMX_SC_PM_CLK_PER);
 	imx_clk_scu("pwm_clk",   IMX_SC_R_LCD_0_PWM_0, IMX_SC_PM_CLK_PER);
+	imx_clk_scu("elcdif_pll", IMX_SC_R_ELCDIF_PLL, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu2("lcd_clk", lcd_sels, ARRAY_SIZE(lcd_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_PER);
 	imx_clk_scu2("lcd_pxl_clk", lcd_pxl_sels, ARRAY_SIZE(lcd_pxl_sels), IMX_SC_R_LCD_0, IMX_SC_PM_CLK_MISC0);
 	imx_clk_scu("lcd_pxl_bypass_div_clk", IMX_SC_R_LCD_0, IMX_SC_PM_CLK_BYPASS);
-	imx_clk_scu("elcdif_pll", IMX_SC_R_ELCDIF_PLL, IMX_SC_PM_CLK_PLL);
 
 	/* Audio SS */
 	imx_clk_scu("audio_pll0_clk", IMX_SC_R_AUDIO_PLL_0, IMX_SC_PM_CLK_PLL);
-- 
2.42.0



