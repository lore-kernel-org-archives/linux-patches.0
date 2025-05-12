Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E66293B6B;
	Mon, 12 May 2025 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072567; cv=none; b=Idc1T0H7w/d0+qKInmstz2KVb5izc3mUFsdtIK1wC8LfOLd/UEZ4kO6yAHKDaJjDFU9scRPLXGg+Yvf9sj99FCaSh0qi9JbuotBMJn/DO4JVle46FU9fh1Q7TloqdYI4yMjknXY5LK/pvaR2DqcKGBbWaCa/b6MwLO15hDqsrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072567; c=relaxed/simple;
	bh=n2mzLF8u1gak5/rJsxVedZFG5/i4WxN2hFfb+rs/Cb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4VZSRQRj04p1hD00iih18D8YKmGMZpzVkckD0pK4qwZpfQIGAEqHvRBFrhfnAibwqHY18uyYuKm8joyZNJLEoGB25JCI3Rd6MBaWqmxf4r2THB3iV6hoSEIBZUZ5J5kEVk5tzyhymDGJr0cGkmW1S/jCl1k+AQcy6KAbnaRStA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV/eZ8Bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV/eZ8Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A62AC4CEE9;
	Mon, 12 May 2025 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072566;
	bh=n2mzLF8u1gak5/rJsxVedZFG5/i4WxN2hFfb+rs/Cb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vV/eZ8BlXmE2WfeRsfuFqyfwdlpqWibzfVcZuWMEzw4d2hsOgtz+jAm43ZoeNSCpQ
	 8FKgTkPyFGFAY2xWvbbIhw20oSdyg2Mxe3C/AtfppRX8CGmHMwsRfwduJY85Z+70bB
	 5tNHrUuXksvjiTn9mNd0pBUq/JE5ZQdQkMsOwThY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.1 80/92] x86/bhi: Do not set BHI_DIS_S in 32-bit mode
Date: Mon, 12 May 2025 19:45:55 +0200
Message-ID: <20250512172026.382342144@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 073fdbe02c69c43fb7c0d547ec265c7747d4a646 upstream.

With the possibility of intra-mode BHI via cBPF, complete mitigation for
BHI is to use IBHF (history fence) instruction with BHI_DIS_S set. Since
this new instruction is only available in 64-bit mode, setting BHI_DIS_S in
32-bit mode is only a partial mitigation.

Do not set BHI_DIS_S in 32-bit mode so as to avoid reporting misleading
mitigated status. With this change IBHF won't be used in 32-bit mode, also
remove the CONFIG_X86_64 check from emit_spectre_bhb_barrier().

Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c  |    5 +++--
 arch/x86/net/bpf_jit_comp.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1656,10 +1656,11 @@ static void __init bhi_select_mitigation
 			return;
 	}
 
-	if (spec_ctrl_bhi_dis())
+	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
 
-	if (!IS_ENABLED(CONFIG_X86_64))
+	/* Mitigate in hardware if supported */
+	if (spec_ctrl_bhi_dis())
 		return;
 
 	/* Mitigate KVM by default */
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -971,8 +971,7 @@ static int emit_spectre_bhb_barrier(u8 *
 	/* Insert IBHF instruction */
 	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&
 	     cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) ||
-	    (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW) &&
-	     IS_ENABLED(CONFIG_X86_64))) {
+	    cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW)) {
 		/*
 		 * Add an Indirect Branch History Fence (IBHF). IBHF acts as a
 		 * fence preventing branch history from before the fence from
@@ -982,6 +981,8 @@ static int emit_spectre_bhb_barrier(u8 *
 		 * hardware that doesn't need or support it.  The REP and REX.W
 		 * prefixes are required by the microcode, and they also ensure
 		 * that the NOP is unlikely to be used in existing code.
+		 *
+		 * IBHF is not a valid instruction in 32-bit mode.
 		 */
 		EMIT5(0xF3, 0x48, 0x0F, 0x1E, 0xF8); /* ibhf */
 	}


