Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BD121ABC6;
	Tue, 29 Apr 2025 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949629; cv=none; b=BLiZKoJ1f/ml4hkdU1AVwcebo8hITUUhi65TxnprQMwpqeTn6/eG2U8i0VO+hwKbl9Q7CBxz5yB052k3wWMQM5cdM5JgBC2uNFfuTHpGrL87CCdR/D2V+ALPR3DpCOeVXEoFAdVB0lVrxN9XGpo89LTCg69Hva8Viqp/+N05xSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949629; c=relaxed/simple;
	bh=2/KfwrZx+uqILIthH9I7cJwIQBMKoW5bSYbJ2BlTYYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psKzRBj0GMzVdY6v/3WO6af3ChBx3/89HyCCfgfVGx+ogvx2vGcPJVjgD/ddIIfAkq0cmThyuysVZV0BsiQmWu+5lEmGEoyYft4WVoCmmDDX0UGXsyqqEQ7pCsyXU4nchs3bkWyyzeEeg+ueStZ88kmwxXcRPD1C6HJQHtyWQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OG2or51i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG2or51i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BB1C4CEE3;
	Tue, 29 Apr 2025 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949629;
	bh=2/KfwrZx+uqILIthH9I7cJwIQBMKoW5bSYbJ2BlTYYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG2or51iOTawXtUPQFvPLB8H8cQo4G3UXpYY2sshXoWKmzWS9gNyQqmHCzGfeZuy8
	 maSWbTzDhYahHyLZiah1I2onpP6sUC5VvdDXlJU2W06Z48yKp8KN841LgQunHaUY/s
	 OcB4s7XfcnPZfxQzcqIMBdA42DrAXO8lb+GVKQp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Amit Shah <amit.shah@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/373] x86/bugs: Dont fill RSB on context switch with eIBRS
Date: Tue, 29 Apr 2025 18:43:48 +0200
Message-ID: <20250429161137.573014012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 27ce8299bc1ec6df8306073785ff82b30b3cc5ee ]

User->user Spectre v2 attacks (including RSB) across context switches
are already mitigated by IBPB in cond_mitigation(), if enabled globally
or if either the prev or the next task has opted in to protection.  RSB
filling without IBPB serves no purpose for protecting user space, as
indirect branches are still vulnerable.

User->kernel RSB attacks are mitigated by eIBRS.  In which case the RSB
filling on context switch isn't needed, so remove it.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/98cdefe42180358efebf78e3b80752850c7a3e1b.1744148254.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 24 ++++++++++++------------
 arch/x86/mm/tlb.c          |  6 +++---
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 018ef230f02ce..75cd45f2338dc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1553,7 +1553,7 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 	rrsba_disabled = true;
 }
 
-static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
+static void __init spectre_v2_select_rsb_mitigation(enum spectre_v2_mitigation mode)
 {
 	/*
 	 * Similar to context switches, there are two types of RSB attacks
@@ -1577,7 +1577,7 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	 */
 	switch (mode) {
 	case SPECTRE_V2_NONE:
-		return;
+		break;
 
 	case SPECTRE_V2_EIBRS:
 	case SPECTRE_V2_EIBRS_LFENCE:
@@ -1586,18 +1586,21 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
 			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
-		return;
+		break;
 
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		pr_info("Spectre v2 / SpectreRSB: Filling RSB on context switch and VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
-		return;
-	}
+		break;
 
-	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
-	dump_stack();
+	default:
+		pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation\n");
+		dump_stack();
+		break;
+	}
 }
 
 /*
@@ -1822,10 +1825,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 *
 	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
-	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
-	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
-
-	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+	spectre_v2_select_rsb_mitigation(mode);
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 19d083ad2de79..94a23fcb20737 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -384,9 +384,9 @@ static void cond_mitigation(struct task_struct *next)
 	prev_mm = this_cpu_read(cpu_tlbstate.last_user_mm_spec);
 
 	/*
-	 * Avoid user/user BTB poisoning by flushing the branch predictor
-	 * when switching between processes. This stops one process from
-	 * doing Spectre-v2 attacks on another.
+	 * Avoid user->user BTB/RSB poisoning by flushing them when switching
+	 * between processes. This stops one process from doing Spectre-v2
+	 * attacks on another.
 	 *
 	 * Both, the conditional and the always IBPB mode use the mm
 	 * pointer to avoid the IBPB when switching between tasks of the
-- 
2.39.5



