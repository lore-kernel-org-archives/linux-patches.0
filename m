Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8910E7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D46C433D6;
	Wed,  2 Nov 2022 03:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358684;
	bh=J4PEPui/C3sTTbsISG1gN2vUDlFycjRnixpyQZ6oqGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj5qOH/xwdH5T5ERzdauciPHATI3BY2AmhYdsT4AIJ5Y/rXB6iXE2gpOiu0+PWycu
	 29X4diy0RPldb8xSFYOIY8NEhtxDAO2IxAEbn5lKH7V62yUdeb/PkD2Re0t7zEWfuM
	 wb0RlIDYwPFj3+Z1ofRCCjrVemu79wAMp0BvE9jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	D Scott Phillips <scott@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/132] arm64: Add AMPERE1 to the Spectre-BHB affected list
Date: Wed,  2 Nov 2022 03:33:52 +0100
Message-Id: <20221102022102.983129214@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: D Scott Phillips <scott@os.amperecomputing.com>

[ Upstream commit 0e5d5ae837c8ce04d2ddb874ec5f920118bd9d31 ]

Per AmpereOne erratum AC03_CPU_12, "Branch history may allow control of
speculative execution across software contexts," the AMPERE1 core needs the
bhb clearing loop to mitigate Spectre-BHB, with a loop iteration count of
11.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20221011022140.432370-1-scott@os.amperecomputing.com
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h |    4 ++++
 arch/arm64/kernel/proton-pack.c  |    6 ++++++
 2 files changed, 10 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -60,6 +60,7 @@
 #define ARM_CPU_IMP_FUJITSU		0x46
 #define ARM_CPU_IMP_HISI		0x48
 #define ARM_CPU_IMP_APPLE		0x61
+#define ARM_CPU_IMP_AMPERE		0xC0
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -112,6 +113,8 @@
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
 
+#define AMPERE_CPU_PART_AMPERE1		0xAC3
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -151,6 +154,7 @@
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
+#define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -868,6 +868,10 @@ u8 spectre_bhb_loop_affected(int scope)
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 			{},
 		};
+		static const struct midr_range spectre_bhb_k11_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+			{},
+		};
 		static const struct midr_range spectre_bhb_k8_list[] = {
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -878,6 +882,8 @@ u8 spectre_bhb_loop_affected(int scope)
 			k = 32;
 		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
 			k = 24;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k11_list))
+			k = 11;
 		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
 			k =  8;
 


