Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9A2221727;
	Mon,  2 Jun 2025 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876123; cv=none; b=sJOM21S/eMfuh0drRwxBp9d9gWSf3e+lmDrY2WTVV59Arz9AANDHa0CJfoBBledQbehHfpM017mdr//lcyz1fNsssD/GSttEHLajil7zCheH6AXnFcWefBKHJiqTEHV99139BUI5pnlrdbMRgKEQdlcwMkymCHIE+4Rh11Zv0Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876123; c=relaxed/simple;
	bh=wKzDoXSCSBxiVtu2/H+RIEF7Tz7SRbmYDbgH06+5eDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtzHO+7Z4A9WQIQtWqBDmYC6g1E9WIRhvb3qCcXhDi69Y7x8O44sshsHLx592uiqwWzGqG8A4YdQv3w/JEeLqvzYPZSg4QR5YoHj0YXb/4dzyG718gT1egPysMvPWsMdA4H5Ejj6pAt0Oj4QNppv82PQJ7jOKHWMRi7igsK1aXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmyzQKfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmyzQKfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281A7C4CEEB;
	Mon,  2 Jun 2025 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876123;
	bh=wKzDoXSCSBxiVtu2/H+RIEF7Tz7SRbmYDbgH06+5eDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmyzQKfCG6UQY17XipNSrj7w7jYEwiT6avUTw5OdimwFlYmwG1x/gDRu3FjDBrLNU
	 DfM1Nx8p7X2Tltfj5OkFu03tVR3E+CnUqbFYINzcWS45vneGs0iZ65tavVWPQlFcbz
	 5L85gVTUH7EhLyHKXuCINqoxFtLDl8A2Eb1grN4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/207] clk: imx8mp: inform CCF of maximum frequency of clocks
Date: Mon,  2 Jun 2025 15:47:30 +0200
Message-ID: <20250602134301.791052972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 06a61b5cb6a8638fa8823cd09b17233b29696fa2 ]

The IMX8MPCEC datasheet lists maximum frequencies allowed for different
modules. Some of these limits are universal, but some depend on
whether the SoC is operating in nominal or in overdrive mode.

The imx8mp.dtsi currently assumes overdrive mode and configures some
clocks in accordance with this. Boards wishing to make use of nominal
mode will need to override some of the clock rates manually.

