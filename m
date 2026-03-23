Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECA621D00A;
	Mon, 23 Mar 2026 13:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274023; cv=none; b=oA6q66AkMmYXoXpyO2sUd8oj/UlV/lcjPjJu2wPRJL/lkhNIoGuoVzzQxOjGCDoqJo7ErnzHFpHzJGxz6Qxp/nEesbnLW9Mvw+3JWbSIKcZxgLB3SuixDSK45JD0ZnwxyJKh0GbXh+irh81yiocx07Lgu1lEaw4ov3GzFVvcWnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274023; c=relaxed/simple;
	bh=12ossGP4ClQ5Qqb9A8W8mIhv7tZCUTdMJYs2SIgzCRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfsvsOG/WtKSoFt+FHtbuT5peU/KOWF9nTaRnbo/ECNbyQcn2Jws4KojyTdsp3FB5T0OLrN0eUjO9Wj5flf1CGy9v+pHVKif7fuevyQakk/JlvDwX80LtT1fUIZJrcqdFWsZv+2MR6SjNdeLnGPfU7n8/T9ahBp9k9Lad+b4VBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u72fzCUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u72fzCUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98907C4CEF7;
	Mon, 23 Mar 2026 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274023;
	bh=12ossGP4ClQ5Qqb9A8W8mIhv7tZCUTdMJYs2SIgzCRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u72fzCUmDJQQcjnz/F7FXQgSwcriWgy/IOkHI0ONbHZE5NZr6gh7ZqSJJ8HAOEymL
	 ijz5cXNcRrUeVuVl+4Q7QjfzHyM18r7zUA5l/eeep+bK+zq90Xxd8a4PyEFgq3b9U1
	 W04Gq9/8fvfP/cWCFwB5SRFGAHfWwjQEM8yp8FvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 085/220] drm/amdgpu: rework how we handle TLB fences
Date: Mon, 23 Mar 2026 14:44:22 +0100
Message-ID: <20260323134507.279227581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e9f58ff991dd4be13fd7a651bbf64329c090af09 upstream.

Add a new VM flag to indicate whether or not we need
a TLB fence.  Userqs (KFD or KGD) require a TLB fence.
A TLB fence is not strictly required for kernel queues,
but it shouldn't hurt.  That said, enabling this
unconditionally should be fine, but it seems to tickle
some issues in KIQ/MES.  Only enable them for KFD,
or when KGD userq queues are enabled (currently via module
parameter).

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4798
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4749
Fixes: f3854e04b708 ("drm/amdgpu: attach tlb fence to the PTs update")
Cc: Christian König <christian.koenig@amd.com>
Cc: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 69c5fbd2b93b5ced77c6e79afe83371bca84c788)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    7 ++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1069,7 +1069,10 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_upd
 	}
 
 	/* Prepare a TLB flush fence to be attached to PTs */
-	if (!params->unlocked) {
+	/* The check for need_tlb_fence should be dropped once we
+	 * sort out the issues with KIQ/MES TLB invalidation timeouts.
+	 */
+	if (!params->unlocked && vm->need_tlb_fence) {
 		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
 
 		/* Makes sure no PD/PT is freed before the flush */
@@ -2602,6 +2605,7 @@ int amdgpu_vm_init(struct amdgpu_device
 	ttm_lru_bulk_move_init(&vm->lru_bulk_move);
 
 	vm->is_compute_context = false;
+	vm->need_tlb_fence = amdgpu_userq_enabled(&adev->ddev);
 
 	vm->use_cpu_for_update = !!(adev->vm_manager.vm_update_mode &
 				    AMDGPU_VM_USE_CPU_FOR_GFX);
@@ -2739,6 +2743,7 @@ int amdgpu_vm_make_compute(struct amdgpu
 	dma_fence_put(vm->last_update);
 	vm->last_update = dma_fence_get_stub();
 	vm->is_compute_context = true;
+	vm->need_tlb_fence = true;
 
 unreserve_bo:
 	amdgpu_bo_unreserve(vm->root.bo);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -440,6 +440,8 @@ struct amdgpu_vm {
 	struct ttm_lru_bulk_move lru_bulk_move;
 	/* Flag to indicate if VM is used for compute */
 	bool			is_compute_context;
+	/* Flag to indicate if VM needs a TLB fence (KFD or KGD) */
+	bool			need_tlb_fence;
 
 	/* Memory partition number, -1 means any partition */
 	int8_t			mem_id;


