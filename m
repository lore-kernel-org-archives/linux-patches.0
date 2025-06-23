Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB5230BC2;
	Mon, 23 Jun 2025 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685364; cv=none; b=dmjGRoZhxWTyLwt4usaZ7lmkpw3RoDX8z2z5txPufu/DbQrTvLaybrl0ZiXgSWNcNbxnQ5q8YFnUApIpLQ8HQc6SHrZBudbKRJwqWVx14dLApZ0duE1fOwUaDy527TZsQR1DcLU9wOFFIq9JKjLS0xxJxaLntHDMm/6Kt20cv7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685364; c=relaxed/simple;
	bh=RV1ri2DnalP+VXGt58jfsRUO2PfINLpn/ql8D76hdq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUfQCko0/QljDpmtRx3Oxhe+hsNblz/CLKy+TWaK/DgLaZ3LXa3CKmnpQlLsBcZKwz7ncxS4RnbcGD5RZo+sFmp2DWYZJXi98reVy7+dJFb55q1ToWoYSGrmhn1RJ8Qqy41QdQcoQfeIXvirMSBlGdl79Fc3iAGNZ0F3BY23III=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W0hUU95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W0hUU95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8821C4CEEA;
	Mon, 23 Jun 2025 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685364;
	bh=RV1ri2DnalP+VXGt58jfsRUO2PfINLpn/ql8D76hdq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W0hUU95y1a13CwnCP+k2DTlQo40tg6Q8/eDhEMR3ZV6/01mNJsvHI1GZZkGC5/T7
	 yKTLW+X71mApcV4j1bXSgnNJ8QP0XrZzxTWgtyUY1/aNmvsou6tp3is6kKG0ruvMJ/
	 elmmJAmjkYXkcNr2IgonEvITDJ5rs7S21eIVMgCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hansen Dsouza <hansen.dsouza@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 234/592] drm/amd/display: disable DPP RCG before DPP CLK enable
Date: Mon, 23 Jun 2025 15:03:12 +0200
Message-ID: <20250623130705.857431228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 1bcd679209420305a86833bc357d50021909edaf ]

[why]
DPP CLK enable needs to disable DPPCLK RCG first.
The DPPCLK_en in dccg should always be enabled when the corresponding
pipe is enabled.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dccg/dcn35/dcn35_dccg.c    | 38 ++++++++++++-------
 .../amd/display/dc/hwss/dcn35/dcn35_hwseq.c   | 21 ++++++----
 2 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
index b363f5360818d..ad910065f463f 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
@@ -391,6 +391,7 @@ static void dccg35_set_dppclk_rcg(struct dccg *dccg,
 
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 
+
 	if (!dccg->ctx->dc->debug.root_clock_optimization.bits.dpp && enable)
 		return;
 
@@ -411,6 +412,8 @@ static void dccg35_set_dppclk_rcg(struct dccg *dccg,
 	BREAK_TO_DEBUGGER();
 		break;
 	}
+	//DC_LOG_DEBUG("%s: inst(%d) DPPCLK rcg_disable: %d\n", __func__, inst, enable ? 0 : 1);
+
 }
 
 static void dccg35_set_dpstreamclk_rcg(
@@ -1112,30 +1115,24 @@ static void dcn35_set_dppclk_enable(struct dccg *dccg,
 {
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 
+
 	switch (dpp_inst) {
 	case 0:
 		REG_UPDATE(DPPCLK_CTRL, DPPCLK0_EN, enable);
-		if (dccg->ctx->dc->debug.root_clock_optimization.bits.dpp)
-			REG_UPDATE(DCCG_GATE_DISABLE_CNTL6, DPPCLK0_ROOT_GATE_DISABLE, enable);
 		break;
 	case 1:
 		REG_UPDATE(DPPCLK_CTRL, DPPCLK1_EN, enable);
-		if (dccg->ctx->dc->debug.root_clock_optimization.bits.dpp)
-			REG_UPDATE(DCCG_GATE_DISABLE_CNTL6, DPPCLK1_ROOT_GATE_DISABLE, enable);
 		break;
 	case 2:
 		REG_UPDATE(DPPCLK_CTRL, DPPCLK2_EN, enable);
-		if (dccg->ctx->dc->debug.root_clock_optimization.bits.dpp)
-			REG_UPDATE(DCCG_GATE_DISABLE_CNTL6, DPPCLK2_ROOT_GATE_DISABLE, enable);
 		break;
 	case 3:
 		REG_UPDATE(DPPCLK_CTRL, DPPCLK3_EN, enable);
-		if (dccg->ctx->dc->debug.root_clock_optimization.bits.dpp)
-			REG_UPDATE(DCCG_GATE_DISABLE_CNTL6, DPPCLK3_ROOT_GATE_DISABLE, enable);
 		break;
 	default:
 		break;
 	}
+	//DC_LOG_DEBUG("%s: dpp_inst(%d) DPPCLK_EN = %d\n", __func__, dpp_inst, enable);
 
 }
 
@@ -1163,14 +1160,18 @@ static void dccg35_update_dpp_dto(struct dccg *dccg, int dpp_inst,
 			ASSERT(false);
 			phase = 0xff;
 		}
+		dccg35_set_dppclk_rcg(dccg, dpp_inst, false);
 
 		REG_SET_2(DPPCLK_DTO_PARAM[dpp_inst], 0,
 				DPPCLK0_DTO_PHASE, phase,
 				DPPCLK0_DTO_MODULO, modulo);
 
 		dcn35_set_dppclk_enable(dccg, dpp_inst, true);
-	} else
+	} else {
 		dcn35_set_dppclk_enable(dccg, dpp_inst, false);
+		/*we have this in hwss: disable_plane*/
+		//dccg35_set_dppclk_rcg(dccg, dpp_inst, true);
+	}
 	dccg->pipe_dppclk_khz[dpp_inst] = req_dppclk;
 }
 