As operating the clocks outside of their allowed range can lead to
difficult to debug issues, it makes sense to register the maximum rates
allowed in the driver, so the CCF can take them into account.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20250218-imx8m-clk-v4-6-b7697dc2dcd0@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c | 151 +++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 0f9ec5e0f5f81..0541ddfdf1020 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -8,6 +8,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/units.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -405,11 +406,151 @@ static const char * const imx8mp_clkout_sels[] = {"audio_pll1_out", "audio_pll2_
 static struct clk_hw **hws;
 static struct clk_hw_onecell_data *clk_hw_data;
 
+struct imx8mp_clock_constraints {
+	unsigned int clkid;
+	u32 maxrate;
+};
+
+/*
+ * Below tables are taken from IMX8MPCEC Rev. 2.1, 07/2023
+ * Table 13. Maximum frequency of modules.
+ * Probable typos fixed are marked with a comment.
+ */
+static const struct imx8mp_clock_constraints imx8mp_clock_common_constraints[] = {
+	{ IMX8MP_CLK_A53_DIV,             1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ENET_AXI,             266666667 }, /* Datasheet claims 266MHz */
+	{ IMX8MP_CLK_NAND_USDHC_BUS,       266666667 }, /* Datasheet claims 266MHz */
+	{ IMX8MP_CLK_MEDIA_APB,            200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_HDMI_APB,             133333333 }, /* Datasheet claims 133MHz */
+	{ IMX8MP_CLK_ML_AXI,               800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_AHB,                  133333333 },
+	{ IMX8MP_CLK_IPG_ROOT,              66666667 },
+	{ IMX8MP_CLK_AUDIO_AHB,            400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_DISP2_PIX,      170 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_DRAM_ALT,             666666667 },
+	{ IMX8MP_CLK_DRAM_APB,             200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_CAN1,                  80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_CAN2,                  80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_PCIE_AUX,              10 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_I2C5,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_I2C6,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_SAI1,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_SAI2,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_SAI3,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_SAI5,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_SAI6,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_ENET_QOS,             125 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ENET_QOS_TIMER,       200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ENET_REF,             125 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ENET_TIMER,           125 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ENET_PHY_REF,         125 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_NAND,                 500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_QSPI,                 400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_USDHC1,               400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_USDHC2,               400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_I2C1,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_I2C2,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_I2C3,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_I2C4,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_UART1,                 80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_UART2,                 80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_UART3,                 80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_UART4,                 80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ECSPI1,                80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ECSPI2,                80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_PWM1,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_PWM2,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_PWM3,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_PWM4,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_GPT1,                 100 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPT2,                 100 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPT3,                 100 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPT4,                 100 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPT5,                 100 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPT6,                 100 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_WDOG,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_IPP_DO_CLKO1,         200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_IPP_DO_CLKO2,         200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_HDMI_REF_266M,        266 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_USDHC3,               400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_MIPI_PHY1_REF,  300 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_DISP1_PIX,      250 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_CAM2_PIX,       277 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_LDB,            595 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_MIPI_TEST_BYTE, 200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ECSPI3,                80 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_PDM,                  200 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_SAI7,                  66666667 }, /* Datasheet claims 66MHz */
+	{ IMX8MP_CLK_MAIN_AXI,             400 * HZ_PER_MHZ },
+	{ /* Sentinel */ }
+};
+
+static const struct imx8mp_clock_constraints imx8mp_clock_nominal_constraints[] = {
+	{ IMX8MP_CLK_M7_CORE,           600 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ML_CORE,           800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU3D_CORE,        800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU3D_SHADER_CORE, 800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU2D_CORE,        800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_AUDIO_AXI_SRC,     600 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_HSIO_AXI,          400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_ISP,         400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_BUS,           600 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_AXI,         400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_HDMI_AXI,          400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU_AXI,           600 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU_AHB,           300 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_NOC,               800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_NOC_IO,            600 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ML_AHB,            300 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_G1,            600 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_G2,            500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_CAM1_PIX,    400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_VC8000E,       400 * HZ_PER_MHZ }, /* Datasheet claims 500MHz */
+	{ IMX8MP_CLK_DRAM_CORE,         800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GIC,               400 * HZ_PER_MHZ },
+	{ /* Sentinel */ }
+};
+
+static const struct imx8mp_clock_constraints imx8mp_clock_overdrive_constraints[] = {
+	{ IMX8MP_CLK_M7_CORE,            800 * HZ_PER_MHZ},
+	{ IMX8MP_CLK_ML_CORE,           1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU3D_CORE,        1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU3D_SHADER_CORE, 1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU2D_CORE,        1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_AUDIO_AXI_SRC,      800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_HSIO_AXI,           500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_ISP,          500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_BUS,            800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_AXI,          500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_HDMI_AXI,           500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU_AXI,            800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GPU_AHB,            400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_NOC,               1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_NOC_IO,             800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_ML_AHB,             400 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_G1,             800 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_G2,             700 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_MEDIA_CAM1_PIX,     500 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_VPU_VC8000E,        500 * HZ_PER_MHZ }, /* Datasheet claims 400MHz */
+	{ IMX8MP_CLK_DRAM_CORE,         1000 * HZ_PER_MHZ },
+	{ IMX8MP_CLK_GIC,                500 * HZ_PER_MHZ },
+	{ /* Sentinel */ }
+};
+
+static void imx8mp_clocks_apply_constraints(const struct imx8mp_clock_constraints constraints[])
+{
+	const struct imx8mp_clock_constraints *constr;
+
+	for (constr = constraints; constr->clkid; constr++)
+		clk_hw_set_rate_range(hws[constr->clkid], 0, constr->maxrate);
+}
+
 static int imx8mp_clocks_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np;
 	void __iomem *anatop_base, *ccm_base;
+	const char *opmode;
 	int err;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mp-anatop");
@@ -720,6 +861,16 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 
 	imx_check_clk_hws(hws, IMX8MP_CLK_END);
 
+	imx8mp_clocks_apply_constraints(imx8mp_clock_common_constraints);
+
+	err = of_property_read_string(np, "fsl,operating-mode", &opmode);
+	if (!err) {
+		if (!strcmp(opmode, "nominal"))
+			imx8mp_clocks_apply_constraints(imx8mp_clock_nominal_constraints);
+		else if (!strcmp(opmode, "overdrive"))
+			imx8mp_clocks_apply_constraints(imx8mp_clock_overdrive_constraints);
+	}
+
 	err = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
 	if (err < 0) {
 		dev_err(dev, "failed to register hws for i.MX8MP\n");
-- 
2.39.5



