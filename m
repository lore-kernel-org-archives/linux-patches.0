Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EF724E4C3;
	Tue, 21 Jul 2026 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654098; cv=none; b=oL40jUpSqDJ5pet51DCmS33enU5L+zvPYm/BOqAZC4cz5KPSg+t0xNWfrspKHgWsSfOpAnNme91H8YPR2w+mXOIJK0McOxCeGn9/PUOwBECQeYN5nPncLCWctlw7qpJOqyMY0V1kTg+zZwtqFnxQmxqwFtHm61751rksf5OunCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654098; c=relaxed/simple;
	bh=OhVET7Rt2WNwiuVYJUS+1HkzldNTqFkpY8ZWCOopfGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMAC0ktOqWIROOrfO5qN6droNcyDfO/Ygnzg5H7vmokRCZnHTen51izXe5Hzb3oy/HSwZCsDpHFgh07uuWpPuMCMmpkquDzspsr456myRwYX9GnuRIEdp6j31egEP+TeF4Hv4ybSZuZj0tviyItplDMSsf5G5cFuiiV34Jzi4PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI1yf9Dh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI1yf9Dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD50B1F000E9;
	Tue, 21 Jul 2026 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654097;
	bh=MwkunX3XEEtKel7kbAbphdgO1oZLUK5UGG0gVyHr8bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI1yf9Dh/zUfrEPcY3qPJVmkXclPLita72FQttuNS/TCg58uqYstLlMstSoNKGk3f
	 OwX7NWoa2yGpO49cdaBCK5GJ7X2R/6ke/laQe/osj59FDdfZ4FbHo6VrrwpEwnYZZO
	 1kypdhoU4r9mmhsZW/6irFo13jWMDq9qkT45VJPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1577/2077] KVM: arm64: nv: Re-translate VNCR before injecting abort
Date: Tue, 21 Jul 2026 17:20:50 +0200
Message-ID: <20260721152629.974800053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

commit bb645aa0a4caeaf7f9cd32e9a948594d434c1a8f upstream.

KVM faults in the VNCR page with FOLL_WRITE whenever the guest aborts
for a write, similar to how a regular stage-2 mapping is handled. It is
entirely possible that the guest reads from the VNCR before writing to
it, in which case the PFN could only be read-only.

Invalidate the VNCR TLB and re-fetch the translation upon taking a VNCR
abort, allowing the host mapping to be faulted in for write the second
time around. Interestingly enough, this also satisfies the ordering
requirements of FEAT_ETS2/3 between descriptor updates and MMU faults.

Cc: stable@vger.kernel.org
Fixes: 2a359e072596 ("KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260618234207.1063941-4-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |  115 ++++++++++++++++++------------------------------
 1 file changed, 44 insertions(+), 71 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1380,88 +1380,61 @@ static void handle_vncr_perm(struct kvm_
 	kvm_inject_nested_sync(vcpu, esr);
 }
 
-static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
-{
-	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
-
-	lockdep_assert_held_read(&vcpu->kvm->mmu_lock);
-
-	if (!vt->valid)
-		return false;
-
-	if (read_vncr_el2(vcpu) != vt->gva)
-		return false;
-
-	if (vt->wr.nG)
-		return get_asid_by_regime(vcpu, TR_EL20) == vt->wr.asid;
-
-	return true;
-}
-
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 {
 	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
 	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_gmem = false;
+	bool perm;
+	int ret;
 
 	WARN_ON_ONCE(!(esr & ESR_ELx_VNCR));
 
 	if (kvm_vcpu_abt_issea(vcpu))
 		return kvm_handle_guest_sea(vcpu);
 
-	if (esr_fsc_is_permission_fault(esr)) {
-		handle_vncr_perm(vcpu);
-	} else if (esr_fsc_is_translation_fault(esr)) {
-		bool valid, is_gmem = false;
-		int ret;
-
-		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
-			valid = kvm_vncr_tlb_lookup(vcpu);
-
-		if (!valid)
-			ret = kvm_translate_vncr(vcpu, &is_gmem);
-		else
-			ret = -EPERM;
-
-		switch (ret) {
-		case -EAGAIN:
-			/* Let's try again... */
-			break;
-		case -ENOMEM:
-			/*
-			 * For guest_memfd, this indicates that it failed to
-			 * create a folio to back the memory. Inform userspace.
-			 */
-			if (is_gmem)
-				return 0;
-			/* Otherwise, let's try again... */
-			break;
-		case -EFAULT:
-		case -EIO:
-		case -EHWPOISON:
-			if (is_gmem)
-				return 0;
-			fallthrough;
-		case -EINVAL:
-		case -ENOENT:
-		case -EACCES:
-			/*
-			 * Translation failed, inject the corresponding
-			 * exception back to EL2.
-			 */
-			esr &= ~ESR_ELx_FSC;
-			esr |= FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
-
-			kvm_inject_nested_sync(vcpu, esr);
-			break;
-		case -EPERM:
-			/* Hack to deal with POE until we get kernel support */
-			handle_vncr_perm(vcpu);
-			break;
-		case 0:
-			break;
-		}
-	} else {
+	if (!esr_fsc_is_translation_fault(esr) && !esr_fsc_is_permission_fault(esr)) {
 		WARN_ONCE(1, "Unhandled VNCR abort, ESR=%llx\n", esr);
+		return 1;
+	}
+
+	ret = kvm_translate_vncr(vcpu, &is_gmem);
+	switch (ret) {
+	case -EAGAIN:
+		/* Let's try again... */
+		return 1;
+	case -ENOMEM:
+		/*
+		 * For guest_memfd, this indicates that it failed to
+		 * create a folio to back the memory. Inform userspace.
+		 */
+		if (is_gmem)
+			return 0;
+		/* Otherwise, let's try again... */
+		break;
+	case -EFAULT:
+	case -EIO:
+	case -EHWPOISON:
+		if (is_gmem)
+			return 0;
+		fallthrough;
+	case -EINVAL:
+	case -ENOENT:
+	case -EACCES:
+		/*
+		 * Translation failed, inject the corresponding
+		 * exception back to EL2.
+		 */
+		esr &= ~ESR_ELx_FSC;
+		esr |= FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
+
+		kvm_inject_nested_sync(vcpu, esr);
+		break;
+	case 0:
+		perm = kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt->wr.pr;
+		if (!perm)
+			handle_vncr_perm(vcpu);
+		break;
 	}
 
 	return 1;