@@ -1182,6 +1183,7 @@ static void dccg35_set_dppclk_root_clock_gating(struct dccg *dccg,
 	if (!dccg->ctx->dc->debug.root_clock_optimization.bits.dpp)
 		return;
 
+
 	switch (dpp_inst) {
 	case 0:
 		REG_UPDATE(DCCG_GATE_DISABLE_CNTL6, DPPCLK0_ROOT_GATE_DISABLE, enable);
@@ -1198,6 +1200,8 @@ static void dccg35_set_dppclk_root_clock_gating(struct dccg *dccg,
 	default:
 		break;
 	}
+	//DC_LOG_DEBUG("%s: dpp_inst(%d) rcg: %d\n", __func__, dpp_inst, enable);
+
 }
 
 static void dccg35_get_pixel_rate_div(
@@ -1521,28 +1525,30 @@ static void dccg35_set_physymclk_root_clock_gating(
 	switch (phy_inst) {
 	case 0:
 		REG_UPDATE(DCCG_GATE_DISABLE_CNTL2,
-				PHYASYMCLK_ROOT_GATE_DISABLE, enable ? 1 : 0);
+				PHYASYMCLK_ROOT_GATE_DISABLE, enable ? 0 : 1);
 		break;
 	case 1:
 		REG_UPDATE(DCCG_GATE_DISABLE_CNTL2,
-				PHYBSYMCLK_ROOT_GATE_DISABLE, enable ? 1 : 0);
+				PHYBSYMCLK_ROOT_GATE_DISABLE, enable ? 0 : 1);
 		break;
 	case 2:
 		REG_UPDATE(DCCG_GATE_DISABLE_CNTL2,
-				PHYCSYMCLK_ROOT_GATE_DISABLE, enable ? 1 : 0);
+				PHYCSYMCLK_ROOT_GATE_DISABLE, enable ? 0 : 1);
 		break;
 	case 3:
 		REG_UPDATE(DCCG_GATE_DISABLE_CNTL2,
-				PHYDSYMCLK_ROOT_GATE_DISABLE, enable ? 1 : 0);
+				PHYDSYMCLK_ROOT_GATE_DISABLE, enable ? 0 : 1);
 		break;
 	case 4:
 		REG_UPDATE(DCCG_GATE_DISABLE_CNTL2,
-				PHYESYMCLK_ROOT_GATE_DISABLE, enable ? 1 : 0);
+				PHYESYMCLK_ROOT_GATE_DISABLE, enable ? 0 : 1);
 		break;
 	default:
 		BREAK_TO_DEBUGGER();
 		return;
 	}
