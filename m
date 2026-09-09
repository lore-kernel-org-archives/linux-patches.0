Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8FF5867C9;
	Wed,  9 Sep 2026 14:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963942; cv=none; b=suZrAE4vHYaGaaSY9C7Kr7e8hQET3SByx1kBBLdoecCf5bY4/QC0xIls460I0lgdl1eGweMnaE2amFgFAbPLVBv6A/oYCAyRatb7LeMk2PMLA9FZlC2NQ0scIUfpZCsxrSkoHvbN5yyG+8Vg5G1p8VwKb27vbSrqViHrK2IonCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963942; c=relaxed/simple;
	bh=osZj7WVK1KoenDFXvIFn1grQgzYcLIOQDZm68a4b5vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b153gCakakMuaNA9c+jF1Co67qxaDMsboqHXN4amzM24/RRX2Gvux1vjm8C34yUtQS75UXB1rUjVZrTe+7dXDTZlPSbhq552kWvedorZWa5Vtate9iFGtGiO6h1YJJZMrTooQPKkEel9KQsxirHYX4h1V63X0yjrLIA+aABKk3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4rH2gHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4rH2gHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39C31F00A3A;
	Wed,  9 Sep 2026 14:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963941;
	bh=+Te5GX1xBxzMiS/PErh6Jo2E2+RPVjO7OtZpmsqn0XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4rH2gHt/OOZmB6/w1WzF7U3M8sdfD2mr4v5Nzdcb9lCwOuDnKbFGn8mx+0vT6lrj
	 AMRhbrL2gF5ibTSNtAGqtBZltiCtFFgIYxyucIx18CiaiXqnETFb6Tr/y90F5jQOk4
	 ZT+Wdy0Js6TXaBHAdXPSmF+FJBWfWtotAOgt8Unw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 252/583] KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page
Date: Wed,  9 Sep 2026 15:38:57 +0200
Message-ID: <20260909134246.851905415@linuxfoundation.org>
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

commit 8c774604b6ecaca495fa3d27c21593269627f48f upstream.

We record a VNCR TLB even when SCTLR_EL2.M is 0 in order to make
our life easier. But this is not something that the architecture
anticipate.

As a consequence, a hypervisor is free to set VNCR_EL2 to
some PA when SCTLR_EL2.M==0, use it to run a guest which indirectly
accesses the VNCR page, then eventually set SCTLR_EL2.M==1 with
the same VA. Yes, this is odd, but apparently legal.

A common trick in HW is to invalidate the TLBs on SCTLR_ELx.M being
flipped. But doing this is a not a good idea for us (we'd need to
trap SCTLR accesses), and wouldn't scale as we nest deeper.

Instead, use the fact that the S1 MMU being off at the point of
translation is cached in our TLB, and if it doesn't match the current
MMU state, leave the VNCR unmapped.

Fixes: 2a359e072596f ("KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260806091026.620700-4-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_nested.h |    7 +++++++
 arch/arm64/kvm/at.c                 |    2 --
 arch/arm64/kvm/nested.c             |    4 ++++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -353,6 +353,8 @@ struct s1_walk_result {
 	bool	failed;
 };
 
+#define S1_MMU_DISABLED		(-127)
+
 static inline void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
 {
 	wr->fst		= fst;
@@ -361,6 +363,11 @@ static inline void fail_s1_walk(struct s
 	wr->failed	= true;
 }
 
+static inline bool s1_walk_translated(struct s1_walk_result *wr)
+{
+	return wr->level != S1_MMU_DISABLED;
+}
+
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va);
 int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -10,8 +10,6 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-#define S1_MMU_DISABLED		(-127)
-
 static int get_ia_size(struct s1_walk_info *wi)
 {
 	return 64 - wi->txsz;
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1413,6 +1413,10 @@ static void kvm_map_l1_vncr(struct kvm_v
 	if (!vt->valid)
 		return;
 
+	/* We cache the MMU state in the TLB. Check that it matches. */
+	if (!!(vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_M) != s1_walk_translated(&vt->wr))
+		return;
+
 	if (read_vncr_el2(vcpu) != vt->gva)
 		return;
 


