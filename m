Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0E941F36F;
	Thu, 16 Jul 2026 13:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209032; cv=none; b=ZY3au7rQcfOg9hmNyOeit+P7kvtwJ48w/kQjIElxm8wmEGSQD3rmAUdrKthHqrk0kE/la4ZQlhceS8Kz7f9w9Y9nGLtSijyiMzpeD7Mkz846T1HW0/UyDpgp6FJBz4HCZRTZLME34BSIKX2oT/dusnf1/W55Ap1DA+g51YiuHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209032; c=relaxed/simple;
	bh=53Zr/Pxn29A5YzqtI2tv2ReNgdWmXxeSQ4oLy8wIdSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+DGhZRT5A/oqgKiTf9EirRht6Hf/INxZBMTzglqfOZJS4VNxhFloUYVk03XdNLfy3EAF7BU+f96jVT5ijWh5YUZnrGTa0hFgQDgf1Ej47RDKR31fZaN6KvOae87Qtcrj1z7gtBbitbz1aCG9IUttNigvo4wA7ACkBrT/v6HnUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbB34oyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbB34oyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9451F000E9;
	Thu, 16 Jul 2026 13:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209031;
	bh=iNYuo0SAUKROeQxdEI9nELWcmQ6i2JFXLBdwV8RdRFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbB34oyXPOVjQUOtwRtChvW/mqqmSkb582O6PmpH3PTrwiWEFUM0nxej0AixocQUG
	 +s+r2fPsWVjJYRuGjiD7BIp0XHeIeLEWgrdk7knAO7KyNUPmPThrEa9RyBqT87rvZh
	 ZwpSLisRtrfl8yrzZEMeeF7wvJ/fCPCB8Re1BUME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH 7.1 009/518] KVM: VMX: Grab vmcs12 on CR8 interception update iff vCPU is in guest mode
Date: Thu, 16 Jul 2026 15:24:37 +0200
Message-ID: <20260716133047.981754123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 7ef78d71ca713d8c00f7c34ddcf276c808143f77 ]

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
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6855,11 +6855,10 @@ int vmx_handle_exit(struct kvm_vcpu *vcp
 
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
 
 	if (is_guest_mode(vcpu) &&
-		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+	    nested_cpu_has(get_vmcs12(vcpu), CPU_BASED_TPR_SHADOW))
 		return;
 
 	guard(vmx_vmcs01)(vcpu);


