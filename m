Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D239017E90E;
	Mon, 27 May 2024 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837295; cv=none; b=r0klKyDfGpUBgpm7Ga9eV8mE8rNrueLEAfX6NKoZeg3A1DrSVTYI9MqEFksnHFdwzoFZ4O30sfNPDjzXcSa1PZRpsqtjtvCYaBYVIH6z9KFv2TFF/2/bSxlOIqYkjG7hEB12QwOFfGhHWAIgPwhDQ0XELLbfcbMj5Wuh1eIdJQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837295; c=relaxed/simple;
	bh=90Pr1ExvdvVoeO5o95/gtJewRkGRYDd0j0NwM9FLkPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na7lCsutl1z0R5e7WUsHFPaqFw48FBmsOnzwCEHbP2JMsdMvbWeqKULnYENnMA3H07zzEf2ekP7s0Mg0zhXDq8qeUhD+oZhUbVjAAxKz31g7mKOvdnBAqMUoOzayxi54dFzi8tsFMpQnQO/EPMGG8lNmvZEKXSce6Op74YWGmfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwnddlW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwnddlW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A20C2BBFC;
	Mon, 27 May 2024 19:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837295;
	bh=90Pr1ExvdvVoeO5o95/gtJewRkGRYDd0j0NwM9FLkPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwnddlW4VYYaGCJeCgviZfmbM5e6esu3ebKBNWq4cvqyABYooEmsnpBB9yP1oS50t
	 4NBiODTdpxLPPJzly98NNt8Cu+L6L4lv7tZaHBMNEcETVnhsjK4VpsAkFekV/kvcjY
	 SXz7jDYF1rtpCn5MMjxInqvr4OhBebC75v4v67qo=
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
Subject: [PATCH 6.9 386/427] virt: acrn: stop using follow_pfn
Date: Mon, 27 May 2024 20:57:13 +0200
Message-ID: <20240527185634.675037198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index fa5d9ca6be570..69c3f619f8819 100644
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



