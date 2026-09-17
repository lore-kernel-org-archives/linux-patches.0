Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A99C4F5DF7;
	Thu, 17 Sep 2026 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664128; cv=none; b=L4Rxd53J/m7LjvryfuHK4FFCk9Th/yUtsg28PQp76r/GL8wBQwDYVRQebEGq04QFq0c0oisx1B7wwHVpqjkn3BoQ/yWxxa3NKkBfNbe3dRW2jbUZsI8HQCX1puJ3xBRWjCaWSWaNz8dv1gkY2BXnhZL7nK7Zztce3C1pCw+0uzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664128; c=relaxed/simple;
	bh=IK1tluLNatXUek3ol8QyKsUUIpZtMe7WxKaptDaZ0sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEkFu8PKYuelhBK3X2ludqCWlshrwjqKNI9B4M32U3TN7KgwZ8+p1v0D9qmAWbgha7SW+tJpTNSMC8eM738sYDzYDWwEOs5yautRCCz8SlERE7Bh0vp5Ei8IpRHqAcsC1uRWNxWyyEX7tIzhpXsTuCjHPKNNiRaQzBTMlFKFAR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIkWvg1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIkWvg1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F36A1F000FF;
	Thu, 17 Sep 2026 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664126;
	bh=Xq+IR+rGai+bSnzat3HeXykdyEKuGjMugJ4zoFkmj7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIkWvg1tjMB5mRZ7n6OfHZhNPbYZmbehrTgpVPtCtJt5cfgs/KF8ufjT2Jkz9Okhd
	 bcMSui7QwJvs6A6YKuqO7amI8u+VSAD+FCCc73WPk3eFBfzr3oZ6Ufk/at5q/nsjcx
	 Ey/c3rAMWWaSQQVasDJeai4wJUYliFLi/+miner4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denzeel Oliva <wachiturroxd150@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0269/1250] clk: samsung: exynos990: Fix PERIC0/1 USI clock types
Date: Thu, 17 Sep 2026 16:01:04 +0100
Message-ID: <20260917151559.433254929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denzeel Oliva <wachiturroxd150@gmail.com>

[ Upstream commit e11560b050ce867bd7d3ccea138231db54e2250a ]

Use nMUX() for USI and UART user muxes to allow reparenting between
OSC and CMU IP output when changing rates, and use DIV_F() with
CLK_SET_RATE_PARENT on their dividers and gates so rate requests
propagate upward.

Consolidate identical USI parent arrays into shared
mout_peric0_nonbususer_p and mout_peric1_nonbususer_p.

Signed-off-by: Denzeel Oliva <wachiturroxd150@gmail.com>
Link: https://patch.msgid.link/20260528-perics-usi-v1-1-13a6ee4d1a6f@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos990.c | 307 +++++++++++++---------------
 1 file changed, 143 insertions(+), 164 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos990.c b/drivers/clk/samsung/clk-exynos990.c
