Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE71D144;
	Mon, 18 Dec 2023 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpJ7127k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A88C433C7;
	Mon, 18 Dec 2023 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908311;
	bh=y29Cjv8/lPVuqHzL3EIqcRVDO1gsBbxAqbjlwoY7G7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpJ7127kyLZIXHtAicUR2/cVV7WW6Oeletr5Hyr49mKNn0AELoUeW5BubBVNeQTBX
	 A5iv0/+/UreYAAcJkkLRnrv7kmzBMjuTPg3mnI4pqLvGQZTRc+IXwGhxC4qPQrPcA1
	 63Q3Vfk35orfxTH6JQFDuNGz0Scx9S8kFy6Lg7vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Houghton <jthoughton@google.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 131/166] arm64: mm: Always make sw-dirty PTEs hw-dirty in pte_modify
Date: Mon, 18 Dec 2023 14:51:37 +0100
Message-ID: <20231218135110.951266133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -826,6 +826,12 @@ static inline pte_t pte_modify(pte_t pte
 		pte = set_pte_bit(pte, __pgprot(PTE_DIRTY));
 
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
+	/*
+	 * If we end up clearing hw dirtiness for a sw-dirty PTE, set hardware
+	 * dirtiness again.
+	 */
+	if (pte_sw_dirty(pte))
+		pte = pte_mkdirty(pte);
 	return pte;
 }
 


