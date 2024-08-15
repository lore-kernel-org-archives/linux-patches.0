Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0BC1714A8;
	Thu, 15 Aug 2024 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729134; cv=none; b=ORt9E7jkSIPZqyB1k98VdegB/dBwRddUIqCcFy9350jC4caZFriBunnPX3mXwYBEEkmBjNlL0/arKzqB10/8VyYLehOANGN2h21cnEpar02qQ4PyniCnEM5sHaOiN4g+gnpthTJ3J5YL4YdKJaaZ5Rd7fO1t3y+Q+NC0FyH8urQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729134; c=relaxed/simple;
	bh=QWKlSzPrYEH4QmKyYQX3CxKxEOQ1+0ylXweRWwPtOCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMPIa6Mbjf8omRSuYiqrN3vvy6+bBi9M6wGKfXIdddNCb5bMUa1HFmsah5JtuszffESU7FvXR1CnCdzTRIr7WOl7kZO3l3RjvMyjZ6DTdBKMvcuvtiL1UM34z2ZRf7nZLiMGlOs60BN7czum2ttdi8bt5522BVZJlriXvOyyuoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpP54vyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpP54vyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E375DC32786;
	Thu, 15 Aug 2024 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729134;
	bh=QWKlSzPrYEH4QmKyYQX3CxKxEOQ1+0ylXweRWwPtOCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpP54vyxrK25O99qpOXKU31GhccLg/jszH/6jWuXUnMgzotB8GD/RDJ3XvvUs6AO6
	 wHMGbrAtkc9omE0/xgMl/ocvq19c9EWYuwLIQcGEgs1sfX8F0m5px4jSBEEFzzkYx1
	 nTvVR9sN1Sjhny1xcr/BizyPaH4xbImOHGN09uAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Kevin Holm <kevin@holm.dev>
Subject: [PATCH 6.10 04/22] drm/amd/display: Prevent IPX From Link Detect and Set Mode
Date: Thu, 15 Aug 2024 15:25:12 +0200
Message-ID: <20240815131831.435325389@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <jerry.zuo@amd.com>

commit 1ff6631baeb1f5d69be192732d0157a06b43f20a upstream.

IPX involvment proven to affect LT, causing link loss. Need to prevent
IPX enabled in LT process in which link detect and set mode are main
procedures that have LT taken place.

Reviewed-by: Roman Li <roman.li@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Kevin Holm <kevin@holm.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2943,6 +2943,7 @@ static int dm_resume(void *handle)
 
 		commit_params.streams = dc_state->streams;
 		commit_params.stream_count = dc_state->stream_count;
+		dc_exit_ips_for_hw_access(dm->dc);
 		WARN_ON(!dc_commit_streams(dm->dc, &commit_params));
 
 		dm_gpureset_commit_state(dm->cached_dc_state, dm);
@@ -3015,6 +3016,7 @@ static int dm_resume(void *handle)
 			emulated_link_detect(aconnector->dc_link);
 		} else {
 			mutex_lock(&dm->dc_lock);
+			dc_exit_ips_for_hw_access(dm->dc);
 			dc_link_detect(aconnector->dc_link, DETECT_REASON_HPD);
 			mutex_unlock(&dm->dc_lock);
 		}
@@ -3351,6 +3353,7 @@ static void handle_hpd_irq_helper(struct
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	struct dm_connector_state *dm_con_state = to_dm_connector_state(connector->state);
+	struct dc *dc = aconnector->dc_link->ctx->dc;
 	bool ret = false;
 
 	if (adev->dm.disable_hpd_irq)
@@ -3385,6 +3388,7 @@ static void handle_hpd_irq_helper(struct
 			drm_kms_helper_connector_hotplug_event(connector);
 	} else {
 		mutex_lock(&adev->dm.dc_lock);
+		dc_exit_ips_for_hw_access(dc);
 		ret = dc_link_detect(aconnector->dc_link, DETECT_REASON_HPD);
 		mutex_unlock(&adev->dm.dc_lock);
 		if (ret) {
@@ -3444,6 +3448,7 @@ static void handle_hpd_rx_irq(void *para
 	bool has_left_work = false;
 	int idx = dc_link->link_index;
 	struct hpd_rx_irq_offload_work_queue *offload_wq = &adev->dm.hpd_rx_offload_wq[idx];
+	struct dc *dc = aconnector->dc_link->ctx->dc;
 
 	memset(&hpd_irq_data, 0, sizeof(hpd_irq_data));
 
@@ -3533,6 +3538,7 @@ out:
 			bool ret = false;
 
 			mutex_lock(&adev->dm.dc_lock);
+			dc_exit_ips_for_hw_access(dc);
 			ret = dc_link_detect(dc_link, DETECT_REASON_HPDRX);
 			mutex_unlock(&adev->dm.dc_lock);
 
@@ -4639,6 +4645,7 @@ static int amdgpu_dm_initialize_drm_devi
 			bool ret = false;
 
 			mutex_lock(&dm->dc_lock);
+			dc_exit_ips_for_hw_access(dm->dc);
 			ret = dc_link_detect(link, DETECT_REASON_BOOT);
 			mutex_unlock(&dm->dc_lock);
 
@@ -8947,6 +8954,7 @@ static void amdgpu_dm_commit_streams(str
 
 			memset(&position, 0, sizeof(position));
 			mutex_lock(&dm->dc_lock);
+			dc_exit_ips_for_hw_access(dm->dc);
 			dc_stream_program_cursor_position(dm_old_crtc_state->stream, &position);
 			mutex_unlock(&dm->dc_lock);
 		}
@@ -9016,6 +9024,7 @@ static void amdgpu_dm_commit_streams(str
 
 	dm_enable_per_frame_crtc_master_sync(dc_state);
 	mutex_lock(&dm->dc_lock);
+	dc_exit_ips_for_hw_access(dm->dc);
 	WARN_ON(!dc_commit_streams(dm->dc, &params));
 
 	/* Allow idle optimization when vblank count is 0 for display off */
@@ -9381,6 +9390,7 @@ static void amdgpu_dm_atomic_commit_tail
 
 
 		mutex_lock(&dm->dc_lock);
+		dc_exit_ips_for_hw_access(dm->dc);
 		dc_update_planes_and_stream(dm->dc,
 					    dummy_updates,
 					    status->plane_count,


