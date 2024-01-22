Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4771514460D;
	Tue, 23 Jan 2024 00:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969544; cv=none; b=r4BCVqquZit3h9YHaQ02YKrc/M3rtTaIJqHdO4x8Dsus1i+gRYHtqFUOfrKHxpn+PIT8M1SdF/MkzzRHm4IZ/MpS0Nd4B4EsV0BcdFpLQwr6mVxufX5LQDA8R2wMyNCjHHOe8nQe8+EFhbnHt5/h6h6fMkjq9CU2Xv/ZOjIP4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969544; c=relaxed/simple;
	bh=UpQ8dVuwVbC5U3IWeSqtUhLR5cQaNUduD55WH0T3ec0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1es31qaZ98sdJXJnhrheGmbtK44L0CW+KUbNR8NTZcRJUvsJErutSOHuYy4Nsg5akf0fdH0ZV4X5Qq8R4gimwf6clP+Deu4B6hsEwX4lt4BuMZvgRIq2cN0TOK8BZ+25yYrHu41oTVvsT70sYHLHAQ2WY8b3tTm7+QzUX6jAIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzDNetBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzDNetBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C37C43390;
	Tue, 23 Jan 2024 00:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969544;
	bh=UpQ8dVuwVbC5U3IWeSqtUhLR5cQaNUduD55WH0T3ec0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzDNetBFeZmvQ0n9RJJeUpaLrnj6weJQNpTZeL8BzHvidVM3xxTSxZ9JgwpuOYChH
	 kIRFh5OGOc1AM5JdfN8WDvw2NZfdNpgtxtW+Ej5sIh2+b49bV2s9Nw7NJi1Lvqr/Yy
	 CHCb0UoLLZ/Tv/xGsBhckB4RnOOOWBUbbxaOYo9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 292/641] drm/amd/display: Use drm_connector in create_stream_for_sink
Date: Mon, 22 Jan 2024 15:53:16 -0800
Message-ID: <20240122235827.029950383@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 3e094a2875260543ca74838decc0c995d3765096 ]

[WHAT]
We need to use this function for both amdgpu_dm_connectors
and drm_writeback_connectors. Modify it to operate on
a drm_connector as a common base.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: dbf5d3d02987 ("drm/amd/display: Check writeback connectors in create_validate_stream_for_sink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 65 +++++++++++--------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 5cf919a489a1..beacda24b4ef 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5527,6 +5527,7 @@ static void fill_stream_properties_from_drm_display_mode(
 			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
 	else if (drm_mode_is_420_also(info, mode_in)
+			&& aconnector
 			&& aconnector->force_yuv420_output)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
 	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR444)
@@ -5562,7 +5563,7 @@ static void fill_stream_properties_from_drm_display_mode(
 		timing_out->hdmi_vic = hv_frame.vic;
 	}
 
