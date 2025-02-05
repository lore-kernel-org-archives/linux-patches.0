Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076111519BF;
	Wed,  5 Feb 2025 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768044; cv=none; b=Q8gd6QFTrNOP45LxQt4ZGervaZEf3iXrc/6UAMFA9gTnKPkY7SFHtsbclyIbQ1DH+KyCzmZGzsIZH/9RlTCKR75fEkE2yLjOUbX0//MSfq+7cibFI7LMc5ShSUKGKwd8ya2Cj+kt+HTluHH5ZUp42HBVc6hdz6nfb6LgknHL91c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768044; c=relaxed/simple;
	bh=AG+vnkaTa4yJNMPlNKpcGv7fy8qVP1SujnPnH/fbcaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBj5mPq55efZ8E9JdGZzMGFITBB5teAA1h4Hy/HP7ncQB5iesU8jfP+bnF082V5x+xyZPcny3b4hf33++WLixIm26t5NvmDX2RVpXyxkg/1TnDKXJYMCIV61+OJOoI5xivzO4huO1qG9I7OteysJiKoowv9Gz38WVObrBmiPHkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrHxOXRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrHxOXRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B96BC4CED1;
	Wed,  5 Feb 2025 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768043;
	bh=AG+vnkaTa4yJNMPlNKpcGv7fy8qVP1SujnPnH/fbcaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrHxOXRu6TPY7w5VR/SCpKYevvwK+IgUMZtJeBSPWNiyCrbj7ePm1dFdyOVTHzZl3
	 mnCxgFcqBmiol9m2BqPyjhpXW/v9GeAfsUDY9ASiALf6putwciJcYYJggWDmLuHur2
	 88USrkq6thkhKd9h3A8BUp5F8z5n1XKs5N8qI0MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 545/590] drm/amd/display: Reduce accessing remote DPCD overhead
Date: Wed,  5 Feb 2025 14:45:00 +0100
Message-ID: <20250205134516.122457854@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Wayne Lin <Wayne.Lin@amd.com>

commit adb4998f4928a17d91be054218a902ba9f8c1f93 upstream.

[Why]
Observed frame rate get dropped by tool like glxgear. Even though the
output to monitor is 60Hz, the rendered frame rate drops to 30Hz lower.

It's due to code path in some cases will trigger
dm_dp_mst_is_port_support_mode() to read out remote Link status to
assess the available bandwidth for dsc maniplation. Overhead of keep
reading remote DPCD is considerable.

[How]
Store the remote link BW in mst_local_bw and use end-to-end full_pbn
as an indicator to decide whether update the remote link bw or not.

Whenever we need the info to assess the BW, visit the stored one first.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3720
Fixes: fa57924c76d9 ("drm/amd/display: Refactor function dm_dp_mst_is_port_support_mode()")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4a9a918545455a5979c6232fcf61ed3d8f0db3ae)
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   34 ++++++++----
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -697,6 +697,8 @@ struct amdgpu_dm_connector {
 	struct drm_dp_mst_port *mst_output_port;
 	struct amdgpu_dm_connector *mst_root;
 	struct drm_dp_aux *dsc_aux;
+	uint32_t mst_local_bw;
+	uint16_t vc_full_pbn;
 	struct mutex handle_mst_msg_ready;
 
 	/* TODO see if we can merge with ddc_bus or make a dm_connector */
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -155,6 +155,17 @@ amdgpu_dm_mst_connector_late_register(st
 	return 0;
 }
 
+
+static inline void
+amdgpu_dm_mst_reset_mst_connector_setting(struct amdgpu_dm_connector *aconnector)
+{
+	aconnector->edid = NULL;
+	aconnector->dsc_aux = NULL;
+	aconnector->mst_output_port->passthrough_aux = NULL;
+	aconnector->mst_local_bw = 0;
+	aconnector->vc_full_pbn = 0;
+}
+
 static void
 amdgpu_dm_mst_connector_early_unregister(struct drm_connector *connector)
 {
@@ -182,9 +193,7 @@ amdgpu_dm_mst_connector_early_unregister
 
 		dc_sink_release(dc_sink);
 		aconnector->dc_sink = NULL;
-		aconnector->edid = NULL;
-		aconnector->dsc_aux = NULL;
-		port->passthrough_aux = NULL;
+		amdgpu_dm_mst_reset_mst_connector_setting(aconnector);
 	}
 
 	aconnector->mst_status = MST_STATUS_DEFAULT;
@@ -500,9 +509,7 @@ dm_dp_mst_detect(struct drm_connector *c
 
 		dc_sink_release(aconnector->dc_sink);
 		aconnector->dc_sink = NULL;
-		aconnector->edid = NULL;
-		aconnector->dsc_aux = NULL;
-		port->passthrough_aux = NULL;
+		amdgpu_dm_mst_reset_mst_connector_setting(aconnector);
 
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			MST_REMOTE_EDID | MST_ALLOCATE_NEW_PAYLOAD | MST_CLEAR_ALLOCATED_PAYLOAD,
@@ -1815,9 +1822,18 @@ enum dc_status dm_dp_mst_is_port_support
 			struct drm_dp_mst_port *immediate_upstream_port = NULL;
 			uint32_t end_link_bw = 0;
 
-			/*Get last DP link BW capability*/
-			if (dp_get_link_current_set_bw(&aconnector->mst_output_port->aux, &end_link_bw)) {
-				if (stream_kbps > end_link_bw) {
+			/*Get last DP link BW capability. Mode shall be supported by Legacy peer*/
+			if (aconnector->mst_output_port->pdt != DP_PEER_DEVICE_DP_LEGACY_CONV &&
+				aconnector->mst_output_port->pdt != DP_PEER_DEVICE_NONE) {
+				if (aconnector->vc_full_pbn != aconnector->mst_output_port->full_pbn) {
+					dp_get_link_current_set_bw(&aconnector->mst_output_port->aux, &end_link_bw);
+					aconnector->vc_full_pbn = aconnector->mst_output_port->full_pbn;
+					aconnector->mst_local_bw = end_link_bw;
+				} else {
+					end_link_bw = aconnector->mst_local_bw;
+				}
+
+				if (end_link_bw > 0 && stream_kbps > end_link_bw) {
 					DRM_DEBUG_DRIVER("MST_DSC dsc decode at last link."
 							 "Mode required bw can't fit into last link\n");
 					return DC_FAIL_BANDWIDTH_VALIDATE;


