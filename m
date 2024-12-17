Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC261EF085;
	Tue, 17 Dec 2024 17:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456273; cv=none; b=NjML0Ffz501PrjxkX+B061Rr5s6AOrwoRZD3yBa164+Ty3t8eDxzG5Wl3hZ7fRehIDqE5r56XePmePGjhz22GcfL6WlqhYbkwGxxOo2aVdMCJebUCG1d8tNOp7tlgGypt605qzl/Sos1e8WMSzyzkTe9bOQ+EtgMkCoOF5c5/AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456273; c=relaxed/simple;
	bh=18xLHDrYE6Y9AjJ3aD/By7eXh2+PbKjUd99aQHHZn+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNG/7FPtEbu7pXPWHQ7yCqnYHSCfR1p30n6cTxuEoW3n426CmD3HhnAmKagpzJ0x+eW2cyavppyf7Db6BAEUtvM8tiap1H4On8MmWz0vc3HXpS3xDyloog2rozDH/eTicIV1Y9yBKSX/BVT/7qWOQpvawmBsyHQFsZOd4VzI6lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9g6k1b2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9g6k1b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8F6C4CED7;
	Tue, 17 Dec 2024 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456273;
	bh=18xLHDrYE6Y9AjJ3aD/By7eXh2+PbKjUd99aQHHZn+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9g6k1b2DDoyGMK9FkC02oAVrV6g1OMEfzuLsXCP7VxjB7zstSqod7Qy1FpnhJY2F
	 UUl6SLTGJvELkDHr/Skv61RGUKGQkFvYf87JMKHB3Mm+/ZCWRklbeZewl7c+n/IjGu
	 9xo33L8fgmaw42ufNxUOedCinBfa54mIjJSMaR+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 6.6 104/109] x86/static-call: provide a way to do very early static-call updates
Date: Tue, 17 Dec 2024 18:08:28 +0100
Message-ID: <20241217170537.748652732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

commit 0ef8047b737d7480a5d4c46d956e97c190f13050 upstream.

Add static_call_update_early() for updating static-call targets in
very early boot.

This will be needed for support of Xen guest type specific hypercall
functions.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/static_call.h |   15 +++++++++++++++
 arch/x86/include/asm/sync_core.h   |    6 +++---
 arch/x86/kernel/static_call.c      |    9 +++++++++
 include/linux/compiler.h           |   37 ++++++++++++++++++++++++++-----------
 include/linux/static_call.h        |    1 +
 kernel/static_call_inline.c        |    2 +-
 6 files changed, 55 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -65,4 +65,19 @@
 
 extern bool __static_call_fixup(void *tramp, u8 op, void *dest);
 
+extern void __static_call_update_early(void *tramp, void *func);
+
+#define static_call_update_early(name, _func)				\
+({									\
+	typeof(&STATIC_CALL_TRAMP(name)) __F = (_func);			\
+	if (static_call_initialized) {					\
+		__static_call_update(&STATIC_CALL_KEY(name),		\
+				     STATIC_CALL_TRAMP_ADDR(name), __F);\
+	} else {							\
+		WRITE_ONCE(STATIC_CALL_KEY(name).func, _func);		\
+		__static_call_update_early(STATIC_CALL_TRAMP_ADDR(name),\
+					   __F);			\
+	}								\
+})
+
 #endif /* _ASM_STATIC_CALL_H */
--- a/arch/x86/include/asm/sync_core.h
+++ b/arch/x86/include/asm/sync_core.h
@@ -8,7 +8,7 @@
 #include <asm/special_insns.h>
 
 #ifdef CONFIG_X86_32
-static inline void iret_to_self(void)
+static __always_inline void iret_to_self(void)
 {
 	asm volatile (
 		"pushfl\n\t"
@@ -19,7 +19,7 @@ static inline void iret_to_self(void)
 		: ASM_CALL_CONSTRAINT : : "memory");
 }
 #else
-static inline void iret_to_self(void)
+static __always_inline void iret_to_self(void)
 {
 	unsigned int tmp;
 
@@ -55,7 +55,7 @@ static inline void iret_to_self(void)
  * Like all of Linux's memory ordering operations, this is a
  * compiler barrier as well.
  */
-static inline void sync_core(void)
+static __always_inline void sync_core(void)
 {
 	/*
 	 * The SERIALIZE instruction is the most straightforward way to
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -172,6 +172,15 @@ void arch_static_call_transform(void *si
 }
 EXPORT_SYMBOL_GPL(arch_static_call_transform);
 
+noinstr void __static_call_update_early(void *tramp, void *func)
+{
+	BUG_ON(system_state != SYSTEM_BOOTING);
+	BUG_ON(!early_boot_irqs_disabled);
+	BUG_ON(static_call_initialized);
+	__text_gen_insn(tramp, JMP32_INSN_OPCODE, tramp, func, JMP32_INSN_SIZE);
+	sync_core();
+}
+
 #ifdef CONFIG_RETHUNK
 /*
  * This is called by apply_returns() to fix up static call trampolines,
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -204,28 +204,43 @@ void ftrace_likely_update(struct ftrace_
 
 #endif /* __KERNEL__ */
 
+/**
+ * offset_to_ptr - convert a relative memory offset to an absolute pointer
+ * @off:	the address of the 32-bit offset value
+ */
+static inline void *offset_to_ptr(const int *off)
+{
+	return (void *)((unsigned long)off + *off);
+}
+
+#endif /* __ASSEMBLY__ */
+
+#ifdef CONFIG_64BIT
+#define ARCH_SEL(a,b) a
+#else
+#define ARCH_SEL(a,b) b
+#endif
+
 /*
  * Force the compiler to emit 'sym' as a symbol, so that we can reference
  * it from inline assembler. Necessary in case 'sym' could be inlined
  * otherwise, or eliminated entirely due to lack of references that are
  * visible to the compiler.
  */
-#define ___ADDRESSABLE(sym, __attrs) \
-	static void * __used __attrs \
+#define ___ADDRESSABLE(sym, __attrs)						\
+	static void * __used __attrs						\
 		__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)&sym;
+
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
 
-/**
- * offset_to_ptr - convert a relative memory offset to an absolute pointer
- * @off:	the address of the 32-bit offset value
- */
-static inline void *offset_to_ptr(const int *off)
-{
-	return (void *)((unsigned long)off + *off);
-}
+#define __ADDRESSABLE_ASM(sym)						\
+	.pushsection .discard.addressable,"aw";				\
+	.align ARCH_SEL(8,4);						\
+	ARCH_SEL(.quad, .long) __stringify(sym);			\
+	.popsection;
 
-#endif /* __ASSEMBLY__ */
+#define __ADDRESSABLE_ASM_STR(sym) __stringify(__ADDRESSABLE_ASM(sym))
 
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -138,6 +138,7 @@
 #ifdef CONFIG_HAVE_STATIC_CALL
 #include <asm/static_call.h>
 
+extern int static_call_initialized;
 /*
  * Either @site or @tramp can be NULL.
  */
--- a/kernel/static_call_inline.c
+++ b/kernel/static_call_inline.c
@@ -15,7 +15,7 @@ extern struct static_call_site __start_s
 extern struct static_call_tramp_key __start_static_call_tramp_key[],
 				    __stop_static_call_tramp_key[];
 
-static int static_call_initialized;
+int static_call_initialized;
 
 /*
  * Must be called before early_initcall() to be effective.


