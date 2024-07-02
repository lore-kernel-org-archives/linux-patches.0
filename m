Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941D1C007E;
	Tue,  2 Jul 2024 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940554; cv=none; b=Ypjs1Jbtz7zgOVb1Muo9T0KVd6SkFnuYZ0pNTuW2/e6cXSthcW0QYDwh3P5Utx3xduZFoIm6xdb8x9GgE31E4cu2ro2I3Q4OvbNfw9Qxuo55SdvApZ5HK9zcP2U+a1pWiVa5WSMaXZNcg2KL+vds6e3dlyjFqf2q9tKfHTx4wso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940554; c=relaxed/simple;
	bh=9D6DgNaanRFq106gdP1fbcWxFR5t481UzLYdW6p8SNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXR2498UqPfhT4lVOS+m63JBn7nqs8vbSthinqrSYub9GyCXJ3tcQZSIIyTO9WhqJ/KMOixEmNBIAOeKrz84Treib+aE7c5tjGv37lmOIWvdFqf9NpmQL1tffGtGkRcqv+dsL/BTbOZvpzyD+UI9rbAmZVUwyH2hHMrWL2f4vzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExTgFY6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExTgFY6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F382C4AF0C;
	Tue,  2 Jul 2024 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940554;
	bh=9D6DgNaanRFq106gdP1fbcWxFR5t481UzLYdW6p8SNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExTgFY6+o6eEOCw6QOrEV/Fd5yEVQBt2j++0dEHFIOMuwY5FiJaI4okCHQbPWu8DT
	 1fBga5aqNVDDEd1todkaDZaIXorlg6c8CAllBdbShnRrJMnuvJjyu0wmTKhCdbRVfQ
	 03bdaphGRue+s/kGRCKIRvTyOAclLIO3rKyz7dbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fusheng Huang <fusheng.huang@ecarxgroup.com>,
	Julia Zhang <Julia.Zhang@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 182/222] drm/amdgpu: avoid using null object of framebuffer
Date: Tue,  2 Jul 2024 19:03:40 +0200
Message-ID: <20240702170250.934566579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3,6 +3,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_simple_kms_helper.h>
+#include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_vblank.h>
 
 #include "amdgpu.h"
@@ -314,7 +315,13 @@ static int amdgpu_vkms_prepare_fb(struct
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
 
@@ -368,12 +375,19 @@ static void amdgpu_vkms_cleanup_fb(struc
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


