Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67302101C9
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF83C433D2;
	Mon, 15 May 2023 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173066;
	bh=Fn7XZrxNZA4XDU0uM9REamtFXS7LYsjls0OiNJWP7H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIvq1nTDzMdef1v52Tv9H6IfLUEUP/1g6izLch1WtqX2PRm6Nf+kjTDFgOKwn6oss
	 kB1wX7bfLvcxqkrrPTmF/8JKdbUhI1gbEJ9YVXMR00TCbsqRIwepIkqyfmxgLINKDE
	 QsYyn97TeWlXu5L+Yz6ZfrEO437mgD3yO1D+UG6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 357/381] KVM: x86: do not report a vCPU as preempted outside instruction boundaries
Date: Mon, 15 May 2023 18:30:08 +0200
Message-Id: <20230515161753.014828080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

commit 6cd88243c7e03845a450795e134b488fc2afb736 upstream.

If a vCPU is outside guest mode and is scheduled out, it might be in the
process of making a memory access.  A problem occurs if another vCPU uses
the PV TLB flush feature during the period when the vCPU is scheduled
out, and a virtual address has already been translated but has not yet
been accessed, because this is equivalent to using a stale TLB entry.

To avoid this, only report a vCPU as preempted if sure that the guest
is at an instruction boundary.  A rescheduling request will be delivered
to the host physical CPU as an external interrupt, so for simplicity
consider any vmexit *not* instruction boundary except for external
interrupts.

It would in principle be okay to report the vCPU as preempted also
if it is sleeping in kvm_vcpu_block(): a TLB flush IPI will incur the
vmentry/vmexit overhead unnecessarily, and optimistic spinning is
also unlikely to succeed.  However, leave it for later because right
now kvm_vcpu_check_block() is doing memory accesses.  Even
though the TLB flush issue only applies to virtual memory address,
it's very much preferrable to be conservative.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: use VCPU_STAT() for debugfs entries]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/svm/svm.c          |    2 ++
 arch/x86/kvm/vmx/vmx.c          |    1 +
 arch/x86/kvm/x86.c              |   22 ++++++++++++++++++++++
 4 files changed, 28 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -553,6 +553,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
 	u64 ia32_xss;
@@ -1061,6 +1062,8 @@ struct kvm_vcpu_stat {
 	u64 req_event;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
+	u64 preemption_reported;
+	u64 preemption_other;
 };
 
 struct x86_instruction_info;
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3983,6 +3983,8 @@ out:
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_INTR)
+		vcpu->arch.at_instruction_boundary = true;
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6510,6 +6510,7 @@ static void handle_external_interrupt_ir
 		return;
 
 	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	vcpu->arch.at_instruction_boundary = true;
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -231,6 +231,8 @@ struct kvm_stats_debugfs_item debugfs_en
 	VCPU_STAT("l1d_flush", l1d_flush),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VCPU_STAT("preemption_reported", preemption_reported),
+	VCPU_STAT("preemption_other", preemption_other),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
@@ -4052,6 +4054,19 @@ static void kvm_steal_time_set_preempted
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
 
+	/*
+	 * The vCPU can be marked preempted if and only if the VM-Exit was on
+	 * an instruction boundary and will not trigger guest emulation of any
+	 * kind (see vcpu_run).  Vendor specific code controls (conservatively)
+	 * when this is true, for example allowing the vCPU to be marked
+	 * preempted if and only if the VM-Exit was due to a host interrupt.
+	 */
+	if (!vcpu->arch.at_instruction_boundary) {
+		vcpu->stat.preemption_other++;
+		return;
+	}
+
+	vcpu->stat.preemption_reported++;
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -9357,6 +9372,13 @@ static int vcpu_run(struct kvm_vcpu *vcp
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		/*
+		 * If another guest vCPU requests a PV TLB flush in the middle
+		 * of instruction emulation, the rest of the emulation could
+		 * use a stale page translation. Assume that any code after
+		 * this point can start executing an instruction.
+		 */
+		vcpu->arch.at_instruction_boundary = false;
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {


