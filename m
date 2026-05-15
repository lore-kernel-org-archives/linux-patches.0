Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC59F3F8713;
	Fri, 15 May 2026 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862201; cv=none; b=ax2C5w4InpIY/qDgeWFAGLBEDVn1ue1aUIIBjW/IUNOkxeabDH6eHjqP2Km3IsatZX/skW7n+jhy8nSlOrJXjI/yHZQxsN16VdOA82w80JwQSSjIrBTLMIMSVvbtq8EOscvXdY3001OorRmWZjppZdPSU8jwkze7CExd0XUc2Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862201; c=relaxed/simple;
	bh=pNiYf46NeCM0keVmYXm+u879sMZulyeinSiaMOfghi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhEWLJlIP1JhBvutnUSPOyinrO4UjGbCnQXlw0za+X9hx9yRRtWetWsvo1XCT0ab+nhA/9gzC3J26RVvKrjJtI/1YZhN+AER/3rKRMefH0YuN3mqehBiWCsW6ybHky1A7WwM9IdAGGArsxvYzxfWdZYy7qC9azhLWyKnlLaucjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kK78ZvXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kK78ZvXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629EBC2BCB0;
	Fri, 15 May 2026 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862201;
	bh=pNiYf46NeCM0keVmYXm+u879sMZulyeinSiaMOfghi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kK78ZvXimdZkFZk6l9IFRhdGgdxfcY7Jj52pYgCwayES2slqnnCMS58MU3YqSEi+P
	 V5gZnXd2RaVB1VNXFxf1R26vCTDqdvkABpPNUbGnpb6NPcGKPE6qFNupY5tXU9Ayhe
	 t4EkZw8RXh5KrwSD9SmB7ohqwCHGjnmnNUvQlP2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 146/188] LoongArch: KVM: Compile switch.S directly into the kernel
Date: Fri, 15 May 2026 17:49:23 +0200
Message-ID: <20260515154700.490807166@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianglai Li <lixianglai@loongson.cn>

commit 5203012fa6045aac4b69d4e7c212e16dcf38ef10 upstream.

If we directly compile the switch.S file into the kernel, the address of
the kvm_exc_entry function will definitely be within the DMW memory area.
Therefore, we will no longer need to perform a copy relocation of the
kvm_exc_entry.

So this patch compiles switch.S directly into the kernel, and then remove
the copy relocation execution logic for the kvm_exc_entry function.

Cc: stable@vger.kernel.org
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kbuild                       |    2 -
 arch/loongarch/include/asm/asm-prototypes.h |   20 ++++++++++++++++
 arch/loongarch/include/asm/kvm_host.h       |    3 --
 arch/loongarch/kvm/Makefile                 |    3 +-
 arch/loongarch/kvm/main.c                   |   35 ++--------------------------
 arch/loongarch/kvm/switch.S                 |   20 ++++++++++++----
 6 files changed, 41 insertions(+), 42 deletions(-)

--- a/arch/loongarch/Kbuild
+++ b/arch/loongarch/Kbuild
@@ -3,7 +3,7 @@ obj-y += mm/
 obj-y += net/
 obj-y += vdso/
 
-obj-$(CONFIG_KVM) += kvm/
+obj-$(subst m,y,$(CONFIG_KVM)) += kvm/
 
 # for cleaning
 subdir- += boot
--- a/arch/loongarch/include/asm/asm-prototypes.h
+++ b/arch/loongarch/include/asm/asm-prototypes.h
@@ -20,3 +20,23 @@ asmlinkage void noinstr __no_stack_prote
 								    struct pt_regs *regs,
 								    int (*fn)(void *),
 								    void *fn_arg);
