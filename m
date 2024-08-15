Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8F219E7EF;
	Thu, 15 Aug 2024 13:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729040; cv=none; b=foSpM5sa7K4MH3BYuZcXTEuuFuFrwqgU/jbcXh+YaQxqpFQ194O7iLwyRElwmAQJu2KgSyhElN/X6eXUEvfzCGstllr5trHPICiw4WF2+qJxMB5VwAZYUBQP72ldUwtF2eQ8NRibERwzpowR7AZOuLz1qOF1WIFUKGi6QN1mhQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729040; c=relaxed/simple;
	bh=F9ltnEpaIH40Y2Lz6nivc0RVFL88Nl6ay4rCUcUYtIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2jevWg1OfMW0b7lIJqXMtwn0z00icJR1Q5dAljMYL4+z+Tje+RaZ+VlFNG5IibZ8LvbSfgiAnKXOStAP6bLDWyxGmCUaApjMt/4JBtf1wzkgOS/PVO0qowrUsRuyn7LDJCBDDSyonvmCyFj6B1tkubqdm0oJRJzXfUqMDgU8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ob9zOc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ob9zOc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B044EC32786;
	Thu, 15 Aug 2024 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729040;
	bh=F9ltnEpaIH40Y2Lz6nivc0RVFL88Nl6ay4rCUcUYtIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ob9zOc7ItuqgsCx/rZ2/s9nsWwYDqIzxdsBQ1Sx0EQYTreyj8dJFiAZBs2VrgE6F
	 FhTs4Pb97HrI9qhyI7oqGgvfXJ/degaydU0OIXBdXryhT8lRyTE0/wK4SolbhZ3BeM
	 gPo82w5jsLA3sc07Ob4hA15sQI5zVBrlhu/9TNhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Amit Daniel Kachhap <amit.kachhap@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 192/196] arm64: cpufeature: Fix the visibility of compat hwcaps
Date: Thu, 15 Aug 2024 15:25:09 +0200
Message-ID: <20240815131859.417000648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Daniel Kachhap <amit.kachhap@arm.com>

commit 85f1506337f0c79a4955edfeee86a18628e3735f upstream.

Commit 237405ebef58 ("arm64: cpufeature: Force HWCAP to be based on the
sysreg visible to user-space") forced the hwcaps to use sanitised
user-space view of the id registers. However, the ID register structures
used to select few compat cpufeatures (vfp, crc32, ...) are masked and
hence such hwcaps do not appear in /proc/cpuinfo anymore for PER_LINUX32
personality.

Add the ID register structures explicitly and set the relevant entry as
visible. As these ID registers are now of type visible so make them
available in 64-bit userspace by making necessary changes in register
emulation logic and documentation.

While at it, update the comment for structure ftr_generic_32bits[] which
lists the ID register that use it.

Fixes: 237405ebef58 ("arm64: cpufeature: Force HWCAP to be based on the sysreg visible to user-space")
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Link: https://lore.kernel.org/r/20221103082232.19189-1-amit.kachhap@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   42 ++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -274,6 +274,30 @@ static const struct arm64_ftr_bits ftr_i
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_mvfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPROUND_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPSHVEC_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPSQRT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPDIVIDE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPTRAP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPDP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_FPSP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_SIMD_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
+static const struct arm64_ftr_bits ftr_mvfr1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_SIMDFMAC_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_FPHP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_SIMDHP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_SIMDSP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_SIMDINT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_SIMDLS_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_FPDNAN_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR1_FPFTZ_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_mvfr2[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 4, 4, 0),		/* FPMisc */
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 0, 4, 0),		/* SIMDMisc */
@@ -289,10 +313,10 @@ static const struct arm64_ftr_bits ftr_d
 
 static const struct arm64_ftr_bits ftr_id_isar5[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_RDM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_CRC32_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SHA2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SHA1_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_AES_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_CRC32_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SHA2_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SHA1_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_AES_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SEVL_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
@@ -332,7 +356,7 @@ static const struct arm64_ftr_bits ftr_z
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
  * 0. Covers the following 32bit registers:
- * id_isar[0-4], id_mmfr[1-3], id_pfr1, mvfr[0-1]
+ * id_isar[1-3], id_mmfr[1-3]
  */
 static const struct arm64_ftr_bits ftr_generic_32bits[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 28, 4, 0),
@@ -387,8 +411,8 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_ID_MMFR4_EL1, ftr_id_mmfr4),
 
 	/* Op1 = 0, CRn = 0, CRm = 3 */
-	ARM64_FTR_REG(SYS_MVFR0_EL1, ftr_generic_32bits),
-	ARM64_FTR_REG(SYS_MVFR1_EL1, ftr_generic_32bits),
+	ARM64_FTR_REG(SYS_MVFR0_EL1, ftr_mvfr0),
+	ARM64_FTR_REG(SYS_MVFR1_EL1, ftr_mvfr1),
 	ARM64_FTR_REG(SYS_MVFR2_EL1, ftr_mvfr2),
 
 	/* Op1 = 0, CRn = 0, CRm = 4 */
@@ -1887,7 +1911,7 @@ cpufeature_pan_not_uao(const struct arm6
 
 /*
  * We emulate only the following system register space.
- * Op0 = 0x3, CRn = 0x0, Op1 = 0x0, CRm = [0, 4 - 7]
+ * Op0 = 0x3, CRn = 0x0, Op1 = 0x0, CRm = [0, 2 - 7]
  * See Table C5-6 System instruction encodings for System register accesses,
  * ARMv8 ARM(ARM DDI 0487A.f) for more details.
  */
@@ -1897,7 +1921,7 @@ static inline bool __attribute_const__ i
 		sys_reg_CRn(id) == 0x0 &&
 		sys_reg_Op1(id) == 0x0 &&
 		(sys_reg_CRm(id) == 0 ||
-		 ((sys_reg_CRm(id) >= 4) && (sys_reg_CRm(id) <= 7))));
+		 ((sys_reg_CRm(id) >= 2) && (sys_reg_CRm(id) <= 7))));
 }
 
 /*


