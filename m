Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79642698A8;
	Tue, 25 Mar 2025 12:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906059; cv=none; b=lqY8NeHIEcInQEPMiGfaXNV04XOZaJdCPSHSo/Boymx7uS82D4a9KXr/LgixOmKNckFkxYztLwtBmorfxh5T0IjwovKsmd9SOyT11j+jcEP+wGQ3EspIjRhcGTpgbXJIhATVhEbC2uJbyxt0snNEuv1bgaHnz0i62/ImlsRbQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906059; c=relaxed/simple;
	bh=thA8BvFrZ4roCDnSetuch5UvS1Aji6kSj5HToQbvtls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb07sqH4h5QuvIBfxXbu/EGkKd+jhACdez7oFoNOvM+321apSnRPSiuia7tfAY8qZnyMIapmlbEHi/wBUjuT4FkitxACdBYvSgBufphXkABw+nktl58n5xo5DL+ABHzxDoRkZIHTWgTLFE55jAw0RomRoHVn+Cliv9wUydGGrwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+npCReC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+npCReC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF5DC4CEE4;
	Tue, 25 Mar 2025 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906058;
	bh=thA8BvFrZ4roCDnSetuch5UvS1Aji6kSj5HToQbvtls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+npCReC+l4/+2wAnfrlTLwHmYcURNOFAmAjaBraeygtit0oTZ/SvQ7tqswy3uGxY
	 TGGk7v/QqL27bee7mST1faugpZKQ1xJrDpc6I3F8bcHasLbh4d9W9V3RXvGsgyi9ua
	 +rtJVufqWqXcjj9xN9iDtpFi9/bRaUyjgtgcartw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.13 112/119] KVM: arm64: Remove host FPSIMD saving for non-protected KVM
Date: Tue, 25 Mar 2025 08:22:50 -0400
Message-ID: <20250325122151.919018542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8eca7f6d5100b6997df4f532090bc3f7e0203bef ]

Now that the host eagerly saves its own FPSIMD/SVE/SME state,
non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
and the code to do this is never used. Protected KVM still needs to
save/restore the host FPSIMD/SVE state to avoid leaking guest state to
the host (and to avoid revealing to the host whether the guest used
FPSIMD/SVE/SME), and that code needs to be retained.

Remove the unused code and data structures.

To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
VHE hyp code, the nVHE/hVHE version is moved into the shared switch
header, where it is only invoked when KVM is in protected mode.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[CPACR_EL1_ZEN -> CPACR_ELx_ZEN -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h       |   18 ++++--------------
 arch/arm64/kvm/arm.c                    |    8 --------
 arch/arm64/kvm/fpsimd.c                 |    2 --
 arch/arm64/kvm/hyp/include/hyp/switch.h |   25 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |    2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   28 ----------------------------
 arch/arm64/kvm/hyp/vhe/switch.c         |    8 --------
 7 files changed, 28 insertions(+), 63 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -613,23 +613,13 @@ struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
 
 	/*
-	 * All pointers in this union are hyp VA.
+	 * Hyp VA.
 	 * sve_state is only used in pKVM and if system_supports_sve().
 	 */
-	union {
-		struct user_fpsimd_state *fpsimd_state;
-		struct cpu_sve_state *sve_state;
-	};
+	struct cpu_sve_state *sve_state;
 
-	union {
-		/* HYP VA pointer to the host storage for FPMR */
-		u64	*fpmr_ptr;
-		/*
-		 * Used by pKVM only, as it needs to provide storage
-		 * for the host
-		 */
-		u64	fpmr;
-	};
+	/* Used by pKVM only. */
+	u64	fpmr;
 
 	/* Ownership of the FP regs */
 	enum {
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2468,14 +2468,6 @@ static void finalize_init_hyp_mode(void)
 			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state =
 				kern_hyp_va(sve_state);
 		}
-	} else {
-		for_each_possible_cpu(cpu) {
-			struct user_fpsimd_state *fpsimd_state;
-
-			fpsimd_state = &per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->host_ctxt.fp_regs;
-			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->fpsimd_state =
-				kern_hyp_va(fpsimd_state);
-		}
 	}
 }
 
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -64,8 +64,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 	 */
 	fpsimd_save_and_flush_cpu_state();
 	*host_data_ptr(fp_owner) = FP_STATE_FREE;
-	*host_data_ptr(fpsimd_state) = NULL;
-	*host_data_ptr(fpmr_ptr) = NULL;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -375,7 +375,28 @@ static inline void __hyp_sve_save_host(v
 			 true);
 }
 
-static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
+static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Non-protected kvm relies on the host restoring its sve state.
+	 * Protected kvm restores the host's sve state as not to reveal that
+	 * fpsimd was used by a guest nor leak upper sve bits.
+	 */
+	if (system_supports_sve()) {
+		__hyp_sve_save_host();
+
+		/* Re-enable SVE traps if not supported for the guest vcpu. */
+		if (!vcpu_has_sve(vcpu))
+			cpacr_clear_set(CPACR_ELx_ZEN, 0);
+
+	} else {
+		__fpsimd_save_state(host_data_ptr(host_ctxt.fp_regs));
+	}
+
+	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
+		*host_data_ptr(fpmr) = read_sysreg_s(SYS_FPMR);
+}
+
 
 /*
  * We trap the first access to the FP/SIMD to save the host context and
@@ -425,7 +446,7 @@ static bool kvm_hyp_handle_fpsimd(struct
 	isb();
 
 	/* Write out the host state if it's in the registers */
-	if (host_owns_fp_regs())
+	if (is_protected_kvm_enabled() && host_owns_fp_regs())
 		kvm_hyp_save_fpsimd_host(vcpu);
 
 	/* Restore the guest state */
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -83,7 +83,7 @@ static void fpsimd_sve_sync(struct kvm_v
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
-		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
+		__fpsimd_restore_state(host_data_ptr(host_ctxt.fp_regs));
 
 	if (has_fpmr)
 		write_sysreg_s(*host_data_ptr(fpmr), SYS_FPMR);
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -193,34 +193,6 @@ static bool kvm_handle_pvm_sys64(struct
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
-static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Non-protected kvm relies on the host restoring its sve state.
-	 * Protected kvm restores the host's sve state as not to reveal that
-	 * fpsimd was used by a guest nor leak upper sve bits.
-	 */
-	if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
-		__hyp_sve_save_host();
-
-		/* Re-enable SVE traps if not supported for the guest vcpu. */
-		if (!vcpu_has_sve(vcpu))
-			cpacr_clear_set(CPACR_ELx_ZEN, 0);
-
-	} else {
-		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
-	}
-
-	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm))) {
-		u64 val = read_sysreg_s(SYS_FPMR);
-
-		if (unlikely(is_protected_kvm_enabled()))
-			*host_data_ptr(fpmr) = val;
-		else
-			**host_data_ptr(fpmr_ptr) = val;
-	}
-}
-
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -309,14 +309,6 @@ static bool kvm_hyp_handle_eret(struct k
 	return true;
 }
 
-static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
-{
-	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
-
-	if (kvm_has_fpmr(vcpu->kvm))
-		**host_data_ptr(fpmr_ptr) = read_sysreg_s(SYS_FPMR);
-}
-
 static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	int ret = -EINVAL;


