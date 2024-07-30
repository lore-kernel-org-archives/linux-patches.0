Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3B1A76B2;
	Tue, 30 Jul 2024 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360447; cv=none; b=bDCnkJOOcqxJR4giLwbuJTmorKFDkNPLVnLmbAeVDQWJv2JKNueWsDGz6JelGVRZiEyWFWCmM2IrNr74wB5oWVOdMm92swlZYi9FEynkZEJszpunzfPGqFO1nOca/NrKFMg7MzxIJypVFgnF9c7OOhj8AWx5LIIdp2YahUMMgQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360447; c=relaxed/simple;
	bh=GvwOoQe+KaAKVR1kIxuEWcwf8uqt8YCELvwBM4duuEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uD7d4nyH+0V1cZyhVsP89G8DFqpIUWe6hl16ygHwDtU+F7J+NkuckYJjX8Mqmix7wD/taNMPawUz+ugSevFqw5111xLFLYIDeKFtlVSdsdrAB966v5YBxjP14k60k2U570uOn6PGcd4G1poEu/qT25dnrB4p17uDXuJaBwlMHRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyAIfh83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyAIfh83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD21C32782;
	Tue, 30 Jul 2024 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360447;
	bh=GvwOoQe+KaAKVR1kIxuEWcwf8uqt8YCELvwBM4duuEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyAIfh83tqJQOHtqjHCmZABc13cYt1UblJu/sqe+Zy1U/kkxRd525ize69Hzu1K4h
	 61BjHsVGRyOctlEld26u78aU8q19KeIfZS9I3CsacUBvQJwSVubLOcqU0dQIL1mOuI
	 g76WdyhkKMmQa2kbNHM5A2A9ad4Ob9sDoJDoRrfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhenGuo Yin <zhenguo.yin@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 702/809] drm/amdgpu: reset vm state machine after gpu reset(vram lost)
Date: Tue, 30 Jul 2024 17:49:38 +0200
Message-ID: <20240730151752.653269400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhenGuo Yin <zhenguo.yin@amd.com>

commit 5659b0c93a1ea02c662a030b322093203f299185 upstream.

[Why]
Page table of compute VM in the VRAM will lost after gpu reset.
VRAM won't be restored since compute VM has no shadows.

[How]
Use higher 32-bit of vm->generation to record a vram_lost_counter.
Reset the VM state machine when vm->genertaion is not equal to
the new generation token.

v2: Check vm->generation instead of calling drm_sched_entity_error
in amdgpu_vm_validate.
v3: Use new generation token instead of vram_lost_counter for check.

Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 47c0388b0589cb481c294dcb857d25a214c46eb3)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -434,7 +434,7 @@ uint64_t amdgpu_vm_generation(struct amd
 	if (!vm)
 		return result;
 
-	result += vm->generation;
+	result += lower_32_bits(vm->generation);
 	/* Add one if the page tables will be re-generated on next CS */
 	if (drm_sched_entity_error(&vm->delayed))
 		++result;
@@ -463,13 +463,14 @@ int amdgpu_vm_validate(struct amdgpu_dev
 		       int (*validate)(void *p, struct amdgpu_bo *bo),
 		       void *param)
 {
+	uint64_t new_vm_generation = amdgpu_vm_generation(adev, vm);
 	struct amdgpu_vm_bo_base *bo_base;
 	struct amdgpu_bo *shadow;
 	struct amdgpu_bo *bo;
 	int r;
 
-	if (drm_sched_entity_error(&vm->delayed)) {
-		++vm->generation;
+	if (vm->generation != new_vm_generation) {
+		vm->generation = new_vm_generation;
 		amdgpu_vm_bo_reset_state_machine(vm);
 		amdgpu_vm_fini_entities(vm);
 		r = amdgpu_vm_init_entities(adev, vm);
@@ -2441,7 +2442,7 @@ int amdgpu_vm_init(struct amdgpu_device
 	vm->last_update = dma_fence_get_stub();
 	vm->last_unlocked = dma_fence_get_stub();
 	vm->last_tlb_flush = dma_fence_get_stub();
-	vm->generation = 0;
+	vm->generation = amdgpu_vm_generation(adev, NULL);
 
 	mutex_init(&vm->eviction_lock);
 	vm->evicting = false;


