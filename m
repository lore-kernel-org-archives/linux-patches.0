Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043D3290F;
	Mon,  2 Jun 2025 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875343; cv=none; b=U75b5kQErCcVLoIujbFjto8fjjImmFKVnoDInf3InncI+hHwrAjW7yIQPboDu28gbblUfP7O8wcjDKU5gF43S5KITemksQB0zCnaGegjAkdrPKzHEAflhu1wn2xDiqyO2MxLYF7zUKLXLvGCj2+amGHaQsZj8EIrN/CVRVxkVAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875343; c=relaxed/simple;
	bh=twrw+GdoYghFD8AdeaGemFhJoqLceregsuW7syqVX40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq/PINb8o50lr1OOdkHltQWk+H0LBT6lhOgDk8e39ykSBm9DoiOdmydqor4iPN8560QAbl/k3yAvT52rWgCSnq6vi1vP8VDjB9ljltECSkfwMW7+PsHa6fp8QlNaRvhsyH47no+i2kcNgPYUyeYMgR5oxXLOJjgCaT8xPj16d7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMX84r2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMX84r2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF26C4CEEB;
	Mon,  2 Jun 2025 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875342;
	bh=twrw+GdoYghFD8AdeaGemFhJoqLceregsuW7syqVX40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMX84r2aUk2gQnAsRUJ6EyzWmrU2Slyz+j863dvra7yhH006cdTjWJkmZSoqty4pF
	 dL7gbTNEuWC4/qahn4luBqrEszNYqSmAG28z2iHWeSNwUH6YJTQYiWFP+x71EWhjEu
	 Mgbksw3fmhpAlrRlcXU3IFK7p7WbCaLUjGEL2pNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 105/270] ASoC: q6afe-clocks: fix reprobing of the driver
Date: Mon,  2 Jun 2025 15:46:30 +0200
Message-ID: <20250602134311.525244023@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 96fadf7e8ff49fdb74754801228942b67c3eeebd upstream.

Q6afe-clocks driver can get reprobed. For example if the APR services
are restarted after the firmware crash. However currently Q6afe-clocks
driver will oops because hw.init will get cleared during first _probe
call. Rewrite the driver to fill the clock data at runtime rather than
using big static array of clocks.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Fixes: 520a1c396d19 ("ASoC: q6afe-clocks: add q6afe clock controller")
Link: https://lore.kernel.org/r/20210327092857.3073879-1-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[Minor context change fixed]
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6afe-clocks.c |  209 ++++++++++++++++++------------------
 sound/soc/qcom/qdsp6/q6afe.c        |    2 
 sound/soc/qcom/qdsp6/q6afe.h        |    2 
 3 files changed, 108 insertions(+), 105 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6afe-clocks.c
+++ b/sound/soc/qcom/qdsp6/q6afe-clocks.c
@@ -11,33 +11,29 @@
 #include <linux/slab.h>
 #include "q6afe.h"
 
-#define Q6AFE_CLK(id) &(struct q6afe_clk) {		\
+#define Q6AFE_CLK(id) {					\
 		.clk_id	= id,				\
 		.afe_clk_id	= Q6AFE_##id,		\
 		.name = #id,				\
-		.attributes = LPASS_CLK_ATTRIBUTE_COUPLE_NO, \
 		.rate = 19200000,			\
-		.hw.init = &(struct clk_init_data) {	\
-			.ops = &clk_q6afe_ops,		\
-			.name = #id,			\
-		},					\
 	}
 
-#define Q6AFE_VOTE_CLK(id, blkid, n) &(struct q6afe_clk) { \
+#define Q6AFE_VOTE_CLK(id, blkid, n) {			\
 		.clk_id	= id,				\
 		.afe_clk_id = blkid,			\
-		.name = #n,				\
-		.hw.init = &(struct clk_init_data) {	\
-			.ops = &clk_vote_q6afe_ops,	\
-			.name = #id,			\
-		},					\
+		.name = n,				\
 	}
 
