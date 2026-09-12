Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30325CA6F;
	Sat, 12 Sep 2026 10:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208449; cv=none; b=XInLxe1pqPLhGO7wLqPvYZsVFC6tFh6voksmD44G7IMaRHyvrLIpE5s7vXRarovRAf84PuWO4FyvM6+fWYUEbFEAvn3I6M2ioTQvE0ondQSKA52FMMLOUPDYdA1RxU6cLrqZuWe/7ctnMijm0thdvRLYVXUnYOUD1J/xOIhqRhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208449; c=relaxed/simple;
	bh=0I3bOxfOj4kHrYlG4CqyXMK0RNqyNnceJXlefMdnzs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFRXVGAYA5CWoTcXkr7aNUDnJ9KxnY5vrnT1GKO7/Uvt4Ar8tvKhFdSLbEDBRzmCx9czIZ4zwLS9BU9EowD8p7aEbY3RYLbavY5AeFXk/67KHfUJribqoChFUdS5vM9DdEbFKQgeaVonDkxjLDeWhCc9vO3sJVAhn7C5fEzn6Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaI8QOgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaI8QOgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020931F000FF;
	Sat, 12 Sep 2026 10:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208448;
	bh=3ZHfwWWDDuM0CLHZOnk+CmCjtS3b3PkQK74a7u83H/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaI8QOgzWFNqUuaybQiyAPs77I8C75JQZFqbI/JuFqd+hpA1WI7v5RuVr8ngxB3gm
	 XgkBYosPT+mP19d86Nq3UbSykNu8tYbYwrxi2r/KAD6JSVCyOXL07nOoIuJXZiawKH
	 mq8G+Jq1sE/v0IgDq5jbc6f1h+ukciu2MQicJbp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0619/1518] clk: rockchip: Fix the fractional part denominator on RK3588/RK3576 PLLs
Date: Sat, 12 Sep 2026 08:46:28 +0200
Message-ID: <20260912065637.431220397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 52aef653c3d0c24013dfa9eccf692594eacdbe17 ]

According to the TRM, the fractional PLL coefficient should be divided by
65536 rather than 65535 to obtain the output rate.

Fix the denominator and add a comment with the TRM provided clock formulae
for future reference.

See RK3576 TRM Part 1 V1.2 section 2.13.1.4 Setting Guide on P, M, S and K
or equivalently RK3588 TRM part 1 V1.0 section 2.17.1.4 Setting Guide on P,
M, S and K.

Fractional PLL rates don't seem to be used by any current mainline
consumers, so this is purely a correctness fix. It will also be important
to properly support DisplayPort output going forward, as the video output
controller derives its pixel clock from system PLLs with no dedicated PHY
PLL option for DP unlike HDMI, and some display modes are only achievable
with fractional PLL rates.

Fixes: 8f6594494b1c ("clk: rockchip: add pll type for RK3588")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260723-rk3588-fracpll-v2-1-3adfb9dda235@flipper.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-pll.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index 86dba3826a77e..0dada00b375fa 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -900,6 +900,13 @@ static void rockchip_rk3588_pll_get_params(struct rockchip_clk_pll *pll,
 	rate->k = ((pllcon >> RK3588_PLLCON2_K_SHIFT) & RK3588_PLLCON2_K_MASK);
 }
 
+/*
+ * 2250 MHz <= Fvco <= 4500 MHz
+ * For Fvco > 3 GHz: period jitter +-1% frac PLL, +-0.75% int PLL
+ * For Fvco < 3 GHz: period jitter +-2% frac PLL, +-1.50% int PLL
+ * Fvco = ((m + k / 65536) * Fin) / p
+ * Fout = ((m + k / 65536) * Fin) / (p * 2^s)
+ */
 static unsigned long rockchip_rk3588_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 {
 	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
@@ -915,7 +922,7 @@ static unsigned long rockchip_rk3588_pll_recalc_rate(struct clk_hw *hw, unsigned
 		/* fractional mode */
 		u64 frac_rate64 = prate * cur.k;
 
-		postdiv = cur.p * 65535;
+		postdiv = cur.p * 65536;
 		do_div(frac_rate64, postdiv);
 		rate64 += frac_rate64;
 	}
-- 
2.53.0



