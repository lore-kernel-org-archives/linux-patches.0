Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BAC3E3DB4;
	Tue, 21 Jul 2026 20:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664561; cv=none; b=QuyWpuqOmTNMRxDa0Wh07yGroU56Y7dw2nc4xKOAb0ifyBxGNk0V95SxiIG5C59WdjOhluXuyfjIYewfyMz9cyg1h2SxS9jk1mGYkbs3RmPod5IeHBjNDkT+2ldgM1svQHC3edamiq55PdRL6PdTUAvOwcSUK/EE6yHFMiTjd04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664561; c=relaxed/simple;
	bh=f1rfSgFQ93UVl6XpJ0jRNdE4uvTaEpaJT2Doe4VCBJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0sO7Dw3nG3vw7q3GjEQX90bvCnpbCrc92J/1qweU+9hiaa4qWC1lg2oo8ja7XcAVhH5sDjcpC0u8gD9xhNX4jHsulxmOLMusXYhSOGiR5k5AmTp0x60+R7GEeEB0cpXk47hZeRgkqE7GCAbRvJZkrqbZUPjUdc3ceknKtvAskg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ua6IIdzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ua6IIdzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8DD1F000E9;
	Tue, 21 Jul 2026 20:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664559;
	bh=SNMVjpP13UPqjPsVpuGi7ZG1Y8q2znRJnNyXJP7XEKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ua6IIdzDcdrz+4PEho1OirucIeotxoyGuqrhe9IAhFK+qWkeCYR2O7lAjvqc80Ewz
	 scleXYB2pokVs5pUndPQRvVsu/nO0xJM6DjYDmKxr0quFvrcrMB1p6QA0zELb5rxrg
	 iIya/i+NHmMyLfoSAdPKiv4bV81ietfbUNpQSD/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <luis.gerhorst@fau.de>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Henriette Herzog <henriette.herzog@rub.de>,
	Maximilian Ott <ott@cs.fau.de>,
	Milan Stephan <milan.stephan@fau.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1203/1276] bpf, arm64, powerpc: Add bpf_jit_bypass_spec_v1/v4()
Date: Tue, 21 Jul 2026 17:27:26 +0200
Message-ID: <20260721152512.984462101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Gerhorst <luis.gerhorst@fau.de>

[ Upstream commit 03c68a0f8c68936a0bb915b030693923784724cb ]

JITs can set bpf_jit_bypass_spec_v1/v4() if they want the verifier to
skip analysis/patching for the respective vulnerability. For v4, this
will reduce the number of barriers the verifier inserts. For v1, it
allows more programs to be accepted.

The primary motivation for this is to not regress unpriv BPF's
performance on ARM64 in a future commit where BPF_NOSPEC is also used
against Spectre v1.

This has the user-visible change that v1-induced rejections on
non-vulnerable PowerPC CPUs are avoided.

For now, this does not change the semantics of BPF_NOSPEC. It is still a
v4-only barrier and must not be implemented if bypass_spec_v4 is always
true for the arch. Changing it to a v1 AND v4-barrier is done in a
future commit.

