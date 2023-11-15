Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA479364BE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aH5ivbdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9E5C433C7;
	Wed, 15 Nov 2023 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076752;
	bh=nwftkS4Z1uhcRzyS8LUhIiplnmQfikcPZwgzKyTzuUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aH5ivbdit2LRv2FsIpeaBJDZUhHItjJwTTcj+/fe+joGtudSLAH5NnaAJJ179d9+U
	 YIbtec5nWw55zcb0AjD+LWXLZbE7Ome1kXYYJaLJBeIpCehJU1Dfam8C4pYVzBmVc1
	 1ypt8dXMfCLjjRUKxtM7F4xj1zcXGYYf4bK4FroE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/603] x86/srso: Fix vulnerability reporting for missing microcode
Date: Wed, 15 Nov 2023 14:09:21 -0500
Message-ID: <20231115191614.288643402@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit dc6306ad5b0dda040baf1fde3cfd458e6abfc4da ]

The SRSO default safe-ret mitigation is reported as "mitigated" even if
microcode hasn't been updated.  That's wrong because userspace may still
be vulnerable to SRSO attacks due to IBPB not flushing branch type
predictions.

Report the safe-ret + !microcode case as vulnerable.

Also report the microcode-only case as vulnerable as it leaves the
kernel open to attacks.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/a8a14f97d1b0e03ec255c81637afdf4cf0ae9c99.1693889988.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/hw-vuln/srso.rst | 24 ++++++++++-----
 arch/x86/kernel/cpu/bugs.c                 | 36 +++++++++++++---------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/srso.rst b/Documentation/admin-guide/hw-vuln/srso.rst
index b6cfb51cb0b46..e715bfc09879a 100644
--- a/Documentation/admin-guide/hw-vuln/srso.rst
+++ b/Documentation/admin-guide/hw-vuln/srso.rst
@@ -46,12 +46,22 @@ The possible values in this file are:
 
    The processor is not vulnerable
 
- * 'Vulnerable: no microcode':
+* 'Vulnerable':
+
+   The processor is vulnerable and no mitigations have been applied.
+
+ * 'Vulnerable: No microcode':
 
    The processor is vulnerable, no microcode extending IBPB
    functionality to address the vulnerability has been applied.
 
- * 'Mitigation: microcode':
+ * 'Vulnerable: Safe RET, no microcode':
+
+   The "Safe RET" mitigation (see below) has been applied to protect the
+   kernel, but the IBPB-extending microcode has not been applied.  User
+   space tasks may still be vulnerable.
+
+ * 'Vulnerable: Microcode, no safe RET':
 
    Extended IBPB functionality microcode patch has been applied. It does
    not address User->Kernel and Guest->Host transitions protection but it
@@ -72,11 +82,11 @@ The possible values in this file are:
 
    (spec_rstack_overflow=microcode)
 
- * 'Mitigation: safe RET':
+ * 'Mitigation: Safe RET':
 
-   Software-only mitigation. It complements the extended IBPB microcode
-   patch functionality by addressing User->Kernel and Guest->Host
-   transitions protection.
+   Combined microcode/software mitigation. It complements the
+   extended IBPB microcode patch functionality by addressing
+   User->Kernel and Guest->Host transitions protection.
 
    Selected by default or by spec_rstack_overflow=safe-ret
 
@@ -129,7 +139,7 @@ an indrect branch prediction barrier after having applied the required
 microcode patch for one's system. This mitigation comes also at
 a performance cost.
 
-Mitigation: safe RET
+Mitigation: Safe RET
 --------------------
 
 The mitigation works by ensuring all RET instructions speculate to
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d5db0baca2f14..a55a3864df1c9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2353,6 +2353,8 @@ early_param("l1tf", l1tf_cmdline);
 
 enum srso_mitigation {
 	SRSO_MITIGATION_NONE,
+	SRSO_MITIGATION_UCODE_NEEDED,
+	SRSO_MITIGATION_SAFE_RET_UCODE_NEEDED,
 	SRSO_MITIGATION_MICROCODE,
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
@@ -2368,11 +2370,13 @@ enum srso_mitigation_cmd {
 };
 
 static const char * const srso_strings[] = {
-	[SRSO_MITIGATION_NONE]           = "Vulnerable",
-	[SRSO_MITIGATION_MICROCODE]      = "Mitigation: microcode",
-	[SRSO_MITIGATION_SAFE_RET]	 = "Mitigation: safe RET",
-	[SRSO_MITIGATION_IBPB]		 = "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT] = "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_NONE]			= "Vulnerable",
+	[SRSO_MITIGATION_UCODE_NEEDED]		= "Vulnerable: No microcode",
+	[SRSO_MITIGATION_SAFE_RET_UCODE_NEEDED]	= "Vulnerable: Safe RET, no microcode",
+	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
+	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
+	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2409,10 +2413,7 @@ static void __init srso_select_mitigation(void)
 	if (!boot_cpu_has_bug(X86_BUG_SRSO) || cpu_mitigations_off())
 		goto pred_cmd;
 
-	if (!has_microcode) {
-		pr_warn("IBPB-extending microcode not applied!\n");
-		pr_warn(SRSO_NOTICE);
-	} else {
+	if (has_microcode) {
 		/*
 		 * Zen1/2 with SMT off aren't vulnerable after the right
 		 * IBPB microcode has been applied.
@@ -2428,6 +2429,12 @@ static void __init srso_select_mitigation(void)
 			srso_mitigation = SRSO_MITIGATION_IBPB;
 			goto out;
 		}
+	} else {
+		pr_warn("IBPB-extending microcode not applied!\n");
+		pr_warn(SRSO_NOTICE);
+
+		/* may be overwritten by SRSO_CMD_SAFE_RET below */
+		srso_mitigation = SRSO_MITIGATION_UCODE_NEEDED;
 	}
 
 	switch (srso_cmd) {
@@ -2457,7 +2464,10 @@ static void __init srso_select_mitigation(void)
 				setup_force_cpu_cap(X86_FEATURE_SRSO);
 				x86_return_thunk = srso_return_thunk;
 			}
-			srso_mitigation = SRSO_MITIGATION_SAFE_RET;
+			if (has_microcode)
+				srso_mitigation = SRSO_MITIGATION_SAFE_RET;
+			else
+				srso_mitigation = SRSO_MITIGATION_SAFE_RET_UCODE_NEEDED;
 		} else {
 			pr_err("WARNING: kernel not compiled with CPU_SRSO.\n");
 			goto pred_cmd;
@@ -2493,7 +2503,7 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
-	pr_info("%s%s\n", srso_strings[srso_mitigation], has_microcode ? "" : ", no microcode");
+	pr_info("%s\n", srso_strings[srso_mitigation]);
 
 pred_cmd:
 	if ((!boot_cpu_has_bug(X86_BUG_SRSO) || srso_cmd == SRSO_CMD_OFF) &&
@@ -2704,9 +2714,7 @@ static ssize_t srso_show_state(char *buf)
 	if (boot_cpu_has(X86_FEATURE_SRSO_NO))
 		return sysfs_emit(buf, "Mitigation: SMT disabled\n");
 
-	return sysfs_emit(buf, "%s%s\n",
-			  srso_strings[srso_mitigation],
-			  boot_cpu_has(X86_FEATURE_IBPB_BRTYPE) ? "" : ", no microcode");
+	return sysfs_emit(buf, "%s\n", srso_strings[srso_mitigation]);
 }
 
 static ssize_t gds_show_state(char *buf)
-- 
2.42.0



