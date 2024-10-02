Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1E31D551;
	Wed,  2 Oct 2024 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879932; cv=none; b=DJdupRbd8r+HMOr2htrAKrhPR4JZr1KrnPs1I/9QcyH3BZoIjVvvMSBGNsz1/1NcbD4FjWRUl+J7mBCPBHbiR/KDnuz81uVbFi5gzAmyYSzcXMQ5ecRAdxpi7lDMHbnVibgOULcn6L7DbrCDveDM04k+DVUPulC6f3bPtPzW1rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879932; c=relaxed/simple;
	bh=qTjxyBRyOp1H5Lk8UUcWecKRouMbemmjZ5R1T0qP/lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlB4F8h4VJeBVMiKD7wih3GhMCLx4IVCqq40odh5quELOD5mKXQUa0MHUy5bvcDjDlzwJg/BeHkQ12CJGo6aJmHmLlKo2/0FOUTIWdgCW/hwxd14XJEsq7x3P4TCbppqonrKfkjoQp+lZ1VeXpI1z2+paaIX1T5W6B8+6WRylRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lakEJqcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lakEJqcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96196C4CEC2;
	Wed,  2 Oct 2024 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879932;
	bh=qTjxyBRyOp1H5Lk8UUcWecKRouMbemmjZ5R1T0qP/lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lakEJqcSqFB5qLdk9Mwv9bWJVf0hcRqHx/2zQN7e/mC1+wPzoeIdm8ZHdl/cfSL3T
	 vXNqu4KXz3AfTsOZp6Rzl98sZRkO8SZPJ39vcY/Wl0uTUMP6Yoi57V8akLqM5r4WkQ
	 zYuSruoDVA9y/aQj9CMPLvu85rVMqBvNLSDkQqRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/538] clk: qcom: dispcc-sm8250: use special function for Lucid 5LPE PLL
Date: Wed,  2 Oct 2024 14:58:46 +0200
Message-ID: <20241002125803.584417717@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 362be5cbaec2a663eb86b7105313368b4a71fc1e ]

According to msm-5.10 the lucid 5lpe PLLs have require slightly
different configuration that trion / lucid PLLs, it doesn't set
PLL_UPDATE_BYPASS bit. Add corresponding function and use it for the
display clock controller on Qualcomm SM8350 platform.

Fixes: 205737fe3345 ("clk: qcom: add support for SM8350 DISPCC")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240804-sm8350-fixes-v1-2-1149dd8399fe@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 52 ++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-alpha-pll.h |  2 ++
 drivers/clk/qcom/dispcc-sm8250.c |  9 ++++--
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 1701cce74df79..7464cf64803fd 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1757,6 +1757,58 @@ const struct clk_ops clk_alpha_pll_agera_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_alpha_pll_agera_ops);
 
