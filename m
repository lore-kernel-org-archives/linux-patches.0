Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A53228E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B358AC433C8;
	Wed, 20 Sep 2023 11:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210798;
	bh=+OGW/XWcjU6j84MbfwtP7hgcZcUaUz36qj+WOQ1ojGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0G6zTZi7AR9T0o4T7fm2TCuWP004jCLVTY2pVQg0s2RK4QDlqE+BasWLbFvLqIfP
	 8dL+UwcdMkZ4XKCyxX4v107cFcmmywFINydt1q/lY+wPpXeKt1U8yTZeBUTPu6cIgV
	 1HmHo+1f3fy/DEamMZiQUsh4dXGIcEGTz8KUz87M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Shen <george.shen@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Mustapha Ghaddar <mghaddar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 208/211] drm/amd/display: Add DPIA Link Encoder Assignment Fix
Date: Wed, 20 Sep 2023 13:30:52 +0200
Message-ID: <20230920112852.312154893@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mustapha Ghaddar <mghaddar@amd.com>

commit 64be47ba286117ee4e3dd9d064c88ea2913e3269 upstream.

For DPIA we should have preferred DIG assignment based on DPIA selected
as per the ASIC design.

Reviewed-by: George Shen <george.shen@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Mustapha Ghaddar <mghaddar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c   |   35 +++++++++++++---
 drivers/gpu/drm/amd/display/dc/dc.h                     |    1 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c |   23 ++++++++++
 drivers/gpu/drm/amd/display/dc/inc/core_types.h         |    1 
 drivers/gpu/drm/amd/display/dc/link/link_factory.c      |    4 +
 5 files changed, 58 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c
