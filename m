Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983A833DEFE;
	Fri,  7 Aug 2026 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116057; cv=none; b=OiVFvFutlYIa5o6od++TEqLjOnZ6YjyWYyWQNAmXXcBjAonuzL5niJPj39YDxMrE43XRPqK+4LRfGKFIh34JRNFR8e516EkKJ+U42pQjH2GbNrVEIluZODg443VCmPd/jXqKhAx2R8EgQzugCp57nbQl37RiljOdHEiQoX8yCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116057; c=relaxed/simple;
	bh=qSoTKgE4jMyLyDTrlqhE3/beC+15PWaMbrxuVLw+KQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6dfUj63aL7YTaxOYX9LIV2tUOKHLCgi/N4mpo6hVlvcuYiiyvTcwJ3r14oX0ww412qWcuZWzGsGtHMUv/OPZQw9el8gmjRTJ/GHhQ4fNINxgF6bRbS5Hbh+7lfppP4zBx/WKZ0BepPfFk6HklKp/ntJ5Zy1i9QfbxmDmbs1V2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqv6/U2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqv6/U2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EA31F000E9;
	Fri,  7 Aug 2026 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116056;
	bh=3ia6hxR3s1f1wik14bGCzqr9vdezNBcBf+UyI+rTonc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqv6/U2Hr3yTuJwh0TMINXAaicKkQlbeqfthGkuEeFl4XqKUWSaCFETilyyhEiw0K
	 gzeK8ND9BO0Bj2gWrONzMudL3v0XhCOEtdIpNlnWQ+fbQ6Mju4HUM0hEcfHSJTHJrU
	 nF1cRZhCbPVfOvd9gavx61PcOu836cgVCVpMgiOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 096/261] KVM: SVM: Update x2APIC MSR intercepts if AVIC is inhibited while L2 is active
Date: Fri,  7 Aug 2026 16:37:33 +0200
Message-ID: <20260807143417.455268074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -167,14 +167,6 @@ static void avic_deactivate_vmcb(struct
 	if (!sev_es_guest(svm->vcpu.kvm))
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
 	svm_set_x2apic_msr_interception(svm, true);
 }


