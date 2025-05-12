Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6522C10A6;
	Mon, 12 May 2025 18:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073145; cv=none; b=Fomg4sEaTqeE6KsPS4U8TOph3bIuadZzZPgmZtCMaYFkH+2PDPYn3IdszcfgCCr/Osqe2IOXhlm+ehNAXaoCGAakxsg2V0r2hP5muGQE2ABK5/LbK4V6+xaZ9N3l3LkAm36P/pYJu4hutEmeKU/AA79piJxGiCfKNPI4+CrVFAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073145; c=relaxed/simple;
	bh=OgENf+4Uf4lpCp2n1aKx4pYeVB2piVislYqGbzt1mJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaYIMTj7BocArUNRbbGRXXXPwvorW5M3cK53QIMGaEcWnkT+klVdEVvmr+UeOU13SDZb3jbxlokqttjeO1tIxhT4TKukwq72i6pi67OR5M6QO3skO20xxQv73YJaLR59Voy5cY3Bw7kJExc63sOR+JP+/jquIvJyaDClYjsj+Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQjC5+0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQjC5+0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01625C4CEF1;
	Mon, 12 May 2025 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073145;
	bh=OgENf+4Uf4lpCp2n1aKx4pYeVB2piVislYqGbzt1mJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQjC5+0X4iK88IQPYwAJ9Kio46s10GSCIoRn9EBAlpV6wri8E1s9y8oe7MeX8pPR4
	 8JXPQXE5pX7osCLy+UDdproaqWczrUiO9ptEV+8hDel7ZhaAkO2zoCpGHTvwLv+xYz
	 AJMBZZjmNGJw9X3F70dOw9fN8cE426GvrXWdLYr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.12 169/184] x86/bpf: Add IBHF call at end of classic BPF
Date: Mon, 12 May 2025 19:46:10 +0200
Message-ID: <20250512172048.693187905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

commit 9f725eec8fc0b39bdc07dcc8897283c367c1a163 upstream.

Classic BPF programs can be run by unprivileged users, allowing
unprivileged code to execute inside the kernel. Attackers can use this to
craft branch history in kernel mode that can influence the target of
indirect branches.

BHI_DIS_S provides user-kernel isolation of branch history, but cBPF can be
used to bypass this protection by crafting branch history in kernel mode.
To stop intra-mode attacks via cBPF programs, Intel created a new
instruction Indirect Branch History Fence (IBHF). IBHF prevents the
predicted targets of subsequent indirect branches from being influenced by
branch history prior to the IBHF. IBHF is only effective while BHI_DIS_S is
enabled.

Add the IBHF instruction to cBPF jitted code's exit path. Add the new fence
when the hardware mitigation is enabled (i.e., X86_FEATURE_CLEAR_BHB_HW is
set) or after the software sequence (X86_FEATURE_CLEAR_BHB_LOOP) is being
used in a virtual machine. Note that X86_FEATURE_CLEAR_BHB_HW and
X86_FEATURE_CLEAR_BHB_LOOP are mutually exclusive, so the JIT compiler will
only emit the new fence, not the SW sequence, when X86_FEATURE_CLEAR_BHB_HW
is set.

Hardware that enumerates BHI_NO basically has BHI_DIS_S protections always
enabled, regardless of the value of BHI_DIS_S. Since BHI_DIS_S doesn't
protect against intra-mode attacks, enumerate BHI bug on BHI_NO hardware as
well.

Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    9 ++++++---
 arch/x86/net/bpf_jit_comp.c  |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1437,9 +1437,12 @@ static void __init cpu_set_bug_bits(stru
 	if (vulnerable_to_rfds(x86_arch_cap_msr))
 		setup_force_cpu_bug(X86_BUG_RFDS);
 
-	/* When virtualized, eIBRS could be hidden, assume vulnerable */
-	if (!(x86_arch_cap_msr & ARCH_CAP_BHI_NO) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
+	/*
+	 * Intel parts with eIBRS are vulnerable to BHI attacks. Parts with
+	 * BHI_NO still need to use the BHI mitigation to prevent Intra-mode
+	 * attacks.  When virtualized, eIBRS could be hidden, assume vulnerable.
+	 */
+	if (!cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
 	    (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
 	     boot_cpu_has(X86_FEATURE_HYPERVISOR)))
 		setup_force_cpu_bug(X86_BUG_BHI);
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -41,6 +41,8 @@ static u8 *emit_code(u8 *ptr, u32 bytes,
 #define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
 #define EMIT3(b1, b2, b3)	EMIT((b1) + ((b2) << 8) + ((b3) << 16), 3)
 #define EMIT4(b1, b2, b3, b4)   EMIT((b1) + ((b2) << 8) + ((b3) << 16) + ((b4) << 24), 4)
+#define EMIT5(b1, b2, b3, b4, b5) \
+	do { EMIT1(b1); EMIT4(b2, b3, b4, b5); } while (0)
 
 #define EMIT1_off32(b1, off) \
 	do { EMIT1(b1); EMIT(off, 4); } while (0)
@@ -1432,6 +1434,23 @@ static int emit_spectre_bhb_barrier(u8 *
 		EMIT1(0x59); /* pop rcx */
 		EMIT1(0x58); /* pop rax */
 	}
+	/* Insert IBHF instruction */
+	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&
+	     cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) ||
+	    (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW) &&
+	     IS_ENABLED(CONFIG_X86_64))) {
+		/*
+		 * Add an Indirect Branch History Fence (IBHF). IBHF acts as a
+		 * fence preventing branch history from before the fence from
+		 * affecting indirect branches after the fence. This is
+		 * specifically used in cBPF jitted code to prevent Intra-mode
+		 * BHI attacks. The IBHF instruction is designed to be a NOP on
+		 * hardware that doesn't need or support it.  The REP and REX.W
+		 * prefixes are required by the microcode, and they also ensure
+		 * that the NOP is unlikely to be used in existing code.
+		 */
+		EMIT5(0xF3, 0x48, 0x0F, 0x1E, 0xF8); /* ibhf */
+	}
 	*pprog = prog;
 	return 0;
 }


