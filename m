Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3D14267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A008C433C0;
	Thu, 29 Jun 2023 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064299;
	bh=GzBpmpcCQ/ren2w5bT7TM84mZzzc2TbezAsv4tluHlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/WJQAgUMIBmJk0bhDMZaXKcAQT2oEDWOtUm+OdutUN14q+U7lAzNU/h7ZG6I/dHM
	 pOU2vSoBHPCKspcH+YCRXjf/901bKwFyvtEciT8TapKKJ0WPVC7Tf5pfNfU5w68VKI
	 E0Ch3dI0eSI81o3Cun7+d2SivjiafFVrG/lhZ9do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Samuel Mendoza-Jonas <samjonas@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 6.1 17/30] powerpc/mm: Convert to using lock_mm_and_find_vma()
Date: Thu, 29 Jun 2023 20:43:36 +0200
Message-ID: <20230629184152.358926096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
References: <20230629184151.651069086@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

commit e6fe228c4ffafdfc970cf6d46883a1f481baf7ea upstream.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig    |    1 +
 arch/powerpc/mm/fault.c |   41 ++++-------------------------------------
 2 files changed, 5 insertions(+), 37 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -257,6 +257,7 @@ config PPC
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
 	select KASAN_VMALLOC			if KASAN && MODULES
+	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_PAGE_SIZE
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_MERGE_VMAS
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -84,11 +84,6 @@ static int __bad_area(struct pt_regs *re
 	return __bad_area_nosemaphore(regs, address, si_code);
 }
 
-static noinline int bad_area(struct pt_regs *regs, unsigned long address)
-{
-	return __bad_area(regs, address, SEGV_MAPERR);
-}
-
 static noinline int bad_access_pkey(struct pt_regs *regs, unsigned long address,
 				    struct vm_area_struct *vma)
 {
@@ -481,40 +476,12 @@ static int ___do_page_fault(struct pt_re
 	 * we will deadlock attempting to validate the fault against the
 	 * address space.  Luckily the kernel only validly references user
 	 * space from well defined areas of code, which are listed in the
-	 * exceptions table.
-	 *
-	 * As the vast majority of faults will be valid we will only perform
-	 * the source reference check when there is a possibility of a deadlock.
-	 * Attempt to lock the address space, if we cannot we then validate the
-	 * source.  If this is invalid we can skip the address space check,
-	 * thus avoiding the deadlock.
-	 */
-	if (unlikely(!mmap_read_trylock(mm))) {
-		if (!is_user && !search_exception_tables(regs->nip))
-			return bad_area_nosemaphore(regs, address);
-
+	 * exceptions table. lock_mm_and_find_vma() handles that logic.
+	 */
 retry:
-		mmap_read_lock(mm);
-	} else {
-		/*
-		 * The above down_read_trylock() might have succeeded in
-		 * which case we'll have missed the might_sleep() from
-		 * down_read():
-		 */
-		might_sleep();
-	}
-
-	vma = find_vma(mm, address);
+	vma = lock_mm_and_find_vma(mm, address, regs);
 	if (unlikely(!vma))
-		return bad_area(regs, address);
-
-	if (unlikely(vma->vm_start > address)) {
-		if (unlikely(!(vma->vm_flags & VM_GROWSDOWN)))
-			return bad_area(regs, address);
-
-		if (unlikely(expand_stack(vma, address)))
-			return bad_area(regs, address);
-	}
+		return bad_area_nosemaphore(regs, address);
 
 	if (unlikely(access_pkey_error(is_write, is_exec,
 				       (error_code & DSISR_KEYFAULT), vma)))


