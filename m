Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B121770B;
	Mon, 12 May 2025 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071144; cv=none; b=aQmzESyOeb2HAsKIZM57dQ42VMkuRNDw29iwTgBzAI1iLUbGm5XNLATpR5SIwQK0L7uIMLJ6sFLZxZ944dQA3RJaQyHd0Dd/23d7YuLZ6S94s9kCEUqbL/9Yp4S570I3beSSI8SdqOAGKMOm75GZSHdWgwb1EwiZ/GRnH4CZ74g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071144; c=relaxed/simple;
	bh=cqH+aF5TZsi2/y+w4E7+bEJCJbVV+jY7gQZYDLGOD+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui+9q66999PeFN3hky8ujv5MnG1nz/RqVPA1I6gDRkWOX0NuHMBMJqaeZisArNQhjrt3ad9A2xAs3CrQTIHZI7cO+vW7rxOP+ChyOxtaTtjWKSPWb/dOA3a5hCtIYOtTZwmD/Ihj6xITWOjbGkWvfWjxUDhZUc8nUxybI3zNGCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svc2pnn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svc2pnn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90FCC4CEE7;
	Mon, 12 May 2025 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071144;
	bh=cqH+aF5TZsi2/y+w4E7+bEJCJbVV+jY7gQZYDLGOD+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svc2pnn+lPGUwA3dixxSlHoUXAtGwWhnbhREUvkHyXeIyh0xL9nJeWfhVLJJT++Xj
	 EZyjoTsWLgO0HkVt22nJ1lOL21p7XWdBHFToRZxNN9gA+2xHqAuuKNziMAC3aaSpx3
	 PLvZIlqdfJKKh3CPEgIdSjKn+VICDxYzOosdq0UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 5.15 54/54] x86/bhi: Do not set BHI_DIS_S in 32-bit mode
Date: Mon, 12 May 2025 19:30:06 +0200
Message-ID: <20250512172017.818291107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -956,8 +956,7 @@ static int emit_spectre_bhb_barrier(u8 *
 	/* Insert IBHF instruction */
 	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&
 	     cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) ||
-	    (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW) &&
-	     IS_ENABLED(CONFIG_X86_64))) {
+	    cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW)) {
 		/*
 		 * Add an Indirect Branch History Fence (IBHF). IBHF acts as a
 		 * fence preventing branch history from before the fence from
@@ -967,6 +966,8 @@ static int emit_spectre_bhb_barrier(u8 *
 		 * hardware that doesn't need or support it.  The REP and REX.W
 		 * prefixes are required by the microcode, and they also ensure
 		 * that the NOP is unlikely to be used in existing code.
+		 *
+		 * IBHF is not a valid instruction in 32-bit mode.
 		 */
 		EMIT5(0xF3, 0x48, 0x0F, 0x1E, 0xF8); /* ibhf */
 	}


