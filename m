Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F96E2DFF3D;
	Tue, 17 Jun 2025 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175481; cv=none; b=asG8n36d4+UGl9gwiHeYvENF+QcK8Mkv9mYMagK3z3toYt5k/q0oo82bkQd3fNzeH9HYJ3D3MwKaLoNtCjOMmc7TcEWrU3xel8VAwZcGQ1dMBEM9NQgZmBrG5aM3SeED7F7z7i2r+Zu827Ob971++9P4J58w0+OKukClsQCJYlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175481; c=relaxed/simple;
	bh=tz62SUgiUe5nn81QlMzWwov5E9khfBR3guccP5qDEvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuCrGK/H7d1vxQLv0qS4uaYPHhoKlaokD1EOnoepzHe/vKx1MJ8s5mK+R0Vjv4Z6fZRZJLeIFxpodJmR4tc+JzTsUAJUPYjYQurkOpMCl+UmmvOkLitRKFI+gH11Fxv1XkdC+cprkCzUWLF4nxXa6LKCjN8+9ubIfqeFhJaH29I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZvbkUS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZvbkUS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B28C4CEE3;
	Tue, 17 Jun 2025 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175480;
	bh=tz62SUgiUe5nn81QlMzWwov5E9khfBR3guccP5qDEvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZvbkUS7qph6VBpb+f9PeVIEU6+udQSdpsOE1ECQGTiWfL18grGRWCdncA5yD91wZ
	 prQFuY0uNA3sw9TYCQDRuaC8qnqeOj5tyG5utthqc1v22N/JPEf4pGVFLda+bPuWpn
	 DiZXXoAUrYkdsd5pRiOmtTQZVmF4hqtO+R9drrcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 092/780] drm/vmwgfx: Fix dumb buffer leak
Date: Tue, 17 Jun 2025 17:16:40 +0200
Message-ID: <20250617152455.261364410@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit f42c09e614f1bda96f5690be8d0bb273234febbc ]

Dumb buffers were not being freed because the GEM reference that was
acquired in gb_surface_define was not dropped like it is in the 2D case.
Dropping this ref uncovered a few additional issues with freeing the
resources associated with dirty tracking in vmw_bo_free/release.

Additionally the TTM object associated with the surface were also leaking
which meant that when the ttm_object_file was closed at process exit the
destructor unreferenced an already destroyed surface.

The solution is to remove the destructor from the vmw_user_surface
associated with the dumb_buffer and immediately unreferencing the TTM
object which his removes it from the ttm_object_file.

This also allows the early return in vmw_user_surface_base_release for the
dumb buffer case to be removed as it should no longer occur.

The chain of references now has the GEM handle(s) owning the dumb buffer.
The GEM handles have a singular GEM reference to the vmw_bo which is
dropped when all handles are closed. When the GEM reference count hits
zero the vmw_bo is freed which then unreferences the surface via
vmw_resource_release in vmw_bo_release.

Fixes: d6667f0ddf46 ("drm/vmwgfx: Fix handling of dumb buffers")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250123204424.836896-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c       |  6 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c  | 18 ++++++++++++------
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index aa13e4061ff15..f30df3dc871fd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -51,11 +51,13 @@ static void vmw_bo_release(struct vmw_bo *vbo)
 			mutex_lock(&res->dev_priv->cmdbuf_mutex);
 			(void)vmw_resource_reserve(res, false, true);
 			vmw_resource_mob_detach(res);
+			if (res->dirty)
+				res->func->dirty_free(res);
 			if (res->coherent)
 				vmw_bo_dirty_release(res->guest_memory_bo);
 			res->guest_memory_bo = NULL;
 			res->guest_memory_offset = 0;
-			vmw_resource_unreserve(res, false, false, false, NULL,
+			vmw_resource_unreserve(res, true, false, false, NULL,
 					       0);
 			mutex_unlock(&res->dev_priv->cmdbuf_mutex);
 		}
@@ -73,9 +75,9 @@ static void vmw_bo_free(struct ttm_buffer_object *bo)
 {
 	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
 
-	WARN_ON(vbo->dirty);
 	WARN_ON(!RB_EMPTY_ROOT(&vbo->res_tree));
 	vmw_bo_release(vbo);
+	WARN_ON(vbo->dirty);
 	kfree(vbo);
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index a73af8a355fbf..c4d5fe5f330f9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -273,7 +273,7 @@ int vmw_user_resource_lookup_handle(struct vmw_private *dev_priv,
 		goto out_bad_resource;
 
 	res = converter->base_obj_to_res(base);
-	kref_get(&res->kref);
+	vmw_resource_reference(res);
 
 	*p_res = res;
 	ret = 0;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 1f7626f6ac0b1..d7a8070330ba5 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -658,7 +658,7 @@ static void vmw_user_surface_free(struct vmw_resource *res)
 	struct vmw_user_surface *user_srf =
 	    container_of(srf, struct vmw_user_surface, srf);
 
-	WARN_ON_ONCE(res->dirty);
+	WARN_ON(res->dirty);
 	if (user_srf->master)
 		drm_master_put(&user_srf->master);
 	kfree(srf->offsets);
@@ -689,8 +689,7 @@ static void vmw_user_surface_base_release(struct ttm_base_object **p_base)
 	 * Dumb buffers own the resource and they'll unref the
 	 * resource themselves
 	 */
-	if (res && res->guest_memory_bo && res->guest_memory_bo->is_dumb)
-		return;
+	WARN_ON(res && res->guest_memory_bo && res->guest_memory_bo->is_dumb);
 
 	vmw_resource_unreference(&res);
 }
@@ -2370,12 +2369,19 @@ int vmw_dumb_create(struct drm_file *file_priv,
 	vbo = res->guest_memory_bo;
 	vbo->is_dumb = true;
 	vbo->dumb_surface = vmw_res_to_srf(res);
-
+	drm_gem_object_put(&vbo->tbo.base);
+	/*
+	 * Unset the user surface dtor since this in not actually exposed
+	 * to userspace. The suface is owned via the dumb_buffer's GEM handle
+	 */
+	struct vmw_user_surface *usurf = container_of(vbo->dumb_surface,
+						struct vmw_user_surface, srf);
+	usurf->prime.base.refcount_release = NULL;
 err:
 	if (res)
 		vmw_resource_unreference(&res);
-	if (ret)
-		ttm_ref_object_base_unref(tfile, arg.rep.handle);
+
+	ttm_ref_object_base_unref(tfile, arg.rep.handle);
 
 	return ret;
 }
-- 
2.39.5



