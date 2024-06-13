Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF186399;
	Thu, 13 Jun 2024 12:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282088; cv=none; b=dkYc512iCEnyPkubeCGYWr8qNNX/dIbdPtfCVw9CxhfYpNL9La+81oHrKUlXDYACMwjycOPT5BkgOXDoiZSeLy5rb0AbvQaeIWTUp7iJtuP15WSDFuyYlsaLQoko5npuB3qseF7RA0rVwO9NLL1rKf3to2ZoifNw4/Muv0Z0YsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282088; c=relaxed/simple;
	bh=9kvbXunvP9dKZT5/U8BmlM4HLQNdFWJbJB5Ynqmv3Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfXEAl0oCrN/hN4a/3AcU+6cx/rwM58FB7TtpZFJ3KFaB/Jthj+SvwWQh0AZbOubudQ4yITtRMAYNbhpPYEJToOMRtw7pwBta5DAX0my6iQhHVjPzfk9M1sS2QdYZon+06f33kMNvjYfaQ2u5kZBD7pGtfY9WeDYCkYDUObSh+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPJZhIzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPJZhIzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F109C2BBFC;
	Thu, 13 Jun 2024 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282088;
	bh=9kvbXunvP9dKZT5/U8BmlM4HLQNdFWJbJB5Ynqmv3Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPJZhIzOXumd4lwshuItnTqpX1rCCAucNg3ybnRDxKsxl+NSIGJYXzvUfcUvXa1Lt
	 z77wrn3nIAS/o8MW1fDcM/FjZByg1pQ65GTuZtDK+5UwwHz4yV/H8pbfII3lq1SZS6
	 AeL49axpEjVyowNCH2CVYSoU6uOPCDGTuRANUzFA=
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
Subject: [PATCH 5.15 159/402] virt: acrn: stop using follow_pfn
Date: Thu, 13 Jun 2024 13:31:56 +0200
Message-ID: <20240613113308.337319535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



