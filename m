Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFF01DDC23;
	Wed,  7 May 2025 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643755; cv=none; b=qFfHiDWjf0ddSGAmPZvBPe0YsWjH2ILWwZQQ/JffqydZ6w+8CLpO4s3D34w25dqRb0HPOExc1pRPhzk68m09/pNVCeI1CMMWPeSbiYPYRchhUcqTYvE9ZcAvaGdkxAxfHVSh5NEyrYihrIjYUm/LpRnJEwwiWKnxDvmy6OMmh7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643755; c=relaxed/simple;
	bh=yCYoQDR7kwKX5YvSO53jY25j8gKC3MoY62XJLu8gruY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU3puXwDc7iFIls2B4+TsjPXQIRfoFIUogGn/mAwF7zP69F6wxounEJjh5ewrz5ITEZv6wWawTlWl+CUJkio6DMW1hxSouYDCqsp26daiwl7RBpVdBYsiJpN5ZXHl4z8prqA/G5J2jAbKUJzRhIU62DDBE7i2c3GdwTOhmcxsfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs/+69cP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs/+69cP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0397C4CEE2;
	Wed,  7 May 2025 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643754;
	bh=yCYoQDR7kwKX5YvSO53jY25j8gKC3MoY62XJLu8gruY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qs/+69cP8el2l/pLHikQVuzzi424GdgfpZ3iDXIlYLBg+AOqY8xTI/GYRO+YVbEPP
	 TfZbkrELAC2A+c+uLXFFPL+vUMnGwpK4KjAps0RGwOmIDHLxkW9LH+z23lb5aSiH4g
	 L0ITWCFt7UMmZzj9BdXIRormlaBUddzr8cIXhlKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 93/97] drm/amd/display: Change HDCP update sequence for DM
Date: Wed,  7 May 2025 20:40:08 +0200
Message-ID: <20250507183810.714628932@linuxfoundation.org>
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

From: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>

[ Upstream commit 393e83484839970e4975dfa1f0666f939a6f3e3d ]

Refactor the sequence in hdcp_update_display() to use
mod_hdcp_update_display().

Previous sequence:
	- remove()->add()

This Sequence was used to update the display, (mod_hdcp_update_display
didn't exist at the time). This meant for any hdcp updates (type changes,
enable/disable) we would remove, reconstruct, and add. This leads to
unnecessary calls to psp eventually

New Sequence using mod_hdcp_update_display():
	- add() once when stream is enabled
	- use update() for all updates

The update function checks for prev == new states and will not
unnecessarily end up calling psp via add/remove.

