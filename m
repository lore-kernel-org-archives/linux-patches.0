Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C2626A1D8;
	Tue,  8 Apr 2025 12:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115386; cv=none; b=t9j4x51kfgDm3IbTmbALKzNJ+sfxB5+Z00C+rqo+Ot4vIzisg2TS/gDxrvewm/VD96214/loiMdo19/Hrcb/ksM4b/tQo92djzKMawoAaUHMEwLuf1UGkh6WiAYTDgZPEIAZSQjg7S18eaXM/1e503DCAud8GevhDF7pWJksgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115386; c=relaxed/simple;
	bh=iRK1PWBI9LUNAsg3DWuRDWV8cYx7pxrWciXmv7Sv+Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnTu8YwBp18tAMBnYuW5nM213OC0uvyVp+jnblM3IhLdedpIadjYkPT6eJZwjTfPEcU5j8Hc6b7kBEtNBONC6FIUsoxhw9AUNd1Uxj8/AywCkdWSVxB3nJaGZhBSFZiE5A6WPi3TsBKfEc+VRhIEYrFnNAyOLSNhASVrRoB90MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cyuuk9IG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cyuuk9IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D72C4CEE5;
	Tue,  8 Apr 2025 12:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115386;
	bh=iRK1PWBI9LUNAsg3DWuRDWV8cYx7pxrWciXmv7Sv+Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cyuuk9IGWIb74iyesXNImI6FkPPZPOFHd04C5KY4Do6x5oizlbYkRsQdGZ44ZY7zn
	 BERDU/LpPseb4he8LDv1PUg8+CENniKwhDk7H6Qu60TSTx6msvMYqSP2Eh4nuadPTA
	 mYVfDZ1D84jp5f3M6hBy3+bFpK2bSVzMCy45JnQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.13 454/499] x86/mm: Fix flush_tlb_range() when used for zapping normal PMDs
Date: Tue,  8 Apr 2025 12:51:06 +0200
Message-ID: <20250408104902.556142012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 3ef938c3503563bfc2ac15083557f880d29c2e64 upstream.

On the following path, flush_tlb_range() can be used for zapping normal
PMD entries (PMD entries that point to page tables) together with the PTE
entries in the pointed-to page table:

    collapse_pte_mapped_thp
      pmdp_collapse_flush
        flush_tlb_range

The arm64 version of flush_tlb_range() has a comment describing that it can
be used for page table removal, and does not use any last-level
invalidation optimizations. Fix the X86 version by making it behave the
same way.

Currently, X86 only uses this information for the following two purposes,
which I think means the issue doesn't have much impact:

 - In native_flush_tlb_multi() for checking if lazy TLB CPUs need to be
   IPI'd to avoid issues with speculative page table walks.
 - In Hyper-V TLB paravirtualization, again for lazy TLB stuff.

The patch "x86/mm: only invalidate final translations with INVLPGB" which
is currently under review (see
<https://lore.kernel.org/all/20241230175550.4046587-13-riel@surriel.com/>)
would probably be making the impact of this a lot worse.

Fixes: 016c4d92cd16 ("x86/mm/tlb: Add freed_tables argument to flush_tlb_mm_range")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250103-x86-collapse-flush-fix-v1-1-3c521856cfa6@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/tlbflush.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -242,7 +242,7 @@ void flush_tlb_multi(const struct cpumas
 	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
 			   ((vma)->vm_flags & VM_HUGETLB)		\
 				? huge_page_shift(hstate_vma(vma))	\
-				: PAGE_SHIFT, false)
+				: PAGE_SHIFT, true)
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,


