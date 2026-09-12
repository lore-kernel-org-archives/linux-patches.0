Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AAC30D3F6;
	Sat, 12 Sep 2026 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224012; cv=none; b=KP2WB+cs/fGJy6DtQ+xKgNa0mj5xF7BWmIl0Xqogh7D1+VTLH8T5m/CwChYprXOBS4yioXJ5LkHoXrajwMvmlkqnh/dIoUxDoNWp8CqPsnMYa9RV1/zAIh1926/iLpq/HMeNpsapTrop4yLy7Hm/aAy7iLjUe7sLBjwsYKYQxLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224012; c=relaxed/simple;
	bh=/PuradVO2F4ZSEsQNToKN4xGHyToR9yXxHkEh+kLGMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhLn+aOxfgw2LXa6JRgBCMJ72O1Z9QQ4R7Aaj4PzYofJTd2EZOUJq0R+VyyHBTdPh6Iv/gPmqHxnI/7XpUfEBQ4yFYh0Sv8b/mZopU0fpSljm0v1IfskvsOk9Q/ebx+OffAiRXtxM8OI/kts/EEydTYvi1GrUfe9TdB2BF78k3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEgAJGny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEgAJGny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1924E1F000FF;
	Sat, 12 Sep 2026 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224009;
	bh=gIKG9/QXof6DHXSjAnShR/PQe2DiXO9Nssmxeqa3eEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bEgAJGnygk5VcROkiz7+X5GtBrFK4chF4gGtUFLmZYxTSuIiRhYTjyfM0wqc/YWl2
	 aSkylt9tmS/4df589MaHWLWQqow+tA8Yll9fJH5lbV7aguh74eE4FFB3ObCnmqv/QL
	 GqJys9A22OWMrHbW6BNbW87KcAPdulrz/lgGk8xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0904/1424] clk: rockchip: Fix the fractional part denominator on RK3588/RK3576 PLLs
Date: Sat, 12 Sep 2026 08:55:36 +0200
Message-ID: <20260912065627.569365560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d42eb6289267..6c7890c150044 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -893,6 +893,13 @@ static void rockchip_rk3588_pll_get_params(struct rockchip_clk_pll *pll,
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
@@ -908,7 +915,7 @@ static unsigned long rockchip_rk3588_pll_recalc_rate(struct clk_hw *hw, unsigned
 		/* fractional mode */
 		u64 frac_rate64 = prate * cur.k;
 
-		postdiv = cur.p * 65535;
+		postdiv = cur.p * 65536;
 		do_div(frac_rate64, postdiv);
 		rate64 += frac_rate64;
 	}
-- 
2.53.0



