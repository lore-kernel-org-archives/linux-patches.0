Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D27C248886;
	Wed, 25 Feb 2026 01:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983677; cv=none; b=k31fQcW3xBPAQqPHd8lUl22t+81MtP3eNvyEMf+d/Pu9MnjzxyadbGKNeodotFgC75eFDQWgtk4OxEzcQ0wu/aMogyhQQ28gmTWw50Gxac69HRu7QgLPDMfEy4BkpcCIJiuHRiV8Rj0BvN9uyn+wYktlmtIn6l+boAijAhV4JBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983677; c=relaxed/simple;
	bh=4+qJQbqqUYS2p9HM9nIjR09yAyEoRy4UBbtoUS89dZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbGEIKGd2K7OLVIGzWjWRD+h6UPqlTts4veO6YdO98DD1LLyQNSj7wIz0O1aVsz4ZPRDj7CKJHh5VqFNde99nUJCm0mo86y2MHGMfuIvJVf4UpzBMBRuo/6A50IEU/xahrOiIbrrDNDXh6lL8TrjC+useqZgl2blRbre9s9EZmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJww1As+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJww1As+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0F0C116D0;
	Wed, 25 Feb 2026 01:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983677;
	bh=4+qJQbqqUYS2p9HM9nIjR09yAyEoRy4UBbtoUS89dZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJww1As+b18rWhDX+rMCr3n+K32Zm/Pm/sdf4FY2uOCK9Q0UJupvfBi8HwJBWgs4Y
	 Lpl30YM+3sf8WtsUslwFVyqikw2xxs1qax1g9/gXPwjhi0J/MqjtCY2ilK8kAmQXt8
	 V/bDvbY2JxxkPUyr7FNMPjQP4zJMsMb/fAhtQ5mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Kleiner <mario.kleiner.de@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 744/781] drm/amd/display: Use same max plane scaling limits for all 64 bpp formats
Date: Tue, 24 Feb 2026 17:24:13 -0800
Message-ID: <20260225012417.973547398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit f0157ce46cf0e5e2257e19d590c9b16036ce26d4 ]

The plane scaling hw seems to have the same min/max plane scaling limits
for all 16 bpc / 64 bpp interleaved pixel color formats.

Therefore add cases to amdgpu_dm_plane_get_min_max_dc_plane_scaling() for
all the 16 bpc fixed-point / unorm formats to use the same .fp16
up/downscaling factor limits as used by the fp16 floating point formats.

So far, 16 bpc unorm formats were not handled, and the default: path
returned max/min factors for 32 bpp argb8888 formats, which were wrong
and bigger than what many DCE / DCN hw generations could handle.

The result sometimes was misscaling of framebuffers with
DRM_FORMAT_XRGB16161616, DRM_FORMAT_ARGB16161616, DRM_FORMAT_XBGR16161616,
DRM_FORMAT_ABGR16161616, leading to very wrong looking display, as tested
on Polaris11 / DCE-11.2.

So far this went unnoticed, because only few userspace clients used such
16 bpc unorm framebuffers, and those didn't use hw plane scaling, so they
did not experience this issue.

With upcoming Mesa 26 exposing 16 bpc unorm formats under both OpenGL
and Vulkan under Wayland, and the upcoming GNOME 50 Mutter Wayland
compositor allowing for direct scanout of these formats, the scaling
hw will be used on these formats if possible for HiDPI display scaling,
so it is important to use the correct hw scaling limits to avoid wrong
display.

Tested on AMD Polaris 11 / DCE 11.2 with upcoming Mesa 26 and GNOME 50
on HiDPI displays with scaling enabled. The mutter Wayland compositor now
correctly falls back to scaling via desktop compositing instead of direct
scanout, thereby avoiding wrong image display. For unscaled mode, it
correctly uses direct scanout.

Fixes: 580204038f5b ("drm/amd/display: Enable support for 16 bpc fixed-point framebuffers.")
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Tested-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 7c4496fb4b9d4..f0946e67aef97 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1060,10 +1060,15 @@ static void amdgpu_dm_plane_get_min_max_dc_plane_scaling(struct drm_device *dev,
 		*min_downscale = plane_cap->max_downscale_factor.nv12;
 		break;
 
+	/* All 64 bpp formats have the same fp16 scaling limits */
 	case DRM_FORMAT_XRGB16161616F:
 	case DRM_FORMAT_ARGB16161616F:
 	case DRM_FORMAT_XBGR16161616F:
 	case DRM_FORMAT_ABGR16161616F:
+	case DRM_FORMAT_XRGB16161616:
+	case DRM_FORMAT_ARGB16161616:
+	case DRM_FORMAT_XBGR16161616:
+	case DRM_FORMAT_ABGR16161616:
 		*max_upscale = plane_cap->max_upscale_factor.fp16;
 		*min_downscale = plane_cap->max_downscale_factor.fp16;
 		break;
-- 
2.51.0



