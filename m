Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E91A2D8DDF;
	Mon,  4 May 2026 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903421; cv=none; b=SPJfslZCh9vSAmCMbzDdk2fH+3gAGiTsEpmkGu9S8AbKU3wcCipbeVCoVWBlo6Vqu3/VKsudHJMJEcj7nXkiVeK1teyEKr8muindtI9YlSbLT1tsfYm1ASU6j8mIa22/ZO7v3t16hX/TkpYDyq2XVIhqViVtoLEmCf8Tk1Gu/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903421; c=relaxed/simple;
	bh=j8rj+PfAnDoVpK4PgMfW7un/R+zR7VrPBttzlst0Lag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg5uq3TGQmFjetlxB7sR5btp2bjMUYcbbUuclVjmOiFLd8C5iwRfDc9C/xdNdeNRRRDc9BEAQkglSzFcvp6BamV+Zyl2xJrVLry9j2oHucYSEhFUXGxznb6RGLtRiupYi3j6DZ5i0ShtkWY99/3ine0LvNxiE1PECY+ljrVHplA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETlOl078; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETlOl078"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E0C2BCB8;
	Mon,  4 May 2026 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903421;
	bh=j8rj+PfAnDoVpK4PgMfW7un/R+zR7VrPBttzlst0Lag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETlOl0786B+UCYQhyvxPtAZf+ynnaW4LpkskxmnfxPumq736yl78F+pSQaCBmmf76
	 PUaIde/FcYV8jGdvxT0TyCa64ItrLZkS1CW75H3VuXoO99301SZvEM2YlrQKfeDu10
	 FDm/u1Cdv+qwlofoxuT4UMxrpzpc3cUNi6T71N+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 7.0 227/307] KVM: nSVM: Raise #UD if unhandled VMMCALL isnt intercepted by L1
Date: Mon,  4 May 2026 15:51:52 +0200
Message-ID: <20260504135151.398368148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cheng <chengkev@google.com>

commit c36991c6f8d2ab56ee67aff04e3c357f45cfc76c upstream.

Explicitly synthesize a #UD for VMMCALL if L2 is active, L1 does NOT want
to intercept VMMCALL, nested_svm_l2_tlb_flush_enabled() is true, and the
hypercall is something other than one of the supported Hyper-V hypercalls.
When all of the above conditions are met, KVM will intercept VMMCALL but
never forward it to L1, i.e. will let L2 make hypercalls as if it were L1.

The TLFS says a whole lot of nothing about this scenario, so go with the
architectural behavior, which says that VMMCALL #UDs if it's not
intercepted.

Opportunistically do a 2-for-1 stub trade by stub-ifying the new API
instead of the helpers it uses.  The last remaining "single" stub will
soon be dropped as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Fixes: 3f4a812edf5c ("KVM: nSVM: hyper-v: Enable L2 TLB flush")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Cheng <chengkev@google.com>
Link: https://patch.msgid.link/20260228033328.2285047-5-chengkev@google.com
[sean: rewrite changelog and comment, tag for stable, remove defunct stubs]
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://patch.msgid.link/20260304002223.1105129-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.h     |    8 --------
 arch/x86/kvm/svm/hyperv.h |   11 +++++++++++
 arch/x86/kvm/svm/nested.c |    4 +---
 arch/x86/kvm/svm/svm.c    |   19 ++++++++++++++++++-
 4 files changed, 30 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -305,14 +305,6 @@ static inline bool kvm_hv_has_stimer_pen
 {
 	return false;
 }
-static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
 static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
 {
 	return 0;
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -41,6 +41,13 @@ static inline bool nested_svm_l2_tlb_flu
 	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
 }
 
+static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
+	       nested_svm_l2_tlb_flush_enabled(vcpu) &&
+	       kvm_hv_is_tlb_flush_hcall(vcpu);
+}
+
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else /* CONFIG_KVM_HYPERV */
 static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
@@ -48,6 +55,10 @@ static inline bool nested_svm_l2_tlb_flu
 {
 	return false;
 }
+static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 static inline void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu) {}
 #endif /* CONFIG_KVM_HYPERV */
 
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1711,9 +1711,7 @@ int nested_svm_exit_special(struct vcpu_
 	}
 	case SVM_EXIT_VMMCALL:
 		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
-		if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
-		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
-		    kvm_hv_is_tlb_flush_hcall(vcpu))
+		if (nested_svm_is_l2_tlb_flush_hcall(vcpu))
 			return NESTED_EXIT_HOST;
 		break;
 	default:
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -52,6 +52,7 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
@@ -3249,6 +3250,22 @@ static int bus_lock_exit(struct kvm_vcpu
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Inject a #UD if L2 is active and the VMMCALL isn't a Hyper-V TLB
+	 * hypercall, as VMMCALL #UDs if it's not intercepted, and this path is
+	 * reachable if and only if L1 doesn't want to intercept VMMCALL or has
+	 * enabled L0 (KVM) handling of Hyper-V L2 TLB flush hypercalls.
+	 */
+	if (is_guest_mode(vcpu) && !nested_svm_is_l2_tlb_flush_hcall(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_emulate_hypercall(vcpu);
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3299,7 +3316,7 @@ static int (*const svm_exit_handlers[])(
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,


