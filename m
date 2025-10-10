Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC002F60CD;
	Fri, 10 Oct 2025 13:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102268; cv=none; b=ffvpzEyh3IRFcPHwWUwVXr008g7MUJM9ahPfh2Zcu1Jxy0QtO63PSIjLmV0wAYiAe6KBr+J6BOO74gULeNU4zDNTJ8gbT01F9QQpcjlGiAiwnR0GAWL5b6XltA7lagkh0Pl/o0zy7Ja58LK6hq0qLzcLX4+YEVFQiJUU5Gwvuig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102268; c=relaxed/simple;
	bh=+lEpebIQQsG1H1UCUOg/C87FCT+edxk9ywzHNJAPb1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiGCOv+B9OKbvD989ZX7stFugIA84p2v7EcttvJREG/dMvWPBvts/+5BrHODj1qXzJBuYJp21BBPAfk3QiwtiannaLPrNxRRsHXW4rQvPuTZZJh6F4Ss1Xmu7wj0psj6aXg/mAR3mkTPNa2E9KEqdDQslrA9Q1aSeBB2zpfe8BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWr9j7er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWr9j7er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4947FC4CEF9;
	Fri, 10 Oct 2025 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102267;
	bh=+lEpebIQQsG1H1UCUOg/C87FCT+edxk9ywzHNJAPb1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWr9j7er7NJ5aYj/laE2wy5GxqUUSU4bVl0vBSaHsXg+WC1zyS8BrD8W5+Bk6WvMV
	 UWcq7FCqgRcukgkNtPQv/IS+sZS7B26v2EvvkLfI73qS0DMzvrEaQ3ZmSN3afaIOUG
	 OOtGRnDldLb17GXqHFTv9aW0fCp2+P6uBYmz6wp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc2032ba16cc2018ca25@syzkaller.appspotmail.com,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 24/26] KVM: x86: Dont (re)check L1 intercepts when completing userspace I/O
Date: Fri, 10 Oct 2025 15:16:19 +0200
Message-ID: <20251010131332.085052566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

commit e750f85391286a4c8100275516973324b621a269 upstream.

When completing emulation of instruction that generated a userspace exit
for I/O, don't recheck L1 intercepts as KVM has already finished that
phase of instruction execution, i.e. has already committed to allowing L2
to perform I/O.  If L1 (or host userspace) modifies the I/O permission
bitmaps during the exit to userspace,  KVM will treat the access as being
intercepted despite already having emulated the I/O access.

Pivot on EMULTYPE_NO_DECODE to detect that KVM is completing emulation.
Of the three users of EMULTYPE_NO_DECODE, only complete_emulated_io() (the
intended "recipient") can reach the code in question.  gp_interception()'s
use is mutually exclusive with is_guest_mode(), and
complete_emulated_insn_gp() unconditionally pairs EMULTYPE_NO_DECODE with
EMULTYPE_SKIP.

The bad behavior was detected by a syzkaller program that toggles port I/O
interception during the userspace I/O exit, ultimately resulting in a WARN
on vcpu->arch.pio.count being non-zero due to KVM no completing emulation
of the I/O instruction.

  WARNING: CPU: 23 PID: 1083 at arch/x86/kvm/x86.c:8039 emulator_pio_in_out+0x154/0x170 [kvm]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 23 UID: 1000 PID: 1083 Comm: repro Not tainted 6.16.0-rc5-c1610d2d66b1-next-vm #74 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:emulator_pio_in_out+0x154/0x170 [kvm]
  PKRU: 55555554
  Call Trace:
   <TASK>
   kvm_fast_pio+0xd6/0x1d0 [kvm]
   vmx_handle_exit+0x149/0x610 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xda8/0x1ac0 [kvm]
   kvm_vcpu_ioctl+0x244/0x8c0 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0x5d/0xc60
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Reported-by: syzbot+cc2032ba16cc2018ca25@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68790db4.a00a0220.3af5df.0020.GAE@google.com
Fixes: 8a76d7f25f8f ("KVM: x86: Add x86 callback for intercept check")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250715190638.1899116-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c     |    9 ++++-----
 arch/x86/kvm/kvm_emulate.h |    3 +--
 arch/x86/kvm/x86.c         |   15 ++++++++-------
 3 files changed, 13 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5107,12 +5107,11 @@ void init_decode_cache(struct x86_emulat
 	ctxt->mem_read.end = 0;
 }
 
