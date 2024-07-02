Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4D915218A;
	Tue,  2 Jul 2024 17:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941223; cv=none; b=cta8abESbrH/lYtCdymdMUfoufs9OUzk3SICAAEMoN8Gpke/iStabG8uv14aENEZaf/iVnPu7StfsLSABzeMXsY3oA9zDaS0Q/ZfFR4WnGZBSL84hWib32LSLYkwyv+lEg8gYKKe2ihLsZbWjNDS1iLcCLKPBUgzbsg3t3BSVto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941223; c=relaxed/simple;
	bh=hG7FJPAIaPSdmg8tjqyi3brawauj8BHJSMmLsEFAyg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQwIAGKyR5FiBnL2G17WhuiElIcb47xyGwYBJt7zE1G448RKPdd8G6gf2SKpeTHvygU7RjytW3saGmfR6Eud0UDXkz00dLKAiq6SRZ1qU2odQQMGrm7p4UgS78sOvai/gOnUyJwArZ3oK+xCwn7M1ourO4S/BOEqu6NUn3KZOrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKw7ki/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKw7ki/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED2C116B1;
	Tue,  2 Jul 2024 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941223;
	bh=hG7FJPAIaPSdmg8tjqyi3brawauj8BHJSMmLsEFAyg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKw7ki/CSh9DZd6+7q+2gPT19otbK7sEJ1DETysQ9fj3c47jVuJEi3Wp71EUJ0xCB
	 orSQ7OxYHG9lo2aM7h82UmzYkJnah7ju6F0dVPNgpKQ6N9bM54+A+3/sJLOJ19qgFJ
	 lHUD5SIFR7GKrJmhqy8ND1Iynhyy7yHTJQer1YyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fusheng Huang <fusheng.huang@ecarxgroup.com>,
	Julia Zhang <Julia.Zhang@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 138/163] drm/amdgpu: avoid using null object of framebuffer
Date: Tue,  2 Jul 2024 19:04:12 +0200
Message-ID: <20240702170238.277601459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Julia Zhang <julia.zhang@amd.com>

commit bcfa48ff785bd121316592b131ff6531e3e696bb upstream.

Instead of using state->fb->obj[0] directly, get object from framebuffer
by calling drm_gem_fb_get_obj() and return error code when object is
null to avoid using null object of framebuffer.

Reported-by: Fusheng Huang <fusheng.huang@ecarxgroup.com>
Signed-off-by: Julia Zhang <Julia.Zhang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -2,6 +2,7 @@
 
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_simple_kms_helper.h>
+#include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_vblank.h>
 
 #include "amdgpu.h"
@@ -313,7 +314,13 @@ static int amdgpu_vkms_prepare_fb(struct
 		return 0;
 	}
 	afb = to_amdgpu_framebuffer(new_state->fb);
-	obj = new_state->fb->obj[0];
+
+	obj = drm_gem_fb_get_obj(new_state->fb, 0);
+	if (!obj) {
+		DRM_ERROR("Failed to get obj from framebuffer\n");
+		return -EINVAL;
+	}
+
 	rbo = gem_to_amdgpu_bo(obj);
 	adev = amdgpu_ttm_adev(rbo->tbo.bdev);
 
@@ -367,12 +374,19 @@ static void amdgpu_vkms_cleanup_fb(struc
 				   struct drm_plane_state *old_state)
 {
 	struct amdgpu_bo *rbo;
+	struct drm_gem_object *obj;
 	int r;
 
 	if (!old_state->fb)
 		return;
 
-	rbo = gem_to_amdgpu_bo(old_state->fb->obj[0]);
+	obj = drm_gem_fb_get_obj(old_state->fb, 0);
+	if (!obj) {
+		DRM_ERROR("Failed to get obj from framebuffer\n");
+		return;
+	}
+
+	rbo = gem_to_amdgpu_bo(obj);
 	r = amdgpu_bo_reserve(rbo, false);
 	if (unlikely(r)) {
 		DRM_ERROR("failed to reserve rbo before unpin\n");


