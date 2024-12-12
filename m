Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E244748A;
	Thu, 12 Dec 2024 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017288; cv=none; b=nRk8SVQmBZHZexpvRl+1cAeNURTbZkfe2O2jpdcL43z5+1W7ZaltW0b+saf+sMCTpQS8LYG/bTttkbRif3oL41DjfRQ2ayUxhtgt0Zv7ntquaBOz9CLPz/iyLkPTE6k80KJmpYEMXX7Op3AE5sM4iPu0Wx+MUM2YUzm8cYMa89s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017288; c=relaxed/simple;
	bh=o2YQ1BEBRm60sOhcOzB6iHVF47GXYVBStDHtGlByxIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/vUbq2dj3gnKpR5I3z/gfGqDYAh5IK8gn1dB1SS7AWnMVMSx2h+C5DDCnFbb8vIZaLfqPdrhSLdJloEeMLyxrjh57qPy1CONva9xONmNZAG9UlEnflinA3P8cJeHudmwg4Kq+pMYlSYmO9ZjrIUpYzmHxA48UTGoWeqAm8qwvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1lQ9NJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1lQ9NJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11519C4CECE;
	Thu, 12 Dec 2024 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017288;
	bh=o2YQ1BEBRm60sOhcOzB6iHVF47GXYVBStDHtGlByxIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1lQ9NJX8kSL8Um9Xh2ZeXzAgTNnqvceUAzdWA+7KqxxY2bkb5JUJ4NIzh+4koOvW
	 5ezkImq4H7tnwbf5buQeE4BOeWbLullBUUuiaoJ3q5ba4ZMFpCH2cGbQXxhQtHxGVN
	 DHdLLtsHZY5wIWbLzHlLZAlOCxK5ozd8o9Y3ScX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/466] drm/amd/display: Update Interface to Check UCLK DPM
Date: Thu, 12 Dec 2024 16:00:06 +0100
Message-ID: <20241212144324.128679509@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit b8d046985c2dc41a0e264a391da4606099f8d44f ]

[Why]
Videos using YUV420 format may result in high power being used.
Disabling MPO may result in lower power usage.
Update interface that can be used to check power profile of a dc_state.

[How]
Allow pstate switching in VBlank as last entry in strategy candidates.
Add helper functions that can be used to determine power level:
-get power profile after a dc_state has undergone full validation

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6a7fd76b949e ("drm/amd/display: Add option to retrieve detile buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c        |  9 ++++++++-
 .../dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c    |  1 +
 drivers/gpu/drm/amd/display/dc/inc/core_types.h |  4 ++++
 .../dc/resource/dcn315/dcn315_resource.c        |  6 ++++++
 .../dc/resource/dcn401/dcn401_resource.c        | 17 +++++++++++++++++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index a6911bb2cf0c6..1d99ab233765f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -6001,8 +6001,15 @@ void dc_set_edp_power(const struct dc *dc, struct dc_link *edp_link,
 struct dc_power_profile dc_get_power_profile_for_dc_state(const struct dc_state *context)
 {
 	struct dc_power_profile profile = { 0 };
+	struct dc *dc = NULL;
 
-	profile.power_level += !context->bw_ctx.bw.dcn.clk.p_state_change_support;
+	if (!context || !context->clk_mgr || !context->clk_mgr->ctx || !context->clk_mgr->ctx->dc)
+		return profile;
+
+	dc = context->clk_mgr->ctx->dc;
+
+	if (dc->res_pool->funcs->get_power_profile)
+		profile.power_level = dc->res_pool->funcs->get_power_profile(context);
 
 	return profile;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
index dd9971867f749..720ecede3a4c0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
@@ -1799,6 +1799,7 @@ bool pmo_dcn4_fams2_init_for_pstate_support(struct dml2_pmo_init_for_pstate_supp
 	}
 
 	if (s->pmo_dcn4.num_pstate_candidates > 0) {
+		s->pmo_dcn4.pstate_strategy_candidates[s->pmo_dcn4.num_pstate_candidates-1].allow_state_increase = true;
 		s->pmo_dcn4.cur_pstate_candidate = -1;
 		return true;
 	} else {
diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index bfb8b8502d202..8597e866bfe6b 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -215,6 +215,10 @@ struct resource_funcs {
 
 	void (*get_panel_config_defaults)(struct dc_panel_config *panel_config);
 	void (*build_pipe_pix_clk_params)(struct pipe_ctx *pipe_ctx);
+	/*
+	 * Get indicator of power from a context that went through full validation
+	 */
+	int (*get_power_profile)(const struct dc_state *context);
 };
 
 struct audio_support{
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
index 3f4b9dba41124..f6b840f046a5d 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
@@ -1812,6 +1812,11 @@ static void dcn315_get_panel_config_defaults(struct dc_panel_config *panel_confi
 	*panel_config = panel_config_defaults;
 }
 
+static int dcn315_get_power_profile(const struct dc_state *context)
+{
+	return !context->bw_ctx.bw.dcn.clk.p_state_change_support;
+}
+
 static struct dc_cap_funcs cap_funcs = {
 	.get_dcc_compression_cap = dcn20_get_dcc_compression_cap
 };
@@ -1840,6 +1845,7 @@ static struct resource_funcs dcn315_res_pool_funcs = {
 	.update_bw_bounding_box = dcn315_update_bw_bounding_box,
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn315_get_panel_config_defaults,
+	.get_power_profile = dcn315_get_power_profile,
 };
 
 static bool dcn315_resource_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
index 4aa975418fb18..6bcc6c400b386 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
@@ -1688,6 +1688,22 @@ static void dcn401_build_pipe_pix_clk_params(struct pipe_ctx *pipe_ctx)
 	}
 }
 
+static int dcn401_get_power_profile(const struct dc_state *context)
+{
+	int uclk_mhz = context->bw_ctx.bw.dcn.clk.dramclk_khz / 1000;
+	int dpm_level = 0;
+
+	for (int i = 0; i < context->clk_mgr->bw_params->clk_table.num_entries_per_clk.num_memclk_levels; i++) {
+		if (context->clk_mgr->bw_params->clk_table.entries[i].memclk_mhz == 0 ||
+			uclk_mhz < context->clk_mgr->bw_params->clk_table.entries[i].memclk_mhz)
+			break;
+		if (uclk_mhz > context->clk_mgr->bw_params->clk_table.entries[i].memclk_mhz)
+			dpm_level++;
+	}
+
+	return dpm_level;
+}
+
 static struct resource_funcs dcn401_res_pool_funcs = {
 	.destroy = dcn401_destroy_resource_pool,
 	.link_enc_create = dcn401_link_encoder_create,
@@ -1714,6 +1730,7 @@ static struct resource_funcs dcn401_res_pool_funcs = {
 	.prepare_mcache_programming = dcn401_prepare_mcache_programming,
 	.build_pipe_pix_clk_params = dcn401_build_pipe_pix_clk_params,
 	.calculate_mall_ways_from_bytes = dcn32_calculate_mall_ways_from_bytes,
+	.get_power_profile = dcn401_get_power_profile,
 };
 
 static uint32_t read_pipe_fuses(struct dc_context *ctx)
-- 
2.43.0



