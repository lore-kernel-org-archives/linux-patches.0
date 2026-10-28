Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207582;
	b=AxPur/DPraIFYemvGVOo5Qb6SiYIASYZ/llOw9P7UuWIYa4F5xHwd4/LCibXxr3HhtDH
	 IDl1eUaB/hVmvALECEHq/l+CFXMCW3C+HmAr5gNMmaxdQ4gzHKIGmBOHmxeB0KHAe/tNP
	 QE5aUGYsRq/Y4Sox7iWil72MeMbrYU/3EmNbqtoGnEYO0H1yEADjWFvpVaMb4ES+SVv/L
	 0KxCbnnMif8upyk2Zm7gdIrbWdXxazSsesjZs2gIVeLUjiontgdVNitf3idICq3I9nhLK
	 tQAIluygAOQb9ChZQle8pJnj/AIQU+9PtkKBMKxFUD17P1DkiMgrtLnXtrJ+9T0y3tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iD4e6VFaKFCfu5S+1zybyXBacZzfezJ3MBSytMium0Y=;
	b=RP30ikXr8ZeM5n7sfScDqYsZqyXXdMAi/7UXwhu6j9yEtWGNIznVUzu4Dl5TEfdNjAOT
	 veJ9HydNulrXz7obGtXYVKqzJYSUzso9y7EaQRzoNOiW7nBG+65QqDEH5DNfef8FfsIkT
	 ku9D3ydJySGwNp7WcjbCfglOxsofrHJArP9VSoFra9Hx9BiyHC0eA6nGiXHaNa0dqIQLW
	 T1ZfcQ92yAgD2qNCKvOHWXlowjOcqtuhem1ZFAAeAgi15gcPHFPkNrhP7BoWQPzNPQGXX
	 1B/eH592FmJIWsnXid6bSmm4QowkMk4SXH8AXtEbpqdrmAYBrC4o8z5FmfgtAualVaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yr17Poc5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C3606A31A;
	Wed, 28 Oct 2026 17:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yr17Poc5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21FB1F01825;
	Wed, 28 Oct 2026 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207582;
	bh=iD4e6VFaKFCfu5S+1zybyXBacZzfezJ3MBSytMium0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr17Poc5Keqq81zZP9YVZmYZo3jfNLa6erCXoDwVW6rJ1grqPz1bYnzadgEF/2ZYg
	 btIFxDcRKUHZKbI5D4fakqEVmgnmOdkHgA+vH6wY8Qe3u/VpYZiULGPkWNDeAyr0dh
	 J/H6Z9/pfrNHr81FzjU2c9V9UMxhyJrRO+QKkKBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 066/247] KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry
Date: Wed, 28 Oct 2026 17:57:49 +0100
Message-ID: <20261028165948.952708894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3689,8 +3689,10 @@ vmentry_fail_vmexit_guest_mode:
 vmentry_fail_vmexit:
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
-	if (!from_vmentry)
+	if (!from_vmentry) {
+		nested_ept_uninit_mmu_context(vcpu);
 		return NVMX_VMENTRY_VMEXIT;
+	}
 
 	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);


