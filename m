Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054258;
	b=us/YDJmb7j3mhPz5fL72q1zBM51W7S+jdyHMGRfQ8oWXkYcH0Q6gUs/znsYNf7OvTVbd
	 X00zP6llw7/HNlvJKg18QF64WgKp3cMzmsIXIBwSpKUXMOuXHGyVcEvSPpxAMm0t3B/N1
	 by6V3X6vGDvaO+ZYWv+dMgI4hXCrNKqkqc+V5jmF6GbZ+qQ4BATMyn+2A55vsbdwQRa69
	 TLbqYXH47db3sfS+EepC7USQbFdlniJs460DWIDgRcxZV8Ye5bK+BXIIkWi8A/ZVDPreV
	 d34thqSXCgWKuPEDIwRK3C3FtIXBJ/FUptxsVA0+IiWtXbo4wW+STT7yOxrc7sIs+dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4xmbz7TSi4NobkrptMYnjTF0kz+C74u4U3wMobbGqI=;
	b=2IBL4CkKyaO8hlNjnSmzCIcz0mB9hB2Wg0mO6mHzQp3SdI9Yj7xzkZZRpYXKigwgSAJM
	 H8ptUc/CtIm7KcDZKUNqZu30+IjEk628xJ5nF3XKj7cupbSC4xy2rEaBL+Xn/k6q9GWyw
	 GnnQuFEf8n6klC/Q/ydMwTWcoSk0NASravj/QMXKpqzT5UwwweXmDo334FbnUcnv2sBXj
	 XPljGg2Hwbl+fp8gtTJaH/WyUPUUMqE1vDyOWaMrYz2gg8eddcTotNirH4tzdRgzB27Xh
	 EtddStYbJjjltpAtqdqtRYoYhDsXlVmIeCerl9gsutYdfQx+J3RInVF9ikG2JyxXHxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJdfo8km;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41382606A32A;
	Thu, 19 Nov 2026 02:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJdfo8km
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D411F000C4;
	Thu, 19 Nov 2026 02:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054258;
	bh=N4xmbz7TSi4NobkrptMYnjTF0kz+C74u4U3wMobbGqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJdfo8kmxqZ3fKUXQewKppTvkWCUCeVH1IeVbuwWwoEJ5ws4MLIFCNPJ/rdnBmMff
	 Hxa2appqXufODdMOgt6DdSNPkh4LDLnpGiMrV075lY9aAlW9JBlxo5JPrY711sfHM5
	 3H2sGthNdzcGMKb1EtSZnXC/c1nNnTWbNftRvO5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1212/2214] KVM: nSVM: Check validity of vmcs01 save area copied from SMRAM on RSM
Date: Wed, 18 Nov 2026 15:48:08 +0100
Message-ID: <20261118150100.299234261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 053621535f014085c935879582dd3b65964a0dce ]

When doing RSM to L2, validate L1's state after copying it back into vmcb01
from SMRAM, as SMRAM is carved out of guest memory, i.e. is writable by the
guest.  Failure to validate L1's state is especially problematic for inputs
to MMU context, as KVM can end up with impossible CR4 vs. EFER state.  E.g.
without the recent hardening FNAME(walk_addr_generic), a guest can trigger:

  ------------[ cut here ]------------
  UBSAN: array-index-out-of-bounds in arch/x86/kvm/mmu/paging_tmpl.h:435:15
  index 3 is out of range for type 'u32 [2]'
  CPU: 3 UID: 0 PID: 92 Comm: CPU 1/KVM Not tainted 7.3.0-rc1 #2 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5f/0x90
   dump_stack+0x10/0x18
   ubsan_epilogue+0x9/0x39
   __ubsan_handle_out_of_bounds.cold+0x50/0x55
   paging32_walk_addr_generic+0x889/0x970
   paging32_page_fault+0x79/0xa60
   kvm_mmu_do_page_fault+0x125/0x270
   kvm_mmu_page_fault+0x88/0x7b0
   npf_interception+0xc8/0x220 [kvm_amd]
   svm_invoke_exit_handler+0x16d/0x1d0 [kvm_amd]
   svm_handle_exit+0xb7/0x160 [kvm_amd]
   vcpu_enter_guest+0x428/0x16a0
   kvm_arch_vcpu_ioctl_run+0x479/0x920
   kvm_vcpu_ioctl+0x316/0xb00
   __x64_sys_ioctl+0xa3/0x100
   x64_sys_call+0x281/0x23d0
   do_syscall_64+0xba/0x550
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x79bb30deb04b
   </TASK>
  ---[ end trace ]---

Fixes: 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from SMM")
Cc: stable@vger.kernel.org
Reported-by: Bill Wendling <morbo@google.com>
Reported-by: Stefan Teodorescu <fane@google.com>
Tested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022021046.295001-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: reused nested_vmcb_valid_sregs() with an is_l1 argument instead of adding the upstream cached-save validation helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 19 ++++++++++---------
 arch/x86/kvm/svm/svm.c    |  2 ++
 arch/x86/kvm/svm/svm.h    |  2 ++
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9a3045d843fc6..beb38ac96c263 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -292,10 +292,15 @@ static bool nested_vmcb_check_cr3_cr4(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Common checks that apply to both L1 and L2 state.  */
-static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
-				    struct vmcb_save_area *save)
+bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
+			     struct vmcb_save_area *save, bool is_l1)
 {
+	if (is_l1 && (!(save->cr0 & X86_CR0_PG) ||
+		      !(save->cr0 & X86_CR0_PE) ||
+		      (save->rflags & X86_EFLAGS_VM) ||
+		      ((save->efer & EFER_LMA) && !(save->efer & EFER_LME))))
+		return false;
+
 	/*
 	 * FIXME: these should be done after copying the fields,
 	 * to avoid TOC/TOU races.  For these save area checks
@@ -674,7 +679,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save, false) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = -1u;
@@ -1365,11 +1370,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
 	 */
-	if (!(save->cr0 & X86_CR0_PG) ||
-	    !(save->cr0 & X86_CR0_PE) ||
-	    (save->rflags & X86_EFLAGS_VM) ||
-	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
-	    !nested_vmcb_valid_sregs(vcpu, save))
+	if (!nested_vmcb_valid_sregs(vcpu, save, true))
 		goto out_free;
 
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0042388321d03..64e646ccde81f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4441,6 +4441,8 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	 */
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, map_save.hva + 0x400);
+	if (!nested_vmcb_valid_sregs(vcpu, &svm->vmcb01.ptr->save, true))
+		goto unmap_save;
 
 	/*
 	 * Enter the nested guest now
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8abb47a509f7e..30088388198b2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -491,6 +491,8 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 void __svm_write_tsc_multiplier(u64 multiplier);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
+bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
+			     struct vmcb_save_area *save, bool is_l1);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
-- 
2.53.0



