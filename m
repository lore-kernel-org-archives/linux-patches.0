Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F80509EFC;
	Mon, 31 Aug 2026 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183753; cv=none; b=nPl/syl1Y9IyY1opd7BEZ1z4q2Q6lNHw5pXW/vcmAR+lUAKlKRux8RPvnJjWzPY8hsoaaLZ+TnRt6HxJnfJxCSxZ5LhXzxIL7qZAJxHXS6qepAjSAZZxFCTCQwhZJZdxJkgv8Pq7Tp2PBknSDKFkokPwf0z5NFPIyEAoaRnqjuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183753; c=relaxed/simple;
	bh=t1MG7w9cPqOAdaCYpbGTw6c2H4hksYdfwM0PKUXuk9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvwantgvbvhmSrRxqd/G8MSHVRK9V5F9m3EaYwwSWSJ7W7vmTgjR8aratolxuppPaIxFASuBhdM0aCQPw+CFbfrfXR++JRrLscVsGE6csYZ0ShpKEI4K+XfW07kKo3eMWHuwLt49raSgbLBsWPk11b1nJ8yN7VYj65SNnDC3YwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcDsa2H8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcDsa2H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DBC1F00ACA;
	Mon, 31 Aug 2026 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183750;
	bh=IqR5M6+j1DzPiDtcu/FrSxhIlfoWBmQPZ+w9Jgy92H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcDsa2H8q7gUGlS8t6WJEqowcXAm4LJCpZP8OYgSgxKxiKZhrKny5GJVzWzmIpwaX
	 RXK0vRtYMSErqaQw8xWq0cReC+HA3srVId6rccn/Vs6Nj19tLSR/+7UacQWbld30t1
	 r3qtPqUia9WClcnMBdhvUl73zsa0FuBOLo7QYT2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 30/76] KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests
Date: Mon, 31 Aug 2026 15:34:02 +0200
Message-ID: <20260831133400.883126074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

commit 42a39ad5d592aec87a70527a4e694f6210694482 upstream.

Track the GPA of the guest-provided VMSA used after AP_CREATION events when
running SNP guests, instead of simply tracking whether or not the vCPU is
using a guest-provided VMSA.  KVM needs to know the GPA of the VMSA that's
actively being used so that it can react to MMU invalidation events, i.e.
so that KVM can drop the VMSA if its backing guest_memfd page is punched
out of existence.

Opportunistically rename snp_vmsa_gpa to clarify that it tracks the pending
VMSA GPA, whereas snp_guest_vmsa_gpa now tracks the in-use VMSA GPA.

Note!  Take care to track the GPA, not the GFN, as VALID_PAGE() won't
behave correctly if an invalid GFN is converted to a GPA for checking.

Note #2!  Keep snp_has_guest_vmsa so that switching to a guest-provided
VMSA is sticky, even if the guest-provided VMSA becomes invalid.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   14 +++++++++-----
 arch/x86/kvm/svm/svm.h |    3 ++-
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4109,6 +4109,7 @@ static void sev_snp_init_protected_guest
 
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
 	/*
 	 * When replacing the VMSA during SEV-SNP AP creation,
@@ -4116,11 +4117,11 @@ static void sev_snp_init_protected_guest
 	 */
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	if (!VALID_PAGE(svm->sev_es.snp_vmsa_gpa))
+	if (!VALID_PAGE(svm->sev_es.snp_pending_vmsa_gpa))
 		return;
 
-	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
-	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+	gfn = gpa_to_gfn(svm->sev_es.snp_pending_vmsa_gpa);
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
 
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
@@ -4145,6 +4146,7 @@ static void sev_snp_init_protected_guest
 	svm->sev_es.snp_has_guest_vmsa = true;
 
 	/* Use the new VMSA */
+	svm->sev_es.snp_guest_vmsa_gpa = gfn_to_gpa(gfn);
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
 	/* Mark the vCPU as runnable */
@@ -4211,10 +4213,10 @@ static int sev_snp_ap_creation(struct vc
 			return -EINVAL;
 		}
 
-		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+		target_svm->sev_es.snp_pending_vmsa_gpa = svm->vmcb->control.exit_info_2;
 		break;
 	case SVM_VMGEXIT_AP_DESTROY:
-		target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+		target_svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
 		break;
 	default:
 		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
@@ -4840,6 +4842,8 @@ int sev_vcpu_create(struct kvm_vcpu *vcp
 		return -ENOMEM;
 
 	svm->sev_es.vmsa = page_address(vmsa_page);
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
+	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
 	vcpu->arch.guest_tsc_protected = snp_is_secure_tsc_enabled(vcpu->kvm);
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -268,7 +268,8 @@ struct vcpu_sev_es_state {
 	u64 ghcb_registered_gpa;
 
 	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
-	gpa_t snp_vmsa_gpa;
+	gpa_t snp_pending_vmsa_gpa;
+	gpa_t snp_guest_vmsa_gpa;
 	bool snp_ap_waiting_for_reset;
 	bool snp_has_guest_vmsa;
 };


