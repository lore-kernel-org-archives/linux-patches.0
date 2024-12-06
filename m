Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E071527AC;
	Fri,  6 Dec 2024 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496553; cv=none; b=QMSLiFZ1jdjI2sxOi2Pnv0ETN6x5weLK6qtK4a4IAHnSpXVkPNGVIrU1e9kx23iTs6jkcHvpw4DojCZFixszdbEOqKpUOdkEfof0bcvz+esmz84NoBKaagxHxJVZ922V3Kv77USiDnlv2oXqZoMdAyJwjKmhxumuLVAhRocmCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496553; c=relaxed/simple;
	bh=mZuPxtwbrOV7pX48anSg6llRROS7uyINPylKMWWy0cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDHUDawODPPWN/IBxssEjmeGhe0VT5gz2Ge4jmZ+AYVpr/TXvp5/V+2ciOc14X1ygZAyVI5T6sm0tN/x0HjoRTkW71HwpN5ZDlopPVRr2LuPL+UrWjNOicEq83WOGbASRKCsrGEuwC7jNWUvn6zTmdWgVO9XLO6Ohy4Rc/gqioQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNjIPK+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNjIPK+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EFAC4CEDE;
	Fri,  6 Dec 2024 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496553;
	bh=mZuPxtwbrOV7pX48anSg6llRROS7uyINPylKMWWy0cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNjIPK+4z/x+xmO3JUA1rM7F2P8jKAFaFqFkkOmA7mFp6iEn1legc8Tp4BoVYQoYq
	 oHA6KELnW8mA8c3gulMPWbyTbiO8Cis9QWzGHdjy1xr4iz08UNfDp4kiRPHsXjJ7xg
	 wcYND7o9x36uGROVSkcF3SXFcjK84V7yWqz7MHcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/676] x86/stackprotector: Work around strict Clang TLS symbol requirements
Date: Fri,  6 Dec 2024 15:27:36 +0100
Message-ID: <20241206143654.805027653@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 577c134d311b9b94598d7a0c86be1f431f823003 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile                     |  3 ++-
 arch/x86/entry/entry.S                | 15 +++++++++++++++
 arch/x86/include/asm/asm-prototypes.h |  3 +++
 arch/x86/kernel/cpu/common.c          |  2 ++
 arch/x86/kernel/vmlinux.lds.S         |  3 +++
 5 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3ff53a2d4ff08..c83582b5a010d 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -113,7 +113,8 @@ ifeq ($(CONFIG_X86_32),y)
 
 	ifeq ($(CONFIG_STACKPROTECTOR),y)
 		ifeq ($(CONFIG_SMP),y)
-			KBUILD_CFLAGS += -mstack-protector-guard-reg=fs -mstack-protector-guard-symbol=__stack_chk_guard
+			KBUILD_CFLAGS += -mstack-protector-guard-reg=fs \
+					 -mstack-protector-guard-symbol=__ref_stack_chk_guard
 		else
 			KBUILD_CFLAGS += -mstack-protector-guard=global
 		endif
diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 34eca8015b64b..2143358d0c4c7 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -48,3 +48,18 @@ EXPORT_SYMBOL_GPL(mds_verw_sel);
 
 .popsection
 
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
diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index 0e82074517f6b..768076e686684 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -19,3 +19,6 @@
 extern void cmpxchg8b_emu(void);
 #endif
 
+#if defined(__GENKSYMS__) && defined(CONFIG_STACKPROTECTOR)
+extern unsigned long __ref_stack_chk_guard;
+#endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7a1e58fb43a03..852cc2ab4df94 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2159,8 +2159,10 @@ void syscall_init(void)
 
 #ifdef CONFIG_STACKPROTECTOR
 DEFINE_PER_CPU(unsigned long, __stack_chk_guard);
+#ifndef CONFIG_SMP
 EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
 #endif
+#endif
 
 #endif	/* CONFIG_X86_64 */
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 54a5596adaa61..60eb8baa44d7b 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -496,6 +496,9 @@ SECTIONS
 	ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations (.rela) detected!")
 }
 
+/* needed for Clang - see arch/x86/entry/entry.S */
+PROVIDE(__ref_stack_chk_guard = __stack_chk_guard);
+
 /*
  * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
  */
-- 
2.43.0



