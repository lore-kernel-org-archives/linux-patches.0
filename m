Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDDE1CF5E7;
	Wed,  2 Oct 2024 13:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875778; cv=none; b=S4D9nc8X5jL8q0tqB2StH3mXKRci1UQxj8JVAUe/Vbw343BRSNU6VVDLTMUKGmLV2g0ORCnayL7zU7rRPCiXwBvmR56siabUTpJG5rvNEARrzQXZ0M6Lj084/NvEy5KNfzOktYu9bd2N1qjoXXZAmZebk1wxvGJT48W2cOBjdM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875778; c=relaxed/simple;
	bh=xYpZQmf8eQZHchNYpqrm0JR9eg8R5Iz9rieevI05nII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q3sOe1JsYB7GvoWuyyRTOVAqOunCU1FEYBbHz5oiTifGvXZeLm8nFI5etSVrUxwBAnTJOtRzcWu8NPvXn4/4nPIfUdA+TwEJuIhYO58KDzVCxe7b3z9my2ueuXpOH/rTC63v0zoCu92GnmYdyzLznkzUtpqoOs3HLvEd3SnIjxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUJr/+FL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUJr/+FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38196C4CEC5;
	Wed,  2 Oct 2024 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875777;
	bh=xYpZQmf8eQZHchNYpqrm0JR9eg8R5Iz9rieevI05nII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUJr/+FLMHuxN4K+cnEHMgAKXK4TMUXUXtOu7m5PMgWgnug8DubCD6MtHiemLb2aU
	 IvMDfFUBxifOVruojiwDLeGfZbKXuPD4KT5WhhEw8q0y1ECHwvA8NXcgjrFxPDOrvG
	 TtpSfx3iBZ5T9V2771j8N2rYGKAg22a3gVrr4LWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 216/695] drm/xe: Use reserved copy engine for user binds on faulting devices
Date: Wed,  2 Oct 2024 14:53:34 +0200
Message-ID: <20241002125831.084299900@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 852856e3b6f679c694dd5ec41e5a3c11aa46640b ]

User binds map to engines with can fault, faults depend on user binds
completion, thus we can deadlock. Avoid this by using reserved copy
engine for user binds on faulting devices.

While we are here, normalize bind queue creation with a helper.

v2:
 - Pass in extensions to bind queue creation (CI)
