Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3159F1A7067;
	Thu, 15 Aug 2024 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730791; cv=none; b=b2ERZgA1DeLWfNHO9B92ysovAuKgSrmpD1HElJuce3g0d8G0DLB3/rTWJ8v4ErmNYFv1oTyDPKrbo2ODTJ9siP0qtnrOjkU5hn0YxcamzeSFbQhqv5oCRmg6u41pf+XLFwfT9YlJwDTcl4zmAGaJ/6Qm5+EDXySviZtNhuxc4m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730791; c=relaxed/simple;
	bh=h/dlVPt4oD+webp88viMeRjtBVIAYQN3slw7CDTjU0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzBoRTmHwFtUI8oThMKbz5K9i6/+Rw6GW793SVEAig4fmEZKnii7DVLa+UgDoQWE7JGgbfuPswXN9fe+pAcUp53alDetqI5crmgPpOnoF7HUMOid7CIAXhJQnIoFzoxP3BnNGXZ8MVNU00bxi2+lAOvFh0K8aU26DY2rwuWJl54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv6zaYtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv6zaYtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7266CC32786;
	Thu, 15 Aug 2024 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730791;
	bh=h/dlVPt4oD+webp88viMeRjtBVIAYQN3slw7CDTjU0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nv6zaYtb4wTTUUTkd6VFOCXJpd7T1fmRNzBv3s0BxgsXYq66kyj2zKrAm+kTU9U0b
	 rtMXrRpZjm8afE4F+Uo5uEPogoOczhi32IZE7JfVUVBVk046VxcvXDulLC5KpbuCvd
	 yj1oWvevqa9JUB8InX6HgSOt8/p04s3IlL1WZaMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/38] drm/i915: Add a function to mmap framebuffer obj
Date: Thu, 15 Aug 2024 15:26:06 +0200
Message-ID: <20240815131834.192441999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit eaee1c08586395182e0004b3512a2f83570ea461 ]

Implement i915_gem_fb_mmap() to enable fb_ops.fb_mmap()
callback for i915's framebuffer objects.

v2: add a comment why i915_gem_object_get() needed(Andi).
v3: mmap also ttm objects.

Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230404143100.10452-3-nirmoy.das@intel.com
Stable-dep-of: 1ac5167b3a90 ("drm/i915/gem: Adjust vma offset for framebuffer mmap offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 137 +++++++++++++++--------
 drivers/gpu/drm/i915/gem/i915_gem_mman.h |   2 +-
 2 files changed, 93 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 1fd704d9cf9a9..180b66f6193cb 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -969,53 +969,15 @@ static struct file *mmap_singleton(struct drm_i915_private *i915)
 	return file;
 }
 
