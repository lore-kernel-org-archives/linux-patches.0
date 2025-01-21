Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3B31F3FFE;
	Tue, 21 Jan 2025 18:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482562; cv=none; b=MAyDBfP7C9q5h8TyvxawhxlsBWmqW+HZ24tKQo/szNWSFWwRE9B1TBacYw7zuTmrtuirPqpvW+rDAP5u7T6RNwjo0K5/AyqGaC9jmZQ0SYPJldUWqGdtg8Z/bI4mw37f+oQLotS0eT0CUDC7VFfZntVVxuJR7YL3bOA9J4Jgf3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482562; c=relaxed/simple;
	bh=nb9AjIKlyvYAuGuF3YFsNCpDmGjhc5Co0VbkCY5hIlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baPPMhABg88KrnDeTiVX18DQeWBOeOvYyl92PfexH5H1hQBX6AeajsLOMYVqTCHtP9Q8gSLtTmGfhCjPAbZnyyHIpCJjxipvMzqmFZRA11f/xC37WfSU5geozewSr7LnDoH2KiAaTXM4iCephK/uTUn9klcM3TJOe76qHQJkDcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWfDoJZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWfDoJZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05306C4CEDF;
	Tue, 21 Jan 2025 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482562;
	bh=nb9AjIKlyvYAuGuF3YFsNCpDmGjhc5Co0VbkCY5hIlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWfDoJZc8RRTlU9LvoeZo2O2Zo3wfF7G9mSB6gOGC67Pl8ybMw9CGAXn7Z1P2ZQdl
	 sBdKlAhD2nJFnAu0uXHYOCWyYJMs/MieuJ/AULBYjIbSJn4ayDnpr31HPn3q8uDBTA
	 tVNHCDS0fT5HQWwqNG/kD5iHFw9g/NWmxbAqHHIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 119/122] drm/amd/display: Do not wait for PSR disable on vbl enable
Date: Tue, 21 Jan 2025 18:52:47 +0100
Message-ID: <20250121174537.642503569@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit ff2e4d874726c549130308b6b46aa0f8a34e04cb upstream.

[Why]

Outside of a modeset/link configuration change, we should not have to
wait for the panel to exit PSR. Depending on the panel and it's state,
it may take multiple frames for it to exit PSR. Therefore, waiting in
all scenarios may cause perceived stuttering, especially in combination
with faster vblank shutdown.

[How]

PSR1 disable is hooked up to the vblank enable event, and vice versa. In
case of vblank enable, do not wait for panel to exit PSR, but still wait
in all other cases.

We also avoid a call to unnecessarily change power_opts on disable -
this ends up sending another command to dmcub fw.

When testing against IGT, some crc tests like kms_plane_alpha_blend and
amd_hotplug were failing due to CRC timeouts. This was found to be
caused by the early return before HW has fully exited PSR1. Fix this by
first making sure we grab a vblank reference, then waiting for panel to
exit PSR1, before programming hw for CRC generation.

Fixes: 58a261bfc967 ("drm/amd/display: use a more lax vblank enable policy for older ASICs")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3743
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit aa6713fa2046f4c09bf3013dd1420ae15603ca6f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         |    4 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c     |   25 ++++++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c    |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c     |   35 ++++++++++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h     |    3 -
 6 files changed, 54 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9095,7 +9095,7 @@ static void amdgpu_dm_commit_planes(stru
 				acrtc_state->stream->link->psr_settings.psr_dirty_rects_change_timestamp_ns =
 				timestamp_ns;
 				if (acrtc_state->stream->link->psr_settings.psr_allow_active)
-					amdgpu_dm_psr_disable(acrtc_state->stream);
+					amdgpu_dm_psr_disable(acrtc_state->stream, true);
 				mutex_unlock(&dm->dc_lock);
 			}
 		}
@@ -9265,7 +9265,7 @@ static void amdgpu_dm_commit_planes(stru
 			if (acrtc_state->stream->link->replay_settings.replay_allow_active)
 				amdgpu_dm_replay_disable(acrtc_state->stream);
 			if (acrtc_state->stream->link->psr_settings.psr_allow_active)
-				amdgpu_dm_psr_disable(acrtc_state->stream);
+				amdgpu_dm_psr_disable(acrtc_state->stream, true);
 		}
 		mutex_unlock(&dm->dc_lock);
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -30,6 +30,7 @@
 #include "amdgpu_dm.h"
 #include "dc.h"
 #include "amdgpu_securedisplay.h"
