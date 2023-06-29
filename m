Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C4714284
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C98C433C0;
	Thu, 29 Jun 2023 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064464;
	bh=pF170Xpm3aG6Wr2QodAS9NbKUqn3ybwaDa2Ttvzy/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aUhCzzOXTi7pY0Uj2GZGsTGmy5Lhw8DbLRaK5CKEypkeEsYu7KA/jUO90PQ/jcl8
	 APoOh24UNCIloUhCBoNr7tI95GjAgwsD6CEvGukaUgxypFdRGZOa9PS69B5wVh4kZs
	 RlY5EVhD6iYS3cXCHsw1PXzpns6Ss97NQ75x+RDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.4 12/28] arm64/mm: Convert to using lock_mm_and_find_vma()
Date: Thu, 29 Jun 2023 20:44:00 +0200
Message-ID: <20230629184152.376648415@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.888604958@linuxfoundation.org>
References: <20230629184151.888604958@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit ae870a68b5d13d67cf4f18d47bb01ee3fee40acb upstream.

This converts arm64 to use the new page fault helper.  It was very
straightforward, but still needed a fix for the "obvious" conversion I
initially did.  Thanks to Suren for the fix and testing.

Fixed-and-tested-by: Suren Baghdasaryan <surenb@google.com>
Unnecessary-code-removal-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig    |    1 +
 arch/arm64/mm/fault.c |   47 ++++++++---------------------------------------
 2 files changed, 9 insertions(+), 39 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -225,6 +225,7 @@ config ARM64
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
 	select KASAN_VMALLOC if KASAN
+	select LOCK_MM_AND_FIND_VMA
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -483,27 +483,14 @@ static void do_bad_area(unsigned long fa
 #define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
 #define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
 
-static vm_fault_t __do_page_fault(struct mm_struct *mm, unsigned long addr,
+static vm_fault_t __do_page_fault(struct mm_struct *mm,
+				  struct vm_area_struct *vma, unsigned long addr,
 				  unsigned int mm_flags, unsigned long vm_flags,
 				  struct pt_regs *regs)
 {
-	struct vm_area_struct *vma = find_vma(mm, addr);
-
-	if (unlikely(!vma))
-		return VM_FAULT_BADMAP;
-
 	/*
 	 * Ok, we have a good vm_area for this memory access, so we can handle
 	 * it.
-	 */
-	if (unlikely(vma->vm_start > addr)) {
-		if (!(vma->vm_flags & VM_GROWSDOWN))
-			return VM_FAULT_BADMAP;
-		if (expand_stack(vma, addr))
-			return VM_FAULT_BADMAP;
-	}
-
-	/*
 	 * Check that the permissions on the VMA allow for the fault which
 	 * occurred.
 	 */
@@ -617,31 +604,15 @@ static int __kprobes do_page_fault(unsig
 	}
 lock_mmap:
 #endif /* CONFIG_PER_VMA_LOCK */
-	/*
-	 * As per x86, we may deadlock here. However, since the kernel only
-	 * validly references user space from well defined areas of the code,
-	 * we can bug out early if this is from code which shouldn't.
-	 */
-	if (!mmap_read_trylock(mm)) {
-		if (!user_mode(regs) && !search_exception_tables(regs->pc))
-			goto no_context;
+
 retry:
-		mmap_read_lock(mm);
-	} else {
-		/*
-		 * The above mmap_read_trylock() might have succeeded in which
-		 * case, we'll have missed the might_sleep() from down_read().
-		 */
-		might_sleep();
-#ifdef CONFIG_DEBUG_VM
-		if (!user_mode(regs) && !search_exception_tables(regs->pc)) {
-			mmap_read_unlock(mm);
-			goto no_context;
-		}
-#endif
+	vma = lock_mm_and_find_vma(mm, addr, regs);
+	if (unlikely(!vma)) {
+		fault = VM_FAULT_BADMAP;
+		goto done;
 	}
 
-	fault = __do_page_fault(mm, addr, mm_flags, vm_flags, regs);
+	fault = __do_page_fault(mm, vma, addr, mm_flags, vm_flags, regs);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
@@ -660,9 +631,7 @@ retry:
 	}
 	mmap_read_unlock(mm);
 
-#ifdef CONFIG_PER_VMA_LOCK
 done:
-#endif
 	/*
 	 * Handle the "normal" (no error) case first.
 	 */