As an alternative to bypass_spec_v1/v4, one could introduce NOSPEC_V1
AND NOSPEC_V4 instructions and allow backends to skip their lowering as
suggested by commit f5e81d111750 ("bpf: Introduce BPF nospec instruction
for mitigating Spectre v4"). Adding bpf_jit_bypass_spec_v1/v4() was
found to be preferable for the following reason:

* bypass_spec_v1/v4 benefits non-vulnerable CPUs: Always performing the
  same analysis (not taking into account whether the current CPU is
  vulnerable), needlessly restricts users of CPUs that are not
  vulnerable. The only use case for this would be portability-testing,
  but this can later be added easily when needed by allowing users to
  force bypass_spec_v1/v4 to false.

* Portability is still acceptable: Directly disabling the analysis
  instead of skipping the lowering of BPF_NOSPEC(_V1/V4) might allow
  programs on non-vulnerable CPUs to be accepted while the program will
  be rejected on vulnerable CPUs. With the fallback to speculation
  barriers for Spectre v1 implemented in a future commit, this will only
  affect programs that do variable stack-accesses or are very complex.

For PowerPC, the SEC_FTR checking in bpf_jit_bypass_spec_v4() is based
on the check that was previously located in the BPF_NOSPEC case.

For LoongArch, it would likely be safe to set both
bpf_jit_bypass_spec_v1() and _v4() according to
commit a6f6a95f2580 ("LoongArch, bpf: Fix jit to skip speculation
barrier opcode"). This is omitted here as I am unable to do any testing
for LoongArch.

Hari's ack concerns the PowerPC part only.

Signed-off-by: Luis Gerhorst <luis.gerhorst@fau.de>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Cc: Henriette Herzog <henriette.herzog@rub.de>
Cc: Maximilian Ott <ott@cs.fau.de>
Cc: Milan Stephan <milan.stephan@fau.de>
Link: https://lore.kernel.org/r/20250603211318.337474-1-luis.gerhorst@fau.de
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 2f884d371faf ("bpf: Allow LPM map access from sleepable BPF programs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c     |   21 ++++++++++++---------
 arch/powerpc/net/bpf_jit_comp64.c |   21 +++++++++++++++++----
 include/linux/bpf.h               |   11 +++++++++--
 kernel/bpf/core.c                 |   15 +++++++++++++++
 4 files changed, 53 insertions(+), 15 deletions(-)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1558,15 +1558,7 @@ emit_cond_jmp:
 
 	/* speculation barrier */
 	case BPF_ST | BPF_NOSPEC:
-		/*
-		 * Nothing required here.
-		 *
-		 * In case of arm64, we rely on the firmware mitigation of
-		 * Speculative Store Bypass as controlled via the ssbd kernel
-		 * parameter. Whenever the mitigation is enabled, it works
-		 * for all of the kernel code with no need to provide any
-		 * additional instructions.
-		 */
+		/* See bpf_jit_bypass_spec_v4() */
 		break;
 
 	/* ST: *(size *)(dst + off) = imm */
@@ -2730,6 +2722,17 @@ bool bpf_jit_supports_percpu_insn(void)
 	return true;
 }
 
+bool bpf_jit_bypass_spec_v4(void)
+{
+	/* In case of arm64, we rely on the firmware mitigation of Speculative
+	 * Store Bypass as controlled via the ssbd kernel parameter. Whenever
+	 * the mitigation is enabled, it works for all of the kernel code with
+	 * no need to provide any additional instructions. Therefore, skip
+	 * inserting nospec insns against Spectre v4.
+	 */
+	return true;
+}
+
 bool bpf_jit_inlines_helper_call(s32 imm)
 {
 	switch (imm) {
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -440,6 +440,23 @@ static int bpf_jit_emit_tail_call(u32 *i
 	return 0;
 }
 
+bool bpf_jit_bypass_spec_v1(void)
+{
+#if defined(CONFIG_PPC_E500) || defined(CONFIG_PPC_BOOK3S_64)
+	return !(security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_BNDS_CHK_SPEC_BAR));
+#else
+	return true;
+#endif
+}
+
+bool bpf_jit_bypass_spec_v4(void)
+{
+	return !(security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_STF_BARRIER) &&
+		 stf_barrier_type_get() != STF_BARRIER_NONE);
+}
+
 /*
  * We spill into the redzone always, even if the bpf program has its own stackframe.
  * Offsets hardcoded based on BPF_PPC_STACK_SAVE -- see bpf_jit_stack_local()
@@ -864,10 +881,6 @@ emit_clear:
 		 * BPF_ST NOSPEC (speculation barrier)
 		 */
 		case BPF_ST | BPF_NOSPEC:
-			if (!security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) ||
-					!security_ftr_enabled(SEC_FTR_STF_BARRIER))
-				break;
-
 			switch (stf_barrier) {
 			case STF_BARRIER_EIEIO:
 				EMIT(PPC_RAW_EIEIO() | 0x02000000);
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2216,6 +2216,9 @@ bpf_prog_run_array_uprobe(const struct b
 	return ret;
 }
 
+bool bpf_jit_bypass_spec_v1(void);
+bool bpf_jit_bypass_spec_v4(void);
+
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
 extern struct mutex bpf_stats_enabled_mutex;
@@ -2386,12 +2389,16 @@ static inline bool bpf_allow_uninit_stac
 
 static inline bool bpf_bypass_spec_v1(const struct bpf_token *token)
 {
-	return cpu_mitigations_off() || bpf_token_capable(token, CAP_PERFMON);
+	return bpf_jit_bypass_spec_v1() ||
+		cpu_mitigations_off() ||
+		bpf_token_capable(token, CAP_PERFMON);
 }
 
 static inline bool bpf_bypass_spec_v4(const struct bpf_token *token)
 {
-	return cpu_mitigations_off() || bpf_token_capable(token, CAP_PERFMON);
+	return bpf_jit_bypass_spec_v4() ||
+		cpu_mitigations_off() ||
+		bpf_token_capable(token, CAP_PERFMON);
 }
 
 int bpf_map_new_fd(struct bpf_map *map, int flags);
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -3088,6 +3088,21 @@ bool __weak bpf_jit_needs_zext(void)
 	return false;
 }
 
+/* By default, enable the verifier's mitigations against Spectre v1 and v4 for
+ * all archs. The value returned must not change at runtime as there is
+ * currently no support for reloading programs that were loaded without
+ * mitigations.
+ */
+bool __weak bpf_jit_bypass_spec_v1(void)
+{
+	return false;
+}
+
+bool __weak bpf_jit_bypass_spec_v4(void)
+{
+	return false;
+}
+
 /* Return true if the JIT inlines the call to the helper corresponding to
  * the imm.
  *


