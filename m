Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856A61A593
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUCdOO1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013D3C433C8;
	Mon,  9 Oct 2023 13:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857428;
	bh=SCWfLcauwZYBHiQWvoVlmzZssnsihl+4rl21N6OFsxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUCdOO1pjL922zRj66C7X7WkZPf1ylGZ9MoblQ+e2Y/smpCHDucb3wqpRC0fhv/fX
	 mOiUPe5UzaTX9YrY9GBZB7NN7o7BxWC8zqd2pHHZMQ3TTEOE53FPh916NHWQoxuRt6
	 5rXsSBXOQPYoWeoK92SjnbUOqK6Arkr0MD6AkNq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 042/162] arm64: cpufeature: Fix CLRBHB and BC detection
Date: Mon,  9 Oct 2023 15:00:23 +0200
Message-ID: <20231009130124.103268657@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kristina Martsenko <kristina.martsenko@arm.com>

commit 479965a2b7ec481737df0cadf553331063b9c343 upstream.

ClearBHB support is indicated by the CLRBHB field in ID_AA64ISAR2_EL1.
Following some refactoring the kernel incorrectly checks the BC field
instead. Fix the detection to use the right field.

(Note: The original ClearBHB support had it as FTR_HIGHER_SAFE, but this
patch uses FTR_LOWER_SAFE, which seems more correct.)

Also fix the detection of BC (hinted conditional branches) to use
FTR_LOWER_SAFE, so that it is not reported on mismatched systems.

Fixes: 356137e68a9f ("arm64/sysreg: Make BHB clear feature defines match the architecture")
Fixes: 8fcc8285c0e3 ("arm64/sysreg: Convert ID_AA64ISAR2_EL1 to automatic generation")
Cc: stable@vger.kernel.org
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230912133429.2606875-1-kristina.martsenko@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    2 +-
 arch/arm64/kernel/cpufeature.c      |    3 ++-
 arch/arm64/tools/sysreg             |    6 +++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -670,7 +670,7 @@ static inline bool supports_clearbhb(int
 		isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
 
 	return cpuid_feature_extract_unsigned_field(isar2,
-						    ID_AA64ISAR2_EL1_BC_SHIFT);
+						    ID_AA64ISAR2_EL1_CLRBHB_SHIFT);
 }
 
 const struct cpumask *system_32bit_el0_cpumask(void);
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -212,7 +212,8 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_EL1_BC_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_CLRBHB_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_BC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_EXACT, ID_AA64ISAR2_EL1_APA3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -484,7 +484,11 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64ISAR2_EL1	3	0	0	6	2
-Res0	63:28
+Res0	63:32
+Enum	31:28	CLRBHB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 Enum	27:24	PAC_frac
 	0b0000	NI
 	0b0001	IMP


