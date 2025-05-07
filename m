Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C20F1DDC23;
	Wed,  7 May 2025 18:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643748; cv=none; b=uFjjZCdpFqo4SjBKZsUSVGz6iLLGOyxVgq3tBksL+B10SAzGN5aeRVa83IceenCeWX2qd50CKlIltULYdzU/ueC+u9Sy0ohTgbEU0ADCdaawZ5QwOvxrtpEp9k2SfOauSmRoXMmnxKAVBgN5+Fi58Zb3kAkHQllBgh1POGFZRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643748; c=relaxed/simple;
	bh=nYE3pSgb9gStjbvhLzJOBGUSNvD2Ftqs1VCc+phGdSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpzWYZa+AcvJYiRd7/DtQBVv4GB11lNHBvG1g0OgJuoX5e2ICQlv0z/Y4I+KXh22lMaqVGYRuG8nEqrkUslmeJ8uKPCvgaN1vN5jW9sO3fh37MS27xN/gQyFN60DTYIxmBmnmRRgfalaChsZzaNgtNJ996eLjs96x1XR5wK8mBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvkRu0h8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvkRu0h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A2EC4CEE2;
	Wed,  7 May 2025 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643747;
	bh=nYE3pSgb9gStjbvhLzJOBGUSNvD2Ftqs1VCc+phGdSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvkRu0h8LygH9N4HHqlN8/+L6dvgS52MUO16CyQWq+xP9kfJKD1aWrp/MKc6GF5ev
	 CypvSmgtX/88paoTtvSSu/HwwGGiqY4ISwjiOu1EPdo5djXZer6+axTNWQY0vYzzAl
	 teUaF0+2eYN3gO7rHJgHogEu4mzbELbL3kEmKG/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <Daniel.Wheeler@amd.com>,
	hersen wu <hersenxs.wu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 91/97] drm/amd/display: phase2 enable mst hdcp multiple displays
Date: Wed,  7 May 2025 20:40:06 +0200
Message-ID: <20250507183810.635002520@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hersen wu <hersenxs.wu@amd.com>

[ Upstream commit aa9fdd5d5add50305d2022fa072fe6f189283415 ]

[why]
For MST topology with 1 physical link and multiple connectors (>=2),
e.g. daisy cahined MST + SST, or 1-to-multi MST hub, if userspace
set to enable the HDCP simultaneously on all connected outputs, the
commit tail iteratively call the hdcp_update_display() for each
display (connector). However, the hdcp workqueue data structure for
each link has only one DM connector and encryption status members,
which means the work queue of property_validate/update() would only
be triggered for the last connector within this physical link, and
therefore the HDCP property value of other connectors would stay on
DESIRED instead of switching to ENABLED, which is NOT as expected.

[how]
Use array of AMDGPU_DM_MAX_DISPLAY_INDEX for both aconnector and
encryption status in hdcp workqueue data structure for each physical
link. For property validate/update work queue, we iterates over the
array and do similar operation/check for each connected display.

Tested-by: Daniel Wheeler <Daniel.Wheeler@amd.com>
Signed-off-by: hersen wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: be593d9d91c5 ("drm/amd/display: Fix slab-use-after-free in hdcp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.c    | 160 +++++++++++++-----
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.h    |   5 +-
 2 files changed, 122 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 3f211c0308a2f..7fc26ca30dcd6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -170,9 +170,10 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 	struct mod_hdcp_display *display = &hdcp_work[link_index].display;
 	struct mod_hdcp_link *link = &hdcp_work[link_index].link;
 	struct mod_hdcp_display_query query;
+	unsigned int conn_index = aconnector->base.index;
 
 	mutex_lock(&hdcp_w->mutex);
-	hdcp_w->aconnector = aconnector;
+	hdcp_w->aconnector[conn_index] = aconnector;
 
 	query.display = NULL;
 	mod_hdcp_query_display(&hdcp_w->hdcp, aconnector->base.index, &query);
@@ -204,7 +205,7 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 					      msecs_to_jiffies(DRM_HDCP_CHECK_PERIOD_MS));
 		} else {
 			display->adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
-			hdcp_w->encryption_status = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+			hdcp_w->encryption_status[conn_index] = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
 			cancel_delayed_work(&hdcp_w->property_validate_dwork);
 		}
 
