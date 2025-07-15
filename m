Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735852E9EC6;
	Tue, 15 Jul 2025 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587939; cv=none; b=DYOkXfU7yiQBhxJm+YMr5AtGtDdYxzOJxJ5kdHEHJfWXxA+LIHTm4YfrafeiCiQy/qV5+HkW8lE3MTRC+M8QGgMR6TXBkFBx7Y6cZQ9a3LU52IEZaY7xMfBHFEqr07s3L92B5j0yObIfV8rG8EYIyzNLsvufCc5591f2UdWXK4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587939; c=relaxed/simple;
	bh=51A3/pc5/XnA/LtQL6GMItecOMTDnjOhoEvNDIgE9tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYSOGdjeTS6NvJ7/Xk8I2WCmwt3Lx9xTmvyHPfSH8GV5GpHlTCPGOl0C1CwdWuOQDvyJsqUID+bnAk0cT+7QLJ8Yl9Eyx6gt1XPORmZFMv7bqM1+Vfu/zSTPQl+c17/JXebueCEJV43Cg9orrc7La6dXXja+q4L0LpSReTzJFp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMn1HVBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMn1HVBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E04C4CEE3;
	Tue, 15 Jul 2025 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587939;
	bh=51A3/pc5/XnA/LtQL6GMItecOMTDnjOhoEvNDIgE9tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMn1HVBuI1zf1mJLrT2ab0ghh9ny6ACkRfUwigcinULghFnrvTPcEnpzCZCac5SGm
	 37kxZ6/kq2Rq22egOwEv5YfykVgd1/HtImzgWXBjLcAfRS9VrlK1J3fwhSbFC6Y8+R
	 r2ycqPL6SI9kE6hYMXU8EoFMk48twJJcfZoNF2EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 168/208] x86/its: Use dynamic thunks for indirect branches
Date: Tue, 15 Jul 2025 15:14:37 +0200
Message-ID: <20250715130817.712727942@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 872df34d7c51a79523820ea6a14860398c639b87 upstream.

ITS mitigation moves the unsafe indirect branches to a safe thunk. This
could degrade the prediction accuracy as the source address of indirect
branches becomes same for different execution paths.

To improve the predictions, and hence the performance, assign a separate
thunk for each indirect callsite. This is also a defense-in-depth measure
to avoid indirect branches aliasing with each other.

As an example, 5000 dynamic thunks would utilize around 16 bits of the
address space, thereby gaining entropy. For a BTB that uses
32 bits for indexing, dynamic thunks could provide better prediction
accuracy over fixed thunks.

