Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9FA188CCA;
	Wed, 19 Feb 2025 09:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955879; cv=none; b=eJ/vCmbC5yTzGAm/yv5CL/JI6izqvqp0AAundXnEpoKlaWt/zaLhJRe+utJv92VCgRuLQyD0uyCohXNMlq6Ayh6H4WBKBP8dylDxAMWR0LbHXpFpsy+MVAwDZd2zedD1IQ7g8k85KMRKrkNBqXFdLx66CLfqV0DgiD6Axj+Em04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955879; c=relaxed/simple;
	bh=2VB54XQmzkrSziZR4x+V3IlXHsYtsjHeuE4bKxgx2L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHmyvPFQCat5rcalUlxHN8AFeF9Zn8xhqMg4K/ZnS68DaQCfDX5WqGdr5dv0VTvwIB1o6sl7dMBbcd7evPRGKr2hBEa7YWuPM973NgTps8krP1iqUr9gunwlkOiTM4db9rSMwUYZ38KTdVqw5Xw4BFFQdL7jvDOTRl2Hbd9BV60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7mJvVtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7mJvVtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A69FC4CED1;
	Wed, 19 Feb 2025 09:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955879;
	bh=2VB54XQmzkrSziZR4x+V3IlXHsYtsjHeuE4bKxgx2L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7mJvVtYjJwuTN26gPwVgQ1L/UQ5NjXKGvMsoGrzTKbRqYz38dOu1gKMyqDW1qj1X
	 djqrftM8n9sYnrOGVGbU6UoUHnslRqO/c3iOoeml5GlSbnHE0Y7gGTpk+zdrz1zJnH
	 nw/bqLaOPiuIE+Q2K95rCyfOX+7Pt5EM93q4v7Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.6 144/152] arm64: Filter out SVE hwcaps when FEAT_SVE isnt implemented
Date: Wed, 19 Feb 2025 09:29:17 +0100
Message-ID: <20250219082555.746688971@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 064737920bdbca86df91b96aed256e88018fef3a upstream.

The hwcaps code that exposes SVE features to userspace only
considers ID_AA64ZFR0_EL1, while this is only valid when
ID_AA64PFR0_EL1.SVE advertises that SVE is actually supported.

The expectations are that when ID_AA64PFR0_EL1.SVE is 0, the
ID_AA64ZFR0_EL1 register is also 0. So far, so good.

Things become a bit more interesting if the HW implements SME.
In this case, a few ID_AA64ZFR0_EL1 fields indicate *SME*
features. And these fields overlap with their SVE interpretations.
But the architecture says that the SME and SVE feature sets must
match, so we're still hunky-dory.

This goes wrong if the HW implements SME, but not SVE. In this
case, we end-up advertising some SVE features to userspace, even
if the HW has none. That's because we never consider whether SVE
is actually implemented. Oh well.

Fix it by restricting all SVE capabilities to ID_AA64PFR0_EL1.SVE
being non-zero. The HWCAPS documentation is amended to reflect the
actually checks performed by the kernel.

Fixes: 06a916feca2b ("arm64: Expose SVE2 features for userspace")
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250107-arm64-2024-dpisa-v5-1-7578da51fc3d@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/elf_hwcaps.rst |   36 ++++++++++++++++++++----------
 arch/arm64/kernel/cpufeature.c          |   38 +++++++++++++++++++++-----------
 2 files changed, 50 insertions(+), 24 deletions(-)

--- a/Documentation/arch/arm64/elf_hwcaps.rst
+++ b/Documentation/arch/arm64/elf_hwcaps.rst
@@ -174,22 +174,28 @@ HWCAP2_DCPODP
     Functionality implied by ID_AA64ISAR1_EL1.DPB == 0b0010.
 
 HWCAP2_SVE2
-    Functionality implied by ID_AA64ZFR0_EL1.SVEVer == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.SVEver == 0b0001.
 
 HWCAP2_SVEAES
-    Functionality implied by ID_AA64ZFR0_EL1.AES == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.AES == 0b0001.
 
 HWCAP2_SVEPMULL
-    Functionality implied by ID_AA64ZFR0_EL1.AES == 0b0010.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.AES == 0b0010.
 
 HWCAP2_SVEBITPERM
-    Functionality implied by ID_AA64ZFR0_EL1.BitPerm == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.BitPerm == 0b0001.
 
 HWCAP2_SVESHA3
-    Functionality implied by ID_AA64ZFR0_EL1.SHA3 == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.SHA3 == 0b0001.
 
 HWCAP2_SVESM4
-    Functionality implied by ID_AA64ZFR0_EL1.SM4 == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.SM4 == 0b0001.
 
 HWCAP2_FLAGM2
     Functionality implied by ID_AA64ISAR0_EL1.TS == 0b0010.
@@ -198,16 +204,20 @@ HWCAP2_FRINT
     Functionality implied by ID_AA64ISAR1_EL1.FRINTTS == 0b0001.
 
 HWCAP2_SVEI8MM
-    Functionality implied by ID_AA64ZFR0_EL1.I8MM == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.I8MM == 0b0001.
 
 HWCAP2_SVEF32MM
-    Functionality implied by ID_AA64ZFR0_EL1.F32MM == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.F32MM == 0b0001.
 
 HWCAP2_SVEF64MM