index 6277dd557fab6..4385c3b76dd68 100644
--- a/drivers/clk/samsung/clk-exynos990.c
+++ b/drivers/clk/samsung/clk-exynos990.c
@@ -1546,54 +1546,44 @@ static const unsigned long peric0_clk_regs[] __initconst = {
 
 /* Parent clock list for CMU_PERIC0 muxes */
 PNAME(mout_peric0_bus_user_p) = { "oscclk", "dout_cmu_peric0_bus" };
-PNAME(mout_peric0_uart_dbg_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi00_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi01_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi02_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi03_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi04_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi05_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi13_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi14_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi15_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
-PNAME(mout_peric0_usi_i2c_user_p) = { "oscclk", "dout_cmu_peric0_ip" };
+PNAME(mout_peric0_nonbususer_p) = { "oscclk", "dout_cmu_peric0_ip" };
 
 static const struct samsung_mux_clock peric0_mux_clks[] __initconst = {
 	MUX(CLK_MOUT_PERIC0_BUS_USER, "mout_peric0_bus_user",
 	    mout_peric0_bus_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_BUS_USER,
 	    4, 1),
-	MUX(CLK_MOUT_PERIC0_UART_DBG, "mout_peric0_uart_dbg",
-	    mout_peric0_uart_dbg_p, PLL_CON0_MUX_CLKCMU_PERIC0_UART_DBG,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI00_USI_USER, "mout_peric0_usi00_usi_user",
-	    mout_peric0_usi00_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI00_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI01_USI_USER, "mout_peric0_usi01_usi_user",
-	    mout_peric0_usi01_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI01_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI02_USI_USER, "mout_peric0_usi02_usi_user",
-	    mout_peric0_usi02_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI02_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI03_USI_USER, "mout_peric0_usi03_usi_user",
-	    mout_peric0_usi03_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI03_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI04_USI_USER, "mout_peric0_usi04_usi_user",
-	    mout_peric0_usi04_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI04_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI05_USI_USER, "mout_peric0_usi05_usi_user",
-	    mout_peric0_usi05_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI05_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI13_USI_USER, "mout_peric0_usi13_usi_user",
-	    mout_peric0_usi13_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI13_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI14_USI_USER, "mout_peric0_usi14_usi_user",
-	    mout_peric0_usi14_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI14_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC0_USI15_USI_USER, "mout_peric0_usi15_usi_user",
-	    mout_peric0_usi15_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI15_USI_USER,
-	    4, 1),
+	nMUX(CLK_MOUT_PERIC0_UART_DBG, "mout_peric0_uart_dbg",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_UART_DBG,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI00_USI_USER, "mout_peric0_usi00_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI00_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI01_USI_USER, "mout_peric0_usi01_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI01_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI02_USI_USER, "mout_peric0_usi02_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI02_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI03_USI_USER, "mout_peric0_usi03_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI03_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI04_USI_USER, "mout_peric0_usi04_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI04_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI05_USI_USER, "mout_peric0_usi05_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI05_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI13_USI_USER, "mout_peric0_usi13_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI13_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI14_USI_USER, "mout_peric0_usi14_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI14_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC0_USI15_USI_USER, "mout_peric0_usi15_usi_user",
+	     mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI15_USI_USER,
+	     4, 1),
 	MUX(CLK_MOUT_PERIC0_USI_I2C_USER, "mout_peric0_usi_i2c_user",
-	    mout_peric0_usi_i2c_user_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI_I2C_USER,
+	    mout_peric0_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC0_USI_I2C_USER,
 	    4, 1),
 };
 
@@ -1602,42 +1592,42 @@ static const struct samsung_div_clock peric0_div_clks[] __initconst = {
 	    "mout_peric0_uart_dbg",
 	    CLK_CON_DIV_DIV_CLK_PERIC0_UART_DBG,
 	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI00_USI, "dout_peric0_usi00_usi",
-	    "mout_peric0_usi00_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI00_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI01_USI, "dout_peric0_usi01_usi",
-	    "mout_peric0_usi01_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI01_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI02_USI, "dout_peric0_usi02_usi",
-	    "mout_peric0_usi02_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI02_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI03_USI, "dout_peric0_usi03_usi",
-	    "mout_peric0_usi03_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI03_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI04_USI, "dout_peric0_usi04_usi",
-	    "mout_peric0_usi04_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI04_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI05_USI, "dout_peric0_usi05_usi",
-	    "mout_peric0_usi05_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI05_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI13_USI, "dout_peric0_usi13_usi",
-	    "mout_peric0_usi13_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI13_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI14_USI, "dout_peric0_usi14_usi",
-	    "mout_peric0_usi14_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI14_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC0_USI15_USI, "dout_peric0_usi15_usi",
-	    "mout_peric0_usi15_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC0_USI15_USI,
-	    0, 4),
+	DIV_F(CLK_DOUT_PERIC0_USI00_USI, "dout_peric0_usi00_usi",
+	      "mout_peric0_usi00_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI00_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI01_USI, "dout_peric0_usi01_usi",
+	      "mout_peric0_usi01_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI01_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI02_USI, "dout_peric0_usi02_usi",
+	      "mout_peric0_usi02_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI02_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI03_USI, "dout_peric0_usi03_usi",
+	      "mout_peric0_usi03_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI03_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI04_USI, "dout_peric0_usi04_usi",
+	      "mout_peric0_usi04_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI04_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI05_USI, "dout_peric0_usi05_usi",
+	      "mout_peric0_usi05_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI05_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI13_USI, "dout_peric0_usi13_usi",
+	      "mout_peric0_usi13_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI13_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI14_USI, "dout_peric0_usi14_usi",
+	      "mout_peric0_usi14_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI14_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC0_USI15_USI, "dout_peric0_usi15_usi",
+	      "mout_peric0_usi15_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC0_USI15_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
 	DIV(CLK_DOUT_PERIC0_USI_I2C, "dout_peric0_usi_i2c",
 	    "mout_peric0_usi_i2c_user",
 	    CLK_CON_DIV_DIV_CLK_PERIC0_USI_I2C,
@@ -2107,58 +2097,47 @@ static const unsigned long peric1_clk_regs[] __initconst = {
 
 /* Parent clock list for CMU_PERIC1 muxes */
 PNAME(mout_peric1_bus_user_p)  = { "oscclk", "dout_cmu_peric1_bus" };
-PNAME(mout_peric1_uart_bt_user_p) = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi06_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi07_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi08_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi09_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi10_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi11_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi12_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi18_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi16_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi17_user_p)  = { "oscclk", "dout_cmu_peric1_ip" };
-PNAME(mout_peric1_usi_i2c_user_p) = { "oscclk", "dout_cmu_peric1_ip" };
+PNAME(mout_peric1_nonbususer_p) = { "oscclk", "dout_cmu_peric1_ip" };
 
 static const struct samsung_mux_clock peric1_mux_clks[] __initconst = {
 	MUX(CLK_MOUT_PERIC1_BUS_USER, "mout_peric1_bus_user",
 	    mout_peric1_bus_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_BUS_USER,
 	    4, 1),
-	MUX(CLK_MOUT_PERIC1_UART_BT_USER, "mout_peric1_uart_bt_user",
-	    mout_peric1_uart_bt_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_UART_BT_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI06_USI_USER, "mout_peric1_usi06_usi_user",
-	    mout_peric1_usi06_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI06_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI07_USI_USER, "mout_peric1_usi07_usi_user",
-	    mout_peric1_usi07_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI07_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI08_USI_USER, "mout_peric1_usi08_usi_user",
-	    mout_peric1_usi08_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI08_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI09_USI_USER, "mout_peric1_usi09_usi_user",
-	    mout_peric1_usi09_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI09_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI10_USI_USER, "mout_peric1_usi10_usi_user",
-	    mout_peric1_usi10_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI10_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI11_USI_USER, "mout_peric1_usi11_usi_user",
-	    mout_peric1_usi11_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI11_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI12_USI_USER, "mout_peric1_usi12_usi_user",
-	    mout_peric1_usi12_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI12_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI18_USI_USER, "mout_peric1_usi18_usi_user",
-	    mout_peric1_usi18_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI18_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI16_USI_USER, "mout_peric1_usi16_usi_user",
-	    mout_peric1_usi16_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI16_USI_USER,
-	    4, 1),
-	MUX(CLK_MOUT_PERIC1_USI17_USI_USER, "mout_peric1_usi17_usi_user",
-	    mout_peric1_usi17_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI17_USI_USER,
-	    4, 1),
+	nMUX(CLK_MOUT_PERIC1_UART_BT_USER, "mout_peric1_uart_bt_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_UART_BT_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI06_USI_USER, "mout_peric1_usi06_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI06_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI07_USI_USER, "mout_peric1_usi07_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI07_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI08_USI_USER, "mout_peric1_usi08_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI08_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI09_USI_USER, "mout_peric1_usi09_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI09_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI10_USI_USER, "mout_peric1_usi10_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI10_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI11_USI_USER, "mout_peric1_usi11_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI11_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI12_USI_USER, "mout_peric1_usi12_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI12_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI18_USI_USER, "mout_peric1_usi18_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI18_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI16_USI_USER, "mout_peric1_usi16_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI16_USI_USER,
+	     4, 1),
+	nMUX(CLK_MOUT_PERIC1_USI17_USI_USER, "mout_peric1_usi17_usi_user",
+	     mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI17_USI_USER,
+	     4, 1),
 	MUX(CLK_MOUT_PERIC1_USI_I2C_USER, "mout_peric1_usi_i2c_user",
-	    mout_peric1_usi_i2c_user_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI_I2C_USER,
+	    mout_peric1_nonbususer_p, PLL_CON0_MUX_CLKCMU_PERIC1_USI_I2C_USER,
 	    4, 1),
 };
 
@@ -2167,46 +2146,46 @@ static const struct samsung_div_clock peric1_div_clks[] __initconst = {
 	    "mout_peric1_uart_bt_user",
 	    CLK_CON_DIV_DIV_CLK_PERIC1_UART_BT,
 	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI06_USI, "dout_peric1_usi06_usi",
-	    "mout_peric1_usi06_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI06_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI07_USI, "dout_peric1_usi07_usi",
-	    "mout_peric1_usi07_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI07_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI08_USI, "dout_peric1_usi08_usi",
-	    "mout_peric1_usi08_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI08_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI18_USI, "dout_peric1_usi18_usi",
-	    "mout_peric1_usi18_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI18_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI12_USI, "dout_peric1_usi12_usi",
-	    "mout_peric1_usi12_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI12_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI09_USI, "dout_peric1_usi09_usi",
-	    "mout_peric1_usi09_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI09_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI10_USI, "dout_peric1_usi10_usi",
-	    "mout_peric1_usi10_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI10_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI11_USI, "dout_peric1_usi11_usi",
-	    "mout_peric1_usi11_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI11_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI16_USI, "dout_peric1_usi16_usi",
-	    "mout_peric1_usi16_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI16_USI,
-	    0, 4),
-	DIV(CLK_DOUT_PERIC1_USI17_USI, "dout_peric1_usi17_usi",
-	    "mout_peric1_usi17_usi_user",
-	    CLK_CON_DIV_DIV_CLK_PERIC1_USI17_USI,
-	    0, 4),
+	DIV_F(CLK_DOUT_PERIC1_USI06_USI, "dout_peric1_usi06_usi",
+	      "mout_peric1_usi06_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI06_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI07_USI, "dout_peric1_usi07_usi",
+	      "mout_peric1_usi07_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI07_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI08_USI, "dout_peric1_usi08_usi",
+	      "mout_peric1_usi08_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI08_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI18_USI, "dout_peric1_usi18_usi",
+	      "mout_peric1_usi18_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI18_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI12_USI, "dout_peric1_usi12_usi",
+	      "mout_peric1_usi12_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI12_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI09_USI, "dout_peric1_usi09_usi",
+	      "mout_peric1_usi09_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI09_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI10_USI, "dout_peric1_usi10_usi",
+	      "mout_peric1_usi10_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI10_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI11_USI, "dout_peric1_usi11_usi",
+	      "mout_peric1_usi11_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI11_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI16_USI, "dout_peric1_usi16_usi",
+	      "mout_peric1_usi16_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI16_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DOUT_PERIC1_USI17_USI, "dout_peric1_usi17_usi",
+	      "mout_peric1_usi17_usi_user",
+	      CLK_CON_DIV_DIV_CLK_PERIC1_USI17_USI, 0, 4,
+	      CLK_SET_RATE_PARENT, 0),
 	DIV(CLK_DOUT_PERIC1_USI_I2C, "dout_peric1_usi_i2c",
 	    "mout_peric1_usi_i2c_user",
 	    CLK_CON_DIV_DIV_CLK_PERIC1_USI_I2C,
-- 
2.53.0



