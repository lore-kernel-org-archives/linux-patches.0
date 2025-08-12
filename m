Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239F51C1AAA;
	Tue, 12 Aug 2025 19:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025318; cv=none; b=f2c+8TfmNOpmrCoTstl6gh6gGmFVa1VHEgcb7FjAhoCJuXMVqdyAp9q1BWhlebK+eXWSfpobritn8vSTR3dykpGzFD2nEZp27q75/b/+SY88h9eMjFT3PfN2Tt3Q+31AoRisM5Ep+LFGvWCJkHtPgXSLIzrDr/WrvURD8HxFPPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025318; c=relaxed/simple;
	bh=XFvHuM+wfMiT3qN2HKoJvCS+1XaHH0nv5a2Fn9swdkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/RbXdXCCBK/23d9/rcK0UPKtLbSR9qh5s39lpZnWqHFAc1Ccksdef2yDgsoQ5lpCOg8U//QkfTyIUUbDhYq9gRgg84JSULvw8auxCw48XqdX+LhKaI5N3SbXy3C/yz+DO4x+ItRjpZyr8zyCbIJcWz5jyz20Jr+Jyc0rMUtsSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APkv3Sp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APkv3Sp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A967C4CEF0;
	Tue, 12 Aug 2025 19:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025317;
	bh=XFvHuM+wfMiT3qN2HKoJvCS+1XaHH0nv5a2Fn9swdkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APkv3Sp0ViPVX/RjKdFPhU7af7uCL+lkLV6zdigSlh6fdQ4yJcoc1h2sl3RaDa0+/
	 bPV8RKEgipUgFWQPiOEg7D7VyHr7v7eSr7a5U4fSVC5ZNx84t3EafnOR7G5FcIqyiS
	 kUU30SiimrEH4nuG5Cuu3GNbOpTSbaemCSWdgTgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.16 605/627] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag
Date: Tue, 12 Aug 2025 19:35:00 +0200
Message-ID: <20250812173454.891102768@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 80c64c7afea1da6a93ebe88d3d29d8a60377ef80 upstream.

Instruct vendor code to load the guest's DR6 into hardware via a new
KVM_RUN flag, and remove kvm_x86_ops.set_dr6(), whose sole purpose was to
load vcpu->arch.dr6 into hardware when DR6 can be read/written directly
by the guest.

Note, TDX already WARNs on any run_flag being set, i.e. will yell if KVM
thinks DR6 needs to be reloaded.  TDX vCPUs force KVM_DEBUGREG_AUTO_SWITCH
and never clear the flag, i.e. should never observe KVM_RUN_LOAD_GUEST_DR6.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250610232010.162191-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm-x86-ops.h |    1 -
 arch/x86/include/asm/kvm_host.h    |    2 +-
 arch/x86/kvm/svm/svm.c             |   12 +++++++-----
 arch/x86/kvm/vmx/main.c            |    9 ---------
 arch/x86/kvm/vmx/vmx.c             |    9 +++------
 arch/x86/kvm/x86.c                 |    2 +-
 6 files changed, 12 insertions(+), 23 deletions(-)

--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -49,7 +49,6 @@ KVM_X86_OP(set_idt)
 KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
-KVM_X86_OP(set_dr6)
 KVM_X86_OP(set_dr7)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1682,6 +1682,7 @@ static inline u16 kvm_lapic_irq_dest_mod
 
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
 };
 
 struct kvm_x86_ops {
@@ -1734,7 +1735,6 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
-	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4438,10 +4438,13 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
 
 	/*
-	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
-	 * of a #DB.
-	 */
-	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
+	 * Run with all-zero DR6 unless the guest can write DR6 freely, so that
+	 * KVM can get the exact cause of a #DB.  Note, loading guest DR6 from
+	 * KVM's snapshot is only necessary when DR accesses won't exit.
+	 */
+	if (unlikely(run_flags & KVM_RUN_LOAD_GUEST_DR6))
+		svm_set_dr6(vcpu, vcpu->arch.dr6);
+	else if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
 
 	clgi();
@@ -5252,7 +5255,6 @@ static struct kvm_x86_ops svm_x86_ops __
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
-	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -489,14 +489,6 @@ static void vt_set_gdt(struct kvm_vcpu *
 	vmx_set_gdt(vcpu, dt);
 }
 
-static void vt_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	if (is_td_vcpu(vcpu))
-		return;
-
-	vmx_set_dr6(vcpu, val);
-}
-
 static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	if (is_td_vcpu(vcpu))
@@ -943,7 +935,6 @@ struct kvm_x86_ops vt_x86_ops __initdata
 	.set_idt = vt_op(set_idt),
 	.get_gdt = vt_op(get_gdt),
 	.set_gdt = vt_op(set_gdt),
-	.set_dr6 = vt_op(set_dr6),
 	.set_dr7 = vt_op(set_dr7),
 	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
 	.cache_reg = vt_op(cache_reg),
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5606,12 +5606,6 @@ void vmx_sync_dirty_debug_regs(struct kv
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	lockdep_assert_irqs_disabled();
-	set_debugreg(vcpu->arch.dr6, 6);
-}
-
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
@@ -7370,6 +7364,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
+	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
+		set_debugreg(vcpu->arch.dr6, 6);
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11052,7 +11052,7 @@ static int vcpu_enter_guest(struct kvm_v
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
+			run_flags |= KVM_RUN_LOAD_GUEST_DR6;
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(DR7_FIXED_1, 7);
 	}


