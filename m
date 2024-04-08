Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1717D419;
	Mon,  8 Apr 2024 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582635; cv=none; b=S25mOcNB7ojNerqZhiYfdSHnjcj1rfc1v9GwK2EzrdJ2R7aPskuoY5rGYvnHuFmpfSHmeRWpkcqYBhTsQzWUZ2KzBLj3rv0eztMU086RsBMqwsKZppvTIcc9mluLMVi3copAey9yBTM0Uf5MyAtxrckEPyJpso5jvjYF1vCyhPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582635; c=relaxed/simple;
	bh=wBfDkII/2Z+SeDq0iv9Cu+pJnDAeQOz6JNs5UzTF6T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSY9Z4v5OPaJRawDgc/haMXqBuOF0ZJr/BnM+0UELrczUpnHEBuJNXh7mNu+osso8XWeoD9Ejpr6EAIb4fAl10pAq3VFaCyKp5UHvErDqm0/90qAvqhckTb9UoTczFTOoXkrh68zf/uxR4jwZHpN3E7R7YuPwd3JLrlGyIqtB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCsjbgK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCsjbgK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEACCC433F1;
	Mon,  8 Apr 2024 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582635;
	bh=wBfDkII/2Z+SeDq0iv9Cu+pJnDAeQOz6JNs5UzTF6T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCsjbgK3URxPQENNSVK6kMo7+waXF7VRHyPWMNOQCmCbtrERb80S54inzt3FP5AH3
	 K51BXPFzFKSsNuaFUIjsqdQnvW3kG1zj08an1vEOa6W1Jir7EHE805qNyje1BGLEvp
	 hmHijghkHglKVCFu/kHD8F0QVqmXmsLpzZxpmCIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 161/690] arch: Introduce CONFIG_FUNCTION_ALIGNMENT
Date: Mon,  8 Apr 2024 14:50:27 +0200
Message-ID: <20240408125405.383915127@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit d49a0626216b95cd4bf696f6acf55f39a16ab0bb upstream.

Generic function-alignment infrastructure.

Architectures can select FUNCTION_ALIGNMENT_xxB symbols; the
FUNCTION_ALIGNMENT symbol is then set to the largest such selected
size, 0 otherwise.

>From this the -falign-functions compiler argument and __ALIGN macro
are set.

This incorporates the DEBUG_FORCE_FUNCTION_ALIGN_64B knob and future
alignment requirements for x86_64 (later in this series) into a single
place.

NOTE: also removes the 0x90 filler byte from the generic __ALIGN
      primitive, that value makes no sense outside of x86.

NOTE: .balign 0 reverts to a no-op.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Change-Id: I053b3c408d56988381feb8c8bdb5e27ea221755f
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220915111143.719248727@infradead.org
[cascardo: adjust context at arch/x86/Kconfig]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                           |    4 ++--
 arch/Kconfig                       |   24 ++++++++++++++++++++++++
 arch/ia64/Kconfig                  |    1 +
 arch/ia64/Makefile                 |    2 +-
 arch/x86/Kconfig                   |    2 ++
 arch/x86/boot/compressed/head_64.S |    8 ++++++++
 arch/x86/include/asm/linkage.h     |    4 +---
 include/asm-generic/vmlinux.lds.h  |    4 ++--
 include/linux/linkage.h            |    4 ++--
 lib/Kconfig.debug                  |    1 +
 10 files changed, 44 insertions(+), 10 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1000,8 +1000,8 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_CFI)
 export CC_FLAGS_CFI
 endif
 
-ifdef CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B
-KBUILD_CFLAGS += -falign-functions=64
+ifneq ($(CONFIG_FUNCTION_ALIGNMENT),0)
+KBUILD_CFLAGS += -falign-functions=$(CONFIG_FUNCTION_ALIGNMENT)
 endif
 
 # arch Makefile may override CC so keep this after arch Makefile is included
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1303,4 +1303,28 @@ source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
 