-struct q6afe_clk {
-	struct device *dev;
+struct q6afe_clk_init {
 	int clk_id;
 	int afe_clk_id;
 	char *name;
+	int rate;
+};
+
+struct q6afe_clk {
+	struct device *dev;
+	int afe_clk_id;
 	int attributes;
 	int rate;
 	uint32_t handle;
@@ -48,8 +44,7 @@ struct q6afe_clk {
 
 struct q6afe_cc {
 	struct device *dev;
-	struct q6afe_clk **clks;
-	int num_clks;
+	struct q6afe_clk *clks[Q6AFE_MAX_CLK_ID];
 };
 
 static int clk_q6afe_prepare(struct clk_hw *hw)
@@ -105,7 +100,7 @@ static int clk_vote_q6afe_block(struct c
 	struct q6afe_clk *clk = to_q6afe_clk(hw);
 
 	return q6afe_vote_lpass_core_hw(clk->dev, clk->afe_clk_id,
-					clk->name, &clk->handle);
+					clk_hw_get_name(&clk->hw), &clk->handle);
 }
 
 static void clk_unvote_q6afe_block(struct clk_hw *hw)
@@ -120,84 +115,76 @@ static const struct clk_ops clk_vote_q6a
 	.unprepare	= clk_unvote_q6afe_block,
 };
 
-struct q6afe_clk *q6afe_clks[Q6AFE_MAX_CLK_ID] = {
-	[LPASS_CLK_ID_PRI_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_IBIT),
-	[LPASS_CLK_ID_PRI_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_EBIT),
-	[LPASS_CLK_ID_SEC_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_IBIT),
-	[LPASS_CLK_ID_SEC_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_EBIT),
-	[LPASS_CLK_ID_TER_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_IBIT),
-	[LPASS_CLK_ID_TER_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_EBIT),
-	[LPASS_CLK_ID_QUAD_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_IBIT),
-	[LPASS_CLK_ID_QUAD_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_EBIT),
-	[LPASS_CLK_ID_SPEAKER_I2S_IBIT] =
-				Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_IBIT),
-	[LPASS_CLK_ID_SPEAKER_I2S_EBIT] =
-				Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_EBIT),
-	[LPASS_CLK_ID_SPEAKER_I2S_OSR] =
-				Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_OSR),
-	[LPASS_CLK_ID_QUI_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_IBIT),
-	[LPASS_CLK_ID_QUI_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_EBIT),
-	[LPASS_CLK_ID_SEN_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_IBIT),
-	[LPASS_CLK_ID_SEN_MI2S_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_EBIT),
-	[LPASS_CLK_ID_INT0_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT0_MI2S_IBIT),
-	[LPASS_CLK_ID_INT1_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT1_MI2S_IBIT),
-	[LPASS_CLK_ID_INT2_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT2_MI2S_IBIT),
-	[LPASS_CLK_ID_INT3_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT3_MI2S_IBIT),
-	[LPASS_CLK_ID_INT4_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT4_MI2S_IBIT),
-	[LPASS_CLK_ID_INT5_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT5_MI2S_IBIT),
-	[LPASS_CLK_ID_INT6_MI2S_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_INT6_MI2S_IBIT),
-	[LPASS_CLK_ID_QUI_MI2S_OSR] = Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_OSR),
-	[LPASS_CLK_ID_PRI_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_IBIT),
-	[LPASS_CLK_ID_PRI_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_EBIT),
-	[LPASS_CLK_ID_SEC_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_IBIT),
-	[LPASS_CLK_ID_SEC_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_EBIT),
-	[LPASS_CLK_ID_TER_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_IBIT),
-	[LPASS_CLK_ID_TER_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_EBIT),
-	[LPASS_CLK_ID_QUAD_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_IBIT),
-	[LPASS_CLK_ID_QUAD_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_EBIT),
-	[LPASS_CLK_ID_QUIN_PCM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_IBIT),
-	[LPASS_CLK_ID_QUIN_PCM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_EBIT),
-	[LPASS_CLK_ID_QUI_PCM_OSR] = Q6AFE_CLK(LPASS_CLK_ID_QUI_PCM_OSR),
-	[LPASS_CLK_ID_PRI_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_IBIT),
-	[LPASS_CLK_ID_PRI_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_EBIT),
-	[LPASS_CLK_ID_SEC_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_IBIT),
-	[LPASS_CLK_ID_SEC_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_EBIT),
-	[LPASS_CLK_ID_TER_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_IBIT),
-	[LPASS_CLK_ID_TER_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_EBIT),
-	[LPASS_CLK_ID_QUAD_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_IBIT),
-	[LPASS_CLK_ID_QUAD_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_EBIT),
-	[LPASS_CLK_ID_QUIN_TDM_IBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_IBIT),
-	[LPASS_CLK_ID_QUIN_TDM_EBIT] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_EBIT),
-	[LPASS_CLK_ID_QUIN_TDM_OSR] = Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_OSR),
-	[LPASS_CLK_ID_MCLK_1] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_1),
-	[LPASS_CLK_ID_MCLK_2] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_2),
-	[LPASS_CLK_ID_MCLK_3] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_3),
-	[LPASS_CLK_ID_MCLK_4] = Q6AFE_CLK(LPASS_CLK_ID_MCLK_4),
-	[LPASS_CLK_ID_INTERNAL_DIGITAL_CODEC_CORE] =
-		Q6AFE_CLK(LPASS_CLK_ID_INTERNAL_DIGITAL_CODEC_CORE),
-	[LPASS_CLK_ID_INT_MCLK_0] = Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_0),
-	[LPASS_CLK_ID_INT_MCLK_1] = Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_1),
-	[LPASS_CLK_ID_WSA_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_MCLK),
-	[LPASS_CLK_ID_WSA_CORE_NPL_MCLK] =
-				Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_NPL_MCLK),
-	[LPASS_CLK_ID_VA_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_MCLK),
-	[LPASS_CLK_ID_TX_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_MCLK),
-	[LPASS_CLK_ID_TX_CORE_NPL_MCLK] =
-			Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_NPL_MCLK),
-	[LPASS_CLK_ID_RX_CORE_MCLK] = Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_MCLK),
-	[LPASS_CLK_ID_RX_CORE_NPL_MCLK] =
-				Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_NPL_MCLK),
-	[LPASS_CLK_ID_VA_CORE_2X_MCLK] =
-				Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_2X_MCLK),
-	[LPASS_HW_AVTIMER_VOTE] = Q6AFE_VOTE_CLK(LPASS_HW_AVTIMER_VOTE,
-						 Q6AFE_LPASS_CORE_AVTIMER_BLOCK,
-						 "LPASS_AVTIMER_MACRO"),
-	[LPASS_HW_MACRO_VOTE] = Q6AFE_VOTE_CLK(LPASS_HW_MACRO_VOTE,
-						Q6AFE_LPASS_CORE_HW_MACRO_BLOCK,
-						"LPASS_HW_MACRO"),
-	[LPASS_HW_DCODEC_VOTE] = Q6AFE_VOTE_CLK(LPASS_HW_DCODEC_VOTE,
-					Q6AFE_LPASS_CORE_HW_DCODEC_BLOCK,
-					"LPASS_HW_DCODEC"),
+static const struct q6afe_clk_init q6afe_clks[] = {
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SPEAKER_I2S_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEN_MI2S_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT0_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT1_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT2_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT3_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT4_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT5_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_INT6_MI2S_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_MI2S_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_PCM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUI_PCM_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_PRI_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_SEC_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_TER_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUAD_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_IBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_EBIT),
+	Q6AFE_CLK(LPASS_CLK_ID_QUIN_TDM_OSR),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_1),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_2),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_3),
+	Q6AFE_CLK(LPASS_CLK_ID_MCLK_4),
+	Q6AFE_CLK(LPASS_CLK_ID_INTERNAL_DIGITAL_CODEC_CORE),
+	Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_0),
+	Q6AFE_CLK(LPASS_CLK_ID_INT_MCLK_1),
+	Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_WSA_CORE_NPL_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_TX_CORE_NPL_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_RX_CORE_NPL_MCLK),
+	Q6AFE_CLK(LPASS_CLK_ID_VA_CORE_2X_MCLK),
+	Q6AFE_VOTE_CLK(LPASS_HW_AVTIMER_VOTE,
+		       Q6AFE_LPASS_CORE_AVTIMER_BLOCK,
+		       "LPASS_AVTIMER_MACRO"),
+	Q6AFE_VOTE_CLK(LPASS_HW_MACRO_VOTE,
+		       Q6AFE_LPASS_CORE_HW_MACRO_BLOCK,
+		       "LPASS_HW_MACRO"),
+	Q6AFE_VOTE_CLK(LPASS_HW_DCODEC_VOTE,
+		       Q6AFE_LPASS_CORE_HW_DCODEC_BLOCK,
+		       "LPASS_HW_DCODEC"),
 };
 
 static struct clk_hw *q6afe_of_clk_hw_get(struct of_phandle_args *clkspec,
@@ -207,7 +194,7 @@ static struct clk_hw *q6afe_of_clk_hw_ge
 	unsigned int idx = clkspec->args[0];
 	unsigned int attr = clkspec->args[1];
 
-	if (idx >= cc->num_clks || attr > LPASS_CLK_ATTRIBUTE_COUPLE_DIVISOR) {
+	if (idx >= Q6AFE_MAX_CLK_ID || attr > LPASS_CLK_ATTRIBUTE_COUPLE_DIVISOR) {
 		dev_err(cc->dev, "Invalid clk specifier (%d, %d)\n", idx, attr);
 		return ERR_PTR(-EINVAL);
 	}
@@ -230,20 +217,36 @@ static int q6afe_clock_dev_probe(struct
 	if (!cc)
 		return -ENOMEM;
 
-	cc->clks = &q6afe_clks[0];
-	cc->num_clks = ARRAY_SIZE(q6afe_clks);
+	cc->dev = dev;
 	for (i = 0; i < ARRAY_SIZE(q6afe_clks); i++) {
-		if (!q6afe_clks[i])
-			continue;
+		unsigned int id = q6afe_clks[i].clk_id;
+		struct clk_init_data init = {
+			.name =  q6afe_clks[i].name,
+		};
+		struct q6afe_clk *clk;
+
+		clk = devm_kzalloc(dev, sizeof(*clk), GFP_KERNEL);
+		if (!clk)
+			return -ENOMEM;
+
+		clk->dev = dev;
+		clk->afe_clk_id = q6afe_clks[i].afe_clk_id;
+		clk->rate = q6afe_clks[i].rate;
+		clk->hw.init = &init;
+
+		if (clk->rate)
+			init.ops = &clk_q6afe_ops;
+		else
+			init.ops = &clk_vote_q6afe_ops;
 
-		q6afe_clks[i]->dev = dev;
+		cc->clks[id] = clk;
 
-		ret = devm_clk_hw_register(dev, &q6afe_clks[i]->hw);
+		ret = devm_clk_hw_register(dev, &clk->hw);
 		if (ret)
 			return ret;
 	}
 
-	ret = of_clk_add_hw_provider(dev->of_node, q6afe_of_clk_hw_get, cc);
+	ret = devm_of_clk_add_hw_provider(dev, q6afe_of_clk_hw_get, cc);
 	if (ret)
 		return ret;
 
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -1681,7 +1681,7 @@ int q6afe_unvote_lpass_core_hw(struct de
 EXPORT_SYMBOL(q6afe_unvote_lpass_core_hw);
 
 int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
-			     char *client_name, uint32_t *client_handle)
+			     const char *client_name, uint32_t *client_handle)
 {
 	struct q6afe *afe = dev_get_drvdata(dev->parent);
 	struct afe_cmd_remote_lpass_core_hw_vote_request *vote_cfg;
--- a/sound/soc/qcom/qdsp6/q6afe.h
+++ b/sound/soc/qcom/qdsp6/q6afe.h
@@ -236,7 +236,7 @@ int q6afe_port_set_sysclk(struct q6afe_p
 int q6afe_set_lpass_clock(struct device *dev, int clk_id, int clk_src,
 			  int clk_root, unsigned int freq);
 int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
-			     char *client_name, uint32_t *client_handle);
+			     const char *client_name, uint32_t *client_handle);
 int q6afe_unvote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 			       uint32_t client_handle);
 #endif /* __Q6AFE_H__ */