+/**
+ * clk_lucid_5lpe_pll_configure - configure the lucid 5lpe pll
+ *
+ * @pll: clk alpha pll
+ * @regmap: register map
+ * @config: configuration to apply for pll
+ */
+void clk_lucid_5lpe_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
+				  const struct alpha_pll_config *config)
+{
+	/*
+	 * If the bootloader left the PLL enabled it's likely that there are
+	 * RCGs that will lock up if we disable the PLL below.
+	 */
+	if (trion_pll_is_enabled(pll, regmap)) {
+		pr_debug("Lucid 5LPE PLL is already enabled, skipping configuration\n");
+		return;
+	}
+
+	clk_alpha_pll_write_config(regmap, PLL_L_VAL(pll), config->l);
+	regmap_write(regmap, PLL_CAL_L_VAL(pll), TRION_PLL_CAL_VAL);
+	clk_alpha_pll_write_config(regmap, PLL_ALPHA_VAL(pll), config->alpha);
+	clk_alpha_pll_write_config(regmap, PLL_CONFIG_CTL(pll),
+				     config->config_ctl_val);
+	clk_alpha_pll_write_config(regmap, PLL_CONFIG_CTL_U(pll),
+				     config->config_ctl_hi_val);
+	clk_alpha_pll_write_config(regmap, PLL_CONFIG_CTL_U1(pll),
+				     config->config_ctl_hi1_val);
+	clk_alpha_pll_write_config(regmap, PLL_USER_CTL(pll),
+					config->user_ctl_val);
+	clk_alpha_pll_write_config(regmap, PLL_USER_CTL_U(pll),
+					config->user_ctl_hi_val);
+	clk_alpha_pll_write_config(regmap, PLL_USER_CTL_U1(pll),
+					config->user_ctl_hi1_val);
+	clk_alpha_pll_write_config(regmap, PLL_TEST_CTL(pll),
+					config->test_ctl_val);
+	clk_alpha_pll_write_config(regmap, PLL_TEST_CTL_U(pll),
+					config->test_ctl_hi_val);
+	clk_alpha_pll_write_config(regmap, PLL_TEST_CTL_U1(pll),
+					config->test_ctl_hi1_val);
+
+	/* Disable PLL output */
+	regmap_update_bits(regmap, PLL_MODE(pll),  PLL_OUTCTRL, 0);
+
+	/* Set operation mode to OFF */
+	regmap_write(regmap, PLL_OPMODE(pll), PLL_STANDBY);
+
+	/* Place the PLL in STANDBY mode */
+	regmap_update_bits(regmap, PLL_MODE(pll), PLL_RESET_N, PLL_RESET_N);
+}
+EXPORT_SYMBOL_GPL(clk_lucid_5lpe_pll_configure);
+
 static int alpha_pll_lucid_5lpe_enable(struct clk_hw *hw)
 {
 	struct clk_alpha_pll *pll = to_clk_alpha_pll(hw);
diff --git a/drivers/clk/qcom/clk-alpha-pll.h b/drivers/clk/qcom/clk-alpha-pll.h
index 903fbab9b58e9..3fd0ef41c72c8 100644
--- a/drivers/clk/qcom/clk-alpha-pll.h
+++ b/drivers/clk/qcom/clk-alpha-pll.h
@@ -198,6 +198,8 @@ void clk_agera_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
 
 void clk_zonda_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
 			     const struct alpha_pll_config *config);
+void clk_lucid_5lpe_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
+				  const struct alpha_pll_config *config);
 void clk_lucid_evo_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
 				 const struct alpha_pll_config *config);
 void clk_rivian_evo_pll_configure(struct clk_alpha_pll *pll, struct regmap *regmap,
diff --git a/drivers/clk/qcom/dispcc-sm8250.c b/drivers/clk/qcom/dispcc-sm8250.c
index e17bb8b543b51..9a9e0852c91f2 100644
--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -1359,8 +1359,13 @@ static int disp_cc_sm8250_probe(struct platform_device *pdev)
 		disp_cc_sm8250_clocks[DISP_CC_MDSS_EDP_GTC_CLK_SRC] = NULL;
 	}
 
-	clk_lucid_pll_configure(&disp_cc_pll0, regmap, &disp_cc_pll0_config);
-	clk_lucid_pll_configure(&disp_cc_pll1, regmap, &disp_cc_pll1_config);
+	if (of_device_is_compatible(pdev->dev.of_node, "qcom,sm8350-dispcc")) {
+		clk_lucid_5lpe_pll_configure(&disp_cc_pll0, regmap, &disp_cc_pll0_config);
+		clk_lucid_5lpe_pll_configure(&disp_cc_pll1, regmap, &disp_cc_pll1_config);
+	} else {
+		clk_lucid_pll_configure(&disp_cc_pll0, regmap, &disp_cc_pll0_config);
+		clk_lucid_pll_configure(&disp_cc_pll1, regmap, &disp_cc_pll1_config);
+	}
 
 	/* Enable clock gating for MDP clocks */
 	regmap_update_bits(regmap, 0x8000, 0x10, 0x10);
-- 
2.43.0



