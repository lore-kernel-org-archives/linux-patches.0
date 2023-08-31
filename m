Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6EB9440
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53794C433C7;
	Thu, 31 Aug 2023 11:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480327;
	bh=EVpRbEBFcMb3fZtXLYBwFjdiUL4hAedKfWq25IiGPbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsOJLepVYMIMwNkfZgso3sDFdcUBCT6oxxTO3dDzo+I/5E8nxINljw4GI4WrvJ5x9
	 SqB1mhkNXNTo+wKBUSqbVjVKR2dl1jfNHHzkYVO13hoQqJjbWEIghJcRpCdffmFXCy
	 bN8tvcT1behqF0ZIoa9+l8iO7dL5DAOvxJ2TsC8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 07/10] parisc: Cleanup mmap implementation regarding color alignment
Date: Thu, 31 Aug 2023 13:10:47 +0200
Message-ID: <20230831110831.346422760@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>
References: <20230831110831.079963475@linuxfoundation.org>
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

From: John David Anglin <dave@parisc-linux.org>

commit 567b35159e76997e95b643b9a8a5d9d2198f2522 upstream.

This change simplifies the randomization of file mapping regions. It
reworks the code to remove duplication. The flow is now similar to
that for mips. Finally, we consistently use the do_color_align variable
to determine when color alignment is needed.

Tested on rp3440.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/sys_parisc.c |  166 +++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 103 deletions(-)

--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -25,31 +25,26 @@
 #include <linux/random.h>
 #include <linux/compat.h>
 
-/* we construct an artificial offset for the mapping based on the physical
- * address of the kernel mapping variable */
-#define GET_LAST_MMAP(filp)		\
-	(filp ? ((unsigned long) filp->f_mapping) >> 8 : 0UL)
-#define SET_LAST_MMAP(filp, val)	\
-	 { /* nothing */ }
-
-static int get_offset(unsigned int last_mmap)
-{
-	return (last_mmap & (SHM_COLOUR-1)) >> PAGE_SHIFT;
-}
+/*
+ * Construct an artificial page offset for the mapping based on the physical
+ * address of the kernel file mapping variable.
+ */
+#define GET_FILP_PGOFF(filp)		\
+	(filp ? (((unsigned long) filp->f_mapping) >> 8)	\
+		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)
 
-static unsigned long shared_align_offset(unsigned int last_mmap,
+static unsigned long shared_align_offset(unsigned long filp_pgoff,
 					 unsigned long pgoff)
 {
-	return (get_offset(last_mmap) + pgoff) << PAGE_SHIFT;
+	return (filp_pgoff + pgoff) << PAGE_SHIFT;
 }
 
 static inline unsigned long COLOR_ALIGN(unsigned long addr,
-			 unsigned int last_mmap, unsigned long pgoff)
+			 unsigned long filp_pgoff, unsigned long pgoff)
 {
 	unsigned long base = (addr+SHM_COLOUR-1) & ~(SHM_COLOUR-1);
 	unsigned long off  = (SHM_COLOUR-1) &
-		(shared_align_offset(last_mmap, pgoff) << PAGE_SHIFT);
-
+		shared_align_offset(filp_pgoff, pgoff);
 	return base + off;
 }
 
@@ -98,126 +93,91 @@ static unsigned long mmap_upper_limit(st
 	return PAGE_ALIGN(STACK_TOP - stack_base);
 }
 
+enum mmap_allocation_direction {UP, DOWN};
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+static unsigned long arch_get_unmapped_area_common(struct file *filp,
+	unsigned long addr, unsigned long len, unsigned long pgoff,
+	unsigned long flags, enum mmap_allocation_direction dir)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
-	unsigned long task_size = TASK_SIZE;
-	int do_color_align, last_mmap;
+	unsigned long filp_pgoff;
+	int do_color_align;
 	struct vm_unmapped_area_info info;
 
-	if (len > task_size)
+	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
 
 	do_color_align = 0;
 	if (filp || (flags & MAP_SHARED))
 		do_color_align = 1;
