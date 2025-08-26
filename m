Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DDA26AEC;
	Tue, 26 Aug 2025 11:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208023; cv=none; b=ghyTl5oke27DBFb29SwciRGN30M9QG0SJOwW2F/hG2h5Xrk3pfyVFwk2ee1B2xuBmZ/GDe30iHmw6UCk68SUXgIL619bx3tgkVgPjeTWcSHrDFW2dO6p3mJXFtOFelWqV6hOWnPZywofJtsukbs8XKYYbFve7UrMCWIrfqd1so0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208023; c=relaxed/simple;
	bh=pOgpfR0WO1+XJIJ28zlO7QbQObHQkL8MXSgegfMN+iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3SVpPSeA/FldurkMZl73d58o4WAwDlngwT6qcmKCZfbGb+giu20wdE6M3cTlm/Jv5SB/fXizWOmEqFUsQv7GPaOFjTppIIphnpy5LK0h/z1bMnnCxAnA6QJYhMRsinTeTvBB6M3ccFIJJWRsdDGn0a97m4njAiO0EkhOK9lKEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhO5/gWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhO5/gWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE017C4CEF1;
	Tue, 26 Aug 2025 11:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208023;
	bh=pOgpfR0WO1+XJIJ28zlO7QbQObHQkL8MXSgegfMN+iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhO5/gWu1uSYoaYdOsHd8VVpw9lUKar7RIAQOqnctsXRsCfe8EUIFm6O6NqtxSrGc
	 ULIid6NZAC/6Vi92rDFQ2Dqykgwj7aOq39/t4dsLIP8cdhmp8xSNEXL23d0yvQTfjT
	 y0+PZWEFIE6ZAjPDqvhZipl8iEL2eB3gRKFttP3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 408/457] drm/xe: Assign ioctl xe file handler to vm in xe_vm_create
Date: Tue, 26 Aug 2025 13:11:32 +0200
Message-ID: <20250826110947.378230740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit 658a1c8e0a66d0777e0e37a11ba19f27a81e77f4 ]

In several code paths, such as xe_pt_create(), the vm->xef field is used
to determine whether a VM originates from userspace or the kernel.

Previously, this handler was only assigned in xe_vm_create_ioctl(),
after the VM was created by xe_vm_create(). However, xe_vm_create()
triggers page table creation, and that function assumes vm->xef should
be already set. This could lead to incorrect origin detection.

To fix this problem and ensure consistency in the initialization of
the VM object, let's move the assignment of this handler to
xe_vm_create.

v2:
 - take reference to the xe file object only when xef is not NULL
 - release the reference to the xe file object on the error path (Matthew)

Fixes: 7f387e6012b6 ("drm/xe: add XE_BO_FLAG_PINNED_LATE_RESTORE")
Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250811104358.2064150-2-piotr.piorkowski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
(cherry picked from commit 9337166fa1d80f7bb7c7d3a8f901f21c348c0f2a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c    |  2 +-
 drivers/gpu/drm/xe/xe_pxp_submit.c |  2 +-
 drivers/gpu/drm/xe/xe_vm.c         | 11 ++++++-----
 drivers/gpu/drm/xe/xe_vm.h         |  2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 1e3fd139dfcb..0a481190f3e6 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -408,7 +408,7 @@ struct xe_migrate *xe_migrate_init(struct xe_tile *tile)
 
 	/* Special layout, prepared below.. */
 	vm = xe_vm_create(xe, XE_VM_FLAG_MIGRATION |
-			  XE_VM_FLAG_SET_TILE_ID(tile));
+			  XE_VM_FLAG_SET_TILE_ID(tile), NULL);
 	if (IS_ERR(vm))
 		return ERR_CAST(vm);
 
diff --git a/drivers/gpu/drm/xe/xe_pxp_submit.c b/drivers/gpu/drm/xe/xe_pxp_submit.c
index d92ec0f515b0..ca95f2a4d4ef 100644
--- a/drivers/gpu/drm/xe/xe_pxp_submit.c
+++ b/drivers/gpu/drm/xe/xe_pxp_submit.c
@@ -101,7 +101,7 @@ static int allocate_gsc_client_resources(struct xe_gt *gt,
 	xe_assert(xe, hwe);
 
 	/* PXP instructions must be issued from PPGTT */
-	vm = xe_vm_create(xe, XE_VM_FLAG_GSC);
+	vm = xe_vm_create(xe, XE_VM_FLAG_GSC, NULL);
 	if (IS_ERR(vm))
 		return PTR_ERR(vm);
 
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 861577746929..7251f23b919c 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1612,7 +1612,7 @@ static void xe_vm_free_scratch(struct xe_vm *vm)
 	}
 }
 
-struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
+struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef)
 {
 	struct drm_gem_object *vm_resv_obj;
 	struct xe_vm *vm;
@@ -1633,9 +1633,10 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 	vm->xe = xe;
 
 	vm->size = 1ull << xe->info.va_bits;
-
 	vm->flags = flags;
 
+	if (xef)
+		vm->xef = xe_file_get(xef);
 	/**
 	 * GSC VMs are kernel-owned, only used for PXP ops and can sometimes be
 	 * manipulated under the PXP mutex. However, the PXP mutex can be taken
@@ -1786,6 +1787,8 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 	for_each_tile(tile, xe, id)
 		xe_range_fence_tree_fini(&vm->rftree[id]);
 	ttm_lru_bulk_move_fini(&xe->ttm, &vm->lru_bulk_move);
+	if (vm->xef)
+		xe_file_put(vm->xef);
 	kfree(vm);
 	if (flags & XE_VM_FLAG_LR_MODE)
 		xe_pm_runtime_put(xe);
@@ -2069,7 +2072,7 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	if (args->flags & DRM_XE_VM_CREATE_FLAG_FAULT_MODE)
 		flags |= XE_VM_FLAG_FAULT_MODE;
 
-	vm = xe_vm_create(xe, flags);
+	vm = xe_vm_create(xe, flags, xef);
 	if (IS_ERR(vm))
 		return PTR_ERR(vm);
 
@@ -2085,8 +2088,6 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 		vm->usm.asid = asid;
 	}
 
-	vm->xef = xe_file_get(xef);
-
 	/* Record BO memory for VM pagetable created against client */
 	for_each_tile(tile, xe, id)
 		if (vm->pt_root[id])
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index 494af6bdc646..0158ec0ae3b2 100644
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -26,7 +26,7 @@ struct xe_sync_entry;
 struct xe_svm_range;
 struct drm_exec;
 
-struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags);
+struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef);
 
 struct xe_vm *xe_vm_lookup(struct xe_file *xef, u32 id);
 int xe_vma_cmp_vma_cb(const void *key, const struct rb_node *node);
-- 
2.50.1



