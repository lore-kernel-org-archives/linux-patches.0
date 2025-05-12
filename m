Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1091DDC07;
	Mon, 12 May 2025 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072273; cv=none; b=ueryJZHDgqxWCi2AH2cS6IsoONtoFRRCb151ZpgTrTO4czI7N/fVyTrzFYF+btMOZ7SlYrLqZTZxqboA3nTkxN7f9HNhsREjZWSlvcK3c5jj1ow21tNK/Tfr76b+tFVwj8ZcVDu9C9BDi47KBu89DqA1QZk9Yew/fzeaDbPzWgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072273; c=relaxed/simple;
	bh=aCQmzDqVhgZygBLFX1lgKFuFTrQgT8iKwvqR88C7Eew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A02SMFfDxLbk4pixCL3nr02JoSI6ZE4D1ShkVFNpv+bw4l+4aGSAHbunsi8wb6r0sT1EqRb31Sp3g0MJIK8Z3GpjsoXIUjRuwxSZmGEqVjgF0mQ+RglBdTzOCxLVGIRD6eqkgP5tMqqDob7q+q5/I6Hy4VGdnrtl9Pt+UqT6yss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5ReGyNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5ReGyNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56191C4CEE7;
	Mon, 12 May 2025 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072272;
	bh=aCQmzDqVhgZygBLFX1lgKFuFTrQgT8iKwvqR88C7Eew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5ReGyNA4f/34cxK8NnLokkrlY1K4z5fBmj4pPCI3AFKnGfkanMwJoH4J23Y0Wre9
	 xeEgM2K52AMe0nxEHOj26mjECcW+EA/SG8sKzJTYWTEGSD8kiKY3f2AGp7tC35LbT1
	 6cPF+hyhEH1YF8LyvMSenD8H0/1H78SmKzagLd9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.14 185/197] x86/bpf: Add IBHF call at end of classic BPF
Date: Mon, 12 May 2025 19:40:35 +0200
Message-ID: <20250512172051.918477911@linuxfoundation.org>
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
@@ -1436,9 +1436,12 @@ static void __init cpu_set_bug_bits(stru
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
@@ -1470,6 +1472,23 @@ static int emit_spectre_bhb_barrier(u8 *
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


