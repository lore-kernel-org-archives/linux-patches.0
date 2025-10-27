Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AB130CD92;
	Mon, 27 Oct 2025 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592960; cv=none; b=Z+ZWXUpNJLEYoQmXr2iZj1pzkJq+XYBwnyS19v6PFsvLGVJpZ9z2gfaBzDPU9gPUwpU08u2OFqahJfPp2EK30WutWVgFP3fPWFvEOR3s6lrpq9RR+oZ7oNtrDFsZnBoP82W5UgcMH+wg+M2fc4ayVnlOW1lCZnPZaEykDmkmU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592960; c=relaxed/simple;
	bh=yBgHncSkiIXHfz+/0qgFa5gzdaqI8h4t+O9EkFGsUss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFC7q7N4QeX2Si1Gwx1egKElWsVWfd3qgt/lPXFsd5AlEFWsr9wxuDAeME49F/kiifWK+G1l7jSUkG9YmW/pwqNSTkoWpwVV8fj8hbez3TiMFry+8N6Fi5xf6MBnCT6kK9eQxQqQ4HENictvLn9lZAuS2kPgwy0NYdKLdj/T7EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVdYkCVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVdYkCVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63589C113D0;
	Mon, 27 Oct 2025 19:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592960;
	bh=yBgHncSkiIXHfz+/0qgFa5gzdaqI8h4t+O9EkFGsUss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVdYkCVlL0dpIVBII6Qfg/JSHwc0d2ogJADcscHWrT8tRkZOddE8gd+Ch7IAGYfUt
	 sU8B2LRBo4uVWK+XH4I9ToM22nE1qbV4Bjhh7dZhLKhpiPptTKwjpwv6JzZUymw3o4
	 xBA8eZlv4b7vbKzHq96MOb+z9yhN4abfanMR8a84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/117] drm/panthor: Fix kernel panic on partial unmap of a GPU VA region
Date: Mon, 27 Oct 2025 19:36:45 +0100
Message-ID: <20251027183456.162510280@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit 4eabd0d8791eaf9a7b114ccbf56eb488aefe7b1f ]

This commit address a kernel panic issue that can happen if Userspace
tries to partially unmap a GPU virtual region (aka drm_gpuva).
The VM_BIND interface allows partial unmapping of a BO.

Panthor driver pre-allocates memory for the new drm_gpuva structures
that would be needed for the map/unmap operation, done using drm_gpuvm
layer. It expected that only one new drm_gpuva would be needed on umap
but a partial unmap can require 2 new drm_gpuva and that's why it
ended up doing a NULL pointer dereference causing a kernel panic.

Following dump was seen when partial unmap was exercised.
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000078
 Mem abort info:
   ESR = 0x0000000096000046
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x06: level 2 translation fault
 Data abort info:
   ISV = 0, ISS = 0x00000046, ISS2 = 0x00000000
   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp=000000088a863000
 [000000000000078] pgd=080000088a842003, p4d=080000088a842003, pud=0800000884bf5003, pmd=0000000000000000
 Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
 <snip>
 pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : panthor_gpuva_sm_step_remap+0xe4/0x330 [panthor]
 lr : panthor_gpuva_sm_step_remap+0x6c/0x330 [panthor]
 sp : ffff800085d43970
 x29: ffff800085d43970 x28: ffff00080363e440 x27: ffff0008090c6000
 x26: 0000000000000030 x25: ffff800085d439f8 x24: ffff00080d402000
 x23: ffff800085d43b60 x22: ffff800085d439e0 x21: ffff00080abdb180
 x20: 0000000000000000 x19: 0000000000000000 x18: 0000000000000010
 x17: 6e656c202c303030 x16: 3666666666646466 x15: 393d61766f69202c
 x14: 312d3d7361203a70 x13: 303030323d6e656c x12: ffff80008324bf58
 x11: 0000000000000003 x10: 0000000000000002 x9 : ffff8000801a6a9c
 x8 : ffff00080360b300 x7 : 0000000000000000 x6 : 000000088aa35fc7
 x5 : fff1000080000000 x4 : ffff8000842ddd30 x3 : 0000000000000001
 x2 : 0000000100000000 x1 : 0000000000000001 x0 : 0000000000000078
 Call trace:
  panthor_gpuva_sm_step_remap+0xe4/0x330 [panthor]
  op_remap_cb.isra.22+0x50/0x80
  __drm_gpuvm_sm_unmap+0x10c/0x1c8
  drm_gpuvm_sm_unmap+0x40/0x60
  panthor_vm_exec_op+0xb4/0x3d0 [panthor]
  panthor_vm_bind_exec_sync_op+0x154/0x278 [panthor]
  panthor_ioctl_vm_bind+0x160/0x4a0 [panthor]
  drm_ioctl_kernel+0xbc/0x138
  drm_ioctl+0x240/0x500
  __arm64_sys_ioctl+0xb0/0xf8
  invoke_syscall+0x4c/0x110
  el0_svc_common.constprop.1+0x98/0xf8
  do_el0_svc+0x24/0x38
  el0_svc+0x40/0xf8
  el0t_64_sync_handler+0xa0/0xc8
  el0t_64_sync+0x174/0x178

Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20251017102922.670084-1-akash.goel@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index b57824abeb9ee..2214dbf472fa4 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1168,10 +1168,14 @@ panthor_vm_op_ctx_prealloc_vmas(struct panthor_vm_op_ctx *op_ctx)
 		break;
 
 	case DRM_PANTHOR_VM_BIND_OP_TYPE_UNMAP:
-		/* Partial unmaps might trigger a remap with either a prev or a next VA,
-		 * but not both.
+		/* Two VMAs can be needed for an unmap, as an unmap can happen
+		 * in the middle of a drm_gpuva, requiring a remap with both
+		 * prev & next VA. Or an unmap can span more than one drm_gpuva
+		 * where the first and last ones are covered partially, requring
+		 * a remap for the first with a prev VA and remap for the last
+		 * with a next VA.
 		 */
-		vma_count = 1;
+		vma_count = 2;
 		break;
 
 	default:
-- 
2.51.0



