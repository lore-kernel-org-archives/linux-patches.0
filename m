Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72B633C1B6;
	Fri,  9 Jan 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961419; cv=none; b=cH1LounpBpe9MexuoM56xONSmt7zLJ1EET1Esgqacigd6wIdrhNxMMKIewhWsWJG0xgP+KxsSfZtKliMw/CounyPcebUG37f82aL/T1EeaSOAoKTSkAoEHbobjLEtAf0MBcPj7fCj33LLLVkGHd6+o2/Q/oo2qVMZUif/eekk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961419; c=relaxed/simple;
	bh=WVAL0M1h3P4g9CRuuoW76d0zchqi5xy8/uuQ7KDvTYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOK93NEmSF5bOx5ElFipaAz6gWlokjfGsP8Y8/zOXjQSaOh8k6zeoDffVzfG4p85AT5kcJdVI+hok4IeNEFsITW2E5QyLhKGNzOldDY+/1s4QawDs/pv8EuCNuxA48ybUeOXFSF3Zchj2d6yoejMFGj5AEUMXAJpqEP1qQhQdAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZF2XkPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZF2XkPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656F7C16AAE;
	Fri,  9 Jan 2026 12:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961417;
	bh=WVAL0M1h3P4g9CRuuoW76d0zchqi5xy8/uuQ7KDvTYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZF2XkPbL9f2nJrZvCT8JPibGh3lMjvPDbtPRLP6Q2II1N9Bkb6O2QHpTooKmzZOW
	 tug3acTp3lv7sfN+33RhH1RRQ7+dgHz+ybrNMsilFaakQnNa2wYviJHnP5GzZ0+5ym
	 qH16Jh+Yf+ZNnTexI+++adL19C0KgVmhZbeJTH8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 705/737] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Date: Fri,  9 Jan 2026 12:44:04 +0100
Message-ID: <20260109112200.593371613@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1017,6 +1017,9 @@ static void svm_recalc_lbr_msr_intercept
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool intercept = !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
 
+	if (intercept == svm->lbr_msrs_intercepted)
+		return;
+
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP,
 			     !intercept, !intercept);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP,
@@ -1029,6 +1032,8 @@ static void svm_recalc_lbr_msr_intercept
 	if (sev_es_guest(vcpu->kvm))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR,
 				     !intercept, !intercept);
+
+	svm->lbr_msrs_intercepted = intercept;
 }
 
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
@@ -1473,6 +1478,7 @@ static int svm_vcpu_create(struct kvm_vc
 	}
 
 	svm->x2avic_msrs_intercepted = true;
+	svm->lbr_msrs_intercepted = true;
 
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -288,6 +288,7 @@ struct vcpu_svm {
 	bool guest_state_loaded;
 
 	bool x2avic_msrs_intercepted;
+	bool lbr_msrs_intercepted;
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;


