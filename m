Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CBB22EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AesQLEc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BCBC433C7;
	Mon,  6 Nov 2023 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277260;
	bh=fMIrVD0FFR5xU3PyDYEiMZYw7jy31yu17fBem2HwSKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AesQLEc+IG1tepO6UtW7Lz8SMenb4YCuPnLhM9DGMLbEnu1WCeQQ4DDBJMQ/cIuIt
	 RHn5TCtuskHUnOPqLAlQ8htB/n2Ia3D9KaBJ6utBXH1+lkVk6SECNyF6LFgCYHV/uG
	 G5kJc04juZffGIsuFBLwyYDVBitClvJmDAlqGM/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Byungchul Park <byungchul.park@lge.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 063/128] x86/mm: Fix RESERVE_BRK() for older binutils
Date: Mon,  6 Nov 2023 14:03:43 +0100
Message-ID: <20231106130311.960141498@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit e32683c6f7d22ba624e0bfc58b02cf3348bdca63 upstream.

With binutils 2.26, RESERVE_BRK() causes a build failure:

  /tmp/ccnGOKZ5.s: Assembler messages:
  /tmp/ccnGOKZ5.s:98: Error: missing ')'
  /tmp/ccnGOKZ5.s:98: Error: missing ')'
  /tmp/ccnGOKZ5.s:98: Error: missing ')'
  /tmp/ccnGOKZ5.s:98: Error: junk at end of line, first unrecognized
  character is `U'

The problem is this line:

  RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE)

Specifically, the INIT_PGT_BUF_SIZE macro which (via PAGE_SIZE's use
_AC()) has a "1UL", which makes older versions of the assembler unhappy.
Unfortunately the _AC() macro doesn't work for inline asm.

Inline asm was only needed here to convince the toolchain to add the
STT_NOBITS flag.  However, if a C variable is placed in a section whose
name is prefixed with ".bss", GCC and Clang automatically set
STT_NOBITS.  In fact, ".bss..page_aligned" already relies on this trick.

So fix the build failure (and simplify the macro) by allocating the
variable in C.

Also, add NOLOAD to the ".brk" output section clause in the linker
script.  This is a failsafe in case the ".bss" prefix magic trick ever
stops working somehow.  If there's a section type mismatch, the GNU
linker will force the ".brk" output section to be STT_NOBITS.  The LLVM
linker will fail with a "section type mismatch" error.

Note this also changes the name of the variable from .brk.##name to
__brk_##name.  The variable names aren't actually used anywhere, so it's
harmless.

Fixes: a1e2c031ec39 ("x86/mm: Simplify RESERVE_BRK()")
Reported-by: Joe Damato <jdamato@fastly.com>
Reported-by: Byungchul Park <byungchul.park@lge.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Joe Damato <jdamato@fastly.com>
Link: https://lore.kernel.org/r/22d07a44c80d8e8e1e82b9a806ddc8c6bbb2606e.1654759036.git.jpoimboe@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/setup.h  |   38 +++++++++++++++++++++-----------------
 arch/x86/kernel/setup.c       |    5 -----
 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 3 files changed, 23 insertions(+), 24 deletions(-)

--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -108,19 +108,16 @@ extern unsigned long _brk_end;
 void *extend_brk(size_t size, size_t align);
 
 /*
- * Reserve space in the brk section.  The name must be unique within the file,
- * and somewhat descriptive.  The size is in bytes.
+ * Reserve space in the .brk section, which is a block of memory from which the
+ * caller is allowed to allocate very early (before even memblock is available)
+ * by calling extend_brk().  All allocated memory will be eventually converted
+ * to memblock.  Any leftover unallocated memory will be freed.
  *
- * The allocation is done using inline asm (rather than using a section
- * attribute on a normal variable) in order to allow the use of @nobits, so
- * that it doesn't take up any space in the vmlinux file.
+ * The size is in bytes.
  */
-#define RESERVE_BRK(name, size)						\
-	asm(".pushsection .brk_reservation,\"aw\",@nobits\n\t"		\
-	    ".brk." #name ":\n\t"					\
-	    ".skip " __stringify(size) "\n\t"				\
-	    ".size .brk." #name ", " __stringify(size) "\n\t"		\
-	    ".popsection\n\t")
+#define RESERVE_BRK(name, size)					\
+	__section(".bss..brk") __aligned(1) __used	\
+	static char __brk_##name[size]
 
 extern void probe_roms(void);
 #ifdef __i386__
@@ -133,12 +130,19 @@ asmlinkage void __init x86_64_start_rese
 
 #endif /* __i386__ */
 #endif /* _SETUP */
-#else
-#define RESERVE_BRK(name,sz)				\
-	.pushsection .brk_reservation,"aw",@nobits;	\
-.brk.name:						\
-1:	.skip sz;					\
-	.size .brk.name,.-1b;				\
+
+#else  /* __ASSEMBLY */
+
+.macro __RESERVE_BRK name, size
+	.pushsection .bss..brk, "aw"
+SYM_DATA_START(__brk_\name)
+	.skip \size
+SYM_DATA_END(__brk_\name)
 	.popsection
+.endm
+
+#define RESERVE_BRK(name, size) __RESERVE_BRK name, size
+
 #endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_X86_SETUP_H */
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -66,11 +66,6 @@ RESERVE_BRK(dmi_alloc, 65536);
 #endif
 
 
-/*
- * Range of the BSS area. The size of the BSS area is determined
- * at link time, with RESERVE_BRK() facility reserving additional
- * chunks.
- */
 unsigned long _brk_start = (unsigned long)__brk_base;
 unsigned long _brk_end   = (unsigned long)__brk_base;
 
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -411,10 +411,10 @@ SECTIONS
 	__end_of_kernel_reserve = .;
 
 	. = ALIGN(PAGE_SIZE);
-	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+	.brk (NOLOAD) : AT(ADDR(.brk) - LOAD_OFFSET) {
 		__brk_base = .;
 		. += 64 * 1024;		/* 64k alignment slop space */
-		*(.brk_reservation)	/* areas brk users have reserved */
+		*(.bss..brk)		/* areas brk users have reserved */
 		__brk_limit = .;
 	}
 


