Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173D0306754;
	Fri,  7 Aug 2026 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117178; cv=none; b=ltG6MsqNwjSNtIghMP3jc1FZWhpa0OT1k4VSmOW1FrCQYK6SwXsfs3sTgHSI6xKCfM/J+EV/ylnbC8HaCpFv+z7qV0Z+PCIeEmeW68vNMukZG1ylsQWvUXVpXKUm7GrNWJuttidL+twinukHUOtfdilIZOMJytB181xzDuCJms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117178; c=relaxed/simple;
	bh=ciZe+WNP6Z0Hh8xBlzIR7E0tuscqhek7fSgzKOVAVfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3VE6JUUisaOC1eD9zC5kf+hZsR107bwS0D4ZaZbO6D72Ox6NxHwYVdBITx9cFEbZfl6dN8ZMoPDM8ShZUj/mciAtaoeAYJN7L1CWEjD6X/zOVcP4tcfx95Za+uzYojKjETTkMw/4gXFkTaUvS4hxb09+ddWb7buyNJsUCVxxHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnXoRRau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnXoRRau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4DE1F000E9;
	Fri,  7 Aug 2026 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117177;
	bh=qNC8Oh4y3DJ0Tilsyqyj/6wYqh+Y1ErUzrpC2zEDzyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnXoRRau6WJsn8axz++ywvG9f4Vx5+VC29ILn+Fvv8b2PxVSacoaPFFBJT9zaoHJT
	 8N0o7VRMtHFlsG1Cz21u0tKu/5CQHA/l1zQSKaqOq7lCkwSaVsAUC62+koFkkzehg3
	 1B3M3JB1KaiU8/rwu4dqunSnMF7M1cft872cf8tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 228/438] KVM: SVM: Update x2APIC MSR intercepts if AVIC is inhibited while L2 is active
Date: Fri,  7 Aug 2026 16:37:04 +0200
Message-ID: <20260807143432.864888441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 7d3aae206663c4e006b25a1c7a20a4029e67da76 upstream.

Always update x2APIC MSR intercepts for L1 when AVIC is deactivated, even
if L2 is active and KVM is using a separate MSR bitmap to run L2.  If AVIC
is fully enabled prior to running L2, and is then inhibited while L2 is
active (for a VM-scoped inhibit), then KVM will run L1 with AVIC disabled,
but with x2APIC MSR intercepts disabled, i.e. will allow L1 to read most of
the host's APIC state, send arbitrary interrupts, change task priority, and
ultimately trivially DoS the host.

E.g. sending a self-IPI in L1 on HYPERV_REENLIGHTENMENT_VECTOR, 0xee, with
CONFIG_HYPERV=n in the host kernel as a "safe" PoC, yields:

  Spurious interrupt (vector 0xee) on CPU#425. Acked

And hacking KVM to abuse kvm_set_posted_intr_wakeup_handler() to register a
handler and WARN on POSTED_INTR_WAKEUP_VECTOR yields:

  ------------[ cut here ]------------
  WARNING: arch/x86/kvm/svm/svm.c:5594 at pi_wakeup_handler+0x9/0x10 [kvm_amd], CPU#156: nested_x2apic_t/316940
  CPU: 156 UID: 0 PID: 316940 Comm: nested_x2apic_t Tainted: G S   U
  Tainted: [S]=CPU_OUT_OF_SPEC, [U]=USER
  Hardware name: Google Astoria-Turin/astoria, BIOS 0.20260209.0-0 02/09/2026
  RIP: 0010:pi_wakeup_handler+0x9/0x10 [kvm_amd]
  Call Trace:
   <IRQ>
   sysvec_kvm_posted_intr_wakeup_ipi+0x64/0x80
   </IRQ>
   <TASK>
   asm_sysvec_kvm_posted_intr_wakeup_ipi+0x1a/0x20
  RIP: 0010:vcpu_run+0x1430/0x1e40 [kvm]
   kvm_arch_vcpu_ioctl_run+0x2c1/0x600 [kvm]
   kvm_vcpu_ioctl+0x580/0x6b0 [kvm]
   __se_sys_ioctl+0x6d/0xb0
   do_syscall_64+0x10a/0x480
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x46ff4b
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: 091abbf578f9 ("KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception")
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://patch.msgid.link/20260729213558.639074-1-pbonzini@redhat.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -240,14 +240,6 @@ static void avic_deactivate_vmcb(struct
 	if (!is_sev_es_guest(&svm->vcpu))
 		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 
-	/*
-	 * If running nested and the guest uses its own MSR bitmap, there
-	 * is no need to update L0's msr bitmap
-	 */
-	if (is_guest_mode(&svm->vcpu) &&
-	    vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT))
-		return;
-
 	/* Enabling MSR intercept for x2APIC registers */
 	avic_set_x2apic_msr_interception(svm, true);
 }


