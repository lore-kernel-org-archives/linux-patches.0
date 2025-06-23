Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091BB676;
	Mon, 23 Jun 2025 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716806; cv=none; b=aafyl8z0KXe4hea5nSR60phqR5uqQXoCTjrLN68zj3eq4PVekk/Mt+pDMmMRJe2YF0/+IrBIespTiB67d8SzEryaulenb0RYoaZkjW+/iM2eBoALec36M3XshMJSQ6IFXyWUj5SfnrkXKAfk0k+fgVcdYx95KF68o3+6dyLYJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716806; c=relaxed/simple;
	bh=BZ651Kzsyx9FphAuSe936adsNcN9GVMVCFWIBgh4hi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpqqiLYoKosWM+/ggHUIJzb0AS4VCx1OTuy2CiTSRLWfWojHFXx6tpLSXotAgbZXWBXX8A6eR32Y9/qxIKXxk3XUeRswVhZ7pLZJwcAgoyOqSeJJwPyaCpXuiSg5WCaptMwrfWDnaDKzKJ+MmdirkYCtXL/FmTx5tS9G0VonAB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL19nl0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL19nl0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC60C4CEEA;
	Mon, 23 Jun 2025 22:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716805;
	bh=BZ651Kzsyx9FphAuSe936adsNcN9GVMVCFWIBgh4hi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL19nl0Iuut5S1UqaZuqSCR/0HpHgxq1/fUIDQ5q4mwCGwNNXkHZ1bmFIBb9FD5bl
	 E1y7n1wCHaCV+OSDQGdJBug3dsfuwHw93hU2k6VB+RQM10wwHqkQmKtymu16/w0SKf
	 fWdGtdTm3CoTP5L36UqDplk7ZW6V1irTHdTRWoNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.15 394/411] arm64: bpf: Add BHB mitigation to the epilogue for cBPF programs
Date: Mon, 23 Jun 2025 15:08:58 +0200
Message-ID: <20250623130643.595434988@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit 0dfefc2ea2f29ced2416017d7e5b1253a54c2735 ]

A malicious BPF program may manipulate the branch history to influence
what the hardware speculates will happen next.

On exit from a BPF program, emit the BHB mititgation sequence.

This is only applied for 'classic' cBPF programs that are loaded by
seccomp.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 
 arch/arm64/kernel/proton-pack.c  |    2 -
 arch/arm64/net/bpf_jit_comp.c    |   55 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -97,6 +97,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+extern bool __nospectre_bhb;
 u8 get_spectre_bhb_loop_value(void);
 bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1023,7 +1023,7 @@ static void this_cpu_set_vectors(enum ar
 	isb();
 }
 
-static bool __read_mostly __nospectre_bhb;
+bool __read_mostly __nospectre_bhb;
 static int __init parse_spectre_bhb_param(char *str)
 {
 	__nospectre_bhb = true;
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -7,14 +7,17 @@
 
 #define pr_fmt(fmt) "bpf_jit: " fmt
 
+#include <linux/arm-smccc.h>
 #include <linux/bitfield.h>
 #include <linux/bpf.h>
+#include <linux/cpu.h>
 #include <linux/filter.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
 
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/set_memory.h>
@@ -327,7 +330,48 @@ static int emit_bpf_tail_call(struct jit
 #undef jmp_offset
 }
 
-static void build_epilogue(struct jit_ctx *ctx)
+/* Clobbers BPF registers 1-4, aka x0-x3 */
+static void __maybe_unused build_bhb_mitigation(struct jit_ctx *ctx)
+{
+	const u8 r1 = bpf2a64[BPF_REG_1]; /* aka x0 */
+	u8 k = get_spectre_bhb_loop_value();
+
+	if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY) ||
+	    cpu_mitigations_off() || __nospectre_bhb ||
+	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
+		return;
+
+	if (supports_clearbhb(SCOPE_SYSTEM)) {
+		emit(aarch64_insn_gen_hint(AARCH64_INSN_HINT_CLEARBHB), ctx);
+		return;
+	}
+
+	if (k) {
+		emit_a64_mov_i64(r1, k, ctx);
+		emit(A64_B(1), ctx);
+		emit(A64_SUBS_I(true, r1, r1, 1), ctx);
+		emit(A64_B_(A64_COND_NE, -2), ctx);
+		emit(aarch64_insn_gen_dsb(AARCH64_INSN_MB_ISH), ctx);
+		emit(aarch64_insn_get_isb_value(), ctx);
+	}
+
+	if (is_spectre_bhb_fw_mitigated()) {
+		emit(A64_ORR_I(false, r1, AARCH64_INSN_REG_ZR,
+			       ARM_SMCCC_ARCH_WORKAROUND_3), ctx);
+		switch (arm_smccc_1_1_get_conduit()) {
+		case SMCCC_CONDUIT_HVC:
+			emit(aarch64_insn_get_hvc_value(), ctx);
+			break;
+		case SMCCC_CONDUIT_SMC:
+			emit(aarch64_insn_get_smc_value(), ctx);
+			break;
+		default:
+			pr_err_once("Firmware mitigation enabled with unknown conduit\n");
+		}
+	}
+}
+
+static void build_epilogue(struct jit_ctx *ctx, bool was_classic)
 {
 	const u8 r0 = bpf2a64[BPF_REG_0];
 	const u8 r6 = bpf2a64[BPF_REG_6];
@@ -346,10 +390,13 @@ static void build_epilogue(struct jit_ct
 	emit(A64_POP(r8, r9, A64_SP), ctx);
 	emit(A64_POP(r6, r7, A64_SP), ctx);
 
+	if (was_classic)
+		build_bhb_mitigation(ctx);
+
 	/* Restore FP/LR registers */
 	emit(A64_POP(A64_FP, A64_LR, A64_SP), ctx);
 
-	/* Set return value */
+	/* Move the return value from bpf:r0 (aka x7) to x0 */
 	emit(A64_MOV(1, A64_R(0), r0), ctx);
 
 	emit(A64_RET(A64_LR), ctx);
@@ -1062,7 +1109,7 @@ struct bpf_prog *bpf_int_jit_compile(str
 	}
 
 	ctx.epilogue_offset = ctx.idx;
-	build_epilogue(&ctx);
+	build_epilogue(&ctx, was_classic);
 
 	extable_size = prog->aux->num_exentries *
 		sizeof(struct exception_table_entry);
@@ -1094,7 +1141,7 @@ skip_init_ctx:
 		goto out_off;
 	}
 
-	build_epilogue(&ctx);
+	build_epilogue(&ctx, was_classic);
 
 	/* 3. Extra pass to validate JITed code. */
 	if (validate_code(&ctx)) {


