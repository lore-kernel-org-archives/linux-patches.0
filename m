Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B066281E;
	Tue, 23 Jan 2024 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971604; cv=none; b=m0s37c6LFaeZ6HT8h+2A0K0SBFoDsbla+Jt3cknFLUWugKN3pXIto1wM7nuq16BuGLqMJK0SHfCVQG7OUqG52UTbqjQBx+0MTE32SPl8VV2ybgc/2e5SGYs6L0UoQWvoQADYetdWGhH86SI/XmQLEScVFS857oDOt80nu7jkzZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971604; c=relaxed/simple;
	bh=b27axd30zMOSE/Q0XJiekndAgB92ItZjhHPMpHJSzeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oml/BXcB4he6csKNPWOTvWwUUztz98zE4naHCDGALt+YnanzMJX+kvUGJrGxQmF35nOE/MI+vwTNWWpYha19f6GdWL3p6DsbX3BnARg0al5y17fgJrrJaLF6hc+4l9hkGfer+ncA+fDVclH7mQ2gEkjNF66T0zR9yLHdddqIHQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3GQ4+41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3GQ4+41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD392C433F1;
	Tue, 23 Jan 2024 01:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971604;
	bh=b27axd30zMOSE/Q0XJiekndAgB92ItZjhHPMpHJSzeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3GQ4+41vQID1h0gqhvNTX5H6UIf7r1ljbPJUxYYexTAR5kaIN9FaMjDvkNjDa+2j
	 kI1YYyxx4mTEoZVJgZ6wEim7oleiJgGqDeGx3MqtDS/8FNaZH+gtqe6IUt6j1vzR97
	 RVN9Xo8C3SjT6xrNTDSlsM8LGFLRn9xt48a3Qf7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Ian Forbes <iforbes@vmware.com>,
	Maaz Mombasawala <mombasawalam@vmware.com>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.1 277/417] drm/vmwgfx: Fix possible invalid drm gem put calls
Date: Mon, 22 Jan 2024 15:57:25 -0800
Message-ID: <20240122235801.438762544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      |    6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |    8 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    3 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c  |    3 +--
 6 files changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -595,10 +595,9 @@ static int vmw_user_bo_synccpu_release(s
 		if (!(flags & drm_vmw_synccpu_allow_cs)) {
 			atomic_dec(&vmw_bo->cpu_writers);
 		}
-		ttm_bo_put(&vmw_bo->base);
+		vmw_user_bo_unref(vmw_bo);
 	}
 
-	drm_gem_object_put(&vmw_bo->base.base);
 	return ret;
 }
 
@@ -638,8 +637,7 @@ int vmw_user_bo_synccpu_ioctl(struct drm
 			return ret;
 
 		ret = vmw_user_bo_synccpu_grab(vbo, arg->flags);
-		vmw_bo_unreference(&vbo);
-		drm_gem_object_put(&vbo->base.base);
+		vmw_user_bo_unref(vbo);
 		if (unlikely(ret != 0)) {
 			if (ret == -ERESTARTSYS || ret == -EBUSY)
 				return -EBUSY;
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1600,6 +1600,14 @@ vmw_bo_reference(struct vmw_buffer_objec
 	return buf;
 }
 
+static inline void vmw_user_bo_unref(struct vmw_buffer_object *vbo)
+{
+	if (vbo) {
+		ttm_bo_put(&vbo->base);
+		drm_gem_object_put(&vbo->base.base);
+	}
+}
+
 static inline void vmw_fifo_resource_inc(struct vmw_private *dev_priv)
 {
 	atomic_inc(&dev_priv->num_fifo_resources);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1159,8 +1159,7 @@ static int vmw_translate_mob_ptr(struct
 		return PTR_ERR(vmw_bo);
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, true, false);
-	ttm_bo_put(&vmw_bo->base);
-	drm_gem_object_put(&vmw_bo->base.base);
+	vmw_user_bo_unref(vmw_bo);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1214,8 +1213,7 @@ static int vmw_translate_guest_ptr(struc
 		return PTR_ERR(vmw_bo);
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, false, false);
-	ttm_bo_put(&vmw_bo->base);
-	drm_gem_object_put(&vmw_bo->base.base);
+	vmw_user_bo_unref(vmw_bo);
 	if (unlikely(ret != 0))
 		return ret;
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1599,10 +1599,8 @@ static struct drm_framebuffer *vmw_kms_f
 
 err_out:
 	/* vmw_user_lookup_handle takes one ref so does new_fb */
-	if (bo) {
-		vmw_bo_unreference(&bo);
-		drm_gem_object_put(&bo->base.base);
-	}
+	if (bo)
+		vmw_user_bo_unref(bo);
 	if (surface)
 		vmw_surface_unreference(&surface);
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -457,8 +457,7 @@ int vmw_overlay_ioctl(struct drm_device
 
 	ret = vmw_overlay_update_stream(dev_priv, buf, arg, true);
 
-	vmw_bo_unreference(&buf);
-	drm_gem_object_put(&buf->base.base);
+	vmw_user_bo_unref(buf);
 
 out_unlock:
 	mutex_unlock(&overlay->mutex);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -806,8 +806,7 @@ static int vmw_shader_define(struct drm_
 				    shader_type, num_input_sig,
 				    num_output_sig, tfile, shader_handle);
 out_bad_arg:
-	vmw_bo_unreference(&buffer);
-	drm_gem_object_put(&buffer->base.base);
+	vmw_user_bo_unref(buffer);
 	return ret;
 }
 


