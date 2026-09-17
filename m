Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B313354707D;
	Thu, 17 Sep 2026 18:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671443; cv=none; b=gME+Wj8/1O0tlMx2mZjf3g5FH9l2FPjnAEZAmMkMUemvFaESpQO0R1sRGvfXQ0BQTYo5/sqDr5DbnjGOzkoWECU91jdhg5FTco+gdJqxNxTZAPcAznh8ubGSznF0k1eT1neuET1SAUIHgFswl5NgjqtmRUhOy7hrIKQ4tNVcjsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671443; c=relaxed/simple;
	bh=ihEpUb5xaiHy+iuUfFkotXmLuas7FShSUUOrATlQrEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIoP0clXTlCIPVNO8Btpa98b7LzseuouzrCuOxkJhrUUtxL1fY5ppNufdtmHDvhPo9Re+cuOXByqhVHHJi0CkRMl+3uuQR3wGvKwsGLOuk8GBLp9hBWbjPUC/P57UWM8AImxaf7MhvxrpCTxYop4j6OssSTWd7Nh3RqWzhy7dr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okFd/h7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okFd/h7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93E41F000FF;
	Thu, 17 Sep 2026 18:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671441;
	bh=Y4k2dRQKJm6dXedQCHEndNkkoBVFFdvtJmXXBgGGruw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okFd/h7T0OB5MPc4JcM/AuPlX0WJMgbcCQM03GlPkN8J1nLBSG2xt3/Bk04zb+Qlv
	 5d4GGXlOpEI5wgn8+zI2NvwkXaYMYwAgRkIXsFXzlkcv8PTxzyn7X1R2zsmxS0DQVM
	 XBxx7Ll59T2hQAVW/nbPHMQ2KvDhyTRva3fwNfvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0978/1102] KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
Date: Thu, 17 Sep 2026 16:15:21 +0100
Message-ID: <20260917151605.250671899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5279d6f7e43d9c5863411482943200bf5ab8a261 ]

Use guard(mutex) in sev_snp_init_protected_guest_state() and pull in its
lock-protected inner helper.  Without an unlock trampoline (and even with
one), there is no real need for an inner helper.  Eliminating the helper
also avoids having to fixup the open coded "lockdep" WARN_ON().

Opportunistically drop the error message if KVM can't obtain the pfn for
the new target VMSA.  The error message provides zero information that
can't be gleaned from the fact that the vCPU is stuck.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250227012541.3234589-10-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

[ This tree lacks upstream commit 1fbee5b01a0fd ("KVM: guest_memfd:
  Provide "struct page" as output from kvm_gmem_get_pfn()"), so its
  kvm_gmem_get_pfn() still uses the older pfn-only signature (no
  struct page **).  Adapted the refactored
  sev_snp_init_protected_guest_state() to keep calling
  kvm_gmem_get_pfn() without a page argument and to use
  kvm_release_pfn_clean(pfn) instead of kvm_release_page_clean(page). ]

Stable-dep-of: 42a39ad5d592 ("KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |  114 +++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 65 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3911,11 +3911,25 @@ next_range:
 	BUG();
 }
 
-static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_memory_slot *slot;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
 
-	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+	if (!svm->sev_es.snp_ap_waiting_for_reset)
+		return;
+
+	svm->sev_es.snp_ap_waiting_for_reset = false;
 
 	/* Mark the vCPU as offline and not runnable */
 	vcpu->arch.pv.pv_unhalted = false;
@@ -3930,78 +3944,48 @@ static int __sev_snp_update_protected_gu
 	 */
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
-		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
-		struct kvm_memory_slot *slot;
-		kvm_pfn_t pfn;
-
-		slot = gfn_to_memslot(vcpu->kvm, gfn);
-		if (!slot)
-			return -EINVAL;
-
-		/*
-		 * The new VMSA will be private memory guest memory, so
-		 * retrieve the PFN from the gmem backend.
-		 */
-		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
-			return -EINVAL;
-
-		/*
-		 * From this point forward, the VMSA will always be a
-		 * guest-mapped page rather than the initial one allocated
-		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
-		 * could be free'd and cleaned up here, but that involves
-		 * cleanups like wbinvd_on_all_cpus() which would ideally
-		 * be handled during teardown rather than guest boot.
-		 * Deferring that also allows the existing logic for SEV-ES
-		 * VMSAs to be re-used with minimal SNP-specific changes.
-		 */
-		svm->sev_es.snp_has_guest_vmsa = true;
-
-		/* Use the new VMSA */
-		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
-
-		/* Mark the vCPU as runnable */
-		vcpu->arch.pv.pv_unhalted = false;
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-
-		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-
-		/*
-		 * gmem pages aren't currently migratable, but if this ever
-		 * changes then care should be taken to ensure
-		 * svm->sev_es.vmsa is pinned through some other means.
-		 */
-		kvm_release_pfn_clean(pfn);
-	}
+	if (!VALID_PAGE(svm->sev_es.snp_vmsa_gpa))
+		return;
 
-	return 0;
-}
+	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
 
-/*
- * Invoked as part of svm_vcpu_reset() processing of an init event.
- */
-void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret;
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!slot)
+		return;
 
-	if (!sev_snp_guest(vcpu->kvm))
+	/*
+	 * The new VMSA will be private memory guest memory, so retrieve the
+	 * PFN from the gmem backend.
+	 */
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
 		return;
 
-	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
+	/*
+	 * From this point forward, the VMSA will always be a guest-mapped page
+	 * rather than the initial one allocated by KVM in svm->sev_es.vmsa. In
+	 * theory, svm->sev_es.vmsa could be free'd and cleaned up here, but
+	 * that involves cleanups like wbinvd_on_all_cpus() which would ideally
+	 * be handled during teardown rather than guest boot.  Deferring that
+	 * also allows the existing logic for SEV-ES VMSAs to be re-used with
+	 * minimal SNP-specific changes.
+	 */
+	svm->sev_es.snp_has_guest_vmsa = true;
 
-	if (!svm->sev_es.snp_ap_waiting_for_reset)
-		goto unlock;
+	/* Use the new VMSA */
+	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
-	svm->sev_es.snp_ap_waiting_for_reset = false;
+	/* Mark the vCPU as runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-	ret = __sev_snp_update_protected_guest_state(vcpu);
-	if (ret)
-		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 
-unlock:
-	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+	/*
+	 * gmem pages aren't currently migratable, but if this ever changes
+	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
+	 * through some other means.
+	 */
+	kvm_release_pfn_clean(pfn);
 }
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)


