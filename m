Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2797C58F07F;
	Wed,  9 Sep 2026 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963957; cv=none; b=e32sx8VOTGP94wKN6XQHAe+5foRcJ8Z/p9gaBtUb3WWKd8FWDRUSu8yxOGQ+dK1TTt1CExS+4bOdCPhjHDGxrcK4m7GYfaX7SHNqlWRIb7xjWW8LTEWrDc7wqgQx/3V/aZ8STPHdoc1d6urucwH7kECkFHfqLIskpQmL1lRCA+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963957; c=relaxed/simple;
	bh=s7c1o+Yog55Iu4BMvqOv3k638ZOkO7WypjfWVFC186o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4Mbm3gpjOKMReB4qT1S5a5j9rXj/g/14gzCrlEv0J24prgdCqr4DFSyrlGWZJdczcGLdg6DTdgBlFb3nPuGvPp37FRZ20eHuMsTDie0HaBWzswJ7yVz5IiwZTQ6nKfxySdOXJeil/tPa26WE4rkBJ9AvVT03LofEWyuCNJNNCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q9pRXqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q9pRXqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4CF1F00A3A;
	Wed,  9 Sep 2026 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963955;
	bh=MhtTAz3oOk1oMju366P+FzhZj/j4o0vjMg4TYVvzGVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0q9pRXqOXxgK1sytLIvdVySXnPSSs1GdrZy83CXbOBN/4pmuupkHNkxgNeNDm/jlp
	 PuOgaPGUscveHafECr10AY4EphlpA9FkALKVYUZUhAbntEthdyPcX+Yo4lSzCZyprj
	 MrkRkII6Gys8/zXN3Cwyz4PrNIWdf8qQaju1kT1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 256/583] KVM: arm64: Sign-extend VA for range-based TLBI invalidation
Date: Wed,  9 Sep 2026 15:39:01 +0200
Message-ID: <20260909134246.987682880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

commit 2393470085649f0b973ecceb26fe8fc71edde0c1 upstream.

When the decode_range_tlbi() helper was moved to be used for S1 TLBIs,
the required sign extension was omitted. Add it.

As a result, special care must be taken to not overflow PA bits when
this is used for S2 invalidation.

Fixes: 85bba00425ae0 ("KVM: arm64: nv: Move TLBI range decoding to a helper")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260801130337.EB2BA1F00AC4@smtp.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260806091026.620700-7-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_nested.h |    7 +++++++
 arch/arm64/kvm/sys_regs.c           |   11 +++++++++++
 2 files changed, 18 insertions(+)

--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -257,6 +257,13 @@ static inline u64 decode_range_tlbi(u64
 
 	base	= (val & GENMASK(36, 0)) << shift;
 
+	/*
+	 * We only deal with at most 48bit VA/IPA, so 48 is where we
+	 * sign-extend from. Should we support FEAT_L{VP}A* at some point,
+	 * this will need to be revisited.
+	 */
+	base	= (u64)sign_extend64(base, 48);
+
 	if (asid)
 		*asid = FIELD_GET(TLBIR_ASID_MASK, val);
 
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3943,6 +3943,7 @@ static bool handle_ripas2e1is(struct kvm
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 	u64 base, range;
+	int pa_bits;
 
 	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
@@ -3954,6 +3955,16 @@ static bool handle_ripas2e1is(struct kvm
 	 */
 	base = decode_range_tlbi(p->regval, &range, NULL);
 
+	/*
+	 * Ignore TLBIs that start out of PA_bits range, and cap the
+	 * invalidation to the [base:bit(PA_bits)] interval.
+	 */
+	pa_bits = kvm_get_pa_bits(vcpu->kvm);
+	if (fls64(base) > pa_bits)
+		return true;
+
+	range = min(range, BIT_ULL(pa_bits) - base);
+
 	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
 				   &(union tlbi_info) {
 					   .range = {


