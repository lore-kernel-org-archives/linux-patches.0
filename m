Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C6378F32;
	Tue, 27 May 2025 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365322; cv=none; b=rDZ1sug42hU7Jy2r8GAzvbh6uCiwlmIsUN9i4TT7Wyr/KHEFkXoA6fCjpPjrOY2006EBsF0FUvCmV//bpawhzOuJ7NWiPZIqlSukOiSm9bJMqAblcWLl3WJBb3r1tg61r+/LZvzTNnO19oznVih9kDB4GlTUnzZ7g4HrmDL4ems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365322; c=relaxed/simple;
	bh=L112nBQ8R5j6uVFotcEoaSdu1UEz2/ab4MV9uunQQJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK3aGYUw3lwDZQlykVt1e0aZAESpBWLK3yk+TBuMWcbpbrgnc9cKT8qAYTh8TadJDcKL/A9lsrxUxKckUiAlwHI/7UwFp/H+iisiqoelEGfnZBovVGePBr0pcnnilfvWhccT03U442/80xOcimOIN1p7WYYwnYLI3oGoHM6d7v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sa8JPITB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sa8JPITB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EA2C4CEE9;
	Tue, 27 May 2025 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365322;
	bh=L112nBQ8R5j6uVFotcEoaSdu1UEz2/ab4MV9uunQQJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa8JPITB1a/UeT9NFeXZRPm2JaELA7J52LvMo4Vv95/im12y2LpRrFCCxh/usyPnT
	 ddHgO/o7TMEpqy3Glc6T4flTgjj9IBLBtz5PEfm7Omj1KcReSz8E8gnKB93bSMz+kM
	 ERJmXMcrsn8coh94kBiDjX2iS+40SKwdQfFaRPWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/626] drm/amd/display: Dont treat wb connector as physical in create_validate_stream_for_sink
Date: Tue, 27 May 2025 18:23:51 +0200
Message-ID: <20250527162458.752303443@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit cbf4890c6f28fb1ad733e14613fbd33c2004bced ]

Don't try to operate on a drm_wb_connector as an amdgpu_dm_connector.
While dereferencing aconnector->base will "work" it's wrong and
might lead to unknown bad things. Just... don't.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 26 ++++++++++++-------
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  2 +-
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   |  6 ++---
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c0ff501687f5b..1e5984e71bfd7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7399,12 +7399,12 @@ static enum dc_status dm_validate_stream_and_context(struct dc *dc,
 }
 
 struct dc_stream_state *
-create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
+create_validate_stream_for_sink(struct drm_connector *connector,
 				const struct drm_display_mode *drm_mode,
 				const struct dm_connector_state *dm_state,
 				const struct dc_stream_state *old_stream)
 {
-	struct drm_connector *connector = &aconnector->base;
+	struct amdgpu_dm_connector *aconnector = NULL;
 	struct amdgpu_device *adev = drm_to_adev(connector->dev);
 	struct dc_stream_state *stream;
 	const struct drm_connector_state *drm_state = dm_state ? &dm_state->base : NULL;
@@ -7415,8 +7415,12 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	if (!dm_state)
 		return NULL;
 
-	if (aconnector->dc_link->connector_signal == SIGNAL_TYPE_HDMI_TYPE_A ||
-	    aconnector->dc_link->dpcd_caps.dongle_type == DISPLAY_DONGLE_DP_HDMI_CONVERTER)
+	if (connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
+		aconnector = to_amdgpu_dm_connector(connector);
+
+	if (aconnector &&
+	    (aconnector->dc_link->connector_signal == SIGNAL_TYPE_HDMI_TYPE_A ||
+	     aconnector->dc_link->dpcd_caps.dongle_type == DISPLAY_DONGLE_DP_HDMI_CONVERTER))
 		bpc_limit = 8;
 
 	do {
@@ -7428,10 +7432,11 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 			break;
 		}
 
-		if (aconnector->base.connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+		dc_result = dc_validate_stream(adev->dm.dc, stream);
+
+		if (!aconnector) /* writeback connector */
 			return stream;
 
-		dc_result = dc_validate_stream(adev->dm.dc, stream);
 		if (dc_result == DC_OK && stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 			dc_result = dm_dp_mst_is_port_support_mode(aconnector, stream);
 
@@ -7461,7 +7466,7 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 				     __func__, __LINE__);
 
 		aconnector->force_yuv420_output = true;
-		stream = create_validate_stream_for_sink(aconnector, drm_mode,
+		stream = create_validate_stream_for_sink(connector, drm_mode,
 						dm_state, old_stream);
 		aconnector->force_yuv420_output = false;
 	}
@@ -7476,6 +7481,9 @@ enum drm_mode_status amdgpu_dm_connector_mode_valid(struct drm_connector *connec
 	struct dc_sink *dc_sink;
 	/* TODO: Unhardcode stream count */
 	struct dc_stream_state *stream;
+	/* we always have an amdgpu_dm_connector here since we got
+	 * here via the amdgpu_dm_connector_helper_funcs
+	 */
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
 	if ((mode->flags & DRM_MODE_FLAG_INTERLACE) ||
@@ -7500,7 +7508,7 @@ enum drm_mode_status amdgpu_dm_connector_mode_valid(struct drm_connector *connec
 
 	drm_mode_set_crtcinfo(mode, 0);
 
-	stream = create_validate_stream_for_sink(aconnector, mode,
+	stream = create_validate_stream_for_sink(connector, mode,
 						 to_dm_connector_state(connector->state),
 						 NULL);
 	if (stream) {
@@ -10520,7 +10528,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		if (!drm_atomic_crtc_needs_modeset(new_crtc_state))
 			goto skip_modeset;
 
-		new_stream = create_validate_stream_for_sink(aconnector,
+		new_stream = create_validate_stream_for_sink(connector,
 							     &new_crtc_state->mode,
 							     dm_new_conn_state,
 							     dm_old_crtc_state->stream);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 20ad72d1b0d9b..9603352ee0949 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -987,7 +987,7 @@ int amdgpu_dm_process_dmub_set_config_sync(struct dc_context *ctx, unsigned int
 					struct set_config_cmd_payload *payload, enum set_config_status *operation_result);
 
 struct dc_stream_state *
-	create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
+	create_validate_stream_for_sink(struct drm_connector *connector,
 					const struct drm_display_mode *drm_mode,
 					const struct dm_connector_state *dm_state,
 					const struct dc_stream_state *old_stream);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index fca0c31e14d8f..92158009cfa73 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1646,7 +1646,6 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 
 		if (ind >= 0) {
 			struct drm_connector *connector;
-			struct amdgpu_dm_connector *aconnector;
 			struct drm_connector_state *drm_new_conn_state;
 			struct dm_connector_state *dm_new_conn_state;
 			struct dm_crtc_state *dm_old_crtc_state;
@@ -1654,15 +1653,14 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 			connector =
 				amdgpu_dm_find_first_crtc_matching_connector(state,
 									     state->crtcs[ind].ptr);
-			aconnector = to_amdgpu_dm_connector(connector);
 			drm_new_conn_state =
 				drm_atomic_get_new_connector_state(state,
-								   &aconnector->base);
+								   connector);
 			dm_new_conn_state = to_dm_connector_state(drm_new_conn_state);
 			dm_old_crtc_state = to_dm_crtc_state(state->crtcs[ind].old_state);
 
 			local_dc_state->streams[i] =
-				create_validate_stream_for_sink(aconnector,
+				create_validate_stream_for_sink(connector,
 								&state->crtcs[ind].new_state->mode,
 								dm_new_conn_state,
 								dm_old_crtc_state->stream);
-- 
2.39.5



