Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94BE2ECD38;
	Tue, 17 Jun 2025 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174788; cv=none; b=GRSF4U8mJ1R6FBl+IN7m62Vr1svmswUwzf8H+Z9CFq8R6H9QygLcN1lQ+Xa1CU9r2x2XLW2u6moKQJLUYeCQp0FabOYBOSJGBnKJPtFY35lm1M10qNsg0MLnkLdB9Uel+7gqn9BiJtZWULivQsaP/arFaPzKEilzs+JBJGBHxq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174788; c=relaxed/simple;
	bh=We0uzWiQOAaz/yu1R4n5eALXH6WAZt/5kOE9/KtZrAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUl47O35rTvXbE7hM3ItI3etbm+YIYbnPoHnDU7YYnGM3+FGq2NRiArCLr5Sw26tBwhysI2Y8N5tLgSBSvaPq2y11dcTlpZWVnb1k8y1lZFSNMkBBdcE07exFaXkiRv3dgmuJezlFPP/zHSYenByU7fSwTURXGs3knSJMyAVOTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/GZKVKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/GZKVKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380CBC4CEE3;
	Tue, 17 Jun 2025 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174788;
	bh=We0uzWiQOAaz/yu1R4n5eALXH6WAZt/5kOE9/KtZrAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/GZKVKlKqeAcnQLvP5PXj9wk/N8n9W9px/aymkRQg646uwfc7nh5EU2hCumIH6X4
	 tjZGQVDgdeI3r1pcDSgKZsdfrLHo7nao+oBG+r86Ey0XpagMGUlSR6rEmcksCzONXq
	 T7wPxYTnDViRHTee0FAHMNenzOxiwXBSfhcO9imE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/512] drm/vmwgfx: Add error path for xa_store in vmw_bo_add_detached_resource
Date: Tue, 17 Jun 2025 17:20:26 +0200
Message-ID: <20250617152421.986565691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 183cda50094cb..ad61373332cc2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -849,9 +849,9 @@ void vmw_bo_placement_set_default_accelerated(struct vmw_bo *bo)
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
index c21ba7ff77368..940c0a0b9c451 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -142,7 +142,7 @@ void vmw_bo_move_notify(struct ttm_buffer_object *bo,
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