@@ -169,11 +169,23 @@ static void add_link_enc_assignment(
 /* Return first available DIG link encoder. */
 static enum engine_id find_first_avail_link_enc(
 		const struct dc_context *ctx,
-		const struct dc_state *state)
+		const struct dc_state *state,
+		enum engine_id eng_id_requested)
 {
 	enum engine_id eng_id = ENGINE_ID_UNKNOWN;
 	int i;
 
+	if (eng_id_requested != ENGINE_ID_UNKNOWN) {
+
+		for (i = 0; i < ctx->dc->res_pool->res_cap->num_dig_link_enc; i++) {
+			eng_id = state->res_ctx.link_enc_cfg_ctx.link_enc_avail[i];
+			if (eng_id == eng_id_requested)
+				return eng_id;
+		}
+	}
+
+	eng_id = ENGINE_ID_UNKNOWN;
+
 	for (i = 0; i < ctx->dc->res_pool->res_cap->num_dig_link_enc; i++) {
 		eng_id = state->res_ctx.link_enc_cfg_ctx.link_enc_avail[i];
 		if (eng_id != ENGINE_ID_UNKNOWN)
@@ -287,7 +299,7 @@ void link_enc_cfg_link_encs_assign(
 		struct dc_stream_state *streams[],
 		uint8_t stream_count)
 {
-	enum engine_id eng_id = ENGINE_ID_UNKNOWN;
+	enum engine_id eng_id = ENGINE_ID_UNKNOWN, eng_id_req = ENGINE_ID_UNKNOWN;
 	int i;
 	int j;
 
@@ -377,8 +389,15 @@ void link_enc_cfg_link_encs_assign(
 		 * assigned to that endpoint.
 		 */
 		link_enc = get_link_enc_used_by_link(state, stream->link);
-		if (link_enc == NULL)
-			eng_id = find_first_avail_link_enc(stream->ctx, state);
+		if (link_enc == NULL) {
+
+			if (stream->link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA &&
+					stream->link->dpia_preferred_eng_id != ENGINE_ID_UNKNOWN)
+				eng_id_req = stream->link->dpia_preferred_eng_id;
+
+			if (eng_id == ENGINE_ID_UNKNOWN)
+				eng_id = find_first_avail_link_enc(stream->ctx, state, eng_id_req);
+		}
 		else
 			eng_id =  link_enc->preferred_engine;
 
@@ -402,7 +421,9 @@ void link_enc_cfg_link_encs_assign(
 			DC_LOG_DEBUG("%s: CUR %s(%d) - enc_id(%d)\n",
 					__func__,
 					assignment.ep_id.ep_type == DISPLAY_ENDPOINT_PHY ? "PHY" : "DPIA",
-					assignment.ep_id.link_id.enum_id - 1,
+					assignment.ep_id.ep_type == DISPLAY_ENDPOINT_PHY ?
+							assignment.ep_id.link_id.enum_id :
+							assignment.ep_id.link_id.enum_id - 1,
 					assignment.eng_id);
 	}
 	for (i = 0; i < MAX_PIPES; i++) {
@@ -413,7 +434,9 @@ void link_enc_cfg_link_encs_assign(
 			DC_LOG_DEBUG("%s: NEW %s(%d) - enc_id(%d)\n",
 					__func__,
 					assignment.ep_id.ep_type == DISPLAY_ENDPOINT_PHY ? "PHY" : "DPIA",
-					assignment.ep_id.link_id.enum_id - 1,
+					assignment.ep_id.ep_type == DISPLAY_ENDPOINT_PHY ?
+							assignment.ep_id.link_id.enum_id :
+							assignment.ep_id.link_id.enum_id - 1,
 					assignment.eng_id);
 	}
 
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1479,6 +1479,7 @@ struct dc_link {
 	 * object creation.
 	 */
 	enum engine_id eng_id;
+	enum engine_id dpia_preferred_eng_id;
 
 	bool test_pattern_enabled;
 	union compliance_test_state compliance_test_state;
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -1029,6 +1029,28 @@ static const struct dce_i2c_mask i2c_mas
 		I2C_COMMON_MASK_SH_LIST_DCN30(_MASK)
 };
 
+/* ========================================================== */
+
+/*
+ * DPIA index | Preferred Encoder     |    Host Router
+ *   0        |      C                |       0
+ *   1        |      First Available  |       0
+ *   2        |      D                |       1
+ *   3        |      First Available  |       1
+ */
+/* ========================================================== */
+static const enum engine_id dpia_to_preferred_enc_id_table[] = {
+		ENGINE_ID_DIGC,
+		ENGINE_ID_DIGC,
+		ENGINE_ID_DIGD,
+		ENGINE_ID_DIGD
+};
+
+static enum engine_id dcn314_get_preferred_eng_id_dpia(unsigned int dpia_index)
+{
+	return dpia_to_preferred_enc_id_table[dpia_index];
+}
+
 static struct dce_i2c_hw *dcn31_i2c_hw_create(
 	struct dc_context *ctx,
 	uint32_t inst)
@@ -1777,6 +1799,7 @@ static struct resource_funcs dcn314_res_
 	.update_bw_bounding_box = dcn314_update_bw_bounding_box,
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 	.get_panel_config_defaults = dcn314_get_panel_config_defaults,
+	.get_preferred_eng_id_dpia = dcn314_get_preferred_eng_id_dpia,
 };
 
 static struct clock_source *dcn30_clock_source_create(
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -65,6 +65,7 @@ struct resource_context;
 struct clk_bw_params;
 
 struct resource_funcs {
+	enum engine_id (*get_preferred_eng_id_dpia)(unsigned int dpia_index);
 	void (*destroy)(struct resource_pool **pool);
 	void (*link_init)(struct dc_link *link);
 	struct panel_cntl*(*panel_cntl_create)(
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -783,6 +783,10 @@ static bool construct_dpia(struct dc_lin
 	/* Set dpia port index : 0 to number of dpia ports */
 	link->ddc_hw_inst = init_params->connector_index;
 
+	// Assign Dpia preferred eng_id
+	if (link->dc->res_pool->funcs->get_preferred_eng_id_dpia)
+		link->dpia_preferred_eng_id = link->dc->res_pool->funcs->get_preferred_eng_id_dpia(link->ddc_hw_inst);
+
 	/* TODO: Create link encoder */
 
 	link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;


