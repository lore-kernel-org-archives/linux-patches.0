Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C2B3A8C6;
	Fri, 24 Nov 2023 18:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRZxqAyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1701FC433C8;
	Fri, 24 Nov 2023 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850023;
	bh=mImOP+ltihGgnwY5maKLq9ylIJnwITtKa3giLJXwA+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRZxqAyxbvm1Jxn2SS8RNsMAgVcuNGtuxcF2JkGNMCNsqVJG90U3u/friOSFIM2Cb
	 OB/A/Mn5JIbeoGxIs+gbcsdgGrGlVu+HQPoceAjVPvNRKpNis0Svh7s7qLikd+NyEg
	 eZ1OGBG3/En83dxz+KoEcjTY49uSGYOFSBof8Db0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	matoro <matoro_mailinglist_kernel@matoro.tk>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 415/530] parisc: fix mmap_base calculation when stack grows upwards
Date: Fri, 24 Nov 2023 17:49:41 +0000
Message-ID: <20231124172040.691840897@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 5f74f820f6fc844b95f9e5e406e0a07d97510420 upstream.

Matoro reported various userspace crashes on the parisc platform with kernel
6.6 and bisected it to commit 3033cd430768 ("parisc: Use generic mmap top-down
layout and brk randomization").

That commit switched parisc to use the common infrastructure to calculate
mmap_base, but missed that the mmap_base() function takes care for
architectures where the stack grows downwards only.

Fix the mmap_base() calculation to include the stack-grows-upwards case
and thus fix the userspace crashes on parisc.

Link: https://lkml.kernel.org/r/ZVH2qeS1bG7/1J/l@p100
Fixes: 3033cd430768 ("parisc: Use generic mmap top-down layout and brk randomization")
Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig                 |    6 +++---
 arch/parisc/include/asm/elf.h       |   10 +---------
 arch/parisc/include/asm/processor.h |    2 ++
 arch/parisc/kernel/sys_parisc.c     |    2 +-
 mm/util.c                           |   10 ++++++++++
 5 files changed, 17 insertions(+), 13 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -138,11 +138,11 @@ config ARCH_MMAP_RND_COMPAT_BITS_MIN
 	default 8
 
 config ARCH_MMAP_RND_BITS_MAX
-	default 24 if 64BIT
-	default 17
+	default 18 if 64BIT
+	default 13
 
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
-	default 17
+	default 13
 
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
--- a/arch/parisc/include/asm/elf.h
+++ b/arch/parisc/include/asm/elf.h
@@ -349,15 +349,7 @@ struct pt_regs;	/* forward declaration..
 
 #define ELF_HWCAP	0
 
-/* Masks for stack and mmap randomization */
-#define BRK_RND_MASK	(is_32bit_task() ? 0x07ffUL : 0x3ffffUL)
-#define MMAP_RND_MASK	(is_32bit_task() ? 0x1fffUL : 0x3ffffUL)
-#define STACK_RND_MASK	MMAP_RND_MASK
-
-struct mm_struct;
-extern unsigned long arch_randomize_brk(struct mm_struct *);
-#define arch_randomize_brk arch_randomize_brk
-
+#define STACK_RND_MASK	0x7ff	/* 8MB of VA */
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 struct linux_binprm;
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -47,6 +47,8 @@
 
 #ifndef __ASSEMBLY__
 
+struct rlimit;
+unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsign
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-static unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
 {
 	unsigned long stack_base;
 
--- a/mm/util.c
+++ b/mm/util.c
@@ -414,6 +414,15 @@ static int mmap_is_legacy(struct rlimit
 
 static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	/*
+	 * For an upwards growing stack the calculation is much simpler.
+	 * Memory for the maximum stack size is reserved at the top of the
+	 * task. mmap_base starts directly below the stack and grows
+	 * downwards.
+	 */
+	return PAGE_ALIGN_DOWN(mmap_upper_limit(rlim_stack) - rnd);
+#else
 	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_guard_gap;
 
@@ -431,6 +440,7 @@ static unsigned long mmap_base(unsigned
 		gap = MAX_GAP;
 
 	return PAGE_ALIGN(STACK_TOP - gap - rnd);
+#endif
 }
 
 void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)


