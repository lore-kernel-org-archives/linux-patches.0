Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF1483A10;
	Mon, 15 Apr 2024 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191478; cv=none; b=Lp9A+vufQwa/Jm0Ik00FfhaoBHgaAq+8v6FkaCJtHENeLdO9rKJ4NpT3deUPE0kXPZC8faWdoRv4izsV8Qvi4JMljeKJ4VHzAXUSyEQEIqqvlac8SM8you4431Qok5MAPiCcU7jNdOEmb9Eqa0Rp9/h7azz0JBAS/VoVV2c64Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191478; c=relaxed/simple;
	bh=KOMQ4WQ7UflswVSYQCOzT6pn6ft4jpuCgrt4+5QLrBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO3+i0KXRr+J2drssvPEBfy/xW+D5Lhs7XOHJeD3By+e9A0HgR5x5BIuKuJr7Pww+/lxRlmQ7eMIMeqJdBSrcHa4oQbiiAzow5wBxTdW0duX92EYfFoFbwztyZffuiQJqME8SGzbJGAMZ+gSsqQQEVc7ejycPCOWeHWBoRvPE1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxVozywM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxVozywM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A9EC2BD10;
	Mon, 15 Apr 2024 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191477;
	bh=KOMQ4WQ7UflswVSYQCOzT6pn6ft4jpuCgrt4+5QLrBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxVozywMeA0LzQlW6JR4dNZosEjjNLYsSZYhI1YQzPiKYZj/PnDDzhmBDZbWneR9L
	 IA5PFYlxfPKhwrB1qM6xUXsbnrXHdS84QKelTsZ+BjG+UqPeFRnvgMekDK/5ysr/dg
	 Ou6W6rzWvmA/eCdUl+6+OsprdWpH9th1JAMhBf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.8 155/172] x86/bugs: Fix BHI handling of RRSBA
Date: Mon, 15 Apr 2024 16:20:54 +0200
Message-ID: <20240415142005.069653811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 1cea8a280dfd1016148a3820676f2f03e3f5b898 upstream.

The ARCH_CAP_RRSBA check isn't correct: RRSBA may have already been
disabled by the Spectre v2 mitigation (or can otherwise be disabled by
the BHI mitigation itself if needed).  In that case retpolines are fine.

Fixes: ec9404e40e8f ("x86/bhi: Add BHI mitigation knob")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/6f56f13da34a0834b69163467449be7f58f253dc.1712813475.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1537,20 +1537,25 @@ static enum spectre_v2_mitigation __init
 	return SPECTRE_V2_RETPOLINE;
 }
 
+static bool __ro_after_init rrsba_disabled;
+
 /* Disable in-kernel use of non-RSB RET predictors */
 static void __init spec_ctrl_disable_kernel_rrsba(void)
 {
-	u64 x86_arch_cap_msr;
+	if (rrsba_disabled)
+		return;
 
-	if (!boot_cpu_has(X86_FEATURE_RRSBA_CTRL))
+	if (!(x86_arch_cap_msr & ARCH_CAP_RRSBA)) {
+		rrsba_disabled = true;
 		return;
+	}
 
-	x86_arch_cap_msr = x86_read_arch_cap_msr();
+	if (!boot_cpu_has(X86_FEATURE_RRSBA_CTRL))
+		return;
 
-	if (x86_arch_cap_msr & ARCH_CAP_RRSBA) {
-		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
-		update_spec_ctrl(x86_spec_ctrl_base);
-	}
+	x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
+	update_spec_ctrl(x86_spec_ctrl_base);
+	rrsba_disabled = true;
 }
 
 static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
@@ -1651,9 +1656,11 @@ static void __init bhi_select_mitigation
 		return;
 
 	/* Retpoline mitigates against BHI unless the CPU has RRSBA behavior */
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE) &&
-	    !(x86_read_arch_cap_msr() & ARCH_CAP_RRSBA))
-		return;
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
+		spec_ctrl_disable_kernel_rrsba();
+		if (rrsba_disabled)
+			return;
+	}
 
 	if (spec_ctrl_bhi_dis())
 		return;
@@ -2808,8 +2815,7 @@ static const char *spectre_bhi_state(voi
 		return "; BHI: BHI_DIS_S";
 	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
 		return "; BHI: SW loop, KVM: SW loop";
-	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
-		 !(x86_arch_cap_msr & ARCH_CAP_RRSBA))
+	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) && rrsba_disabled)
 		return "; BHI: Retpoline";
 	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
 		return "; BHI: Syscall hardening, KVM: SW loop";


