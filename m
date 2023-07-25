Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435B1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2651CC433C8;
	Tue, 25 Jul 2023 11:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283208;
	bh=tgnsHJ9YqVLtmmG/jw9s6JujDvIT+tZrfAB2EzFUGAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDS69u9m2e9ZL4Q6mjx/1eLDJJ2lwDysyDzz+zM+PT8e4DSiCVRVoOBSnqEcumtzp
	 G56PnoX7Xb/OOY2MwZbCeveqbjKW9i839wyNWAqCG1OVZ1545+lysJJgHVKgqIeFH5
	 dFutq0bHn3GBBDhPBBtGj/yovVRLJf6X4JLlhqXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 177/183] drm/amd/display: use max_dsc_bpp in amdgpu_dm
Date: Tue, 25 Jul 2023 12:46:45 +0200
Message-ID: <20230725104514.107483956@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 6e5abe94c6eb9b281398e39819217e8fdd1c336f upstream.

Since, the quirk is handled in the DRM core now, we can use that value
instead of the internal value.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    6 ++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   11 +++++++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5714,16 +5714,14 @@ static void apply_dsc_policy_for_stream(
 {
 	struct drm_connector *drm_connector = &aconnector->base;
 	uint32_t link_bandwidth_kbps;
-	uint32_t max_dsc_target_bpp_limit_override = 0;
 	struct dc *dc = sink->ctx->dc;
 	uint32_t max_supported_bw_in_kbps, timing_bw_in_kbps;
 	uint32_t dsc_max_supported_bw_in_kbps;
+	uint32_t max_dsc_target_bpp_limit_override =
+		drm_connector->display_info.max_dsc_bpp;
 
 	link_bandwidth_kbps = dc_link_bandwidth_kbps(aconnector->dc_link,
 							dc_link_get_link_cap(aconnector->dc_link));
-	if (stream->link && stream->link->local_sink)
-		max_dsc_target_bpp_limit_override =
-			stream->link->local_sink->edid_caps.panel_patch.max_dsc_target_bpp_limit;
 
 	/* Set DSC policy according to dsc_clock_en */
 	dc_dsc_policy_set_enable_dsc_when_not_needed(
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -673,15 +673,18 @@ static void set_dsc_configs_from_fairnes
 		int count,
 		int k)
 {
+	struct drm_connector *drm_connector;
 	int i;
 
 	for (i = 0; i < count; i++) {
+		drm_connector = &params[i].aconnector->base;
+
 		memset(&params[i].timing->dsc_cfg, 0, sizeof(params[i].timing->dsc_cfg));
 		if (vars[i + k].dsc_enabled && dc_dsc_compute_config(
 					params[i].sink->ctx->dc->res_pool->dscs[0],
 					&params[i].sink->dsc_caps.dsc_dec_caps,
 					params[i].sink->ctx->dc->debug.dsc_min_slice_height_override,
-					params[i].sink->edid_caps.panel_patch.max_dsc_target_bpp_limit,
+					drm_connector->display_info.max_dsc_bpp,
 					0,
 					params[i].timing,
 					&params[i].timing->dsc_cfg)) {
@@ -723,12 +726,16 @@ static int bpp_x16_from_pbn(struct dsc_m
 	struct dc_dsc_config dsc_config;
 	u64 kbps;
 
+	struct drm_connector *drm_connector = &param.aconnector->base;
+	uint32_t max_dsc_target_bpp_limit_override =
+		drm_connector->display_info.max_dsc_bpp;
+
 	kbps = div_u64((u64)pbn * 994 * 8 * 54, 64);
 	dc_dsc_compute_config(
 			param.sink->ctx->dc->res_pool->dscs[0],
 			&param.sink->dsc_caps.dsc_dec_caps,
 			param.sink->ctx->dc->debug.dsc_min_slice_height_override,
-			param.sink->edid_caps.panel_patch.max_dsc_target_bpp_limit,
+			max_dsc_target_bpp_limit_override,
 			(int) kbps, param.timing, &dsc_config);
 
 	return dsc_config.bits_per_pixel;


