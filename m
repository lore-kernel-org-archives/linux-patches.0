Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C07556B81;
	Wed,  9 Sep 2026 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962523; cv=none; b=PG/ZSgPcOHuZBTymUPibUXbsGBQaI2m/fzFj0fC8TgAc8AuSLOuDB3EdnWcjpWxQqaKLqbKYrOky1zujK2j75B/Qy2Bi3HvfDwtw+xhK0RjmA3kzQNpRqCNujlaBX5rAv5aA57ho1b3nIAA+abpr+hUoA3h9OHx+3V9qCPDUGOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962523; c=relaxed/simple;
	bh=hway2vSAG3Cc5J6Eko3N5xqnG6z/X1cm477oiT2ZRvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6Pm9L3vHncET3RETU45/Toq2tbCJl6jtedBGs+B+6X6QF0Y/qiiuh4woV5hHAoEn3l+0gkb8ubY57ImwyDWf/HLqFhxfAn+xijK9x2et9bfFsr1rjd1+rk9o1yMzKWe+lGDnxTSftnxGB2QG7o/jS5DL1SYuEUffZ968GC48vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2EHp2wM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2EHp2wM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2301D1F00A3A;
	Wed,  9 Sep 2026 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962522;
	bh=bZJlVVgAUSLqkR/C+iM1KfxCm87vg4JHYv8zVTuHhCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2EHp2wMmZ0oWyCQITIpqtF7m4fufUaA66y230Rou5mYy9JgPhQAfNRgYkBaSNyU/
	 fpiWAG65RejLu/Z3DGKOO+WvwUiISxhHp1bTJ20WWw6XGcdr8a0tFrZAHpSNSDQF2G
	 urmPkPOmK4xCr40X2ljcL8TS1jAgQ+FBKypZpoDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 320/556] KVM: arm64: Sign-extend VA for range-based TLBI invalidation
Date: Wed,  9 Sep 2026 15:40:00 +0200
Message-ID: <20260909134241.921452798@linuxfoundation.org>
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
@@ -291,6 +291,13 @@ static inline u64 decode_range_tlbi(u64
 
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
@@ -4057,6 +4057,7 @@ static bool handle_ripas2e1is(struct kvm
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 	u64 base, range;
+	int pa_bits;
 
 	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
@@ -4068,6 +4069,16 @@ static bool handle_ripas2e1is(struct kvm
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


