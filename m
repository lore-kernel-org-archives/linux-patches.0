Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63899256C78;
	Thu, 17 Apr 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912878; cv=none; b=fwaH0HYj8PKkEuNjv2rsS31InC/q7E0gMl0vSUx9528oRLPJehKpco7lYXYWcUJ8B5RwM1xh4gJANiVfXwA7IcHVKO082hVKQoGTJBjVbQd2FjirD6OHT8sWbAZI3S35vcpNDBKNtT0TpL0ZUh0i+ox/GmutwJBRRZ7sTAyY0Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912878; c=relaxed/simple;
	bh=/rJqhcyM7x1K8gK4IjKwQuFyjV/KFWYNwkk5LjqnWAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ILSNOv9V/2eQCwCPB9dxsjuhZ/1+sgPXQLdJRr5beixwCB0fj+oBUELXgFV8+qYbiG4hcRUf6Sg9g62IsCBA9u7aFUtTtHtCYM8wcsWX0Xmjh9R1PscQQRnkwXJ3yE0gpV+6/ZbvB1cqUcvQozstaR86Z15mAQlIQrvdh1nfA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prVY3dOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prVY3dOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE95DC4CEE4;
	Thu, 17 Apr 2025 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912878;
	bh=/rJqhcyM7x1K8gK4IjKwQuFyjV/KFWYNwkk5LjqnWAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prVY3dOhAJqX9CnT4xnW6GziCN2BGsHXpCdUwfmUE0Sa8LC2A6eCdTuRDHfRbUsE/
	 f/+dOq6BLVFxe4sC1VGA8qX5duRb/IFdUwqz7j7sd+zmxKDWnlML+ymJSN//83XLk3
	 kbZmT+fy+KK1faT2CuWQXoN3QwrCPg/3l+quV7Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 154/449] drm/amdgpu: Unlocked unmap only clear page table leaves
Date: Thu, 17 Apr 2025 19:47:22 +0200
Message-ID: <20250417175124.178712239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 23b645231eeffdaf44021debac881d2f26824150 ]

SVM migration unmap pages from GPU and then update mapping to GPU to
recover page fault. Currently unmap clears the PDE entry for range
length >= huge page and free PTB bo, update mapping to alloc new PT bo.
There is race bug that the freed entry bo maybe still on the pt_free
list, reused when updating mapping and then freed, leave invalid PDE
entry and cause GPU page fault.

By setting the update to clear only one PDE entry or clear PTB, to
avoid unmap to free PTE bo. This fixes the race bug and improve the
unmap and map to GPU performance. Update mapping to huge page will
still free the PTB bo.

With this change, the vm->pt_freed list and work is not needed. Add
WARN_ON(unlocked) in amdgpu_vm_pt_free_dfs to catch if unmap to free the
PTB.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c    |  4 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h    |  4 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c | 43 +++++++----------------
 3 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 5c07777d3239e..22aa4a8f11891 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2534,8 +2534,6 @@ int amdgpu_vm_init(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	spin_lock_init(&vm->status_lock);
 	INIT_LIST_HEAD(&vm->freed);
 	INIT_LIST_HEAD(&vm->done);
-	INIT_LIST_HEAD(&vm->pt_freed);
-	INIT_WORK(&vm->pt_free_work, amdgpu_vm_pt_free_work);
 	INIT_KFIFO(vm->faults);
 
 	r = amdgpu_vm_init_entities(adev, vm);
@@ -2717,8 +2715,6 @@ void amdgpu_vm_fini(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 
 	amdgpu_amdkfd_gpuvm_destroy_cb(adev, vm);
 
-	flush_work(&vm->pt_free_work);
-
 	root = amdgpu_bo_ref(vm->root.bo);
 	amdgpu_bo_reserve(root, true);
 	amdgpu_vm_set_pasid(adev, vm, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
index a3e128e373bc6..5010a3107bf89 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -374,10 +374,6 @@ struct amdgpu_vm {
 	/* BOs which are invalidated, has been updated in the PTs */
 	struct list_head        done;
 
-	/* PT BOs scheduled to free and fill with zero if vm_resv is not hold */
-	struct list_head	pt_freed;
-	struct work_struct	pt_free_work;
-
 	/* contains the page directory */
 	struct amdgpu_vm_bo_base     root;
 	struct dma_fence	*last_update;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index b0bf216821152..30022123b0bf6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -547,27 +547,6 @@ static void amdgpu_vm_pt_free(struct amdgpu_vm_bo_base *entry)
 	amdgpu_bo_unref(&entry->bo);
 }
 
-void amdgpu_vm_pt_free_work(struct work_struct *work)
-{
-	struct amdgpu_vm_bo_base *entry, *next;
-	struct amdgpu_vm *vm;
-	LIST_HEAD(pt_freed);
-
-	vm = container_of(work, struct amdgpu_vm, pt_free_work);
-
-	spin_lock(&vm->status_lock);
-	list_splice_init(&vm->pt_freed, &pt_freed);
-	spin_unlock(&vm->status_lock);
-
-	/* flush_work in amdgpu_vm_fini ensure vm->root.bo is valid. */
-	amdgpu_bo_reserve(vm->root.bo, true);
-
-	list_for_each_entry_safe(entry, next, &pt_freed, vm_status)
-		amdgpu_vm_pt_free(entry);
-
-	amdgpu_bo_unreserve(vm->root.bo);
-}
-
 /**
  * amdgpu_vm_pt_free_list - free PD/PT levels
  *
@@ -580,19 +559,15 @@ void amdgpu_vm_pt_free_list(struct amdgpu_device *adev,
 			    struct amdgpu_vm_update_params *params)
 {
 	struct amdgpu_vm_bo_base *entry, *next;
-	struct amdgpu_vm *vm = params->vm;
 	bool unlocked = params->unlocked;
 
 	if (list_empty(&params->tlb_flush_waitlist))
 		return;
 
-	if (unlocked) {
-		spin_lock(&vm->status_lock);
-		list_splice_init(&params->tlb_flush_waitlist, &vm->pt_freed);
-		spin_unlock(&vm->status_lock);
-		schedule_work(&vm->pt_free_work);
-		return;
-	}
+	/*
+	 * unlocked unmap clear page table leaves, warning to free the page entry.
+	 */
+	WARN_ON(unlocked);
 
 	list_for_each_entry_safe(entry, next, &params->tlb_flush_waitlist, vm_status)
 		amdgpu_vm_pt_free(entry);
@@ -900,7 +875,15 @@ int amdgpu_vm_ptes_update(struct amdgpu_vm_update_params *params,
 		incr = (uint64_t)AMDGPU_GPU_PAGE_SIZE << shift;
 		mask = amdgpu_vm_pt_entries_mask(adev, cursor.level);
 		pe_start = ((cursor.pfn >> shift) & mask) * 8;
-		entry_end = ((uint64_t)mask + 1) << shift;
+
+		if (cursor.level < AMDGPU_VM_PTB && params->unlocked)
+			/*
+			 * MMU notifier callback unlocked unmap huge page, leave is PDE entry,
+			 * only clear one entry. Next entry search again for PDE or PTE leave.
+			 */
+			entry_end = 1ULL << shift;
+		else
+			entry_end = ((uint64_t)mask + 1) << shift;
 		entry_end += cursor.pfn & ~(entry_end - 1);
 		entry_end = min(entry_end, end);
 
-- 
2.39.5



