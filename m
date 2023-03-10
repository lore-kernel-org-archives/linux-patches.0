Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110708825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9F7C4339B;
	Fri, 10 Mar 2023 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460307;
	bh=9DBJ0AgGG6JhtNYrFLU1dpI93pIMrvciTirRuZAVY1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAMDCiFHNjPtIEu5g8O1bCn02efkreu/5Uk1wmF4+YNLYaqvMLCkDQHr/KG8Z59KN
	 WVdg1Fx/C11V2zgUR4/oBIZcBr8d+OXMZJMIpwJPvzo5TgJtUEGvJYV1bkUCga9Sh6
	 BNy1xgyqXLciJ6H60Xksat+M5O+PJHVO+o+L7VEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Breno Leitao <leitao@debian.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/529] x86/bugs: Reset speculation control settings on init
Date: Fri, 10 Mar 2023 14:37:15 +0100
Message-Id: <20230310133818.504613297@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 0125acda7d76b943ca55811df40ed6ec0ecf670f ]

Currently, x86_spec_ctrl_base is read at boot time and speculative bits
are set if Kconfig items are enabled. For example, IBRS is enabled if
CONFIG_CPU_IBRS_ENTRY is configured, etc. These MSR bits are not cleared
if the mitigations are disabled.

This is a problem when kexec-ing a kernel that has the mitigation
disabled from a kernel that has the mitigation enabled. In this case,
the MSR bits are not cleared during the new kernel boot. As a result,
this might have some performance degradation that is hard to pinpoint.

This problem does not happen if the machine is (hard) rebooted because
the bit will be cleared by default.

  [ bp: Massage. ]

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20221128153148.1129350-1-leitao@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/msr-index.h |  4 ++++
 arch/x86/kernel/cpu/bugs.c       | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 5a8ee3b83af2a..f71a177b6b185 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -54,6 +54,10 @@
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
+/* A mask for bits which the kernel toggles when controlling mitigations */
+#define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
+							| SPEC_CTRL_RRSBA_DIS_S)
+
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a2a087a797ae5..c5034986ea444 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -136,9 +136,17 @@ void __init check_bugs(void)
 	 * have unknown values. AMD64_LS_CFG MSR is cached in the early AMD
 	 * init code as it is not enumerated and depends on the family.
 	 */
-	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
+	if (cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL)) {
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 
+		/*
+		 * Previously running kernel (kexec), may have some controls
+		 * turned ON. Clear them and let the mitigations setup below
+		 * rediscover them based on configuration.
+		 */
+		x86_spec_ctrl_base &= ~SPEC_CTRL_MITIGATIONS_MASK;
+	}
+
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
-- 
2.39.2



