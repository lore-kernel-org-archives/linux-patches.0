Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5162B21A4C4;
	Tue, 12 Nov 2024 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408426; cv=none; b=t02C+ibEbsy65gUFlNnsinSk//AC4J1T7wTbjfKFTDH/tlEpcD+sNlQ/fA7DWyEHPL7SD+wvmA7FP/UU0rMnTpIWnLksWolP4HXCTf3IlsNOuT+VMkpS/oxU68kSH+7Z51qOzWC5HqBP7vF0PbiuWKucW+SEB+OR90P+kwqHcSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408426; c=relaxed/simple;
	bh=3JGqsVVoCl4k69hXeP2++19vhcU5CuF/tPvMoRk4yQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUyLGnlaaVGudY3er05yGwuTs6MwfsUacqGCyjk6wGfQLSe5f0YEhzC8u6ITFCXkjUjXI6cNOblIAZPGOGrMZA6oglrV7i3wWtw7Epvz+TT4bSiwCUEqW1E0pZ2+R/W3BVoTEBf8xky5m9FZiLdNx8gN/PBVbZtt3/YgCjauUU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ji8RhDrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ji8RhDrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE20C4CECD;
	Tue, 12 Nov 2024 10:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408425;
	bh=3JGqsVVoCl4k69hXeP2++19vhcU5CuF/tPvMoRk4yQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji8RhDrpSuFMl3LLnRLCmAVlwnOENxRmjtkDin4NO/xuQ6WrDRSWAvZj3O7dDcx7L
	 Bw0UuBmxwL4N+Ap7zOlzvDhJTQnUlF95ovtOKhRCAfzxvRJ6XoC2cRbcrvBID7KJzl
	 6ekHhIEUWeIIUQdpVQDR/EBZ3kdKIg2a/JWEtFtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.11 131/184] arm64: smccc: Remove broken support for SMCCCv1.3 SVE discard hint
Date: Tue, 12 Nov 2024 11:21:29 +0100
Message-ID: <20241112101905.894911556@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 8c462d56487e3abdbf8a61cedfe7c795a54f4a78 upstream.

SMCCCv1.3 added a hint bit which callers can set in an SMCCC function ID
(AKA "FID") to indicate that it is acceptable for the SMCCC
implementation to discard SVE and/or SME state over a specific SMCCC
call. The kernel support for using this hint is broken and SMCCC calls
may clobber the SVE and/or SME state of arbitrary tasks, though FPSIMD
state is unaffected.

The kernel support is intended to use the hint when there is no SVE or
SME state to save, and to do this it checks whether TIF_FOREIGN_FPSTATE
is set or TIF_SVE is clear in assembly code:

