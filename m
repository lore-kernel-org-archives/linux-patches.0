Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0638F232787;
	Mon, 10 Mar 2025 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626651; cv=none; b=jiW/0nWmHB13SL4gipyKq/ExrD16uqMAzECkUb6MDRWj6COLVAWsujDMNax3hfdkazNbTyJogM0PJMNlMHW3ayk/FkEDeaVpNfwwQe5ZaYZ3RBwDO9WTuRiORVWybgYa0VqWUWpqP4oyV+5YR1WG+0YL74IQ4lh5c8KKgmXGbWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626651; c=relaxed/simple;
	bh=X/Z0heMr3HPAfVaIjYbkUvzkLa43h75AJAMZx8tqr1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMRrIkuN1EJj+Q/+OayyKUXvIIDZci5IXFYGz1Ct+w8CDyvi1AzLlVm4OyweO4ise0CzItUlZxe6PRcunH2knP7RnNSgGnM6yYXJ4fl0mv2E5hb7mw0chyitXic+MSRPvKHLSwsZgqb7raRHSg5zbKhYHKO7dCSx8Bk0Ax8Xp1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyylUeiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyylUeiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8659AC4CEE5;
	Mon, 10 Mar 2025 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626650;
	bh=X/Z0heMr3HPAfVaIjYbkUvzkLa43h75AJAMZx8tqr1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyylUeiR105t6d1AF+DNY7S16fKrjqWtwksbf4Gyir5YzTcEQR1V7Lw0SJXtVJ4x+
	 Va443mLuQpfY+OiUNZKsVMtHbPuKYG9iryBU23z2Dg4YnXQ83mLxwZCtzesSBXHnNq
	 I78Pl9dgw27TzFBvGCNwPohvx6qLAB7tFofJ89HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan King <brendan.king@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.13 038/207] drm/imagination: Hold drm_gem_gpuva lock for unmap
Date: Mon, 10 Mar 2025 18:03:51 +0100
Message-ID: <20250310170449.288114767@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan King <Brendan.King@imgtec.com>

commit a5c4c3ba95a52d66315acdfbaba9bd82ed39c250 upstream.

Avoid a warning from drm_gem_gpuva_assert_lock_held in drm_gpuva_unlink.

The Imagination driver uses the GEM object reservation lock to protect
the gpuva list, but the GEM object was not always known in the code
paths that ended up calling drm_gpuva_unlink. When the GEM object isn't
known, it is found by calling drm_gpuva_find to lookup the object
associated with a given virtual address range, or by calling
drm_gpuva_find_first when removing all mappings.

Cc: stable@vger.kernel.org
Fixes: 4bc736f890ce ("drm/imagination: vm: make use of GPUVM's drm_exec helper")
Signed-off-by: Brendan King <brendan.king@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226-hold-drm_gem_gpuva-lock-for-unmap-v2-1-3fdacded227f@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_fw_meta.c |    6 -
 drivers/gpu/drm/imagination/pvr_vm.c      |  134 ++++++++++++++++++++++++------
 drivers/gpu/drm/imagination/pvr_vm.h      |    3 
 3 files changed, 115 insertions(+), 28 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_fw_meta.c
