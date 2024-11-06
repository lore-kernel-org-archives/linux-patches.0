Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27151DE4EA;
	Wed,  6 Nov 2024 12:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896121; cv=none; b=IquRDJPWfHN2F//Sr0Nf/HWoB5nff6xb+US0hiuwMPy6MO9f9RVB7AzkM8a6PsKkV+Tfu470NzSFd/A78VaVvnVJkv3ltxlARX6XlUai6HWlScghF+Ltfhc33goVmG39VOzziRRcHnOxr9e6IEWtJ98dHCys50aGgjJso0PGPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896121; c=relaxed/simple;
	bh=jCjHbih9tIprlF4BormAhU8gl54BkSSiJNCz5l1zjsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2asp9My3AzizrNHA0xNlRPj56Uo/LQMpB73XtdhoZ161OeHYoFPHVN1f6KbwRU7du0q1WnQ9j3aQkFGFABZrBNqA2B5GSpfqxG0SYP09hi4DAwjKbtXQcTLYG8+jXOmNa9s+44kCsa0bd8Ia0aWGKToaJSSQQtwzr3dlVZZq3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAn/WgDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAn/WgDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DA6C4CECD;
	Wed,  6 Nov 2024 12:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896120;
	bh=jCjHbih9tIprlF4BormAhU8gl54BkSSiJNCz5l1zjsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAn/WgDxgR3LINLbj8EiPFgGr/yTcP5pon5z9NIBjZbIxHu4TIP8pPNRD+CuGRA8n
	 23tsbp1r3eXry1ATWBiSf2/LmP/Jrgt1/iu5WcdUGEmRlEx/WUGR5oJDGrjojR1zeL
	 xxLs4IQwnF8b+8ky19rq2ebL6E1EyYKMXmyYlJfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 079/245] drm/panthor: Fix firmware initialization on systems with a page size > 4k
Date: Wed,  6 Nov 2024 13:02:12 +0100
Message-ID: <20241106120321.150505702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 5d01b56f0518d80211812420a8907ca0b6c6e4e3 ]

The system and GPU MMU page size might differ, which becomes a
problem for FW sections that need to be mapped at explicit addresses
since our PAGE_SIZE alignment might cover a VA range that's
expected to be used for another section.

Make sure we never map more than we need.

Changes in v3:
- Add R-bs

Changes in v2:
- Plan for per-VM page sizes so the MCU VM and user VM can
  have different pages sizes

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241030150231.768949-1-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c  |  4 ++--
 drivers/gpu/drm/panthor/panthor_gem.c | 11 ++++++++---
 drivers/gpu/drm/panthor/panthor_mmu.c | 16 +++++++++++++---
 drivers/gpu/drm/panthor/panthor_mmu.h |  1 +
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.c b/drivers/gpu/drm/panthor/panthor_fw.c
index ef232c0c20493..4e2d3a02ea068 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -487,6 +487,7 @@ static int panthor_fw_load_section_entry(struct panthor_device *ptdev,
 					 struct panthor_fw_binary_iter *iter,
 					 u32 ehdr)
 {
+	ssize_t vm_pgsz = panthor_vm_page_size(ptdev->fw->vm);
 	struct panthor_fw_binary_section_entry_hdr hdr;
 	struct panthor_fw_section *section;
 	u32 section_size;
@@ -515,8 +516,7 @@ static int panthor_fw_load_section_entry(struct panthor_device *ptdev,
 		return -EINVAL;
 	}
 
-	if ((hdr.va.start & ~PAGE_MASK) != 0 ||
-	    (hdr.va.end & ~PAGE_MASK) != 0) {
+	if (!IS_ALIGNED(hdr.va.start, vm_pgsz) || !IS_ALIGNED(hdr.va.end, vm_pgsz)) {
 		drm_err(&ptdev->base, "Firmware corrupted, virtual addresses not page aligned: 0x%x-0x%x\n",
 			hdr.va.start, hdr.va.end);
 		return -EINVAL;
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 38f560864879c..be97d56bc011d 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -44,8 +44,7 @@ void panthor_kernel_bo_destroy(struct panthor_kernel_bo *bo)
 			to_panthor_bo(bo->obj)->exclusive_vm_root_gem != panthor_vm_root_gem(vm)))
 		goto out_free_bo;
 
-	ret = panthor_vm_unmap_range(vm, bo->va_node.start,
-				     panthor_kernel_bo_size(bo));
+	ret = panthor_vm_unmap_range(vm, bo->va_node.start, bo->va_node.size);
 	if (ret)
 		goto out_free_bo;
 
@@ -95,10 +94,16 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 	}
 
 	bo = to_panthor_bo(&obj->base);
