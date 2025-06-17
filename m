Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9BC2EA487;
	Tue, 17 Jun 2025 15:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174795; cv=none; b=HVwr/bvTphp2nEk5+8qzgRLSZ3jk9wV5smi9pFiRdo4WzO9axgfhBV/LhdVLuitCxWzO8Tp9BMf+So9zV7lA8wiobqbRBTV/NNcouN2O/09XJE6ubCSmOgKlGGEhy3w8n58OqcYuEoD8ktnU8ji6c4aS5i8YkFAf2lRe8S/hl+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174795; c=relaxed/simple;
	bh=b7ymUgux2RduL95prAhnYhopc4V/96ihV/Y4qMruiLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3i6fOGcovvB5v/YbvYgq2R68daHJiZUfOb6e6CW9LcKP1P1nmx+mvrLOKx71BH8/qOQx+p5vt0V+vmY1He0shDiCQstCqpjvEVdkFN8rjPZ4ODG6Ic3Yrguv0KH2XZc99tbi9Lhr/OOUP3NRXVgZvsBGW8E9H9OzAHKxU9xkNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c721wdp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c721wdp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB86CC4CEE3;
	Tue, 17 Jun 2025 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174795;
	bh=b7ymUgux2RduL95prAhnYhopc4V/96ihV/Y4qMruiLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c721wdp74LLl+t2tl1Su2MRQgdX+GokN6oMKG8eKGNXQa9F/1HCu/Zm+62U5vmgSf
	 TO/Cst4c807NHzGXxINgM1mu2kDlxnk7ATN+9iw95xReBJAZt4GO0zLiUgiiw8wC1M
	 YGSvdFPTP0E3/Pc7bROUE+2+jjz6AOnjwx97WRpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/512] drm/vmwgfx: Fix dumb buffer leak
Date: Tue, 17 Jun 2025 17:20:27 +0200
Message-ID: <20250617152422.035203033@linuxfoundation.org>
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
index ad61373332cc2..e8e49f13cfa2c 100644
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



