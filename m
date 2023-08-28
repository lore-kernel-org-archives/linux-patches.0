Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8AEC433C8;
	Mon, 28 Aug 2023 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218029;
	bh=5+uv+t8Izs+nPhD3uRuqgT45am/m7RuzTs1/exk8mSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqIjwjQOu5PotllBUk4PQr79Kw7uFZ3NBZaoduUdhUn3FxUh3pbe5wLtL5WKZFBqN
	 c4jiY8HZBOovOoIsa4Q4qItWb8KVkPFYUB9kpEbfcNjhjHhy2GEahz9Xk+oMmpn3h7
	 kkgob5bePzsyo1Mrhg/a2dd26+zjYQDcczmHk+tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Ian Forbes <iforbes@vmware.com>,
	Maaz Mombasawala <mombasawalam@vmware.com>
Subject: [PATCH 6.4 068/129] drm/vmwgfx: Fix possible invalid drm gem put calls
Date: Mon, 28 Aug 2023 12:12:27 +0200
Message-ID: <20230828101159.613224516@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zackr@vmware.com>

commit f9e96bf1905479f18e83a3a4c314a8dfa56ede2c upstream.

vmw_bo_unreference sets the input buffer to null on exit, resulting in
null ptr deref's on the subsequent drm gem put calls.

This went unnoticed because only very old userspace would be exercising
those paths but it wouldn't be hard to hit on old distros with brand
new kernels.

Introduce a new function that abstracts unrefing of user bo's to make
the code cleaner and more explicit.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reported-by: Ian Forbes <iforbes@vmware.com>
Fixes: 9ef8d83e8e25 ("drm/vmwgfx: Do not drop the reference to the handle too soon")
Cc: <stable@vger.kernel.org> # v6.4+
Reviewed-by: Maaz Mombasawala<mombasawalam@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230818041301.407636-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      |    6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h      |    8 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    3 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c  |    3 +--
 6 files changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -497,10 +497,9 @@ static int vmw_user_bo_synccpu_release(s
 		if (!(flags & drm_vmw_synccpu_allow_cs)) {
 			atomic_dec(&vmw_bo->cpu_writers);
 		}
-		ttm_bo_put(&vmw_bo->tbo);
+		vmw_user_bo_unref(vmw_bo);
 	}
 
-	drm_gem_object_put(&vmw_bo->tbo.base);
 	return ret;
 }
 
@@ -540,8 +539,7 @@ int vmw_user_bo_synccpu_ioctl(struct drm
 			return ret;
 
 		ret = vmw_user_bo_synccpu_grab(vbo, arg->flags);
-		vmw_bo_unreference(&vbo);
-		drm_gem_object_put(&vbo->tbo.base);
+		vmw_user_bo_unref(vbo);
 		if (unlikely(ret != 0)) {
 			if (ret == -ERESTARTSYS || ret == -EBUSY)
 				return -EBUSY;
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -195,6 +195,14 @@ static inline struct vmw_bo *vmw_bo_refe
 	return buf;
 }
 
+static inline void vmw_user_bo_unref(struct vmw_bo *vbo)
+{
+	if (vbo) {
+		ttm_bo_put(&vbo->tbo);
+		drm_gem_object_put(&vbo->tbo.base);
+	}
+}
+
 static inline struct vmw_bo *to_vmw_bo(struct drm_gem_object *gobj)
 {
 	return container_of((gobj), struct vmw_bo, tbo.base);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1164,8 +1164,7 @@ static int vmw_translate_mob_ptr(struct
 	}
 	vmw_bo_placement_set(vmw_bo, VMW_BO_DOMAIN_MOB, VMW_BO_DOMAIN_MOB);
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo);
-	ttm_bo_put(&vmw_bo->tbo);
-	drm_gem_object_put(&vmw_bo->tbo.base);
+	vmw_user_bo_unref(vmw_bo);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1221,8 +1220,7 @@ static int vmw_translate_guest_ptr(struc
 	vmw_bo_placement_set(vmw_bo, VMW_BO_DOMAIN_GMR | VMW_BO_DOMAIN_VRAM,
 			     VMW_BO_DOMAIN_GMR | VMW_BO_DOMAIN_VRAM);
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo);
-	ttm_bo_put(&vmw_bo->tbo);
-	drm_gem_object_put(&vmw_bo->tbo.base);
+	vmw_user_bo_unref(vmw_bo);
 	if (unlikely(ret != 0))
 		return ret;
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1665,10 +1665,8 @@ static struct drm_framebuffer *vmw_kms_f
 
 err_out:
 	/* vmw_user_lookup_handle takes one ref so does new_fb */
-	if (bo) {
-		vmw_bo_unreference(&bo);
-		drm_gem_object_put(&bo->tbo.base);
-	}
+	if (bo)
+		vmw_user_bo_unref(bo);
 	if (surface)
 		vmw_surface_unreference(&surface);
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -451,8 +451,7 @@ int vmw_overlay_ioctl(struct drm_device
 
 	ret = vmw_overlay_update_stream(dev_priv, buf, arg, true);
 
-	vmw_bo_unreference(&buf);
-	drm_gem_object_put(&buf->tbo.base);
+	vmw_user_bo_unref(buf);
 
 out_unlock:
 	mutex_unlock(&overlay->mutex);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -809,8 +809,7 @@ static int vmw_shader_define(struct drm_
 				    shader_type, num_input_sig,
 				    num_output_sig, tfile, shader_handle);
 out_bad_arg:
-	vmw_bo_unreference(&buffer);
-	drm_gem_object_put(&buffer->tbo.base);
+	vmw_user_bo_unref(buffer);
 	return ret;
 }
 