-    Functionality implied by ID_AA64ZFR0_EL1.F64MM == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.F64MM == 0b0001.
 
 HWCAP2_SVEBF16
-    Functionality implied by ID_AA64ZFR0_EL1.BF16 == 0b0001.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.BF16 == 0b0001.
 
 HWCAP2_I8MM
     Functionality implied by ID_AA64ISAR1_EL1.I8MM == 0b0001.
@@ -273,7 +283,8 @@ HWCAP2_EBF16
     Functionality implied by ID_AA64ISAR1_EL1.BF16 == 0b0010.
 
 HWCAP2_SVE_EBF16
-    Functionality implied by ID_AA64ZFR0_EL1.BF16 == 0b0010.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.BF16 == 0b0010.
 
 HWCAP2_CSSC
     Functionality implied by ID_AA64ISAR2_EL1.CSSC == 0b0001.
@@ -282,7 +293,8 @@ HWCAP2_RPRFM
     Functionality implied by ID_AA64ISAR2_EL1.RPRFM == 0b0001.
 
 HWCAP2_SVE2P1
-    Functionality implied by ID_AA64ZFR0_EL1.SVEver == 0b0010.
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001 and
+    ID_AA64ZFR0_EL1.SVEver == 0b0010.
 
 HWCAP2_SME2
     Functionality implied by ID_AA64SMFR0_EL1.SMEver == 0b0001.
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2762,6 +2762,13 @@ static const struct arm64_cpu_capabiliti
 		.matches = match,						\
 	}
 
+#define HWCAP_CAP_MATCH_ID(match, reg, field, min_value, cap_type, cap)		\
+	{									\
+		__HWCAP_CAP(#cap, cap_type, cap)				\
+		HWCAP_CPUID_MATCH(reg, field, min_value) 			\
+		.matches = match,						\
+	}
+
 #ifdef CONFIG_ARM64_PTR_AUTH
 static const struct arm64_cpu_capabilities ptr_auth_hwcap_addr_matches[] = {
 	{
@@ -2790,6 +2797,13 @@ static const struct arm64_cpu_capabiliti
 };
 #endif
 
+#ifdef CONFIG_ARM64_SVE
+static bool has_sve_feature(const struct arm64_cpu_capabilities *cap, int scope)
+{
+	return system_supports_sve() && has_user_cpuid_feature(cap, scope);
+}
+#endif
+
 static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(ID_AA64ISAR0_EL1, AES, PMULL, CAP_HWCAP, KERNEL_HWCAP_PMULL),
 	HWCAP_CAP(ID_AA64ISAR0_EL1, AES, AES, CAP_HWCAP, KERNEL_HWCAP_AES),
@@ -2827,18 +2841,18 @@ static const struct arm64_cpu_capabiliti
 	HWCAP_CAP(ID_AA64MMFR2_EL1, AT, IMP, CAP_HWCAP, KERNEL_HWCAP_USCAT),
 #ifdef CONFIG_ARM64_SVE
 	HWCAP_CAP(ID_AA64PFR0_EL1, SVE, IMP, CAP_HWCAP, KERNEL_HWCAP_SVE),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, SVEver, SVE2p1, CAP_HWCAP, KERNEL_HWCAP_SVE2P1),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, SVEver, SVE2, CAP_HWCAP, KERNEL_HWCAP_SVE2),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, AES, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEAES),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, AES, PMULL128, CAP_HWCAP, KERNEL_HWCAP_SVEPMULL),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, BitPerm, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEBITPERM),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, BF16, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEBF16),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, BF16, EBF16, CAP_HWCAP, KERNEL_HWCAP_SVE_EBF16),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, SHA3, IMP, CAP_HWCAP, KERNEL_HWCAP_SVESHA3),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, SM4, IMP, CAP_HWCAP, KERNEL_HWCAP_SVESM4),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, I8MM, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEI8MM),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, F32MM, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEF32MM),
-	HWCAP_CAP(ID_AA64ZFR0_EL1, F64MM, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEF64MM),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, SVEver, SVE2p1, CAP_HWCAP, KERNEL_HWCAP_SVE2P1),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, SVEver, SVE2, CAP_HWCAP, KERNEL_HWCAP_SVE2),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, AES, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEAES),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, AES, PMULL128, CAP_HWCAP, KERNEL_HWCAP_SVEPMULL),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, BitPerm, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEBITPERM),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, BF16, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEBF16),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, BF16, EBF16, CAP_HWCAP, KERNEL_HWCAP_SVE_EBF16),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, SHA3, IMP, CAP_HWCAP, KERNEL_HWCAP_SVESHA3),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, SM4, IMP, CAP_HWCAP, KERNEL_HWCAP_SVESM4),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, I8MM, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEI8MM),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, F32MM, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEF32MM),
+	HWCAP_CAP_MATCH_ID(has_sve_feature, ID_AA64ZFR0_EL1, F64MM, IMP, CAP_HWCAP, KERNEL_HWCAP_SVEF64MM),
 #endif
 	HWCAP_CAP(ID_AA64PFR1_EL1, SSBS, SSBS2, CAP_HWCAP, KERNEL_HWCAP_SSBS),
 #ifdef CONFIG_ARM64_BTI