Have ITS thunks be variable sized and use EXECMEM_MODULE_TEXT such that
they are both more flexible (got to extend them later) and live in 2M TLBs,
just like kernel code, avoiding undue TLB pressure.

  [ pawan: CONFIG_EXECMEM and CONFIG_EXECMEM_ROX are not supported on
	   backport kernel, made changes to use module_alloc() and
	   set_memory_*() for dynamic thunks. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |   10 ++
 arch/x86/kernel/alternative.c      |  133 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/module.c           |    6 +
 include/linux/module.h             |    5 +
 4 files changed, 151 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -80,6 +80,16 @@ extern void apply_returns(s32 *start, s3
 
 struct module;
 
+#ifdef CONFIG_MITIGATION_ITS
+extern void its_init_mod(struct module *mod);
+extern void its_fini_mod(struct module *mod);
+extern void its_free_mod(struct module *mod);
+#else /* CONFIG_MITIGATION_ITS */
+static inline void its_init_mod(struct module *mod) { }
+static inline void its_fini_mod(struct module *mod) { }
+static inline void its_free_mod(struct module *mod) { }
+#endif
+
 #if defined(CONFIG_RETHUNK) && defined(CONFIG_STACK_VALIDATION)
 extern bool cpu_wants_rethunk(void);
 extern bool cpu_wants_rethunk_at(void *addr);
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -18,6 +18,7 @@
 #include <linux/mmu_context.h>
 #include <linux/bsearch.h>
 #include <linux/sync_core.h>
+#include <linux/moduleloader.h>
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
@@ -29,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/fixmap.h>
 #include <asm/asm-prototypes.h>
+#include <asm/set_memory.h>
 
 int __read_mostly alternatives_patched;
 
@@ -552,6 +554,127 @@ static int emit_indirect(int op, int reg
 
 #ifdef CONFIG_MITIGATION_ITS
 
+static struct module *its_mod;
+static void *its_page;
+static unsigned int its_offset;
+
+/* Initialize a thunk with the "jmp *reg; int3" instructions. */
+static void *its_init_thunk(void *thunk, int reg)
+{
+	u8 *bytes = thunk;
+	int i = 0;
+
+	if (reg >= 8) {
+		bytes[i++] = 0x41; /* REX.B prefix */
+		reg -= 8;
+	}
+	bytes[i++] = 0xff;
+	bytes[i++] = 0xe0 + reg; /* jmp *reg */
+	bytes[i++] = 0xcc;
+
+	return thunk;
+}
+
+void its_init_mod(struct module *mod)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
+		return;
+
+	mutex_lock(&text_mutex);
+	its_mod = mod;
+	its_page = NULL;
+}
+
+void its_fini_mod(struct module *mod)
+{
+	int i;
+
+	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
+		return;
+
+	WARN_ON_ONCE(its_mod != mod);
+
+	its_mod = NULL;
+	its_page = NULL;
+	mutex_unlock(&text_mutex);
+
+	for (i = 0; i < mod->its_num_pages; i++) {
+		void *page = mod->its_page_array[i];
+		set_memory_ro((unsigned long)page, 1);
+		set_memory_x((unsigned long)page, 1);
+	}
+}
+
+void its_free_mod(struct module *mod)
+{
+	int i;
+
+	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
+		return;
+
+	for (i = 0; i < mod->its_num_pages; i++) {
+		void *page = mod->its_page_array[i];
+		module_memfree(page);
+	}
+	kfree(mod->its_page_array);
+}
+
+static void *its_alloc(void)
+{
+	void *page = module_alloc(PAGE_SIZE);
+
+	if (!page)
+		return NULL;
+
+	if (its_mod) {
+		void *tmp = krealloc(its_mod->its_page_array,
+				     (its_mod->its_num_pages+1) * sizeof(void *),
+				     GFP_KERNEL);
+		if (!tmp) {
+			module_memfree(page);
+			return NULL;
+		}
+
+		its_mod->its_page_array = tmp;
+		its_mod->its_page_array[its_mod->its_num_pages++] = page;
+	}
+
+	return page;
+}
+
+static void *its_allocate_thunk(int reg)
+{
+	int size = 3 + (reg / 8);
+	void *thunk;
+
+	if (!its_page || (its_offset + size - 1) >= PAGE_SIZE) {
+		its_page = its_alloc();
+		if (!its_page) {
+			pr_err("ITS page allocation failed\n");
+			return NULL;
+		}
+		memset(its_page, INT3_INSN_OPCODE, PAGE_SIZE);
+		its_offset = 32;
+	}
+
+	/*
+	 * If the indirect branch instruction will be in the lower half
+	 * of a cacheline, then update the offset to reach the upper half.
+	 */
+	if ((its_offset + size - 1) % 64 < 32)
+		its_offset = ((its_offset - 1) | 0x3F) + 33;
+
+	thunk = its_page + its_offset;
+	its_offset += size;
+
+	set_memory_rw((unsigned long)its_page, 1);
+	thunk = its_init_thunk(thunk, reg);
+	set_memory_ro((unsigned long)its_page, 1);
+	set_memory_x((unsigned long)its_page, 1);
+
+	return thunk;
+}
+
 static int __emit_trampoline(void *addr, struct insn *insn, u8 *bytes,
 			     void *call_dest, void *jmp_dest)
 {
@@ -599,9 +722,13 @@ clang_jcc:
 
 static int emit_its_trampoline(void *addr, struct insn *insn, int reg, u8 *bytes)
 {
-	return __emit_trampoline(addr, insn, bytes,
-				 __x86_indirect_its_thunk_array[reg],
-				 __x86_indirect_its_thunk_array[reg]);
+	u8 *thunk = __x86_indirect_its_thunk_array[reg];
+	u8 *tmp = its_allocate_thunk(reg);
+
+	if (tmp)
+		thunk = tmp;
+
+	return __emit_trampoline(addr, insn, bytes, thunk, thunk);
 }
 
 /* Check if an indirect branch is at ITS-unsafe address */
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -274,10 +274,15 @@ int module_finalize(const Elf_Ehdr *hdr,
 			returns = s;
 	}
 
+	its_init_mod(me);
+
 	if (retpolines) {
 		void *rseg = (void *)retpolines->sh_addr;
 		apply_retpolines(rseg, rseg + retpolines->sh_size);
 	}
+
+	its_fini_mod(me);
+
 	if (returns) {
 		void *rseg = (void *)returns->sh_addr;
 		apply_returns(rseg, rseg + returns->sh_size);
@@ -313,4 +318,5 @@ int module_finalize(const Elf_Ehdr *hdr,
 void module_arch_cleanup(struct module *mod)
 {
 	alternatives_smp_module_del(mod);
+	its_free_mod(mod);
 }
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -524,6 +524,11 @@ struct module {
 	atomic_t refcnt;
 #endif
 
+#ifdef CONFIG_MITIGATION_ITS
+	int its_num_pages;
+	void **its_page_array;
+#endif
+
 #ifdef CONFIG_CONSTRUCTORS
 	/* Constructor functions. */
 	ctor_fn_t *ctors;


