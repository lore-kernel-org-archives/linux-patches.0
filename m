Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9418B345729;
	Mon, 20 Apr 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700078; cv=none; b=a17mX3W9MVnlU8zVPqSQGrHc/BRQCqTdgDPfO3H2LxSl9j2w/LRFIV3AQj9WWNSbUTAC6lyWMFCzxGr8LLV/JC8Rp9BZKeIFR7arxmim1jkTGey1jPKF7FCWhiwez/XIqudORP7hSNvZmZ8b2c7+5txv0Bt1RueNxIl75xWE/NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700078; c=relaxed/simple;
	bh=1U/XrJA0b6QgNRflqXzo0yTGM7A2eEyHd5X7OP8tCKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qArSDuDrNDwABI8wVRn86PR3ygxcPN4gc3r3V9BIYUGwm6xUcuwWIvzABJ7VAQDt0bxW15e8O4iTjtWRAMWG3qzqhWu31AzvPNPSqFVjI8cgKYSTTzcv5IZjxcbKSaqVtSQrdJYhKJtlD775z/CH4ZEjohBaiHW1sSCSFuS3RvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhZKnmwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhZKnmwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74DAC2BCB6;
	Mon, 20 Apr 2026 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700078;
	bh=1U/XrJA0b6QgNRflqXzo0yTGM7A2eEyHd5X7OP8tCKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhZKnmwdEe8/Qtx/78NF827JHJ8/oQj7qlUr4ZpqQXzVqJScY5Q2ELfPhBHGQBHVK
	 ILYxOLjq2Ra+/CCSbynrDdX0tqjpip31DHdAtXO6XaT5+dt3QMWS1VorjmV29PLW6A
	 UfU3RrMIA04WYPAEXiI4JUbjRgTLDj3OrmhiBrW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 032/220] drm/amdkfd: Fix queue preemption/eviction failures by aligning control stack size to GPU page size
Date: Mon, 20 Apr 2026 17:39:33 +0200
Message-ID: <20260420153935.190962667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 78746a474e92fc7aaed12219bec7c78ae1bd6156 ]

The control stack size is calculated based on the number of CUs and
waves, and is then aligned to PAGE_SIZE. When the resulting control
stack size is aligned to 64 KB, GPU hangs and queue preemption
failures are observed while running RCCL unit tests on systems with
more than two GPUs.

amdgpu 0048:0f:00.0: amdgpu: Queue preemption failed for queue with
doorbell_id: 80030008
amdgpu 0048:0f:00.0: amdgpu: Failed to evict process queues
amdgpu 0048:0f:00.0: amdgpu: GPU reset begin!. Source: 4
amdgpu 0048:0f:00.0: amdgpu: Queue preemption failed for queue with
doorbell_id: 80030008
amdgpu 0048:0f:00.0: amdgpu: Failed to evict process queues
amdgpu 0048:0f:00.0: amdgpu: Failed to restore process queues

This issue is observed on both 4 KB and 64 KB system page-size
configurations.

This patch fixes the issue by aligning the control stack size to
AMDGPU_GPU_PAGE_SIZE instead of PAGE_SIZE, so the control stack size
will not be 64 KB on systems with a 64 KB page size and queue
preemption works correctly.

Additionally, In the current code, wg_data_size is aligned to PAGE_SIZE,
which can waste memory if the system page size is large. In this patch,
wg_data_size is aligned to AMDGPU_GPU_PAGE_SIZE. The cwsr_size, calculated
from wg_data_size and the control stack size, is aligned to PAGE_SIZE.

Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a3e14436304392fbada359edd0f1d1659850c9b7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 2822c90bd7be4..b97f4a51db6e3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -444,10 +444,11 @@ void kfd_queue_ctx_save_restore_size(struct kfd_topology_device *dev)
 		    min(cu_num * 40, props->array_count / props->simd_arrays_per_engine * 512)
 		    : cu_num * 32;
 
-	wg_data_size = ALIGN(cu_num * WG_CONTEXT_DATA_SIZE_PER_CU(gfxv, props), PAGE_SIZE);
+	wg_data_size = ALIGN(cu_num * WG_CONTEXT_DATA_SIZE_PER_CU(gfxv, props),
+				AMDGPU_GPU_PAGE_SIZE);
 	ctl_stack_size = wave_num * CNTL_STACK_BYTES_PER_WAVE(gfxv) + 8;
 	ctl_stack_size = ALIGN(SIZEOF_HSA_USER_CONTEXT_SAVE_AREA_HEADER + ctl_stack_size,
-			       PAGE_SIZE);
+			       AMDGPU_GPU_PAGE_SIZE);
 
 	if ((gfxv / 10000 * 10000) == 100000) {
 		/* HW design limits control stack size to 0x7000.
@@ -459,7 +460,7 @@ void kfd_queue_ctx_save_restore_size(struct kfd_topology_device *dev)
 
 	props->ctl_stack_size = ctl_stack_size;
 	props->debug_memory_size = ALIGN(wave_num * DEBUGGER_BYTES_PER_WAVE, DEBUGGER_BYTES_ALIGN);
-	props->cwsr_size = ctl_stack_size + wg_data_size;
+	props->cwsr_size = ALIGN(ctl_stack_size + wg_data_size, PAGE_SIZE);
 
 	if (gfxv == 80002)	/* GFX_VERSION_TONGA */
 		props->eop_buffer_size = 0x8000;
-- 
2.53.0