|        ldr     <flags>, [<current_task>, #TSK_TI_FLAGS]
|        tbnz    <flags>, #TIF_FOREIGN_FPSTATE, 1f   // Any live FP state?
|        tbnz    <flags>, #TIF_SVE, 2f               // Does that state include SVE?
|
| 1:     orr     <fid>, <fid>, ARM_SMCCC_1_3_SVE_HINT
| 2:
|        << SMCCC call using FID >>

This is not safe as-is:

(1) SMCCC calls can be made in a preemptible context and preemption can
    result in TIF_FOREIGN_FPSTATE being set or cleared at arbitrary
    points in time. Thus checking for TIF_FOREIGN_FPSTATE provides no
    guarantee.

(2) TIF_FOREIGN_FPSTATE only indicates that the live FP/SVE/SME state in
    the CPU does not belong to the current task, and does not indicate
    that clobbering this state is acceptable.

    When the live CPU state is clobbered it is necessary to update
    fpsimd_last_state.st to ensure that a subsequent context switch will
    reload FP/SVE/SME state from memory rather than consuming the
    clobbered state. This and the SMCCC call itself must happen in a
    critical section with preemption disabled to avoid races.

(3) Live SVE/SME state can exist with TIF_SVE clear (e.g. with only
    TIF_SME set), and checking TIF_SVE alone is insufficient.

Remove the broken support for the SMCCCv1.3 SVE saving hint. This is
effectively a revert of commits:

* cfa7ff959a78 ("arm64: smccc: Support SMCCC v1.3 SVE register saving hint")
* a7c3acca5380 ("arm64: smccc: Save lr before calling __arm_smccc_sve_check()")

... leaving behind the ARM_SMCCC_VERSION_1_3 and ARM_SMCCC_1_3_SVE_HINT
definitions, since these are simply definitions from the SMCCC
specification, and the latter is used in KVM via ARM_SMCCC_CALL_HINTS.

If we want to bring this back in future, we'll probably want to handle
this logic in C where we can use all the usual FPSIMD/SVE/SME helper
functions, and that'll likely require some rework of the SMCCC code
and/or its callers.

Fixes: cfa7ff959a78 ("arm64: smccc: Support SMCCC v1.3 SVE register saving hint")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241106160448.2712997-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/smccc-call.S |   35 +++--------------------------------
 drivers/firmware/smccc/smccc.c |    4 ----
 include/linux/arm-smccc.h      |   32 +++-----------------------------
 3 files changed, 6 insertions(+), 65 deletions(-)

--- a/arch/arm64/kernel/smccc-call.S
+++ b/arch/arm64/kernel/smccc-call.S
@@ -7,48 +7,19 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
-#include <asm/thread_info.h>
-
-/*
- * If we have SMCCC v1.3 and (as is likely) no SVE state in
- * the registers then set the SMCCC hint bit to say there's no
- * need to preserve it.  Do this by directly adjusting the SMCCC
- * function value which is already stored in x0 ready to be called.
- */
-SYM_FUNC_START(__arm_smccc_sve_check)
-
-	ldr_l	x16, smccc_has_sve_hint
-	cbz	x16, 2f
-
-	get_current_task x16
-	ldr	x16, [x16, #TSK_TI_FLAGS]
-	tbnz	x16, #TIF_FOREIGN_FPSTATE, 1f	// Any live FP state?
-	tbnz	x16, #TIF_SVE, 2f		// Does that state include SVE?
-
-1:	orr	x0, x0, ARM_SMCCC_1_3_SVE_HINT
-
-2:	ret
-SYM_FUNC_END(__arm_smccc_sve_check)
-EXPORT_SYMBOL(__arm_smccc_sve_check)
 
 	.macro SMCCC instr
-	stp     x29, x30, [sp, #-16]!
-	mov	x29, sp
-alternative_if ARM64_SVE
-	bl	__arm_smccc_sve_check
-alternative_else_nop_endif
 	\instr	#0
-	ldr	x4, [sp, #16]
+	ldr	x4, [sp]
 	stp	x0, x1, [x4, #ARM_SMCCC_RES_X0_OFFS]
 	stp	x2, x3, [x4, #ARM_SMCCC_RES_X2_OFFS]
-	ldr	x4, [sp, #24]
+	ldr	x4, [sp, #8]
 	cbz	x4, 1f /* no quirk structure */
 	ldr	x9, [x4, #ARM_SMCCC_QUIRK_ID_OFFS]
 	cmp	x9, #ARM_SMCCC_QUIRK_QCOM_A6
 	b.ne	1f
 	str	x6, [x4, ARM_SMCCC_QUIRK_STATE_OFFS]
-1:	ldp     x29, x30, [sp], #16
-	ret
+1:	ret
 	.endm
 
 /*
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -16,7 +16,6 @@ static u32 smccc_version = ARM_SMCCC_VER
 static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
 
 bool __ro_after_init smccc_trng_available = false;
-u64 __ro_after_init smccc_has_sve_hint = false;
 s32 __ro_after_init smccc_soc_id_version = SMCCC_RET_NOT_SUPPORTED;
 s32 __ro_after_init smccc_soc_id_revision = SMCCC_RET_NOT_SUPPORTED;
 
@@ -28,9 +27,6 @@ void __init arm_smccc_version_init(u32 v
 	smccc_conduit = conduit;
 
 	smccc_trng_available = smccc_probe_trng();
-	if (IS_ENABLED(CONFIG_ARM64_SVE) &&
-	    smccc_version >= ARM_SMCCC_VERSION_1_3)
-		smccc_has_sve_hint = true;
 
 	if ((smccc_version >= ARM_SMCCC_VERSION_1_2) &&
 	    (smccc_conduit != SMCCC_CONDUIT_NONE)) {
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -227,8 +227,6 @@ u32 arm_smccc_get_version(void);
 
 void __init arm_smccc_version_init(u32 version, enum arm_smccc_conduit conduit);
 
-extern u64 smccc_has_sve_hint;
-
 /**
  * arm_smccc_get_soc_id_version()
  *
@@ -327,15 +325,6 @@ struct arm_smccc_quirk {
 };
 
 /**
- * __arm_smccc_sve_check() - Set the SVE hint bit when doing SMC calls
- *
- * Sets the SMCCC hint bit to indicate if there is live state in the SVE
- * registers, this modifies x0 in place and should never be called from C
- * code.
- */
-asmlinkage unsigned long __arm_smccc_sve_check(unsigned long x0);
-
-/**
  * __arm_smccc_smc() - make SMC calls
  * @a0-a7: arguments passed in registers 0 to 7
  * @res: result values from registers 0 to 3
@@ -402,20 +391,6 @@ asmlinkage void __arm_smccc_hvc(unsigned
 
 #endif
 
-/* nVHE hypervisor doesn't have a current thread so needs separate checks */
-#if defined(CONFIG_ARM64_SVE) && !defined(__KVM_NVHE_HYPERVISOR__)
-
-#define SMCCC_SVE_CHECK ALTERNATIVE("nop \n",  "bl __arm_smccc_sve_check \n", \
-				    ARM64_SVE)
-#define smccc_sve_clobbers "x16", "x30", "cc",
-
-#else
-
-#define SMCCC_SVE_CHECK
-#define smccc_sve_clobbers
-
-#endif
-
 #define __constraint_read_2	"r" (arg0)
 #define __constraint_read_3	__constraint_read_2, "r" (arg1)
 #define __constraint_read_4	__constraint_read_3, "r" (arg2)
@@ -486,12 +461,11 @@ asmlinkage void __arm_smccc_hvc(unsigned
 		register unsigned long r3 asm("r3"); 			\
 		CONCATENATE(__declare_arg_,				\
 			    COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__);	\
-		asm volatile(SMCCC_SVE_CHECK				\
-			     inst "\n" :				\
+		asm volatile(inst "\n" :				\
 			     "=r" (r0), "=r" (r1), "=r" (r2), "=r" (r3)	\
 			     : CONCATENATE(__constraint_read_,		\
 					   COUNT_ARGS(__VA_ARGS__))	\
-			     : smccc_sve_clobbers "memory");		\
+			     : "memory");				\
 		if (___res)						\
 			*___res = (typeof(*___res)){r0, r1, r2, r3};	\
 	} while (0)
@@ -540,7 +514,7 @@ asmlinkage void __arm_smccc_hvc(unsigned
 		asm ("" :						\
 		     : CONCATENATE(__constraint_read_,			\
 				   COUNT_ARGS(__VA_ARGS__))		\
-		     : smccc_sve_clobbers "memory");			\
+		     : "memory");					\
 		if (___res)						\
 			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
 	} while (0)