-	if (is_freesync_video_mode(mode_in, aconnector)) {
+	if (aconnector && is_freesync_video_mode(mode_in, aconnector)) {
 		timing_out->h_addressable = mode_in->hdisplay;
 		timing_out->h_total = mode_in->htotal;
 		timing_out->h_sync_width = mode_in->hsync_end - mode_in->hsync_start;
@@ -6039,14 +6040,14 @@ static void apply_dsc_policy_for_stream(struct amdgpu_dm_connector *aconnector,
 }
 
 static struct dc_stream_state *
-create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
+create_stream_for_sink(struct drm_connector *connector,
 		       const struct drm_display_mode *drm_mode,
 		       const struct dm_connector_state *dm_state,
 		       const struct dc_stream_state *old_stream,
 		       int requested_bpc)
 {
+	struct amdgpu_dm_connector *aconnector = NULL;
 	struct drm_display_mode *preferred_mode = NULL;
-	struct drm_connector *drm_connector;
 	const struct drm_connector_state *con_state = &dm_state->base;
 	struct dc_stream_state *stream = NULL;
 	struct drm_display_mode mode;
@@ -6065,20 +6066,22 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	drm_mode_init(&mode, drm_mode);
 	memset(&saved_mode, 0, sizeof(saved_mode));
 
-	if (aconnector == NULL) {
-		DRM_ERROR("aconnector is NULL!\n");
+	if (connector == NULL) {
+		DRM_ERROR("connector is NULL!\n");
 		return stream;
 	}
 
-	drm_connector = &aconnector->base;
-
-	if (!aconnector->dc_sink) {
-		sink = create_fake_sink(aconnector);
-		if (!sink)
-			return stream;
-	} else {
-		sink = aconnector->dc_sink;
-		dc_sink_retain(sink);
+	if (connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK) {
+		aconnector = NULL;
+		aconnector = to_amdgpu_dm_connector(connector);
+		if (!aconnector->dc_sink) {
+			sink = create_fake_sink(aconnector);
+			if (!sink)
+				return stream;
+		} else {
+			sink = aconnector->dc_sink;
+			dc_sink_retain(sink);
+		}
 	}
 
 	stream = dc_create_stream_for_sink(sink);
@@ -6088,12 +6091,13 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 		goto finish;
 	}
 
+	/* We leave this NULL for writeback connectors */
 	stream->dm_stream_context = aconnector;
 
 	stream->timing.flags.LTE_340MCSC_SCRAMBLE =
-		drm_connector->display_info.hdmi.scdc.scrambling.low_rates;
+		connector->display_info.hdmi.scdc.scrambling.low_rates;
 
-	list_for_each_entry(preferred_mode, &aconnector->base.modes, head) {
+	list_for_each_entry(preferred_mode, &connector->modes, head) {
 		/* Search for preferred mode */
 		if (preferred_mode->type & DRM_MODE_TYPE_PREFERRED) {
 			native_mode_found = true;
@@ -6102,7 +6106,7 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	}
 	if (!native_mode_found)
 		preferred_mode = list_first_entry_or_null(
-				&aconnector->base.modes,
+				&connector->modes,
 				struct drm_display_mode,
 				head);
 
@@ -6116,7 +6120,7 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 		 * and the modelist may not be filled in time.
 		 */
 		DRM_DEBUG_DRIVER("No preferred mode found\n");
-	} else {
+	} else if (aconnector) {
 		recalculate_timing = is_freesync_video_mode(&mode, aconnector);
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
@@ -6139,13 +6143,17 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	 */
 	if (!scale || mode_refresh != preferred_refresh)
 		fill_stream_properties_from_drm_display_mode(
-			stream, &mode, &aconnector->base, con_state, NULL,
+			stream, &mode, connector, con_state, NULL,
 			requested_bpc);
 	else
 		fill_stream_properties_from_drm_display_mode(
-			stream, &mode, &aconnector->base, con_state, old_stream,
+			stream, &mode, connector, con_state, old_stream,
 			requested_bpc);
 
+	/* The rest isn't needed for writeback connectors */
+	if (!aconnector)
+		goto finish;
+
 	if (aconnector->timing_changed) {
 		drm_dbg(aconnector->base.dev,
 			"overriding timing for automated test, bpc %d, changing to %d\n",
@@ -6163,7 +6171,7 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
 	fill_audio_info(
 		&stream->audio_info,
-		drm_connector,
+		connector,
 		sink);
 
 	update_stream_signal(stream, sink);
@@ -6633,7 +6641,7 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	enum dc_status dc_result = DC_OK;
 
 	do {
-		stream = create_stream_for_sink(aconnector, drm_mode,
+		stream = create_stream_for_sink(connector, drm_mode,
 						dm_state, old_stream,
 						requested_bpc);
 		if (stream == NULL) {
@@ -9365,15 +9373,16 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
 	acrtc = to_amdgpu_crtc(crtc);
 	connector = amdgpu_dm_find_first_crtc_matching_connector(state, crtc);
-	aconnector = to_amdgpu_dm_connector(connector);
+	if (connector && connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
+		aconnector = to_amdgpu_dm_connector(connector);
 
 	/* TODO This hack should go away */
-	if (aconnector && enable) {
+	if (connector && enable) {
 		/* Make sure fake sink is created in plug-in scenario */
 		drm_new_conn_state = drm_atomic_get_new_connector_state(state,
-							    &aconnector->base);
+									connector);
 		drm_old_conn_state = drm_atomic_get_old_connector_state(state,
-							    &aconnector->base);
+									connector);
 
 		if (IS_ERR(drm_new_conn_state)) {
 			ret = PTR_ERR_OR_ZERO(drm_new_conn_state);
@@ -9520,7 +9529,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		 * added MST connectors not found in existing crtc_state in the chained mode
 		 * TODO: need to dig out the root cause of that
 		 */
-		if (!aconnector)
+		if (!connector)
 			goto skip_modeset;
 
 		if (modereset_required(new_crtc_state))
@@ -9563,7 +9572,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	 * We want to do dc stream updates that do not require a
 	 * full modeset below.
 	 */
-	if (!(enable && aconnector && new_crtc_state->active))
+	if (!(enable && connector && new_crtc_state->active))
 		return 0;
 	/*
 	 * Given above conditions, the dc state cannot be NULL because:
-- 
2.43.0



