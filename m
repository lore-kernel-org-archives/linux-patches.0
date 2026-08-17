Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F9282F29;
	Mon, 17 Aug 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979051; cv=none; b=hflM1yvtIPVyWEhB2OKKIuV8/raMm0h4WckW6v74tXGTOvyhtGvSxNxbZjZl+FlHpw9gwgM7qtTzuSUblJYg/IMU0fesMlx3nVn5Olv669vvXzMCHjGYtPbs9HF0hutQa1vNz3Le68OUf41Inc+TBg5YsrtNKlGACT3w1oBpdls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979051; c=relaxed/simple;
	bh=NAPlPn+uVz3cALtl+q5/RnNh3s46se5ghxPcBae6+1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSk2fsPe3kPhinU2gKw9+A6SV+WGSTDaMtMDYaMnMCr25Zvl9bd2yjGIfvlv3gAL5ZmgDtTSsF/xuAZZTk4NOXpOrpIomAqLCOd2sJiPVPE5oEPacsJ+RY//OyY3WPEb0K2MPN2NlpcygRkETBByIpU18kIhDMKxk74ZvQdZ4sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+2moxpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+2moxpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5431F00A3A;
	Mon, 17 Aug 2026 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979050;
	bh=aats3eKahJ8TI3aOU1QaCercKytzFpmdyK0Fis+Z8h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+2moxplr5o4f61jwAX/XdkvE/eqeZb3itPCdEdydAdAO41NNTw5kx8cmLosguwuU
	 OMEPghCpGCHBsT/oTpiGsF3ka3+pA/Vwf61jDdcTa/CNxCX42hmKayrVY16ZaFWNJr
	 68HAY3RkjUeICJVDgfbZmqVap8LrEB4Zg7zRyqW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/609] x86/bugs: Enable IBPB flush on BPF JIT allocation
Date: Mon, 17 Aug 2026 15:26:27 +0200
Message-ID: <20260817132546.675058019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a3af84b0fa00ead01fcd0e28b5d773ff25990a0d upstream.

Enable hardening against JIT spraying when Spectre-v2 mitigations are in
use. Specifically, issue an IBPB flush on BPF JIT memory reuse. Skip
enabling the IBPB flush if the BPF dispatcher is already using a retpoline
sequence.

This hardening applies only when BPF-JIT is in use. Guard the enabling
under CONFIG_BPF_JIT so that bugs.c still builds with CONFIG_BPF_JIT=n.

  [ pawan: Use entry_ibpb() instead of write_ibpb(). JIT hardening enable
	   moved to spectre_v2_select_mitigation() because there is no
	   spectre_v2_apply_mitigation()]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 ++
 arch/x86/kernel/cpu/bugs.c           |   50 +++++++++++++++++++++++++++++++----
 2 files changed, 49 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -293,6 +293,10 @@ void srso_safe_ret(void);
 void srso_alias_safe_ret(void);
 void handle_interrupted_saferet(struct pt_regs *regs);
 
+#ifdef CONFIG_BPF_JIT
+extern void bpf_arch_ibpb(void);
+#endif
+
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
 #endif
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -16,6 +16,7 @@
 #include <linux/sched/smt.h>
 #include <linux/pgtable.h>
 #include <linux/bpf.h>
+#include <linux/filter.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -1298,8 +1299,21 @@ static inline const char *spectre_v2_mod
 {
 	return spectre_v2_bad_module ? " - vulnerable module loaded" : "";
 }
+
+/*
+ * The "retpoline sequence" is the "call;mov;ret" sequence that
+ * replaces normal indirect branch instructions. Differentiate
+ * *the* retpoline sequence from the LFENCE-prefixed indirect
+ * branches that simply use the retpoline infrastructure.
+ */
+static inline bool retpoline_seq_enabled(void)
+{
+	return boot_cpu_has(X86_FEATURE_RETPOLINE) && !boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE);
+}
+
 #else
 static inline const char *spectre_v2_module_string(void) { return ""; }
+static inline bool retpoline_seq_enabled(void) { return false; }
 #endif
 
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
@@ -1780,8 +1794,7 @@ static void __init bhi_select_mitigation
 		return;
 
 	/* Retpoline mitigates against BHI unless the CPU has RRSBA behavior */
-	if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
-	    !boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE)) {
+	if (retpoline_seq_enabled()) {
 		spec_ctrl_disable_kernel_rrsba();
 		if (rrsba_disabled)
 			return;
@@ -1803,6 +1816,27 @@ static void __init bhi_select_mitigation
 	pr_info("Spectre BHI mitigation: SW BHB clearing on syscall\n");
 }
 
+#ifdef CONFIG_BPF_JIT
+static void __bpf_arch_ibpb(void *unused)
+{
+	entry_ibpb();
+}
+
+void bpf_arch_ibpb(void)
+{
+	on_each_cpu(__bpf_arch_ibpb, NULL, 1);
+}
+
+static bool __init cpu_wants_ibpb_bpf(void)
+{
+	/* A genuine retpoline already neutralizes ring0 indirect predictions */
+	if (retpoline_seq_enabled())
+		return false;
+
+	return boot_cpu_has(X86_FEATURE_IBPB);
+}
+#endif
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1985,6 +2019,14 @@ static void __init spectre_v2_select_mit
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
 
+#ifdef CONFIG_BPF_JIT
+	if (cpu_wants_ibpb_bpf()) {
+		static_call_update(bpf_arch_pred_flush, bpf_arch_ibpb);
+		static_branch_enable(&bpf_pred_flush_enabled);
+		pr_info("Enabling IBPB for BPF\n");
+	}
+#endif
+
 	/* Set up IBPB and STIBP depending on the general spectre V2 command */
 	spectre_v2_cmd = cmd;
 }
@@ -3157,9 +3199,7 @@ static const char *spectre_bhi_state(voi
 		return "; BHI: BHI_DIS_S";
 	else if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
 		return "; BHI: SW loop, KVM: SW loop";
-	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
-		 !boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE) &&
-		 rrsba_disabled)
+	else if (retpoline_seq_enabled() && rrsba_disabled)
 		return "; BHI: Retpoline";
 	else if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
 		return "; BHI: Vulnerable, KVM: SW loop";


