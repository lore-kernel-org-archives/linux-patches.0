Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255B1DFEF;
	Wed, 20 Nov 2024 12:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107543; cv=none; b=t8zc/sTqXhJPiVoMcYFm/+OJV066fnuHo9XGt83NxJsqO/+v8ETH8b6VAffZ5KTZN5/RCJWESq2l2Lg0yP3pTsLqTvzs9DFIJxzU9efqX0but74WEQCgZG/5439OUG2S779M5TygYMYas8GdQTxbFm8yBDqSSnoy0D2Oww//OqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107543; c=relaxed/simple;
	bh=2KJdwdEF4f/rkh2xCgbWJ7/4scskCEIUANqUq57512g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvZxwv0HkmY6ZEMdXv52dg5czJWig9juHnxiHlvspu7227SZtV5T29nPa/Cnaid6omqAIhCag7sGljOroNa9ot0FUxpI2/lc9ZRoeqR4Q4GCyg42Q7ADN1xCmPIBb2DZ4qfBSARnTI3atKARFWDpP/bpwrS4R5KuTe9be3F+Duk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp3L+BXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp3L+BXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78C0C4CECD;
	Wed, 20 Nov 2024 12:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107542;
	bh=2KJdwdEF4f/rkh2xCgbWJ7/4scskCEIUANqUq57512g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp3L+BXCe90XZdMGiFVIBqyk41/WV1I6kZ/2Nq25m2pEFk6mv/WuJanpervEXEccD
	 DQQlmBz3g3PBsnWhtc8FfIzQ8Iy61gLc3q+bq/aExIe4LqXWJ7dt/njO79cEN6QBal
	 eyFfl6AO/nVhjFI1X8N4YahfEvjWM5HhfwYVeneU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.11 041/107] x86/stackprotector: Work around strict Clang TLS symbol requirements
Date: Wed, 20 Nov 2024 13:56:16 +0100
Message-ID: <20241120125630.602084856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 577c134d311b9b94598d7a0c86be1f431f823003 upstream.

GCC and Clang both implement stack protector support based on Thread Local
Storage (TLS) variables, and this is used in the kernel to implement per-task
stack cookies, by copying a task's stack cookie into a per-CPU variable every
time it is scheduled in.

Both now also implement -mstack-protector-guard-symbol=, which permits the TLS
variable to be specified directly. This is useful because it will allow to
move away from using a fixed offset of 40 bytes into the per-CPU area on
x86_64, which requires a lot of special handling in the per-CPU code and the
runtime relocation code.

However, while GCC is rather lax in its implementation of this command line
option, Clang actually requires that the provided symbol name refers to a TLS
variable (i.e., one declared with __thread), although it also permits the
variable to be undeclared entirely, in which case it will use an implicit
declaration of the right type.

The upshot of this is that Clang will emit the correct references to the stack
cookie variable in most cases, e.g.,

  10d:       64 a1 00 00 00 00       mov    %fs:0x0,%eax
                     10f: R_386_32   __stack_chk_guard

However, if a non-TLS definition of the symbol in question is visible in the
same compilation unit (which amounts to the whole of vmlinux if LTO is
enabled), it will drop the per-CPU prefix and emit a load from a bogus
address.

Work around this by using a symbol name that never occurs in C code, and emit
it as an alias in the linker script.

Fixes: 3fb0fdb3bbe7 ("x86/stackprotector/32: Make the canary into a regular percpu variable")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1854
Link: https://lore.kernel.org/r/20241105155801.1779119-2-brgerst@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile                     |    5 +++--
 arch/x86/entry/entry.S                |   16 ++++++++++++++++
 arch/x86/include/asm/asm-prototypes.h |    3 +++
 arch/x86/kernel/cpu/common.c          |    2 ++
 arch/x86/kernel/vmlinux.lds.S         |    3 +++
 5 files changed, 27 insertions(+), 2 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -138,9 +138,10 @@ ifeq ($(CONFIG_X86_32),y)
 
     ifeq ($(CONFIG_STACKPROTECTOR),y)
         ifeq ($(CONFIG_SMP),y)
-			KBUILD_CFLAGS += -mstack-protector-guard-reg=fs -mstack-protector-guard-symbol=__stack_chk_guard
+            KBUILD_CFLAGS += -mstack-protector-guard-reg=fs \
+                             -mstack-protector-guard-symbol=__ref_stack_chk_guard
         else
-			KBUILD_CFLAGS += -mstack-protector-guard=global
+            KBUILD_CFLAGS += -mstack-protector-guard=global
         endif
     endif
 else
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -51,3 +51,19 @@ EXPORT_SYMBOL_GPL(mds_verw_sel);
 .popsection
 
 THUNK warn_thunk_thunk, __warn_thunk
+
+#ifndef CONFIG_X86_64
+/*
+ * Clang's implementation of TLS stack cookies requires the variable in
+ * question to be a TLS variable. If the variable happens to be defined as an
+ * ordinary variable with external linkage in the same compilation unit (which
+ * amounts to the whole of vmlinux with LTO enabled), Clang will drop the
+ * segment register prefix from the references, resulting in broken code. Work
+ * around this by avoiding the symbol used in -mstack-protector-guard-symbol=
+ * entirely in the C code, and use an alias emitted by the linker script
+ * instead.
+ */
+#ifdef CONFIG_STACKPROTECTOR
+EXPORT_SYMBOL(__ref_stack_chk_guard);
+#endif
+#endif
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -20,3 +20,6 @@
 extern void cmpxchg8b_emu(void);
 #endif
 
+#if defined(__GENKSYMS__) && defined(CONFIG_STACKPROTECTOR)
+extern unsigned long __ref_stack_chk_guard;
+#endif
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2084,8 +2084,10 @@ void syscall_init(void)
 
 #ifdef CONFIG_STACKPROTECTOR
 DEFINE_PER_CPU(unsigned long, __stack_chk_guard);
+#ifndef CONFIG_SMP
 EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
 #endif
+#endif
 
 #endif	/* CONFIG_X86_64 */
 
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -492,6 +492,9 @@ SECTIONS
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 
+/* needed for Clang - see arch/x86/entry/entry.S */
+PROVIDE(__ref_stack_chk_guard = __stack_chk_guard);
+
 #ifdef CONFIG_X86_64
 /*
  * Per-cpu symbols which need to be offset from __per_cpu_load


