Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F52153F4;
	Thu, 12 Dec 2024 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017021; cv=none; b=oAy2YKijLOVhy69Fy0+8Vkry5JteVKDm9vaHeLOT31jzm/FGY28RoP5P3imIL1gonZKOydOgcCPhrOXIAfuuFRQp04In0BdvSwyjLQCLZAVIV1EKTMzLG9CGd7ypZE7BPmaLPK8M2v1mY4rrtW/YCYKHVrqE1D3ruljlgYqKYBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017021; c=relaxed/simple;
	bh=9sHPJle6vviKxiwv/dZWbvVOpRf6fqMtnZo3eLGhhzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg1ocMVNpJy+n+fWPJi6OBod4kgdaZMntgbETaA2vA3b/SjkwQOtnxhmWV4gVwPqhMvUjAjNmSj5C+YC7x4xX5mqDcPY1W4G+u/SJ9exSNTJpCXVdrmjSJuL0zC7i5acAcP+ixXUrfX2ELaRdGQSDOH2QDBkM1oq9nMt+CYtA3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4bBhySr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4bBhySr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A883C4CECE;
	Thu, 12 Dec 2024 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017021;
	bh=9sHPJle6vviKxiwv/dZWbvVOpRf6fqMtnZo3eLGhhzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4bBhySrPxhTPDc0FaDCccIMKcAz2DXA/1z9e+stRmIVXjCGawqVG9v6snT2ktLy5
	 o4qrwb+tYrowJ48YPr2IOWvu0oVjHB2yZGbDLHh4uxZGtp/606U6OT4DUd0xUAsFLb
	 /Ynx+mwtUAvsfbE2mNA/yCA3iMtNfnh9iplDRwTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/466] drm/amd/display: Prune Invalid Modes For HDMI Output
Date: Thu, 12 Dec 2024 15:58:17 +0100
Message-ID: <20241212144319.745464185@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit abdd2768d7630bc8ec3403aea24f4197bada3c1f ]

[Why]
1. HDMI does not have 6 bpc support. Having 6 bpc pass validation
does not comply with spec.
2. Validate 420 only for native HDMI, but not apply to pcon use
case.
3. Current mode validation log is not readable.

[how]
1. Cap 8 bpc for dp-hdmi converter.
2. Validate yuv420 for pcon use case as well,
   if rgb/yuv444 8bpc cannot fit into pcon bw limitation of
   the link from the converter to HDMI sink.
3. Add readable pixel_format and color_depth into debug log.

Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 19 ++++++---
 .../gpu/drm/amd/display/dc/core/dc_debug.c    | 40 +++++++++++++++++++
 .../gpu/drm/amd/display/dc/core/dc_stream.c   |  6 +--
 .../gpu/drm/amd/display/dc/inc/core_status.h  |  2 +
 4 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8c3db8346f300..ad3a3aa72b51f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7341,10 +7341,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	const struct drm_connector_state *drm_state = dm_state ? &dm_state->base : NULL;
 	int requested_bpc = drm_state ? drm_state->max_requested_bpc : 8;
 	enum dc_status dc_result = DC_OK;
+	uint8_t bpc_limit = 6;
 
 	if (!dm_state)
 		return NULL;
 