Reviewed-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: be593d9d91c5 ("drm/amd/display: Fix slab-use-after-free in hdcp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.c    | 80 +++++++++----------
 1 file changed, 38 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 15537f554ca86..7c67bb771f996 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -168,53 +168,45 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 			 bool enable_encryption)
 {
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
-	struct mod_hdcp_display *display = &hdcp_work[link_index].display;
-	struct mod_hdcp_link *link = &hdcp_work[link_index].link;
-	struct mod_hdcp_display_query query;
+	struct mod_hdcp_link_adjustment link_adjust;
+	struct mod_hdcp_display_adjustment display_adjust;
 	unsigned int conn_index = aconnector->base.index;
 
 	mutex_lock(&hdcp_w->mutex);
 	hdcp_w->aconnector[conn_index] = aconnector;
 
-	query.display = NULL;
-	mod_hdcp_query_display(&hdcp_w->hdcp, aconnector->base.index, &query);
-
-	if (query.display) {
-		memcpy(display, query.display, sizeof(struct mod_hdcp_display));
-		mod_hdcp_remove_display(&hdcp_w->hdcp, aconnector->base.index, &hdcp_w->output);
-
-		hdcp_w->link.adjust.hdcp2.force_type = MOD_HDCP_FORCE_TYPE_0;
-
-		if (enable_encryption) {
-			/* Explicitly set the saved SRM as sysfs call will be after
-			 * we already enabled hdcp (s3 resume case)
-			 */
-			if (hdcp_work->srm_size > 0)
-				psp_set_srm(hdcp_work->hdcp.config.psp.handle, hdcp_work->srm,
-					    hdcp_work->srm_size,
-					    &hdcp_work->srm_version);
-
-			display->adjust.disable = MOD_HDCP_DISPLAY_NOT_DISABLE;
-			if (content_type == DRM_MODE_HDCP_CONTENT_TYPE0) {
-				hdcp_w->link.adjust.hdcp1.disable = 0;
-				hdcp_w->link.adjust.hdcp2.force_type = MOD_HDCP_FORCE_TYPE_0;
-			} else if (content_type == DRM_MODE_HDCP_CONTENT_TYPE1) {
-				hdcp_w->link.adjust.hdcp1.disable = 1;
-				hdcp_w->link.adjust.hdcp2.force_type = MOD_HDCP_FORCE_TYPE_1;
-			}
+	memset(&link_adjust, 0, sizeof(link_adjust));
+	memset(&display_adjust, 0, sizeof(display_adjust));
 
-			schedule_delayed_work(&hdcp_w->property_validate_dwork,
-					      msecs_to_jiffies(DRM_HDCP_CHECK_PERIOD_MS));
-		} else {
-			display->adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
-			hdcp_w->encryption_status[conn_index] = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
-			cancel_delayed_work(&hdcp_w->property_validate_dwork);
+	if (enable_encryption) {
+		/* Explicitly set the saved SRM as sysfs call will be after we already enabled hdcp
+		 * (s3 resume case)
+		 */
+		if (hdcp_work->srm_size > 0)
+			psp_set_srm(hdcp_work->hdcp.config.psp.handle, hdcp_work->srm,
+				    hdcp_work->srm_size,
+				    &hdcp_work->srm_version);
+
+		display_adjust.disable = MOD_HDCP_DISPLAY_NOT_DISABLE;
+
+		link_adjust.auth_delay = 2;
+
+		if (content_type == DRM_MODE_HDCP_CONTENT_TYPE0) {
+			link_adjust.hdcp2.force_type = MOD_HDCP_FORCE_TYPE_0;
+		} else if (content_type == DRM_MODE_HDCP_CONTENT_TYPE1) {
+			link_adjust.hdcp1.disable = 1;
+			link_adjust.hdcp2.force_type = MOD_HDCP_FORCE_TYPE_1;
 		}
 
-		display->state = MOD_HDCP_DISPLAY_ACTIVE;
+		schedule_delayed_work(&hdcp_w->property_validate_dwork,
+				      msecs_to_jiffies(DRM_HDCP_CHECK_PERIOD_MS));
+	} else {
+		display_adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
+		hdcp_w->encryption_status[conn_index] = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+		cancel_delayed_work(&hdcp_w->property_validate_dwork);
 	}
 
-	mod_hdcp_add_display(&hdcp_w->hdcp, link, display, &hdcp_w->output);
+	mod_hdcp_update_display(&hdcp_w->hdcp, conn_index, &link_adjust, &display_adjust, &hdcp_w->output);
 
 	process_output(hdcp_w);
 	mutex_unlock(&hdcp_w->mutex);
@@ -521,7 +513,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	int link_index = aconnector->dc_link->link_index;
 	struct mod_hdcp_display *display = &hdcp_work[link_index].display;
 	struct mod_hdcp_link *link = &hdcp_work[link_index].link;
-	struct drm_connector_state *conn_state;
+	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
 	struct dc_sink *sink = NULL;
 	bool link_is_hdcp14 = false;
 
@@ -563,7 +555,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	display->adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
 	link->adjust.auth_delay = 3;
 	link->adjust.hdcp1.disable = 0;
-	conn_state = aconnector->base.state;
+	hdcp_w->encryption_status[display->index] = MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
 
 	DRM_DEBUG_DRIVER("[HDCP_DM] display %d, CP %d, type %d\n", aconnector->base.index,
 			 (!!aconnector->base.state) ?
@@ -571,9 +563,13 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 			 (!!aconnector->base.state) ?
 			 aconnector->base.state->hdcp_content_type : -1);
 
-	if (conn_state)
-		hdcp_update_display(hdcp_work, link_index, aconnector,
-				    conn_state->hdcp_content_type, false);
+	mutex_lock(&hdcp_w->mutex);
+
+	mod_hdcp_add_display(&hdcp_w->hdcp, link, display, &hdcp_w->output);
+
+	process_output(hdcp_w);
+	mutex_unlock(&hdcp_w->mutex);
+
 }
 
 /**
-- 
2.39.5



