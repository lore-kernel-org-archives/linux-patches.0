Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52213181B88;
	Sun,  1 Sep 2024 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208178; cv=none; b=PTqAAXK1LjOHiGAYtDeyQX/EV83xktc3LFEIercSfN33TFR9f5WBgCAu1Ai48WNUrNbXDzkBlmemCGm6bb4QfAOjhmq3tohvl8JgdcnvUkQuefF+yuW0XIIxTsqLd6lqkMOlcjzVmVHpfrOx8tKWMDJBufNH0NusC89Bq5QkvLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208178; c=relaxed/simple;
	bh=ohKshwXyi8Yn/B/SrTtH68zgYd4Mk8Y/LnO7owUxb3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGrTkUosQtj0yFmLzqxHrlVkv4i4nAh3zXeMVAzA7tyOtDxSKguQdpfQUZfRU0ZyW6HEZdOm6IH4Aw9FMkgkNTaScFs/igRabHwDTcw2y0xelOqSGYAXXhZPfAMh3o2CZUem5lL0VmMJtBCXpz7FPMJFfs/YtjA7V7UUMHBzBdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2fFCgWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2fFCgWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BC4C4CEC3;
	Sun,  1 Sep 2024 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208178;
	bh=ohKshwXyi8Yn/B/SrTtH68zgYd4Mk8Y/LnO7owUxb3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2fFCgWF6ZBcOEvCM7SVP6IYgw9neGiWeE8js9k1xAl2PIsNnTbMmnw1bMnVLADcV
	 3d0VoGWKAiDSon29TsK/mDDHUGvp2abDrRdJvfSDLUnZnGKa3/g3GAGqKm+OcHyJg7
	 duAYLZZyYGjPZPgQ90eTV56Mqox0CvgxP5ONSyts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 67/93] drm/amd/display: avoid using null object of framebuffer
Date: Sun,  1 Sep 2024 18:16:54 +0200
Message-ID: <20240901160809.887357436@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 3b9a33235c773c7a3768060cf1d2cf8a9153bc37 ]

Instead of using state->fb->obj[0] directly, get object from framebuffer
by calling drm_gem_fb_get_obj() and return error code when object is
null to avoid using null object of framebuffer.

Fixes: 5d945cbcd4b1 ("drm/amd/display: Create a file dedicated to planes")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 73dd0ad9e5dad53766ea3e631303430116f834b3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index cc74dd69acf2b..fa9f53b310793 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -28,6 +28,7 @@
 #include <drm/drm_blend.h>
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
+#include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fourcc.h>
 
 #include "amdgpu.h"
@@ -848,10 +849,14 @@ static int dm_plane_helper_prepare_fb(struct drm_plane *plane,
 	}
 
 	afb = to_amdgpu_framebuffer(new_state->fb);
-	obj = new_state->fb->obj[0];
+	obj = drm_gem_fb_get_obj(new_state->fb, 0);
+	if (!obj) {
+		DRM_ERROR("Failed to get obj from framebuffer\n");
+		return -EINVAL;
+	}
+
 	rbo = gem_to_amdgpu_bo(obj);
 	adev = amdgpu_ttm_adev(rbo->tbo.bdev);
-
 	r = amdgpu_bo_reserve(rbo, true);
 	if (r) {
 		dev_err(adev->dev, "fail to reserve bo (%d)\n", r);
-- 
2.43.0



