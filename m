Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A54719ABC6;
	Thu, 17 Apr 2025 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915444; cv=none; b=TeOU1NCKfv5QR90hW24ByjBEZLp9+R7tbS8qDUWv9korCCcEaVqmPQ8I18BomaP1+ndiGJfq4fjYNWNInTSPfzbLZc27wE7bkpCXHYkuIA6y6SerkbWA4OpA7WZ/x32PUA7JHQj5yCj6rLFoUzHr4rLsqQX1kFd9stdkLHfDRZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915444; c=relaxed/simple;
	bh=h84wUcQyejpJnc1xHvPdZmZUWhbe4ROZzx2lIaU23ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwELXiuhTTBo0/dT7cqxs3pfSFM4H9T/idwSVh5hhMVYSZ/UNk//XoGbjkVs1hzUjLv5dkNuF1W0YGgDbP6EO89DvrZqCmj8xdrqe5BXi1SnYcPahGHrHdF3236Md4af++womCK9uoC4fXIdFZfDLpSG3CFvDwkueuhYH9/+0JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5rac7Nk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5rac7Nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4696EC4CEE4;
	Thu, 17 Apr 2025 18:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915443;
	bh=h84wUcQyejpJnc1xHvPdZmZUWhbe4ROZzx2lIaU23ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5rac7Nk5Dx9UZMSYNP3O6Q+4Pp/02Xd5qtMQyWE8Q3mildshIxs6HIxU/GxZjubm
	 zksS5FTWZOGiV/NXKzr9vV2iM9HFzEygPt+d9Cvp2a7+Spo25Q9naUYhiUI/ncaqA6
	 Ap7xdJvrFwqvrG6v/I9EnCQsXk4hz8A0KbCa8+ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/393] drm/amdgpu: Unlocked unmap only clear page table leaves
Date: Thu, 17 Apr 2025 19:48:59 +0200
Message-ID: <20250417175112.818985260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 73e02141a6e21..37d53578825b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2434,8 +2434,6 @@ int amdgpu_vm_init(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	spin_lock_init(&vm->status_lock);
 	INIT_LIST_HEAD(&vm->freed);
 	INIT_LIST_HEAD(&vm->done);
-	INIT_LIST_HEAD(&vm->pt_freed);
-	INIT_WORK(&vm->pt_free_work, amdgpu_vm_pt_free_work);
 	INIT_KFIFO(vm->faults);
 
 	r = amdgpu_vm_init_entities(adev, vm);
@@ -2607,8 +2605,6 @@ void amdgpu_vm_fini(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 
 	amdgpu_amdkfd_gpuvm_destroy_cb(adev, vm);
 
-	flush_work(&vm->pt_free_work);
-
 	root = amdgpu_bo_ref(vm->root.bo);
 	amdgpu_bo_reserve(root, true);
 	amdgpu_vm_put_task_info(vm->task_info);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
index 52dd7cdfdc814..ee893527a4f1d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -360,10 +360,6 @@ struct amdgpu_vm {
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
index f78a0434a48fa..54ae0e9bc6d77 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -546,27 +546,6 @@ static void amdgpu_vm_pt_free(struct amdgpu_vm_bo_base *entry)
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
@@ -579,19 +558,15 @@ void amdgpu_vm_pt_free_list(struct amdgpu_device *adev,
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
@@ -899,7 +874,15 @@ int amdgpu_vm_ptes_update(struct amdgpu_vm_update_params *params,
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