-int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
+int x86_emulate_insn(struct x86_emulate_ctxt *ctxt, bool check_intercepts)
 {
 	const struct x86_emulate_ops *ops = ctxt->ops;
 	int rc = X86EMUL_CONTINUE;
 	int saved_dst_type = ctxt->dst.type;
-	bool is_guest_mode = ctxt->ops->is_guest_mode(ctxt);
 
 	ctxt->mem_read.pos = 0;
 
@@ -5160,7 +5159,7 @@ int x86_emulate_insn(struct x86_emulate_
 				fetch_possible_mmx_operand(&ctxt->dst);
 		}
 
-		if (unlikely(is_guest_mode) && ctxt->intercept) {
+		if (unlikely(check_intercepts) && ctxt->intercept) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_PRE_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -5189,7 +5188,7 @@ int x86_emulate_insn(struct x86_emulate_
 				goto done;
 		}
 
-		if (unlikely(is_guest_mode) && (ctxt->d & Intercept)) {
+		if (unlikely(check_intercepts) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_POST_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -5243,7 +5242,7 @@ int x86_emulate_insn(struct x86_emulate_
 
 special_insn:
 
-	if (unlikely(is_guest_mode) && (ctxt->d & Intercept)) {
+	if (unlikely(check_intercepts) && (ctxt->d & Intercept)) {
 		rc = emulator_check_intercept(ctxt, ctxt->intercept,
 					      X86_ICPT_POST_MEMACCESS);
 		if (rc != X86EMUL_CONTINUE)
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -235,7 +235,6 @@ struct x86_emulate_ops {
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
 	bool (*is_smm)(struct x86_emulate_ctxt *ctxt);
-	bool (*is_guest_mode)(struct x86_emulate_ctxt *ctxt);
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
@@ -521,7 +520,7 @@ bool x86_page_table_writing_insn(struct
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
 void init_decode_cache(struct x86_emulate_ctxt *ctxt);
-int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
+int x86_emulate_insn(struct x86_emulate_ctxt *ctxt, bool check_intercepts);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
 			 u16 tss_selector, int idt_index, int reason,
 			 bool has_error_code, u32 error_code);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8470,11 +8470,6 @@ static bool emulator_is_smm(struct x86_e
 	return is_smm(emul_to_vcpu(ctxt));
 }
 
-static bool emulator_is_guest_mode(struct x86_emulate_ctxt *ctxt)
-{
-	return is_guest_mode(emul_to_vcpu(ctxt));
-}
-
 #ifndef CONFIG_KVM_SMM
 static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 {
@@ -8558,7 +8553,6 @@ static const struct x86_emulate_ops emul
 	.guest_cpuid_is_intel_compatible = emulator_guest_cpuid_is_intel_compatible,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.is_smm              = emulator_is_smm,
-	.is_guest_mode       = emulator_is_guest_mode,
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
@@ -9143,7 +9137,14 @@ restart:
 		ctxt->exception.address = 0;
 	}
 
-	r = x86_emulate_insn(ctxt);
+	/*
+	 * Check L1's instruction intercepts when emulating instructions for
+	 * L2, unless KVM is re-emulating a previously decoded instruction,
+	 * e.g. to complete userspace I/O, in which case KVM has already
+	 * checked the intercepts.
+	 */
+	r = x86_emulate_insn(ctxt, is_guest_mode(vcpu) &&
+				   !(emulation_type & EMULTYPE_NO_DECODE));
 
 	if (r == EMULATION_INTERCEPTED)
 		return 1;


