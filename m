Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A15B38F658;
	Thu, 17 Sep 2026 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671451; cv=none; b=VF8u5jiXw8HeriSsnORoefqxJuqwwUJTRaD77iAM4fYAyreV3zL6KtsxBpL43vLNwRVDpvc3WX2WrxX5JwcTumFOe7mvAFwk+AIWeQkNXlN16ZnOH/qg7+qv/1yWTwPPJzcTYZ/BK4KvAnux1lGeFGr0oIhwJuAFeFvbo/k1ycs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671451; c=relaxed/simple;
	bh=Am/AVhiHOKibMc2iJSEPMsORI5NtOdqp9NLOFhe8NhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ibr3ifcVQXvwn4ytL/pgcHSyEr88Ax+9xjN6/r7H5KuyN/Gg1Q6h5ZZB4izEll9sSvmBkQypNsNu+W3x9cNGF42CUdjd3gOV64xYYISESoxGSxDZcQX2qT3NMkKsLIGVJhuwD0e6e0EgauoLd1PyVEzOy3g0TC+sUKjKMSsxpn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCPVlu9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCPVlu9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFCC1F000FF;
	Thu, 17 Sep 2026 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671450;
	bh=5HUE1E/QTUp1IUzbxSQ/dbr8J2q88XuOie5+H3Hbw0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCPVlu9FoFqqDpUkSrZZUd9QKuvntitxtQsOgkztMKPtnZDxD5xcgG+1Dv9uiiq1S
	 JaJgUi+zZCQt7nDtziQ5UbKeNkbYH5QAfnkCrNrqPTL8aA5n6Aigk/Tt296pPfk+4P
	 uZTkATXNEbNO45g4X3EJLsWDxQbCMMYS1gzRolUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0981/1102] KVM: SVM: Move SEV-ES VMSA allocation to a dedicated sev_vcpu_create() helper
Date: Thu, 17 Sep 2026 16:15:24 +0100
Message-ID: <20260917151605.330485892@linuxfoundation.org>
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

[ Upstream commit 34bd82aab15b8b9e8e9d923267283c84aa8c2789 ]

Add a dedicated sev_vcpu_create() helper to allocate the VMSA page for
SEV-ES+ vCPUs, and to allow for consolidating a variety of related SEV+
code in the near future.

No functional change intended.

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Link: https://lore.kernel.org/r/20250819234833.3080255-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 42a39ad5d592 ("KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |   25 +++++++------------------
 arch/x86/kvm/svm/svm.h |    2 ++
 3 files changed, 29 insertions(+), 18 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4672,6 +4672,26 @@ void sev_init_vmcb(struct vcpu_svm *svm)
 		sev_es_init_vmcb(svm);
 }
 
+int sev_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct page *vmsa_page;
+
+	if (!sev_es_guest(vcpu->kvm))
+		return 0;
+
+	/*
+	 * SEV-ES guests require a separate (from the VMCB) VMSA page used to
+	 * contain the encrypted register state of the guest.
+	 */
+	vmsa_page = snp_safe_alloc_page();
+	if (!vmsa_page)
+		return -ENOMEM;
+
+	svm->sev_es.vmsa = page_address(vmsa_page);
+	return 0;
+}
+
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1433,7 +1433,6 @@ static int svm_vcpu_create(struct kvm_vc
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb01_page;
-	struct page *vmsa_page = NULL;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1444,24 +1443,18 @@ static int svm_vcpu_create(struct kvm_vc
 	if (!vmcb01_page)
 		goto out;
 
-	if (sev_es_guest(vcpu->kvm)) {
-		/*
-		 * SEV-ES guests require a separate VMSA page used to contain
-		 * the encrypted register state of the guest.
-		 */
-		vmsa_page = snp_safe_alloc_page();
-		if (!vmsa_page)
-			goto error_free_vmcb_page;
-	}
+	err = sev_vcpu_create(vcpu);
+	if (err)
+		goto error_free_vmcb_page;
 
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_vmsa_page;
+		goto error_free_sev;
 
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
-		goto error_free_vmsa_page;
+		goto error_free_sev;
 	}
 
 	svm->x2avic_msrs_intercepted = true;
@@ -1471,16 +1464,12 @@ static int svm_vcpu_create(struct kvm_vc
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
-		svm->sev_es.vmsa = page_address(vmsa_page);
-
 	svm->guest_state_loaded = false;
 
 	return 0;
 
-error_free_vmsa_page:
-	if (vmsa_page)
-		__free_page(vmsa_page);
+error_free_sev:
+	sev_free_vcpu(vcpu);
 error_free_vmcb_page:
 	__free_page(vmcb01_page);
 out:
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -759,6 +759,7 @@ static inline struct page *snp_safe_allo
 	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
 }
 
+int sev_vcpu_create(struct kvm_vcpu *vcpu);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
@@ -783,6 +784,7 @@ static inline struct page *snp_safe_allo
 	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
 }
 
+static inline int sev_vcpu_create(struct kvm_vcpu *vcpu) { return 0; }
 static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
 static inline void sev_vm_destroy(struct kvm *kvm) {}
 static inline void __init sev_set_cpu_caps(void) {}


