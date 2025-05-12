Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF1B254863;
	Mon, 12 May 2025 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072276; cv=none; b=N7y3k3ercCqFkz5GlXkf0dYps9FQRwY0N6hP4gsC3HuqWg5b7DG08UpYNcc28u2JhC3FNbFWwUYtjYRdKFv+NLS/1sL5H8V1nKLOR4Z28OJ86WgVZf6cqRsTGIPx8ninuSxaM09/eQtj1mhqvksi64ua3cFYGlM2Sm4cDXTLdPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072276; c=relaxed/simple;
	bh=NbstpcZVAeZapqjdeJVQRHVMX8BmtzKE0BOBZTkknxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGBVXFvBpJXDbILe68ZO5q+CQURiPmb6UksU0DAvsj5FgE/cVnSVIvv0rGL1cnqBehViuig0e4EU7Bhc1k2UkmGHKxiYqA6RfvH4UrE3/Uu9OHZVCRSXtarJcTgGQdmwW2NGwr7Y5EQtQNq1K13LzKBpq2Sqsw7edAypDRddiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjRCuWDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjRCuWDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45E5C4CEE7;
	Mon, 12 May 2025 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072276;
	bh=NbstpcZVAeZapqjdeJVQRHVMX8BmtzKE0BOBZTkknxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjRCuWDiWpjwJ5qeWux4ytIDwyJ0y/79oZF/0T4MldRx6S2NvxjKk9BFFGnBFU7yq
	 34rfBXbHEFcANUWeRVuES4eat1US66uioE/gureruxuAHqhW66AlcQd0VxrtYygrKn
	 49wMXTKao0gRi6iEgHN1B+GB7fn4Mvw4c3Rr+HBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.14 186/197] x86/bhi: Do not set BHI_DIS_S in 32-bit mode
Date: Mon, 12 May 2025 19:40:36 +0200
Message-ID: <20250512172051.958215563@linuxfoundation.org>
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
 arch/x86/kernel/cpu/bugs.c  |    6 +++---
 arch/x86/net/bpf_jit_comp.c |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1684,11 +1684,11 @@ static void __init bhi_select_mitigation
 			return;
 	}
 
-	/* Mitigate in hardware if supported */
-	if (spec_ctrl_bhi_dis())
+	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
 
-	if (!IS_ENABLED(CONFIG_X86_64))
+	/* Mitigate in hardware if supported */
+	if (spec_ctrl_bhi_dis())
 		return;
 
 	if (bhi_mitigation == BHI_MITIGATION_VMEXIT_ONLY) {
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1475,8 +1475,7 @@ static int emit_spectre_bhb_barrier(u8 *
 	/* Insert IBHF instruction */
 	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&
 	     cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) ||
-	    (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW) &&
-	     IS_ENABLED(CONFIG_X86_64))) {
+	    cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW)) {
 		/*
 		 * Add an Indirect Branch History Fence (IBHF). IBHF acts as a
 		 * fence preventing branch history from before the fence from
@@ -1486,6 +1485,8 @@ static int emit_spectre_bhb_barrier(u8 *
 		 * hardware that doesn't need or support it.  The REP and REX.W
 		 * prefixes are required by the microcode, and they also ensure
 		 * that the NOP is unlikely to be used in existing code.
+		 *
+		 * IBHF is not a valid instruction in 32-bit mode.
 		 */
 		EMIT5(0xF3, 0x48, 0x0F, 0x1E, 0xF8); /* ibhf */
 	}