+	//DC_LOG_DEBUG("%s: dpp_inst(%d) PHYESYMCLK_ROOT_GATE_DISABLE:\n", __func__, phy_inst, enable ? 0 : 1);
+
 }
 
 static void dccg35_set_physymclk(
@@ -1643,6 +1649,8 @@ static void dccg35_dpp_root_clock_control(
 		return;
 
 	if (clock_on) {
+		dccg35_set_dppclk_rcg(dccg, dpp_inst, false);
+
 		/* turn off the DTO and leave phase/modulo at max */
 		dcn35_set_dppclk_enable(dccg, dpp_inst, 1);
 		REG_SET_2(DPPCLK_DTO_PARAM[dpp_inst], 0,
@@ -1654,6 +1662,8 @@ static void dccg35_dpp_root_clock_control(
 		REG_SET_2(DPPCLK_DTO_PARAM[dpp_inst], 0,
 			  DPPCLK0_DTO_PHASE, 0,
 			  DPPCLK0_DTO_MODULO, 1);
+		/*we have this in hwss: disable_plane*/
+		//dccg35_set_dppclk_rcg(dccg, dpp_inst, true);
 	}
 
 	dccg->dpp_clock_gated[dpp_inst] = !clock_on;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index 922b8d71cf1aa..63077c1fad859 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -241,11 +241,6 @@ void dcn35_init_hw(struct dc *dc)
 			dc->res_pool->hubbub->funcs->allow_self_refresh_control(dc->res_pool->hubbub,
 					!dc->res_pool->hubbub->ctx->dc->debug.disable_stutter);
 	}
-	if (res_pool->dccg->funcs->dccg_root_gate_disable_control) {
-		for (i = 0; i < res_pool->pipe_count; i++)
-			res_pool->dccg->funcs->dccg_root_gate_disable_control(res_pool->dccg, i, 0);
-	}
-
 	for (i = 0; i < res_pool->audio_count; i++) {
 		struct audio *audio = res_pool->audios[i];
 
@@ -901,12 +896,18 @@ void dcn35_init_pipes(struct dc *dc, struct dc_state *context)
 void dcn35_enable_plane(struct dc *dc, struct pipe_ctx *pipe_ctx,
 			       struct dc_state *context)
 {
+	struct dpp *dpp = pipe_ctx->plane_res.dpp;
+	struct dccg *dccg = dc->res_pool->dccg;
+
+
 	/* enable DCFCLK current DCHUB */
 	pipe_ctx->plane_res.hubp->funcs->hubp_clk_cntl(pipe_ctx->plane_res.hubp, true);
 
 	/* initialize HUBP on power up */
 	pipe_ctx->plane_res.hubp->funcs->hubp_init(pipe_ctx->plane_res.hubp);
-
+	/*make sure DPPCLK is on*/
+	dccg->funcs->dccg_root_gate_disable_control(dccg, dpp->inst, true);
+	dpp->funcs->dpp_dppclk_control(dpp, false, true);
 	/* make sure OPP_PIPE_CLOCK_EN = 1 */
 	pipe_ctx->stream_res.opp->funcs->opp_pipe_clock_control(
 			pipe_ctx->stream_res.opp,
@@ -923,6 +924,7 @@ void dcn35_enable_plane(struct dc *dc, struct pipe_ctx *pipe_ctx,
 		// Program system aperture settings
 		pipe_ctx->plane_res.hubp->funcs->hubp_set_vm_system_aperture_settings(pipe_ctx->plane_res.hubp, &apt);
 	}
+	//DC_LOG_DEBUG("%s: dpp_inst(%d) =\n", __func__, dpp->inst);
 
 	if (!pipe_ctx->top_pipe
 		&& pipe_ctx->plane_state
@@ -938,6 +940,8 @@ void dcn35_plane_atomic_disable(struct dc *dc, struct pipe_ctx *pipe_ctx)
 {
 	struct hubp *hubp = pipe_ctx->plane_res.hubp;
 	struct dpp *dpp = pipe_ctx->plane_res.dpp;
+	struct dccg *dccg = dc->res_pool->dccg;
+
 
 	dc->hwss.wait_for_mpcc_disconnect(dc, dc->res_pool, pipe_ctx);
 
@@ -955,7 +959,8 @@ void dcn35_plane_atomic_disable(struct dc *dc, struct pipe_ctx *pipe_ctx)
 	hubp->funcs->hubp_clk_cntl(hubp, false);
 
 	dpp->funcs->dpp_dppclk_control(dpp, false, false);
-/*to do, need to support both case*/
+	dccg->funcs->dccg_root_gate_disable_control(dccg, dpp->inst, false);
+
 	hubp->power_gated = true;
 
 	hubp->funcs->hubp_reset(hubp);
@@ -967,6 +972,8 @@ void dcn35_plane_atomic_disable(struct dc *dc, struct pipe_ctx *pipe_ctx)
 	pipe_ctx->top_pipe = NULL;
 	pipe_ctx->bottom_pipe = NULL;
 	pipe_ctx->plane_state = NULL;
+	//DC_LOG_DEBUG("%s: dpp_inst(%d)=\n", __func__, dpp->inst);
+
 }
 
 void dcn35_disable_plane(struct dc *dc, struct dc_state *state, struct pipe_ctx *pipe_ctx)
-- 
2.39.5