-/*
- * This overcomes the limitation in drm_gem_mmap's assignment of a
- * drm_gem_object as the vma->vm_private_data. Since we need to
- * be able to resolve multiple mmap offsets which could be tied
- * to a single gem object.
- */
-int i915_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+static int
+i915_gem_object_mmap(struct drm_i915_gem_object *obj,
+		     struct i915_mmap_offset *mmo,
+		     struct vm_area_struct *vma)
 {
-	struct drm_vma_offset_node *node;
-	struct drm_file *priv = filp->private_data;
-	struct drm_device *dev = priv->minor->dev;
-	struct drm_i915_gem_object *obj = NULL;
-	struct i915_mmap_offset *mmo = NULL;
+	struct drm_i915_private *i915 = to_i915(obj->base.dev);
+	struct drm_device *dev = &i915->drm;
 	struct file *anon;
 
-	if (drm_dev_is_unplugged(dev))
-		return -ENODEV;
-
-	rcu_read_lock();
-	drm_vma_offset_lock_lookup(dev->vma_offset_manager);
-	node = drm_vma_offset_exact_lookup_locked(dev->vma_offset_manager,
-						  vma->vm_pgoff,
-						  vma_pages(vma));
-	if (node && drm_vma_node_is_allowed(node, priv)) {
-		/*
-		 * Skip 0-refcnted objects as it is in the process of being
-		 * destroyed and will be invalid when the vma manager lock
-		 * is released.
-		 */
-		if (!node->driver_private) {
-			mmo = container_of(node, struct i915_mmap_offset, vma_node);
-			obj = i915_gem_object_get_rcu(mmo->obj);
-
-			GEM_BUG_ON(obj && obj->ops->mmap_ops);
-		} else {
-			obj = i915_gem_object_get_rcu
-				(container_of(node, struct drm_i915_gem_object,
-					      base.vma_node));
-
-			GEM_BUG_ON(obj && !obj->ops->mmap_ops);
-		}
-	}
-	drm_vma_offset_unlock_lookup(dev->vma_offset_manager);
-	rcu_read_unlock();
-	if (!obj)
-		return node ? -EACCES : -EINVAL;
-
 	if (i915_gem_object_is_readonly(obj)) {
 		if (vma->vm_flags & VM_WRITE) {
 			i915_gem_object_put(obj);
@@ -1047,7 +1009,7 @@ int i915_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (obj->ops->mmap_ops) {
 		vma->vm_page_prot = pgprot_decrypted(vm_get_page_prot(vma->vm_flags));
 		vma->vm_ops = obj->ops->mmap_ops;
-		vma->vm_private_data = node->driver_private;
+		vma->vm_private_data = obj->base.vma_node.driver_private;
 		return 0;
 	}
 
@@ -1085,6 +1047,91 @@ int i915_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
+/*
+ * This overcomes the limitation in drm_gem_mmap's assignment of a
+ * drm_gem_object as the vma->vm_private_data. Since we need to
+ * be able to resolve multiple mmap offsets which could be tied
+ * to a single gem object.
+ */
+int i915_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct drm_vma_offset_node *node;
+	struct drm_file *priv = filp->private_data;
+	struct drm_device *dev = priv->minor->dev;
+	struct drm_i915_gem_object *obj = NULL;
+	struct i915_mmap_offset *mmo = NULL;
+
+	if (drm_dev_is_unplugged(dev))
+		return -ENODEV;
+
+	rcu_read_lock();
+	drm_vma_offset_lock_lookup(dev->vma_offset_manager);
+	node = drm_vma_offset_exact_lookup_locked(dev->vma_offset_manager,
+						  vma->vm_pgoff,
+						  vma_pages(vma));
+	if (node && drm_vma_node_is_allowed(node, priv)) {
+		/*
+		 * Skip 0-refcnted objects as it is in the process of being
+		 * destroyed and will be invalid when the vma manager lock
+		 * is released.
+		 */
+		if (!node->driver_private) {
+			mmo = container_of(node, struct i915_mmap_offset, vma_node);
+			obj = i915_gem_object_get_rcu(mmo->obj);
+
+			GEM_BUG_ON(obj && obj->ops->mmap_ops);
+		} else {
+			obj = i915_gem_object_get_rcu
+				(container_of(node, struct drm_i915_gem_object,
+					      base.vma_node));
+
+			GEM_BUG_ON(obj && !obj->ops->mmap_ops);
+		}
+	}
+	drm_vma_offset_unlock_lookup(dev->vma_offset_manager);
+	rcu_read_unlock();
+	if (!obj)
+		return node ? -EACCES : -EINVAL;
+
+	return i915_gem_object_mmap(obj, mmo, vma);
+}
+
+int i915_gem_fb_mmap(struct drm_i915_gem_object *obj, struct vm_area_struct *vma)
+{
+	struct drm_i915_private *i915 = to_i915(obj->base.dev);
+	struct drm_device *dev = &i915->drm;
+	struct i915_mmap_offset *mmo = NULL;
+	enum i915_mmap_type mmap_type;
+	struct i915_ggtt *ggtt = to_gt(i915)->ggtt;
+
+	if (drm_dev_is_unplugged(dev))
+		return -ENODEV;
+
+	/* handle ttm object */
+	if (obj->ops->mmap_ops) {
+		/*
+		 * ttm fault handler, ttm_bo_vm_fault_reserved() uses fake offset
+		 * to calculate page offset so set that up.
+		 */
+		vma->vm_pgoff += drm_vma_node_start(&obj->base.vma_node);
+	} else {
+		/* handle stolen and smem objects */
+		mmap_type = i915_ggtt_has_aperture(ggtt) ? I915_MMAP_TYPE_GTT : I915_MMAP_TYPE_WC;
+		mmo = mmap_offset_attach(obj, mmap_type, NULL);
+		if (!mmo)
+			return -ENODEV;
+	}
+
+	/*
+	 * When we install vm_ops for mmap we are too late for
+	 * the vm_ops->open() which increases the ref_count of
+	 * this obj and then it gets decreased by the vm_ops->close().
+	 * To balance this increase the obj ref_count here.
+	 */
+	obj = i915_gem_object_get(obj);
+	return i915_gem_object_mmap(obj, mmo, vma);
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftests/i915_gem_mman.c"
 #endif
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.h b/drivers/gpu/drm/i915/gem/i915_gem_mman.h
index 1fa91b3033b35..196417fd0f5c4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.h
@@ -29,5 +29,5 @@ void i915_gem_object_release_mmap_gtt(struct drm_i915_gem_object *obj);
 
 void i915_gem_object_runtime_pm_release_mmap_offset(struct drm_i915_gem_object *obj);
 void i915_gem_object_release_mmap_offset(struct drm_i915_gem_object *obj);
-
+int i915_gem_fb_mmap(struct drm_i915_gem_object *obj, struct vm_area_struct *vma);
 #endif
-- 
2.43.0



