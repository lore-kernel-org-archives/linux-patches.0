Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D8CC433D6;
	Wed, 30 Nov 2022 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833846;
	bh=lr5xJGzUjP8NLAV/SJAWmf1Bjx0GqUsuY3JFGcUnmbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZF5ARi4k2j+kdhrUG81dJrQqlNANrDyyKTPlJmQipqQt/uHpIZdc60EN5QY/D/lG
	 bHuxFAjJ0/eJnpkYES92BOMNiDj4pK8+LT6JBTPAqpG6YG4iyMRw4oyKSQWyQ7mhg7
	 I1lbzhXHQ+qgay9uj5Lh3M9gPOrEP7YjGUXQv9EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Steve Su <steve.su@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/289] drm/amd/display: Fix gpio port mapping issue
Date: Wed, 30 Nov 2022 19:20:21 +0100
Message-Id: <20221130180544.951105464@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve Su <steve.su@amd.com>

[ Upstream commit c0b2753f5db281b07013899c79b5f06a614055f9 ]

[Why]
1. Port of gpio has different mapping.

[How]
1. Add a dummy entry in mapping table.
2. Fix incorrect mask bit field access.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Steve Su <steve.su@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/gpio/dcn32/hw_factory_dcn32.c   | 14 ++++++++++++++
 drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c       |  9 ++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c b/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
index d635b73af46f..0ea52ba5ac82 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
@@ -107,6 +107,13 @@ static const struct ddc_registers ddc_data_regs_dcn[] = {
 	ddc_data_regs_dcn2(3),
 	ddc_data_regs_dcn2(4),
 	ddc_data_regs_dcn2(5),
+	{
+		// add a dummy entry for cases no such port
+		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
+		.ddc_setup = 0,
+		.phy_aux_cntl = 0,
+		.dc_gpio_aux_ctrl_5 = 0
+	},
 	{
 			DDC_GPIO_VGA_REG_LIST(DATA),
 			.ddc_setup = 0,
@@ -121,6 +128,13 @@ static const struct ddc_registers ddc_clk_regs_dcn[] = {
 	ddc_clk_regs_dcn2(3),
 	ddc_clk_regs_dcn2(4),
 	ddc_clk_regs_dcn2(5),
+	{
+		// add a dummy entry for cases no such port
+		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
+		.ddc_setup = 0,
+		.phy_aux_cntl = 0,
+		.dc_gpio_aux_ctrl_5 = 0
+	},
 	{
 			DDC_GPIO_VGA_REG_LIST(CLK),
 			.ddc_setup = 0,
diff --git a/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c b/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c
index 6fd38cdd68c0..525bc8881950 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c
@@ -94,11 +94,14 @@ static enum gpio_result set_config(
 		 * is required for detection of AUX mode */
 		if (hw_gpio->base.en != GPIO_DDC_LINE_VIP_PAD) {
 			if (!ddc_data_pd_en || !ddc_clk_pd_en) {
-
-				REG_SET_2(gpio.MASK_reg, regval,
+				if (hw_gpio->base.en == GPIO_DDC_LINE_DDC_VGA) {
+					// bit 4 of mask has different usage in some cases
+					REG_SET(gpio.MASK_reg, regval, DC_GPIO_DDC1DATA_PD_EN, 1);
+				} else {
+					REG_SET_2(gpio.MASK_reg, regval,
 						DC_GPIO_DDC1DATA_PD_EN, 1,
 						DC_GPIO_DDC1CLK_PD_EN, 1);
-
+				}
 				if (config_data->type ==
 						GPIO_CONFIG_TYPE_I2C_AUX_DUAL_MODE)
 					msleep(3);
-- 
2.35.1



