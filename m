Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A0B245022;
	Mon, 12 May 2025 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072261; cv=none; b=crZZCWWgCoq3C06cKWhvgZfj+VJRG0DfnYAxRqqeThrYRrhgBLF+ShMOJ9hkDrgX/0Ol0Rt5pQ7UNbBs3zoCdfwaPyQEgnjRU0e8ZNzJQynjtN+SpRQvtG/7OeSeS6lrnjtuKnr8TIDowHbqjHWCEXaXreSxwFFeihLjhs54rm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072261; c=relaxed/simple;
	bh=xVKQJErdrONznFmlLotIDK++yCsPTI2i2X1g9qeyqQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWD74uJPSKNb4k6Ne9dh5ddEg4Q5tZQEZ+W2uoWd/npQcVj7AsH0r5PEAzP8zi+H2JURv0se9eyyr9RHLaVnXEe2lB3wf0nJWRTHjAS8M6YBAV/oXeSHEYHWDHKb1ShXD+BJANBJJqqpxDxPchE4EYU+deOAGYB6CxriXw1hiKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PijoWriV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PijoWriV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CD4C4CEE7;
	Mon, 12 May 2025 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072261;
	bh=xVKQJErdrONznFmlLotIDK++yCsPTI2i2X1g9qeyqQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PijoWriVaBOw3q+E5eLz5z/p5IZU5VExDq2XT9AUMSyyLZ1pLEP9oOA92GZPwqBQX
	 I7J5dB+72q1ycs3yUFVWzhTXyhZ1Mu3eMuWFrgnB8R06n/BLTHkOQY0moRlKkKDWdk
	 u5VoN6y+QPmqRN+3+/+ZWXmYVQWFqAlY2WD8Fq2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.14 181/197] arm64: bpf: Add BHB mitigation to the epilogue for cBPF programs
Date: Mon, 12 May 2025 19:40:31 +0200
Message-ID: <20250512172051.758825530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit 0dfefc2ea2f29ced2416017d7e5b1253a54c2735 upstream.

A malicious BPF program may manipulate the branch history to influence
what the hardware speculates will happen next.

On exit from a BPF program, emit the BHB mititgation sequence.

This is only applied for 'classic' cBPF programs that are loaded by
seccomp.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 
 arch/arm64/kernel/proton-pack.c  |    2 -
 arch/arm64/net/bpf_jit_comp.c    |   54 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 52 insertions(+), 5 deletions(-)

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
@@ -1020,7 +1020,7 @@ static void this_cpu_set_vectors(enum ar
 	isb();
 }
 
-static bool __read_mostly __nospectre_bhb;
+bool __read_mostly __nospectre_bhb;
 static int __init parse_spectre_bhb_param(char *str)
 {
 	__nospectre_bhb = true;
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt) "bpf_jit: " fmt
 
+#include <linux/arm-smccc.h>
 #include <linux/bitfield.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
@@ -17,6 +18,7 @@
 #include <asm/asm-extable.h>
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/text-patching.h>
@@ -864,7 +866,48 @@ static void build_plt(struct jit_ctx *ct
 		plt->target = (u64)&dummy_tramp;
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
 	const u8 ptr = bpf2a64[TCCNT_PTR];
@@ -877,10 +920,13 @@ static void build_epilogue(struct jit_ct
 
 	emit(A64_POP(A64_ZR, ptr, A64_SP), ctx);
 
+	if (was_classic)
+		build_bhb_mitigation(ctx);
+
 	/* Restore FP/LR registers */
 	emit(A64_POP(A64_FP, A64_LR, A64_SP), ctx);
 
-	/* Set return value */
+	/* Move the return value from bpf:r0 (aka x7) to x0 */
 	emit(A64_MOV(1, A64_R(0), r0), ctx);
 
 	/* Authenticate lr */
@@ -1817,7 +1863,7 @@ struct bpf_prog *bpf_int_jit_compile(str
 	}
 
 	ctx.epilogue_offset = ctx.idx;
-	build_epilogue(&ctx);
+	build_epilogue(&ctx, was_classic);
 	build_plt(&ctx);
 
 	extable_align = __alignof__(struct exception_table_entry);
@@ -1880,7 +1926,7 @@ skip_init_ctx:
 		goto out_free_hdr;
 	}
 
-	build_epilogue(&ctx);
+	build_epilogue(&ctx, was_classic);
 	build_plt(&ctx);
 
 	/* Extra pass to validate JITed code. */