+
+struct kvm_run;
+struct kvm_vcpu;
+struct loongarch_fpu;
+
+void kvm_exc_entry(void);
+int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
+
+void kvm_save_fpu(struct loongarch_fpu *fpu);
+void kvm_restore_fpu(struct loongarch_fpu *fpu);
+
+#ifdef CONFIG_CPU_HAS_LSX
+void kvm_save_lsx(struct loongarch_fpu *fpu);
+void kvm_restore_lsx(struct loongarch_fpu *fpu);
+#endif
+
+#ifdef CONFIG_CPU_HAS_LASX
+void kvm_save_lasx(struct loongarch_fpu *fpu);
+void kvm_restore_lasx(struct loongarch_fpu *fpu);
+#endif
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -85,7 +85,6 @@ struct kvm_context {
 struct kvm_world_switch {
 	int (*exc_entry)(void);
 	int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
-	unsigned long page_order;
 };
 
 #define MAX_PGTABLE_LEVELS	4
@@ -339,8 +338,6 @@ void kvm_exc_entry(void);
 int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
 
 extern unsigned long vpid_mask;
-extern const unsigned long kvm_exception_size;
-extern const unsigned long kvm_enter_guest_size;
 extern struct kvm_world_switch *kvm_loongarch_ops;
 
 #define SW_GCSR		(1 << 0)
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -7,11 +7,12 @@ include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
 
+obj-y += switch.o
+
 kvm-y += exit.o
 kvm-y += interrupt.o
 kvm-y += main.o
 kvm-y += mmu.o
-kvm-y += switch.o
 kvm-y += timer.o
 kvm-y += tlb.o
 kvm-y += vcpu.o
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -340,8 +340,7 @@ void kvm_arch_disable_virtualization_cpu
 
 static int kvm_loongarch_env_init(void)
 {
-	int cpu, order, ret;
-	void *addr;
+	int cpu, ret;
 	struct kvm_context *context;
 
 	vmcs = alloc_percpu(struct kvm_context);
@@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
 		return -ENOMEM;
 	}
 
-	/*
-	 * PGD register is shared between root kernel and kvm hypervisor.
-	 * So world switch entry should be in DMW area rather than TLB area
-	 * to avoid page fault reenter.
-	 *
-	 * In future if hardware pagetable walking is supported, we won't
-	 * need to copy world switch code to DMW area.
-	 */
-	order = get_order(kvm_exception_size + kvm_enter_guest_size);
-	addr = (void *)__get_free_pages(GFP_KERNEL, order);
-	if (!addr) {
-		free_percpu(vmcs);
-		vmcs = NULL;
-		kfree(kvm_loongarch_ops);
-		kvm_loongarch_ops = NULL;
-		return -ENOMEM;
-	}
-
-	memcpy(addr, kvm_exc_entry, kvm_exception_size);
-	memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_guest_size);
-	flush_icache_range((unsigned long)addr, (unsigned long)addr + kvm_exception_size + kvm_enter_guest_size);
-	kvm_loongarch_ops->exc_entry = addr;
-	kvm_loongarch_ops->enter_guest = addr + kvm_exception_size;
-	kvm_loongarch_ops->page_order = order;
+	kvm_loongarch_ops->exc_entry = (void *)kvm_exc_entry;
+	kvm_loongarch_ops->enter_guest = (void *)kvm_enter_guest;
 
 	vpid_mask = read_csr_gstat();
 	vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
