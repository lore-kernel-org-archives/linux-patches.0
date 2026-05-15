Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378CB4BCAA1;
	Fri, 15 May 2026 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862293; cv=none; b=FSTfRH7yfrWM/Ie4GBjxYyBfScbvHiyH6mHshKsgZ3k7kEK6rInbGkmSJLx0akZJWQ+ELzKGFKsnOwQv6yTtUVwiGvH28drc4jiFnd3Y9m6qvSlICgHQ13icOG1t9FuLSdmlf4BKKSdoZ382zRR4NER04j98xYBDEIcwJ4skvnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862293; c=relaxed/simple;
	bh=Mb5eSJ3gdx3j5O1HZ4lpuuZ18aH8uOUiqMOBp701WP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+ERYxRRuI6F+mfDOBkgavTzzT4qP5u0nv/i9qH7TpTVb3T6dWbyIgNVvaz4MYeqLZjrzdL4OFJxDa0IGADqHiISBg60BZaKBmSmxfffDS7hVw4pCuhtiTxY+meQuB/DDH1Jp0v2Jjq1Y0ODNBrwTJ9XAAjfOCN8bc7Tz+pI4F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wee8Ps5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wee8Ps5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CC4C2BCC7;
	Fri, 15 May 2026 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862293;
	bh=Mb5eSJ3gdx3j5O1HZ4lpuuZ18aH8uOUiqMOBp701WP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wee8Ps5jYDNETDsYd+nl9THhvjsydOuxh1CIGD2zOwSlU9rpoAnAMzVgMy9gUbDbC
	 Z1LRLA0Gj2X24R/5E7Gp3ezC0vLPXfCGcyEGiEOIv5yPAZDoa/V5MZQU74RG5qNaWa
	 Ha16Br45faVe6fKsDB9bafwvBR3sb4xd2wuUQLTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 155/188] drm/amdgpu: rework how we handle TLB fences
Date: Fri, 15 May 2026 17:49:32 +0200
Message-ID: <20260515154700.685199317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 69c5fbd2b93b5ced77c6e79afe83371bca84c788 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    7 ++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1066,7 +1066,10 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_upd
 	}
 
 	/* Prepare a TLB flush fence to be attached to PTs */
-	if (!params->unlocked) {
+	/* The check for need_tlb_fence should be dropped once we
+	 * sort out the issues with KIQ/MES TLB invalidation timeouts.
+	 */
+	if (!params->unlocked && vm->need_tlb_fence) {
 		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
 
 		/* Makes sure no PD/PT is freed before the flush */
@@ -2584,6 +2587,7 @@ int amdgpu_vm_init(struct amdgpu_device
 	ttm_lru_bulk_move_init(&vm->lru_bulk_move);
 
 	vm->is_compute_context = false;
+	vm->need_tlb_fence = amdgpu_userq_enabled(&adev->ddev);
 
 	vm->use_cpu_for_update = !!(adev->vm_manager.vm_update_mode &
 				    AMDGPU_VM_USE_CPU_FOR_GFX);
@@ -2721,6 +2725,7 @@ int amdgpu_vm_make_compute(struct amdgpu
 	dma_fence_put(vm->last_update);
 	vm->last_update = dma_fence_get_stub();
 	vm->is_compute_context = true;
+	vm->need_tlb_fence = true;
 
 unreserve_bo:
 	amdgpu_bo_unreserve(vm->root.bo);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -439,6 +439,8 @@ struct amdgpu_vm {
 	struct ttm_lru_bulk_move lru_bulk_move;
 	/* Flag to indicate if VM is used for compute */
 	bool			is_compute_context;
+	/* Flag to indicate if VM needs a TLB fence (KFD or KGD) */
+	bool			need_tlb_fence;
 
 	/* Memory partition number, -1 means any partition */
 	int8_t			mem_id;


