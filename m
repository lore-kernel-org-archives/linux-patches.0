Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1882518B0A;
	Wed, 25 Feb 2026 01:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983389; cv=none; b=K3CK1zoKOG3D+Y/3bIzH2Zlg1bJ8p025XnFr+1RD4kmslnLCzzcsekGhdbDepMfKrfK0/gq9g6GgAM3tKMx3hAM0STT4b02F6ypR2zHAHraWjerwzLMaQluEpdbcNCrfaB7eZQjNOpyYu/G8Xx5j+rr78K6bUJZEg/jGh+pW+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983389; c=relaxed/simple;
	bh=gQCbjtcz6r17DLWj9UaqlL07ccdKijZQcDwkqdd1MLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMh1YfWsEmk1GsVhndG158ZycASWDPnnDxjJ3IlmrSu4+3pqjNL0dXeqcqs6lRT9S2r+/9kIwLQJYTmladBBHUqGfGYKDLN+KLsqyxKaIdPvj+J9jq1NclQUkqyso+YjSBGXAtSBTwQuXpcKj7YQDTR9pSdsPDI2eVYoYIPsAcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTdmZeOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTdmZeOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6FDC116D0;
	Wed, 25 Feb 2026 01:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983389;
	bh=gQCbjtcz6r17DLWj9UaqlL07ccdKijZQcDwkqdd1MLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTdmZeOp1GCsOsc5GJyiKz4BbQn90OGbdWUbx0UHGbREeCk6hKoyHnHtq7s7bVWmI
	 Bf3l8/FXZKYG8BsI829bupW1pk/NIrHnd4ay+lprndFelO8BE3iDaqjuE3DNztOcMC
	 CIP6M3JhPambbcY8npMl1S56riM2x7UJacYZjRlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <fustini@kernel.org>,
	Yao Zi <ziyao@disroot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 511/781] clk: thead: th1520-ap: Poll for PLL lock and wait for stability
Date: Tue, 24 Feb 2026 17:20:20 -0800
Message-ID: <20260225012412.338794381@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 892abfbed71e8e0fc5d6ccee1e975904805c6327 ]

All PLLs found on TH1520 SoC take 21250ns at maximum to lock, and their
lock status is indicated by register PLL_STS (offset 0x80 inside AP
clock controller). We should poll the register to ensure the PLL
actually locks after enabling it.

Furthermore, a 30us delay is added after enabling the PLL, after which
the PLL could be considered stable as stated by vendor clock code.

Fixes: 56a48c1833aa ("clk: thead: add support for enabling/disabling PLLs")
Reviewed-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 34 +++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 71ad03a998e8e..d870f0c665f8a 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -8,11 +8,14 @@
 #include <dt-bindings/clock/thead,th1520-clk-ap.h>
 #include <linux/bitfield.h>
 #include <linux/clk-provider.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
+#define TH1520_PLL_STS		0x80
+
 #define TH1520_PLL_POSTDIV2	GENMASK(26, 24)
 #define TH1520_PLL_POSTDIV1	GENMASK(22, 20)
 #define TH1520_PLL_FBDIV	GENMASK(19, 8)
@@ -23,6 +26,13 @@
 #define TH1520_PLL_FRAC		GENMASK(23, 0)
 #define TH1520_PLL_FRAC_BITS    24
 
+/*
+ * All PLLs in TH1520 take 21250ns at maximum to lock, let's take its double
+ * for safety.
+ */
+#define TH1520_PLL_LOCK_TIMEOUT_US	44
+#define TH1520_PLL_STABLE_DELAY_US	30
+
 struct ccu_internal {
 	u8	shift;
 	u8	width;
@@ -64,6 +74,7 @@ struct ccu_div {
 
 struct ccu_pll {
 	struct ccu_common	common;
+	u32			lock_sts_mask;
 };
 
 #define TH_CCU_ARG(_shift, _width)					\
@@ -299,9 +310,21 @@ static void ccu_pll_disable(struct clk_hw *hw)
 static int ccu_pll_enable(struct clk_hw *hw)
 {
 	struct ccu_pll *pll = hw_to_ccu_pll(hw);
+	u32 reg;
+	int ret;
 
-	return regmap_clear_bits(pll->common.map, pll->common.cfg1,
-				 TH1520_PLL_VCO_RST);
+	regmap_clear_bits(pll->common.map, pll->common.cfg1,
+			  TH1520_PLL_VCO_RST);
+
+	ret = regmap_read_poll_timeout_atomic(pll->common.map, TH1520_PLL_STS,
+					      reg, reg & pll->lock_sts_mask,
+					      5, TH1520_PLL_LOCK_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	udelay(TH1520_PLL_STABLE_DELAY_US);
+
+	return 0;
 }
 
 static int ccu_pll_is_enabled(struct clk_hw *hw)
@@ -389,6 +412,7 @@ static struct ccu_pll cpu_pll0_clk = {
 					      &clk_pll_ops,
 					      CLK_IS_CRITICAL),
 	},
+	.lock_sts_mask		= BIT(1),
 };
 
 static struct ccu_pll cpu_pll1_clk = {
@@ -401,6 +425,7 @@ static struct ccu_pll cpu_pll1_clk = {
 					      &clk_pll_ops,
 					      CLK_IS_CRITICAL),
 	},
+	.lock_sts_mask		= BIT(4),
 };
 
 static struct ccu_pll gmac_pll_clk = {
@@ -413,6 +438,7 @@ static struct ccu_pll gmac_pll_clk = {
 					      &clk_pll_ops,
 					      CLK_IS_CRITICAL),
 	},
+	.lock_sts_mask		= BIT(3),
 };
 
 static const struct clk_hw *gmac_pll_clk_parent[] = {
@@ -433,6 +459,7 @@ static struct ccu_pll video_pll_clk = {
 					      &clk_pll_ops,
 					      CLK_IS_CRITICAL),
 	},
+	.lock_sts_mask		= BIT(7),
 };
 
 static const struct clk_hw *video_pll_clk_parent[] = {
@@ -453,6 +480,7 @@ static struct ccu_pll dpu0_pll_clk = {
 					      &clk_pll_ops,
 					      0),
 	},
+	.lock_sts_mask		= BIT(8),
 };
 
 static const struct clk_hw *dpu0_pll_clk_parent[] = {
@@ -469,6 +497,7 @@ static struct ccu_pll dpu1_pll_clk = {
 					      &clk_pll_ops,
 					      0),
 	},
+	.lock_sts_mask		= BIT(9),
 };
 
 static const struct clk_hw *dpu1_pll_clk_parent[] = {
@@ -485,6 +514,7 @@ static struct ccu_pll tee_pll_clk = {
 					      &clk_pll_ops,
 					      CLK_IS_CRITICAL),
 	},
+	.lock_sts_mask		= BIT(10),
 };
 
 static const struct clk_parent_data c910_i0_parents[] = {
-- 
2.51.0



