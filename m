Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844211D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kg4N9Qwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D148DC433C8;
	Wed,  4 Oct 2023 18:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443956;
	bh=gRW+DykGRrQxhOaSFfSYupC+C8Pw4XmovLzpu0qccTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kg4N9QwuPibwaizXLxxmwVJOw69357C+2Q28Xy+uBx5aJjAP3hQVHJg9JnuCgEERX
	 tXH9HHCihaJ0ndR8lOUis7fDWtAnQf145dv28PhBacBM28XKgWP/atUcOhHM8FX5Ur
	 WwCA2ufbiJVLiLDplcOhY/cxD64stGGLfXRS9sjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 079/321] x86/srso: Set CPUID feature bits independently of bug or mitigation status
Date: Wed,  4 Oct 2023 19:53:44 +0200
Message-ID: <20231004175232.887449441@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 91857ae20303cc98ed36720d9868fcd604a2ee75 ]

Booting with mitigations=off incorrectly prevents the
X86_FEATURE_{IBPB_BRTYPE,SBPB} CPUID bits from getting set.

Also, future CPUs without X86_BUG_SRSO might still have IBPB with branch
type prediction flushing, in which case SBPB should be used instead of
IBPB.  The current code doesn't allow for that.

Also, cpu_has_ibpb_brtype_microcode() has some surprising side effects
and the setting of these feature bits really doesn't belong in the
mitigation code anyway.  Move it to earlier.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/869a1709abfe13b673bdd10c2f4332ca253a40bc.1693889988.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h |  2 --
 arch/x86/kernel/cpu/amd.c        | 28 +++++++++-------------------
 arch/x86/kernel/cpu/bugs.c       | 13 +------------
 3 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fd750247ca891..9e26294e415c8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -676,12 +676,10 @@ extern u16 get_llc_id(unsigned int cpu);
 #ifdef CONFIG_CPU_SUP_AMD
 extern u32 amd_get_nodes_per_socket(void);
 extern u32 amd_get_highest_perf(void);
-extern bool cpu_has_ibpb_brtype_microcode(void);
 extern void amd_clear_divider(void);
 #else
 static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
 static inline u32 amd_get_highest_perf(void)		{ return 0; }
-static inline bool cpu_has_ibpb_brtype_microcode(void)	{ return false; }
 static inline void amd_clear_divider(void)		{ }
 #endif
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7eca6a8abbb1c..b08af929135d9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -766,6 +766,15 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_TOPOEXT))
 		smp_num_siblings = ((cpuid_ebx(0x8000001e) >> 8) & 0xff) + 1;
+
+	if (!cpu_has(c, X86_FEATURE_IBPB_BRTYPE)) {
+		if (c->x86 == 0x17 && boot_cpu_has(X86_FEATURE_AMD_IBPB))
+			setup_force_cpu_cap(X86_FEATURE_IBPB_BRTYPE);
+		else if (c->x86 >= 0x19 && !wrmsrl_safe(MSR_IA32_PRED_CMD, PRED_CMD_SBPB)) {
+			setup_force_cpu_cap(X86_FEATURE_IBPB_BRTYPE);
+			setup_force_cpu_cap(X86_FEATURE_SBPB);
+		}
+	}
 }
 
 static void init_amd_k8(struct cpuinfo_x86 *c)
@@ -1301,25 +1310,6 @@ void amd_check_microcode(void)
 	on_each_cpu(zenbleed_check_cpu, NULL, 1);
 }
 
-bool cpu_has_ibpb_brtype_microcode(void)
-{
-	switch (boot_cpu_data.x86) {
-	/* Zen1/2 IBPB flushes branch type predictions too. */
-	case 0x17:
-		return boot_cpu_has(X86_FEATURE_AMD_IBPB);
-	case 0x19:
-		/* Poke the MSR bit on Zen3/4 to check its presence. */
-		if (!wrmsrl_safe(MSR_IA32_PRED_CMD, PRED_CMD_SBPB)) {
-			setup_force_cpu_cap(X86_FEATURE_SBPB);
-			return true;
-		} else {
-			return false;
-		}
-	default:
-		return false;
-	}
-}
-
 /*
  * Issue a DIV 0/1 insn to clear any division data from previous DIV
  * operations.
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index bdd3e296f72b0..b0ae985aa6a4a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2404,26 +2404,15 @@ early_param("spec_rstack_overflow", srso_parse_cmdline);
 
 static void __init srso_select_mitigation(void)
 {
-	bool has_microcode;
+	bool has_microcode = boot_cpu_has(X86_FEATURE_IBPB_BRTYPE);
 
 	if (!boot_cpu_has_bug(X86_BUG_SRSO) || cpu_mitigations_off())
 		goto pred_cmd;
 
-	/*
-	 * The first check is for the kernel running as a guest in order
-	 * for guests to verify whether IBPB is a viable mitigation.
-	 */
-	has_microcode = boot_cpu_has(X86_FEATURE_IBPB_BRTYPE) || cpu_has_ibpb_brtype_microcode();
 	if (!has_microcode) {
 		pr_warn("IBPB-extending microcode not applied!\n");
 		pr_warn(SRSO_NOTICE);
 	} else {
-		/*
-		 * Enable the synthetic (even if in a real CPUID leaf)
-		 * flags for guests.
-		 */
-		setup_force_cpu_cap(X86_FEATURE_IBPB_BRTYPE);
-
 		/*
 		 * Zen1/2 with SMT off aren't vulnerable after the right
 		 * IBPB microcode has been applied.
-- 
2.40.1