@@ -223,9 +224,10 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 {
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
 	struct drm_connector_state *conn_state = aconnector->base.state;
+	unsigned int conn_index = aconnector->base.index;
 
 	mutex_lock(&hdcp_w->mutex);
-	hdcp_w->aconnector = aconnector;
+	hdcp_w->aconnector[conn_index] = aconnector;
 
 	/* the removal of display will invoke auth reset -> hdcp destroy and
 	 * we'd expect the Content Protection (CP) property changed back to
@@ -247,13 +249,18 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_index)
 {
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
+	unsigned int conn_index;
 
 	mutex_lock(&hdcp_w->mutex);
 
 	mod_hdcp_reset_connection(&hdcp_w->hdcp,  &hdcp_w->output);
 
 	cancel_delayed_work(&hdcp_w->property_validate_dwork);
-	hdcp_w->encryption_status = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+		hdcp_w->encryption_status[conn_index] =
+			MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+	}
 
 	process_output(hdcp_w);
 
@@ -290,49 +297,83 @@ static void event_callback(struct work_struct *work)
 
 
 }
+
 static void event_property_update(struct work_struct *work)
 {
-
 	struct hdcp_workqueue *hdcp_work = container_of(work, struct hdcp_workqueue, property_update_work);
-	struct amdgpu_dm_connector *aconnector = hdcp_work->aconnector;
-	struct drm_device *dev = hdcp_work->aconnector->base.dev;
+	struct amdgpu_dm_connector *aconnector = NULL;
+	struct drm_device *dev;
 	long ret;
+	unsigned int conn_index;
+	struct drm_connector *connector;
+	struct drm_connector_state *conn_state;
 
-	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
-	mutex_lock(&hdcp_work->mutex);
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+		aconnector = hdcp_work->aconnector[conn_index];
 
+		if (!aconnector)
+			continue;
 
-	if (aconnector->base.state && aconnector->base.state->commit) {
-		ret = wait_for_completion_interruptible_timeout(&aconnector->base.state->commit->hw_done, 10 * HZ);
+		if (!aconnector->base.index)
+			continue;
 
-		if (ret == 0) {
-			DRM_ERROR("HDCP state unknown! Setting it to DESIRED");
-			hdcp_work->encryption_status = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
-		}
-	}
+		connector = &aconnector->base;
+
+		/* check if display connected */
+		if (connector->status != connector_status_connected)
+			continue;
 
-	if (aconnector->base.state) {
-		if (hdcp_work->encryption_status != MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF) {
-			if (aconnector->base.state->hdcp_content_type ==
+		conn_state = aconnector->base.state;
+
+		if (!conn_state)
+			continue;
+
+		dev = connector->dev;
+
+		if (!dev)
+			continue;
+
+		drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+		mutex_lock(&hdcp_work->mutex);
+
+		if (conn_state->commit) {
+			ret = wait_for_completion_interruptible_timeout(
+				&conn_state->commit->hw_done, 10 * HZ);
+			if (ret == 0) {
+				DRM_ERROR(
+					"HDCP state unknown! Setting it to DESIRED");
+				hdcp_work->encryption_status[conn_index] =
+					MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+			}
+		}
+		if (hdcp_work->encryption_status[conn_index] !=
+			MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF) {
+			if (conn_state->hdcp_content_type ==
 				DRM_MODE_HDCP_CONTENT_TYPE0 &&
-			hdcp_work->encryption_status <=
-				MOD_HDCP_ENCRYPTION_STATUS_HDCP2_TYPE0_ON)
-				drm_hdcp_update_content_protection(&aconnector->base,
+				hdcp_work->encryption_status[conn_index] <=
+				MOD_HDCP_ENCRYPTION_STATUS_HDCP2_TYPE0_ON) {
+
+				DRM_DEBUG_DRIVER("[HDCP_DM] DRM_MODE_CONTENT_PROTECTION_ENABLED\n");
+				drm_hdcp_update_content_protection(
+					connector,
 					DRM_MODE_CONTENT_PROTECTION_ENABLED);
-			else if (aconnector->base.state->hdcp_content_type ==
+			} else if (conn_state->hdcp_content_type ==
 					DRM_MODE_HDCP_CONTENT_TYPE1 &&
-				hdcp_work->encryption_status ==
-					MOD_HDCP_ENCRYPTION_STATUS_HDCP2_TYPE1_ON)
-				drm_hdcp_update_content_protection(&aconnector->base,
+					hdcp_work->encryption_status[conn_index] ==
+					MOD_HDCP_ENCRYPTION_STATUS_HDCP2_TYPE1_ON) {
+				drm_hdcp_update_content_protection(
+					connector,
 					DRM_MODE_CONTENT_PROTECTION_ENABLED);
+			}
 		} else {
-			drm_hdcp_update_content_protection(&aconnector->base,
-				DRM_MODE_CONTENT_PROTECTION_DESIRED);
+			DRM_DEBUG_DRIVER("[HDCP_DM] DRM_MODE_CONTENT_PROTECTION_DESIRED\n");
+			drm_hdcp_update_content_protection(
+				connector, DRM_MODE_CONTENT_PROTECTION_DESIRED);
+
 		}
+		mutex_unlock(&hdcp_work->mutex);
+		drm_modeset_unlock(&dev->mode_config.connection_mutex);
 	}
-
-	mutex_unlock(&hdcp_work->mutex);
-	drm_modeset_unlock(&dev->mode_config.connection_mutex);
 }
 
 static void event_property_validate(struct work_struct *work)
@@ -340,19 +381,51 @@ static void event_property_validate(struct work_struct *work)
 	struct hdcp_workqueue *hdcp_work =
 		container_of(to_delayed_work(work), struct hdcp_workqueue, property_validate_dwork);
 	struct mod_hdcp_display_query query;
-	struct amdgpu_dm_connector *aconnector = hdcp_work->aconnector;
-
-	if (!aconnector)
-		return;
+	struct amdgpu_dm_connector *aconnector;
+	unsigned int conn_index;
 
 	mutex_lock(&hdcp_work->mutex);
 
-	query.encryption_status = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
-	mod_hdcp_query_display(&hdcp_work->hdcp, aconnector->base.index, &query);
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX;
+	     conn_index++) {
+		aconnector = hdcp_work->aconnector[conn_index];
+
+
+		if (!aconnector)
+			continue;
+
+		if (!aconnector->base.index)
+			continue;
+
+		/* check if display connected */
+		if (aconnector->base.status != connector_status_connected)
+			continue;
 
-	if (query.encryption_status != hdcp_work->encryption_status) {
-		hdcp_work->encryption_status = query.encryption_status;
-		schedule_work(&hdcp_work->property_update_work);
+		if (!aconnector->base.state)
+			continue;
+
+		query.encryption_status = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+		mod_hdcp_query_display(&hdcp_work->hdcp, aconnector->base.index,
+				       &query);
+
+		DRM_DEBUG_DRIVER("[HDCP_DM] disp %d, connector->CP %u, (query, work): (%d, %d)\n",
+			aconnector->base.index,
+			aconnector->base.state->content_protection,
+			query.encryption_status,
+			hdcp_work->encryption_status[conn_index]);
+
+		if (query.encryption_status !=
+		    hdcp_work->encryption_status[conn_index]) {
+			DRM_DEBUG_DRIVER("[HDCP_DM] encryption_status change from %x to %x\n",
+				hdcp_work->encryption_status[conn_index], query.encryption_status);
+
+			hdcp_work->encryption_status[conn_index] =
+				query.encryption_status;
+
+			DRM_DEBUG_DRIVER("[HDCP_DM] trigger property_update_work\n");
+
+			schedule_work(&hdcp_work->property_update_work);
+		}
 	}
 
 	mutex_unlock(&hdcp_work->mutex);
@@ -687,6 +760,13 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct
 		hdcp_work[i].hdcp.config.ddc.funcs.read_i2c = lp_read_i2c;
 		hdcp_work[i].hdcp.config.ddc.funcs.write_dpcd = lp_write_dpcd;
 		hdcp_work[i].hdcp.config.ddc.funcs.read_dpcd = lp_read_dpcd;
+
+		memset(hdcp_work[i].aconnector, 0,
+		       sizeof(struct amdgpu_dm_connector *) *
+			       AMDGPU_DM_MAX_DISPLAY_INDEX);
+		memset(hdcp_work[i].encryption_status, 0,
+		       sizeof(enum mod_hdcp_encryption_status) *
+			       AMDGPU_DM_MAX_DISPLAY_INDEX);
 	}
 
 	cp_psp->funcs.update_stream_config = update_config;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
index bbbf7d0eff82f..69b445b011c8c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
@@ -43,7 +43,7 @@ struct hdcp_workqueue {
 	struct delayed_work callback_dwork;
 	struct delayed_work watchdog_timer_dwork;
 	struct delayed_work property_validate_dwork;
-	struct amdgpu_dm_connector *aconnector;
+	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_INDEX];
 	struct mutex mutex;
 
 	struct mod_hdcp hdcp;
@@ -51,8 +51,7 @@ struct hdcp_workqueue {
 	struct mod_hdcp_display display;
 	struct mod_hdcp_link link;
 
-	enum mod_hdcp_encryption_status encryption_status;
-
+	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_INDEX];
 	/* when display is unplugged from mst hub, connctor will be
 	 * destroyed within dm_dp_mst_connector_destroy. connector
 	 * hdcp perperties, like type, undesired, desired, enabled,
-- 
2.39.5



