Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053B385D7B;
	Sat, 17 Oct 2026 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258675; cv=none; b=AtTm5rRUutk72p1JbA80pjx+ox69IPBucr8phpa1g/nuwY5/Jc6bAivL5147nW1Zgtcq3uHWjsqtGf6cXc78cKgMO3GfKqr+XyIoz8ClEfE4JzxVufY/R+QPZjNA2yWtGT8maqUHD1DndJtQHou2PsvvNCNT9aOOWfAtmi9KrDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258675; c=relaxed/simple;
	bh=szvWzYQ7dQtYfX3YgqtUBoMJvEe7Kn/ERRm5zPBwMUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poqP8N+VUxfbsdLDZdiv0H9N/Qn/7M72Q9Judnftr/PspIh68QQw21ubDrpB7D9fLYG2r9RS7Yc1ZtYXuVVrE0jlSmdiKe0MPtNiXDjtsnuL41s0oxjtdxY3NAlhIrCR8uJgtR1e0OK1vEqDQQV75xR9KSPBsohxHgNsIvK11HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWv3X7O9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWv3X7O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB9D1F000C4;
	Sat, 17 Oct 2026 17:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258673;
	bh=Em76Xug7tI59DrALxCgmKUROI7tC6YtONOpFbfWJbh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWv3X7O9D/kipqmj4zZHDKBvVkPn/a3fH67jpkZVPrwzJFWd+eRHsK47yRcio2ko1
	 dUrt9XKN30Vjf8E2XAZ+SovxRzwCwGcamPSbC3feQ1sRzOx6nWtTuElpsYTo5gknVI
	 FU4BWR/FjA44UCUYMPVIS63UoxZeGmI/dPlRD+tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0961/1674] KVM: nSVM: Raise #UD if unhandled VMMCALL isnt intercepted by L1
Date: Sat, 17 Oct 2026 17:53:53 +0200
Message-ID: <20261017160455.792244189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Kevin Cheng <chengkev@google.com>

[ Upstream commit c36991c6f8d2ab56ee67aff04e3c357f45cfc76c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/hyperv.h |  7 +++++++
 arch/x86/kvm/svm/nested.c |  4 +---
 arch/x86/kvm/svm/svm.c    | 19 ++++++++++++++++++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 02f4784b5d446..1970f09fce9f4 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -40,6 +40,13 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
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
 
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bdcfcc492dec8..432d188b2f3c9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1548,9 +1548,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index df8bc8def019b..8844f49d3e7f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -49,6 +49,7 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
@@ -3300,6 +3301,22 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
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
@@ -3350,7 +3367,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
-- 
2.53.0



