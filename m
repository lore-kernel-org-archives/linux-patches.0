Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629561078F;
	Tue, 30 Jul 2024 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356335; cv=none; b=qkd3d+9IDfIrLKZLW3FcwWYc7ISEgvb7frvrRdZTPTi1n1rFD7b4ZfclQgqNpxfxBY0A+umIzkLnBe+lqsO3/IWdGCYVbjq9MjyimZ4W+y01Q0ffun3xnq138ULRuEHdTZK0WsLrv4bbMhYsVF8W8P3Dfj8bHRoRX6p1G7jqSFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356335; c=relaxed/simple;
	bh=TzLkHvXXOhWG3NowSwydAbPLG8SuWkGwVx6mpFAs2Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjUT2CuulbMfJY04Nz3VgCPtpZ6600dIailpVSfDtc7R54tjOyMcnTZ60c/7QDk4BzKtaW5SED3isSzooin3KaBBHBP4SGNXn6S1lVFJ1yPk/vsRzGvJSnWlwFxgXOnvcJedk5+Th0TGzeIopJMYXUOlvm8vdyBJsdiFWFyPcoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyU7YhC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyU7YhC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6731C32782;
	Tue, 30 Jul 2024 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356335;
	bh=TzLkHvXXOhWG3NowSwydAbPLG8SuWkGwVx6mpFAs2Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyU7YhC48FK9UCeMoipRmZl48v5lbiwppqKidKyQQo+ZyzveS5s1PBat7MDmvX27Z
	 775a/zoD8PkBX381m32dUW5WXrHL4/KBdvKAc5F5Qoy6j+Joa5U53PUkhCkvzkoHLe
	 fqjzhZEmRfWu0USjgH4YWh4atgOWNKOVZh6b8uoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/440] clk: qcom: branch: Add helper functions for setting retain bits
Date: Tue, 30 Jul 2024 17:46:55 +0200
Message-ID: <20240730151622.983349216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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



