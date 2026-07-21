Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A5146D2D2;
	Tue, 21 Jul 2026 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659642; cv=none; b=tKAoNiQvTzvF8dA8TLR3WntbpvrToNEHQzO6DXUU7gHeQMCd2+ZybzgOQ1MjzoYCQnm2FYAuVJEQX29oiaV4izC4doUpRvdVKGpmdSjmsicrMS+lQ8p/0TucUC62BpEnd2hoagm/LfokQTcG4KiFEcZDFrDaaJbp1L0bLkTLrj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659642; c=relaxed/simple;
	bh=ALgWatwi0RCjZXrKPUKXXYE83cBtlA70f766EqDX1y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuXrBJZrGqKwnux4Mf9lL/jhGBj1DFWqKDAdqCLne1ij194Q2N9Wj4JspYXs2HAMqfiHQo2zchAonZHdfkTglVDweBQGHy2z73zy/m9NcO6JqkEbjf5LtuZsMy99fG9ZgcSo2+UWtvaW/ZwZS5ocIply+TzOb6lc5Jwbpeg/mFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDUrrIzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDUrrIzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096B61F000E9;
	Tue, 21 Jul 2026 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659640;
	bh=EviGoPicWjOcWf/Vs8282mg0Wi3+yjJPZCgSRqqfuwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDUrrIzWkrt9pXdhCXq6TVYw6SEMFEp078zV5RR+GIfqO/90d0NdRtdD9mq2XtsHm
	 hc1MO5DvUrezSOno2ajnUL1s/zc/uS3qfJyq6vXwHPIkB/ypxyRV5mFQW8wDHBIDiO
	 oFwAvZvThYeqkJ3OSP5clFaYGaApcfTc5WE1QYts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1597/1611] KVM: arm64: Deduplicate ASID retrieval code
Date: Tue, 21 Jul 2026 17:28:33 +0200
Message-ID: <20260721152551.397983493@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 54e367cb94d6bef941bbc1132d9959dc73bd4b6f upstream.

We currently have three versions of the ASID retrieval code, one
in the S1 walker, and two in the VNCR handling (although the last
two are limited to the EL2&0 translation regime).

Make this code common, and take this opportunity to also simplify
the code a bit while switching over to the TTBRx_EL1_ASID macro.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20260225104718.14209-1-maz@kernel.org
[maz: cherry-pick as dependency of bb645aa0a4caeaf7f9cd32e9a948594d434c1a8f]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_nested.h |    2 +
 arch/arm64/kvm/at.c                 |   27 +---------------
 arch/arm64/kvm/nested.c             |   60 ++++++++++++++++++------------------
 3 files changed, 35 insertions(+), 54 deletions(-)

--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -371,6 +371,8 @@ int kvm_vcpu_allocate_vncr_tlb(struct kv
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
 void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val);
 
+u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime);
+
 #define vncr_fixmap(c)						\
 	({							\
 		u32 __c = (c);					\
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -483,31 +483,8 @@ static int walk_s1(struct kvm_vcpu *vcpu
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
 	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
-	if (wr->nG) {
-		u64 asid_ttbr, tcr;
-
-		switch (wi->regime) {
-		case TR_EL10:
-			tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
-			asid_ttbr = ((tcr & TCR_A1) ?
-				     vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
-				     vcpu_read_sys_reg(vcpu, TTBR0_EL1));
-			break;
-		case TR_EL20:
-			tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-			asid_ttbr = ((tcr & TCR_A1) ?
-				     vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
-				     vcpu_read_sys_reg(vcpu, TTBR0_EL2));
-			break;
-		default:
-			BUG();
-		}
-
-		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
-		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
-			wr->asid &= GENMASK(7, 0);
-	}
+	if (wr->nG)
+		wr->asid = get_asid_by_regime(vcpu, wi->regime);
 
 	return 0;
 
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -818,6 +818,33 @@ int kvm_inject_s2_fault(struct kvm_vcpu
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
 
+u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	enum vcpu_sysreg ttbr_elx;
+	u64 tcr;
+	u16 asid;
+
+	switch (regime) {
+	case TR_EL10:
+		tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
+		ttbr_elx = (tcr & TCR_A1) ? TTBR1_EL1 : TTBR0_EL1;
+		break;
+	case TR_EL20:
+		tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+		ttbr_elx = (tcr & TCR_A1) ? TTBR1_EL2 : TTBR0_EL2;
+		break;
+	default:
+		BUG();
+	}
+
+	asid = FIELD_GET(TTBRx_EL1_ASID, vcpu_read_sys_reg(vcpu, ttbr_elx));
+	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
+	    !(tcr & TCR_ASID16))
+		asid &= GENMASK(7, 0);
+
+	return asid;
+}
+
 static void invalidate_vncr(struct vncr_tlb *vt)
 {
 	vt->valid = false;
@@ -1314,20 +1341,8 @@ static bool kvm_vncr_tlb_lookup(struct k
 	if (read_vncr_el2(vcpu) != vt->gva)
 		return false;
 
-	if (vt->wr.nG) {
-		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-		u64 ttbr = ((tcr & TCR_A1) ?
-			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
-			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
-		u16 asid;
-
-		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
-		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
-			asid &= GENMASK(7, 0);
-
-		return asid == vt->wr.asid;
-	}
+	if (vt->wr.nG)
+		return get_asid_by_regime(vcpu, TR_EL20) == vt->wr.asid;
 
 	return true;
 }
@@ -1428,21 +1443,8 @@ static void kvm_map_l1_vncr(struct kvm_v
 	if (read_vncr_el2(vcpu) != vt->gva)
 		return;
 
-	if (vt->wr.nG) {
-		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
-		u64 ttbr = ((tcr & TCR_A1) ?
-			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
-			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
-		u16 asid;
-
-		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
-		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
-		    !(tcr & TCR_ASID16))
-			asid &= GENMASK(7, 0);
-
-		if (asid != vt->wr.asid)
-			return;
-	}
+	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) != vt->wr.asid)
+		return;
 
 	vt->cpu = smp_processor_id();
 


