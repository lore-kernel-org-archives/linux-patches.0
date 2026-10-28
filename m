Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211769;
	b=tQHver8QRWxVLfAjjEwMhlRCWRiSEVK6oqJ1RwAu4PyKWKJw1Ph+EnsrNKeN+Rme2fMB
	 59uOV51J+JuXeOJ4TLPbeq/6e0zqD8RYuSD1Kcj3y9xpPAg/ALG+FflEzVw2R6VVdEaAI
	 S85ZIBm8t/Mb2PVmtF9EOlN/28MjFVSBovlTUjF9M0S5dDO4S8+vpnPGYFUQPdgBdfTtb
	 Ff3wT3T3X/qGs1mxKXDn0sv0xGwJij2bjGXzkZ0gm6Ra/wipidIuANRQSbN16ru1Nu1Up
	 WSEj/Enege7CtONmNftH+qLt5h8ay2goA0XJ888SKjUozmto6O6LaoGmswhbXULQ62g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hL2bLvFMqqRrUiUNHWlqVTlTJqqHabfIP8RXRZyKMMk=;
	b=1NBZL3ilGWPZBWCtMVn9AfNHdaxgO77/885F8d+n9TNArs+hNDMCzzmnSlqHcJEltslh
	 SLDEJPO/x4D4/iG77UIFv6bN8l2U+VQ3TUuPgTcg3d2mDxRQdKjUI/K+yjRlkhS57i/q2
	 V8zK955LGDaNZQXq+NwUooQxHnhbEYKF6mj9hBkMNCjXcq/CExrPyS7nqIOqugnKQsaK3
	 oxQHYoNqmZf3ucwpSS0+0KET6Xet5TSY1p451RAx7A36RkmVIZei8Gr6lqsOyb8GOKh7q
	 fE68lQhSuR/jXNAEtsFB3kAGTof6pe06+y2sDALLdVLUpx6F5vWvFZWs9cxRwjydxUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfoMvnKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F699606A32D;
	Wed, 28 Oct 2026 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfoMvnKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7441F01825;
	Wed, 28 Oct 2026 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211769;
	bh=hL2bLvFMqqRrUiUNHWlqVTlTJqqHabfIP8RXRZyKMMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfoMvnKsI3ur1cSINkywnKnfofJEec1tecQx5Jl7hgeK+ryjP3M6lAh9iGsCNtKbT
	 wp+w0KF+ZftHzw6ia7Gf9SFn1Pe2lokifg6/2dDh9LKL+Auj/gyISlHAPq8RrQft22
	 8Tf2JYIMqCxDszLXSIvA7v+79ZsC0fllrWRBttnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 493/571] KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry
Date: Wed, 28 Oct 2026 18:00:40 +0100
Message-ID: <20261028170019.725638399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>

commit c8f4cfe1cf93bce924e27f2abead7a4c4a487505 upstream.

Reset the vCPU's MMU pointer back to the root MMU if loading L2 state fails
in the "not from VM-Entry" case, i.e. when emulating RSM or handling
KVM_SET_NESTED_STATE.  Failure to unwind the MMU pointer results in KVM
trying to run L1 with a nested MMU, and is especially problematic if the
vCPU manages to free its nested state before the VM crashes.  Constructing
the root for a nested EPT MMU goes through vmcs12, which is dynamically
allocated/freed when nVMX is enabled/disabled.  And so if the nested state
is freed with the MMU still pointing at the nested MMU, KVM will hit a NULL
pointer deref when attempting to get L1=>L2 EPTP.

  BUG: kernel NULL pointer dereference, address: 0000000000000078
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 114a2d067 P4D 111743067 PUD 11141f067 PMD 0
  Oops: Oops: 0000 [#1] SMP
  CPU: 20 UID: 1000 PID: 1272 Comm: nested_tdp_faul Not tainted 7.3.0-rc4-8c89f11d1a99b-sink-vm #1914 PREEMPTLAZY
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:nested_ept_get_eptp+0xb/0x10 [kvm_intel]
  Call Trace:
   <TASK>
   kvm_mmu_load+0xcd/0x870 [kvm]
   kvm_arch_vcpu_ioctl_run+0x18f5/0x1f80 [kvm]
   kvm_vcpu_ioctl+0x2c7/0x970 [kvm]
   __x64_sys_ioctl+0x90/0xd0
   do_syscall_64+0x9c/0x4d0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x47491b
   </TASK>
  Modules linked in: kvm_intel kvm irqbypass
  CR2: 0000000000000078
  ---[ end trace 0000000000000000 ]---
  RIP: 0010:nested_ept_get_eptp+0xb/0x10 [kvm_intel]

Cc: David Woodhouse <dwmw2@infradead.org>
Fixes: 72e9cbdb4338 ("KVM: nVMX: fix SMI injection in guest mode")
Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
Cc: stable@vger.kernel.org
Signed-off-by: Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>
[sean: write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://patch.msgid.link/20261001214356.3825100-2-seanjc@google.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3538,8 +3538,10 @@ vmentry_fail_vmexit_guest_mode:
 vmentry_fail_vmexit:
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
-	if (!from_vmentry)
+	if (!from_vmentry) {
+		nested_ept_uninit_mmu_context(vcpu);
 		return NVMX_VMENTRY_VMEXIT;
+	}
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;


