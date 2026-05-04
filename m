Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43F3DE428;
	Mon,  4 May 2026 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904126; cv=none; b=LuY7qCzKptZjYuWGy5fJ0mXqvInHRmjP0+LXxI6dwnImQnwB09+zlj6kZ/SETBFjbWWi3Y4TP3X5gg7CUXg2uxVvLOEQCLRmeTWaooncWbDkzLRvK10a9dUkiLGQHMYuaY9HVwy8loGi1xZD8xCApXcNffo1P9VXxVR1QM02RFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904126; c=relaxed/simple;
	bh=m83WUHNqreu0g6B6l76VJILXnWpRLa+iMomYfL3Wma8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hA+g4D8rvAFO84zc3Mc/MgUJ/0m3eIHH7LjnriHYvTf2HMhD43rcwrjU7Cr/hT3yeP0j45bcO8IHAZYpLdjUzLTVgs85kdWMB4Pwh73Mg7iGCVin57r0FfWXEgqBp4JVbA4sYLkgd7ShY+5uBBC/ujQcvWQnKNX/QYA7XNuatyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x22a8mOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x22a8mOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90D1C2BCC4;
	Mon,  4 May 2026 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904126;
	bh=m83WUHNqreu0g6B6l76VJILXnWpRLa+iMomYfL3Wma8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x22a8mOjd2SkF0arvF2AhKdagcDko5F/4EMUnmy1WD0hvJ6KEfHxVl9Nx9YodL/Xa
	 C23xuI4mB4F3tdd0ijo6EdGBv6X/Iv+yRDkfbfqxFFEFXP/rBlnPiFFittK7By3jUt
	 vNJ+hV4SlFnBlzMKBenTsBNmXJEt8lqKYxEaNeJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 6.18 192/275] KVM: nSVM: Raise #UD if unhandled VMMCALL isnt intercepted by L1
Date: Mon,  4 May 2026 15:52:12 +0200
Message-ID: <20260504135150.211491239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1672,9 +1672,7 @@ int nested_svm_exit_special(struct vcpu_
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
 
@@ -3177,6 +3178,22 @@ static int bus_lock_exit(struct kvm_vcpu
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
@@ -3227,7 +3244,7 @@ static int (*const svm_exit_handlers[])(
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,


