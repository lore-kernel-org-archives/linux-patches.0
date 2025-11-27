Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241C424E4A8;
	Thu, 27 Nov 2025 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255952; cv=none; b=QpNEI4ZtWLWvDi3eiJJqkZrYCtCv0dUoqReCtycUhIXr4zAiZLQIDmVFXJBj6dbBiYIz4mUZBFbfd/yl+5GVhojSLrIjVZP3zun5F4TfCC/77eWWtIARseNjytzkRYKaoX8XrP+2rgIAx7VC4MXm5IlPrrPHKcjxD9RDJ6CLTrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255952; c=relaxed/simple;
	bh=yxKf8QwdME+2Vfdy2C4BgYPInxg3lBU9PqyBprplpPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/bXHKX9CaQHc39uAH7tcji0oj0n/BUsD3DV1x0lZWjwPDAbqvdA7ltjn6OGUNgFmDqT9epcr3/EcFd/2fkBI/4GtSbnC/dg4ZPF1wOr2ZVUFeEdn+nnpkZFN8haHpX+qssIuM9I1Y9qcYIWK4OzH3WY7BxSwyJuo/jUId4fEAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPtLjKqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPtLjKqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35BFC4CEF8;
	Thu, 27 Nov 2025 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255952;
	bh=yxKf8QwdME+2Vfdy2C4BgYPInxg3lBU9PqyBprplpPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPtLjKqG1kuwiwMGeLzNsQJgJb2AT3454iB6jLXpFDu5QkuNv1KWwGGkZxKPyiN8f
	 fxAXDDdjrRwcJ+y/VRuUDitlLbfgihpg0NPRguw7/XkAHfm0AWC2Vyfdpsl1ryujsW
	 hbvW45bMjzdNMlFL/kXUX1eFNtwCjsUWqZeXcvzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 138/175] drm/msm: Fix pgtable prealloc error path
Date: Thu, 27 Nov 2025 15:46:31 +0100
Message-ID: <20251127144047.998945672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 830d68f2cb8ab6fb798bb9555016709a9e012af0 ]

The following splat was reported:

    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
    Mem abort info:
      ESR = 0x0000000096000004
      EC = 0x25: DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
      FSC = 0x04: level 0 translation fault
    Data abort info:
      ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
      CM = 0, WnR = 0, TnD = 0, TagAccess = 0
      GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
    user pgtable: 4k pages, 48-bit VAs, pgdp=00000008d0fd8000
    [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
    Internal error: Oops: 0000000096000004 [#1]  SMP
    CPU: 5 UID: 1000 PID: 149076 Comm: Xwayland Tainted: G S                  6.16.0-rc2-00809-g0b6974bb4134-dirty #367 PREEMPT
    Tainted: [S]=CPU_OUT_OF_SPEC
    Hardware name: Qualcomm Technologies, Inc. SM8650 HDK (DT)
    pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
    pc : build_detached_freelist+0x28/0x224
    lr : kmem_cache_free_bulk.part.0+0x38/0x244
    sp : ffff000a508c7a20
    x29: ffff000a508c7a20 x28: ffff000a508c7d50 x27: ffffc4e49d16f350
    x26: 0000000000000058 x25: 00000000fffffffc x24: 0000000000000000
    x23: ffff00098c4e1450 x22: 00000000fffffffc x21: 0000000000000000
    x20: ffff000a508c7af8 x19: 0000000000000002 x18: 00000000000003e8
    x17: ffff000809523850 x16: ffff000809523820 x15: 0000000000401640
    x14: ffff000809371140 x13: 0000000000000130 x12: ffff0008b5711e30
    x11: 00000000001058fa x10: 0000000000000a80 x9 : ffff000a508c7940
    x8 : ffff000809371ba0 x7 : 781fffe033087fff x6 : 0000000000000000
    x5 : ffff0008003cd000 x4 : 781fffe033083fff x3 : ffff000a508c7af8
    x2 : fffffdffc0000000 x1 : 0001000000000000 x0 : ffff0008001a6a00
    Call trace:
     build_detached_freelist+0x28/0x224 (P)
     kmem_cache_free_bulk.part.0+0x38/0x244
     kmem_cache_free_bulk+0x10/0x1c
     msm_iommu_pagetable_prealloc_cleanup+0x3c/0xd0
     msm_vma_job_free+0x30/0x240
     msm_ioctl_vm_bind+0x1d0/0x9a0
     drm_ioctl_kernel+0x84/0x104
     drm_ioctl+0x358/0x4d4
     __arm64_sys_ioctl+0x8c/0xe0
     invoke_syscall+0x44/0x100
     el0_svc_common.constprop.0+0x3c/0xe0
     do_el0_svc+0x18/0x20
     el0_svc+0x30/0x100
     el0t_64_sync_handler+0x104/0x130
     el0t_64_sync+0x170/0x174
    Code: aa0203f5 b26287e2 f2dfbfe2 aa0303f4 (f8737ab6)
    ---[ end trace 0000000000000000 ]---

Since msm_vma_job_free() is called directly from the ioctl, this looks
like an error path cleanup issue.  Which I think results from
prealloc_cleanup() called without a preceding successful
prealloc_allocate() call.  So handle that case better.

Reported-by: Connor Abbott <cwabbott0@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/678677/
Message-ID: <20251006153542.419998-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 76cdd5ea06a02..10ef47ffb787a 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -338,6 +338,8 @@ msm_iommu_pagetable_prealloc_allocate(struct msm_mmu *mmu, struct msm_mmu_preall
 
 	ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pages);
 	if (ret != p->count) {
+		kfree(p->pages);
+		p->pages = NULL;
 		p->count = ret;
 		return -ENOMEM;
 	}
@@ -351,6 +353,9 @@ msm_iommu_pagetable_prealloc_cleanup(struct msm_mmu *mmu, struct msm_mmu_preallo
 	struct kmem_cache *pt_cache = get_pt_cache(mmu);
 	uint32_t remaining_pt_count = p->count - p->ptr;
 
+	if (!p->pages)
+		return;
+
 	if (p->count > 0)
 		trace_msm_mmu_prealloc_cleanup(p->count, remaining_pt_count);
 
-- 
2.51.0



