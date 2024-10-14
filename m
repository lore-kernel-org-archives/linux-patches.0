Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA2481749;
	Mon, 14 Oct 2024 14:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917976; cv=none; b=kzAmy4t4FEtzwSfVUb5t6936Uc2SZjazHnoQGexey2tH2MApnnlKbxcoSDBRPsMsp5W+sVSye0UzuNy14JWdeIgxYCkXcFBMQXiKyERKh1/TGLEoIO2pervcMGMYpooBYrd0yZXroc3MHJktHKuiLxOufezktV+oh0Zl9qrZivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917976; c=relaxed/simple;
	bh=BStISiLnROqtA59xv8XMZKOkC2k9E2/sCp/QTZYwuNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/l+j1Zb8G80t3FDep4uwTUw4tF7GH/FZWZMrSaaJ/FLJ5R/PK2HIp+oIgX2rFE4XqNNpmqvwwdBt/9Il18/Xw2ZX3uD6lojESXrW//gB11PP45mc00BG0DfOrtBo8qFkduyDUBmQY0dWYsQvVjIpy1inpyoG8CA2mTnwoZmNsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pv5v1vAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pv5v1vAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8919BC4CEC3;
	Mon, 14 Oct 2024 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917976;
	bh=BStISiLnROqtA59xv8XMZKOkC2k9E2/sCp/QTZYwuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pv5v1vAbKokS8B3YrHMq7CWIrS0eJPzTFq/TnAqjD7Pd53POl8d7YR/2XuNmMuV6j
	 4nz5QL76VlCFgUDWnRUz8jkxl2sxmylI5ZNU/vOyrDTwT9E1gjsp954jltKuCX10h6
	 ivpLNQSrz0WozhaNi7qxlNK5kwd1kzVEPHwyAFDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/798] clk: imx: fracn-gppll: support integer pll
Date: Mon, 14 Oct 2024 16:12:20 +0200
Message-ID: <20241014141225.242230474@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 56b8d0bf3ea8b0db8543e04a6b97348a543405ab ]

The fracn gppll could be configured in FRAC or INTEGER mode during
hardware design. The current driver only support FRAC mode, while
this patch introduces INTEGER support. When the PLL is INTEGER pll,
there is no mfn, mfd, the calculation is as below:
 Fvco_clk = (Fref / DIV[RDIV] ) * DIV[MFI]
 Fclko_odiv = Fvco_clk / DIV[ODIV]

In this patch, we reuse the FRAC pll logic with some condition check to
simplify the driver

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230403095300.3386988-4-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 7622f888fca1 ("clk: imx: fracn-gppll: fix fractional part of PLL getting lost")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 68 +++++++++++++++++++++++++++----
 drivers/clk/imx/clk.h             |  7 ++++
 2 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index f6674110a88e0..e2633ad94640f 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -53,11 +53,22 @@
 		.odiv	=	(_odiv),			\
 	}
 
+#define PLL_FRACN_GP_INTEGER(_rate, _mfi, _rdiv, _odiv)		\
+	{							\
+		.rate	=	(_rate),			\
+		.mfi	=	(_mfi),				\
+		.mfn	=	0,				\
+		.mfd	=	0,				\
+		.rdiv	=	(_rdiv),			\
+		.odiv	=	(_odiv),			\
+	}
+
 struct clk_fracn_gppll {
 	struct clk_hw			hw;
 	void __iomem			*base;
 	const struct imx_fracn_gppll_rate_table *rate_table;
 	int rate_count;
+	u32 flags;
 };
 
 /*
@@ -83,6 +94,24 @@ struct imx_fracn_gppll_clk imx_fracn_gppll = {
 };
 EXPORT_SYMBOL_GPL(imx_fracn_gppll);
 
+/*
+ * Fvco = (Fref / rdiv) * MFI
+ * Fout = Fvco / odiv
+ * The (Fref / rdiv) should be in range 20MHz to 40MHz
+ * The Fvco should be in range 2.5Ghz to 5Ghz
+ */
+static const struct imx_fracn_gppll_rate_table int_tbl[] = {
+	PLL_FRACN_GP_INTEGER(1700000000U, 141, 1, 2),
+	PLL_FRACN_GP_INTEGER(1400000000U, 175, 1, 3),
+	PLL_FRACN_GP_INTEGER(900000000U, 150, 1, 4),
+};
+
+struct imx_fracn_gppll_clk imx_fracn_gppll_integer = {
+	.rate_table = int_tbl,
+	.rate_count = ARRAY_SIZE(int_tbl),
+};
+EXPORT_SYMBOL_GPL(imx_fracn_gppll_integer);
+
 static inline struct clk_fracn_gppll *to_clk_fracn_gppll(struct clk_hw *hw)
 {
 	return container_of(hw, struct clk_fracn_gppll, hw);
@@ -169,9 +198,15 @@ static unsigned long clk_fracn_gppll_recalc_rate(struct clk_hw *hw, unsigned lon
 		break;
 	}
 
-	/* Fvco = Fref * (MFI + MFN / MFD) */
-	fvco = fvco * mfi * mfd + fvco * mfn;
-	do_div(fvco, mfd * rdiv * odiv);
+	if (pll->flags & CLK_FRACN_GPPLL_INTEGER) {
+		/* Fvco = (Fref / rdiv) * MFI */
+		fvco = fvco * mfi;
+		do_div(fvco, rdiv * odiv);
+	} else {
+		/* Fvco = (Fref / rdiv) * (MFI + MFN / MFD) */
+		fvco = fvco * mfi * mfd + fvco * mfn;
+		do_div(fvco, mfd * rdiv * odiv);
+	}
 
 	return (unsigned long)fvco;
 }
