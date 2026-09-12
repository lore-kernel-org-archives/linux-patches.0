Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB83FC5B5;
	Sat, 12 Sep 2026 08:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202047; cv=none; b=tvAbrx4VnLasjTwAZH8VKB8Yn1rNhhBtdoNE99aKqpwxGOHYjVvddZYUMw/n7nvBckQDfi4uofUsrLk8xZpDCUm/TzLfJOfpmUpT8I7NwSuB8tMqvUgojLNVo/rO8qUh45PfZVhUhMiI/spQ6QQH1tAg0SNa2IBnQQWPZaDH24s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202047; c=relaxed/simple;
	bh=f1wbr7//Afe6UGh8WFUxxOLWFlBoBsdEGKb7ek0XHLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD21w7EaFRkL2bF6ProW4enEKGFIt/okcgANLtlUlc+WLKdoDGf5u/RyNiHCSfWS23/RuNE7kI8Rb1HO2deCbKR1xtWsyH8U8psZrFtXMsffzvLQWK7Ak1qP49xBuAzJSkAKu+tZ+XE/Im3QfWisYwweXKVTKih7IdmEw/bty4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQejU5QA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQejU5QA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E96D1F000FF;
	Sat, 12 Sep 2026 08:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202046;
	bh=odKxMEBzPwRyVE2gn+Wqf62FrRrc3qwxQwhLl9Vg/0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQejU5QAcoZJKjSrUtr8QFbdtA3b5ONQS5hR0IcGbp4LNbBWWcvPI8dLffN622okE
	 n98OJ6/PY0GZfOA7sNOoJxu58PCKe3LMnWSrH8oOb0cWbBt+d4IO2CkzqScF93VB12
	 JLE9SpTFtjSVAZC1qKFiF7ijaDIuBrvVX9JzAiow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1122/1815] clk: rockchip: rk3576: fix source muxes for SPI0..SPI4
Date: Sat, 12 Sep 2026 08:47:52 +0200
Message-ID: <20260912065715.359413907@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 586ff159ec02533c17dd928641529cb0b52e9c62 ]

The TRM defines available source muxes for SPI0..SPI4 as
 - b00: clk_gpll_div6_src
 - b01: clk_gpll_div8_src
 - b10: clk_cpll_div10_src
 - b11: clk_xin_osc0_func

Which doesn't match what the current clock driver implements, making it
impossible to derive some SPI clock rates such as 37.125 MHz (which
requires clk_gpll_div8_src as the source mux).

Add a correct mux definition per TRM and point SPI0..SPI4 clocks at it.

Fixes: cc40f5baa91b ("clk: rockchip: Add clock controller for the RK3576")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260805-rk3576-spi-clk-v1-1-2f040d0d163b@flipper.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3576.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3576.c b/drivers/clk/rockchip/clk-rk3576.c
index 63f229e73a454..2cdd667f40041 100644
--- a/drivers/clk/rockchip/clk-rk3576.c
+++ b/drivers/clk/rockchip/clk-rk3576.c
@@ -315,6 +315,7 @@ PNAME(mux_100m_24m_lclk0_p)		= { "clk_cpll_div10", "xin24m", "lclk_asrc_src_0" }
 PNAME(mux_100m_24m_lclk1_p)		= { "clk_cpll_div10", "xin24m", "lclk_asrc_src_1" };
 PNAME(mux_150m_100m_50m_24m_p)		= { "clk_gpll_div8", "clk_cpll_div10", "clk_cpll_div20", "xin24m" };
 PNAME(mux_200m_100m_50m_24m_p)		= { "clk_gpll_div6", "clk_cpll_div10", "clk_cpll_div20", "xin24m" };
+PNAME(mux_200m_150m_100m_24m_p)		= { "clk_gpll_div6", "clk_gpll_div8", "clk_cpll_div10", "xin24m" };
 PNAME(mux_400m_200m_100m_24m_p)		= { "clk_gpll_div3", "clk_gpll_div6", "clk_cpll_div10", "xin24m" };
 PNAME(mux_500m_250m_100m_24m_p)		= { "clk_cpll_div2", "clk_cpll_div4", "clk_cpll_div10", "xin24m" };
 PNAME(mux_600m_400m_300m_24m_p)		= { "clk_gpll_div2", "clk_gpll_div3", "clk_gpll_div4", "xin24m" };
@@ -706,19 +707,19 @@ static struct rockchip_clk_branch rk3576_clk_branches[] __initdata = {
 			RK3576_CLKGATE_CON(16), 0, GFLAGS),
 	GATE(PCLK_SPI4, "pclk_spi4", "pclk_bus_root", 0,
 			RK3576_CLKGATE_CON(16), 1, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI0, "clk_spi0", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI0, "clk_spi0", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(70), 13, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 2, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI1, "clk_spi1", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI1, "clk_spi1", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 0, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 3, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI2, "clk_spi2", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI2, "clk_spi2", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 2, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 4, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI3, "clk_spi3", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI3, "clk_spi3", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 4, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 5, GFLAGS),
-	COMPOSITE_NODIV(CLK_SPI4, "clk_spi4", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(CLK_SPI4, "clk_spi4", mux_200m_150m_100m_24m_p, 0,
 			RK3576_CLKSEL_CON(71), 6, 2, MFLAGS,
 			RK3576_CLKGATE_CON(16), 6, GFLAGS),
 	GATE(PCLK_WDT0, "pclk_wdt0", "pclk_bus_root", 0,
-- 
2.53.0