-	last_mmap = GET_LAST_MMAP(filp);
+	filp_pgoff = GET_FILP_PGOFF(filp);
 
 	if (flags & MAP_FIXED) {
-		if ((flags & MAP_SHARED) && last_mmap &&
-		    (addr - shared_align_offset(last_mmap, pgoff))
+		/* Even MAP_FIXED mappings must reside within TASK_SIZE */
+		if (TASK_SIZE - len < addr)
+			return -EINVAL;
+
+		if ((flags & MAP_SHARED) && filp &&
+		    (addr - shared_align_offset(filp_pgoff, pgoff))
 				& (SHM_COLOUR - 1))
 			return -EINVAL;
-		goto found_addr;
+		return addr;
 	}
 
 	if (addr) {
-		if (do_color_align && last_mmap)
-			addr = COLOR_ALIGN(addr, last_mmap, pgoff);
+		if (do_color_align)
+			addr = COLOR_ALIGN(addr, filp_pgoff, pgoff);
 		else
 			addr = PAGE_ALIGN(addr);
 
 		vma = find_vma_prev(mm, addr, &prev);
-		if (task_size - len >= addr &&
+		if (TASK_SIZE - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)) &&
 		    (!prev || addr >= vm_end_gap(prev)))
-			goto found_addr;
+			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
-	info.low_limit = mm->mmap_legacy_base;
-	info.high_limit = mmap_upper_limit(NULL);
-	info.align_mask = last_mmap ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
-	info.align_offset = shared_align_offset(last_mmap, pgoff);
-	addr = vm_unmapped_area(&info);
+	info.align_mask = do_color_align ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
+	info.align_offset = shared_align_offset(filp_pgoff, pgoff);
 
-found_addr:
-	if (do_color_align && !last_mmap && !(addr & ~PAGE_MASK))
-		SET_LAST_MMAP(filp, addr - (pgoff << PAGE_SHIFT));
+	if (dir == DOWN) {
+		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+		info.low_limit = PAGE_SIZE;
+		info.high_limit = mm->mmap_base;
+		addr = vm_unmapped_area(&info);
+		if (!(addr & ~PAGE_MASK))
+			return addr;
+		VM_BUG_ON(addr != -ENOMEM);
+
+		/*
+		 * A failed mmap() very likely causes application failure,
+		 * so fall back to the bottom-up function here. This scenario
+		 * can happen with large stack limits and large mmap()
+		 * allocations.
+		 */
+	}
 
-	return addr;
+	info.flags = 0;
+	info.low_limit = mm->mmap_legacy_base;
+	info.high_limit = mmap_upper_limit(NULL);
+	return vm_unmapped_area(&info);
 }
 
-unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags)
+unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
+	unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	struct vm_area_struct *vma, *prev;
-	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
-	int do_color_align, last_mmap;
-	struct vm_unmapped_area_info info;
-
-	/* requested length too big for entire address space */
-	if (len > TASK_SIZE)
-		return -ENOMEM;
-
-	do_color_align = 0;
-	if (filp || (flags & MAP_SHARED))
-		do_color_align = 1;
-	last_mmap = GET_LAST_MMAP(filp);
-
-	if (flags & MAP_FIXED) {
-		if ((flags & MAP_SHARED) && last_mmap &&
-		    (addr - shared_align_offset(last_mmap, pgoff))
-			& (SHM_COLOUR - 1))
-			return -EINVAL;
-		goto found_addr;
-	}
-
-	/* requesting a specific address */
-	if (addr) {
-		if (do_color_align && last_mmap)
-			addr = COLOR_ALIGN(addr, last_mmap, pgoff);
-		else
-			addr = PAGE_ALIGN(addr);
-
-		vma = find_vma_prev(mm, addr, &prev);
-		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)) &&
-		    (!prev || addr >= vm_end_gap(prev)))
-			goto found_addr;
-	}
-
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.low_limit = PAGE_SIZE;
-	info.high_limit = mm->mmap_base;
-	info.align_mask = last_mmap ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
-	info.align_offset = shared_align_offset(last_mmap, pgoff);
-	addr = vm_unmapped_area(&info);
-	if (!(addr & ~PAGE_MASK))
-		goto found_addr;
-	VM_BUG_ON(addr != -ENOMEM);
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	return arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
-
-found_addr:
-	if (do_color_align && !last_mmap && !(addr & ~PAGE_MASK))
-		SET_LAST_MMAP(filp, addr - (pgoff << PAGE_SHIFT));
+	return arch_get_unmapped_area_common(filp,
+			addr, len, pgoff, flags, UP);
+}
 
-	return addr;
+unsigned long arch_get_unmapped_area_topdown(struct file *filp,
+	unsigned long addr, unsigned long len, unsigned long pgoff,
+	unsigned long flags)
+{
+	return arch_get_unmapped_area_common(filp,
+			addr, len, pgoff, flags, DOWN);
 }
 
 static int mmap_is_legacy(void)


