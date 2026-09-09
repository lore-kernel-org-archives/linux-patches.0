Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C8D5650F2;
	Wed,  9 Sep 2026 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962512; cv=none; b=pn7g3XL5bvscQ0CWcgKc9O6wkcUeKd0U96wha3XnD9AtM4kDOJ43TCTEtXEmprXFmSTM+wAtPC1CP/Bp8SvNQjjzwyQZw4vtx2SO3R3/tYv8ZO7xqER0mbYwhWnTQUYPksfVjdHBUZ4T4QRtQyyGDjiMg/FFGF30X0MXEqk81Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962512; c=relaxed/simple;
	bh=0j6v6Vq5YOXYfS9BD8pIF0/Ej1b06AQaOTicxR6f7CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WClfhdOQhnJ1Ve+dCzxgAANyOrIvrwOeZzzHbe5By/aIQIHnwFudNmxELycPdp252jYhgXeRWW+yZ4npeAtcgFj1kgzkI5dlmEQm/l9N6jyZDYVE9G0ZfoJByCCqNCq9rQXh49BUdFWPCpUijFbjHQf5JfuwMPgc7Jd/AfZE8BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2gvpZ8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2gvpZ8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F2B1F00A3A;
	Wed,  9 Sep 2026 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962511;
	bh=E24zzYTnEtC8ZXUDUQxj7yUXejzWVuXZrwv7mZiGF6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2gvpZ8ptKLSmUg3s916GVlL/Tkx6gxPMnIPmo4M5frzbXD539vChP5F6d2Pi/dLU
	 Ffx7nuPsvYV+rKrgYBtkLSP3ovN7JvStUC4rpWKBVBFNsAHy6eUxQ2cGhf6YmVJUlP
	 JHbOkwN5ypyt7qJC9B3Us8DhE392EFO7BkD9fhdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 316/556] KVM: arm64: Correctly handle end of VA space TLBI invalidation
Date: Wed,  9 Sep 2026 15:39:56 +0200
Message-ID: <20260909134241.780566372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 34af2c3e31f91a739dc175459fdbd99ed952b457 upstream.

Our TLB invalidation by VA code is based on comparing two ranges,
one defined by the TLB, and one defined by the TLBI instruction.

Each range is defined by a start and a size. However, the way the
comparison is done doesn't account for address rollover, as it
compares an address with (base + size). This works nicely until
this expression represent the last page/block in the TTBR1 VA space,
as the result is a big fat 0. And a failed TLB invalidation.

Rewrite the comparison in a way that is immune to the address
rollover (making the end address inclusive instead of exclusive),
and move this into a common helper that is used by both VA and IPA
invalidations, as suggested by Hyunwoo Kim (although the IPA version
didn't suffer from this particular problem, obviously).

Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260806091026.620700-5-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1001,6 +1001,20 @@ static void invalidate_vncr(struct vncr_
 		clear_fixmap(vncr_fixmap(vt->cpu));
 }
 
+static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
+				u64 scope_start, u64 scope_size)
+{
+	u64 tlb_size, tlb_start, tlb_end, scope_end;
+
+	tlb_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift, vt->wr.level));
+
+	tlb_start = addr & ~(tlb_size - 1);
+	tlb_end = tlb_start + tlb_size - 1;
+	scope_end = scope_start + scope_size - 1;
+
+	return !(tlb_end < scope_start || tlb_start > scope_end);
+}
+
 /*
  * VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions, and
  * either can race against a vcpu not being onlined yet (no pseudo-TLB
@@ -1023,19 +1037,9 @@ static void kvm_invalidate_vncr_ipa(stru
 	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
 		return;
 
-	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
-		u64 ipa_start, ipa_end, ipa_size;
-
-		ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
-							    vt->wr.level));
-		ipa_start = vt->wr.pa & ~(ipa_size - 1);
-		ipa_end = ipa_start + ipa_size;
-
-		if (ipa_end <= start || ipa_start >= end)
-			continue;
-
-		invalidate_vncr(vt);
-	}
+	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm)
+		if (vncr_tlb_intersects(vt, vt->wr.pa, start, end - start))
+			invalidate_vncr(vt);
 }
 
 struct s1e2_tlbi_scope {
@@ -1061,28 +1065,19 @@ static void invalidate_vncr_va(struct kv
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
-		u64 va_start, va_end, va_size;
-
-		va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
-							   vt->wr.level));
-		va_start = vt->gva & ~(va_size - 1);
-		va_end = va_start + va_size;
-
 		switch (scope->type) {
 		case TLBI_ALL:
 			break;
 
 		case TLBI_VA:
-			if (va_end <= scope->va ||
-			    va_start >= (scope->va + scope->size))
+			if (!vncr_tlb_intersects(vt, vt->gva, scope->va, scope->size))
 				continue;
 			if (vt->wr.nG && vt->wr.asid != scope->asid)
 				continue;
 			break;
 
 		case TLBI_VAA:
-			if (va_end <= scope->va ||
-			    va_start >= (scope->va + scope->size))
+			if (!vncr_tlb_intersects(vt, vt->gva, scope->va, scope->size))
 				continue;
 			break;
 


