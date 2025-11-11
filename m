Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3932609FD;
	Tue, 11 Nov 2025 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824472; cv=none; b=Fu4IHpfrz0/WVd1i2oxDt5QRY82bgHM6eP7xhQ8ujM60o+TLgzvANzatCOBPiYNOGrTkV8uCKz+xZVv7lY6csLKrJq2+DxSIJyPi1srjbwpJgY0sFzZjUUYEGkDJAWkR5wZrLrcpvvkejeuF9L7RxD7tkRNkDWyMP1mToSOh6bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824472; c=relaxed/simple;
	bh=wFCl8y4fyrBdX0yVkBmqEfsfUTkj32BnNd+aWBvyXa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC5AbjejA4hkumrB6u2JiKVHumNT0AwDixXYAHfLW0PtnGS7xCxGr+RsRyHHpqc39tYtxqQHHiYQmzFe7bUvt5mMr+fSBb255cP8deGBLZibsn/FxuA4PA7i38s1z3OKtz1WuZuQfUV+KHRpYju0I25iq7ru/AI/7YgVvIVSYDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gllEidIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gllEidIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAA9C116B1;
	Tue, 11 Nov 2025 01:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824471;
	bh=wFCl8y4fyrBdX0yVkBmqEfsfUTkj32BnNd+aWBvyXa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gllEidIEFnp34PTI5/u0Yabn9NWznzrvwxMhjtaU43mNLg8JXlLFxXahWcM+AJqSS
	 xgyAmZQvQtHc0QDnUs3s8S+FEy+j6lMZ4+h9QF33o8t4eNYMoMeieO6x6OwR9rNmW3
	 gJf4qPfz1f4zecm/HTiGmWnXasDS1RkcNUsByimY=
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
Subject: [PATCH 6.12 453/565] drm/amd/display: Add fallback path for YCBCR422
Date: Tue, 11 Nov 2025 09:45:09 +0900
Message-ID: <20251111004537.082307214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c314c213c21c3..271710104f0e5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6162,7 +6162,8 @@ static void fill_stream_properties_from_drm_display_mode(
 			&& aconnector->force_yuv420_output)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
 	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR422)
-			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
+			&& aconnector
+			&& aconnector->force_yuv422_output)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
 	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR444)
 			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
@@ -7421,6 +7422,7 @@ create_validate_stream_for_sink(struct drm_connector *connector,
 		bpc_limit = 8;
 
 	do {
+		drm_dbg_kms(connector->dev, "Trying with %d bpc\n", requested_bpc);
 		stream = create_stream_for_sink(connector, drm_mode,
 						dm_state, old_stream,
 						requested_bpc);
@@ -7456,16 +7458,41 @@ create_validate_stream_for_sink(struct drm_connector *connector,
 
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
index 47f6569be54cb..2c0e1180706fa 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -724,6 +724,7 @@ struct amdgpu_dm_connector {
 
 	bool fake_enable;
 	bool force_yuv420_output;
+	bool force_yuv422_output;
 	struct dsc_preferred_settings dsc_settings;
 	union dp_downstream_port_present mst_downstream_port_present;
 	/* Cached display modes */
-- 
2.51.0



