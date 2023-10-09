Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190B317990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4zEerOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC5BC433CB;
	Mon,  9 Oct 2023 13:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856868;
	bh=Q7luXdGpRBvMUUAHfmt6dsX9udfWCMsI12cbNGfpItU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4zEerOfJ6YggiRZLyqMrwWU7CHeRB9do44LleoboKZZ5HIYeTtcXKD8+t2+5+VUU
	 yUQcS4WSQZhACjTbkG+exETV9K8qOUCu3TMeyvT/9p9ow4eBFyEL8br4H3jUMMJ6qA
	 oLT55RSFyVco0WL2xl78pcVVlFrPZL5qiI8rBDho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 018/163] arm64: add HWCAP for FEAT_HBC (hinted conditional branches)
Date: Mon,  9 Oct 2023 14:59:42 +0200
Message-ID: <20231009130124.516946674@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joey Gouly <joey.gouly@arm.com>

[ Upstream commit 7f86d128e437990fd08d9e66ae7c1571666cff8a ]

Add a HWCAP for FEAT_HBC, so that userspace can make a decision on using
this feature.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20230804143746.3900803-2-joey.gouly@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 479965a2b7ec ("arm64: cpufeature: Fix CLRBHB and BC detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/hwcap.h      | 1 +
 arch/arm64/include/uapi/asm/hwcap.h | 1 +
 arch/arm64/kernel/cpufeature.c      | 3 ++-
 arch/arm64/kernel/cpuinfo.c         | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 692b1ec663b27..521267478d187 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -138,6 +138,7 @@
 #define KERNEL_HWCAP_SME_B16B16		__khwcap2_feature(SME_B16B16)
 #define KERNEL_HWCAP_SME_F16F16		__khwcap2_feature(SME_F16F16)
 #define KERNEL_HWCAP_MOPS		__khwcap2_feature(MOPS)
+#define KERNEL_HWCAP_HBC		__khwcap2_feature(HBC)
 
 /*
  * This yields a mask that user programs can use to figure out what
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index a2cac4305b1e0..53026f45a5092 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -103,5 +103,6 @@
 #define HWCAP2_SME_B16B16	(1UL << 41)
 #define HWCAP2_SME_F16F16	(1UL << 42)
 #define HWCAP2_MOPS		(1UL << 43)
+#define HWCAP2_HBC		(1UL << 44)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f9d456fe132d8..ac764c1dac363 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -222,7 +222,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_CSSC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_RPRFM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_EL1_BC_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_EL1_BC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_MOPS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_EXACT, ID_AA64ISAR2_EL1_APA3_SHIFT, 4, 0),
@@ -2844,6 +2844,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(ID_AA64ISAR2_EL1, RPRES, IMP, CAP_HWCAP, KERNEL_HWCAP_RPRES),
 	HWCAP_CAP(ID_AA64ISAR2_EL1, WFxT, IMP, CAP_HWCAP, KERNEL_HWCAP_WFXT),
 	HWCAP_CAP(ID_AA64ISAR2_EL1, MOPS, IMP, CAP_HWCAP, KERNEL_HWCAP_MOPS),
+	HWCAP_CAP(ID_AA64ISAR2_EL1, BC, IMP, CAP_HWCAP, KERNEL_HWCAP_HBC),
 #ifdef CONFIG_ARM64_SME
 	HWCAP_CAP(ID_AA64PFR1_EL1, SME, IMP, CAP_HWCAP, KERNEL_HWCAP_SME),
 	HWCAP_CAP(ID_AA64SMFR0_EL1, FA64, IMP, CAP_HWCAP, KERNEL_HWCAP_SME_FA64),
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 58622dc859177..98fda85005353 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -126,6 +126,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_SME_B16B16]	= "smeb16b16",
 	[KERNEL_HWCAP_SME_F16F16]	= "smef16f16",
 	[KERNEL_HWCAP_MOPS]		= "mops",
+	[KERNEL_HWCAP_HBC]		= "hbc",
 };
 
 #ifdef CONFIG_COMPAT
-- 
2.40.1



