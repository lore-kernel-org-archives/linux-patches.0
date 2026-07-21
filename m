Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6CF39EF16;
	Tue, 21 Jul 2026 21:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668584; cv=none; b=ORSyjHVs2mJ7xsr3HEzslvw4DB8rtpWWBF75LgM/vEi9sLzY0ti4b6AAahvq9MuVb0g6r4rNu1zZiNV1LtsBnkxYp+c5jF5hD8p4J5A+/Y3j0ko7t7uFeDgPtEq+2L7dkhb8+w01tkJIqv5c+tJjvpxDKI584LDFNRAfNpz1udo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668584; c=relaxed/simple;
	bh=f5DtmY3Gsv0HGRvCepnCa94oC3HLPuFGMh61dWreAIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIQmmpCN1uNgvZ60+m91PHzMOVox5E6iqFY2UogGmSh2aCd9hPvMAwTT7YYohvsUHk2oETsOiEaBsEEkxaQ/9cFTxnVL917Zx8zdQKRkmDlI+GXL58zDb1QXEG/fzniQRhZiV9EK3ViAKq679TGTXOAPhAFaAvOCRRM6mw6rbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYrS3giJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYrS3giJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA1B1F000E9;
	Tue, 21 Jul 2026 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668583;
	bh=Dj99ZY3Mtv2TiB3xRvDKoq5JnEDhRBjzzFFbTBegWUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYrS3giJ1DMoTUdD75vZHq3nLh9N8G51cyTLX9OF3bf6A9QpHuINCS1bv5pPI5Aq5
	 1OhO3j/nnmLdwijvftW3/+6f2JXojuPMvB443j1Kib7Attgse4eR1Jts1KQRVlFT6e
	 MnHM14aKbqQ3wUyAdsuwl6L2vfGF1+Y0XNp4CtlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 0230/1067] KVM: VMX: Grab vmcs12 on CR8 interception update iff vCPU is in guest mode
Date: Tue, 21 Jul 2026 17:13:51 +0200
Message-ID: <20260721152429.747718509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6620,11 +6620,10 @@ static noinstr void vmx_l1d_flush(struct
 
 static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
 
 	if (is_guest_mode(vcpu) &&
-		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+	    nested_cpu_has(get_vmcs12(vcpu), CPU_BASED_TPR_SHADOW))
 		return;
 
 	tpr_threshold = (irr == -1 || tpr < irr) ? 0 : irr;


