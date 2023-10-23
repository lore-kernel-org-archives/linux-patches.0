Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EAD15EA7
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJt6dxiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4ACC433C7;
	Mon, 23 Oct 2023 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061504;
	bh=wIv5axdTp+ZUSnINp0piZ3vBSXTi3a+cOuypXLYLzz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJt6dxiKQPfsX0VtyuFW1FmMXUt2Gk3y8cyGlf2kdoL/MFdPAHC676oLE2+0AE2xj
	 dr7EiEuMG9IlQu4rENrS7sOd4VUwH/lmoG+2QMNd/vIyXqZuKUbdiiwoNkQDrBMjHv
	 UkyANrTJnCzsGSOuc5mcWQRM0cYU662DP2/gK9K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactcode.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.10 042/202] x86/cpu: Fix AMD erratum #1485 on Zen4-based CPUs
Date: Mon, 23 Oct 2023 12:55:49 +0200
Message-ID: <20231023104827.815185120@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit f454b18e07f518bcd0c05af17a2239138bff52de upstream.

Fix erratum #1485 on Zen4 parts where running with STIBP disabled can
cause an #UD exception. The performance impact of the fix is negligible.

Reported-by: René Rebe <rene@exactcode.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: René Rebe <rene@exactcode.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/D99589F4-BC5D-430B-87B2-72C20370CF57@exactcode.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    9 +++++++--
 arch/x86/kernel/cpu/amd.c        |    8 ++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -541,12 +541,17 @@
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
-/* Fam 17h MSRs */
-#define MSR_F17H_IRPERF			0xc00000e9
+/* Zen4 */
+#define MSR_ZEN4_BP_CFG			0xc001102e
+#define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
+/* Zen 2 */
 #define MSR_ZEN2_SPECTRAL_CHICKEN	0xc00110e3
 #define MSR_ZEN2_SPECTRAL_CHICKEN_BIT	BIT_ULL(1)
 
+/* Fam 17h MSRs */
+#define MSR_F17H_IRPERF			0xc00000e9
+
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -81,6 +81,10 @@ static const int amd_div0[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0x00, 0x0, 0x2f, 0xf),
 			   AMD_MODEL_RANGE(0x17, 0x50, 0x0, 0x5f, 0xf));
 
+static const int amd_erratum_1485[] =
+	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x19, 0x10, 0x0, 0x1f, 0xf),
+			   AMD_MODEL_RANGE(0x19, 0x60, 0x0, 0xaf, 0xf));
+
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 {
 	int osvw_id = *erratum++;
@@ -1178,6 +1182,10 @@ static void init_amd(struct cpuinfo_x86
 		pr_notice_once("AMD Zen1 DIV0 bug detected. Disable SMT for full protection.\n");
 		setup_force_cpu_bug(X86_BUG_DIV0);
 	}
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
+	     cpu_has_amd_erratum(c, amd_erratum_1485))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
 }
 
 #ifdef CONFIG_X86_32


