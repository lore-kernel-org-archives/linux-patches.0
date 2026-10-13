Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA4F4FECE0;
	Tue, 13 Oct 2026 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893460; cv=none; b=F+cSNW//EY7GNqMmtZOjuQ34W1pj78Gm00k6TNeUQtbjj2q+6qNy3UBqrjRc9QEKv5zDSeGI2PcAZ9bajB970UFYO/4Wg6ph/lZFAoMHEPBNDri+koHxX22d+qvhwAfGmpoEKKdr1XiTF3shttUoUwhpI1J7l0Lg8oKzsRBAoXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893460; c=relaxed/simple;
	bh=hp6KBJWPvW2Spb0TYFgY/eIMldzml4MvsupKlkd28DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlSlxlj0Cw79ouKRwZovmX4fZHxw7Smpg0+Vdj4Fo6pCPgCNdleOYzO4c5R3xNm4AR/jx5g/h3SmKQckeFqsGer2EQBZW0R2BDQSGGtPL+LHh916tnKDglBNOLTNyTqJ40/b2yUyMH8HoQEzJTr3EM/XmNNlVPtqKeXshGB0YuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuMRD5F9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuMRD5F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B5B1F00893;
	Tue, 13 Oct 2026 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893459;
	bh=opRqLyiUQCm1qjOC7kIBnPE11PlyGAwvz/uyYaU5MJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuMRD5F9w6tuccBc92jrih4Yu8gJTS7E+al1HcesCRaPBSZ2jVwTPn/9Fw98Bxync
	 hpIjB07Xu9xU11LYn7D2bs1WQPLx2F1hLFGs/SUjhmIIwhw4pbOrhvJldIBNOFXMfH
	 DtliKAG3D6HQJdWoeGrc99A/MyX9Sr3uxBH4bqqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 232/621] KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor
Date: Tue, 13 Oct 2026 13:33:47 +0200
Message-ID: <20261013112926.365366729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 83726330748981372bde86ed5411d7b306612991 ]

ZCR_EL2 can be updated by a VHE guest hypervisor either using ZCR_EL2
(which traps) or ZCR_EL1 (which does not trap). KVM handles both in
different way:

- on ZCR_EL2 trap, ZCR_EL2.LEN is immediately capped at the VM's own
  VL limit. This has the potential to break existing SW that relies
  on the full LEN field to be stateful.

- on ZCR_EL1 access, we do absolutely nothing.

On restoring the SVE context for an L2 guest, we directly restore the
guest hypervisor's view of ZCR_EL2 into the physical ZCR_EL2. If the
guest's view of the register was updated using the ZCR_EL2 accessor,
the value has already been sanitised (with the caveat mentioned above).

But if the guest used ZCR_EL1, the raw value is written into the HW,
and the L2 guest can now access VLs that it shouldn't.

Fix all the above by moving the VL capping to the restore points,
ensuring that:

- the HW is always programmed with a capped value, irrespective of
  the accessor being used,

- the ZCR_EL2.LEN field is always completely stateful, irrespective
  of the accessor being used.

Additionally, move ZCR_EL2 to be a sanitised register, ensuring that
only the LEN field is actually stateful. This requires some creative
construction of the RES0 mask, as the sysreg generation script does
not yet generate RAZ/WI fields.

Fixes: b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260529-kvm-arm64-fix-zcr-len-nv-v2-1-86cad51992bd@kernel.org
[maz: rewrote commit message, tidy up access_zcr_el2()]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++++------
 arch/arm64/kvm/nested.c                 |  4 ++++
 arch/arm64/kvm/sys_regs.c               | 11 +++--------
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ca26460bde651..419e37112a6f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -493,7 +493,6 @@ enum vcpu_sysreg {
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
-	ZCR_EL2,	/* SVE Control Register (EL2) */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
@@ -524,6 +523,7 @@ enum vcpu_sysreg {
 	SCTLR2_EL2,	/* System Control Register 2 (EL2) */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
+	ZCR_EL2,	/* SVE Control Register (EL2) */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e1ad60d3f3677..b5c8a8e9adfe7 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -438,11 +438,13 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
+	u64 zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+
 	/*
 	 * The vCPU's saved SVE state layout always matches the max VL of the
 	 * vCPU. Start off with the max VL so we can load the SVE state.
 	 */
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr,
 			    true);
@@ -452,8 +454,10 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
 	 * that into hardware before wrapping up.
 	 */
-	if (is_nested_ctxt(vcpu))
-		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
+	if (is_nested_ctxt(vcpu)) {
+		zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
+		sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
+	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
 }
@@ -477,11 +481,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vcpu_has_sve(vcpu)) {
+		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+
 		/* A guest hypervisor may restrict the effective max VL. */
 		if (is_nested_ctxt(vcpu))
-			zcr_el2 = __vcpu_sys_reg(vcpu, ZCR_EL2);
-		else
-			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+			zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
 
 		write_sysreg_el2(zcr_el2, SYS_ZCR);
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3184fff22442f..92853a343c429 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1840,6 +1840,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	/* VNCR_EL2 */
 	set_sysreg_masks(kvm, VNCR_EL2, VNCR_EL2_RES0, VNCR_EL2_RES1);
 
+	/* ZCR_EL2 - bits 8:4 are RAZ/WI so treat them as RES0 */
+	set_sysreg_masks(kvm, ZCR_EL2, ZCR_ELx_RES0 | GENMASK_ULL(8, 4),
+			 ZCR_ELx_RES1);
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		__vcpu_rmw_sys_reg(vcpu, sr, |=, 0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 308ba3dba8098..bf8b6d5990088 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2750,21 +2750,16 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	unsigned int vq;
-
 	if (guest_hyp_sve_traps_enabled(vcpu)) {
 		kvm_inject_nested_sve_trap(vcpu);
 		return false;
 	}
 
-	if (!p->is_write) {
+	if (!p->is_write)
 		p->regval = __vcpu_sys_reg(vcpu, ZCR_EL2);
-		return true;
-	}
+	else
+		__vcpu_assign_sys_reg(vcpu, ZCR_EL2, p->regval);
 
-	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
-	vq = min(vq, vcpu_sve_max_vq(vcpu));
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, vq - 1);
 	return true;
 }
 
-- 
2.53.0