+++ b/drivers/gpu/drm/imagination/pvr_fw_meta.c
@@ -527,8 +527,10 @@ pvr_meta_vm_map(struct pvr_device *pvr_d
 static void
 pvr_meta_vm_unmap(struct pvr_device *pvr_dev, struct pvr_fw_object *fw_obj)
 {
-	pvr_vm_unmap(pvr_dev->kernel_vm_ctx, fw_obj->fw_mm_node.start,
-		     fw_obj->fw_mm_node.size);
+	struct pvr_gem_object *pvr_obj = fw_obj->gem;
+
+	pvr_vm_unmap_obj(pvr_dev->kernel_vm_ctx, pvr_obj,
+			 fw_obj->fw_mm_node.start, fw_obj->fw_mm_node.size);
 }
 
 static bool
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -293,8 +293,9 @@ err_bind_op_fini:
 
 static int
 pvr_vm_bind_op_unmap_init(struct pvr_vm_bind_op *bind_op,
-			  struct pvr_vm_context *vm_ctx, u64 device_addr,
-			  u64 size)
+			  struct pvr_vm_context *vm_ctx,
+			  struct pvr_gem_object *pvr_obj,
+			  u64 device_addr, u64 size)
 {
 	int err;
 
@@ -318,6 +319,7 @@ pvr_vm_bind_op_unmap_init(struct pvr_vm_
 		goto err_bind_op_fini;
 	}
 
+	bind_op->pvr_obj = pvr_obj;
 	bind_op->vm_ctx = vm_ctx;
 	bind_op->device_addr = device_addr;
 	bind_op->size = size;
@@ -598,20 +600,6 @@ err_free:
 }
 
 /**
- * pvr_vm_unmap_all() - Unmap all mappings associated with a VM context.
- * @vm_ctx: Target VM context.
- *
- * This function ensures that no mappings are left dangling by unmapping them
- * all in order of ascending device-virtual address.
- */
-void
-pvr_vm_unmap_all(struct pvr_vm_context *vm_ctx)
-{
-	WARN_ON(pvr_vm_unmap(vm_ctx, vm_ctx->gpuvm_mgr.mm_start,
-			     vm_ctx->gpuvm_mgr.mm_range));
-}
-
-/**
  * pvr_vm_context_release() - Teardown a VM context.
  * @ref_count: Pointer to reference counter of the VM context.
  *
@@ -703,11 +691,7 @@ pvr_vm_lock_extra(struct drm_gpuvm_exec
 	struct pvr_vm_bind_op *bind_op = vm_exec->extra.priv;
 	struct pvr_gem_object *pvr_obj = bind_op->pvr_obj;
 
-	/* Unmap operations don't have an object to lock. */
-	if (!pvr_obj)
-		return 0;
-
-	/* Acquire lock on the GEM being mapped. */
+	/* Acquire lock on the GEM object being mapped/unmapped. */
 	return drm_exec_lock_obj(&vm_exec->exec, gem_from_pvr_gem(pvr_obj));
 }
 
@@ -772,8 +756,10 @@ err_cleanup:
 }
 
 /**
- * pvr_vm_unmap() - Unmap an already mapped section of device-virtual memory.
+ * pvr_vm_unmap_obj_locked() - Unmap an already mapped section of device-virtual
+ * memory.
  * @vm_ctx: Target VM context.
+ * @pvr_obj: Target PowerVR memory object.
  * @device_addr: Virtual device address at the start of the target mapping.
  * @size: Size of the target mapping.
  *
@@ -784,9 +770,13 @@ err_cleanup:
  *  * Any error encountered while performing internal operations required to
  *    destroy the mapping (returned from pvr_vm_gpuva_unmap or
  *    pvr_vm_gpuva_remap).
+ *
+ * The vm_ctx->lock must be held when calling this function.
  */
-int
-pvr_vm_unmap(struct pvr_vm_context *vm_ctx, u64 device_addr, u64 size)
+static int
+pvr_vm_unmap_obj_locked(struct pvr_vm_context *vm_ctx,
+			struct pvr_gem_object *pvr_obj,
+			u64 device_addr, u64 size)
 {
 	struct pvr_vm_bind_op bind_op = {0};
 	struct drm_gpuvm_exec vm_exec = {
@@ -799,11 +789,13 @@ pvr_vm_unmap(struct pvr_vm_context *vm_c
 		},
 	};
 
-	int err = pvr_vm_bind_op_unmap_init(&bind_op, vm_ctx, device_addr,
-					    size);
+	int err = pvr_vm_bind_op_unmap_init(&bind_op, vm_ctx, pvr_obj,
+					    device_addr, size);
 	if (err)
 		return err;
 
+	pvr_gem_object_get(pvr_obj);
+
 	err = drm_gpuvm_exec_lock(&vm_exec);
 	if (err)
 		goto err_cleanup;
@@ -818,6 +810,96 @@ err_cleanup:
 	return err;
 }
 
