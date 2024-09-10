Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C41922D9;
	Tue, 10 Sep 2024 10:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964647; cv=none; b=F24fet8m6MkVwHbxCupb2TopHRWTxLi9ahZbmE37JOeRb3BwfOcmX07hXvyi/C0Xln0aiIg5SanJc7bY6CHPPCXv/V18sK11CAdE0Fl8gWcUvgq5hiHqQJ0CXu1dDV+arirJdKrY/9k0HY2Y0uHlJFiCb1q045iTxMlYc/Vj+y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964647; c=relaxed/simple;
	bh=kjCg/CEPRtiCMdh36O9fg/X9s1j0Hg4hQoWliciXzzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8In0/nhXGCe9td0zZ3D91xKFmTWIQ5HXfpu17/LC9xd3rGFt/+9BMPXx2FMqNjk9j16qxUstpGA80Hgg0zreeEXNnCBFTPc/V4VK/WFnw5q6W8FwkocBUOhnabzuxOeiADjPiYeFf+ZPLdYuA4S49rOc3f1d3hoCwr3BI+9pHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwkKuup5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwkKuup5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9EBC4CEC3;
	Tue, 10 Sep 2024 10:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964647;
	bh=kjCg/CEPRtiCMdh36O9fg/X9s1j0Hg4hQoWliciXzzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwkKuup5pHtKHX4KzFaKPckp2fXqvnAdNNmC5shjciR5vM+LiXvgBtrammIXvH+CR
	 JAB2kbWI+2xR2Lutcl9s6tZxzSY18GgiV6zFkzypR4abPpryAnr6E/BCjle9DjZohq
	 2RFA7H0fwou15qbL26JwFfhuDQSUU+a1bXq9DDII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Amit Pundir <amit.pundir@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/269] clk: qcom: gcc-sm8550: Dont park the USB RCG at registration time
Date: Tue, 10 Sep 2024 11:34:01 +0200
Message-ID: <20240910092616.853222874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 7b6dfa1bbe7f727315d2e05a2fc8e4cfeb779156 ]

Amit Pundir reports that audio and USB-C host mode stops working if the
gcc_usb30_prim_master_clk_src clk is registered and
clk_rcg2_shared_init() parks it on XO. Skip parking this clk at
registration time to fix those issues.

Partially revert commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
registration") by skipping the parking bit for this clk, but keep the
part where we cache the config register. That's still necessary to
figure out the true parent of the clk at registration time.

Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Fixes: 929c75d57566 ("clk: qcom: gcc-sm8550: Mark RCGs shared where applicable")
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20240819233628.2074654-3-swboyd@chromium.org
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg.h    |  1 +
 drivers/clk/qcom/clk-rcg2.c   | 30 ++++++++++++++++++++++++++++++
 drivers/clk/qcom/gcc-sm8550.c |  2 +-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
index e6d84c8c7989..84c497f361bc 100644
--- a/drivers/clk/qcom/clk-rcg.h
+++ b/drivers/clk/qcom/clk-rcg.h
@@ -176,6 +176,7 @@ extern const struct clk_ops clk_byte2_ops;
 extern const struct clk_ops clk_pixel_ops;
 extern const struct clk_ops clk_gfx3d_ops;
 extern const struct clk_ops clk_rcg2_shared_ops;
+extern const struct clk_ops clk_rcg2_shared_no_init_park_ops;
 extern const struct clk_ops clk_dp_ops;
 
 struct clk_rcg_dfs_data {
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index b9f2a29be927..461f54fe5e4f 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1182,6 +1182,36 @@ const struct clk_ops clk_rcg2_shared_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
 
+static int clk_rcg2_shared_no_init_park(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+
+	/*
+	 * Read the config register so that the parent is properly mapped at
+	 * registration time.
+	 */
+	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &rcg->parked_cfg);
+
+	return 0;
+}
+
+/*
+ * Like clk_rcg2_shared_ops but skip the init so that the clk frequency is left
+ * unchanged at registration time.
+ */
+const struct clk_ops clk_rcg2_shared_no_init_park_ops = {
+	.init = clk_rcg2_shared_no_init_park,
+	.enable = clk_rcg2_shared_enable,
+	.disable = clk_rcg2_shared_disable,
+	.get_parent = clk_rcg2_shared_get_parent,
+	.set_parent = clk_rcg2_shared_set_parent,
+	.recalc_rate = clk_rcg2_shared_recalc_rate,
+	.determine_rate = clk_rcg2_determine_rate,
+	.set_rate = clk_rcg2_shared_set_rate,
+	.set_rate_and_parent = clk_rcg2_shared_set_rate_and_parent,
+};
+EXPORT_SYMBOL_GPL(clk_rcg2_shared_no_init_park_ops);
+
 /* Common APIs to be used for DFS based RCGR */
 static void clk_rcg2_dfs_populate_freq(struct clk_hw *hw, unsigned int l,
 				       struct freq_tbl *f)
diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index bf7b7c5d4606..eb3765c57b65 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -1159,7 +1159,7 @@ static struct clk_rcg2 gcc_usb30_prim_master_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.43.0



