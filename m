Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27C12931FB;
	Sat, 12 Sep 2026 08:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200125; cv=none; b=Vfy19q2ZR4ZM8NDhKAqLqM3n3gm0A7d836uNa76ENqmHV3UXe0rHSTN7smTSMk0A7nWsxCJNn8lXHCAvYH7C33eG18XfyxTPcAkTCJvYUtM7F233MldvbdZj6l+j7KFJwrOrc/4UM9fuop2XLJEcO5mvpMcjNifpuTN29LoKUnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200125; c=relaxed/simple;
	bh=yGM/nwRrdF/m8yDgW0CORX4OgucOGZcCmCzYuNh21qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYhbR7Ge52LMyOnHbB0iIjTvtNISefSFZVdMJhGsUCVLu21ZAuNLI2ct/zE6Tz1twuQ3u0kI7XATuoupMXfg0BlD9i9HJ0vZDS0tFO7+aryjLSmrpMLlXAbOsgr+rTdIrvz6VTCXz/Qon0c9MwsDMENNfjV71kPuZr9v4UrpkDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4P087BM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4P087BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8D01F000FF;
	Sat, 12 Sep 2026 08:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200124;
	bh=hhKDhk3A6gaMQ8JxSQmMA2Mppde890P71k4vQSu8CCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4P087BMLqCfFXQ/WqFEPVC+4mFMKcwBYYLsonb47IcHmQiuKEx2s4W6tEeDmK/wP
	 NMe4evRj/0kZ2o3eWIuRqT4zDCxiSpQ/C6jcJLDmF7a8AAIXLFPLD28fKnCghXyFJp
	 q5jqOuXf6EB5JS1bv4UbhJaYeI5O2Gu9QifD0//8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0724/1815] clk: rockchip: Fractional PLL coefficient on RK3588/RK3576 is twos complement
Date: Sat, 12 Sep 2026 08:41:14 +0200
Message-ID: <20260912065705.897957506@linuxfoundation.org>
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

[ Upstream commit 5814788834774ed6ad1a27ae91b44eeca80cd27f ]

When the PLL rates table was first committed for RK3588 (and later reused
for RK3576), the fractional PLL coefficient was defined as an unsigned
value, while the TRM clearly states that it is a two's complement 16-bit
value.

Treating the fractional PLL coefficient as unsigned in rate recalculation
results in a kernel-visible rate which deviates from what the hardware
actually generates by Fin / (p * 2^s), or 2 MHz for the two affected table
entries.

Rockchip's downstream kernel later revised the fractional PLL code [1] to
account for the two's complement nature of the coefficient, but that
change wasn't upstreamed.

Change the PLL table definition to use two's complement for the
fractional coefficient and update its users accordingly.

Note that a negative fractional coefficient is meant to be subtracted from
the next larger integer multiplier, so the m values in the table are
also adjusted accordingly for the two negative-k entries.

Rockchip's downstream commit introducing the two's complement logic for k
also does unrelated tweaks to the PLL parameters which are not explained
by the switch to the two's complement, so they are not replicated here.
If any of the parameters prove to need further tweaks (e.g. for precision
or jitter) that would better be done in targeted follow-up commits.

Fractional PLL rates don't seem to be used by any current mainline
consumers, so this is purely a correctness fix. It will also be important
to properly support DisplayPort output going forward, as the video output
controller derives its pixel clock from system PLLs with no dedicated PHY
PLL option for DP unlike HDMI, and some display modes are only achievable
using fractional PLL rates.

Link: https://github.com/flipperdevices/rockchip-linux/commit/7a72bc05dcc3a51e85ae531749e6270bf9b9212d [1]
Fixes: f1c506d152ff ("clk: rockchip: add clock controller for the RK3588")
Fixes: cc40f5baa91b ("clk: rockchip: Add clock controller for the RK3576")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260723-rk3588-fracpll-v2-2-3adfb9dda235@flipper.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-pll.c    | 7 ++++---
 drivers/clk/rockchip/clk-rk3576.c | 4 ++--
 drivers/clk/rockchip/clk-rk3588.c | 4 ++--
 drivers/clk/rockchip/clk.h        | 8 ++++----
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index bf8acf7cee0d9..706ca4b344d39 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/clk-provider.h>
 #include <linux/iopoll.h>
+#include <linux/math64.h>
 #include <linux/regmap.h>
 #include <linux/clk.h>
 #include "clk.h"
