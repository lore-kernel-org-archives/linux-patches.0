Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF7C1EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3600C433C8;
	Tue, 25 Jul 2023 10:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282132;
	bh=XyuekDBcu2bwrlnA/r26Ljyo0oc/KAgs1g4MiCcVx+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eyKhtLXCilRmXK8rUn+mJnEU0xRpi1Udy/LwsN6Rr38zCIf5k9Y0K6XVvGmTC/pq
	 fJDwmlB+vL3AbnAtqNnefgPJ96FfWd3nrhjmsAU7k4UaAbfZpejCvV2kwVHWhJnaP3
	 yHZQijfoIezKCUyVwO6n6SMkEffED0PIrFiIz6uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	matoro <matoro_mailinglist_kernel@matoro.tk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 002/227] io_uring: Fix io_uring mmap() by using architecture-provided get_unmapped_area()
Date: Tue, 25 Jul 2023 12:42:49 +0200
Message-ID: <20230725104514.910275867@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 32832a407a7178eec3215fad9b1a3298c14b0d69 upstream.

The io_uring testcase is broken on IA-64 since commit d808459b2e31
("io_uring: Adjust mapping wrt architecture aliasing requirements").

The reason is, that this commit introduced an own architecture
independend get_unmapped_area() search algorithm which finds on IA-64 a
memory region which is outside of the regular memory region used for
shared userspace mappings and which can't be used on that platform
due to aliasing.

To avoid similar problems on IA-64 and other platforms in the future,
it's better to switch back to the architecture-provided
get_unmapped_area() function and adjust the needed input parameters
before the call. Beside fixing the issue, the function now becomes
easier to understand and maintain.

This patch has been successfully tested with the io_uring testcase on
physical x86-64, ppc64le, IA-64 and PA-RISC machines. On PA-RISC the LTP
mmmap testcases did not report any regressions.

Cc: stable@vger.kernel.org # 6.4
Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Fixes: d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing requirements")
Link: https://lore.kernel.org/r/20230721152432.196382-2-deller@gmx.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/sys_parisc.c |   15 +++++++++-----
 io_uring/io_uring.c             |   42 ++++++++++++++++------------------------
 2 files changed, 27 insertions(+), 30 deletions(-)

--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -26,12 +26,17 @@
 #include <linux/compat.h>
 
 /*
- * Construct an artificial page offset for the mapping based on the physical
+ * Construct an artificial page offset for the mapping based on the virtual
  * address of the kernel file mapping variable.
+ * If filp is zero the calculated pgoff value aliases the memory of the given
+ * address. This is useful for io_uring where the mapping shall alias a kernel
+ * address and a userspace adress where both the kernel and the userspace
+ * access the same memory region.
  */
-#define GET_FILP_PGOFF(filp)		\
-	(filp ? (((unsigned long) filp->f_mapping) >> 8)	\
-		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)
+#define GET_FILP_PGOFF(filp, addr)		\
+	((filp ? (((unsigned long) filp->f_mapping) >> 8)	\
+		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)	\
+	  + (addr >> PAGE_SHIFT))
 
 static unsigned long shared_align_offset(unsigned long filp_pgoff,
 					 unsigned long pgoff)
@@ -111,7 +116,7 @@ static unsigned long arch_get_unmapped_a
 	do_color_align = 0;
 	if (filp || (flags & MAP_SHARED))
 		do_color_align = 1;
-	filp_pgoff = GET_FILP_PGOFF(filp);
+	filp_pgoff = GET_FILP_PGOFF(filp, addr);
 
 	if (flags & MAP_FIXED) {
 		/* Even MAP_FIXED mappings must reside within TASK_SIZE */
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3433,8 +3433,6 @@ static unsigned long io_uring_mmu_get_un
 			unsigned long addr, unsigned long len,
 			unsigned long pgoff, unsigned long flags)
 {
-	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
-	struct vm_unmapped_area_info info;
 	void *ptr;
 
 	/*
@@ -3449,32 +3447,26 @@ static unsigned long io_uring_mmu_get_un
 	if (IS_ERR(ptr))
 		return -ENOMEM;
 
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
+	/*
+	 * Some architectures have strong cache aliasing requirements.
+	 * For such architectures we need a coherent mapping which aliases
+	 * kernel memory *and* userspace memory. To achieve that:
+	 * - use a NULL file pointer to reference physical memory, and
+	 * - use the kernel virtual address of the shared io_uring context
+	 *   (instead of the userspace-provided address, which has to be 0UL
+	 *   anyway).
+	 * For architectures without such aliasing requirements, the
+	 * architecture will return any suitable mapping because addr is 0.
+	 */
+	filp = NULL;
+	flags |= MAP_SHARED;
+	pgoff = 0;	/* has been translated to ptr above */
 #ifdef SHM_COLOUR
-	info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
+	addr = (uintptr_t) ptr;
 #else
-	info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
+	addr = 0UL;
 #endif
-	info.align_offset = (unsigned long) ptr;
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	addr = vm_unmapped_area(&info);
-	if (offset_in_page(addr)) {
-		info.flags = 0;
-		info.low_limit = TASK_UNMAPPED_BASE;
-		info.high_limit = mmap_end;
-		addr = vm_unmapped_area(&info);
-	}
-
-	return addr;
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
 #else /* !CONFIG_MMU */