+/**
+ * pvr_vm_unmap_obj() - Unmap an already mapped section of device-virtual
+ * memory.
+ * @vm_ctx: Target VM context.
+ * @pvr_obj: Target PowerVR memory object.
+ * @device_addr: Virtual device address at the start of the target mapping.
+ * @size: Size of the target mapping.
+ *
+ * Return:
+ *  * 0 on success,
+ *  * Any error encountered by pvr_vm_unmap_obj_locked.
+ */
+int
+pvr_vm_unmap_obj(struct pvr_vm_context *vm_ctx, struct pvr_gem_object *pvr_obj,
+		 u64 device_addr, u64 size)
+{
+	int err;
+
+	mutex_lock(&vm_ctx->lock);
+	err = pvr_vm_unmap_obj_locked(vm_ctx, pvr_obj, device_addr, size);
+	mutex_unlock(&vm_ctx->lock);
+
+	return err;
+}
+
+/**
+ * pvr_vm_unmap() - Unmap an already mapped section of device-virtual memory.
+ * @vm_ctx: Target VM context.
+ * @device_addr: Virtual device address at the start of the target mapping.
+ * @size: Size of the target mapping.
+ *
+ * Return:
+ *  * 0 on success,
+ *  * Any error encountered by drm_gpuva_find,
+ *  * Any error encountered by pvr_vm_unmap_obj_locked.
+ */
+int
+pvr_vm_unmap(struct pvr_vm_context *vm_ctx, u64 device_addr, u64 size)
+{
+	struct pvr_gem_object *pvr_obj;
+	struct drm_gpuva *va;
+	int err;
+
+	mutex_lock(&vm_ctx->lock);
+
+	va = drm_gpuva_find(&vm_ctx->gpuvm_mgr, device_addr, size);
+	if (va) {
+		pvr_obj = gem_to_pvr_gem(va->gem.obj);
+		err = pvr_vm_unmap_obj_locked(vm_ctx, pvr_obj,
+					      va->va.addr, va->va.range);
+	} else {
+		err = -ENOENT;
+	}
+
+	mutex_unlock(&vm_ctx->lock);
+
+	return err;
+}
+
+/**
+ * pvr_vm_unmap_all() - Unmap all mappings associated with a VM context.
+ * @vm_ctx: Target VM context.
+ *
+ * This function ensures that no mappings are left dangling by unmapping them
+ * all in order of ascending device-virtual address.
+ */
+void
+pvr_vm_unmap_all(struct pvr_vm_context *vm_ctx)
+{
+	mutex_lock(&vm_ctx->lock);
+
+	for (;;) {
+		struct pvr_gem_object *pvr_obj;
+		struct drm_gpuva *va;
+
+		va = drm_gpuva_find_first(&vm_ctx->gpuvm_mgr,
+					  vm_ctx->gpuvm_mgr.mm_start,
+					  vm_ctx->gpuvm_mgr.mm_range);
+		if (!va)
+			break;
+
+		pvr_obj = gem_to_pvr_gem(va->gem.obj);
+
+		WARN_ON(pvr_vm_unmap_obj_locked(vm_ctx, pvr_obj,
+						va->va.addr, va->va.range));
+	}
+
+	mutex_unlock(&vm_ctx->lock);
+}
+
 /* Static data areas are determined by firmware. */
 static const struct drm_pvr_static_data_area static_data_areas[] = {
 	{
--- a/drivers/gpu/drm/imagination/pvr_vm.h
+++ b/drivers/gpu/drm/imagination/pvr_vm.h
@@ -38,6 +38,9 @@ struct pvr_vm_context *pvr_vm_create_con
 int pvr_vm_map(struct pvr_vm_context *vm_ctx,
 	       struct pvr_gem_object *pvr_obj, u64 pvr_obj_offset,
 	       u64 device_addr, u64 size);
+int pvr_vm_unmap_obj(struct pvr_vm_context *vm_ctx,
+		     struct pvr_gem_object *pvr_obj,
+		     u64 device_addr, u64 size);
 int pvr_vm_unmap(struct pvr_vm_context *vm_ctx, u64 device_addr, u64 size);
 void pvr_vm_unmap_all(struct pvr_vm_context *vm_ctx);
 


