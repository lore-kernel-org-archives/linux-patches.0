Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538342A14C;
	Thu, 16 Jul 2026 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212424; cv=none; b=phJXwBb4Sa9omty5qJAccxPrPm7YdW5iYYZsdjlAwo01qLZT2GaLv+hXFx124h/EuShoGz93Z3kSgPYrSZfSkvdwtmk8VzFCMgaiGEVrQi5elcbFmYKyAoh5vU7p+LSYC+VaTiopTIkEdXKOvvWO1tGAo7cUVNbsXJE7J1mzLVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212424; c=relaxed/simple;
	bh=g64v3oYteSk+zi/qNj+Wq/xSNmLp45uGnF3AYnVapN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBtIvYrYKtKcYxn2CskIn3Qtrcqo2Ud2TgRd9Ux28oYJLPcKRNHt5geAwU3E8chnUuW5vUS0qe0TSnOcZE3o4v5o69XSlFShQQmCY1Q/pRvRGzpstYQh+i1ojX3KOV4L2UYmKWVCAi6iohfWOutZOI0Qc4XdT7iS+uZsgGYQbps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAAxiTZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAAxiTZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2799F1F000E9;
	Thu, 16 Jul 2026 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212423;
	bh=kOyPsVwz9ecZKsPGUqNdnfD766YuKJL+XhGubQmb184=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAAxiTZKoX8DWAHEmH7YpnT49vS5Da0+54f7d2aBq+AnLop4/V7/P68hxkto7cZfm
	 pS0sRvItQZHoAguvcwtR55qigilV+vPYwWkZ1U2Y0wDx6oWSB5cvMeqMIckr84c6C8
	 zONuhgHjHp9bcu+jQVjsRgMqFpBCvx5ZDQuAFHHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 320/349] KVM: VMX: Grab vmcs12 on CR8 interception update iff vCPU is in guest mode
Date: Thu, 16 Jul 2026 15:34:14 +0200
Message-ID: <20260716133040.476131441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 7ef78d71ca713d8c00f7c34ddcf276c808143f77 upstream.

When updating CR8 intercepts, get vmcs12 if and only if the vCPU is in
guest mode so that a future change can have update CR8 intercepts during
vCPU creation, without running afoul of get_vmcs12()'s lockdep assertion.

  ------------[ cut here ]------------
  debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read(&vcpu->kvm->users_count))
  WARNING: arch/x86/kvm/vmx/nested.h:61 at get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline], CPU#0: syz.2.19/5879
  WARNING: arch/x86/kvm/vmx/nested.h:61 at vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879, CPU#0: syz.2.19/5879
  Modules linked in:
  CPU: 0 UID: 0 PID: 5879 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
  RIP: 0010:get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline]
  RIP: 0010:vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879
  Call Trace:
   <TASK>
   apic_update_ppr arch/x86/kvm/lapic.c:984 [inline]
   kvm_lapic_reset+0x1c24/0x2980 arch/x86/kvm/lapic.c:3023
   kvm_vcpu_reset+0x44c/0x1bf0 arch/x86/kvm/x86.c:12986
   kvm_arch_vcpu_create+0x746/0x8b0 arch/x86/kvm/x86.c:12847
   kvm_vm_ioctl_create_vcpu+0x428/0x930 virt/kvm/kvm_main.c:4201
   kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5159
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:597 [inline]
   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

No functional change intended.

Reported-by: syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/all/6a2adf3b.3b0a2d4e.8c8d1.0012.GAE@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260618174347.1981064-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6707,11 +6707,10 @@ static noinstr void vmx_l1d_flush(struct
 
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
 
 	if (is_guest_mode(vcpu) &&
-		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+	    nested_cpu_has(get_vmcs12(vcpu), CPU_BASED_TPR_SHADOW))
 		return;
 
 	tpr_threshold = (irr == -1 || tpr < irr) ? 0 : irr;


