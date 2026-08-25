Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8029647CC96;
	Tue, 25 Aug 2026 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666236; cv=none; b=NBik3MwAfewrFx5vnl3mcwuv/2ucJdOq44aWUKLzGcXJO0zW6HH52CB7AkNpwIb3NNwuQI8Po4JgVsMW0h16+Rt1fGVGQup4LDPNDB/OVvHh07o4471eiaJh1oOe/eAw+HcoAZmGnazZ9gGjIfIatcyLYaZK3W/UAURGebvESWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666236; c=relaxed/simple;
	bh=QjVojVnxehTubCJd2B2xJW09pCmbpjAuMtK07velgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSyL7W4G9fGZ92TiRY/jXx54gKCKhlsNFQrdCcPU4SkABuF0C6l79UO8I756rnxq/JsKO8T5T5yAEuXpnyxO3KAFwo7As6dYQzhJOA5Gx8EF1255S1vQQdKF+TCM1NMpx0stsonj0HgH1VRO3TdYhBwm7KfNbkiPIC5NNhj4iqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqpuf8qS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqpuf8qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D431F000E9;
	Tue, 25 Aug 2026 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666235;
	bh=/6sWOBfYrEJnC2730PUeZjJUXkbdgHVYhZmbbCHiL2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqpuf8qSMzHPdW/avIv+aMsBg+ez+Ru6jNoYMv45VuW2zPFXPSXoEJSKVrQIm1+yA
	 SGLZ7hrBLysUneB7Ery8O5Y41tHxae2ewT8bd/k/u8ZBdIqumtBG8R2HLhaJUkcR8f
	 aIy30iim7/tTAdhrFBI0NT39MmiHKrXdpFfbp6l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Gardon <bgardon@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 51/76] KVM: x86/mmu: Retry page fault if root is invalidated by memslot update
Date: Tue, 25 Aug 2026 15:26:44 +0200
Message-ID: <20260825132543.573783299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a955cad84cdaffa282b3cf8f5ce69e9e5655e585 ]

Bail from the page fault handler if the root shadow page was obsoleted by
a memslot update.  Do the check _after_ acuiring mmu_lock, as the TDP MMU
doesn't rely on the memslot/MMU generation, and instead relies on the
root being explicit marked invalid by kvm_mmu_zap_all_fast(), which takes
mmu_lock for write.

For the TDP MMU, inserting a SPTE into an obsolete root can leak a SP if
kvm_tdp_mmu_zap_invalidated_roots() has already zapped the SP, i.e. has
moved past the gfn associated with the SP.

For other MMUs, the resulting behavior is far more convoluted, though
unlikely to be truly problematic.  Installing SPs/SPTEs into the obsolete
root isn't directly problematic, as the obsolete root will be unloaded
and dropped before the vCPU re-enters the guest.  But because the legacy
MMU tracks shadow pages by their role, any SP created by the fault can
can be reused in the new post-reload root.  Again, that _shouldn't_ be
problematic as any leaf child SPTEs will be created for the current/valid
memslot generation, and kvm_mmu_get_page() will not reuse child SPs from
the old generation as they will be flagged as obsolete.  But, given that
continuing with the fault is pointess (the root will be unloaded), apply
the check to all MMUs.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211120045046.3940942-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[backport note: is_page_fault_stale() adapted to take individual parameters
 instead of struct kvm_page_fault, since 4326e57ef40a ("KVM: MMU: change
 direct_page_fault() arguments to kvm_page_fault") is not in 5.15.y;
 required by the following backport of 2abd5287f083 and by 0cb2af2ea66a
 to be backported separately]
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |   22 ++++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |    3 ++-
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1942,7 +1942,11 @@ static void mmu_audit_disable(void) { }
 
 static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	return sp->role.invalid ||
+	if (sp->role.invalid)
+		return true;
+
+	/* TDP MMU pages due not use the MMU generation. */
+	return !sp->tdp_mmu_page &&
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
@@ -3968,6 +3972,20 @@ out_retry:
 	return true;
 }
 
+/*
+ * Returns true if the page fault is stale and needs to be retried, i.e. if the
+ * root was invalidated by a memslot update or a relevant mmu_notifier fired.
+ */
+static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
+				kvm_pfn_t pfn, unsigned long mmu_seq, hva_t hva)
+{
+	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
+		return true;
+
+	return !is_noslot_pfn(pfn) &&
+	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva);
+}
+
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			     bool prefault, int max_level, bool is_tdp)
 {
@@ -4009,7 +4027,7 @@ static int direct_page_fault(struct kvm_
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva))
 		goto out_unlock;
 
 	if (is_tdp_mmu_fault) {
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -925,7 +925,8 @@ static int FNAME(page_fault)(struct kvm_
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+
+	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);


