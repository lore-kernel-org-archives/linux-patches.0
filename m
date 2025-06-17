Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B02FA628;
	Tue, 17 Jun 2025 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178961; cv=none; b=vDYACHewL0njkrt81li3gQso2uhKY6Hxkwc3Qhz2LtN6bCSZppRtS8xLqfkXK1mCGHJH14juapAq9VhisSO8vKc9vGZDPD2iT0cwDPOszMcVI6HfZqAd5R8xuhwPAmofGXA+zXX4Mo4AZbhg/r0dBkMIH01IdOzJ5Kq01HfH7vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178961; c=relaxed/simple;
	bh=72wcJTRapVJsr1O5ciX3p4Rn89hS7RvsD30HEY5X8BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQsxsHa2SE95jfcaaLEH9TuqvL7yT2wHm2tRGyabbPAY/rzA3az8b+LFECuax7oH0FsfXOifwagONw8lkF+O+gJdy7EvF0PO89sNDnzGkZa3nKwgkl8NIPd636ixc/VTRlPKfAbWL3LdtN8fEKcUfaJExsjVbsFExkj9b6FEtNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQg5yd+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQg5yd+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47948C4CEE7;
	Tue, 17 Jun 2025 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178961;
	bh=72wcJTRapVJsr1O5ciX3p4Rn89hS7RvsD30HEY5X8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQg5yd+e6srphHv/JdBFoOw9hve4ze19CFtHhze+HAlLuf+M8cqS0AqqPxG7m8+Db
	 SJohuAW6BMycrdQLmvYhP9M8vqi09l1yBz9vwOzc+jbBz8GdkqlN/wj/KA2aMb0Wqc
	 a0du/mttjFiOy4+1BtkqOGhtJBZdbjEJIVrcpTN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 604/780] drm/i915/display: Fix u32 overflow in SNPS PHY HDMI PLL setup
Date: Tue, 17 Jun 2025 17:25:12 +0200
Message-ID: <20250617152516.080961029@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>

[ Upstream commit 791d76005de0ab556b590473eb4cbfede727fce0 ]

When configuring the HDMI PLL, calculations use DIV_ROUND_UP_ULL and
DIV_ROUND_DOWN_ULL macros, which internally rely on do_div. However, do_div
expects a 32-bit (u32) divisor, and at higher data rates, the divisor can
exceed this limit. This leads to incorrect division results and
ultimately misconfigured PLL values.
This fix replaces do_div calls with  div64_base64 calls where diviser
can exceed u32 limit.

Fixes: 5947642004bf ("drm/i915/display: Add support for SNPS PHY HDMI PLL algorithm for DG2")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://lore.kernel.org/r/20250528064557.4172149-1-dibin.moolakadan.subrahmanian@intel.com
(cherry picked from commit ce924116e43ffbfa544d82976c4b9d11bcde9334)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/display/intel_snps_hdmi_pll.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c b/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c
index c6321dafef4f3..74bb3bedf30f5 100644
--- a/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c
@@ -41,12 +41,12 @@ static s64 interp(s64 x, s64 x1, s64 x2, s64 y1, s64 y2)
 {
 	s64 dydx;
 
-	dydx = DIV_ROUND_UP_ULL((y2 - y1) * 100000, (x2 - x1));
+	dydx = DIV64_U64_ROUND_UP((y2 - y1) * 100000, (x2 - x1));
 
-	return (y1 + DIV_ROUND_UP_ULL(dydx * (x - x1), 100000));
+	return (y1 + DIV64_U64_ROUND_UP(dydx * (x - x1), 100000));
 }
 
-static void get_ana_cp_int_prop(u32 vco_clk,
+static void get_ana_cp_int_prop(u64 vco_clk,
 				u32 refclk_postscalar,
 				int mpll_ana_v2i,
 				int c, int a,
@@ -115,16 +115,16 @@ static void get_ana_cp_int_prop(u32 vco_clk,
 								      CURVE0_MULTIPLIER));
 
 	scaled_interpolated_sqrt =
-			int_sqrt(DIV_ROUND_UP_ULL(interpolated_product, vco_div_refclk_float) *
+			int_sqrt(DIV64_U64_ROUND_UP(interpolated_product, vco_div_refclk_float) *
 			DIV_ROUND_DOWN_ULL(1000000000000ULL, 55));
 
 	/* Scale vco_div_refclk for ana_cp_int */
 	scaled_vco_div_refclk2 = DIV_ROUND_UP_ULL(vco_div_refclk_float, 1000000);
-	adjusted_vco_clk2 = 1460281 * DIV_ROUND_UP_ULL(scaled_interpolated_sqrt *
+	adjusted_vco_clk2 = 1460281 * DIV64_U64_ROUND_UP(scaled_interpolated_sqrt *
 						       scaled_vco_div_refclk2,
 						       curve_1_interpolated);
 
-	*ana_cp_prop = DIV_ROUND_UP_ULL(adjusted_vco_clk2, curve_2_scaled2);
+	*ana_cp_prop = DIV64_U64_ROUND_UP(adjusted_vco_clk2, curve_2_scaled2);
 	*ana_cp_prop = max(1, min(*ana_cp_prop, 127));
 }
 
@@ -165,10 +165,10 @@ static void compute_hdmi_tmds_pll(u64 pixel_clock, u32 refclk,
 	/* Select appropriate v2i point */
 	if (datarate <= INTEL_SNPS_PHY_HDMI_9999MHZ) {
 		mpll_ana_v2i = 2;
-		tx_clk_div = ilog2(DIV_ROUND_DOWN_ULL(INTEL_SNPS_PHY_HDMI_9999MHZ, datarate));
+		tx_clk_div = ilog2(div64_u64(INTEL_SNPS_PHY_HDMI_9999MHZ, datarate));
 	} else {
 		mpll_ana_v2i = 3;
-		tx_clk_div = ilog2(DIV_ROUND_DOWN_ULL(INTEL_SNPS_PHY_HDMI_16GHZ, datarate));
+		tx_clk_div = ilog2(div64_u64(INTEL_SNPS_PHY_HDMI_16GHZ, datarate));
 	}
 	vco_clk = (datarate << tx_clk_div) >> 1;
 
-- 
2.39.5



