Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D56C301022;
	Sat, 25 Oct 2025 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409101; cv=none; b=FS4eVlk07/C/SNQgdiMTSCjmmFRi+rCvJIZur7vpaA51BlQQzrnXT14j7TQMbqjlDc48cUM+hl6KjLKQKPZsyvHazYBqy7DgVbKZTujnH9DZ5EsL+erOmzq4xJq/u0KMICk1izflvpIOI6dVP+rbZLSLDpjy3/Plh0dHyO8xefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409101; c=relaxed/simple;
	bh=e8Nq4BtWHfgOs12TuGSdxe2W+AHWwicaXkE4GoHLI4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4I9OSEKchbfR+Yvos0DFi0vh+DEXQpMvU8XxeVMRmFh4YkGtI0yObqsPM5lU2pmQFfPB9DJzXoCGbpKp7acchVEDA+m162EBA8eZ/2t0LGzWMhAl1al1HSjyyoYr7GowlEWwIvEDRypKaJUvPUFwFbt9dnpRiioF/TYBgUZgrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJ3ATytz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJ3ATytz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05127C4CEF5;
	Sat, 25 Oct 2025 16:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409101;
	bh=e8Nq4BtWHfgOs12TuGSdxe2W+AHWwicaXkE4GoHLI4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJ3ATytz/TczpNzDITux3tRJwoPCchRdy+Tr5SL2Lj/0154FTGvbTltViu45pmXAf
	 CwL729yXH60OUSaFPDGYol9n5Z0zRCHkKudzjnQ374OqioULA5NFwZjsRPIm/2HFKT
	 PJ/l7QXO21uhns0lqiDlrzCFj1YnCqR2oA5FSssABVHlrCd3yUTSEOOfXraagJBfz7
	 7e/h7slU8d27eS+RSFrEHqOfPXO7GMFDybdfHG+1CU8QdjOvgKJj8CfM+Rhyp8p9+n
	 zMVUK6h/aq/jomIGH2oVrbQESkFETCctS3bd152tXRuAmz/DeoCv8E+mOnEnWrJEGn
	 yuyxYGS8LeKtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lo-an Chen <lo-an.chen@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alvin.lee2@amd.com,
	ray.wu@amd.com,
	alexandre.f.demers@gmail.com,
	Wesley.Chalmers@amd.com,
	lohita.mudimela@amd.com,
	alex.hung@amd.com,
	dillon.varone@amd.com,
	nicholas.kazlauskas@amd.com,
	PeiChen.Huang@amd.com,
	Emily.Nie@amd.com,
	yan.li@amd.com,
	ryanseto@amd.com,
	linux@treblig.org,
	ethan@ethancedwards.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Init dispclk from bootup clock for DCN314
Date: Sat, 25 Oct 2025 11:57:12 -0400
Message-ID: <20251025160905.3857885-201-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lo-an Chen <lo-an.chen@amd.com>

[ Upstream commit f082daf08f2ff313bdf9cf929a28f6d888117986 ]

[Why]
Driver does not pick up and save vbios's clocks during init clocks,
the dispclk in clk_mgr will keep 0 until the first update clocks.
In some cases, OS changes the timing in the second set mode
(lower the pixel clock), causing the driver to lower the dispclk
in prepare bandwidth, which is illegal and causes grey screen.

[How]
1. Dump and save the vbios's clocks, and init the dispclk in
dcn314_init_clocks.
2. Fix the condition in dcn314_update_clocks, regarding a 0kHz value.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Lo-an Chen <lo-an.chen@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- dc/clk_mgr now snapshots the firmware-provided clocks during bring-up
  and seeds the manager’s state with that value, so `dispclk` no longer
  sits at 0 until the first SMU transaction (`drivers/gpu/drm/amd/displa
  y/dc/clk_mgr/dcn314/dcn314_clk_mgr.c:247-270`). That directly
  addresses the grey-screen failure seen when the OS lowers pixel clock
  before the driver programs a valid baseline clock.
