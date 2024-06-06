Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EBA19B3CA;
	Thu,  6 Jun 2024 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683374; cv=none; b=gG2iVWNTVIbQo2Zsp/lT845QGgngPPXDk1RtNXBGsegdmKrzrqDW5HJ+veI+inZvr8XyPAykRYBTZ1Lm8LnjOsonD+nPSLxTidxgb52H5dC7pYR96r5MsyGQVm1EDiOls/M8M/9oF0/oNZ/2Du52ur3JQXHW6GQFkmGFirogFsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683374; c=relaxed/simple;
	bh=YB2nD5Wk6r5WmnPS6hhJv/GlNdvlg7r+WoixRbraSI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiqLQppB0AWqviFYH80M2QMPQ0hCdXREZS6Lh2Z099Ry38zUhiUpE+L0u+qMUEHRtS6DFkIaCGXNbxbjYfyigxAn/XynefC/MNOdbgx8tqU645wcrDWDZ0f92fa+1EAoQT9q1FnK2us2h8fhthXnFDlT9U6PhNb+cSK+WKhX2BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HG76EVs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HG76EVs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56420C32781;
	Thu,  6 Jun 2024 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683374;
	bh=YB2nD5Wk6r5WmnPS6hhJv/GlNdvlg7r+WoixRbraSI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HG76EVs5OtnTjsWFhs2yfUK1zHwJ0CtDOoaRY4I8dqRAi3cb1+Z9yHZHwMb2aO8kP
	 I8ncA5kqoQ7cxvYb5r7x2Qjt7ytFSxw88ufJBieMo5oCZbTKSWxT/Xr0FyyLkAZc6/
	 ggUOf7LuTGBuCqaS4Ss76P6BlTvcsAmpk0LwxnGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	David Hildenbrand <david@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Fei Li <fei1.li@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/473] virt: acrn: stop using follow_pfn
Date: Thu,  6 Jun 2024 16:03:07 +0200
Message-ID: <20240606131708.492203451@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1b265da7ea1e1ae997fa119c2846bb389eb39c6b ]

Patch series "remove follow_pfn".

This series open codes follow_pfn in the only remaining caller, although
the code there remains questionable.  It then also moves follow_phys into
the only user and simplifies it a bit.

This patch (of 3):

Switch from follow_pfn to follow_pte so that we can get rid of follow_pfn.
Note that this doesn't fix any of the pre-existing raciness and lack of
permission checking in the code.

Link: https://lkml.kernel.org/r/20240324234542.2038726-1-hch@lst.de
Link: https://lkml.kernel.org/r/20240324234542.2038726-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3d6586008f7b ("drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/acrn/mm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index b4ad8d452e9a1..ffc1d1136f765 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -171,18 +171,24 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		spinlock_t *ptl;
+		pte_t *ptep;
+
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
 			return -EINVAL;
 		}
 
-		ret = follow_pfn(vma, memmap->vma_base, &pfn);
-		mmap_read_unlock(current->mm);
+		ret = follow_pte(vma->vm_mm, memmap->vma_base, &ptep, &ptl);
 		if (ret < 0) {
+			mmap_read_unlock(current->mm);
 			dev_dbg(acrn_dev.this_device,
 				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
 			return ret;
 		}
+		pfn = pte_pfn(ptep_get(ptep));
+		pte_unmap_unlock(ptep, ptl);
+		mmap_read_unlock(current->mm);
 
 		return acrn_mm_region_add(vm, memmap->user_vm_pa,
 			 PFN_PHYS(pfn), memmap->len,
-- 
2.43.0



