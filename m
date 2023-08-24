Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEA0FC07
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27953C433C9;
	Thu, 24 Aug 2023 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888887;
	bh=dogeuh+iGoERDaeMQiXe9QKIX0LZN0XiagZynhYN/Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysu7y1/vnhWNnpHoSlwbJutDY70gJR9TVw8LzEiIpj/iZhTJ/8p+ShOqHLCvARPjY
	 nBR+Pzg5oPfWMRP7HQAwTU5NrPTiO8jNxLLMAAGat7lJZyy5GRiMczDp4/fgV+BgGD
	 rgwZ9Uqs0qTFpktGlVdfm+WtRrTvvD3GAbUZR0c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	hersen wu <hersenxs.wu@amd.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/139] drm/amd/display: phase3 mst hdcp for multiple displays
Date: Thu, 24 Aug 2023 16:49:32 +0200
Message-ID: <20230824145025.738941912@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: hersen wu <hersenxs.wu@amd.com>

[ Upstream commit e8fd3eeb5e8711af39b00642da06474e52f4780c ]

[Why]
multiple display hdcp are enabled within event_property_validate,
event_property_update by looping all displays on mst hub. when
one of display on mst hub in unplugged or disabled, hdcp are
disabled for all displays on mst hub within hdcp_reset_display
by looping all displays of mst link. for displays still active,
their encryption status are off. kernel driver will not run hdcp
authentication again. therefore, hdcp are not enabled automatically.

[How]
within is_content_protection_different, check drm_crtc_state changes
of all displays on mst hub, if need, triger hdcp_update_display to
re-run hdcp authentication.

Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: hersen wu <hersenxs.wu@amd.com>
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: cdff36a0217a ("drm/amd/display: fix access hdcp_workqueue assert")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 183 ++++++++++++++----
 1 file changed, 141 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 41be9606726e9..65f9e7012f6c4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8566,27 +8566,55 @@ is_scaling_state_different(const struct dm_connector_state *dm_state,
 }
 
 #ifdef CONFIG_DRM_AMD_DC_HDCP