+config FUNCTION_ALIGNMENT_4B
+	bool
+
+config FUNCTION_ALIGNMENT_8B
+	bool
+
+config FUNCTION_ALIGNMENT_16B
+	bool
+
+config FUNCTION_ALIGNMENT_32B
+	bool
+
+config FUNCTION_ALIGNMENT_64B
+	bool
+
+config FUNCTION_ALIGNMENT
+	int
+	default 64 if FUNCTION_ALIGNMENT_64B
+	default 32 if FUNCTION_ALIGNMENT_32B
+	default 16 if FUNCTION_ALIGNMENT_16B
+	default 8 if FUNCTION_ALIGNMENT_8B
+	default 4 if FUNCTION_ALIGNMENT_4B
+	default 0
+
 endmenu
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -63,6 +63,7 @@ config IA64
 	select PCI_MSI_ARCH_FALLBACKS if PCI_MSI
 	select SET_FS
 	select ZONE_DMA32
+	select FUNCTION_ALIGNMENT_32B
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -23,7 +23,7 @@ KBUILD_AFLAGS_KERNEL := -mconstant-gp
 EXTRA		:=
 
 cflags-y	:= -pipe $(EXTRA) -ffixed-r13 -mfixed-range=f12-f15,f32-f127 \
-		   -falign-functions=32 -frename-registers -fno-optimize-sibling-calls
+		   -frename-registers -fno-optimize-sibling-calls
 KBUILD_CFLAGS_KERNEL := -mconstant-gp
 
 GAS_STATUS	= $(shell $(srctree)/arch/ia64/scripts/check-gas "$(CC)" "$(OBJDUMP)")
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -267,6 +267,8 @@ config X86
 	select HAVE_ARCH_KCSAN			if X86_64
 	select X86_FEATURE_NAMES		if PROC_FS
 	select PROC_PID_ARCH_STATUS		if PROC_FS
+	select FUNCTION_ALIGNMENT_16B		if X86_64 || X86_ALIGNMENT_16
+	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 
 config INSTRUCTION_DECODER
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -38,6 +38,14 @@
 #include "pgtable.h"
 
 /*
+ * Fix alignment at 16 bytes. Following CONFIG_FUNCTION_ALIGNMENT will result
+ * in assembly errors due to trying to move .org backward due to the excessive
+ * alignment.
+ */
+#undef __ALIGN
+#define __ALIGN		.balign	16, 0x90
+
+/*
  * Locally defined symbols should be marked hidden:
  */
 	.hidden _bss
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -13,10 +13,8 @@
 
 #ifdef __ASSEMBLY__
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_ALIGNMENT_16)
-#define __ALIGN		.p2align 4, 0x90
+#define __ALIGN		.balign CONFIG_FUNCTION_ALIGNMENT, 0x90;
 #define __ALIGN_STR	__stringify(__ALIGN)
-#endif
 
 #if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define RET	jmp __x86_return_thunk
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -81,8 +81,8 @@
 #define RO_EXCEPTION_TABLE
 #endif
 
-/* Align . to a 8 byte boundary equals to maximum function alignment. */
-#define ALIGN_FUNCTION()  . = ALIGN(8)
+/* Align . function alignment. */
+#define ALIGN_FUNCTION()  . = ALIGN(CONFIG_FUNCTION_ALIGNMENT)
 
 /*
  * LD_DEAD_CODE_DATA_ELIMINATION option enables -fdata-sections, which
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -69,8 +69,8 @@
 #endif
 
 #ifndef __ALIGN
-#define __ALIGN		.align 4,0x90
-#define __ALIGN_STR	".align 4,0x90"
+#define __ALIGN			.balign CONFIG_FUNCTION_ALIGNMENT
+#define __ALIGN_STR		__stringify(__ALIGN)
 #endif
 
 #ifdef __ASSEMBLY__
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -424,6 +424,7 @@ config SECTION_MISMATCH_WARN_ONLY
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
 	bool "Force all function address 64B aligned"
 	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
+	select FUNCTION_ALIGNMENT_64B
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance


