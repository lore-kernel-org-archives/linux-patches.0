Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017EB2528FC;
	Mon, 12 May 2025 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072327; cv=none; b=iTYp3srdWQMlO87XM/Dk3P6T1keSb5SW5xij8Ti+Wq3gx/VhXwQo76uFVfTr+SA8mzhL+J7Z1ZNH7KapxygDSpC7MX5Chb5K5VKDGmLDkMmKrqyn40CDei5cpQqOVEifYISETyNI8At/sk50mjCPVBijIOds2O34vNhJk8ywXdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072327; c=relaxed/simple;
	bh=uskCj52PTWBW2WDFEAQof/cU9VcGI94klYZMCj7QFFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk73swUduxLG/hbuY7QhwaHbTOfD99HyPDVcX046f/ej8Hfggpxkc0EshXWPp4N5RMDSenVSZ2KrIwqK5eVh/OF7AScrxLGKJZ0KeLVAmJRMQEANXbP82ZavrrnIZjFuy+Cxzch7odEhXpByYf21vMCLEw00tGowNfAqh8niYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnFpDckd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnFpDckd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08350C4CEE7;
	Mon, 12 May 2025 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072326;
	bh=uskCj52PTWBW2WDFEAQof/cU9VcGI94klYZMCj7QFFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnFpDckd6ahdYZy9/ZeATYpMH9D6/ZtBGy/zKzHljcjAEZyjp+WCEHNllZguPGyRE
	 trDdbS88PO/JRw0dltZcWtu7JlJyNylhaR2be5vuIk8ky9m624Q7tOovnrjwkV6+zf
	 PhvvtKPFRXxNQy3qKx5z/4Y6JY26eMu67pRg29dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.14 196/197] x86/its: Use dynamic thunks for indirect branches
Date: Mon, 12 May 2025 19:40:46 +0200
Message-ID: <20250512172052.397970761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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

  [ pawan: CONFIG_EXECMEM_ROX is not supported on backport kernel, made
	   adjustments to set memory to RW and ROX ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/alternative.h |   10 ++
 arch/x86/kernel/alternative.c      |  129 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/module.c           |    6 +
 include/linux/execmem.h            |    3 
 include/linux/module.h             |    5 +
 6 files changed, 151 insertions(+), 3 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2768,6 +2768,7 @@ config MITIGATION_ITS
 	bool "Enable Indirect Target Selection mitigation"
 	depends on CPU_SUP_INTEL && X86_64
 	depends on MITIGATION_RETPOLINE && MITIGATION_RETHUNK
+	select EXECMEM
 	default y
 	help
 	  Enable Indirect Target Selection (ITS) mitigation. ITS is a bug in
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -125,6 +125,16 @@ static __always_inline int x86_call_dept
 }
 #endif
 
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
 #if defined(CONFIG_MITIGATION_RETHUNK) && defined(CONFIG_OBJTOOL)
 extern bool cpu_wants_rethunk(void);
 extern bool cpu_wants_rethunk_at(void *addr);
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -18,6 +18,7 @@
 #include <linux/mmu_context.h>
 #include <linux/bsearch.h>
 #include <linux/sync_core.h>
+#include <linux/execmem.h>
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
@@ -32,6 +33,7 @@
 #include <asm/asm-prototypes.h>
 #include <asm/cfi.h>
 #include <asm/ibt.h>
+#include <asm/set_memory.h>
 
 int __read_mostly alternatives_patched;
 
@@ -125,6 +127,123 @@ const unsigned char * const x86_nops[ASM
 #endif
 };
 
+#ifdef CONFIG_MITIGATION_ITS
+
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
+	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
+		return;
+
+	WARN_ON_ONCE(its_mod != mod);
+
+	its_mod = NULL;
+	its_page = NULL;
+	mutex_unlock(&text_mutex);
+
+	for (int i = 0; i < mod->its_num_pages; i++) {
+		void *page = mod->its_page_array[i];
+		set_memory_rox((unsigned long)page, 1);
+	}
+}
+
+void its_free_mod(struct module *mod)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
+		return;
+
+	for (int i = 0; i < mod->its_num_pages; i++) {
+		void *page = mod->its_page_array[i];
+		execmem_free(page);
+	}
+	kfree(mod->its_page_array);
+}
+
+static void *its_alloc(void)
+{
+	void *page __free(execmem) = execmem_alloc(EXECMEM_MODULE_TEXT, PAGE_SIZE);
+
+	if (!page)
+		return NULL;
+
+	if (its_mod) {
+		void *tmp = krealloc(its_mod->its_page_array,
+				     (its_mod->its_num_pages+1) * sizeof(void *),
+				     GFP_KERNEL);
+		if (!tmp)
+			return NULL;
+
+		its_mod->its_page_array = tmp;
+		its_mod->its_page_array[its_mod->its_num_pages++] = page;
+	}
+
+	return no_free_ptr(page);
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
+	set_memory_rox((unsigned long)its_page, 1);
+
+	return thunk;
+}
+
+#endif
+
 /*
  * Nomenclature for variable names to simplify and clarify this code and ease
  * any potential staring at it:
@@ -646,9 +765,13 @@ static int emit_call_track_retpoline(voi
 #ifdef CONFIG_MITIGATION_ITS
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
@@ -252,6 +252,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 			ibt_endbr = s;
 	}
 
+	its_init_mod(me);
+
 	if (retpolines || cfi) {
 		void *rseg = NULL, *cseg = NULL;
 		unsigned int rsize = 0, csize = 0;
@@ -272,6 +274,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 		void *rseg = (void *)retpolines->sh_addr;
 		apply_retpolines(rseg, rseg + retpolines->sh_size, me);
 	}
+
+	its_fini_mod(me);
+
 	if (returns) {
 		void *rseg = (void *)returns->sh_addr;
 		apply_returns(rseg, rseg + returns->sh_size, me);
@@ -335,4 +340,5 @@ int module_post_finalize(const Elf_Ehdr
 void module_arch_cleanup(struct module *mod)
 {
 	alternatives_smp_module_del(mod);
+	its_free_mod(mod);
 }
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/moduleloader.h>
+#include <linux/cleanup.h>
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
 		!defined(CONFIG_KASAN_VMALLOC)
@@ -139,6 +140,8 @@ void *execmem_alloc(enum execmem_type ty
  */
 void execmem_free(void *ptr);
 
+DEFINE_FREE(execmem, void *, if (_T) execmem_free(_T));
+
 #ifdef CONFIG_MMU
 /**
  * execmem_vmap - create virtual mapping for EXECMEM_MODULE_DATA memory
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -587,6 +587,11 @@ struct module {
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


