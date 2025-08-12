Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38692949E0;
	Tue, 12 Aug 2025 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025314; cv=none; b=S1lBkt8elQE1raeZaqMMYHXijPViOXpwUpSzq0IC+oO6EnyyeInloGCNkp6QLi8KX8oJYnyIB9rkYCoV9ivbqruV1nEQ8CNAlbybnaTMC4+GERjS0rTm0Ij1L85ZZo/SShKnGfYZZul57ii8knUpJNusl7GAeTjrsK8KfBfTXf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025314; c=relaxed/simple;
	bh=UNKa+EJKPG2+YeVxPMFQLNWo17r9T4BWWY8Z6xGM0/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAqkEY7P4XRft+sEgdOkvLMyFdkiCZvjdcLcMiiVWtb8Feid60gSlbgnzFwFNmDdbwNsX32lkUPtrUmuq5+U9cWKuBb5On1UU9IWgQbZmqS5vGGY7YkJrjKkrZGI28n1CHDX6m22JdeGzyGYHCKtUeBGpsIwZU3NPFOLaYb4olM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhw04pYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhw04pYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6ADC4CEF0;
	Tue, 12 Aug 2025 19:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025314;
	bh=UNKa+EJKPG2+YeVxPMFQLNWo17r9T4BWWY8Z6xGM0/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhw04pYp6FT8kaJ2gNfOASviY/mwYuEdRGpj1h45WEqatVQuWFNYxESw53iXgp7PL
	 og38eSH1z2ypNjy24wkbCTto82fcGXg2T3t0SOGSSXz67zOXbkRB9mftCCRxih6Q5o
	 7VjD7P3ACYTl0spbFdLLKxkAKk3SO5ruyUKbb/Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.16 604/627] KVM: x86: Convert vcpu_run()s immediate exit param into a generic bitmap
Date: Tue, 12 Aug 2025 19:34:59 +0200
Message-ID: <20250812173454.854625933@linuxfoundation.org>
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

commit 2478b1b220c49d25cb1c3f061ec4f9b351d9a131 upstream.

Convert kvm_x86_ops.vcpu_run()'s "force_immediate_exit" boolean parameter
into an a generic bitmap so that similar "take action" information can be
passed to vendor code without creating a pile of boolean parameters.

This will allow dropping kvm_x86_ops.set_dr6() in favor of a new flag, and
will also allow for adding similar functionality for re-loading debugctl
in the active VMCS.

Opportunistically massage the TDX WARN and comment to prepare for adding
more run_flags, all of which are expected to be mutually exclusive with
TDX, i.e. should be WARNed on.

No functional change intended.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250610232010.162191-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    6 +++++-
 arch/x86/kvm/svm/svm.c          |    4 ++--
 arch/x86/kvm/vmx/main.c         |    6 +++---
 arch/x86/kvm/vmx/tdx.c          |   18 +++++++++---------
 arch/x86/kvm/vmx/vmx.c          |    3 ++-
 arch/x86/kvm/vmx/x86_ops.h      |    4 ++--
 arch/x86/kvm/x86.c              |   11 ++++++++---
 7 files changed, 31 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1680,6 +1680,10 @@ static inline u16 kvm_lapic_irq_dest_mod
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+enum kvm_x86_run_flags {
+	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+};
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1761,7 +1765,7 @@ struct kvm_x86_ops {
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
 	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
-						  bool force_immediate_exit);
+						  u64 run_flags);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4389,9 +4389,9 @@ static noinstr void svm_vcpu_enter_exit(
 	guest_state_exit_irqoff();
 }
 
-static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
-					  bool force_immediate_exit)
+static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -175,12 +175,12 @@ static int vt_vcpu_pre_run(struct kvm_vc
 	return vmx_vcpu_pre_run(vcpu);
 }
 
-static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
 	if (is_td_vcpu(vcpu))
-		return tdx_vcpu_run(vcpu, force_immediate_exit);
+		return tdx_vcpu_run(vcpu, run_flags);
 
-	return vmx_vcpu_run(vcpu, force_immediate_exit);
+	return vmx_vcpu_run(vcpu, run_flags);
 }
 
 static int vt_handle_exit(struct kvm_vcpu *vcpu,
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1025,20 +1025,20 @@ static void tdx_load_host_xsave_state(st
 				DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
 				DEBUGCTLMSR_FREEZE_IN_SMM)
 
-fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	struct vcpu_vt *vt = to_vt(vcpu);
 
 	/*
-	 * force_immediate_exit requires vCPU entering for events injection with
-	 * an immediately exit followed. But The TDX module doesn't guarantee
-	 * entry, it's already possible for KVM to _think_ it completely entry
-	 * to the guest without actually having done so.
-	 * Since KVM never needs to force an immediate exit for TDX, and can't
-	 * do direct injection, just warn on force_immediate_exit.
+	 * WARN if KVM wants to force an immediate exit, as the TDX module does
+	 * not guarantee entry into the guest, i.e. it's possible for KVM to
+	 * _think_ it completed entry to the guest and forced an immediate exit
+	 * without actually having done so.  Luckily, KVM never needs to force
+	 * an immediate exit for TDX (KVM can't do direct event injection, so
+	 * just WARN and continue on.
 	 */
-	WARN_ON_ONCE(force_immediate_exit);
+	WARN_ON_ONCE(run_flags);
 
 	/*
 	 * Wait until retry of SEPT-zap-related SEAMCALL completes before
@@ -1048,7 +1048,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu
 	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
 		return EXIT_FASTPATH_EXIT_HANDLED;
 
-	trace_kvm_entry(vcpu, force_immediate_exit);
+	trace_kvm_entry(vcpu, run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT);
 
 	if (pi_test_on(&vt->pi_desc)) {
 		apic->send_IPI_self(POSTED_INTR_VECTOR);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7323,8 +7323,9 @@ out:
 	guest_state_exit_irqoff();
 }
 
-fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
+	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -21,7 +21,7 @@ void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
 int vmx_vcpu_create(struct kvm_vcpu *vcpu);
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
-fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags);
 void vmx_vcpu_free(struct kvm_vcpu *vcpu);
 void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
@@ -133,7 +133,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcp
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
-fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10785,6 +10785,7 @@ static int vcpu_enter_guest(struct kvm_v
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
+	u64 run_flags;
 
 	bool req_immediate_exit = false;
 
@@ -11029,8 +11030,11 @@ static int vcpu_enter_guest(struct kvm_v
 		goto cancel_injection;
 	}
 
-	if (req_immediate_exit)
+	run_flags = 0;
+	if (req_immediate_exit) {
+		run_flags |= KVM_RUN_FORCE_IMMEDIATE_EXIT;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	}
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -11067,8 +11071,7 @@ static int vcpu_enter_guest(struct kvm_v
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu,
-						       req_immediate_exit);
+		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu, run_flags);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -11080,6 +11083,8 @@ static int vcpu_enter_guest(struct kvm_v
 			break;
 		}
 
+		run_flags = 0;
+
 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
 		++vcpu->stat.exits;
 	}


