Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F291DFD1;
	Sun,  1 Sep 2024 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209327; cv=none; b=f/USS5XqLss2r4xXIsO85UsXTqc8z6g52nB2o6pomzSsO7KMrM4X884CHIeh6ztP4BpRE/dcULZVeTocwbxGv12+977+zTLIKTE6sGQQJbLfDV6h++lmoa6AF/mnlCwZqeQ7rZgn5sxoyBG2YAxGfj3qHMPbthZP1o696QlssDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209327; c=relaxed/simple;
	bh=DqOUYdPq1GKpPOJOvmHfYbomnGsKC7ooTDQ32n/5k3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jkw5aDgqu7jzqcsmQg8K2JAtbuGGEVe/2/OP4aaYR4xC8N9fmbYxpjEil1pdYwHbt91c2MbwZkv0S9ux0IYpnP5fa8k3YDNVG4KgPeJ4rXv9R/11n71KHj2hdJR094y2oOziyXwqEuncwyycgpGXJQrfDVCvZpI2v3y7EuobM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Du+Jwddq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Du+Jwddq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B54AC4CEC3;
	Sun,  1 Sep 2024 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209326;
	bh=DqOUYdPq1GKpPOJOvmHfYbomnGsKC7ooTDQ32n/5k3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Du+JwddqVWOtm9uk58IgXfLKivZuoEyDBv7rTvmocgJJUvH69iH+O6gKe/yVf4OTy
	 QYxX4i0KQeB3wvOfVgkb9XSZrZhe/fndUvc9ptFyD7jgjN/xB1dTRjY/qI+IH/aimS
	 1WdstZL6f0DC3rw76kKn/hzcuGNwNjfYQtitIRJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/71] drm/amd/display: avoid using null object of framebuffer
Date: Sun,  1 Sep 2024 18:17:58 +0200
Message-ID: <20240901160803.891405146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cd6e99cf74a06..08b10df93c317 100644
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



