Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCFF1A7067;
	Thu, 15 Aug 2024 14:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730661; cv=none; b=rryfShAZR226QVIjeeBht9/m2d4lVDJAPu3sSOh8bBoFQQC1AGSbmUi0TGgtGsVPCThAOPH9HsNjrxMGxYP/zlzka5oYesgBvEj59n15U8zKwZGNyDFPnlPU97rrx7QHFYqbKFxdiy5HDGO4eOG7jFD7royXiZbGrqes+eqKu+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730661; c=relaxed/simple;
	bh=xJ9Df5eCIx6OeHuRc0MAA7m2IiiBc8++9qjpHPrnYw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsE9lfz8YOEuL9fY/OVLu3RVpybORA55UDWRdYMC6zZVUPhoXL0FNuvWjGbCos4CUKUxESSaeFC2AeZdxRDMzALT+kQXnMOeBnJvshaILZwcAuv3MZwzgyScTmtuVxBgfKmrKlD42RKkJV95VXFubQ2GFVGIea45QiFp66AU27c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwz0FuuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwz0FuuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E200C32786;
	Thu, 15 Aug 2024 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730661;
	bh=xJ9Df5eCIx6OeHuRc0MAA7m2IiiBc8++9qjpHPrnYw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwz0FuuRxI3ClhHp3duthAKddTpDqMWvwVo18GsX4nb12PuiQdd2hP1yNvzeu1e/p
	 nDcUpa3Eh0/Z+b2wYuwF0V/l1KuVomYohOoqTfE4ow/1FCJh8gcq8aW/0zKdLUwLqp
	 xNnBmcxAxzePds2RLV2w080rgOXBOFggi0Pjee2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Amit Daniel Kachhap <amit.kachhap@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 478/484] arm64: cpufeature: Fix the visibility of compat hwcaps
Date: Thu, 15 Aug 2024 15:25:36 +0200
Message-ID: <20240815131959.945271682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 Documentation/arm64/cpu-feature-registers.rst |   38 ++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c                |   42 ++++++++++++++++++++------
 2 files changed, 70 insertions(+), 10 deletions(-)

--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -92,7 +92,7 @@ operation if the source belongs to the s
 
 The infrastructure emulates only the following system register space::
 
-	Op0=3, Op1=0, CRn=0, CRm=0,4,5,6,7
+	Op0=3, Op1=0, CRn=0, CRm=0,2,3,4,5,6,7
 
 (See Table C5-6 'System instruction encodings for non-Debug System
 register accesses' in ARMv8 ARM DDI 0487A.h, for the list of
@@ -291,6 +291,42 @@ infrastructure:
      | RPRES                        | [7-4]   |    y    |
      +------------------------------+---------+---------+
 
+  10) MVFR0_EL1 - AArch32 Media and VFP Feature Register 0
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | FPDP                         | [11-8]  |    y    |
+     +------------------------------+---------+---------+
+
+  11) MVFR1_EL1 - AArch32 Media and VFP Feature Register 1
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | SIMDFMAC                     | [31-28] |    y    |
+     +------------------------------+---------+---------+
+     | SIMDSP                       | [19-16] |    y    |
+     +------------------------------+---------+---------+
+     | SIMDInt                      | [15-12] |    y    |
+     +------------------------------+---------+---------+
+     | SIMDLS                       | [11-8]  |    y    |
+     +------------------------------+---------+---------+
+
+  12) ID_ISAR5_EL1 - AArch32 Instruction Set Attribute Register 5
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | CRC32                        | [19-16] |    y    |
+     +------------------------------+---------+---------+
+     | SHA2                         | [15-12] |    y    |
+     +------------------------------+---------+---------+
+     | SHA1                         | [11-8]  |    y    |
+     +------------------------------+---------+---------+
+     | AES                          | [7-4]   |    y    |
+     +------------------------------+---------+---------+
+
 
 Appendix I: Example
 -------------------
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -422,6 +422,30 @@ static const struct arm64_ftr_bits ftr_i
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
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR2_FPMISC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR2_SIMDMISC_SHIFT, 4, 0),
@@ -452,10 +476,10 @@ static const struct arm64_ftr_bits ftr_i
 
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
@@ -562,7 +586,7 @@ static const struct arm64_ftr_bits ftr_z
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
  * 0. Covers the following 32bit registers:
- * id_isar[1-4], id_mmfr[1-3], id_pfr1, mvfr[0-1]
+ * id_isar[1-3], id_mmfr[1-3]
  */
 static const struct arm64_ftr_bits ftr_generic_32bits[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 28, 4, 0),
@@ -629,8 +653,8 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_ID_ISAR6_EL1, ftr_id_isar6),
 
 	/* Op1 = 0, CRn = 0, CRm = 3 */
-	ARM64_FTR_REG(SYS_MVFR0_EL1, ftr_generic_32bits),
-	ARM64_FTR_REG(SYS_MVFR1_EL1, ftr_generic_32bits),
+	ARM64_FTR_REG(SYS_MVFR0_EL1, ftr_mvfr0),
+	ARM64_FTR_REG(SYS_MVFR1_EL1, ftr_mvfr1),
 	ARM64_FTR_REG(SYS_MVFR2_EL1, ftr_mvfr2),
 	ARM64_FTR_REG(SYS_ID_PFR2_EL1, ftr_id_pfr2),
 	ARM64_FTR_REG(SYS_ID_DFR1_EL1, ftr_id_dfr1),
@@ -3068,7 +3092,7 @@ static void __maybe_unused cpu_enable_cn
 
 /*
  * We emulate only the following system register space.
- * Op0 = 0x3, CRn = 0x0, Op1 = 0x0, CRm = [0, 4 - 7]
+ * Op0 = 0x3, CRn = 0x0, Op1 = 0x0, CRm = [0, 2 - 7]
  * See Table C5-6 System instruction encodings for System register accesses,
  * ARMv8 ARM(ARM DDI 0487A.f) for more details.
  */
@@ -3078,7 +3102,7 @@ static inline bool __attribute_const__ i
 		sys_reg_CRn(id) == 0x0 &&
 		sys_reg_Op1(id) == 0x0 &&
 		(sys_reg_CRm(id) == 0 ||
-		 ((sys_reg_CRm(id) >= 4) && (sys_reg_CRm(id) <= 7))));
+		 ((sys_reg_CRm(id) >= 2) && (sys_reg_CRm(id) <= 7))));
 }
 
 /*