@@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
 
 static void kvm_loongarch_env_exit(void)
 {
-	unsigned long addr;
-
 	if (vmcs)
 		free_percpu(vmcs);
 
 	if (kvm_loongarch_ops) {
-		if (kvm_loongarch_ops->exc_entry) {
-			addr = (unsigned long)kvm_loongarch_ops->exc_entry;
-			free_pages(addr, kvm_loongarch_ops->page_order);
-		}
 		kfree(kvm_loongarch_ops);
 	}
 
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -4,9 +4,11 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/kvm_types.h>
 #include <asm/asm.h>
 #include <asm/asmmacro.h>
 #include <asm/loongarch.h>
+#include <asm/page.h>
 #include <asm/regdef.h>
 #include <asm/unwind_hints.h>
 
@@ -100,8 +102,13 @@
 	 *  -        is still in guest mode, such as pgd table/vmid registers etc,
 	 *  -        will fix with hw page walk enabled in future
 	 * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
+	 *
+	 * PGD register is shared between root kernel and kvm hypervisor.
+	 * So world switch entry should be in DMW area rather than TLB area
+	 * to avoid page fault re-enter.
 	 */
 	.text
+	.p2align PAGE_SHIFT
 	.cfi_sections	.debug_frame
 SYM_CODE_START(kvm_exc_entry)
 	UNWIND_HINT_END_OF_STACK
@@ -190,8 +197,8 @@ ret_to_host:
 	kvm_restore_host_gpr    a2
 	jr      ra
 
-SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
 SYM_CODE_END(kvm_exc_entry)
+EXPORT_SYMBOL_GPL(kvm_exc_entry)
 
 /*
  * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
@@ -215,8 +222,8 @@ SYM_FUNC_START(kvm_enter_guest)
 	/* Save kvm_vcpu to kscratch */
 	csrwr	a1, KVM_VCPU_KS
 	kvm_switch_to_guest
-SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
 SYM_FUNC_END(kvm_enter_guest)
+EXPORT_SYMBOL_GPL(kvm_enter_guest)
 
 SYM_FUNC_START(kvm_save_fpu)
 	fpu_save_csr	a0 t1
@@ -224,6 +231,7 @@ SYM_FUNC_START(kvm_save_fpu)
 	fpu_save_cc	a0 t1 t2
 	jr              ra
 SYM_FUNC_END(kvm_save_fpu)
+EXPORT_SYMBOL_GPL(kvm_save_fpu)
 
 SYM_FUNC_START(kvm_restore_fpu)
 	fpu_restore_double a0 t1
@@ -231,6 +239,7 @@ SYM_FUNC_START(kvm_restore_fpu)
 	fpu_restore_cc	   a0 t1 t2
 	jr                 ra
 SYM_FUNC_END(kvm_restore_fpu)
+EXPORT_SYMBOL_GPL(kvm_restore_fpu)
 
 #ifdef CONFIG_CPU_HAS_LSX
 SYM_FUNC_START(kvm_save_lsx)
@@ -239,6 +248,7 @@ SYM_FUNC_START(kvm_save_lsx)
 	lsx_save_data   a0 t1
 	jr              ra
 SYM_FUNC_END(kvm_save_lsx)
+EXPORT_SYMBOL_GPL(kvm_save_lsx)
 
 SYM_FUNC_START(kvm_restore_lsx)
 	lsx_restore_data a0 t1
@@ -246,6 +256,7 @@ SYM_FUNC_START(kvm_restore_lsx)
 	fpu_restore_csr  a0 t1 t2
 	jr               ra
 SYM_FUNC_END(kvm_restore_lsx)
+EXPORT_SYMBOL_GPL(kvm_restore_lsx)
 #endif
 
 #ifdef CONFIG_CPU_HAS_LASX
@@ -255,6 +266,7 @@ SYM_FUNC_START(kvm_save_lasx)
 	lasx_save_data  a0 t1
 	jr              ra
 SYM_FUNC_END(kvm_save_lasx)
+EXPORT_SYMBOL_GPL(kvm_save_lasx)
 
 SYM_FUNC_START(kvm_restore_lasx)
 	lasx_restore_data a0 t1
@@ -262,10 +274,8 @@ SYM_FUNC_START(kvm_restore_lasx)
 	fpu_restore_csr   a0 t1 t2
 	jr                ra
 SYM_FUNC_END(kvm_restore_lasx)
+EXPORT_SYMBOL_GPL(kvm_restore_lasx)
 #endif
-	.section ".rodata"
-SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
-SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
 
 #ifdef CONFIG_CPU_HAS_LBT
 STACK_FRAME_NON_STANDARD kvm_restore_fpu