-static bool is_content_protection_different(struct drm_connector_state *state,
-					    const struct drm_connector_state *old_state,
-					    const struct drm_connector *connector, struct hdcp_workqueue *hdcp_w)
+static bool is_content_protection_different(struct drm_crtc_state *new_crtc_state,
+					    struct drm_crtc_state *old_crtc_state,
+					    struct drm_connector_state *new_conn_state,
+					    struct drm_connector_state *old_conn_state,
+					    const struct drm_connector *connector,
+					    struct hdcp_workqueue *hdcp_w)
 {
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 	struct dm_connector_state *dm_con_state = to_dm_connector_state(connector->state);
 
-	/* Handle: Type0/1 change */
-	if (old_state->hdcp_content_type != state->hdcp_content_type &&
-	    state->content_protection != DRM_MODE_CONTENT_PROTECTION_UNDESIRED) {
-		state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+	pr_debug("[HDCP_DM] connector->index: %x connect_status: %x dpms: %x\n",
+		connector->index, connector->status, connector->dpms);
+	pr_debug("[HDCP_DM] state protection old: %x new: %x\n",
+		old_conn_state->content_protection, new_conn_state->content_protection);
+
+	if (old_crtc_state)
+		pr_debug("[HDCP_DM] old crtc en: %x a: %x m: %x a-chg: %x c-chg: %x\n",
+		old_crtc_state->enable,
+		old_crtc_state->active,
+		old_crtc_state->mode_changed,
+		old_crtc_state->active_changed,
+		old_crtc_state->connectors_changed);
+
+	if (new_crtc_state)
+		pr_debug("[HDCP_DM] NEW crtc en: %x a: %x m: %x a-chg: %x c-chg: %x\n",
+		new_crtc_state->enable,
+		new_crtc_state->active,
+		new_crtc_state->mode_changed,
+		new_crtc_state->active_changed,
+		new_crtc_state->connectors_changed);
+
+	/* hdcp content type change */
+	if (old_conn_state->hdcp_content_type != new_conn_state->hdcp_content_type &&
+	    new_conn_state->content_protection != DRM_MODE_CONTENT_PROTECTION_UNDESIRED) {
+		new_conn_state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+		pr_debug("[HDCP_DM] Type0/1 change %s :true\n", __func__);
 		return true;
 	}
 
-	/* CP is being re enabled, ignore this
-	 *
-	 * Handles:	ENABLED -> DESIRED
-	 */
-	if (old_state->content_protection == DRM_MODE_CONTENT_PROTECTION_ENABLED &&
-	    state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED) {
-		state->content_protection = DRM_MODE_CONTENT_PROTECTION_ENABLED;
+	/* CP is being re enabled, ignore this */
+	if (old_conn_state->content_protection == DRM_MODE_CONTENT_PROTECTION_ENABLED &&
+	    new_conn_state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED) {
+		if (new_crtc_state && new_crtc_state->mode_changed) {
+			new_conn_state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+			pr_debug("[HDCP_DM] ENABLED->DESIRED & mode_changed %s :true\n", __func__);
+			return true;
+		};
+		new_conn_state->content_protection = DRM_MODE_CONTENT_PROTECTION_ENABLED;
+		pr_debug("[HDCP_DM] ENABLED -> DESIRED %s :false\n", __func__);
 		return false;
 	}
 
@@ -8594,9 +8622,9 @@ static bool is_content_protection_different(struct drm_connector_state *state,
 	 *
 	 * Handles:	UNDESIRED -> ENABLED
 	 */
-	if (old_state->content_protection == DRM_MODE_CONTENT_PROTECTION_UNDESIRED &&
-	    state->content_protection == DRM_MODE_CONTENT_PROTECTION_ENABLED)
-		state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+	if (old_conn_state->content_protection == DRM_MODE_CONTENT_PROTECTION_UNDESIRED &&
+	    new_conn_state->content_protection == DRM_MODE_CONTENT_PROTECTION_ENABLED)
+		new_conn_state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
 
 	/* Stream removed and re-enabled
 	 *
@@ -8606,10 +8634,12 @@ static bool is_content_protection_different(struct drm_connector_state *state,
 	 *
 	 * Handles:	DESIRED -> DESIRED (Special case)
 	 */
-	if (!(old_state->crtc && old_state->crtc->enabled) &&
-		state->crtc && state->crtc->enabled &&
+	if (!(old_conn_state->crtc && old_conn_state->crtc->enabled) &&
+		new_conn_state->crtc && new_conn_state->crtc->enabled &&
 		connector->state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED) {
 		dm_con_state->update_hdcp = false;
+		pr_debug("[HDCP_DM] DESIRED->DESIRED (Stream removed and re-enabled) %s :true\n",
+			__func__);
 		return true;
 	}
 
@@ -8621,35 +8651,42 @@ static bool is_content_protection_different(struct drm_connector_state *state,
 	 *
 	 * Handles:	DESIRED -> DESIRED (Special case)
 	 */
-	if (dm_con_state->update_hdcp && state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED &&
-	    connector->dpms == DRM_MODE_DPMS_ON && aconnector->dc_sink != NULL) {
+	if (dm_con_state->update_hdcp &&
+	new_conn_state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED &&
+	connector->dpms == DRM_MODE_DPMS_ON && aconnector->dc_sink != NULL) {
 		dm_con_state->update_hdcp = false;
+		pr_debug("[HDCP_DM] DESIRED->DESIRED (Hot-plug, headless s3, dpms) %s :true\n",
+			__func__);
 		return true;
 	}
 
-	/*
-	 * Handles:	UNDESIRED -> UNDESIRED
-	 *		DESIRED -> DESIRED
-	 *		ENABLED -> ENABLED
-	 */
-	if (old_state->content_protection == state->content_protection)
+	if (old_conn_state->content_protection == new_conn_state->content_protection) {
+		if (new_conn_state->content_protection >= DRM_MODE_CONTENT_PROTECTION_DESIRED) {
+			if (new_crtc_state && new_crtc_state->mode_changed) {
+				pr_debug("[HDCP_DM] DESIRED->DESIRED or ENABLE->ENABLE mode_change %s :true\n",
+					__func__);
+				return true;
+			};
+			pr_debug("[HDCP_DM] DESIRED->DESIRED & ENABLE->ENABLE %s :false\n",
+				__func__);
+			return false;
+		};
+
+		pr_debug("[HDCP_DM] UNDESIRED->UNDESIRED %s :false\n", __func__);
 		return false;
+	}
 
-	/*
-	 * Handles:	UNDESIRED -> DESIRED
-	 *		DESIRED -> UNDESIRED
-	 *		ENABLED -> UNDESIRED
-	 */
-	if (state->content_protection != DRM_MODE_CONTENT_PROTECTION_ENABLED)
+	if (new_conn_state->content_protection != DRM_MODE_CONTENT_PROTECTION_ENABLED) {
+		pr_debug("[HDCP_DM] UNDESIRED->DESIRED or DESIRED->UNDESIRED or ENABLED->UNDESIRED %s :true\n",
+			__func__);
 		return true;
+	}
 
-	/*
-	 * Handles:	DESIRED -> ENABLED
-	 */
+	pr_debug("[HDCP_DM] DESIRED->ENABLED %s :false\n", __func__);
 	return false;
 }
-
 #endif
+
 static void remove_stream(struct amdgpu_device *adev,
 			  struct amdgpu_crtc *acrtc,
 			  struct dc_stream_state *stream)
@@ -9592,15 +9629,66 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 		}
 	}
 #ifdef CONFIG_DRM_AMD_DC_HDCP
+	for_each_oldnew_connector_in_state(state, connector, old_con_state, new_con_state, i) {
+		struct dm_connector_state *dm_new_con_state = to_dm_connector_state(new_con_state);
+		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
+		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
+
+		pr_debug("[HDCP_DM] -------------- i : %x ----------\n", i);
+
+		if (!connector)
+			continue;
+
+		pr_debug("[HDCP_DM] connector->index: %x connect_status: %x dpms: %x\n",
+			connector->index, connector->status, connector->dpms);
+		pr_debug("[HDCP_DM] state protection old: %x new: %x\n",
+			old_con_state->content_protection, new_con_state->content_protection);
+
+		if (aconnector->dc_sink) {
+			if (aconnector->dc_sink->sink_signal != SIGNAL_TYPE_VIRTUAL &&
+				aconnector->dc_sink->sink_signal != SIGNAL_TYPE_NONE) {
+				pr_debug("[HDCP_DM] pipe_ctx dispname=%s\n",
+				aconnector->dc_sink->edid_caps.display_name);
+			}
+		}
+
+		new_crtc_state = NULL;
+		old_crtc_state = NULL;
+
+		if (acrtc) {
+			new_crtc_state = drm_atomic_get_new_crtc_state(state, &acrtc->base);
+			old_crtc_state = drm_atomic_get_old_crtc_state(state, &acrtc->base);
+		}
+
+		if (old_crtc_state)
+			pr_debug("old crtc en: %x a: %x m: %x a-chg: %x c-chg: %x\n",
+			old_crtc_state->enable,
+			old_crtc_state->active,
+			old_crtc_state->mode_changed,
+			old_crtc_state->active_changed,
+			old_crtc_state->connectors_changed);
+
+		if (new_crtc_state)
+			pr_debug("NEW crtc en: %x a: %x m: %x a-chg: %x c-chg: %x\n",
+			new_crtc_state->enable,
+			new_crtc_state->active,
+			new_crtc_state->mode_changed,
+			new_crtc_state->active_changed,
+			new_crtc_state->connectors_changed);
+	}
+
 	for_each_oldnew_connector_in_state(state, connector, old_con_state, new_con_state, i) {
 		struct dm_connector_state *dm_new_con_state = to_dm_connector_state(new_con_state);
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
 		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
 		new_crtc_state = NULL;
+		old_crtc_state = NULL;
 
-		if (acrtc)
+		if (acrtc) {
 			new_crtc_state = drm_atomic_get_new_crtc_state(state, &acrtc->base);
+			old_crtc_state = drm_atomic_get_old_crtc_state(state, &acrtc->base);
+		}
 
 		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
 
@@ -9612,7 +9700,8 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			continue;
 		}
 
-		if (is_content_protection_different(new_con_state, old_con_state, connector, adev->dm.hdcp_workqueue)) {
+		if (is_content_protection_different(new_crtc_state, old_crtc_state, new_con_state,
+											old_con_state, connector, adev->dm.hdcp_workqueue)) {
 			/* when display is unplugged from mst hub, connctor will
 			 * be destroyed within dm_dp_mst_connector_destroy. connector
 			 * hdcp perperties, like type, undesired, desired, enabled,
@@ -9622,6 +9711,11 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			 * will be retrieved from hdcp_work within dm_dp_mst_get_modes
 			 */
 
+			bool enable_encryption = false;
+
+			if (new_con_state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED)
+				enable_encryption = true;
+
 			if (aconnector->dc_link && aconnector->dc_sink &&
 				aconnector->dc_link->type == dc_connection_mst_branch) {
 				struct hdcp_workqueue *hdcp_work = adev->dm.hdcp_workqueue;
@@ -9634,11 +9728,16 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 					new_con_state->content_protection;
 			}
 
+			if (new_crtc_state && new_crtc_state->mode_changed &&
+				new_con_state->content_protection >= DRM_MODE_CONTENT_PROTECTION_DESIRED)
+				enable_encryption = true;
+
+			DRM_INFO("[HDCP_DM] hdcp_update_display enable_encryption = %x\n", enable_encryption);
+
 			hdcp_update_display(
 				adev->dm.hdcp_workqueue, aconnector->dc_link->link_index, aconnector,
-				new_con_state->hdcp_content_type,
-				new_con_state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED);
-    }
+				new_con_state->hdcp_content_type, enable_encryption);
+		}
 	}
 #endif
 
-- 
2.40.1



