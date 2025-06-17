Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6E22F2366;
	Tue, 17 Jun 2025 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175453; cv=none; b=JaiCR/XpGl9PSOvYTM8ka6VJ3gplsvOz3GqwkddBKfYCEbhaAWBwCVYU+NFA7y/g3RvOmY6AgJVbN+sithq7j8bUy3RPTYRAWxew30u5TBWjKDda/+kNVrOIm2e6AJQmi9VYKwUkuXLQ97K2miPHf6EGPPm7S1eswikFukpBjMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175453; c=relaxed/simple;
	bh=mObWzqO8p+ey81O8utPFXh1Kv2sv9Q7zkY6DknY139E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA2ox9u9jCsdIqzTenG34aOF/wsehHoOf7O7C7+iOn8IbPyK8NSACjNodZEoiOBRSbbRwWHVcMKEKgry1YNzolWBEa5DFRqqYkXc34BCQ7wCgj6aBHK1lfrOW5Bbu6FwURU5CG4/y+spENKaqy3P/FoGvxREIo/ksCjEu/K1HVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byqIJWj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byqIJWj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF1EC4CEE3;
	Tue, 17 Jun 2025 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175453;
	bh=mObWzqO8p+ey81O8utPFXh1Kv2sv9Q7zkY6DknY139E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byqIJWj77cugJC/9ncF3cBNee7tu+vWF/KKOtgpyO0kHuXXWZRwEsVxB6I7jusjFR
	 RywkBvRZD6zItgLuotydD9sx90utvDN5wkhKsLvK12xS/h2ebZEjlGswJwz/BLgact
	 KSNi8kE1LpIEG0N6y0naHarDhtWMF6XTjl7d9WyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 089/780] drm/vmwgfx: Add error path for xa_store in vmw_bo_add_detached_resource
Date: Tue, 17 Jun 2025 17:16:37 +0200
Message-ID: <20250617152455.137085400@linuxfoundation.org>
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

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit 3282422bf251db541fe07c548ca304130d37d754 ]

The xa_store() may fail due to memory allocation failure because there
is no guarantee that the index is already used. This fix introduces new
paths to handle the error.

This patch also aligns the order of function calls by calling
vmw_bo_add_detached_resource() before ttm_prime_object_init() in order
to allow consistent error handling.

Fixes: d6667f0ddf46 ("drm/vmwgfx: Fix handling of dumb buffers")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250225145223.34773-1-keisuke.nishimura@inria.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      |  4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h      |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 16 ++++++++++++++--
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index 9b5b8c1f063bb..aa13e4061ff15 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -848,9 +848,9 @@ void vmw_bo_placement_set_default_accelerated(struct vmw_bo *bo)
 	vmw_bo_placement_set(bo, domain, domain);
 }
 
-void vmw_bo_add_detached_resource(struct vmw_bo *vbo, struct vmw_resource *res)
+int vmw_bo_add_detached_resource(struct vmw_bo *vbo, struct vmw_resource *res)
 {
-	xa_store(&vbo->detached_resources, (unsigned long)res, res, GFP_KERNEL);
+	return xa_err(xa_store(&vbo->detached_resources, (unsigned long)res, res, GFP_KERNEL));
 }
 
 void vmw_bo_del_detached_resource(struct vmw_bo *vbo, struct vmw_resource *res)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
index 11e330c7c7f52..51790a11fe649 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -141,7 +141,7 @@ void vmw_bo_move_notify(struct ttm_buffer_object *bo,
 			struct ttm_resource *mem);
 void vmw_bo_swap_notify(struct ttm_buffer_object *bo);
 
-void vmw_bo_add_detached_resource(struct vmw_bo *vbo, struct vmw_resource *res);
+int vmw_bo_add_detached_resource(struct vmw_bo *vbo, struct vmw_resource *res);
 void vmw_bo_del_detached_resource(struct vmw_bo *vbo, struct vmw_resource *res);
 struct vmw_surface *vmw_bo_surface(struct vmw_bo *vbo);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 5721c74da3e0b..1f7626f6ac0b1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -871,7 +871,12 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 			vmw_resource_unreference(&res);
 			goto out_unlock;
 		}
-		vmw_bo_add_detached_resource(res->guest_memory_bo, res);
+
+		ret = vmw_bo_add_detached_resource(res->guest_memory_bo, res);
+		if (unlikely(ret != 0)) {
+			vmw_resource_unreference(&res);
+			goto out_unlock;
+		}
 	}
 
 	tmp = vmw_resource_reference(&srf->res);
@@ -1670,6 +1675,14 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 
 	}
 
+	if (res->guest_memory_bo) {
+		ret = vmw_bo_add_detached_resource(res->guest_memory_bo, res);
+		if (unlikely(ret != 0)) {
+			vmw_resource_unreference(&res);
+			goto out_unlock;
+		}
+	}
+
 	tmp = vmw_resource_reference(res);
 	ret = ttm_prime_object_init(tfile, res->guest_memory_size, &user_srf->prime,
 				    VMW_RES_SURFACE,
@@ -1684,7 +1697,6 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 	rep->handle      = user_srf->prime.base.handle;
 	rep->backup_size = res->guest_memory_size;
 	if (res->guest_memory_bo) {
-		vmw_bo_add_detached_resource(res->guest_memory_bo, res);
 		rep->buffer_map_handle =
 			drm_vma_node_offset_addr(&res->guest_memory_bo->tbo.base.vma_node);
 		rep->buffer_size = res->guest_memory_bo->tbo.base.size;
-- 
2.39.5



