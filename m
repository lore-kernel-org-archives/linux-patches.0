Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A170B562600;
	Wed,  9 Sep 2026 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962506; cv=none; b=Z5BGcjNqG+YUr1vHcWG8gkbkbcO0hSlozXuTeG1I79D5gQwy//wIDObrOaGt+/N0i/6Hc+rupMTy3EgquNWRfi7n46N0n12iJBvYSv9dJn2IY5kNNb8MOUZQlmwswi/C4LC62VtO5Y25/nfSLLmNgLAlpC+CmPs7/cgSYJMK7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962506; c=relaxed/simple;
	bh=tw3jKCxcGLf88AXMShWoxsw5ON72X6ivAl//Z68D8/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5nePzRGwtKyWxLRBPZQ2ZlNeNhNOEV7dC+SrJyi5XOx1ZilAoKFQ/8v7C7sHNBh3gT1+aQG2s0rzpCa56sCtv6+J7GG8PXhWMvJwnNa2I92xlI5IwZW22+3D9lBQQLxi3D0ciLDZZdM5cqkqXH6ox7uQc3dqfCbsBVYpTUqGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDTWKD2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDTWKD2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3291F00A3A;
	Wed,  9 Sep 2026 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962505;
	bh=rLLp+79ESETDUdW5dZW5WBP7nCXuhpRaRuipXwwa05c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDTWKD2QD0c2p2kmdY/UU/r+KnF/zQ8KMXM+n2Ij7WpUb/RVRMzMuts7pO5Oc+3V9
	 YQKlw9Vw56mZAPj+MNpbro3GWw/yIPSv5TjMeERnJyTNABUHYpVekPMTHBaFdE3oRv
	 Jmi4gNuIBlQk9f/YzcaCWkWpMqrWPyHaLHE2vGy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 315/556] KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation
Date: Wed,  9 Sep 2026 15:39:55 +0200
Message-ID: <20260909134241.748161342@linuxfoundation.org>
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

commit 8053393680d4fa3eb962667d2be95dd39f0940e5 upstream.

Computing the effects of a TLB invalidation involves looking at
the size of the mapping cached by the TLB. For S1 mappings such as
VNCR, this is deducted from the combination of the base granule size
and the mapping level.

However, this implies that the S1 MMU is *on*. When the MMU is off,
we indicate this with the level being set to a "creative" value of
-127 (S1_MMU_DISABLED).

This ends-up being misinterpreted by pgshift_level_to_ttl() as it
doesn't handle negative levels at all (the level is immediately cast
to a u8 and only the bottom two bits considered), leading to an
invalidation size of 0. Not helpful.

Tidy-up pgshift_level_to_ttl() to handle these negative levels, and
ttl_to_size() to always return SZ_1G when no valid TTL is present.
This allows the removal of open-coded checks for similar situations.

Note that the check for a negative value not explicitely checking for
S1_MMU_DISABLED is deliberate, so that actual negative levels introduced
with LVA2 and D128 can take the same path if we ever support them.

Fixes: 7270cc9157f47 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/r/ameGoxbn2wzBq2kL@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260806091026.620700-3-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -506,7 +506,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *
 	return ret;
 }
 
-static unsigned int ttl_to_size(u8 ttl)
+static unsigned int __ttl_to_size(u8 ttl)
 {
 	int level = ttl & 3;
 	int gran = (ttl >> 2) & 3;
@@ -562,10 +562,22 @@ static unsigned int ttl_to_size(u8 ttl)
 	return max_size;
 }
 
-static u8 pgshift_level_to_ttl(u16 shift, u8 level)
+static unsigned int ttl_to_size(u8 ttl)
+{
+	return __ttl_to_size(ttl) ?: SZ_1G;
+}
+
+static u8 pgshift_level_to_ttl(u16 shift, s8 level)
 {
 	u8 ttl;
 
+	/*
+	 * If we don't have a proper level, fallback to the maximum
+	 * size.
+	 */
+	if (level < 0)
+		return 0;
+
 	switch(shift) {
 	case 12:
 		ttl = TLBI_TTL_TG_4K;
@@ -676,7 +688,11 @@ unsigned long compute_tlb_inval_range(st
 		ttl = get_guest_mapping_ttl(mmu, addr);
 	}
 
-	max_size = ttl_to_size(ttl);
+	/*
+	 * Don't use the default 1GB fallback, as we can adapt to the
+	 * max mapping size we allow at S2.
+	 */
+	max_size = __ttl_to_size(ttl);
 
 	if (!max_size) {
 		/* Compute the maximum extent of the invalidation */
@@ -1126,8 +1142,6 @@ static void compute_s1_tlbi_range(struct
 	case OP_TLBI_VALE1OSNXS:
 		scope->type = TLBI_VA;
 		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
-		if (!scope->size)
-			scope->size = SZ_1G;
 		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
 		scope->asid = FIELD_GET(TLBIR_ASID_MASK, val);
 		break;
@@ -1154,8 +1168,6 @@ static void compute_s1_tlbi_range(struct
 	case OP_TLBI_VAALE1OSNXS:
 		scope->type = TLBI_VAA;
 		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
-		if (!scope->size)
-			scope->size = SZ_1G;
 		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
 		break;
 	case OP_TLBI_RVAE2:


