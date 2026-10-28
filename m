Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209381;
	b=CM/HdoD66Vhwk6kd+l7be/i+VOdssrgeBLTDxwZs8L37L2hzfpCsCoQ7khijgeQSe+px
	 je7I0zuBTORQn96eqQiyoAU4f1MzFi6l+T/OeJv3NpAHE2VAHQet2e/nnaMX5WpqsPTpd
	 p7vXaRvHKsas2+Ps7le+/+su/ekch/fhhlRZRZe98q+Ak6RmKdkxcP7u1x33eOehRnm76
	 C8BAx0Zmt4jxYUMBSGtQOGEER2Kun8jrIe9bjwJSTdmzVecWkNfTbUuLs6qSuMFb41gYD
	 yyGanIe5EqB+DeX8uBX/aC5uZpgoDTqbJzJzBemA4PnhXo7pc7rNcIp5EqG+v++WHeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WEl9Ue4+aJczCQZNgwjZ1eRDcxQhG5tFfKyU7YjB3xE=;
	b=4WGm6ej1hzfTq8ZYAMohhdMmTqIcy7csDP5m+9K8rNfsx9PmJ64VKE8JH0twiHIMaj07
	 cJDSpn5s3xhBeEEe2XTZMdgDF2sF5TOxc0rdwR4vs7uyt6RfIWbWyf33oDSFPk3Q25own
	 vScADUctNJ8CyUVwwmxndCF4Q6gIG4ndfWBO0LkE8LtNkyPjXgteaVQ22E8lLw/5BqYHV
	 b431KebWRJ2j4jo/bxfh7IejwJaVRlsK5S795fsLzFPnV9RxxFc+TR6Gj3uEfDh94vkrw
	 +QM+alOzZrsdT3nEhiTXgJRDWevE3QGBPsMG2TzltUFYCbEClyU94uX51F0n9UK243g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+DxcTjG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508BF606A31A;
	Wed, 28 Oct 2026 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+DxcTjG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9CB1F01825;
	Wed, 28 Oct 2026 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209380;
	bh=WEl9Ue4+aJczCQZNgwjZ1eRDcxQhG5tFfKyU7YjB3xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+DxcTjGD/IyqTpQlXWLo7sxGnLK0LpURiiUDmZmySmF+dVh3HDEBpTzBB+YMDzGF
	 c4bky5krAoW0J1nVC/N0xmZDx+2JRXuytUUcyLKJtfI9/MrFQNI3WUAFOsMpM7K4hX
	 zii/v3NTS0kyowRXMsbB1tIRN/UQj5O5w5LFkUcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 450/516] KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028170014.141621710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3509,8 +3509,10 @@ vmentry_fail_vmexit_guest_mode:
 vmentry_fail_vmexit:
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
-	if (!from_vmentry)
+	if (!from_vmentry) {
+		nested_ept_uninit_mmu_context(vcpu);
 		return NVMX_VMENTRY_VMEXIT;
+	}
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;