@@ -215,8 +250,10 @@ static int clk_fracn_gppll_set_rate(struct clk_hw *hw, unsigned long drate,
 	pll_div = FIELD_PREP(PLL_RDIV_MASK, rate->rdiv) | rate->odiv |
 		FIELD_PREP(PLL_MFI_MASK, rate->mfi);
 	writel_relaxed(pll_div, pll->base + PLL_DIV);
-	writel_relaxed(rate->mfd, pll->base + PLL_DENOMINATOR);
-	writel_relaxed(FIELD_PREP(PLL_MFN_MASK, rate->mfn), pll->base + PLL_NUMERATOR);
+	if (pll->flags & CLK_FRACN_GPPLL_FRACN) {
+		writel_relaxed(rate->mfd, pll->base + PLL_DENOMINATOR);
+		writel_relaxed(FIELD_PREP(PLL_MFN_MASK, rate->mfn), pll->base + PLL_NUMERATOR);
+	}
 
 	/* Wait for 5us according to fracn mode pll doc */
 	udelay(5);
@@ -300,8 +337,10 @@ static const struct clk_ops clk_fracn_gppll_ops = {
 	.set_rate	= clk_fracn_gppll_set_rate,
 };
 
-struct clk_hw *imx_clk_fracn_gppll(const char *name, const char *parent_name, void __iomem *base,
-				   const struct imx_fracn_gppll_clk *pll_clk)
+static struct clk_hw *_imx_clk_fracn_gppll(const char *name, const char *parent_name,
+					   void __iomem *base,
+					   const struct imx_fracn_gppll_clk *pll_clk,
+					   u32 pll_flags)
 {
 	struct clk_fracn_gppll *pll;
 	struct clk_hw *hw;
@@ -322,6 +361,7 @@ struct clk_hw *imx_clk_fracn_gppll(const char *name, const char *parent_name, vo
 	pll->hw.init = &init;
 	pll->rate_table = pll_clk->rate_table;
 	pll->rate_count = pll_clk->rate_count;
+	pll->flags = pll_flags;
 
 	hw = &pll->hw;
 
@@ -334,4 +374,18 @@ struct clk_hw *imx_clk_fracn_gppll(const char *name, const char *parent_name, vo
 
 	return hw;
 }
+
+struct clk_hw *imx_clk_fracn_gppll(const char *name, const char *parent_name, void __iomem *base,
+				   const struct imx_fracn_gppll_clk *pll_clk)
+{
+	return _imx_clk_fracn_gppll(name, parent_name, base, pll_clk, CLK_FRACN_GPPLL_FRACN);
+}
 EXPORT_SYMBOL_GPL(imx_clk_fracn_gppll);
+
+struct clk_hw *imx_clk_fracn_gppll_integer(const char *name, const char *parent_name,
+					   void __iomem *base,
+					   const struct imx_fracn_gppll_clk *pll_clk)
+{
+	return _imx_clk_fracn_gppll(name, parent_name, base, pll_clk, CLK_FRACN_GPPLL_INTEGER);
+}
+EXPORT_SYMBOL_GPL(imx_clk_fracn_gppll_integer);
diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
index fb59131395f03..ef090fa3327a2 100644
--- a/drivers/clk/imx/clk.h
+++ b/drivers/clk/imx/clk.h
@@ -74,6 +74,9 @@ extern struct imx_pll14xx_clk imx_1416x_pll;
 extern struct imx_pll14xx_clk imx_1443x_pll;
 extern struct imx_pll14xx_clk imx_1443x_dram_pll;
 
+#define CLK_FRACN_GPPLL_INTEGER	BIT(0)
+#define CLK_FRACN_GPPLL_FRACN	BIT(1)
+
 /* NOTE: Rate table should be kept sorted in descending order. */
 struct imx_fracn_gppll_rate_table {
 	unsigned int rate;
@@ -92,8 +95,12 @@ struct imx_fracn_gppll_clk {
 
 struct clk_hw *imx_clk_fracn_gppll(const char *name, const char *parent_name, void __iomem *base,
 				   const struct imx_fracn_gppll_clk *pll_clk);
+struct clk_hw *imx_clk_fracn_gppll_integer(const char *name, const char *parent_name,
+					   void __iomem *base,
+					   const struct imx_fracn_gppll_clk *pll_clk);
 
 extern struct imx_fracn_gppll_clk imx_fracn_gppll;
+extern struct imx_fracn_gppll_clk imx_fracn_gppll_integer;
 
 #define imx_clk_cpu(name, parent_name, div, mux, pll, step) \
 	to_clk(imx_clk_hw_cpu(name, parent_name, div, mux, pll, step))
-- 
2.43.0