v3:
 - s/resevered/reserved (Lucas)
 - Fix NULL hwe check (Jonathan)

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240816034033.53837-1-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 122 +++++++++++++++--------------
 drivers/gpu/drm/xe/xe_exec_queue.h |   6 +-
 drivers/gpu/drm/xe/xe_migrate.c    |   2 +-
 drivers/gpu/drm/xe/xe_vm.c         |   8 +-
 4 files changed, 70 insertions(+), 68 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index ddc22a8d9bf5f..c2953ddbd16e1 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -166,7 +166,8 @@ struct xe_exec_queue *xe_exec_queue_create(struct xe_device *xe, struct xe_vm *v
 
 struct xe_exec_queue *xe_exec_queue_create_class(struct xe_device *xe, struct xe_gt *gt,
 						 struct xe_vm *vm,
-						 enum xe_engine_class class, u32 flags)
+						 enum xe_engine_class class,
+						 u32 flags, u64 extensions)
 {
 	struct xe_hw_engine *hwe, *hwe0 = NULL;
 	enum xe_hw_engine_id id;
@@ -186,7 +187,54 @@ struct xe_exec_queue *xe_exec_queue_create_class(struct xe_device *xe, struct xe
 	if (!logical_mask)
 		return ERR_PTR(-ENODEV);
 
-	return xe_exec_queue_create(xe, vm, logical_mask, 1, hwe0, flags, 0);
+	return xe_exec_queue_create(xe, vm, logical_mask, 1, hwe0, flags, extensions);
+}
+
+/**
+ * xe_exec_queue_create_bind() - Create bind exec queue.
+ * @xe: Xe device.
+ * @tile: tile which bind exec queue belongs to.
+ * @flags: exec queue creation flags
+ * @extensions: exec queue creation extensions
+ *
+ * Normalize bind exec queue creation. Bind exec queue is tied to migration VM
+ * for access to physical memory required for page table programming. On a
+ * faulting devices the reserved copy engine instance must be used to avoid
+ * deadlocking (user binds cannot get stuck behind faults as kernel binds which
+ * resolve faults depend on user binds). On non-faulting devices any copy engine
+ * can be used.
+ *
+ * Returns exec queue on success, ERR_PTR on failure
+ */
+struct xe_exec_queue *xe_exec_queue_create_bind(struct xe_device *xe,
+						struct xe_tile *tile,
+						u32 flags, u64 extensions)
+{
+	struct xe_gt *gt = tile->primary_gt;
+	struct xe_exec_queue *q;
+	struct xe_vm *migrate_vm;
+
+	migrate_vm = xe_migrate_get_vm(tile->migrate);
+	if (xe->info.has_usm) {
+		struct xe_hw_engine *hwe = xe_gt_hw_engine(gt,
+							   XE_ENGINE_CLASS_COPY,
+							   gt->usm.reserved_bcs_instance,
+							   false);
+
+		if (!hwe)
+			return ERR_PTR(-EINVAL);
+
+		q = xe_exec_queue_create(xe, migrate_vm,
+					 BIT(hwe->logical_instance), 1, hwe,
+					 flags, extensions);
+	} else {
+		q = xe_exec_queue_create_class(xe, gt, migrate_vm,
+					       XE_ENGINE_CLASS_COPY, flags,
+					       extensions);
+	}
+	xe_vm_put(migrate_vm);
+
+	return q;
 }
 
 void xe_exec_queue_destroy(struct kref *ref)
@@ -418,34 +466,6 @@ static int exec_queue_user_extensions(struct xe_device *xe, struct xe_exec_queue
 	return 0;
 }
 
-static u32 bind_exec_queue_logical_mask(struct xe_device *xe, struct xe_gt *gt,
-					struct drm_xe_engine_class_instance *eci,
-					u16 width, u16 num_placements)
-{
-	struct xe_hw_engine *hwe;
-	enum xe_hw_engine_id id;
-	u32 logical_mask = 0;
-
-	if (XE_IOCTL_DBG(xe, width != 1))
-		return 0;
-	if (XE_IOCTL_DBG(xe, num_placements != 1))
-		return 0;
-	if (XE_IOCTL_DBG(xe, eci[0].engine_instance != 0))
-		return 0;
-
-	eci[0].engine_class = DRM_XE_ENGINE_CLASS_COPY;
-
-	for_each_hw_engine(hwe, gt, id) {
-		if (xe_hw_engine_is_reserved(hwe))
-			continue;
-
-		if (hwe->class == XE_ENGINE_CLASS_COPY)
-			logical_mask |= BIT(hwe->logical_instance);
-	}
-
-	return logical_mask;
-}
-
 static u32 calc_validate_logical_mask(struct xe_device *xe, struct xe_gt *gt,
 				      struct drm_xe_engine_class_instance *eci,
 				      u16 width, u16 num_placements)
@@ -507,8 +527,9 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 	struct drm_xe_engine_class_instance __user *user_eci =
 		u64_to_user_ptr(args->instances);
 	struct xe_hw_engine *hwe;
-	struct xe_vm *vm, *migrate_vm;
+	struct xe_vm *vm;
 	struct xe_gt *gt;
+	struct xe_tile *tile;
 	struct xe_exec_queue *q = NULL;
 	u32 logical_mask;
 	u32 id;
@@ -533,37 +554,20 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 		return -EINVAL;
 
 	if (eci[0].engine_class == DRM_XE_ENGINE_CLASS_VM_BIND) {
-		for_each_gt(gt, xe, id) {
-			struct xe_exec_queue *new;
-			u32 flags;
-
-			if (xe_gt_is_media_type(gt))
-				continue;
-
-			eci[0].gt_id = gt->info.id;
-			logical_mask = bind_exec_queue_logical_mask(xe, gt, eci,
-								    args->width,
-								    args->num_placements);
-			if (XE_IOCTL_DBG(xe, !logical_mask))
-				return -EINVAL;
-
-			hwe = xe_hw_engine_lookup(xe, eci[0]);
-			if (XE_IOCTL_DBG(xe, !hwe))
-				return -EINVAL;
-
-			/* The migration vm doesn't hold rpm ref */
-			xe_pm_runtime_get_noresume(xe);
-
-			flags = EXEC_QUEUE_FLAG_VM | (id ? EXEC_QUEUE_FLAG_BIND_ENGINE_CHILD : 0);
+		if (XE_IOCTL_DBG(xe, args->width != 1) ||
+		    XE_IOCTL_DBG(xe, args->num_placements != 1) ||
+		    XE_IOCTL_DBG(xe, eci[0].engine_instance != 0))
+			return -EINVAL;
 
-			migrate_vm = xe_migrate_get_vm(gt_to_tile(gt)->migrate);
-			new = xe_exec_queue_create(xe, migrate_vm, logical_mask,
-						   args->width, hwe, flags,
-						   args->extensions);
+		for_each_tile(tile, xe, id) {
+			struct xe_exec_queue *new;
+			u32 flags = EXEC_QUEUE_FLAG_VM;
 
-			xe_pm_runtime_put(xe); /* now held by engine */
+			if (id)
+				flags |= EXEC_QUEUE_FLAG_BIND_ENGINE_CHILD;
 
-			xe_vm_put(migrate_vm);
+			new = xe_exec_queue_create_bind(xe, tile, flags,
+							args->extensions);
 			if (IS_ERR(new)) {
 				err = PTR_ERR(new);
 				if (q)
diff --git a/drivers/gpu/drm/xe/xe_exec_queue.h b/drivers/gpu/drm/xe/xe_exec_queue.h
index 289a3a51d2a21..f4ba8897763f8 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue.h
@@ -20,7 +20,11 @@ struct xe_exec_queue *xe_exec_queue_create(struct xe_device *xe, struct xe_vm *v
 					   u64 extensions);
 struct xe_exec_queue *xe_exec_queue_create_class(struct xe_device *xe, struct xe_gt *gt,
 						 struct xe_vm *vm,
-						 enum xe_engine_class class, u32 flags);
+						 enum xe_engine_class class,
+						 u32 flags, u64 extensions);
+struct xe_exec_queue *xe_exec_queue_create_bind(struct xe_device *xe,
+						struct xe_tile *tile,
+						u32 flags, u64 extensions);
 
 void xe_exec_queue_fini(struct xe_exec_queue *q);
 void xe_exec_queue_destroy(struct kref *ref);
diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index c9f5673353ee3..a849c48d8ac90 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -404,7 +404,7 @@ struct xe_migrate *xe_migrate_init(struct xe_tile *tile)
 		m->q = xe_exec_queue_create_class(xe, primary_gt, vm,
 						  XE_ENGINE_CLASS_COPY,
 						  EXEC_QUEUE_FLAG_KERNEL |
-						  EXEC_QUEUE_FLAG_PERMANENT);
+						  EXEC_QUEUE_FLAG_PERMANENT, 0);
 	}
 	if (IS_ERR(m->q)) {
 		xe_vm_close_and_put(vm);
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 50e8fc49ba6c1..b49bee0dfac5d 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1412,19 +1412,13 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 	/* Kernel migration VM shouldn't have a circular loop.. */
 	if (!(flags & XE_VM_FLAG_MIGRATION)) {
 		for_each_tile(tile, xe, id) {
-			struct xe_gt *gt = tile->primary_gt;
-			struct xe_vm *migrate_vm;
 			struct xe_exec_queue *q;
 			u32 create_flags = EXEC_QUEUE_FLAG_VM;
 
 			if (!vm->pt_root[id])
 				continue;
 
-			migrate_vm = xe_migrate_get_vm(tile->migrate);
-			q = xe_exec_queue_create_class(xe, gt, migrate_vm,
-						       XE_ENGINE_CLASS_COPY,
-						       create_flags);
-			xe_vm_put(migrate_vm);
+			q = xe_exec_queue_create_bind(xe, tile, create_flags, 0);
 			if (IS_ERR(q)) {
 				err = PTR_ERR(q);
 				goto err_close;
-- 
2.43.0



