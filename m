Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173981CACE4;
	Mon, 14 Oct 2024 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919645; cv=none; b=T4NhBndFJml+uV2bTDu71pR5PX7qPZqybFLFo3JAW3JSuQ0y+5tv73Q19FLZGqzWJxWY62NYB82qf7H+s6vf68kNXij6tRG9iGxbyGtizhYB4zWwoaCF2bTMowBo3spkp4HRs2V/fwaqQKzZYYps3ymLXkJpsagKvP3JJXwXe34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919645; c=relaxed/simple;
	bh=41yYohRbQ2CxURdYCmsxUNIO6r6IIXKg8+i90kthOZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZNlsna2BRKIzPbd1vWISLDN6ewc195LRt1cteRix0aZ4RslrmkNd05qRIz7gBeJG0w6C8caqkvgXlI61C58jBvmH4b4vjQOFwpLfywmy4kowBrkB5Z6JKdNSi7TLjSzopFzQhgyM8omN4A+POBJQ9UXHMZodq4Qse3ThEXSvWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3POJS7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3POJS7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D01C4CEC3;
	Mon, 14 Oct 2024 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919645;
	bh=41yYohRbQ2CxURdYCmsxUNIO6r6IIXKg8+i90kthOZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3POJS7ifE/Z1pS8LRn6ufP7rbMVpKef3oW48D0+Xs2syfrQpHNQHsEWkSgv7Dd+t
	 N7SyfiULugyg4CieyV+L7i3vTVZOKP0KnI8XN4NsUd7FJZJZ8HBxywVv8ixVnxhYGM
	 gDY6/1y4UczC4l0KOHzmbIN74pk+DnJyHkqxXrpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 636/798] clk: imx6ul: fix enet1 gate configuration
Date: Mon, 14 Oct 2024 16:19:50 +0200
Message-ID: <20241014141243.027374898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 5f82bfced6118450cb9ea3f12316568f6fac10ab ]

According to the "i.MX 6UltraLite Applications Processor Reference Manual,
Rev. 2, 03/2017", BIT(13) is ENET1_125M_EN which is not controlling root
of PLL6. It is controlling ENET1 separately.

So, instead of this picture (implementation before this patch):
fec1 <- enet_ref (divider) <---------------------------,
                                                       |- pll6_enet (gate)
fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´

we should have this one (after this patch):
fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
                                                       |- pll6_enet
fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´

With this fix, the RMII reference clock will be turned off, after
setting network interface down on each separate interface
(ip l s dev eth0 down). Which was not working before, on system with both
FECs enabled.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230131084642.709385-16-o.rempel@pengutronix.de
Stable-dep-of: 32c055ef563c ("clk: imx6ul: fix clock parent for IMX6UL_CLK_ENETx_REF_SEL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c             | 7 ++++---
 include/dt-bindings/clock/imx6ul-clock.h | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index 520b100bff4bb..777c4d2b87b3f 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -176,7 +176,7 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 	hws[IMX6UL_CLK_PLL3_USB_OTG]	= imx_clk_hw_gate("pll3_usb_otg",	"pll3_bypass", base + 0x10, 13);
 	hws[IMX6UL_CLK_PLL4_AUDIO]	= imx_clk_hw_gate("pll4_audio",	"pll4_bypass", base + 0x70, 13);
 	hws[IMX6UL_CLK_PLL5_VIDEO]	= imx_clk_hw_gate("pll5_video",	"pll5_bypass", base + 0xa0, 13);
-	hws[IMX6UL_CLK_PLL6_ENET]	= imx_clk_hw_gate("pll6_enet",	"pll6_bypass", base + 0xe0, 13);
+	hws[IMX6UL_CLK_PLL6_ENET]	= imx_clk_hw_fixed_factor("pll6_enet",	"pll6_bypass", 1, 1);
 	hws[IMX6UL_CLK_PLL7_USB_HOST]	= imx_clk_hw_gate("pll7_usb_host",	"pll7_bypass", base + 0x20, 13);
 
 	/*
@@ -205,12 +205,13 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 	hws[IMX6UL_CLK_PLL3_PFD2] = imx_clk_hw_pfd("pll3_pfd2_508m", "pll3_usb_otg", base + 0xf0,	 2);
 	hws[IMX6UL_CLK_PLL3_PFD3] = imx_clk_hw_pfd("pll3_pfd3_454m", "pll3_usb_otg", base + 0xf0,	 3);
 
-	hws[IMX6UL_CLK_ENET_REF] = clk_hw_register_divider_table(NULL, "enet_ref", "pll6_enet", 0,
+	hws[IMX6UL_CLK_ENET_REF] = clk_hw_register_divider_table(NULL, "enet1_ref", "pll6_enet", 0,
 			base + 0xe0, 0, 2, 0, clk_enet_ref_table, &imx_ccm_lock);
 	hws[IMX6UL_CLK_ENET2_REF] = clk_hw_register_divider_table(NULL, "enet2_ref", "pll6_enet", 0,
 			base + 0xe0, 2, 2, 0, clk_enet_ref_table, &imx_ccm_lock);
 
-	hws[IMX6UL_CLK_ENET2_REF_125M] = imx_clk_hw_gate("enet_ref_125m", "enet2_ref", base + 0xe0, 20);
+	hws[IMX6UL_CLK_ENET1_REF_125M] = imx_clk_hw_gate("enet1_ref_125m", "enet1_ref", base + 0xe0, 13);
+	hws[IMX6UL_CLK_ENET2_REF_125M] = imx_clk_hw_gate("enet2_ref_125m", "enet2_ref", base + 0xe0, 20);
 	hws[IMX6UL_CLK_ENET_PTP_REF]	= imx_clk_hw_fixed_factor("enet_ptp_ref", "pll6_enet", 1, 20);
 	hws[IMX6UL_CLK_ENET_PTP]	= imx_clk_hw_gate("enet_ptp", "enet_ptp_ref", base + 0xe0, 21);
 
diff --git a/include/dt-bindings/clock/imx6ul-clock.h b/include/dt-bindings/clock/imx6ul-clock.h
index 79094338e6f1e..b44920f1edb0d 100644
--- a/include/dt-bindings/clock/imx6ul-clock.h
+++ b/include/dt-bindings/clock/imx6ul-clock.h
@@ -256,7 +256,8 @@
 #define IMX6UL_CLK_GPIO4		247
 #define IMX6UL_CLK_GPIO5		248
 #define IMX6UL_CLK_MMDC_P1_IPG		249
+#define IMX6UL_CLK_ENET1_REF_125M	250
 
-#define IMX6UL_CLK_END			250
+#define IMX6UL_CLK_END			251
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6UL_H */
-- 
2.43.0



