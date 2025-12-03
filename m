Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACCE349B14;
	Wed,  3 Dec 2025 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780905; cv=none; b=HyXlODc3VhamMGhXVmiCVoerDN8qEHRsZceebp56nVrI4I+FPLCIee315kPpUqaOYjVLZjy/3+xrmqBSK1VWuQ3siRfTUMQB46Vq5+HTJa8H/8pHL9ztsOoL2v7OX1Os0QbLsOq3pP/fY2lFqrEiuAlSdptpec7BQ4uY0W9dqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780905; c=relaxed/simple;
	bh=0fmVTcHDptkF2ATrtYkLbXsWbxDxGQR+DydRN1wsUjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci1npo6N5gqSCY7kg0eZaNdbUI5zLGNDZ/9P9jMEUyYCPEp5rSogdcKONtrZiUkes4eGFFCOU9yaKwM8nuHilwKVA9x9BU0h+dfRVRovFL9FJk9cHmMLBAF+Sj2R6mk7UYXJnBr00defNZGpIaI8Kf/ubqa8ZS4zVW1whZGtyZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0I1EpsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0I1EpsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E02C4CEF5;
	Wed,  3 Dec 2025 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780905;
	bh=0fmVTcHDptkF2ATrtYkLbXsWbxDxGQR+DydRN1wsUjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0I1EpsImu8rLUcsW5eP5Q5TcBRAWbdTa+56p1171/f8IH7VDiZHH2TNmGD3oxWL1
	 LQOhnbaiPrYZoY+pC+4ybC6J+pS8+Xi+lNvaiSjow9gZfqKHBCw9bCUS+lG8dZYEJg
	 +GlEQ1rc+xzo5gtcsEEC6EdVceKhj7yJCGyaCwn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 124/132] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Date: Wed,  3 Dec 2025 16:30:03 +0100
Message-ID: <20251203152347.907510018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit 3fa05f96fc08dff5e846c2cc283a249c1bf029a1 upstream.

Don't update the LBR MSR intercept bitmaps if they're already up-to-date,
as unconditionally updating the intercepts forces KVM to recalculate the
MSR bitmaps for vmcb02 on every nested VMRUN.  The redundant updates are
functionally okay; however, they neuter an optimization in Hyper-V
nested virtualization enlightenments and this manifests as a self-test
failure.

In particular, Hyper-V lets L1 mark "nested enlightenments" as clean, i.e.
tell KVM that no changes were made to the MSR bitmap since the last VMRUN.
The hyperv_svm_test KVM selftest intentionally changes the MSR bitmap
"without telling KVM about it" to verify that KVM honors the clean hint,
correctly fails because KVM notices the changed bitmap anyway:

  ==== Test Assertion Failure ====
  x86/hyperv_svm_test.c:120: vmcb->control.exit_code == 0x081
  pid=193558 tid=193558 errno=4 - Interrupted system call
     1	0x0000000000411361: assert_on_unhandled_exception at processor.c:659
     2	0x0000000000406186: _vcpu_run at kvm_util.c:1699
     3	 (inlined by) vcpu_run at kvm_util.c:1710
     4	0x0000000000401f2a: main at hyperv_svm_test.c:175
     5	0x000000000041d0d3: __libc_start_call_main at libc-start.o:?
     6	0x000000000041f27c: __libc_start_main_impl at ??:?
     7	0x00000000004021a0: _start at ??:?
  vmcb->control.exit_code == SVM_EXIT_VMMCALL

Do *not* fix this by skipping svm_hv_vmcb_dirty_nested_enlightenments()
when svm_set_intercept_for_msr() performs a no-op change.  changes to
the L0 MSR interception bitmap are only triggered by full CPUID updates
and MSR filter updates, both of which should be rare.  Changing
svm_set_intercept_for_msr() risks hiding unintended pessimizations
like this one, and is actually more complex than this change.

Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251112013017.1836863-1-yosry.ahmed@linux.dev
[Rewritten commit message based on mailing list discussion. - Paolo]
Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    6 ++++++
 arch/x86/kvm/svm/svm.h |    1 +
 2 files changed, 7 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1000,6 +1000,9 @@ static void svm_recalc_lbr_msr_intercept
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool intercept = !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
 
+	if (intercept == svm->lbr_msrs_intercepted)
+		return;
+
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP,
 			     !intercept, !intercept);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP,
@@ -1012,6 +1015,8 @@ static void svm_recalc_lbr_msr_intercept
 	if (sev_es_guest(vcpu->kvm))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR,
 				     !intercept, !intercept);
+
+	svm->lbr_msrs_intercepted = intercept;
 }
 
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
@@ -1450,6 +1455,7 @@ static int svm_vcpu_create(struct kvm_vc
 	}
 
 	svm->x2avic_msrs_intercepted = true;
+	svm->lbr_msrs_intercepted = true;
 
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -324,6 +324,7 @@ struct vcpu_svm {
 	bool guest_state_loaded;
 
 	bool x2avic_msrs_intercepted;
+	bool lbr_msrs_intercepted;
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;


