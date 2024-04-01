Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71C5383BA;
	Mon,  1 Apr 2024 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987187; cv=none; b=vGCHRbZZy4F0LaUGnVbVc2QDgPWadk9uduCB7JMgTCO6NNy7motobFDjJG/1dBJ8ZewMB3NHwg6AefFa4JvtisIUoJztqzWjyN7D9cgtezjC7q4RsknprOF5ZSOv6kpKTOxJH7tsLkGsDBu8jy/vGpfeM+3mTgFAkVYeMCXdgOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987187; c=relaxed/simple;
	bh=e0iAUC2/zpxmznW1L/sU1OVFbEV9w+vBkNWKJAHVITo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLhqPAYo3GL+fE++6iITb4nH92aYCfCWOxm5eRPVMWSmpwC+XOWQ+JiImBa4c8tjfXq/3NaplzStgXxpjAK1e0WkKPUvmaCJ/TbNw0ZQ6Bo+0H4ec9Z8iSlcriQxKI5+WaR9ScDLumYsrOa7tSZefZaK9hUucvkd6SkL6qjsjvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSZCCqxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSZCCqxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296C2C433F1;
	Mon,  1 Apr 2024 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987187;
	bh=e0iAUC2/zpxmznW1L/sU1OVFbEV9w+vBkNWKJAHVITo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSZCCqxF+YntvCDNiAL5Tvatqfp1PwXMbVxWpNg2uE8XvB76zu27dutfTD2SeP22I
	 FYFj0F6aP53BjOuUYk23cr8UzH4CNFct2OQWzc2AZk4DwpsJQwTgWWL38kldB3iJLy
	 iYJAcTQinZFLUB8Yp0gd6D2psK3myfoIGIqSDFbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 211/399] drm/amd/display: Init DPPCLK from SMU on dcn32
Date: Mon,  1 Apr 2024 17:42:57 +0200
Message-ID: <20240401152555.483626546@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit 4f5b8d78ca43fcc695ba16c83ebfabbfe09506d6 ]

[WHY & HOW]
DPPCLK ranges should be obtained from the SMU when available.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c  | 14 ++++++++++
 .../drm/amd/display/dc/dml2/dml2_wrapper.c    | 28 +++++++++++++------
 .../drm/amd/display/dc/dml2/dml2_wrapper.h    |  3 ++
 .../dc/resource/dcn32/dcn32_resource.c        |  2 ++
 .../dc/resource/dcn321/dcn321_resource.c      |  2 ++
 5 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index aadd07bc68c5d..bbdbc78161a00 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -216,6 +216,16 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 	if (clk_mgr_base->bw_params->dc_mode_limit.dispclk_mhz > 1950)
 		clk_mgr_base->bw_params->dc_mode_limit.dispclk_mhz = 1950;
 
+	/* DPPCLK */
+	dcn32_init_single_clock(clk_mgr, PPCLK_DPPCLK,
+			&clk_mgr_base->bw_params->clk_table.entries[0].dppclk_mhz,
+			&num_entries_per_clk->num_dppclk_levels);
+	num_levels = num_entries_per_clk->num_dppclk_levels;
+	clk_mgr_base->bw_params->dc_mode_limit.dppclk_mhz = dcn30_smu_get_dc_mode_max_dpm_freq(clk_mgr, PPCLK_DPPCLK);
+	//HW recommends limit of 1950 MHz in display clock for all DCN3.2.x
+	if (clk_mgr_base->bw_params->dc_mode_limit.dppclk_mhz > 1950)
+		clk_mgr_base->bw_params->dc_mode_limit.dppclk_mhz = 1950;
+
 	if (num_entries_per_clk->num_dcfclk_levels &&
 			num_entries_per_clk->num_dtbclk_levels &&
 			num_entries_per_clk->num_dispclk_levels)
@@ -240,6 +250,10 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 					= khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_dpp_clk_khz);
 	}
 
+	for (i = 0; i < num_levels; i++)
+		if (clk_mgr_base->bw_params->clk_table.entries[i].dppclk_mhz > 1950)
+			clk_mgr_base->bw_params->clk_table.entries[i].dppclk_mhz = 1950;
+
 	/* Get UCLK, update bounding box */
 	clk_mgr_base->funcs->get_memclk_states_from_smu(clk_mgr_base);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
index 2a58a7687bdb5..72cca367062e1 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -703,13 +703,8 @@ static inline struct dml2_context *dml2_allocate_memory(void)
 	return (struct dml2_context *) kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
 }
 
-bool dml2_create(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)
+static void dml2_init(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)
 {
-	// Allocate Mode Lib Ctx
-	*dml2 = dml2_allocate_memory();
-
-	if (!(*dml2))
-		return false;
 
 	// Store config options
 	(*dml2)->config = *config;
@@ -737,9 +732,18 @@ bool dml2_create(const struct dc *in_dc, const struct dml2_configuration_options
 	initialize_dml2_soc_bbox(*dml2, in_dc, &(*dml2)->v20.dml_core_ctx.soc);
 
 	initialize_dml2_soc_states(*dml2, in_dc, &(*dml2)->v20.dml_core_ctx.soc, &(*dml2)->v20.dml_core_ctx.states);
+}
+
+bool dml2_create(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)
+{
+	// Allocate Mode Lib Ctx
+	*dml2 = dml2_allocate_memory();
+
+	if (!(*dml2))
+		return false;
+
+	dml2_init(in_dc, config, dml2);
 
-	/*Initialize DML20 instance which calls dml2_core_create, and core_dcn3_populate_informative*/
-	//dml2_initialize_instance(&(*dml_ctx)->v20.dml_init);
 	return true;
 }
 
@@ -779,3 +783,11 @@ bool dml2_create_copy(struct dml2_context **dst_dml2,
 
 	return true;
 }
+
+void dml2_reinit(const struct dc *in_dc,
+				 const struct dml2_configuration_options *config,
+				 struct dml2_context **dml2)
+{
+
+	dml2_init(in_dc, config, dml2);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
index ee0eb184eb6d7..cc662d682fd4d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
@@ -214,6 +214,9 @@ void dml2_copy(struct dml2_context *dst_dml2,
 	struct dml2_context *src_dml2);
 bool dml2_create_copy(struct dml2_context **dst_dml2,
 	struct dml2_context *src_dml2);
+void dml2_reinit(const struct dc *in_dc,
+				 const struct dml2_configuration_options *config,
+				 struct dml2_context **dml2);
 
 /*
  * dml2_validate - Determines if a display configuration is supported or not.
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index c4a4afd8d1a9d..9042378fa8dfb 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1931,6 +1931,8 @@ static void dcn32_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw
 {
 	DC_FP_START();
 	dcn32_update_bw_bounding_box_fpu(dc, bw_params);
+	if (dc->debug.using_dml2 && dc->current_state && dc->current_state->bw_ctx.dml2)
+		dml2_reinit(dc, &dc->dml2_options, &dc->current_state->bw_ctx.dml2);
 	DC_FP_END();
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
index 74412e5f03fef..f4dd6443a3551 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1581,6 +1581,8 @@ static void dcn321_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
 {
 	DC_FP_START();
 	dcn321_update_bw_bounding_box_fpu(dc, bw_params);
+	if (dc->debug.using_dml2 && dc->current_state && dc->current_state->bw_ctx.dml2)
+		dml2_reinit(dc, &dc->dml2_options, &dc->current_state->bw_ctx.dml2);
 	DC_FP_END();
 }
 
-- 
2.43.0