-	size = obj->base.size;
 	kbo->obj = &obj->base;
 	bo->flags = bo_flags;
 
+	/* The system and GPU MMU page size might differ, which becomes a
+	 * problem for FW sections that need to be mapped at explicit address
+	 * since our PAGE_SIZE alignment might cover a VA range that's
+	 * expected to be used for another section.
+	 * Make sure we never map more than we need.
+	 */
+	size = ALIGN(size, panthor_vm_page_size(vm));
 	ret = panthor_vm_alloc_va(vm, gpu_va, size, &kbo->va_node);
 	if (ret)
 		goto err_put_obj;
diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index ce8e8a93d7076..837ba312f3a8b 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -826,6 +826,14 @@ void panthor_vm_idle(struct panthor_vm *vm)
 	mutex_unlock(&ptdev->mmu->as.slots_lock);
 }
 
+u32 panthor_vm_page_size(struct panthor_vm *vm)
+{
+	const struct io_pgtable *pgt = io_pgtable_ops_to_pgtable(vm->pgtbl_ops);
+	u32 pg_shift = ffs(pgt->cfg.pgsize_bitmap) - 1;
+
+	return 1u << pg_shift;
+}
+
 static void panthor_vm_stop(struct panthor_vm *vm)
 {
 	drm_sched_stop(&vm->sched, NULL);
@@ -1025,12 +1033,13 @@ int
 panthor_vm_alloc_va(struct panthor_vm *vm, u64 va, u64 size,
 		    struct drm_mm_node *va_node)
 {
+	ssize_t vm_pgsz = panthor_vm_page_size(vm);
 	int ret;
 
-	if (!size || (size & ~PAGE_MASK))
+	if (!size || !IS_ALIGNED(size, vm_pgsz))
 		return -EINVAL;
 
-	if (va != PANTHOR_VM_KERNEL_AUTO_VA && (va & ~PAGE_MASK))
+	if (va != PANTHOR_VM_KERNEL_AUTO_VA && !IS_ALIGNED(va, vm_pgsz))
 		return -EINVAL;
 
 	mutex_lock(&vm->mm_lock);
@@ -2366,11 +2375,12 @@ panthor_vm_bind_prepare_op_ctx(struct drm_file *file,
 			       const struct drm_panthor_vm_bind_op *op,
 			       struct panthor_vm_op_ctx *op_ctx)
 {
+	ssize_t vm_pgsz = panthor_vm_page_size(vm);
 	struct drm_gem_object *gem;
 	int ret;
 
 	/* Aligned on page size. */
-	if ((op->va | op->size) & ~PAGE_MASK)
+	if (!IS_ALIGNED(op->va | op->size, vm_pgsz))
 		return -EINVAL;
 
 	switch (op->flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) {
diff --git a/drivers/gpu/drm/panthor/panthor_mmu.h b/drivers/gpu/drm/panthor/panthor_mmu.h
index 6788771071e35..8d21e83d8aba1 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.h
+++ b/drivers/gpu/drm/panthor/panthor_mmu.h
@@ -30,6 +30,7 @@ panthor_vm_get_bo_for_va(struct panthor_vm *vm, u64 va, u64 *bo_offset);
 
 int panthor_vm_active(struct panthor_vm *vm);
 void panthor_vm_idle(struct panthor_vm *vm);
+u32 panthor_vm_page_size(struct panthor_vm *vm);
 int panthor_vm_as(struct panthor_vm *vm);
 int panthor_vm_flush_all(struct panthor_vm *vm);
 
-- 
2.43.0



