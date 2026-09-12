Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66C329B799;
	Sat, 12 Sep 2026 08:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202309; cv=none; b=fy1gcNgkQ81smhVZpZDsgKO7zOFnXEgpUzol9HAgEDlMJMTPDHM75NeBR2juxvRJjMi5ibkTK3wq5Zg8WOCc3Rk850Oxg7+nawY66oO8nmhWFn7+EV7kZJfKM8GrmmFSqlMwMPAvD98+K4ZMglzRcP32tdaBg99xWa4BCt+dtwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202309; c=relaxed/simple;
	bh=yTkaMpWUXHXABgwcKNbm06jDtaxUZANJJOZG99oBPHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEsE010tjFVRDYSgUdHruaF/+XqEcFbGG6DIPr8bigy/B7wL+8/SOJYXjhceQMLJvJ2sj+gqkRqu3kRHav79yawbYJhNrG3/ww88PkCRKEI2fPu0o3xQRhTTMpELG8EYARphQbpmEKtbBEEDMxTikJCHndY/uYvN1jboon2KLP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWW6zGZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWW6zGZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25641F000FF;
	Sat, 12 Sep 2026 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202307;
	bh=7B1Au0qvdUXKlgfZr4jhPP/Zc7Fltd6s54Jd/oJVKiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWW6zGZSMVpgzF7HjoBj0yY4Hmd/nHu1rEOH4WLDk5pfnoK/4BBTi8Bt2D7kAHyPV
	 ylA7L6HK0j6KQp5aCcqhf5toho4b78GeeI00OrxtoKL+2KQEe2YfpH0O52F6L20rvq
	 iF30XjyJylHTwk2HYMGnmtFCDxNaO3hehKI5USqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1175/1815] pinctrl: tegra264: fix DAP2 DIN/DOUT pin assignment
Date: Sat, 12 Sep 2026 08:48:45 +0200
Message-ID: <20260912065716.598851509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit 27e5b8efc25b9238865288b7091ae6915c2f7c14 ]

The dap2_din and dap2_dout pin groups were given swapped ball suffixes:
DAP2_DIN was described as ball PV7 and DAP2_DOUT as ball PW0. On silicon
DAP2_DIN is on ball PW0 (mux register 0x6050, drive register 0x6054) and
DAP2_DOUT is on ball PV7 (mux register 0x6058, drive register 0x605c),
as reflected by the board pinmux.

Because the ball suffixes were swapped, the groups were also assigned the
wrong primary mux functions (dap2_din -> I2S2_SDATA_OUT and dap2_dout ->
I2S2_SDATA_IN), routing the I2S2 data-in and data-out signals to the wrong
pins and breaking DAP2 audio.

Rename the groups to dap2_din_pw0 and dap2_dout_pv7 and give each pad its
correct function (dap2_din_pw0 -> I2S2_SDATA_IN, dap2_dout_pv7 ->
I2S2_SDATA_OUT). The register offsets are already correct and are left
unchanged. This matches the board pinmux.

