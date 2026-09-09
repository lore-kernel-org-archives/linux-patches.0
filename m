Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ECE58E2D5;
	Wed,  9 Sep 2026 14:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963948; cv=none; b=sYq25phC2YLVn1X8gbRB2BRlis4hLrMeAGdxZZ8bwLjnZoOehRRmTBiuEopDxWQNS7zb4kJs8KLhfYar4zhFVpyEVDEiBdqGh+oj9/iLdpDquu2F90TU8Uo+5r0sXmvAtzE7dwp2/ZCRtHAgMOKgdBCRudCd6PE41Q1acZsAZGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963948; c=relaxed/simple;
	bh=Y8To9WpUbPPSbD0p9xndKjypjeNJogEgjV/R/FC9X9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syK0fzbSk5HMr3Iyir+nZelqTXUi8ClDU3kXnkbsxmbZsHLB6Ua5XafITzqI1wVbsgp19YEzi+JPuH1kFOWJuFRDj51OF19NXKkQYBu1WBZT2b4XtGP4MlZGwn+e3L6y3t8+GO+uVlGX/Ax0FJk6PWya3WuJcEfE9uyKEiIoH5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3nxYvVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3nxYvVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1741F00A3A;
	Wed,  9 Sep 2026 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963947;
	bh=GAaX3ufg69s6eqhu2L+sDPU5VitwF0llGklFEt9/n+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3nxYvVPQ0b2LXA34thXgkPhYTLlRNQMrvQbivL0gt0s2lDMkDjMnwZxb9i5KO+OU
	 oezz/HMxHoRooi1pPi7DWeY/Jkrvq4HwE2AvJ33mjTgZ87xrXcH5/YdU5+m8vTonKy
	 YXFovwBTyVS6co/t4diTsa0sD+Vm7/KRB0Wkz7oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 253/583] KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation
Date: Wed,  9 Sep 2026 15:38:58 +0200
Message-ID: <20260909134246.885866997@linuxfoundation.org>
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
@@ -387,7 +387,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *
 	return ret;
 }
 
-static unsigned int ttl_to_size(u8 ttl)
+static unsigned int __ttl_to_size(u8 ttl)
 {
 	int level = ttl & 3;
 	int gran = (ttl >> 2) & 3;
@@ -443,10 +443,22 @@ static unsigned int ttl_to_size(u8 ttl)
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
@@ -556,7 +568,11 @@ unsigned long compute_tlb_inval_range(st
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
@@ -993,8 +1009,6 @@ static void compute_s1_tlbi_range(struct
 	case OP_TLBI_VALE1OSNXS:
 		scope->type = TLBI_VA;
 		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
-		if (!scope->size)
-			scope->size = SZ_1G;
 		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
 		scope->asid = FIELD_GET(TLBIR_ASID_MASK, val);
 		break;
@@ -1021,8 +1035,6 @@ static void compute_s1_tlbi_range(struct
 	case OP_TLBI_VAALE1OSNXS:
 		scope->type = TLBI_VAA;
 		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
-		if (!scope->size)
-			scope->size = SZ_1G;
 		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
 		break;
 	case OP_TLBI_RVAE2:


