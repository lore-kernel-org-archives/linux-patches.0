Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DCA1714D9;
	Thu, 15 Aug 2024 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729514; cv=none; b=qMrJ40s0GyB2LZf/0x1SDKY1xiYQo4WRWGtdFATzbhbjIh8pt0HgSgyNos5rpr+k1tY/v7W25fRLhakxr9wUOilaqUn5hor5o3xSDpqnKzfhT1ranYtVEsvD1f8X/7D/okvnCXIBemxLUYqocVZWrN12X2CvD45dGN5MfC15k0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729514; c=relaxed/simple;
	bh=NWLywo9x91e8HwQInpK/C/kxiXq0/fsDI3nGTGEBBM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGyRuAmDF30GaacFxo0RUvFx4xdMBZTTKE/XyCgUCq5h/Zkd2YvcoIb+qd2gkXyGXc7GHjyilzEM5EE5cnA3hUzrtxWrkvGF47nklnnrFm9NJZeaellgqw9hVCfsMdhEItbcW8gQ7KDISPhs5pbJwC79IymYI/rwmKF2k7iEnHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lw6cKtCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lw6cKtCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A078C32786;
	Thu, 15 Aug 2024 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729513;
	bh=NWLywo9x91e8HwQInpK/C/kxiXq0/fsDI3nGTGEBBM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lw6cKtCevaUM3iPYg4F72rSgHNlRtwvZADA5AQUOf34q9bNrCUHVVFP2yEp0UAPBG
	 RQPE5P3zDoTshV2SggXH6yHussKR+ss4DNd/lZeCbgS/walV2eqJRzTMI0H63w37S/
	 7wFKFrGct6LHbOO9IRG6FntnZC7aTli2k3QpaR9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/484] clk: qcom: branch: Add helper functions for setting retain bits
Date: Thu, 15 Aug 2024 15:19:39 +0200
Message-ID: <20240815131945.966551229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit b594e6f6605311785171b8d4600fe96e35625530 ]

Most Qualcomm branch clocks come with a pretty usual set of bits that
can enable memory retention by means of not turning off parts of the
memory logic. Add them to the common header file and introduce helper
functions for setting them instead of using magic writes.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230208091340.124641-2-konrad.dybcio@linaro.org
Stable-dep-of: f38467b5a920 ("clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-branch.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/clk/qcom/clk-branch.h b/drivers/clk/qcom/clk-branch.h
index 17a58119165e8..55b3a2c3afed9 100644
--- a/drivers/clk/qcom/clk-branch.h
+++ b/drivers/clk/qcom/clk-branch.h
@@ -37,6 +37,32 @@ struct clk_branch {
 	struct clk_regmap clkr;
 };
 
+/* Branch clock common bits for HLOS-owned clocks */
+#define CBCR_FORCE_MEM_CORE_ON		BIT(14)
+#define CBCR_FORCE_MEM_PERIPH_ON	BIT(13)
+#define CBCR_FORCE_MEM_PERIPH_OFF	BIT(12)
+
+static inline void qcom_branch_set_force_mem_core(struct regmap *regmap,
+						  struct clk_branch clk, bool on)
+{
+	regmap_update_bits(regmap, clk.halt_reg, CBCR_FORCE_MEM_CORE_ON,
+			   on ? CBCR_FORCE_MEM_CORE_ON : 0);
+}
+
+static inline void qcom_branch_set_force_periph_on(struct regmap *regmap,
+						   struct clk_branch clk, bool on)
+{
+	regmap_update_bits(regmap, clk.halt_reg, CBCR_FORCE_MEM_PERIPH_ON,
+			   on ? CBCR_FORCE_MEM_PERIPH_ON : 0);
+}
+
+static inline void qcom_branch_set_force_periph_off(struct regmap *regmap,
+						    struct clk_branch clk, bool on)
+{
+	regmap_update_bits(regmap, clk.halt_reg, CBCR_FORCE_MEM_PERIPH_OFF,
+			   on ? CBCR_FORCE_MEM_PERIPH_OFF : 0);
+}
+
 extern const struct clk_ops clk_branch_ops;
 extern const struct clk_ops clk_branch2_ops;
 extern const struct clk_ops clk_branch_simple_ops;
-- 
2.43.0



