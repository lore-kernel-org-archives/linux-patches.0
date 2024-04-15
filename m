Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5177C9445;
	Mon, 15 Apr 2024 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192238; cv=none; b=FRP/GSYP7FXOMKk+5IlnRA3gQC8ktMRureMIgweilrCvo6MlJbujBWEeOLqiQIODR/LcVnx8TmECUrJV1eD1Xlf+VQoxtzEbselcu31gRfRfaOk/z7916Y/h6oLUfjaJ10nHleN5KhHubs5IVAUyu0euZa++C8jfJbROPQCXNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192238; c=relaxed/simple;
	bh=vk8vNDFLpYNamNRhB4AV4jYUdvqJ65wMK5XAh3tYC48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVQtUpM6B9s2b4G3jx531z6UjxnwfSh8u1KlIeIH7/tBg4cyYLiO+Yli7muawd1Yf9VG/mDem9th/MF5HB5VqgR86xALKNDgJbsbTqV3KM2nprFzVlFl0E+S2JQqUx+L2l0SnhUSZW2J5OG86ee7RJ6SEbvHZCK7+ocn9wVtKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM1dvpJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM1dvpJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63FDC113CC;
	Mon, 15 Apr 2024 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192238;
	bh=vk8vNDFLpYNamNRhB4AV4jYUdvqJ65wMK5XAh3tYC48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM1dvpJjY6adyNzV4VI0gwRjBCpZWHIZ5lrurk3vf6ndVBehEDjWSS8AlnoS1TYBe
	 GGFE9XqvDDMdm89LpolkpO8jA121D/yOf8Mc5g/0mBXxo3HiZW7WgDNhuuGnOqjzuO
	 BRuH+4pulGkj+n7BudWIjaqITwpHokmnirhogMTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 41/45] x86/bugs: Fix BHI handling of RRSBA
Date: Mon, 15 Apr 2024 16:21:48 +0200
Message-ID: <20240415141943.475976085@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1515,20 +1515,25 @@ static enum spectre_v2_mitigation __init
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
@@ -1629,9 +1634,11 @@ static void __init bhi_select_mitigation
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
@@ -2788,8 +2795,7 @@ static const char *spectre_bhi_state(voi
 		return "; BHI: BHI_DIS_S";
 	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
 		return "; BHI: SW loop, KVM: SW loop";
-	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
-		 !(x86_arch_cap_msr & ARCH_CAP_RRSBA))
+	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) && rrsba_disabled)
 		return "; BHI: Retpoline";
 	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
 		return "; BHI: Syscall hardening, KVM: SW loop";


