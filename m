Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA3CC433C8;
	Mon, 11 Sep 2023 14:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443528;
	bh=jDImVAU/nv1piEZKzyTD86ThHmMxpeCmYvX+aW+7/9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjQkfmcKHLc4ucX7yaPWn78D3x2084UQpw37mqw/zgHOo4KAXC+vPRyU2Xqv/GNiN
	 zQdKlqlqaxygnC9ySUrIWbxja+oXVzFtCzuw3nwBlfsfhMRzvCOasGsZncpsPu3SC6
	 qUrcggkE4jWZQLG857CbuqYgeYckcA475/UCGuwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 409/737] clk: qcom: gpucc-sm6350: Introduce index-based clk lookup
Date: Mon, 11 Sep 2023 15:44:28 +0200
Message-ID: <20230911134702.047697988@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit f6f89d194e4ddcfe197ac8a05ed4161f642a5c68 ]

Add the nowadays-prefered and marginally faster way of looking up parent
clocks in the device tree. It also allows for clock-names-independent
operation, so long as the order (which is enforced by schema) is kept.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230315-topic-lagoon_gpu-v2-1-afcdfb18bb13@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 743913b343a3 ("clk: qcom: gpucc-sm6350: Fix clock source names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sm6350.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sm6350.c b/drivers/clk/qcom/gpucc-sm6350.c
index ef15185a99c31..a9887d1f0ed71 100644
--- a/drivers/clk/qcom/gpucc-sm6350.c
+++ b/drivers/clk/qcom/gpucc-sm6350.c
@@ -24,6 +24,12 @@
 #define CX_GMU_CBCR_WAKE_MASK		0xF
 #define CX_GMU_CBCR_WAKE_SHIFT		8
 
+enum {
+	DT_BI_TCXO,
+	DT_GPLL0_OUT_MAIN,
+	DT_GPLL0_OUT_MAIN_DIV,
+};
+
 enum {
 	P_BI_TCXO,
 	P_GPLL0_OUT_MAIN,
@@ -61,6 +67,7 @@ static struct clk_alpha_pll gpu_cc_pll0 = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gpu_cc_pll0",
 			.parent_data =  &(const struct clk_parent_data){
+				.index = DT_BI_TCXO,
 				.fw_name = "bi_tcxo",
 			},
 			.num_parents = 1,
@@ -104,6 +111,7 @@ static struct clk_alpha_pll gpu_cc_pll1 = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gpu_cc_pll1",
 			.parent_data =  &(const struct clk_parent_data){
+				.index = DT_BI_TCXO,
 				.fw_name = "bi_tcxo",
 			},
 			.num_parents = 1,
@@ -121,11 +129,11 @@ static const struct parent_map gpu_cc_parent_map_0[] = {
 };
 
 static const struct clk_parent_data gpu_cc_parent_data_0[] = {
-	{ .fw_name = "bi_tcxo" },
+	{ .index = DT_BI_TCXO, .fw_name = "bi_tcxo" },
 	{ .hw = &gpu_cc_pll0.clkr.hw },
 	{ .hw = &gpu_cc_pll1.clkr.hw },
-	{ .fw_name = "gcc_gpu_gpll0_clk" },
-	{ .fw_name = "gcc_gpu_gpll0_div_clk" },
+	{ .index = DT_GPLL0_OUT_MAIN, .fw_name = "gcc_gpu_gpll0_clk" },
+	{ .index = DT_GPLL0_OUT_MAIN_DIV, .fw_name = "gcc_gpu_gpll0_div_clk" },
 };
 
 static const struct parent_map gpu_cc_parent_map_1[] = {
@@ -138,12 +146,12 @@ static const struct parent_map gpu_cc_parent_map_1[] = {
 };
 
 static const struct clk_parent_data gpu_cc_parent_data_1[] = {
-	{ .fw_name = "bi_tcxo" },
+	{ .index = DT_BI_TCXO, .fw_name = "bi_tcxo" },
 	{ .hw = &crc_div.hw },
 	{ .hw = &gpu_cc_pll0.clkr.hw },
 	{ .hw = &gpu_cc_pll1.clkr.hw },
 	{ .hw = &gpu_cc_pll1.clkr.hw },
-	{ .fw_name = "gcc_gpu_gpll0_clk" },
+	{ .index = DT_GPLL0_OUT_MAIN, .fw_name = "gcc_gpu_gpll0_clk" },
 };
 
 static const struct freq_tbl ftbl_gpu_cc_gmu_clk_src[] = {
-- 
2.40.1



