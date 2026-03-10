Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F543859DF;
	Tue, 10 Mar 2026 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141229; cv=none; b=Pcx3mGalSJmsfXWnH+72wIe9nWQA+X2SEi5SHHLUirkgA8DyE765g/wTXdDT7VyityQGFycO+64id2IXjod8NQirkxtWi/+Z/UGinkALZ6oIoGynOU7E5suw6XTDlJ4IgRXmWeiMDWDqa6aiWs0ZSX6+O3vSgQX8FizXcjhNzRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141229; c=relaxed/simple;
	bh=8IR4PP04duRSTiV4ISE6cFPUeS+SxWcKYCuAjg/xwpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du0Lop8HIVz3WHUrb2IS3u/WQDAp3DNvnABHO79pg3rRwIaBEBjMtzAo1+arxEmd+DsOaIHoctBocANzv1VOG+ixLlrgi0WIarxZWaQl1keIh4HqbEQWDI8pVY6hzu/ZLwux4ruRMFLJS/JMtETxIz+Wvakq34VShrOi5wNlGh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RB1lYCr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RB1lYCr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B80C19423;
	Tue, 10 Mar 2026 11:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141229;
	bh=8IR4PP04duRSTiV4ISE6cFPUeS+SxWcKYCuAjg/xwpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB1lYCr+ozQLPmo5qCYgOm14D6l8rgWCKddQQz8jhMhVGWSoCaQyBtWj0fUWeK1x8
	 MKtgnDPRxGvsfjvYZQgXv7ZFRA4p+oZySdSunJxyqmzkJQF+747Tydb49FEglQIXFI
	 jp6ikH+S3UtdeJLSXNV0GGEU5I25K3Rk8WJavU+hS3cfFJMav0E2ddQXiVC0OCgq7Y
	 1bazIHy6CmQRWaApPqy0r6wDi6A5cOtodzDqZJqjEYHihGpNNyoQqf/p3eEM2K+jMp
	 C3guP59R29+o65m9RkEIAarZr5c/C7SGyNWggBOJAOHDxzk/9hscmxFNM49FBGjCrZ
	 zjmSRQFTeYPoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Hung <alex.hung@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 231/311] drm/amd/display: Enable DEGAMMA and reject COLOR_PIPELINE+DEGAMMA_LUT
Date: Tue, 10 Mar 2026 07:04:38 -0400
Message-ID: <91648b08e85d0ff62d0a78d11be14d6abd08979f.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit a4fa2355e0add57253468ef13bd08f11285f3b6e ]

[WHAT]
Create DEGAMMA properties even if color pipeline is enabled, and enforce
the mutual exclusion in atomic check by rejecting any commit that
attempts to enable both COLOR_PIPELINE on the plane and DEGAMMA_LUT on
the CRTC simultaneously.

Fixes: 18a4127e9315 ("drm/amd/display: Disable CRTC degamma when color pipeline is enabled")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4963
Reviewed-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 196a6aa727f1f15eb54dda5e60a41543ea9397ee)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c   | 16 ++++++++--------
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c  |  8 ++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 9fcd72d87d25b..39fcbc3e702dc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -765,15 +765,15 @@ int amdgpu_dm_crtc_init(struct amdgpu_display_manager *dm,
 	dm->adev->mode_info.crtcs[crtc_index] = acrtc;
 
 	/* Don't enable DRM CRTC degamma property for
-	 * 1. Degamma is replaced by color pipeline.
-	 * 2. DCE since it doesn't support programmable degamma anywhere.
-	 * 3. DCN401 since pre-blending degamma LUT doesn't apply to cursor.
+	 * 1. DCE since it doesn't support programmable degamma anywhere.
+	 * 2. DCN401 since pre-blending degamma LUT doesn't apply to cursor.
+	 * Note: DEGAMMA properties are created even if the primary plane has the
+	 * COLOR_PIPELINE property. User space can use either the DEGAMMA properties
+	 * or the COLOR_PIPELINE property. An atomic commit which attempts to enable
+	 * both is rejected.
 	 */
-	if (plane->color_pipeline_property)
-		has_degamma = false;
-	else
-		has_degamma = dm->adev->dm.dc->caps.color.dpp.dcn_arch &&
-			      dm->adev->dm.dc->ctx->dce_version != DCN_VERSION_4_01;
+	has_degamma = dm->adev->dm.dc->caps.color.dpp.dcn_arch &&
+		      dm->adev->dm.dc->ctx->dce_version != DCN_VERSION_4_01;
 
 	drm_crtc_enable_color_mgmt(&acrtc->base, has_degamma ? MAX_COLOR_LUT_ENTRIES : 0,
 				   true, MAX_COLOR_LUT_ENTRIES);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 7474f1bc1d0b8..44b9c8ca6d719 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1256,6 +1256,14 @@ static int amdgpu_dm_plane_atomic_check(struct drm_plane *plane,
 	if (ret)
 		return ret;
 
+	/* Reject commits that attempt to use both COLOR_PIPELINE and CRTC DEGAMMA_LUT */
+	if (new_plane_state->color_pipeline && new_crtc_state->degamma_lut) {
+		drm_dbg_atomic(plane->dev,
+			       "[PLANE:%d:%s] COLOR_PIPELINE and CRTC DEGAMMA_LUT cannot be enabled simultaneously\n",
+			       plane->base.id, plane->name);
+		return -EINVAL;
+	}
+
 	ret = amdgpu_dm_plane_fill_dc_scaling_info(adev, new_plane_state, &scaling_info);
 	if (ret)
 		return ret;
-- 
2.51.0

