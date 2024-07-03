Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119D2181CE4;
	Wed,  3 Jul 2024 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003593; cv=none; b=LWXlyvwL+Yvk8hn4jqbfKH+rL+B/vRJw9QumMbAou+xGuYcYrFBNYyz/e9m3eMUCyeP16EHRZveUxOjytMjUusVA/kvocohAv4CglBobnIr3L6Y7zjlVERaHwXgNdv+NHiPp7dzCTCZifajNdZ5Xd63Ug+s3r0ltoHBf022lnfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003593; c=relaxed/simple;
	bh=YnJdVWdk8uUgzmp0/xG0y6P/0jRxollt/2aLo/ZaYbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZa9wvCrlFL187jgogYM8Z29MwBAUgcX8XU/lPsdirv5TQbebS4sjFdlkn0fXDOAZAfGDlz5HF3dARv8q97+1TuoDvZkLu/2RlWdmdTcdnbILKTRzJdtZjGeQQbJqe/Zw9l7m4D+zX6n8QLyJaQPaI/Q1YmTYFKyfh4ION0yUpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os0R1JQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os0R1JQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDB4C2BD10;
	Wed,  3 Jul 2024 10:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003593;
	bh=YnJdVWdk8uUgzmp0/xG0y6P/0jRxollt/2aLo/ZaYbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os0R1JQGK3aIqRS8I/2eQbLnfGXXX9gPbR1kQZfqkyLSC1SvCxmfJPHQotR1fQXoD
	 jdp5ZB+Q6KOG9Ddz02dBEAkowmm3Q+pVc9igCuJpC0nZiU8bUIrnQnkONIxpcN4IRR
	 /3LdUTgHTx0Sl2dep7RPxkzGvDrGmEXTRABNotAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang-Huang Bao <i@eh5.me>,
	Heiko Stuebner <heiko@sntech.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/139] pinctrl: rockchip: fix pinmux bits for RK3328 GPIO2-B pins
Date: Wed,  3 Jul 2024 12:39:57 +0200
Message-ID: <20240703102834.217127957@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang-Huang Bao <i@eh5.me>

[ Upstream commit e8448a6c817c2aa6c6af785b1d45678bd5977e8d ]

The pinmux bits for GPIO2-B0 to GPIO2-B6 actually have 2 bits width,
correct the bank flag for GPIO2-B. The pinmux bits for GPIO2-B7 is
recalculated so it remain unchanged.

The pinmux bits for those pins are not explicitly specified in RK3328
TRM, however we can get hint from pad name and its correspinding IOMUX
setting for pins in interface descriptions. The correspinding IOMIX
settings for GPIO2-B0 to GPIO2-B6 can be found in the same row next to
occurrences of following pad names in RK3328 TRM.

GPIO2-B0: IO_SPIclkm0_GPIO2B0vccio5
GPIO2-B1: IO_SPItxdm0_GPIO2B1vccio5
GPIO2-B2: IO_SPIrxdm0_GPIO2B2vccio5
GPIO2-B3: IO_SPIcsn0m0_GPIO2B3vccio5
GPIO2-B4: IO_SPIcsn1m0_FLASHvol_sel_GPIO2B4vccio5
GPIO2-B5: IO_ I2C2sda_TSADCshut_GPIO2B5vccio5
GPIO2-B6: IO_ I2C2scl_GPIO2B6vccio5

This fix has been tested on NanoPi R2S for fixing confliting pinmux bits
between GPIO2-B7 with GPIO2-B5.

Signed-off-by: Huang-Huang Bao <i@eh5.me>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Fixes: 3818e4a7678e ("pinctrl: rockchip: Add rk3328 pinctrl support")
Link: https://lore.kernel.org/r/20240606125755.53778-2-i@eh5.me
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index fb7f2282635e8..5d14b77d65285 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -662,12 +662,6 @@ static  struct rockchip_mux_recalced_data rk3128_mux_recalced_data[] = {
 
 static struct rockchip_mux_recalced_data rk3328_mux_recalced_data[] = {
 	{
-		.num = 2,
-		.pin = 12,
-		.reg = 0x24,
-		.bit = 8,
-		.mask = 0x3
-	}, {
 		.num = 2,
 		.pin = 15,
 		.reg = 0x28,
@@ -3689,7 +3683,7 @@ static struct rockchip_pin_bank rk3328_pin_banks[] = {
 	PIN_BANK_IOMUX_FLAGS(0, 32, "gpio0", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(1, 32, "gpio1", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(2, 32, "gpio2", 0,
-			     IOMUX_WIDTH_3BIT,
+			     0,
 			     IOMUX_WIDTH_3BIT,
 			     0),
 	PIN_BANK_IOMUX_FLAGS(3, 32, "gpio3",
-- 
2.43.0