+#include "amdgpu_dm_psr.h"
 
 static const char *const pipe_crc_sources[] = {
 	"none",
@@ -224,6 +225,10 @@ int amdgpu_dm_crtc_configure_crc_source(
 
 	mutex_lock(&adev->dm.dc_lock);
 
+	/* For PSR1, check that the panel has exited PSR */
+	if (stream_state->link->psr_settings.psr_version < DC_PSR_VERSION_SU_1)
+		amdgpu_dm_psr_wait_disable(stream_state);
+
 	/* Enable or disable CRTC CRC generation */
 	if (dm_is_crc_source_crtc(source) || source == AMDGPU_DM_PIPE_CRC_SOURCE_NONE) {
 		if (!dc_stream_configure_crc(stream_state->ctx->dc,
@@ -357,6 +362,17 @@ int amdgpu_dm_crtc_set_crc_source(struct
 
 	}
 
+	/*
+	 * Reading the CRC requires the vblank interrupt handler to be
+	 * enabled. Keep a reference until CRC capture stops.
+	 */
+	enabled = amdgpu_dm_is_valid_crc_source(cur_crc_src);
+	if (!enabled && enable) {
+		ret = drm_crtc_vblank_get(crtc);
+		if (ret)
+			goto cleanup;
+	}
+
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
 	/* Reset secure_display when we change crc source from debugfs */
 	amdgpu_dm_set_crc_window_default(crtc, crtc_state->stream);
@@ -367,16 +383,7 @@ int amdgpu_dm_crtc_set_crc_source(struct
 		goto cleanup;
 	}
 
-	/*
-	 * Reading the CRC requires the vblank interrupt handler to be
-	 * enabled. Keep a reference until CRC capture stops.
-	 */
-	enabled = amdgpu_dm_is_valid_crc_source(cur_crc_src);
 	if (!enabled && enable) {
-		ret = drm_crtc_vblank_get(crtc);
-		if (ret)
-			goto cleanup;
-
 		if (dm_is_crc_source_dprx(source)) {
 			if (drm_dp_start_crc(aux, crtc)) {
 				DRM_DEBUG_DRIVER("dp start crc failed\n");
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -142,7 +142,7 @@ static void amdgpu_dm_crtc_set_panel_sr_
 		amdgpu_dm_replay_enable(vblank_work->stream, true);
 	} else if (vblank_enabled) {
 		if (link->psr_settings.psr_version < DC_PSR_VERSION_SU_1 && is_sr_active)
-			amdgpu_dm_psr_disable(vblank_work->stream);
+			amdgpu_dm_psr_disable(vblank_work->stream, false);
 	} else if (link->psr_settings.psr_feature_enabled &&
 		allow_sr_entry && !is_sr_active && !is_crc_window_active) {
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -3638,7 +3638,7 @@ static int crc_win_update_set(void *data
 		/* PSR may write to OTG CRC window control register,
 		 * so close it before starting secure_display.
 		 */
-		amdgpu_dm_psr_disable(acrtc->dm_irq_params.stream);
+		amdgpu_dm_psr_disable(acrtc->dm_irq_params.stream, true);
 
 		spin_lock_irq(&adev_to_drm(adev)->event_lock);
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -201,14 +201,13 @@ void amdgpu_dm_psr_enable(struct dc_stre
  *
  * Return: true if success
  */
-bool amdgpu_dm_psr_disable(struct dc_stream_state *stream)
+bool amdgpu_dm_psr_disable(struct dc_stream_state *stream, bool wait)
 {
-	unsigned int power_opt = 0;
 	bool psr_enable = false;
 
 	DRM_DEBUG_DRIVER("Disabling psr...\n");
 
-	return dc_link_set_psr_allow_active(stream->link, &psr_enable, true, false, &power_opt);
+	return dc_link_set_psr_allow_active(stream->link, &psr_enable, wait, false, NULL);
 }
 
 /*
@@ -251,3 +250,33 @@ bool amdgpu_dm_psr_is_active_allowed(str
 
 	return allow_active;
 }
+
+/**
+ * amdgpu_dm_psr_wait_disable() - Wait for eDP panel to exit PSR
+ * @stream: stream state attached to the eDP link
+ *
+ * Waits for a max of 500ms for the eDP panel to exit PSR.
+ *
+ * Return: true if panel exited PSR, false otherwise.
+ */
+bool amdgpu_dm_psr_wait_disable(struct dc_stream_state *stream)
+{
+	enum dc_psr_state psr_state = PSR_STATE0;
+	struct dc_link *link = stream->link;
+	int retry_count;
+
+	if (link == NULL)
+		return false;
+
+	for (retry_count = 0; retry_count <= 1000; retry_count++) {
+		dc_link_get_psr_state(link, &psr_state);
+		if (psr_state == PSR_STATE0)
+			break;
+		udelay(500);
+	}
+
+	if (retry_count == 1000)
+		return false;
+
+	return true;
+}
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h
@@ -34,8 +34,9 @@
 void amdgpu_dm_set_psr_caps(struct dc_link *link);
 void amdgpu_dm_psr_enable(struct dc_stream_state *stream);
 bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream);
-bool amdgpu_dm_psr_disable(struct dc_stream_state *stream);
+bool amdgpu_dm_psr_disable(struct dc_stream_state *stream, bool wait);
 bool amdgpu_dm_psr_disable_all(struct amdgpu_display_manager *dm);
 bool amdgpu_dm_psr_is_active_allowed(struct amdgpu_display_manager *dm);
+bool amdgpu_dm_psr_wait_disable(struct dc_stream_state *stream);
 
 #endif /* AMDGPU_DM_AMDGPU_DM_PSR_H_ */


