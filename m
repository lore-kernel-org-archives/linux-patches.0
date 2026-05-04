Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8200D3DE45B;
	Mon,  4 May 2026 14:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904682; cv=none; b=X1EllwSvEzG0F/IuGOWXPElMh2ZLhZAmXox94KcBiBlBbRqRDZ/YTxOAiy5l/TXQdVjCDzKXher5OuqtqFp24h8GoyqqE7pudfQ2TCOmn9OMe6WCpAlJr7FDCvjgAiua3ALEdPFsAubnPNYMJH4glp/GnXyBYt8zap6pQikTkZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904682; c=relaxed/simple;
	bh=1plkIr0JUitPX04WqZDngTr15Jo3wjeYFs+4vLwn7/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKmNtHeol03TYKjfybk3wUm3H+ZOlpvk7dIU2TPlgLsBS8HK6lYFC/kRyHtldwwRPAB1ejiO6niLn/IuxAFGfc65OD0vgbCYxCnY01tlQR2qZUFW5ARrxFQcErweRLs9flODGD64L8n9u4vYW6q/6/UM9FdWNY62bbcOmppbhpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzUn1PkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzUn1PkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E87C2BCB8;
	Mon,  4 May 2026 14:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904682;
	bh=1plkIr0JUitPX04WqZDngTr15Jo3wjeYFs+4vLwn7/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzUn1PkV7t2YfOLR+Q0nW2/i1BGC/dRZZfA7TOrMQRepOQFw30Qo+AfkuYdq8Sv5r
	 FD8y7L8ELn23+4wyEIuAxiO0ZZNmVBetQ0vlOYQW9eR4wCkux1gBtzq3OJ8t+MeRNP
	 v8z9wT/7nsm0/nIL8jgYIInuElrLBUT/wbWYyUhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 6.12 132/215] KVM: nSVM: Raise #UD if unhandled VMMCALL isnt intercepted by L1
Date: Mon,  4 May 2026 15:52:31 +0200
Message-ID: <20260504135134.972524849@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -304,14 +304,6 @@ static inline bool kvm_hv_has_stimer_pen
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
@@ -1532,9 +1532,7 @@ int nested_svm_exit_special(struct vcpu_
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
@@ -49,6 +49,7 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
@@ -3377,6 +3378,22 @@ static int invpcid_interception(struct k
 	return kvm_handle_invpcid(vcpu, type, gva);
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
@@ -3427,7 +3444,7 @@ static int (*const svm_exit_handlers[])(
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,


