Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C8D3090CE;
	Mon, 13 Oct 2025 15:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370272; cv=none; b=YQt0+vbgj1MQE1HfP6IiPRvL87uZzNWwI29xDyQRKR95mSDJ0FYfGRcJ/EH7E9ydcbuU3oa9utIA9uNCpjxH4Gk/zSwheUr11CxUZchyiVM+UwaOvFvm8gxinEl8s8gatNeYSbj1fz+AFaI56A59aLy7CA0228VeknRXcEW5+Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370272; c=relaxed/simple;
	bh=+voAjPvjIfFIF4IzkHYvvSCJiTlLgBpj67sA9KvxG0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAPsWsU9bRXsMlQi3ij+MlyvQPzpxxuzPCNmBZ+0h2UemO6YSY4cAxwI/1/XSPeoXcgP9KuUzP9JuFslV9klxo0PmBImGl5esEJlMQvQiDV6xg+wp1p+dwG6cxCX0qk5KuK+RcUFGWXD00uEOjfAHucvuLOMrE5K3fXEhQx99wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bor1dsdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bor1dsdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD48C4CEE7;
	Mon, 13 Oct 2025 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370271;
	bh=+voAjPvjIfFIF4IzkHYvvSCJiTlLgBpj67sA9KvxG0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bor1dsdCPM5Fd2J8Nh56F/enZk77IMz6uSOPFwcJvjp9q8HeINOjbe3yTTkRIce+K
	 nAdCPpi53YT6T2PpDFfv+I6PVVEWAhrJzMrVI3b/QWk38LLVD2UTHwkmwY6CawqFM6
	 9D07Kn8Z+VHB9u1maVdeIXs2FdXiOwxsk6ulEXVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 538/563] KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isnt valid
Date: Mon, 13 Oct 2025 16:46:39 +0200
Message-ID: <20251013144430.798513945@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 0910dd7c9ad45a2605c45fd2bf3d1bcac087687c upstream.

Skip the WRMSR and HLT fastpaths in SVM's VM-Exit handler if the next RIP
isn't valid, e.g. because KVM is running with nrips=false.  SVM must
decode and emulate to skip the instruction if the CPU doesn't provide the
next RIP, and getting the instruction bytes to decode requires reading
guest memory.  Reading guest memory through the emulator can fault, i.e.
can sleep, which is disallowed since the fastpath handlers run with IRQs
disabled.

 BUG: sleeping function called from invalid context at ./include/linux/uaccess.h:106
 in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 32611, name: qemu
 preempt_count: 1, expected: 0
 INFO: lockdep is turned off.
 irq event stamp: 30580
 hardirqs last  enabled at (30579): [<ffffffffc08b2527>] vcpu_run+0x1787/0x1db0 [kvm]
 hardirqs last disabled at (30580): [<ffffffffb4f62e32>] __schedule+0x1e2/0xed0
 softirqs last  enabled at (30570): [<ffffffffb4247a64>] fpu_swap_kvm_fpstate+0x44/0x210
 softirqs last disabled at (30568): [<ffffffffb4247a64>] fpu_swap_kvm_fpstate+0x44/0x210
 CPU: 298 UID: 0 PID: 32611 Comm: qemu Tainted: G     U              6.16.0-smp--e6c618b51cfe-sleep #782 NONE
 Tainted: [U]=USER
 Hardware name: Google Astoria-Turin/astoria, BIOS 0.20241223.2-0 01/17/2025
 Call Trace:
  <TASK>
  dump_stack_lvl+0x7d/0xb0
  __might_resched+0x271/0x290
  __might_fault+0x28/0x80
  kvm_vcpu_read_guest_page+0x8d/0xc0 [kvm]
  kvm_fetch_guest_virt+0x92/0xc0 [kvm]
  __do_insn_fetch_bytes+0xf3/0x1e0 [kvm]
  x86_decode_insn+0xd1/0x1010 [kvm]
  x86_emulate_instruction+0x105/0x810 [kvm]
  __svm_skip_emulated_instruction+0xc4/0x140 [kvm_amd]
  handle_fastpath_invd+0xc4/0x1a0 [kvm]
  vcpu_run+0x11a1/0x1db0 [kvm]
  kvm_arch_vcpu_ioctl_run+0x5cc/0x730 [kvm]
  kvm_vcpu_ioctl+0x578/0x6a0 [kvm]
  __se_sys_ioctl+0x6d/0xb0
  do_syscall_64+0x8a/0x2c0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 RIP: 0033:0x7f479d57a94b
  </TASK>

Note, this is essentially a reapply of commit 5c30e8101e8d ("KVM: SVM:
Skip WRMSR fastpath on VM-Exit if next RIP isn't valid"), but with
different justification (KVM now grabs SRCU when skipping the instruction
for other reasons).

Fixes: b439eb8ab578 ("Revert "KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid"")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250805190526.1453366-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4180,13 +4180,21 @@ static int svm_vcpu_pre_run(struct kvm_v
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	/*
+	 * Next RIP must be provided as IRQs are disabled, and accessing guest
+	 * memory to decode the instruction might fault, i.e. might sleep.
+	 */
+	if (!nrips || !control->next_rip)
+		return EXIT_FASTPATH_NONE;
 
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
 
-	switch (svm->vmcb->control.exit_code) {
+	switch (control->exit_code) {
 	case SVM_EXIT_MSR:
-		if (!svm->vmcb->control.exit_info_1)
+		if (!control->exit_info_1)
 			break;
 		return handle_fastpath_set_msr_irqoff(vcpu);
 	case SVM_EXIT_HLT:


