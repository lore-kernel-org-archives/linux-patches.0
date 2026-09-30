Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0A73438A6;
	Wed, 30 Sep 2026 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788065; cv=none; b=WE4T81Q4X3k8TlwPzGGMArUk76P+DU1iP89nbVv0K2BvLjCAAbBgqb8BQ7uUaDkHKH7EWmTFq90X9vw61wzqZErOy+aflmdSKEyTGFuFynJ4LGMj/qIfu9kEALdM06sayyLmjvKg4W+lOyOIRunQgonbE3jGJx6yhawPDik4gQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788065; c=relaxed/simple;
	bh=rXkZBtsrwmiXwaQTK0ZLx1xAo6JUUOhqNgc7qiM/TJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7Tly53u3N0i2/oL83L+5gr5h7LJikk9EyLlDTTJ2hPCtRonL8Vg0nNx2Qu/U5CM3KH5si3uQkXbOyTN4GlnXgcQE5zzc037TDsDlmEyxu1+xKlxi4UXP5AuWSgYvlfID1gImRAc50XLTAciifM6A+aQh0Gzebd6ZhAyyHhla30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ng/V/fXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ng/V/fXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B44F1F000FF;
	Wed, 30 Sep 2026 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788063;
	bh=eY6eSBCGXLAFDuoG2SVq2SWvlOt5Pg+9+vLNtjzpuOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ng/V/fXu8NC/puXB7XyIV3tqdpJqXc+mPx7MlACGk7/DodMos0BsgJBhtDtmTUPKZ
	 xwVTvg22/scNSevputnFXUDXhWDBsforu/xaBTC6sPqlx/aXDUExBbjiNfIXAASvfB
	 qZfLs2mLDbipXZ5/0zpm1fUdQdKDT5LE+Vxc7O/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 452/457] KVM: x86/mmu: Move kvm_mmu_do_page_fault() from mmu_internal.h => mmu.c
Date: Wed, 30 Sep 2026 17:29:17 +0200
Message-ID: <20260930152355.759512548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

[ Upstream commit 20fe9252460524f9028b515f0f672442ffe6779b ]

Move kvm_mmu_do_page_fault() into mmu.c, as there are no users outside of
mmu.c, and the function typically isn't inlined by the compiler anyways.
This will allow moving the EMULTYPE_xxx definitions into x86.h without
having to include x86.h in mmu_internal.h, i.e. will help preserve the
goal of making x86.h KVM x86's "top-level" include.

No functional change intended.

Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20260613000329.732085-30-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 10180a277549 ("KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c          |   67 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h |   66 ---------------------------------------
 2 files changed, 66 insertions(+), 67 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4957,7 +4957,7 @@ out_unlock:
 }
 #endif
 
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 #ifdef CONFIG_X86_64
 	if (tdp_mmu_enabled)
@@ -4967,6 +4967,71 @@ int kvm_tdp_page_fault(struct kvm_vcpu *
 	return direct_page_fault(vcpu, fault);
 }
 
+static int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				 u64 err, bool prefetch, int *emulation_type,
+				 u8 *level)
+{
+	struct kvm_page_fault fault = {
+		.addr = cr2_or_gpa,
+		.error_code = err,
+		.exec = err & PFERR_FETCH_MASK,
+		.write = err & PFERR_WRITE_MASK,
+		.present = err & PFERR_PRESENT_MASK,
+		.rsvd = err & PFERR_RSVD_MASK,
+		.user = err & PFERR_USER_MASK,
+		.prefetch = prefetch,
+		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.nx_huge_page_workaround_enabled =
+			is_nx_huge_page_enabled(vcpu->kvm),
+
+		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
+		.is_private = err & PFERR_PRIVATE_ACCESS,
+
+		.pfn = KVM_PFN_ERR_FAULT,
+	};
+	int r;
+
+	if (vcpu->arch.mmu->root_role.direct) {
+		/*
+		 * Things like memslots don't understand the concept of a shared
+		 * bit. Strip it so that the GFN can be used like normal, and the
+		 * fault.addr can be used when the shared bit is needed.
+		 */
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_direct_bits(vcpu->kvm);
+		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
+	}
+
+	/*
+	 * With retpoline being active an indirect call is rather expensive,
+	 * so do a direct call in the most common case.
+	 */
+	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
+		r = kvm_tdp_page_fault(vcpu, &fault);
+	else
+		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
+
+	/*
+	 * Not sure what's happening, but punt to userspace and hope that
+	 * they can fix it by changing memory to shared, or they can
+	 * provide a better error.
+	 */
+	if (r == RET_PF_EMULATE && fault.is_private) {
+		pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
+		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
+		return -EFAULT;
+	}
+
+	if (fault.write_fault_to_shadow_pgtable && emulation_type)
+		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+	if (level)
+		*level = fault.goal_level;
+
+	return r;
+}
+
+
 static int kvm_tdp_page_prefault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				 u64 error_code, u8 *level)
 {
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -290,8 +290,6 @@ struct kvm_page_fault {
 	bool write_fault_to_shadow_pgtable;
 };
 
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-
 /*
  * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
  * and of course kvm_mmu_do_page_fault().
@@ -337,70 +335,6 @@ static inline void kvm_mmu_prepare_memor
 				      fault->is_private);
 }
 
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u64 err, bool prefetch,
-					int *emulation_type, u8 *level)
-{
-	struct kvm_page_fault fault = {
-		.addr = cr2_or_gpa,
-		.error_code = err,
-		.exec = err & PFERR_FETCH_MASK,
-		.write = err & PFERR_WRITE_MASK,
-		.present = err & PFERR_PRESENT_MASK,
-		.rsvd = err & PFERR_RSVD_MASK,
-		.user = err & PFERR_USER_MASK,
-		.prefetch = prefetch,
-		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
-		.nx_huge_page_workaround_enabled =
-			is_nx_huge_page_enabled(vcpu->kvm),
-
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
-		.req_level = PG_LEVEL_4K,
-		.goal_level = PG_LEVEL_4K,
-		.is_private = err & PFERR_PRIVATE_ACCESS,
-
-		.pfn = KVM_PFN_ERR_FAULT,
-	};
-	int r;
-
-	if (vcpu->arch.mmu->root_role.direct) {
-		/*
-		 * Things like memslots don't understand the concept of a shared
-		 * bit. Strip it so that the GFN can be used like normal, and the
-		 * fault.addr can be used when the shared bit is needed.
-		 */
-		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_direct_bits(vcpu->kvm);
-		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
-	}
-
-	/*
-	 * With retpoline being active an indirect call is rather expensive,
-	 * so do a direct call in the most common case.
-	 */
-	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
-		r = kvm_tdp_page_fault(vcpu, &fault);
-	else
-		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
-
-	/*
-	 * Not sure what's happening, but punt to userspace and hope that
-	 * they can fix it by changing memory to shared, or they can
-	 * provide a better error.
-	 */
-	if (r == RET_PF_EMULATE && fault.is_private) {
-		pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
-		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
-		return -EFAULT;
-	}
-
-	if (fault.write_fault_to_shadow_pgtable && emulation_type)
-		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
-	if (level)
-		*level = fault.goal_level;
-
-	return r;
-}
-
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);


