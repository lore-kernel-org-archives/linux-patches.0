Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4720330;
	Tue, 26 Aug 2025 11:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208150; cv=none; b=SU/7Gqe1X7ju7HeLGb/rea6DVEU5tmlYLxNd8MVbqSSK1WBIU8AgTjNiYaKnFN130cFyt9uhaYON2FOwgrG2Aleboq4cUPYvWzv6LeCHeJ/+X9PtwvSu6P1FeTNa5PfQzEMgDgdaxeANefrEkUm5IqLde7aP/eZ3D6rLxEpa3Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208150; c=relaxed/simple;
	bh=dU1p1nFws2rS5qk10FFWWIVnKRRq7b3p4ydm1l7YPRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ol1GTJ8K/0Gw/tr27x5VBBrjrU7C2fs4Sugm9b0ySbzZiYl7f0az2Nh2uegpXEPIc/LLCa/7E3KJmyKWM85vI2fV27gw1q8DCN/XcEzzoky3CI1YPor7FFMx65bhYJT+YpydeGuPP0l4q4Z7luxdelHGCBHw3QrlgMwnDCqp3FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A02F7bEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A02F7bEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CB5C4CEF1;
	Tue, 26 Aug 2025 11:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208149;
	bh=dU1p1nFws2rS5qk10FFWWIVnKRRq7b3p4ydm1l7YPRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A02F7bEIu3OPcVFDuAGgqIcsdzn8tJ3TQHuseNpYd6a96bX0nY7K79ngas1tpRIVq
	 6rWY69U8ZZ0zLgMmU45lyGv+vzvl60ciGfpSTgnVQAPgYYr6XFON79W9l3ZLF/w3fq
	 JarLuBqbAx8+omz+BnOsgL/QdBwyBMO2oZE98xq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Christoph Manszewski <christoph.manszewski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 457/457] drm/xe: Fix vm_bind_ioctl double free bug
Date: Tue, 26 Aug 2025 13:12:21 +0200
Message-ID: <20250826110948.578694551@linuxfoundation.org>
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

From: Christoph Manszewski <christoph.manszewski@intel.com>

[ Upstream commit 111fb43a557726079a67ce3ab51f602ddbf7097e ]

If the argument check during an array bind fails, the bind_ops are freed
twice as seen below. Fix this by setting bind_ops to NULL after freeing.

==================================================================
BUG: KASAN: double-free in xe_vm_bind_ioctl+0x1b2/0x21f0 [xe]
Free of addr ffff88813bb9b800 by task xe_vm/14198

CPU: 5 UID: 0 PID: 14198 Comm: xe_vm Not tainted 6.16.0-xe-eudebug-cmanszew+ #520 PREEMPT(full)
Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-P DDR5 RVP, BIOS ADLPFWI1.R00.2411.A02.2110081023 10/08/2021
Call Trace:
 <TASK>
 dump_stack_lvl+0x82/0xd0
 print_report+0xcb/0x610
 ? __virt_addr_valid+0x19a/0x300
 ? xe_vm_bind_ioctl+0x1b2/0x21f0 [xe]
 kasan_report_invalid_free+0xc8/0xf0
 ? xe_vm_bind_ioctl+0x1b2/0x21f0 [xe]
 ? xe_vm_bind_ioctl+0x1b2/0x21f0 [xe]
 check_slab_allocation+0x102/0x130
 kfree+0x10d/0x440
 ? should_fail_ex+0x57/0x2f0
 ? xe_vm_bind_ioctl+0x1b2/0x21f0 [xe]
 xe_vm_bind_ioctl+0x1b2/0x21f0 [xe]
 ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
 ? __lock_acquire+0xab9/0x27f0
 ? lock_acquire+0x165/0x300
 ? drm_dev_enter+0x53/0xe0 [drm]
 ? find_held_lock+0x2b/0x80
 ? drm_dev_exit+0x30/0x50 [drm]
 ? drm_ioctl_kernel+0x128/0x1c0 [drm]
 drm_ioctl_kernel+0x128/0x1c0 [drm]
 ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
 ? find_held_lock+0x2b/0x80
 ? __pfx_drm_ioctl_kernel+0x10/0x10 [drm]
 ? should_fail_ex+0x57/0x2f0
 ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
 drm_ioctl+0x352/0x620 [drm]
 ? __pfx_drm_ioctl+0x10/0x10 [drm]
 ? __pfx_rpm_resume+0x10/0x10
 ? do_raw_spin_lock+0x11a/0x1b0
 ? find_held_lock+0x2b/0x80
 ? __pm_runtime_resume+0x61/0xc0
 ? rcu_is_watching+0x20/0x50
 ? trace_irq_enable.constprop.0+0xac/0xe0
 xe_drm_ioctl+0x91/0xc0 [xe]
 __x64_sys_ioctl+0xb2/0x100
 ? rcu_is_watching+0x20/0x50
 do_syscall_64+0x68/0x2e0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fa9acb24ded

Fixes: b43e864af0d4 ("drm/xe/uapi: Add DRM_XE_VM_BIND_FLAG_CPU_ADDR_MIRROR")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Christoph Manszewski <christoph.manszewski@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250813101231.196632-2-christoph.manszewski@intel.com
(cherry picked from commit a01b704527c28a2fd43a17a85f8996b75ec8492a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 3135de124c18..3b11b1d52bee 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3200,6 +3200,7 @@ static int vm_bind_ioctl_check_args(struct xe_device *xe, struct xe_vm *vm,
 free_bind_ops:
 	if (args->num_binds > 1)
 		kvfree(*bind_ops);
+	*bind_ops = NULL;
 	return err;
 }
 
@@ -3305,7 +3306,7 @@ int xe_vm_bind_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	struct xe_exec_queue *q = NULL;
 	u32 num_syncs, num_ufence = 0;
 	struct xe_sync_entry *syncs = NULL;
-	struct drm_xe_vm_bind_op *bind_ops;
+	struct drm_xe_vm_bind_op *bind_ops = NULL;
 	struct xe_vma_ops vops;
 	struct dma_fence *fence;
 	int err;
-- 
2.50.1