Fixes: c98506206912 ("pinctrl: tegra: Add Tegra264 pinmux driver")
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra264.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra264.c b/drivers/pinctrl/tegra/pinctrl-tegra264.c
index be64fba34dce4..f8afb0bdb68a8 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra264.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra264.c
@@ -96,8 +96,8 @@ enum {
 	TEGRA_PIN_UART4_RTS_N_PV4,
 	TEGRA_PIN_UART4_CTS_N_PV5,
 	TEGRA_PIN_DAP2_CLK_PV6,
-	TEGRA_PIN_DAP2_DIN_PV7,
-	TEGRA_PIN_DAP2_DOUT_PW0,
+	TEGRA_PIN_DAP2_DIN_PW0,
+	TEGRA_PIN_DAP2_DOUT_PV7,
 	TEGRA_PIN_DAP2_FS_PW1,
 	TEGRA_PIN_GEN1_I2C_SCL_PW2,
 	TEGRA_PIN_GEN1_I2C_SDA_PW3,
@@ -329,8 +329,8 @@ static const struct pinctrl_pin_desc tegra264_main_pins[] = {
 	PINCTRL_PIN(TEGRA_PIN_UART4_RTS_N_PV4, "UART4_RTS_N_PV4"),
 	PINCTRL_PIN(TEGRA_PIN_UART4_CTS_N_PV5, "UART4_CTS_N_PV5"),
 	PINCTRL_PIN(TEGRA_PIN_DAP2_CLK_PV6, "DAP2_CLK_PV6"),
-	PINCTRL_PIN(TEGRA_PIN_DAP2_DIN_PV7, "DAP2_DIN_PV7"),
-	PINCTRL_PIN(TEGRA_PIN_DAP2_DOUT_PW0, "DAP2_DOUT_PW0"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_DIN_PW0, "DAP2_DIN_PW0"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_DOUT_PV7, "DAP2_DOUT_PV7"),
 	PINCTRL_PIN(TEGRA_PIN_DAP2_FS_PW1, "DAP2_FS_PW1"),
 	PINCTRL_PIN(TEGRA_PIN_GEN1_I2C_SCL_PW2, "GEN1_I2C_SCL_PW2"),
 	PINCTRL_PIN(TEGRA_PIN_GEN1_I2C_SDA_PW3, "GEN1_I2C_SDA_PW3"),
@@ -827,12 +827,12 @@ static const unsigned int dap2_clk_pv6_pins[] = {
 	TEGRA_PIN_DAP2_CLK_PV6,
 };
 
-static const unsigned int dap2_din_pv7_pins[] = {
-	TEGRA_PIN_DAP2_DIN_PV7,
+static const unsigned int dap2_din_pw0_pins[] = {
+	TEGRA_PIN_DAP2_DIN_PW0,
 };
 
-static const unsigned int dap2_dout_pw0_pins[] = {
-	TEGRA_PIN_DAP2_DOUT_PW0,
+static const unsigned int dap2_dout_pv7_pins[] = {
+	TEGRA_PIN_DAP2_DOUT_PV7,
 };
 
 static const unsigned int dap2_fs_pw1_pins[] = {
@@ -1834,8 +1834,8 @@ static const char * const tegra264_functions[] = {
 #define drive_gen1_i2c_sda_pw3 DRV_PINGROUP_ENTRY_Y(0x601c, 12, 4, 20, 4, -1, -1, -1, -1, 0)
 #define drive_dap2_fs_pw1 DRV_PINGROUP_ENTRY_Y(0x6044, 12, 4, 20, 4, -1, -1, -1, -1, 0)
 #define drive_dap2_clk_pv6 DRV_PINGROUP_ENTRY_Y(0x604c, 12, 4, 20, 4, -1, -1, -1, -1, 0)
-#define drive_dap2_din_pv7 DRV_PINGROUP_ENTRY_Y(0x6054, 12, 4, 20, 4, -1, -1, -1, -1, 0)
-#define drive_dap2_dout_pw0 DRV_PINGROUP_ENTRY_Y(0x605c, 12, 4, 20, 4, -1, -1, -1, -1, 0)
+#define drive_dap2_din_pw0 DRV_PINGROUP_ENTRY_Y(0x6054, 12, 4, 20, 4, -1, -1, -1, -1, 0)
+#define drive_dap2_dout_pv7 DRV_PINGROUP_ENTRY_Y(0x605c, 12, 4, 20, 4, -1, -1, -1, -1, 0)
 #define drive_pwm10_pv1 DRV_PINGROUP_ENTRY_Y(0x6064, 12, 4, 20, 4, -1, -1, -1, -1, 0)
 #define drive_soc_gpio170_pu0 DRV_PINGROUP_ENTRY_Y(0x606c, 12, 4, 20, 4, -1, -1, -1, -1, 0)
 #define drive_soc_gpio171_pu1 DRV_PINGROUP_ENTRY_Y(0x6074, 12, 4, 20, 4, -1, -1, -1, -1, 0)
@@ -2051,8 +2051,8 @@ static const struct tegra_pingroup tegra264_main_groups[] = {
 	PINGROUP(gen1_i2c_sda_pw3, I2C1_DAT, RSVD1, RSVD2, RSVD3, 0x6018, 0, Y, 5, 7, 6, 8, -1, 10, 11),
 	PINGROUP(dap2_fs_pw1, I2S2_LRCK, RSVD1, RSVD2, RSVD3, 0x6040, 0, Y, 5, 7, 6, 8, -1, 10, 11),
 	PINGROUP(dap2_clk_pv6, I2S2_SCLK, RSVD1, RSVD2, RSVD3, 0x6048, 0, Y, 5, 7, 6, 8, -1, 10, 11),
-	PINGROUP(dap2_din_pv7, I2S2_SDATA_OUT, RSVD1, RSVD2, RSVD3, 0x6050, 0, Y, 5, 7, 6, 8, -1, 10, 11),
-	PINGROUP(dap2_dout_pw0, I2S2_SDATA_IN, RSVD1, RSVD2, RSVD3, 0x6058, 0, Y, 5, 7, 6, 8, -1, 10, 11),
+	PINGROUP(dap2_din_pw0, I2S2_SDATA_IN, RSVD1, RSVD2, RSVD3, 0x6050, 0, Y, 5, 7, 6, 8, -1, 10, 11),
+	PINGROUP(dap2_dout_pv7, I2S2_SDATA_OUT, RSVD1, RSVD2, RSVD3, 0x6058, 0, Y, 5, 7, 6, 8, -1, 10, 11),
 	PINGROUP(pwm10_pv1, GP_PWM10, SDMMC1_CD, I2S7_LRCK, RSVD3, 0x6060, 0, Y, 5, 7, 6, 8, -1, 10, 11),
 	PINGROUP(soc_gpio170_pu0, RSVD0, I2S7_SDATA_IN, CCLA_LA_TRIGGER_MUX, RSVD3, 0x6068, 0, Y, 5, 7, 6, 8, -1, 10, 11),
 	PINGROUP(soc_gpio171_pu1, RSVD0, SPI4_SCK, RSVD2, RSVD3, 0x6070, 0, Y, 5, 7, 6, 8, -1, 10, 11),
-- 
2.53.0