@@ -906,6 +907,7 @@ static void rockchip_rk3588_pll_get_params(struct rockchip_clk_pll *pll,
  * For Fvco < 3 GHz: period jitter +-2% frac PLL, +-1.50% int PLL
  * Fvco = ((m + k / 65536) * Fin) / p
  * Fout = ((m + k / 65536) * Fin) / (p * 2^s)
+ * -32768 <= k <= 32767 (only available in frac PLLs, not int PLLs)
  */
 static unsigned long rockchip_rk3588_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 {
@@ -920,11 +922,10 @@ static unsigned long rockchip_rk3588_pll_recalc_rate(struct clk_hw *hw, unsigned
 
 	if (cur.k) {
 		/* fractional mode */
-		u64 frac_rate64 = prate * cur.k;
+		s64 frac_rate64 = (s64)prate * cur.k;
 
 		postdiv = cur.p * 65536;
-		do_div(frac_rate64, postdiv);
-		rate64 += frac_rate64;
+		rate64 += div_s64(frac_rate64, postdiv);
 	}
 	rate64 = rate64 >> cur.s;
 
diff --git a/drivers/clk/rockchip/clk-rk3576.c b/drivers/clk/rockchip/clk-rk3576.c
index 2557358e0b9d8..63f229e73a454 100644
--- a/drivers/clk/rockchip/clk-rk3576.c
+++ b/drivers/clk/rockchip/clk-rk3576.c
@@ -79,13 +79,13 @@ static struct rockchip_pll_rate_table rk3576_pll_rates[] = {
 	RK3588_PLL_RATE(1008000000, 2, 336, 2, 0),
 	RK3588_PLL_RATE(1000000000, 3, 500, 2, 0),
 	RK3588_PLL_RATE(983040000, 4, 655, 2, 23592),
-	RK3588_PLL_RATE(955520000, 3, 477, 2, 49806),
+	RK3588_PLL_RATE(955520000, 3, 478, 2, -15730),
 	RK3588_PLL_RATE(903168000, 6, 903, 2, 11009),
 	RK3588_PLL_RATE(900000000, 2, 300, 2, 0),
 	RK3588_PLL_RATE(816000000, 2, 272, 2, 0),
 	RK3588_PLL_RATE(786432000, 2, 262, 2, 9437),
 	RK3588_PLL_RATE(786000000, 1, 131, 2, 0),
-	RK3588_PLL_RATE(785560000, 3, 392, 2, 51117),
+	RK3588_PLL_RATE(785560000, 3, 393, 2, -14419),
 	RK3588_PLL_RATE(722534400, 8, 963, 2, 24850),
 	RK3588_PLL_RATE(600000000, 2, 200, 2, 0),
 	RK3588_PLL_RATE(594000000, 2, 198, 2, 0),
diff --git a/drivers/clk/rockchip/clk-rk3588.c b/drivers/clk/rockchip/clk-rk3588.c
index 86a6870cc2ee3..517e30e249d7b 100644
--- a/drivers/clk/rockchip/clk-rk3588.c
+++ b/drivers/clk/rockchip/clk-rk3588.c
@@ -79,14 +79,14 @@ static struct rockchip_pll_rate_table rk3588_pll_rates[] = {
 	RK3588_PLL_RATE(1008000000, 2, 336, 2, 0),
 	RK3588_PLL_RATE(1000000000, 3, 500, 2, 0),
 	RK3588_PLL_RATE(983040000, 4, 655, 2, 23592),
-	RK3588_PLL_RATE(955520000, 3, 477, 2, 49806),
+	RK3588_PLL_RATE(955520000, 3, 478, 2, -15730),
 	RK3588_PLL_RATE(903168000, 6, 903, 2, 11009),
 	RK3588_PLL_RATE(900000000, 2, 300, 2, 0),
 	RK3588_PLL_RATE(850000000, 3, 425, 2, 0),
 	RK3588_PLL_RATE(816000000, 2, 272, 2, 0),
 	RK3588_PLL_RATE(786432000, 2, 262, 2, 9437),
 	RK3588_PLL_RATE(786000000, 1, 131, 2, 0),
-	RK3588_PLL_RATE(785560000, 3, 392, 2, 51117),
+	RK3588_PLL_RATE(785560000, 3, 393, 2, -14419),
 	RK3588_PLL_RATE(722534400, 8, 963, 2, 24850),
 	RK3588_PLL_RATE(600000000, 2, 200, 2, 0),
 	RK3588_PLL_RATE(594000000, 2, 198, 2, 0),
diff --git a/drivers/clk/rockchip/clk.h b/drivers/clk/rockchip/clk.h
index 9e3503e2ffc23..72b36bba31523 100644
--- a/drivers/clk/rockchip/clk.h
+++ b/drivers/clk/rockchip/clk.h
@@ -635,10 +635,10 @@ struct rockchip_pll_rate_table {
 		};
 		struct {
 			/* for RK3588 */
-			unsigned int m;
-			unsigned int p;
-			unsigned int s;
-			unsigned int k;
+			unsigned int m;	/* main divider, 10 bit unsigned */
+			unsigned int p;	/* pre-divider, 6 bit unsigned */
+			unsigned int s;	/* scaler, 3 bit unsigned */
+			s16 k;		/* fractional part, 16 bit two's complement */
 		};
 	};
 };
-- 
2.53.0



