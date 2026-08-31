Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424D9492188;
	Mon, 31 Aug 2026 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183512; cv=none; b=CGOIFM4h+6cYv25aqoJXld3az2kzDmBYeP+aL1jrgr3KPvH07IO6cVjMF8gcQnrlFCBcWDnUODeyKCpz8mpfpdN19QJCT3CCJxo+FDgouith61bAoX04Gh9PHM4CnsvVFRD0VT8qJxwG7qzmjWsz8Fx+0wxDTeh+X3jA5hp02YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183512; c=relaxed/simple;
	bh=FPiUCaZVLGScb98tU+97a6HYSEfmsiOvBd9JCR3LtD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSl2ZmEFBM2aiKU/bRpZL+R+1XOYW+p9GmKG+Ohg4IsqSUcmrBzlpqhTkIk955OIw0BBCuDeyPjM9jO/Q8UhJW3HtSclumR5cSePnGN40qlQO/DZvqba/rqb9ZkbGeii0+vQzJbMu/QD90vX6amn6ZdN/91hjGvoidijPxBpXZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlX2muW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlX2muW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950001F00ACA;
	Mon, 31 Aug 2026 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183511;
	bh=6D3pVCi4Plm4bBrUf5GZ5FwLipEOLeleOCgpz5QU44s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlX2muW+vBXdQ0gOWLCvJmNkWQrNNv5gzBg7rJERhu1YvWqI3CXrVLrFpHL21ou/H
	 nyDyFdefpdmPj1RF6d+uQVycs6B1TO1310l5legLlbXdq0HtjydTdt+xVvxso8+RQK
	 8BemJHrkxgOtOIrIUyuYxrQQjJTOoFC05czUubwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 23/71] KVM: SEV: Extract loading of guest-provided VMSA to a separate helper
Date: Mon, 31 Aug 2026 15:33:48 +0200
Message-ID: <20260831133400.250938890@linuxfoundation.org>
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

commit 0060569e4f18a7dee2dd8728595e909f19a23c24 upstream.

Extract the loading/retrieval of a guest-provided VMSA to a separate helper
so that KVM can reuse the core logic when refreshing the VMSA after an MMU
invalidation from guest_memfd.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   52 +++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4021,29 +4021,17 @@ static int snp_begin_psc(struct vcpu_svm
 	return snp_do_psc(svm);
 }
 
-/*
- * Invoked as part of svm_vcpu_reset() processing of an init event.
- */
-static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+static void sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa_to_gfn(gpa);
 	struct page *page;
 	kvm_pfn_t pfn;
-	gfn_t gfn;
-
-	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
 
-	if (!svm->sev_es.snp_ap_waiting_for_reset)
-		return;
-
-	svm->sev_es.snp_ap_waiting_for_reset = false;
+	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
 
-	/* Mark the vCPU as offline and not runnable */
-	vcpu->arch.pv.pv_unhalted = false;
-	kvm_set_mp_state(vcpu, KVM_MP_STATE_HALTED);
-
-	/* Clear use of the VMSA */
+	/* Clear use of the VMSA. */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
@@ -4053,12 +4041,9 @@ static void sev_snp_init_protected_guest
 	 */
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	if (!VALID_PAGE(svm->sev_es.snp_pending_vmsa_gpa))
+	if (!VALID_PAGE(gpa))
 		return;
 
-	gfn = gpa_to_gfn(svm->sev_es.snp_pending_vmsa_gpa);
-	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
-
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
 		return;
@@ -4082,7 +4067,7 @@ static void sev_snp_init_protected_guest
 	svm->sev_es.snp_has_guest_vmsa = true;
 
 	/* Use the new VMSA */
-	svm->sev_es.snp_guest_vmsa_gpa = gfn_to_gpa(gfn);
+	svm->sev_es.snp_guest_vmsa_gpa = gpa;
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
 	/* Mark the vCPU as runnable */
@@ -4096,6 +4081,31 @@ static void sev_snp_init_protected_guest
 	kvm_release_page_clean(page);
 }
 
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	gpa_t gpa;
+
+	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_waiting_for_reset)
+		return;
+
+	svm->sev_es.snp_ap_waiting_for_reset = false;
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_HALTED);
+
+	gpa = svm->sev_es.snp_pending_vmsa_gpa;
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
+
+	sev_snp_reload_vmsa(vcpu, gpa);
+}
+
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
 {
 	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);


