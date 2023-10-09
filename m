Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B6917990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SM9kPehT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F87C433C8;
	Mon,  9 Oct 2023 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856871;
	bh=Z8NUSYRi+WUxlLFr3tm1rXBoH8Y0KBF6HPG0U9rETcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SM9kPehTeOjadogBVR3gkCgn8w0390lRcNcVSadPxWmox3dlZWik5Ybvegwp7OHZb
	 2Gp7Jp4JFBJ+DWl9ic7w0VjxoYDakst7b35Eu8oJHN9vuioNx++fGYu3kSk8Z8igEf
	 SSOZftpPQbNOGa2o8UbfzDWWbW8n+rvVuczGx/N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 019/163] arm64: cpufeature: Fix CLRBHB and BC detection
Date: Mon,  9 Oct 2023 14:59:43 +0200
Message-ID: <20231009130124.543506050@linuxfoundation.org>
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

From: Kristina Martsenko <kristina.martsenko@arm.com>

[ Upstream commit 479965a2b7ec481737df0cadf553331063b9c343 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 arch/arm64/kernel/cpufeature.c      | 3 ++-
 arch/arm64/tools/sysreg             | 6 +++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 96e50227f940e..5bba393760557 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -663,7 +663,7 @@ static inline bool supports_clearbhb(int scope)
 		isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
 
 	return cpuid_feature_extract_unsigned_field(isar2,
-						    ID_AA64ISAR2_EL1_BC_SHIFT);
+						    ID_AA64ISAR2_EL1_CLRBHB_SHIFT);
 }
 
 const struct cpumask *system_32bit_el0_cpumask(void);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ac764c1dac363..2c0b8444fea67 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -222,7 +222,8 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_CSSC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_RPRFM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_EL1_BC_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_CLRBHB_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_BC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_EL1_MOPS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_EXACT, ID_AA64ISAR2_EL1_APA3_SHIFT, 4, 0),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 65866bf819c33..ffc81afa6caca 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1347,7 +1347,11 @@ UnsignedEnum	51:48	RPRFM
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Res0	47:28
+Res0	47:32
+UnsignedEnum	31:28	CLRBHB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 UnsignedEnum	27:24	PAC_frac
 	0b0000	NI
 	0b0001	IMP
-- 
2.40.1



