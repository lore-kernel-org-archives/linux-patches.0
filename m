Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773974;
	b=PgFVhqt0N7D8z8TxU5BCg2xdGDHMG6Ny8EHbU8E3XVEoJx69LWsYX+bwkopWlv3BQ2bC
	 RspfW1q8uMbot7+UMbc6Kqd/HucYKV1lNC1R/eNQWYF2irhNkPR4shWb72zIgQ/774nOT
	 5QsQKT968JhA/CqoqMpk6CzUCkbbM5EGh2/bkGKc7ulJlcMZEgkGm0YyAgQPxCrFWK7Vb
	 Vj9Zry4d+Rm/qbAESremBXH/cjwAMJ+eB5X3xmrkoF6K8/15QVHk/puvsiuCMWCugMBqv
	 d7kRimq8rjvwUmIJe4VZkfM09JG3j1HmPKfe+u8heATP4VFslU3GQKwx7ktxu7I0R1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27svanuAPz0L+ZY4JuLehQBIxI6NlqziPsWMUSIxsHU=;
	b=b3ojIZvOvpD1U9fNMpi+c7kpuBRagNfAWjrEH+TyR1G76KfYJsFP9zQIr06WmlQSTkVg
	 0wZ5WV4UP2f3RbARG6yOlqwZcWenwepGjJR3ZmRevtwI06A6m+QlZjETaMcWtIA8dF3s+
	 i6QDZtRLvTQUPL/WqOMo6Gx7yTDigmf/6Eg7QFlrYauSmu4ejxDcDzYhzw19/hp207sAp
	 kCxjyMQcr5Q0ZBcXlXc6oGqJ+EMiH8i8oFRChFBm/p8EzcGKFmqBg6QmcpPcDoLt7MfcK
	 WriLBg6RtDlJZbuAAWG1kFKrTMwIzlgL5rDbUgJ7xcGPiwBI4jsXrpwTt1yvB5oV6Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Id6WbZsZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19C7606A31A;
	Fri, 23 Oct 2026 16:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Id6WbZsZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B7E1F01825;
	Fri, 23 Oct 2026 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773973;
	bh=27svanuAPz0L+ZY4JuLehQBIxI6NlqziPsWMUSIxsHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Id6WbZsZTwt1jb4xF6j8K/enyedaYTuTh7vKkF1VbdN2RTNeoisd1s7qQScE7fgws
	 Ou0spjP/+1dRs+bVS9SSuL6h4cdZN3UT4u1QaFUH/NVt/Tv9tRJk61p8abm0M4cIzG
	 ySDt8mr7nYEcZEt/FlK+ec6i+SgeOUahEe+3anXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 078/193] KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry
Date: Fri, 23 Oct 2026 18:35:55 +0200
Message-ID: <20261023163716.051302028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3821,8 +3821,10 @@ vmentry_fail_vmexit_guest_mode:
 vmentry_fail_vmexit:
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
-	if (!from_vmentry)
+	if (!from_vmentry) {
+		nested_ept_uninit_mmu_context(vcpu);
 		return NVMX_VMENTRY_VMEXIT;
+	}
 
 	nested_put_vmcs12_pages(vcpu);
 


