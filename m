Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F9E366DAE;
	Tue,  6 Jan 2026 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722088; cv=none; b=adyvKi2IbmLT1uyHjpbvviBKPMYtqep3ZtOHFKnLsdufN93/Wi8Eu8t8PUFgS1CO06pzzsOtku6m1OpEKdKHInnmDg+2lQWzWm//7oqD3E8x3n+fG09d1GEa4vsvy2sfTNsdajmkYmjhEjJeCjpp+/9LQeuYDp+7m54abptRsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722088; c=relaxed/simple;
	bh=S6J5zHc11sdMgfNTma1IiZa47mCKxKRJ4noGgqIMDVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EePDec4oAyrhuYv9n+mJmjoByfUbQJRe6V2MEcCoNQw7b+NQcHaY6pz1XmG74I8l+rfyQb/FfgObtj5gPwDVRcVw9tcLS5W1ULUM5bIBWuKQq5DMpjzQV8EO3yr1JPxNVwJPyx7X8MLIkA1IOuBSHEPorAag051yX+I+CbhhwBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlcOZhMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlcOZhMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35656C116C6;
	Tue,  6 Jan 2026 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722087;
	bh=S6J5zHc11sdMgfNTma1IiZa47mCKxKRJ4noGgqIMDVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlcOZhMfqexsHOa5Qggz3nUVrHe4jSFk7QAirAlpP3nCOkFiT5yg5gCytIxDiSG6F
	 fwbAhLi+Fc7k+dwVuKeWxQrfY9tT7B+WyI4o32f4J7wpRiDEmZOFPicyDKU79Xn5Xa
	 QK8dzA88zzOiZZCIXL7K180umhjiR95Y+X1GSgP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Dave Vasilevsky <dave@vasilevsky.ca>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 128/312] powerpc, mm: Fix mprotect on book3s 32-bit
Date: Tue,  6 Jan 2026 18:03:22 +0100
Message-ID: <20260106170552.474535099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Vasilevsky <dave@vasilevsky.ca>

commit 78fc63ffa7813e33681839bb33826c24195f0eb7 upstream.

On 32-bit book3s with hash-MMUs, tlb_flush() was a no-op. This was
unnoticed because all uses until recently were for unmaps, and thus
handled by __tlb_remove_tlb_entry().

After commit 4a18419f71cd ("mm/mprotect: use mmu_gather") in kernel 5.19,
tlb_gather_mmu() started being used for mprotect as well. This caused
mprotect to simply not work on these machines:

  int *ptr = mmap(NULL, 4096, PROT_READ|PROT_WRITE,
                  MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  *ptr = 1; // force HPTE to be created
  mprotect(ptr, 4096, PROT_READ);
  *ptr = 2; // should segfault, but succeeds

Fixed by making tlb_flush() actually flush TLB pages. This finally
agrees with the behaviour of boot3s64's tlb_flush().

Fixes: 4a18419f71cd ("mm/mprotect: use mmu_gather")
Cc: stable@vger.kernel.org
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251116-vasi-mprotect-g3-v3-1-59a9bd33ba00@vasilevsky.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/book3s/32/tlbflush.h |    5 ++++-
 arch/powerpc/mm/book3s32/tlb.c                |    9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/32/tlbflush.h
+++ b/arch/powerpc/include/asm/book3s/32/tlbflush.h
@@ -11,6 +11,7 @@
 void hash__flush_tlb_mm(struct mm_struct *mm);
 void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
 void hash__flush_range(struct mm_struct *mm, unsigned long start, unsigned long end);
+void hash__flush_gather(struct mmu_gather *tlb);
 
 #ifdef CONFIG_SMP
 void _tlbie(unsigned long address);
@@ -29,7 +30,9 @@ void _tlbia(void);
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
-	if (!mmu_has_feature(MMU_FTR_HPTE_TABLE))
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		hash__flush_gather(tlb);
+	else
 		_tlbia();
 }
 
--- a/arch/powerpc/mm/book3s32/tlb.c
+++ b/arch/powerpc/mm/book3s32/tlb.c
@@ -105,3 +105,12 @@ void hash__flush_tlb_page(struct vm_area
 		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
 }
 EXPORT_SYMBOL(hash__flush_tlb_page);
+
+void hash__flush_gather(struct mmu_gather *tlb)
+{
+	if (tlb->fullmm || tlb->need_flush_all)
+		hash__flush_tlb_mm(tlb->mm);
+	else
+		hash__flush_range(tlb->mm, tlb->start, tlb->end);
+}
+EXPORT_SYMBOL(hash__flush_gather);


