Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290F624A043;
	Tue, 11 Nov 2025 01:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825146; cv=none; b=fBYu1F84GTjph18zczBbMpeT9hcEePzTw6/xDH5NRemVu8N3viTRclk8AFL2ogW2qDlskc3i14R3SfjZxOVT6Bf0BecDYm2HXu68BP83ZMQumpQG12yMB1DxuRcvwI13rNkMAEeKq1yWsGATvzTws77XDcccGvH0cl223axs6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825146; c=relaxed/simple;
	bh=d1oqdhEEb5Jf1hEGYd72XoMf/jCCV7WXAyUD46hZtDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alcGZMvsC+Aq4OOKEP1qPE2mvk1XGbphVUSgHOZcw1gLN941yq5SOePWbG085Q7JMTJQCU/brX7q3gCSYx6RYSg2zWwdxkw61Fj9TB6KOFuvI+XOTtY/w2dBA6cvLzAkt3naOhj9rHdQIiHVFia7VQ+P9feHSVTceLzcFQpG2G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUPCo7kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUPCo7kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70009C4CEF5;
	Tue, 11 Nov 2025 01:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825146;
	bh=d1oqdhEEb5Jf1hEGYd72XoMf/jCCV7WXAyUD46hZtDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUPCo7kdCev6v2L+Ta/okyXUqdNBTg3Yv5D0pyoC5eI4FEFOz/4WSn8WOEP6xugHU
	 pEJ4pNYlO0f4GN8dIi0zR8/qzyoyy6JUQbVfT+tA9FoKE9GkbRkv/atwnqDtvcjNp1
	 YtkCfoNX5r3bs9D/bF6iq2qQDBDfdDkaHamRJjOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauri Carvalho <mcarvalho3@lenovo.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Mario Limonciello <Mario.Limonciello@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 681/849] drm/amd/display: Add fallback path for YCBCR422
Date: Tue, 11 Nov 2025 09:44:11 +0900
Message-ID: <20251111004552.886595483@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <Mario.Limonciello@amd.com>

[ Upstream commit db291ed1732e02e79dca431838713bbf602bda1c ]

[Why]
DP validation may fail with multiple displays and higher color depths.
The sink may support others though.

[How]
When DP bandwidth validation fails, progressively fallback through:
- YUV422 8bpc (bandwidth efficient)
- YUV422 6bpc (reduced color depth)
- YUV420 (last resort)

This resolves cases where displays would show no image due to insufficient
DP link bandwidth for the requested RGB mode.

Suggested-by: Mauri Carvalho <mcarvalho3@lenovo.com>
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 45 +++++++++++++++----
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  1 +
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 60eb2c2c79b77..e3e9faa4aaeb7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6405,7 +6405,8 @@ static void fill_stream_properties_from_drm_display_mode(
 			&& aconnector->force_yuv420_output)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
 	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR422)
-			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
+			&& aconnector
+			&& aconnector->force_yuv422_output)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
 	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR444)
 			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
@@ -7665,6 +7666,7 @@ create_validate_stream_for_sink(struct drm_connector *connector,
 		bpc_limit = 8;
 
 	do {
+		drm_dbg_kms(connector->dev, "Trying with %d bpc\n", requested_bpc);
 		stream = create_stream_for_sink(connector, drm_mode,
 						dm_state, old_stream,
 						requested_bpc);
@@ -7700,16 +7702,41 @@ create_validate_stream_for_sink(struct drm_connector *connector,
 
 	} while (stream == NULL && requested_bpc >= bpc_limit);
 
-	if ((dc_result == DC_FAIL_ENC_VALIDATE ||
-	     dc_result == DC_EXCEED_DONGLE_CAP) &&
-	     !aconnector->force_yuv420_output) {
-		DRM_DEBUG_KMS("%s:%d Retry forcing yuv420 encoding\n",
-				     __func__, __LINE__);
-
-		aconnector->force_yuv420_output = true;
+	switch (dc_result) {
+	/*
+	 * If we failed to validate DP bandwidth stream with the requested RGB color depth,
+	 * we try to fallback and configure in order:
+	 * YUV422 (8bpc, 6bpc)
+	 * YUV420 (8bpc, 6bpc)
+	 */
+	case DC_FAIL_ENC_VALIDATE:
+	case DC_EXCEED_DONGLE_CAP:
+	case DC_NO_DP_LINK_BANDWIDTH:
+		/* recursively entered twice and already tried both YUV422 and YUV420 */
+		if (aconnector->force_yuv422_output && aconnector->force_yuv420_output)
+			break;
+		/* first failure; try YUV422 */
+		if (!aconnector->force_yuv422_output) {
+			drm_dbg_kms(connector->dev, "%s:%d Validation failed with %d, retrying w/ YUV422\n",
+				    __func__, __LINE__, dc_result);
+			aconnector->force_yuv422_output = true;
+		/* recursively entered and YUV422 failed, try YUV420 */
+		} else if (!aconnector->force_yuv420_output) {
+			drm_dbg_kms(connector->dev, "%s:%d Validation failed with %d, retrying w/ YUV420\n",
+				    __func__, __LINE__, dc_result);
+			aconnector->force_yuv420_output = true;
+		}
 		stream = create_validate_stream_for_sink(connector, drm_mode,
-						dm_state, old_stream);
+							 dm_state, old_stream);
+		aconnector->force_yuv422_output = false;
 		aconnector->force_yuv420_output = false;
+		break;
+	case DC_OK:
+		break;
+	default:
+		drm_dbg_kms(connector->dev, "%s:%d Unhandled validation failure %d\n",
+			    __func__, __LINE__, dc_result);
+		break;
 	}
 
 	return stream;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 42801caf57b69..bb0ed81bcacdf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -790,6 +790,7 @@ struct amdgpu_dm_connector {
 
 	bool fake_enable;
 	bool force_yuv420_output;
+	bool force_yuv422_output;
 	struct dsc_preferred_settings dsc_settings;
 	union dp_downstream_port_present mst_downstream_port_present;
 	/* Cached display modes */
-- 
2.51.0



