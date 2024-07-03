Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8724C16F0D0;
	Wed,  3 Jul 2024 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006202; cv=none; b=CEmgmmBoJp+YqJh0N6b8x7UCygfmPhz0x0SivhdrMwneEnDieJJ/XCPs0PxEn8vFnTlYDbdvZUcV4U3PTkIy0s3Rc6R9DlOe1w0b/uPU52TRYKZ/oBtpOoJRZrrWLduiNg3l7XwqCutnyNK1bOU76tqfLbzcHv7TthzzN53ZScA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006202; c=relaxed/simple;
	bh=HZJ12c7BPz4lJfV7G6DnmZmNdZeahnMpeSkKi1qRWSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhzxBC0uj2vXNcUQS5EZ3EI6JT68T5vVmL0J5RPNhbHec3MZSSH3+vqmAhWDnH5bc9xznRBhrocNh4k65eYZachDkqPMe/3G7Y3XtiKnv5IVxA56tJkkCQVS5xemZEOaJb5gWNiRdgO/pdGTKuAJpvkndj4hSN9R2IJGzfa9Pdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEZX12E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEZX12E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07400C2BD10;
	Wed,  3 Jul 2024 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006202;
	bh=HZJ12c7BPz4lJfV7G6DnmZmNdZeahnMpeSkKi1qRWSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEZX12E3J6alDC1Z0pnEBtCq/iyebsTK4OSaZUK47mEjSLOxx/tVThwlZ21v3nUoz
	 SSX2v1j6Bo6HpZ7lC4CcekjK27s2bUAfP0iv0Wa+p3j37f3eExgWT5Tr6dLbiQlU5c
	 /R1u8cZmM2EofJVfQoo1JIqNpDtk6sjwGymNam70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fusheng Huang <fusheng.huang@ecarxgroup.com>,
	Julia Zhang <Julia.Zhang@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 334/356] drm/amdgpu: avoid using null object of framebuffer
Date: Wed,  3 Jul 2024 12:41:10 +0200
Message-ID: <20240703102925.745964252@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -315,7 +316,13 @@ static int amdgpu_vkms_prepare_fb(struct
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
 	INIT_LIST_HEAD(&list);
@@ -364,12 +371,19 @@ static void amdgpu_vkms_cleanup_fb(struc
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


