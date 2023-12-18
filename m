Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5DC3A1AC;
	Mon, 18 Dec 2023 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KW+sZz0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744D4C433C8;
	Mon, 18 Dec 2023 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908942;
	bh=nY89NZ4NO1qDjNTszcFsD0G9lPetWdrs8GuHMENuPbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KW+sZz0n5RhfM2rtfEY5drEGgn2VmmyH156XJJHci4kEorGizlVaocFYG6L7MNOUk
	 LSvKhXhSw/+5Hzx5k7iCQxQPaeTsTtwcn3cGiADYrAM5Gjcn21+qfNnsbhw3lfd3Rr
	 idH03M7tVhsG/HVc9u1uXohbcPEEtaQuiE580zYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Houghton <jthoughton@google.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 66/83] arm64: mm: Always make sw-dirty PTEs hw-dirty in pte_modify
Date: Mon, 18 Dec 2023 14:52:27 +0100
Message-ID: <20231218135052.648296084@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

From: James Houghton <jthoughton@google.com>

commit 3c0696076aad60a2f04c019761921954579e1b0e upstream.

It is currently possible for a userspace application to enter an
infinite page fault loop when using HugeTLB pages implemented with
contiguous PTEs when HAFDBS is not available. This happens because:

1. The kernel may sometimes write PTEs that are sw-dirty but hw-clean
   (PTE_DIRTY | PTE_RDONLY | PTE_WRITE).

2. If, during a write, the CPU uses a sw-dirty, hw-clean PTE in handling
   the memory access on a system without HAFDBS, we will get a page
   fault.

3. HugeTLB will check if it needs to update the dirty bits on the PTE.
   For contiguous PTEs, it will check to see if the pgprot bits need
   updating. In this case, HugeTLB wants to write a sequence of
   sw-dirty, hw-dirty PTEs, but it finds that all the PTEs it is about
   to overwrite are all pte_dirty() (pte_sw_dirty() => pte_dirty()),
   so it thinks no update is necessary.

We can get the kernel to write a sw-dirty, hw-clean PTE with the
following steps (showing the relevant VMA flags and pgprot bits):

i.   Create a valid, writable contiguous PTE.
       VMA vmflags:     VM_SHARED | VM_READ | VM_WRITE
       VMA pgprot bits: PTE_RDONLY | PTE_WRITE
       PTE pgprot bits: PTE_DIRTY | PTE_WRITE

ii.  mprotect the VMA to PROT_NONE.
       VMA vmflags:     VM_SHARED
       VMA pgprot bits: PTE_RDONLY
       PTE pgprot bits: PTE_DIRTY | PTE_RDONLY

iii. mprotect the VMA back to PROT_READ | PROT_WRITE.
       VMA vmflags:     VM_SHARED | VM_READ | VM_WRITE
       VMA pgprot bits: PTE_RDONLY | PTE_WRITE
       PTE pgprot bits: PTE_DIRTY | PTE_WRITE | PTE_RDONLY

Make it impossible to create a writeable sw-dirty, hw-clean PTE with
pte_modify(). Such a PTE should be impossible to create, and there may
be places that assume that pte_dirty() implies pte_hw_dirty().

Signed-off-by: James Houghton <jthoughton@google.com>
Fixes: 031e6e6b4e12 ("arm64: hugetlb: Avoid unnecessary clearing in huge_ptep_set_access_flags")
Cc: <stable@vger.kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/r/20231204172646.2541916-3-jthoughton@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -766,6 +766,12 @@ static inline pte_t pte_modify(pte_t pte
 	if (pte_hw_dirty(pte))
 		pte = pte_mkdirty(pte);
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
+	/*
+	 * If we end up clearing hw dirtiness for a sw-dirty PTE, set hardware
+	 * dirtiness again.
+	 */
+	if (pte_sw_dirty(pte))
+		pte = pte_mkdirty(pte);
 	return pte;
 }
 


