Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9A54F4735;
	Tue, 13 Oct 2026 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892354; cv=none; b=c7ztqDdMegredg6KGqW0FpnnK3M3xMoJUPgkK+6hV1m10KtwLEuJnuquBhRykM1FQ9A5t7uLtmbj3m7pGHrK6nbjSiWgtQJFRryFmX0YbK0x+16DLAl7E0oCPcxlZURN0elWzoOFBldCEjpq8ng7kFyqd0d8E7zTtHzuZVuKXoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892354; c=relaxed/simple;
	bh=ADnhXeoGegbLTeTsGYbDKxI/JV0BWscSOhB3hDaYUT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAZWpEI/k5NOTE52+O9bnxHoted8p2x6eiazj+9qJWJj+GEWp+y+/kEbtFYbS8Pz4w0q21hEvY9QkciQPDcGVulesOBIGfBYzS2b7GC7Qe1k+14vA68ShwCUYmKZ3D0wzPEYVnFpSeuOwCj6/pfozhgOyJwNO05HQ6/vDDTcA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGDJc7d+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGDJc7d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B421F00893;
	Tue, 13 Oct 2026 11:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892353;
	bh=tYZ/sMPSulVcRTc+0rNjpiQrECH/0IHoOFlmqfKIwB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGDJc7d+0UBPOCaOx7RCZfqeky2mcYmnAsIlDvJTIXVO8Rrlswp4TVj9sutCyY1KM
	 XUq6vnzjzXztxkJPI0uYL3E7J8GUIcCrS3lCSXoWqZTKEiILFFwuF3mAm79utfQbMy
	 +Q1YPFdyKsihYHFt+/uC4qCQYvjfDNt9FPj3jDzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 145/281] drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs
Date: Tue, 13 Oct 2026 13:37:41 +0200
Message-ID: <20261013112858.677525014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


