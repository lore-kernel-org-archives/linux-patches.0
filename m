Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ED33BB43
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm/kRNUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAECEC433C7;
	Wed, 15 Nov 2023 19:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078102;
	bh=rsf+tcqrLm1xuk6F8LRbzbwMdFUlSWKSswc6gFoDU4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm/kRNUJ8SC3/qkkYZZmJxk44CAoYRqFqIWgewvUvlrnDg0jLllaXHvru45e3C9g7
	 WfGXw2x53spt+LFm7uElezf83zL9t2gVarTnKig7HlO9vR76euJn/1aPY0kbk4eHpa
	 lvcsZMklzIGFtrFu5jFZrFagG73ZmmV/CLoKQBQw=
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
Subject: [PATCH 6.1 086/379] clk: imx: imx8qxp: Fix elcdif_pll clock
Date: Wed, 15 Nov 2023 14:22:41 -0500
Message-ID: <20231115192650.222944045@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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
index 546a3703bfeb2..273de1f293076 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -148,10 +148,10 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
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



