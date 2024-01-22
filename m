Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1453984D;
	Tue, 23 Jan 2024 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974035; cv=none; b=hZX4jjDFS54y/EZT4/bC2BXBic3Gn/xaN2LY4+H7+wRcGqPWC1/X0ivoW9eYV2dZTTAFB7KNz1ldPWN8va20jbrvTfeq75RDYUyAP6Ej2BWLDtorTsJy4FdwKZFXqjErDlSVQLqXbUVGh4AzFC/5BHC282rEPEJHQE5M8kxo8P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974035; c=relaxed/simple;
	bh=bgIZxB8l9ckA99/yf8xsQLcThR9/MPG6+jc7BKBHsVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMJd5PbjMXNs6s/ah2uI27ueZZV3W9dwYrXMTrHzaumq9i/QL8imbW3lRUFHjg5CgLXAqt1Ieiw9/3mJEKkuhaDkgBD/23Mkc8Av9WDA3+mBTNchlYAYrgTM5EhqloeGi9plHJxH8Dk/MCMUU0hi1wb3UjTPWzIijjQnfTNOObs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9RuZJAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9RuZJAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C683BC433C7;
	Tue, 23 Jan 2024 01:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974034;
	bh=bgIZxB8l9ckA99/yf8xsQLcThR9/MPG6+jc7BKBHsVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9RuZJAskereveZbple3BxNhvwx8r/d7fFzy/fTzO56kYtvBlMnzW+dyUnB+B3DDY
	 6OHmtk6jXlbay3A8dsEIWUScvtwchmKskIq1f4pm69URfZi2/aO0bM7LwOYKnmqjHg
	 fc14sYUMUuEkG7AeLr6GtwwAeBbHa6ZOltOClqsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Niethe <jniethe5@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/583] KVM: PPC: Book3S HV: Introduce low level MSR accessor
Date: Mon, 22 Jan 2024 15:51:02 -0800
Message-ID: <20240122235812.584220979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit 6de2e837babb411cfb3cdb570581c3a65576ddaf ]

kvmppc_get_msr() and kvmppc_set_msr_fast() serve as accessors for the
MSR. However because the MSR is kept in the shared regs they include a
conditional check for kvmppc_shared_big_endian() and endian conversion.

Within the Book3S HV specific code there are direct reads and writes of
shregs::msr. In preparation for Nested APIv2 these accesses need to be
replaced with accessor functions so it is possible to extend their
behavior. However, using the kvmppc_get_msr() and kvmppc_set_msr_fast()
functions is undesirable because it would introduce a conditional branch
and endian conversion that is not currently present.

kvmppc_set_msr_hv() already exists, it is used for the
kvmppc_ops::set_msr callback.