- The new `dcn314_dump_clk_registers()` implementation reads the DCN314
  clock counters and bypass selectors from hardware and populates
  `boot_snapshot` (`dcn314_clk_mgr.c:466-523`). This mirrors what newer
  ASIC backends already do and gives the init path trustworthy data
  without changing behaviour elsewhere.
- Clock updates now refuse to program a 0 kHz display clock unless we
  are safely power-gating with no active displays
  (`dcn314_clk_mgr.c:289` and `365-381`). Combined with the seeded
  baseline clock, this stops illegal downclocks that triggered the grey
  screens.
- Setting the default minimum dispclk to 100 MHz for this ASIC (`drivers
  /gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c:930`)
  ensures the SMU clamp takes effect even before debug knobs are
  touched.
- The patch is tightly scoped to the DCN314 clock manager/resource code,
  follows existing patterns used by other DCN3.x platforms, and only
  performs register reads plus conditional guards—low regression risk
  with a clear correctness fix, making it a good stable backport
  candidate.

 .../dc/clk_mgr/dcn314/dcn314_clk_mgr.c        | 142 +++++++++++++++++-
 .../dc/clk_mgr/dcn314/dcn314_clk_mgr.h        |   5 +
 .../dc/resource/dcn314/dcn314_resource.c      |   1 +
 3 files changed, 143 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
