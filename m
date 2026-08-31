Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F3048F853;
	Mon, 31 Aug 2026 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183509; cv=none; b=setOCaEVBPVVO5GmAEc8q60AZRvNu59J5oJu+i++VQrTVldYY273v0TUYN0AjudH+bNS3jJp4cRKPclWtftBNdbonRtLA/ebSs89qm4cMt+I5gQtZFLQVNWLaUyMIRoW42DjsB6md9FRl/Kw5DOXY19ZYsuLYkuhND+Ieews/XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183509; c=relaxed/simple;
	bh=0As4kzs1DChT4fg0oMzfwHQj+6tyXv09+duGEmuxIjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW4eS2ijB1/u3PKdBOlqmpT2g87qTaHI3PNO+XyBGeahQhGfKLJW3azxji/4ZgGkoKcl913bOsAPhanIE1HHKld5rs3wCOobNunRVtf1O7qbUTa2J+QHgnTvc/G5FdhYpDWa4NOKZbnKWZy8DvOJTeT4AyNtCZZw3UchcLCfyCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxjggDeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxjggDeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0BA1F00A3D;
	Mon, 31 Aug 2026 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183508;
	bh=b/U2Ka8WrmP1zhreHw65Kfq2/fDo4CWpKEMzh+7S/ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxjggDeF5p9HPc6OnSPUPlnQ4Y+cgwc5OwJbM/1cDUWTpHODNKG3hv/GCsAJ4w3IT
	 vbg87yClQ03J/2RxOn8eHPY8V40FP431nHSBHgImfHjvPDu+v3ZeJNrmOnn1OKADnR
	 0GpK6E2SjGq3lgW965kl/QCCRL0D/LxnyAPnXkt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 22/71] KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests
Date: Mon, 31 Aug 2026 15:33:47 +0200
Message-ID: <20260831133400.195190318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4045,6 +4045,7 @@ static void sev_snp_init_protected_guest
 
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
 	/*
 	 * When replacing the VMSA during SEV-SNP AP creation,
@@ -4052,11 +4053,11 @@ static void sev_snp_init_protected_guest
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
@@ -4081,6 +4082,7 @@ static void sev_snp_init_protected_guest
 	svm->sev_es.snp_has_guest_vmsa = true;
 
 	/* Use the new VMSA */
+	svm->sev_es.snp_guest_vmsa_gpa = gfn_to_gpa(gfn);
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
 	/* Mark the vCPU as runnable */
@@ -4147,10 +4149,10 @@ static int sev_snp_ap_creation(struct vc
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
@@ -4833,6 +4835,8 @@ int sev_vcpu_create(struct kvm_vcpu *vcp
 		return -ENOMEM;
 
 	svm->sev_es.vmsa = page_address(vmsa_page);
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
+	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
 	vcpu->arch.guest_tsc_protected = snp_is_secure_tsc_enabled(vcpu->kvm);
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -272,7 +272,8 @@ struct vcpu_sev_es_state {
 	u64 ghcb_registered_gpa;
 
 	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
-	gpa_t snp_vmsa_gpa;
+	gpa_t snp_pending_vmsa_gpa;
+	gpa_t snp_guest_vmsa_gpa;
 	bool snp_ap_waiting_for_reset;
 	bool snp_has_guest_vmsa;
 };


