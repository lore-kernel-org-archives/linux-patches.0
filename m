Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828991;
	b=yNAfNObDO4TmJLHPnj5vetHCxA6sjHrA3BnJTHk1W4L/EmchYaQFaCzC271RvfETxyvc
	 uKP3PoBY4ijkKewuLpCr855x4AWtHHyZomoC7e+AM6yYKgYXxK38w/fi8KHYuJcVSNd6l
	 BY921+UIaekz98DDR1skFjp3/SnC+YgUsLBrb8+oqzYbi2rCuA1b3p2dwVMPyURDB3gVt
	 B2YNYcAKF98owGkAs96ecmJ4r0knqKDPT90LAO3PrEQQYJCcAsw0uzn+NpVvAtHXeVY1A
	 FbgG4uFu+e+M1YEwBCPwsIm/oFUl2+eV8Q78Ff7MVfw/qh0FKr5PTuxHKyZDsCNMYLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I5vycsvoKF51EIN2/pQMO794hy1IbEJT2Oq10WPM2QY=;
	b=NYSjQQ4g2Y1QPY20eKF5EQfHl70v3cAAU3y/kiAEspooIrgozYgGn0vMsqijkVv5TOCC
	 KszIuQxUDGqEP7Chkx9e+EA6c2/aRTySTchAWfdJVt5PguklYm1uBCN7akd/BBnI6SjQb
	 fuA1EKa2U8CxUZsSuDfSmqGZOklGHmHPiRz7Zq93MZQd3ugm8UH60W6KrHwCjx23pLSwo
	 BZMuR6AMwG2L6t5tvTMIkXjM2fIBfmCX5UAT8Tz896U3KP8nbsQQbUH2JU8jhktK6cdB0
	 9hq65LzpgeqyvJ3eZ2qWp01+NeeG4SaAgjR3vHKR9e9sRaDpkRABdxYF+v6Zc/+1uag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Chofhu4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D53607F281;
	Wed,  4 Nov 2026 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Chofhu4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B5A1F000C1;
	Wed,  4 Nov 2026 21:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828991;
	bh=I5vycsvoKF51EIN2/pQMO794hy1IbEJT2Oq10WPM2QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Chofhu4u4HfPTY5E9xQMff/IIdTlkXEOIXdhVm84Wvqib9lU7VZh9s+UCvl8DyF65
	 zrSlGZMNiFikmhzz3PMV1zXtXQzEWt0vmvsYjL5IGreLELhqG155gyWMUrw6CFFjuz
	 Gh2sNdUSWnMXtr/+B9ObH/C27PM7ms/2Riayx5XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.3 374/547] x86/bugs: Adapt SRSO mitigation to Zen6
Date: Wed,  4 Nov 2026 16:09:18 -0500
Message-ID: <20261104211048.928197687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit ae1d2082d93bc04604dc08e9b7f9cdba5e0c28e6 upstream.

Zen6 has BTB protection which isolates the different contexts
(user/kernel, guest/host) from one another. This makes the SafeRET
mitigation there unnecessary leaving the user/user and guest/guest
attack vectors open, whose protection is handled by the Spectre v2
mitigation setting to do IBPB on a context switch.

Detect that setting and report it with a new mitigation string.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260822013231.1109255-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/bugs.c         |   18 ++++++++++++++++--
 arch/x86/kernel/cpu/scattered.c    |    1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -430,6 +430,7 @@
 #define X86_FEATURE_SUCCOR		(17*32+ 1) /* "succor" Uncorrectable error containment and recovery */
 #define X86_FEATURE_CPPC_PERF_PRIO	(17*32+ 2) /* CPPC Floor Perf support */
 #define X86_FEATURE_SMCA		(17*32+ 3) /* "smca" Scalable MCA */
+#define X86_FEATURE_BTB_CTX_ISOLATION	(17*32+ 4) /* AMD: Branch predictions contexts isolated */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 18 */
 #define X86_FEATURE_AVX512_4VNNIW	(18*32+ 2) /* "avx512_4vnniw" AVX-512 Neural Network Instructions */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1175,6 +1175,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
 	SRSO_MITIGATION_BP_SPEC_REDUCE,
+	SRSO_MITIGATION_USER_IBPB,
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_AUTO;
@@ -2908,7 +2909,8 @@ static const char * const srso_strings[]
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
 	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
-	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation",
+	[SRSO_MITIGATION_USER_IBPB]		= "Mitigation: IBPB on context switch",
 };
 
 static int __init srso_parse_cmdline(char *str)
@@ -2948,7 +2950,9 @@ static void __init srso_select_mitigatio
 		 * required.  Otherwise the 'microcode' mitigation is sufficient
 		 * to protect the user->user and guest->guest vectors.
 		 */
-		if (cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST) ||
+		if ((cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST) &&
+		    !boot_cpu_has(X86_FEATURE_BTB_CTX_ISOLATION))
+					||
 		    (cpu_attack_vector_mitigated(CPU_MITIGATE_USER_KERNEL) &&
 		     !boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO))) {
 			srso_mitigation = SRSO_MITIGATION_SAFE_RET;
@@ -3024,6 +3028,16 @@ static void __init srso_update_mitigatio
 	    boot_cpu_has(X86_FEATURE_IBPB_BRTYPE))
 		srso_mitigation = SRSO_MITIGATION_IBPB;
 
+	/*
+	 * See if IBPB on context switch is the only thing needed to address
+	 * GUEST/GUEST and USER/USER vectors.
+	 */
+	if (srso_mitigation == SRSO_MITIGATION_MICROCODE  &&
+	    boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO) &&
+	    boot_cpu_has(X86_FEATURE_BTB_CTX_ISOLATION) &&
+	    spectre_v2_user_ibpb != SPECTRE_V2_USER_NONE)
+		srso_mitigation = SRSO_MITIGATION_USER_IBPB;
+
 	pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -64,6 +64,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
+	{ X86_FEATURE_BTB_CTX_ISOLATION,	CPUID_ECX,  8, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },


