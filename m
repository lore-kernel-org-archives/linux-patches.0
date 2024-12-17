Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071891F37BE;
	Tue, 17 Dec 2024 17:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455904; cv=none; b=JNCABpRn7/Ed4Ao14DhZGw0APixgN0GxiDS6TYnkOR/QILiPUK1hIu6pMpBqFVrf/hvknlnLalIQlyvlZvQsjyv7XM8PLyGkfTSOPLFNWpI/QwOhHSCs84yrvaj+9SJ8TPkvOVbmctZtkly0bQ6QvbsIrlLe1Mr63TYyBXl1cIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455904; c=relaxed/simple;
	bh=IHh/oLeES8T/bK3A2LsJqoEiY2prXuIOUidSRYFuqaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8On3x2iSUb7CFQVhns0UYUwCRQH5x3kVndupcVWj1EpRLNsOX53PkXoZj+2ET4OBiVKGNbaq5aIAtUYFdIguiN+vxUSGTxFNCzsUsS1wMn/PJ6QkcgNaGuVyIWbiGDAOYa9RoG/DKfi5hHx4tEKnIOItq96XCG95xazVrILccU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrgap2GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrgap2GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F346C4CED3;
	Tue, 17 Dec 2024 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455903;
	bh=IHh/oLeES8T/bK3A2LsJqoEiY2prXuIOUidSRYFuqaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrgap2GUCUEmcLn9Hqapb72RxmlRXF98JYR8tILwDl+GU9xVPeq4G8lyQpxtIu/th
	 Yu+oT4pW2M2WS7xU7lXpbN31E1lAyi7hFLfU8s7JeC/XYrznydL8vIkkHXxeq+IA4T
	 G9MuQQ2UJnDwz3H+iD9RPyrL9X+O10r0LZIZbnwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 6.1 71/76] x86/static-call: provide a way to do very early static-call updates
Date: Tue, 17 Dec 2024 18:07:51 +0100
Message-ID: <20241217170529.443343190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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
@@ -170,6 +170,15 @@ void arch_static_call_transform(void *si
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
@@ -205,28 +205,43 @@ void ftrace_likely_update(struct ftrace_
 
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
 
+extern bool static_call_initialized;
 /*
  * Either @site or @tramp can be NULL.
  */
--- a/kernel/static_call_inline.c
+++ b/kernel/static_call_inline.c
@@ -15,7 +15,7 @@ extern struct static_call_site __start_s
 extern struct static_call_tramp_key __start_static_call_tramp_key[],
 				    __stop_static_call_tramp_key[];
 
-static bool static_call_initialized;
+bool static_call_initialized;
 
 /* mutex to protect key modules/sites */
 static DEFINE_MUTEX(static_call_mutex);


