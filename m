Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9193BBA04;
	Sat, 17 Oct 2026 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257479; cv=none; b=NzZmbrF/QXyXyWHGPx8bqNiPk2uwEDZDDhuZlhHwqp7ZFGXEjKXmS7TGwEeSJq+8CIQXJr1iOZ8OhLCG/RVS1eyaZf1NkfVNMrSnHD5ErxKa5m3pvcZ3xULD0Mmd76vne1MhzfmhLSVxam+jMAkSels9FA6/muDViTR6T/Sh2dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257479; c=relaxed/simple;
	bh=PGGsj9syaNRQk663ragwUlyp3YS/S5Teab1OX9mNocI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjHtfVbXn3oIC5I1dXN36l9HzpwxSewLlE+/9EWcxAa3YwiSzhhEP+RPd53C6Xx+I+O8TL+LxpgfBPeDXV0UTtjvw4w4z+709xso5rO0AbL2wMGpdnULLRo7p07o5V5O6GT0JvT+WI8XXEtSeVGV5umN06tkFCldxyI3h3bxcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdBMa3DW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdBMa3DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6871F000C4;
	Sat, 17 Oct 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257478;
	bh=8lib6pRvz8Dw+15mkWjI+101XHPw5vnjtZ0xMTj2O6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdBMa3DWqKE0O4+YqELqOTOCt3wIm6cBeJV87nuQ6T5tHjvlMQD2KO2Vz/lcXYKSz
	 uhp9WaV098vBi+ii27z/LiGg3LIdKmlZpPOeWbclMzkh4I56x9j/gBVCVjbgvYC/1P
	 E8oL9e7r/qceP2+FLb9rgUqyEEbMhuSN/7jnZsvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0530/1674] drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs
Date: Sat, 17 Oct 2026 17:46:42 +0200
Message-ID: <20261017160444.703849707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

commit 7744262f5d63f9faa4d59dec127ae1c8b2d56495 upstream.

[Why]

DM was declaring it's own list of has_alpha DRM formats to check against
for enabling alpha blending, when the format->has_alpha already does
that for us.

The self-declared list missed some has_alpha formats, causing
direct-scanout planes with such formats to appear opaque.

[How]

Drop the self-declared list, instead use the format->has_alpha field
directly.

Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ecdac91ed43d836683d5daa467f4907405420e2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c |   20 ----------------
 1 file changed, 1 insertion(+), 19 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -110,25 +110,7 @@ void amdgpu_dm_plane_fill_blending_from_
 
 	if (plane_state->pixel_blend_mode == DRM_MODE_BLEND_PREMULTI ||
 		plane_state->pixel_blend_mode == DRM_MODE_BLEND_COVERAGE) {
-		static const uint32_t alpha_formats[] = {
-			DRM_FORMAT_ARGB8888,
-			DRM_FORMAT_RGBA8888,
-			DRM_FORMAT_ABGR8888,
-			DRM_FORMAT_ARGB2101010,
-			DRM_FORMAT_ABGR2101010,
-			DRM_FORMAT_ARGB16161616,
-			DRM_FORMAT_ABGR16161616,
-			DRM_FORMAT_ARGB16161616F,
-		};
-		uint32_t format = plane_state->fb->format->format;
-		unsigned int i;
-
-		for (i = 0; i < ARRAY_SIZE(alpha_formats); ++i) {
-			if (format == alpha_formats[i]) {
-				*per_pixel_alpha = true;
-				break;
-			}
-		}
+		*per_pixel_alpha = plane_state->fb->format->has_alpha;
 
 		if (*per_pixel_alpha && plane_state->pixel_blend_mode == DRM_MODE_BLEND_COVERAGE)
 			*pre_multiplied_alpha = false;


