Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BAD40587A;
	Tue, 21 Jul 2026 18:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658432; cv=none; b=ILNq/6lo3oO47Rw9yctvtpA3x8vRsTBAPomo7LITbILoc7m2fCwrwGW97Cd2p9eRLK0s1VyRuFHwoQSySzIfr977zPs7zX/uKWlUoykDuhPSIBuaCGrXwEQrdRRQD5nNEZCZHiGMqZyMW2xMvakO1aSkyvUCWkXpkXUo71vXwb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658432; c=relaxed/simple;
	bh=57mMqUf27KUsa/h6V7i9/7RWCmw0ObTKIt7Fb956J1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEl7cGGq5yzn7FpCKgWBkraYIROGRdlSvuBjDfKYfcLRjLmxp2YiMxnVhzKk/NyrF82aPv06v1yuKmGzZo8z0VwHvZuaCeauV+MFqr6zAUlNEcX7W6pytnloPDeXXJNzbKOe3/jJrMN9Jr1MOTpX0a/HpM+9rfDA0NpTzS+ZGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6ABVygx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6ABVygx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6691F00A3A;
	Tue, 21 Jul 2026 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658431;
	bh=dl3POLiz3Rpc171lYjZP+iLgxDpKY0MieRJGzpIsUqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6ABVygxVW/MyqZEhvpIbANOBjCCqst4v9jyRa4isiZxETE+uf0BPSJu3xD5sDCtB
	 +lCoXWTBj2n6n7hy39uGkH+RgGsezzcVVHgDWxYkyC+ZZCekn8SoX1Wwab0u9jD1wm
	 zdPyUA72jo2jYI48C4hoG0ZvpqNJoHo22lT0pc5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1141/1611] KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
Date: Tue, 21 Jul 2026 17:20:57 +0200
Message-ID: <20260721152541.086165209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

commit 2684e02bac41c5220f6c1ab2bdcc957b71812977 upstream.

KVM currently maps the L1 VNCR into the host stage-1 by relying entirely
on the permissions of the guest stage-1. At the same time, it is
entirely possible that the backing PFN is read-only (e.g. RO memslot),
meaning that the L1 VNCR should use at most a read-only mapping.

Cache the writability of the PFN in the VNCR TLB and use it to constrain
the resulting fixmap permissions. Promote VNCR permission faults to an
SEA in the case where the guest attempts to write to a read-only
endpoint. Conveniently, this also plugs a page leak found by Sashiko [*]
resulting from the early return for a read-only PFN.

Cc: stable@vger.kernel.org
Fixes: 2a359e072596 ("KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2")
Link: https://lore.kernel.org/kvm/20260608082603.16AEC1F00893@smtp.kernel.org/
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260618234207.1063941-2-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -24,6 +24,7 @@ struct vncr_tlb {
 	struct s1_walk_result	wr;
 
 	u64			hpa;
+	bool			hpa_writable;
 
 	/* -1 when not mapped on a CPU */
 	int			cpu;
@@ -1226,7 +1227,7 @@ static int kvm_translate_vncr(struct kvm
 	if (!*is_gmem) {
 		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
 					&writable, &page);
-		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 	} else {
 		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
@@ -1235,6 +1236,8 @@ static int kvm_translate_vncr(struct kvm
 					      write_fault, false, false);
 			return ret;
 		}
+
+		writable = !(memslot->flags & KVM_MEM_READONLY);
 	}
 
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
@@ -1245,28 +1248,41 @@ static int kvm_translate_vncr(struct kvm
 
 		vt->gva = va;
 		vt->hpa = pfn << PAGE_SHIFT;
+		vt->hpa_writable = writable;
 		vt->valid = true;
 		vt->cpu = -1;
 
 		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
-		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw);
+		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw && vt->hpa_writable);
 	}
 
-	if (vt->wr.pw)
+	if (vt->wr.pw && vt->hpa_writable)
 		mark_page_dirty(vcpu->kvm, gfn);
 
 	return 0;
 }
 
-static void inject_vncr_perm(struct kvm_vcpu *vcpu)
+static void handle_vncr_perm(struct kvm_vcpu *vcpu)
 {
 	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
 	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 fsc;
+
+	/*
+	 * Promote to an external abort if the stage-1 permits writes but the
+	 * HPA is read-only (e.g. RO memslot).
+	 */
+	if (kvm_is_write_fault(vcpu) && vt->wr.pw && !vt->hpa_writable)
+		fsc = ESR_ELx_FSC_EXTABT;
+	/*
+	 * Otherwise, inject a permission fault using the guest's translation
+	 * level rather than the host's.
+	 */
+	else
+		fsc = ESR_ELx_FSC_PERM_L(vt->wr.level);
 
-	/* Adjust the fault level to reflect that of the guest's */
 	esr &= ~ESR_ELx_FSC;
-	esr |= FIELD_PREP(ESR_ELx_FSC,
-			  ESR_ELx_FSC_PERM_L(vt->wr.level));
+	esr |= FIELD_PREP(ESR_ELx_FSC, fsc);
 
 	kvm_inject_nested_sync(vcpu, esr);
 }
@@ -1312,7 +1328,7 @@ int kvm_handle_vncr_abort(struct kvm_vcp
 		return kvm_handle_guest_sea(vcpu);
 
 	if (esr_fsc_is_permission_fault(esr)) {
-		inject_vncr_perm(vcpu);
+		handle_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {
 		bool valid, is_gmem = false;
 		int ret;
@@ -1360,7 +1376,7 @@ int kvm_handle_vncr_abort(struct kvm_vcp
 			break;
 		case -EPERM:
 			/* Hack to deal with POE until we get kernel support */
-			inject_vncr_perm(vcpu);
+			handle_vncr_perm(vcpu);
 			break;
 		case 0:
 			break;
@@ -1417,7 +1433,7 @@ static void kvm_map_l1_vncr(struct kvm_v
 
 	vt->cpu = smp_processor_id();
 
-	if (vt->wr.pw && vt->wr.pr)
+	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
 		prot = PAGE_KERNEL;
 	else if (vt->wr.pr)
 		prot = PAGE_KERNEL_RO;


