Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A5E1DE8BA;
	Tue,  8 Oct 2024 12:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391332; cv=none; b=XOVvQW8wALgfQsEpBj0Zl4HOUj4DSkE1j+Bpn1WE4/L2rtciZ9D/jVtKwmo4gjoFJpod+RJ0ke2wNPUMbDAuTt8wBsx/XlKvZL69eNm8Bez7xfhE+SDm1jBUEN1mA22awLdf8Ts7x6ew/XC+8mz41Qv2weRyqvDdxe17dAzi/es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391332; c=relaxed/simple;
	bh=nE2TvYUEQfCa86HuvipNIcBM18rZk+iXvfiStG7pSwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU+hY8d327xNbgZkQeV/pJQEWqrI//KdMSwNM06SfRkIV5TeeqvPPq8J3MSdrCkx0QVf93S8+IB3p9wyTpr1uPBLoB66m/rNekh/Wc3z8JEzGlBCu/iJBjbaxuQPJfdT/rjV96GEwwyhwdYA5+GhIp66xZhSRbzR5OgPVitwZ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WURVJd2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WURVJd2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC8BC4CEC7;
	Tue,  8 Oct 2024 12:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391331;
	bh=nE2TvYUEQfCa86HuvipNIcBM18rZk+iXvfiStG7pSwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WURVJd2KMZBSUXefuRM5MMYy9OXgw4mzbhenXVnYIHjZgQQVfTrn9n8KUmeyE2AiN
	 8OifJb/TqQbvw/zIPDWmt03GP5RTZm+Uy93wGyyLJR2x+QHY5CLUd7FCcCBI0re0if
	 y6XcomIHksgCLHVkPEGq4s/3jfRBPg5N13kH8iPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 081/558] drm/amd/display: Fix VRR cannot enable
Date: Tue,  8 Oct 2024 14:01:51 +0200
Message-ID: <20241008115705.562890722@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit f91a9af09dea850d83d4b217b8acbafd97b5c61f ]

[Why]
Sometimes the VRR cannot enable after login to the desktop.

User space may call the DRM_IOCTL_MODE_GETCONNECTOR right after
the DRM_IOCTL_MODE_RMFB.

After calling DRM_IOCTL_MODE_RMFB to remove all the frame buffer
and it will cause the driver to disable the crtc and disable the
link while calling the link_set_dpms_off().

It will cause the dpcd read failed in amdgpu_dm_update_freesync_caps()
while try to get the DP_MSA_TIMING_PAR_IGNORED capability and think
the sink side does not support VRR.

[How]
Use the dpcd_caps.allow_invalid_MSA_timing_param flag instead of
reading from dpcd directly.

dpcd_caps.allow_invalid_MSA_timing_param flag is updated during HPD.
It is safe to replace the original method.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 23 ++-----------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a705e7fa18c06..9ee54c5ce4a61 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11812,25 +11812,6 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	return ret;
 }
 
-static bool is_dp_capable_without_timing_msa(struct dc *dc,
-					     struct amdgpu_dm_connector *amdgpu_dm_connector)
-{
-	u8 dpcd_data;
-	bool capable = false;
-
-	if (amdgpu_dm_connector->dc_link &&
-		dm_helpers_dp_read_dpcd(
-				NULL,
-				amdgpu_dm_connector->dc_link,
-				DP_DOWN_STREAM_PORT_COUNT,
-				&dpcd_data,
-				sizeof(dpcd_data))) {
-		capable = (dpcd_data & DP_MSA_TIMING_PAR_IGNORED) ? true:false;
-	}
-
-	return capable;
-}
-
 static bool dm_edid_parser_send_cea(struct amdgpu_display_manager *dm,
 		unsigned int offset,
 		unsigned int total_length,
@@ -12133,8 +12114,8 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 		     sink->sink_signal == SIGNAL_TYPE_EDP)) {
 		bool edid_check_required = false;
 
-		if (is_dp_capable_without_timing_msa(adev->dm.dc,
-						     amdgpu_dm_connector)) {
+		if (amdgpu_dm_connector->dc_link &&
+		    amdgpu_dm_connector->dc_link->dpcd_caps.allow_invalid_MSA_timing_param) {
 			if (edid->features & DRM_EDID_FEATURE_CONTINUOUS_FREQ) {
 				amdgpu_dm_connector->min_vfreq = connector->display_info.monitor_range.min_vfreq;
 				amdgpu_dm_connector->max_vfreq = connector->display_info.monitor_range.max_vfreq;
-- 
2.43.0



