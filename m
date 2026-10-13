Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81EA4FE2E3;
	Tue, 13 Oct 2026 12:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893141; cv=none; b=Xx0yHMup9QLovkPFevYXeQCF5tFKs1Tde97CUhHvPXidC9GK/sDpM+0ubdOWPL/L8eJK1re9AdRTZVkvrCZVnbwuFjS/Rm2gP52lAZ1gedFiMd3ITAUmA7+TwQBFnIymoYd4jZCa3orBTs2DVXuj7mZs+/yiE2DWp818SN2TJ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893141; c=relaxed/simple;
	bh=OTADfKDmPO1DJWRxfS8oG0Jm9elMNCz72X2H369Wi50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8g51Lb3bkw7Iqq15lCgEFZIkl9OR90l74AAcE4mAqhOqj+aGHZTiXSmYdOoY1XsVUXWoGj7F1cxv0TqDMTVvGmBq7KDP7IZ2XBu2UZmKxLZXKijlXpxbN0QPrvlvx1dYXhvU3y6XPShRJ1tIuD+q/tWMo7WHC/O8KB//w2F0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlZOWMHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlZOWMHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE60E1F000FF;
	Tue, 13 Oct 2026 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893139;
	bh=YheHzGGbovNkKbD/oqD9mGT785DU2/Gj0lug2CRL9m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlZOWMHknVGzQ3jg7TK8KJXbmr7R2Pl4UsNG33DGp/eHLjyhMY5oehGxUtEo99DKz
	 sWlXk8PaiXDUganjIcyFq8HbaMTWq+PiWCnK2DORQI7I52OU+rwth/k0bagWOXgy9N
	 pvV0sbF5zhVwE68vGxUKktBz+B/xYysSASNkfoQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 127/621] drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs
Date: Tue, 13 Oct 2026 13:32:02 +0200
Message-ID: <20261013112923.872522424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -109,25 +109,7 @@ void amdgpu_dm_plane_fill_blending_from_
 
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