Introduce a low level accessor __kvmppc_{s,g}et_msr_hv() that simply
gets and sets shregs::msr. This will be extend for Nested APIv2 support.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230914030600.16993-8-jniethe5@gmail.com
Stable-dep-of: ecd10702baae ("KVM: PPC: Book3S HV: Handle pending exceptions on guest entry with MSR_EE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c  |  5 ++--
 arch/powerpc/kvm/book3s_hv.c         | 34 ++++++++++++++--------------
 arch/powerpc/kvm/book3s_hv.h         | 10 ++++++++
 arch/powerpc/kvm/book3s_hv_builtin.c |  5 ++--
 4 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index efd0ebf70a5e..fdfc2a62dd67 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -28,6 +28,7 @@
 #include <asm/pte-walk.h>
 
 #include "book3s.h"
+#include "book3s_hv.h"
 #include "trace_hv.h"
 
 //#define DEBUG_RESIZE_HPT	1
@@ -347,7 +348,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	unsigned long v, orig_v, gr;
 	__be64 *hptep;
 	long int index;
-	int virtmode = vcpu->arch.shregs.msr & (data ? MSR_DR : MSR_IR);
+	int virtmode = __kvmppc_get_msr_hv(vcpu) & (data ? MSR_DR : MSR_IR);
 
 	if (kvm_is_radix(vcpu->kvm))
 		return kvmppc_mmu_radix_xlate(vcpu, eaddr, gpte, data, iswrite);
@@ -385,7 +386,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 	/* Get PP bits and key for permission check */
 	pp = gr & (HPTE_R_PP0 | HPTE_R_PP);
-	key = (vcpu->arch.shregs.msr & MSR_PR) ? SLB_VSID_KP : SLB_VSID_KS;
+	key = (__kvmppc_get_msr_hv(vcpu) & MSR_PR) ? SLB_VSID_KP : SLB_VSID_KS;
 	key &= slb_v;
 
 	/* Calculate permissions */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7fa7fcebe8da..11bc5aaea01f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1370,7 +1370,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
  */
 static void kvmppc_cede(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.shregs.msr |= MSR_EE;
+	__kvmppc_set_msr_hv(vcpu, __kvmppc_get_msr_hv(vcpu) | MSR_EE);
 	vcpu->arch.ceded = 1;
 	smp_mb();
 	if (vcpu->arch.prodded) {
@@ -1585,7 +1585,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	 * That can happen due to a bug, or due to a machine check
 	 * occurring at just the wrong time.
 	 */
-	if (vcpu->arch.shregs.msr & MSR_HV) {
+	if (__kvmppc_get_msr_hv(vcpu) & MSR_HV) {
 		printk(KERN_EMERG "KVM trap in HV mode!\n");
 		printk(KERN_EMERG "trap=0x%x | pc=0x%lx | msr=0x%llx\n",
 			vcpu->arch.trap, kvmppc_get_pc(vcpu),
@@ -1636,7 +1636,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		 * so that it knows that the machine check occurred.
 		 */
 		if (!vcpu->kvm->arch.fwnmi_enabled) {
-			ulong flags = (vcpu->arch.shregs.msr & 0x083c0000) |
+			ulong flags = (__kvmppc_get_msr_hv(vcpu) & 0x083c0000) |
 					(kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 			kvmppc_core_queue_machine_check(vcpu, flags);
 			r = RESUME_GUEST;
@@ -1666,7 +1666,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		 * as a result of a hypervisor emulation interrupt
 		 * (e40) getting turned into a 700 by BML RTAS.
 		 */
-		flags = (vcpu->arch.shregs.msr & 0x1f0000ull) |
+		flags = (__kvmppc_get_msr_hv(vcpu) & 0x1f0000ull) |
 			(kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 		kvmppc_core_queue_program(vcpu, flags);
 		r = RESUME_GUEST;
@@ -1676,7 +1676,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	{
 		int i;
 
-		if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
+		if (unlikely(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 			/*
 			 * Guest userspace executed sc 1. This can only be
 			 * reached by the P9 path because the old path
@@ -1754,7 +1754,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			break;
 		}
 
-		if (!(vcpu->arch.shregs.msr & MSR_DR))
+		if (!(__kvmppc_get_msr_hv(vcpu) & MSR_DR))
 			vsid = vcpu->kvm->arch.vrma_slb_v;
 		else
 			vsid = vcpu->arch.fault_gpa;
@@ -1778,7 +1778,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		long err;
 
 		vcpu->arch.fault_dar = kvmppc_get_pc(vcpu);
-		vcpu->arch.fault_dsisr = vcpu->arch.shregs.msr &
+		vcpu->arch.fault_dsisr = __kvmppc_get_msr_hv(vcpu) &
 			DSISR_SRR1_MATCH_64S;
 		if (kvm_is_radix(vcpu->kvm) || !cpu_has_feature(CPU_FTR_ARCH_300)) {
 			/*
@@ -1787,7 +1787,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			 * hash fault handling below is v3 only (it uses ASDR
 			 * via fault_gpa).
 			 */
-			if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
+			if (__kvmppc_get_msr_hv(vcpu) & HSRR1_HISI_WRITE)
 				vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
 			r = RESUME_PAGE_FAULT;
 			break;
@@ -1801,7 +1801,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			break;
 		}
 
-		if (!(vcpu->arch.shregs.msr & MSR_IR))
+		if (!(__kvmppc_get_msr_hv(vcpu) & MSR_IR))
 			vsid = vcpu->kvm->arch.vrma_slb_v;
 		else
 			vsid = vcpu->arch.fault_gpa;
@@ -1891,7 +1891,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		kvmppc_dump_regs(vcpu);
 		printk(KERN_EMERG "trap=0x%x | pc=0x%lx | msr=0x%llx\n",
 			vcpu->arch.trap, kvmppc_get_pc(vcpu),
-			vcpu->arch.shregs.msr);
+			__kvmppc_get_msr_hv(vcpu));
 		run->hw.hardware_exit_reason = vcpu->arch.trap;
 		r = RESUME_HOST;
 		break;
@@ -1915,11 +1915,11 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	 * That can happen due to a bug, or due to a machine check
 	 * occurring at just the wrong time.
 	 */
-	if (vcpu->arch.shregs.msr & MSR_HV) {
+	if (__kvmppc_get_msr_hv(vcpu) & MSR_HV) {
 		pr_emerg("KVM trap in HV mode while nested!\n");
 		pr_emerg("trap=0x%x | pc=0x%lx | msr=0x%llx\n",
 			 vcpu->arch.trap, kvmppc_get_pc(vcpu),
-			 vcpu->arch.shregs.msr);
+			 __kvmppc_get_msr_hv(vcpu));
 		kvmppc_dump_regs(vcpu);
 		return RESUME_HOST;
 	}
@@ -1976,7 +1976,7 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		vcpu->arch.fault_dar = kvmppc_get_pc(vcpu);
 		vcpu->arch.fault_dsisr = kvmppc_get_msr(vcpu) &
 					 DSISR_SRR1_MATCH_64S;
-		if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
+		if (__kvmppc_get_msr_hv(vcpu) & HSRR1_HISI_WRITE)
 			vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
 		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = kvmhv_nested_page_fault(vcpu);
@@ -2935,7 +2935,7 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
 	spin_lock_init(&vcpu->arch.tbacct_lock);
 	vcpu->arch.busy_preempt = TB_NIL;
-	vcpu->arch.shregs.msr = MSR_ME;
+	__kvmppc_set_msr_hv(vcpu, MSR_ME);
 	vcpu->arch.intr_msr = MSR_SF | MSR_ME;
 
 	/*
@@ -4184,7 +4184,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		__this_cpu_write(cpu_in_guest, NULL);
 
 		if (trap == BOOK3S_INTERRUPT_SYSCALL &&
-		    !(vcpu->arch.shregs.msr & MSR_PR)) {
+		    !(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 			unsigned long req = kvmppc_get_gpr(vcpu, 3);
 
 			/*
@@ -4663,7 +4663,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
-		if (vcpu->arch.shregs.msr & MSR_EE) {
+		if (__kvmppc_get_msr_hv(vcpu) & MSR_EE) {
 			if (xive_interrupt_pending(vcpu))
 				kvmppc_inject_interrupt_hv(vcpu,
 						BOOK3S_INTERRUPT_EXTERNAL, 0);
@@ -4876,7 +4876,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		if (run->exit_reason == KVM_EXIT_PAPR_HCALL) {
 			accumulate_time(vcpu, &vcpu->arch.hcall);
 
-			if (WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_PR)) {
+			if (WARN_ON_ONCE(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 				/*
 				 * These should have been caught reflected
 				 * into the guest by now. Final sanity check:
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index acd9a7a95bbf..95241764dfb4 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -51,6 +51,16 @@ void accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next);
 #define end_timing(vcpu) do {} while (0)
 #endif
 
+static inline void __kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 val)
+{
+	vcpu->arch.shregs.msr = val;
+}
+
+static inline u64 __kvmppc_get_msr_hv(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.shregs.msr;
+}
+
 #define KVMPPC_BOOK3S_HV_VCPU_ACCESSOR_SET(reg, size)			\
 static inline void kvmppc_set_##reg ##_hv(struct kvm_vcpu *vcpu, u##size val)	\
 {									\
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 0f5b021fa559..663f5222f3d0 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -32,6 +32,7 @@
 
 #include "book3s_xics.h"
 #include "book3s_xive.h"
+#include "book3s_hv.h"
 
 /*
  * Hash page table alignment on newer cpus(CPU_FTR_ARCH_206)
@@ -510,7 +511,7 @@ void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 	 */
 	if ((msr & MSR_TS_MASK) == MSR_TS_MASK)
 		msr &= ~MSR_TS_MASK;
-	vcpu->arch.shregs.msr = msr;
+	__kvmppc_set_msr_hv(vcpu, msr);
 	kvmppc_end_cede(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvmppc_set_msr_hv);
@@ -548,7 +549,7 @@ static void inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
 	kvmppc_set_srr0(vcpu, pc);
 	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
 	kvmppc_set_pc(vcpu, new_pc);
-	vcpu->arch.shregs.msr = new_msr;
+	__kvmppc_set_msr_hv(vcpu, new_msr);
 }
 
 void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
-- 
2.43.0



