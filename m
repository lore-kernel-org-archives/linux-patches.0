Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAEE30DEB8;
	Mon, 27 Oct 2025 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591774; cv=none; b=u9SF328N4ikUBMuWS1Gpj61vFT56bKOixijMHfDF3zveHe7fi6PPkD5BotvpeX5QTSneQPtR9FA3ZXhpBTSE1QANhGbuETSugzcwCcmoorf/ToJlkx1udJqGd7hbz6UdfLQNMG44tbpXM918KS7lLoW6q8X4fxYG1ywuemLMufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591774; c=relaxed/simple;
	bh=Za4LY3ysf441Np4yXDpVI93p7yDvNIi66gUkEa0SOp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvCNPH8Vxj/0kIzSy7FAgZd8jZUU60hFOoZWKJCMsW+U/jICd+gM8c1qFzw9y32U2MV2sokw7dkjmhDMAtuhyTh6QjbwmU3N2hWhyMNh6yo/TJWeDQQxMBJI1woAATsdV/KJrRg8dyRMmoLB7wXwdJW05XoL8AsYZQDpC+pfiQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjCDtQ4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjCDtQ4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586C2C4CEF1;
	Mon, 27 Oct 2025 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591774;
	bh=Za4LY3ysf441Np4yXDpVI93p7yDvNIi66gUkEa0SOp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjCDtQ4b0IeQOBLSTuE9IwySD7g6uyNEkOLAcZ4h6AVKCVxWMU5SaevTDmozgRMRQ
	 WCQEJvJGCT5sQrFbOlVKvmKjS3LAgPW/uUPdzITt6kCy0Z5orbItCn8BnFo8Tnjj7C
	 t768+V+4OHOAaU+lmRLpoRwfY2rvPr4cMTUi4+/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/332] drm/amdgpu: use atomic functions with memory barriers for vm fault info
Date: Mon, 27 Oct 2025 19:36:18 +0100
Message-ID: <20251027183533.463048063@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 6df8e84aa6b5b1812cc2cacd6b3f5ccbb18cda2b ]

The atomic variable vm_fault_info_updated is used to synchronize access to
adev->gmc.vm_fault_info between the interrupt handler and
get_vm_fault_info().

The default atomic functions like atomic_set() and atomic_read() do not
provide memory barriers. This allows for CPU instruction reordering,
meaning the memory accesses to vm_fault_info and the vm_fault_info_updated
flag are not guaranteed to occur in the intended order. This creates a
race condition that can lead to inconsistent or stale data being used.

The previous implementation, which used an explicit mb(), was incomplete
and inefficient. It failed to account for all potential CPU reorderings,
such as the access of vm_fault_info being reordered before the atomic_read
of the flag. This approach is also more verbose and less performant than
using the proper atomic functions with acquire/release semantics.

Fix this by switching to atomic_set_release() and atomic_read_acquire().
These functions provide the necessary acquire and release semantics,
which act as memory barriers to ensure the correct order of operations.
It is also more efficient and idiomatic than using explicit full memory
barriers.

Fixes: b97dfa27ef3a ("drm/amdgpu: save vm fault information for amdkfd")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kept kgd_dev parameter and adev cast in amdgpu_amdkfd_gpuvm_get_vm_fault_info ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    5 ++---
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c            |    7 +++----
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c            |    7 +++----
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1640,10 +1640,9 @@ int amdgpu_amdkfd_gpuvm_get_vm_fault_inf
 	struct amdgpu_device *adev;
 
 	adev = (struct amdgpu_device *)kgd;
-	if (atomic_read(&adev->gmc.vm_fault_info_updated) == 1) {
+	if (atomic_read_acquire(&adev->gmc.vm_fault_info_updated) == 1) {
 		*mem = *adev->gmc.vm_fault_info;
-		mb();
-		atomic_set(&adev->gmc.vm_fault_info_updated, 0);
+		atomic_set_release(&adev->gmc.vm_fault_info_updated, 0);
 	}
 	return 0;
 }
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
@@ -1067,7 +1067,7 @@ static int gmc_v7_0_sw_init(void *handle
 					GFP_KERNEL);
 	if (!adev->gmc.vm_fault_info)
 		return -ENOMEM;
-	atomic_set(&adev->gmc.vm_fault_info_updated, 0);
+	atomic_set_release(&adev->gmc.vm_fault_info_updated, 0);
 
 	return 0;
 }
@@ -1297,7 +1297,7 @@ static int gmc_v7_0_process_interrupt(st
 	vmid = REG_GET_FIELD(status, VM_CONTEXT1_PROTECTION_FAULT_STATUS,
 			     VMID);
 	if (amdgpu_amdkfd_is_kfd_vmid(adev, vmid)
-		&& !atomic_read(&adev->gmc.vm_fault_info_updated)) {
+		&& !atomic_read_acquire(&adev->gmc.vm_fault_info_updated)) {
 		struct kfd_vm_fault_info *info = adev->gmc.vm_fault_info;
 		u32 protections = REG_GET_FIELD(status,
 					VM_CONTEXT1_PROTECTION_FAULT_STATUS,
@@ -1313,8 +1313,7 @@ static int gmc_v7_0_process_interrupt(st
 		info->prot_read = protections & 0x8 ? true : false;
 		info->prot_write = protections & 0x10 ? true : false;
 		info->prot_exec = protections & 0x20 ? true : false;
-		mb();
-		atomic_set(&adev->gmc.vm_fault_info_updated, 1);
+		atomic_set_release(&adev->gmc.vm_fault_info_updated, 1);
 	}
 
 	return 0;
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
@@ -1199,7 +1199,7 @@ static int gmc_v8_0_sw_init(void *handle
 					GFP_KERNEL);
 	if (!adev->gmc.vm_fault_info)
 		return -ENOMEM;
-	atomic_set(&adev->gmc.vm_fault_info_updated, 0);
+	atomic_set_release(&adev->gmc.vm_fault_info_updated, 0);
 
 	return 0;
 }
@@ -1488,7 +1488,7 @@ static int gmc_v8_0_process_interrupt(st
 	vmid = REG_GET_FIELD(status, VM_CONTEXT1_PROTECTION_FAULT_STATUS,
 			     VMID);
 	if (amdgpu_amdkfd_is_kfd_vmid(adev, vmid)
-		&& !atomic_read(&adev->gmc.vm_fault_info_updated)) {
+		&& !atomic_read_acquire(&adev->gmc.vm_fault_info_updated)) {
 		struct kfd_vm_fault_info *info = adev->gmc.vm_fault_info;
 		u32 protections = REG_GET_FIELD(status,
 					VM_CONTEXT1_PROTECTION_FAULT_STATUS,
@@ -1504,8 +1504,7 @@ static int gmc_v8_0_process_interrupt(st
 		info->prot_read = protections & 0x8 ? true : false;
 		info->prot_write = protections & 0x10 ? true : false;
 		info->prot_exec = protections & 0x20 ? true : false;
-		mb();
-		atomic_set(&adev->gmc.vm_fault_info_updated, 1);
+		atomic_set_release(&adev->gmc.vm_fault_info_updated, 1);
 	}
 
 	return 0;