index 91d872d6d392b..bc2ad0051b35b 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -77,6 +77,7 @@ static const struct IP_BASE CLK_BASE = { { { { 0x00016C00, 0x02401800, 0, 0, 0,
 #undef DC_LOGGER
 #define DC_LOGGER \
 	clk_mgr->base.base.ctx->logger
+
 #define regCLK1_CLK_PLL_REQ			0x0237
 #define regCLK1_CLK_PLL_REQ_BASE_IDX		0
 
@@ -87,8 +88,70 @@ static const struct IP_BASE CLK_BASE = { { { { 0x00016C00, 0x02401800, 0, 0, 0,
 #define CLK1_CLK_PLL_REQ__PllSpineDiv_MASK	0x0000F000L
 #define CLK1_CLK_PLL_REQ__FbMult_frac_MASK	0xFFFF0000L
 
+#define regCLK1_CLK0_DFS_CNTL				0x0269
+#define regCLK1_CLK0_DFS_CNTL_BASE_IDX		0
+#define regCLK1_CLK1_DFS_CNTL				0x026c
+#define regCLK1_CLK1_DFS_CNTL_BASE_IDX		0
+#define regCLK1_CLK2_DFS_CNTL				0x026f
+#define regCLK1_CLK2_DFS_CNTL_BASE_IDX		0
+#define regCLK1_CLK3_DFS_CNTL				0x0272
+#define regCLK1_CLK3_DFS_CNTL_BASE_IDX		0
+#define regCLK1_CLK4_DFS_CNTL				0x0275
+#define regCLK1_CLK4_DFS_CNTL_BASE_IDX		0
+#define regCLK1_CLK5_DFS_CNTL				0x0278
+#define regCLK1_CLK5_DFS_CNTL_BASE_IDX		0
+
+#define regCLK1_CLK0_CURRENT_CNT			0x02fb
+#define regCLK1_CLK0_CURRENT_CNT_BASE_IDX	0
+#define regCLK1_CLK1_CURRENT_CNT			0x02fc
+#define regCLK1_CLK1_CURRENT_CNT_BASE_IDX	0
+#define regCLK1_CLK2_CURRENT_CNT			0x02fd
+#define regCLK1_CLK2_CURRENT_CNT_BASE_IDX	0
+#define regCLK1_CLK3_CURRENT_CNT			0x02fe
+#define regCLK1_CLK3_CURRENT_CNT_BASE_IDX	0
+#define regCLK1_CLK4_CURRENT_CNT			0x02ff
+#define regCLK1_CLK4_CURRENT_CNT_BASE_IDX	0
+#define regCLK1_CLK5_CURRENT_CNT			0x0300
+#define regCLK1_CLK5_CURRENT_CNT_BASE_IDX	0
+
+#define regCLK1_CLK0_BYPASS_CNTL			0x028a
+#define regCLK1_CLK0_BYPASS_CNTL_BASE_IDX	0
+#define regCLK1_CLK1_BYPASS_CNTL			0x0293
+#define regCLK1_CLK1_BYPASS_CNTL_BASE_IDX	0
 #define regCLK1_CLK2_BYPASS_CNTL			0x029c
 #define regCLK1_CLK2_BYPASS_CNTL_BASE_IDX	0
+#define regCLK1_CLK3_BYPASS_CNTL			0x02a5
+#define regCLK1_CLK3_BYPASS_CNTL_BASE_IDX	0
+#define regCLK1_CLK4_BYPASS_CNTL			0x02ae
+#define regCLK1_CLK4_BYPASS_CNTL_BASE_IDX	0
+#define regCLK1_CLK5_BYPASS_CNTL			0x02b7
+#define regCLK1_CLK5_BYPASS_CNTL_BASE_IDX	0
+
+#define regCLK1_CLK0_DS_CNTL				0x0283
+#define regCLK1_CLK0_DS_CNTL_BASE_IDX		0
+#define regCLK1_CLK1_DS_CNTL				0x028c
+#define regCLK1_CLK1_DS_CNTL_BASE_IDX		0
+#define regCLK1_CLK2_DS_CNTL				0x0295
+#define regCLK1_CLK2_DS_CNTL_BASE_IDX		0
+#define regCLK1_CLK3_DS_CNTL				0x029e
+#define regCLK1_CLK3_DS_CNTL_BASE_IDX		0
+#define regCLK1_CLK4_DS_CNTL				0x02a7
+#define regCLK1_CLK4_DS_CNTL_BASE_IDX		0
+#define regCLK1_CLK5_DS_CNTL				0x02b0
+#define regCLK1_CLK5_DS_CNTL_BASE_IDX		0
+
+#define regCLK1_CLK0_ALLOW_DS				0x0284
+#define regCLK1_CLK0_ALLOW_DS_BASE_IDX		0
+#define regCLK1_CLK1_ALLOW_DS				0x028d
+#define regCLK1_CLK1_ALLOW_DS_BASE_IDX		0
+#define regCLK1_CLK2_ALLOW_DS				0x0296
+#define regCLK1_CLK2_ALLOW_DS_BASE_IDX		0
+#define regCLK1_CLK3_ALLOW_DS				0x029f
+#define regCLK1_CLK3_ALLOW_DS_BASE_IDX		0
+#define regCLK1_CLK4_ALLOW_DS				0x02a8
+#define regCLK1_CLK4_ALLOW_DS_BASE_IDX		0
+#define regCLK1_CLK5_ALLOW_DS				0x02b1
+#define regCLK1_CLK5_ALLOW_DS_BASE_IDX		0
 
 #define CLK1_CLK2_BYPASS_CNTL__CLK2_BYPASS_SEL__SHIFT	0x0
 #define CLK1_CLK2_BYPASS_CNTL__CLK2_BYPASS_DIV__SHIFT	0x10
@@ -185,6 +248,8 @@ void dcn314_init_clocks(struct clk_mgr *clk_mgr)
 {
 	struct clk_mgr_internal *clk_mgr_int = TO_CLK_MGR_INTERNAL(clk_mgr);
 	uint32_t ref_dtbclk = clk_mgr->clks.ref_dtbclk_khz;
+	struct clk_mgr_dcn314 *clk_mgr_dcn314 = TO_CLK_MGR_DCN314(clk_mgr_int);
+	struct clk_log_info log_info = {0};
 
 	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
 	// Assumption is that boot state always supports pstate
@@ -200,6 +265,9 @@ void dcn314_init_clocks(struct clk_mgr *clk_mgr)
 			dce_adjust_dp_ref_freq_for_ss(clk_mgr_int, clk_mgr->dprefclk_khz);
 	else
 		clk_mgr->dp_dto_source_clock_in_khz = clk_mgr->dprefclk_khz;
+
+	dcn314_dump_clk_registers(&clk_mgr->boot_snapshot, &clk_mgr_dcn314->base.base, &log_info);
+	clk_mgr->clks.dispclk_khz =  clk_mgr->boot_snapshot.dispclk * 1000;
 }
 
 void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
@@ -218,6 +286,8 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 	if (dc->work_arounds.skip_clock_update)
 		return;
 
+	display_count = dcn314_get_active_display_cnt_wa(dc, context);
+
 	/*
 	 * if it is safe to lower, but we are already in the lower state, we don't have to do anything
 	 * also if safe to lower is false, we just go in the higher state
@@ -236,7 +306,6 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 		}
 		/* check that we're not already in lower */
 		if (clk_mgr_base->clks.pwr_state != DCN_PWR_STATE_LOW_POWER) {
-			display_count = dcn314_get_active_display_cnt_wa(dc, context);
 			/* if we can go lower, go lower */
 			if (display_count == 0) {
 				union display_idle_optimization_u idle_info = { 0 };
@@ -293,11 +362,19 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 		update_dppclk = true;
 	}
 
-	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)) {
+	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) &&
+	    (new_clocks->dispclk_khz > 0 || (safe_to_lower && display_count == 0))) {
+		int requested_dispclk_khz = new_clocks->dispclk_khz;
+
 		dcn314_disable_otg_wa(clk_mgr_base, context, safe_to_lower, true);
 
+		/* Clamp the requested clock to PMFW based on their limit. */
+		if (dc->debug.min_disp_clk_khz > 0 && requested_dispclk_khz < dc->debug.min_disp_clk_khz)
+			requested_dispclk_khz = dc->debug.min_disp_clk_khz;
+
+		dcn314_smu_set_dispclk(clk_mgr, requested_dispclk_khz);
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
-		dcn314_smu_set_dispclk(clk_mgr, clk_mgr_base->clks.dispclk_khz);
+
 		dcn314_disable_otg_wa(clk_mgr_base, context, safe_to_lower, false);
 
 		update_dispclk = true;
@@ -385,10 +462,65 @@ bool dcn314_are_clock_states_equal(struct dc_clocks *a,
 	return true;
 }
 
-static void dcn314_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
+
+static void dcn314_dump_clk_registers_internal(struct dcn35_clk_internal *internal, struct clk_mgr *clk_mgr_base)
+{
+	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
+
+	// read dtbclk
+	internal->CLK1_CLK4_CURRENT_CNT = REG_READ(CLK1_CLK4_CURRENT_CNT);
+	internal->CLK1_CLK4_BYPASS_CNTL = REG_READ(CLK1_CLK4_BYPASS_CNTL);
+
+	// read dcfclk
+	internal->CLK1_CLK3_CURRENT_CNT = REG_READ(CLK1_CLK3_CURRENT_CNT);
+	internal->CLK1_CLK3_BYPASS_CNTL = REG_READ(CLK1_CLK3_BYPASS_CNTL);
+
+	// read dcf deep sleep divider
+	internal->CLK1_CLK3_DS_CNTL = REG_READ(CLK1_CLK3_DS_CNTL);
+	internal->CLK1_CLK3_ALLOW_DS = REG_READ(CLK1_CLK3_ALLOW_DS);
+
+	// read dppclk
+	internal->CLK1_CLK1_CURRENT_CNT = REG_READ(CLK1_CLK1_CURRENT_CNT);
+	internal->CLK1_CLK1_BYPASS_CNTL = REG_READ(CLK1_CLK1_BYPASS_CNTL);
+
+	// read dprefclk
+	internal->CLK1_CLK2_CURRENT_CNT = REG_READ(CLK1_CLK2_CURRENT_CNT);
+	internal->CLK1_CLK2_BYPASS_CNTL = REG_READ(CLK1_CLK2_BYPASS_CNTL);
+
+	// read dispclk
+	internal->CLK1_CLK0_CURRENT_CNT = REG_READ(CLK1_CLK0_CURRENT_CNT);
+	internal->CLK1_CLK0_BYPASS_CNTL = REG_READ(CLK1_CLK0_BYPASS_CNTL);
+}
+
+void dcn314_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
 		struct clk_mgr *clk_mgr_base, struct clk_log_info *log_info)
 {
-	return;
+
+	struct dcn35_clk_internal internal = {0};
+
+	dcn314_dump_clk_registers_internal(&internal, clk_mgr_base);
+
+	regs_and_bypass->dcfclk = internal.CLK1_CLK3_CURRENT_CNT / 10;
+	regs_and_bypass->dcf_deep_sleep_divider = internal.CLK1_CLK3_DS_CNTL / 10;
+	regs_and_bypass->dcf_deep_sleep_allow = internal.CLK1_CLK3_ALLOW_DS;
+	regs_and_bypass->dprefclk = internal.CLK1_CLK2_CURRENT_CNT / 10;
+	regs_and_bypass->dispclk = internal.CLK1_CLK0_CURRENT_CNT / 10;
+	regs_and_bypass->dppclk = internal.CLK1_CLK1_CURRENT_CNT / 10;
+	regs_and_bypass->dtbclk = internal.CLK1_CLK4_CURRENT_CNT / 10;
+
+	regs_and_bypass->dppclk_bypass = internal.CLK1_CLK1_BYPASS_CNTL & 0x0007;
+	if (regs_and_bypass->dppclk_bypass < 0 || regs_and_bypass->dppclk_bypass > 4)
+		regs_and_bypass->dppclk_bypass = 0;
+	regs_and_bypass->dcfclk_bypass = internal.CLK1_CLK3_BYPASS_CNTL & 0x0007;
+	if (regs_and_bypass->dcfclk_bypass < 0 || regs_and_bypass->dcfclk_bypass > 4)
+		regs_and_bypass->dcfclk_bypass = 0;
+	regs_and_bypass->dispclk_bypass = internal.CLK1_CLK0_BYPASS_CNTL & 0x0007;
+	if (regs_and_bypass->dispclk_bypass < 0 || regs_and_bypass->dispclk_bypass > 4)
+		regs_and_bypass->dispclk_bypass = 0;
+	regs_and_bypass->dprefclk_bypass = internal.CLK1_CLK2_BYPASS_CNTL & 0x0007;
+	if (regs_and_bypass->dprefclk_bypass < 0 || regs_and_bypass->dprefclk_bypass > 4)
+		regs_and_bypass->dprefclk_bypass = 0;
+
 }
 
 static struct clk_bw_params dcn314_bw_params = {
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h
index 002c28e807208..0577eb527bc36 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h
@@ -65,4 +65,9 @@ void dcn314_clk_mgr_construct(struct dc_context *ctx,
 
 void dcn314_clk_mgr_destroy(struct clk_mgr_internal *clk_mgr_int);
 
+
+void dcn314_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
+		struct clk_mgr *clk_mgr_base, struct clk_log_info *log_info);
+
+
 #endif //__DCN314_CLK_MGR_H__
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
index 663c49cce4aa3..d4917a35b991a 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -927,6 +927,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.enable_legacy_fast_update = true,
 	.using_dml2 = false,
 	.disable_dsc_power_gate = true,
+	.min_disp_clk_khz = 100000,
 };
 
 static const struct dc_panel_config panel_config_defaults = {
-- 
2.51.0