+	if (aconnector->dc_link->connector_signal == SIGNAL_TYPE_HDMI_TYPE_A ||
+	    aconnector->dc_link->dpcd_caps.dongle_type == DISPLAY_DONGLE_DP_HDMI_CONVERTER)
+		bpc_limit = 8;
+
 	do {
 		stream = create_stream_for_sink(connector, drm_mode,
 						dm_state, old_stream,
@@ -7365,11 +7370,12 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 			dc_result = dm_validate_stream_and_context(adev->dm.dc, stream);
 
 		if (dc_result != DC_OK) {
-			DRM_DEBUG_KMS("Mode %dx%d (clk %d) failed DC validation with error %d (%s)\n",
+			DRM_DEBUG_KMS("Mode %dx%d (clk %d) pixel_encoding:%s color_depth:%s failed validation -- %s\n",
 				      drm_mode->hdisplay,
 				      drm_mode->vdisplay,
 				      drm_mode->clock,
-				      dc_result,
+				      dc_pixel_encoding_to_str(stream->timing.pixel_encoding),
+				      dc_color_depth_to_str(stream->timing.display_color_depth),
 				      dc_status_to_str(dc_result));
 
 			dc_stream_release(stream);
@@ -7377,10 +7383,13 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 			requested_bpc -= 2; /* lower bpc to retry validation */
 		}
 
-	} while (stream == NULL && requested_bpc >= 6);
+	} while (stream == NULL && requested_bpc >= bpc_limit);
 
-	if (dc_result == DC_FAIL_ENC_VALIDATE && !aconnector->force_yuv420_output) {
-		DRM_DEBUG_KMS("Retry forcing YCbCr420 encoding\n");
+	if ((dc_result == DC_FAIL_ENC_VALIDATE ||
+	     dc_result == DC_EXCEED_DONGLE_CAP) &&
+	     !aconnector->force_yuv420_output) {
+		DRM_DEBUG_KMS("%s:%d Retry forcing yuv420 encoding\n",
+				     __func__, __LINE__);
 
 		aconnector->force_yuv420_output = true;
 		stream = create_validate_stream_for_sink(aconnector, drm_mode,
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_debug.c b/drivers/gpu/drm/amd/display/dc/core/dc_debug.c
index 801cdbc8117d9..e255c204b7e85 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_debug.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_debug.c
@@ -434,3 +434,43 @@ char *dc_status_to_str(enum dc_status status)
 
 	return "Unexpected status error";
 }
+
+char *dc_pixel_encoding_to_str(enum dc_pixel_encoding pixel_encoding)
+{
+	switch (pixel_encoding) {
+	case PIXEL_ENCODING_RGB:
+		return "RGB";
+	case PIXEL_ENCODING_YCBCR422:
+		return "YUV422";
+	case PIXEL_ENCODING_YCBCR444:
+		return "YUV444";
+	case PIXEL_ENCODING_YCBCR420:
+		return "YUV420";
+	default:
+		return "Unknown";
+	}
+}
+
+char *dc_color_depth_to_str(enum dc_color_depth color_depth)
+{
+	switch (color_depth) {
+	case COLOR_DEPTH_666:
+		return "6-bpc";
+	case COLOR_DEPTH_888:
+		return "8-bpc";
+	case COLOR_DEPTH_101010:
+		return "10-bpc";
+	case COLOR_DEPTH_121212:
+		return "12-bpc";
+	case COLOR_DEPTH_141414:
+		return "14-bpc";
+	case COLOR_DEPTH_161616:
+		return "16-bpc";
+	case COLOR_DEPTH_999:
+		return "9-bpc";
+	case COLOR_DEPTH_111111:
+		return "11-bpc";
+	default:
+		return "Unknown";
+	}
+}
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 9a406d74c0dd7..3d93efdc1026d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -819,12 +819,12 @@ void dc_stream_log(const struct dc *dc, const struct dc_stream_state *stream)
 			stream->dst.height,
 			stream->output_color_space);
 	DC_LOG_DC(
-			"\tpix_clk_khz: %d, h_total: %d, v_total: %d, pixelencoder:%d, displaycolorDepth:%d\n",
+			"\tpix_clk_khz: %d, h_total: %d, v_total: %d, pixel_encoding:%s, color_depth:%s\n",
 			stream->timing.pix_clk_100hz / 10,
 			stream->timing.h_total,
 			stream->timing.v_total,
-			stream->timing.pixel_encoding,
-			stream->timing.display_color_depth);
+			dc_pixel_encoding_to_str(stream->timing.pixel_encoding),
+			dc_color_depth_to_str(stream->timing.display_color_depth));
 	DC_LOG_DC(
 			"\tlink: %d\n",
 			stream->link->link_index);
diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_status.h b/drivers/gpu/drm/amd/display/dc/inc/core_status.h
index fa5edd03d0043..b5afd8c3103db 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_status.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_status.h
@@ -60,5 +60,7 @@ enum dc_status {
 };
 
 char *dc_status_to_str(enum dc_status status);
+char *dc_pixel_encoding_to_str(enum dc_pixel_encoding pixel_encoding);
+char *dc_color_depth_to_str(enum dc_color_depth color_depth);
 
 #endif /* _CORE_STATUS_H_ */
-- 
2.43.0



