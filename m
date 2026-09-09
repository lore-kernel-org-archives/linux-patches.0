Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613B0550DC3;
	Wed,  9 Sep 2026 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962025; cv=none; b=t7VfHLSX5uO3XeiZ+5PwDD8b1Gr5luBWAVg79S3FdPDKGMyRjhzcsPNq+G0aR1+YQwLuM49WtierewIKC8iOs1RJk0CV1dknGL/F7lRmJVZSh4UG8uCJhxQvrIjpfwbqH8El4omke4PhgkS8Y9wfjGDyOBrMESP4pRdMEhpe/IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962025; c=relaxed/simple;
	bh=JccGlIguHKNaehHoCCwSG5UN3N9/ul/v0drjnpd5m14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U17whlGz7wBw3nH71SEZ1cdU2bZa/xGI7zcBY2Y8gwDtv3JO3vvarjoKvqzKKQExnEVM7h55CudnvAWHUncsJUn4jciuBm9fPdDmSJ0QGlWxAwr38wfQKmHDL5ULfx5czo4+ZfpgSf3RuVOy4Kh0Mic+xEZgoXvkCMMULvoZbK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJDPiB2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJDPiB2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23AB1F00A3A;
	Wed,  9 Sep 2026 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962024;
	bh=X1z7ZJRIj1+eCVgm4yzBu/ZOCa6orp9rhM6QJXCZaAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJDPiB2EV2VYcbOooHQ64CpS4MjKcTNGAyenacg0MJSaS6HeiYUitsSDysyhQpQsJ
	 TEi/ZYQbZLYMFptQORHv0ifLGd/NcBBIdlHFvVnr0/ra0FSD2nmld9zFQpfB53KH4v
	 rx6st5lykwR43himQ8bTYUp1lovOq8QhzEwO87oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 147/556] arm64: Dont read GMID_EL1 when MTE is disabled
Date: Wed,  9 Sep 2026 15:37:07 +0200
Message-ID: <20260909134235.614505335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 5445d64199626974269fcdf347769ad44b0bb53b upstream.

__cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
ID_AA64PFR1_EL1, so it reads the register even when the kernel has
disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets HCR_EL2.TID5
in that case, and pKVM injects an UNDEF the host cannot handle:

  Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
  pc : __cpuinfo_store_cpu+0xf4/0x264
  Kernel panic - not syncing: Attempted to kill the idle task!

Only pKVM reaches it, and only after a CPU is offlined and brought back
online: its CPU_ON relay sets the host HCR before the CPU enters EL1,
while plain nVHE sets it at CPUHP_AP_KVM_ONLINE.

Gate the read on the CPU's own ID_AA64PFR1_EL1 with the command-line
override applied, and on CONFIG_ARM64_MTE, which no register reflects.
The boot CPU stores its registers before init_cpu_features() strips an
unsafe override, so clamp against the hardware value here too.

Fixes: f35abcbb8a084 ("KVM: arm64: Trap MTE access and discovery when MTE is disabled")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpu.h        |    1 +
 arch/arm64/include/asm/cpufeature.h |    7 -------
 arch/arm64/kernel/cpufeature.c      |   33 +++++++++++++++++++++++++++++----
 arch/arm64/kernel/cpuinfo.c         |    2 +-
 4 files changed, 31 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -78,5 +78,6 @@ void __init cpuinfo_store_boot_cpu(void)
 void __init init_cpu_features(struct cpuinfo_arm64 *info);
 void update_cpu_features(int cpu, struct cpuinfo_arm64 *info,
 				 struct cpuinfo_arm64 *boot);
+bool gmid_el1_accessible(const struct cpuinfo_arm64 *info);
 
 #endif /* __ASM_CPU_H */
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -627,13 +627,6 @@ static inline bool id_aa64pfr1_mpamfrac(
 	return val > 0;
 }
 
-static inline bool id_aa64pfr1_mte(u64 pfr1)
-{
-	u32 val = cpuid_feature_extract_unsigned_field(pfr1, ID_AA64PFR1_EL1_MTE_SHIFT);
-
-	return val >= ID_AA64PFR1_EL1_MTE_MTE2;
-}
-
 void __init setup_boot_cpu_features(void);
 void __init setup_system_features(void);
 void __init setup_user_features(void);
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1176,6 +1176,33 @@ static bool detect_ftr_has_mpam(void)
 	return id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1);
 }
 
+bool gmid_el1_accessible(const struct cpuinfo_arm64 *info)
+{
+	const struct arm64_ftr_bits *ftrp;
+	s64 mte, ovr;
+	u64 ftr_mask;
+
+	/* No ID register reflects CONFIG_ARM64_MTE. */
+	if (!IS_ENABLED(CONFIG_ARM64_MTE))
+		return false;
+
+	for (ftrp = ftr_id_aa64pfr1; ftrp->width; ftrp++) {
+		if (ftrp->shift == ID_AA64PFR1_EL1_MTE_SHIFT)
+			break;
+	}
+
+	ftr_mask = arm64_ftr_mask(ftrp);
+	mte = arm64_ftr_value(ftrp, info->reg_id_aa64pfr1);
+
+	/* The boot CPU runs before init_cpu_ftr_reg() strips unsafe overrides. */
+	if ((id_aa64pfr1_override.mask & ftr_mask) == ftr_mask) {
+		ovr = arm64_ftr_value(ftrp, id_aa64pfr1_override.val);
+		mte = arm64_ftr_safe_value(ftrp, ovr, mte);
+	}
+
+	return mte >= ID_AA64PFR1_EL1_MTE_MTE2;
+}
+
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
 	/* Before we start using the tables, make sure it is sorted */
@@ -1228,7 +1255,7 @@ void __init init_cpu_features(struct cpu
 		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
 	}
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (gmid_el1_accessible(info))
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
 }
 
@@ -1490,11 +1517,9 @@ void update_cpu_features(int cpu,
 	 * they read/write depends on the GMID_EL1.BS field. Check that the
 	 * value is the same on all CPUs.
 	 */
-	if (IS_ENABLED(CONFIG_ARM64_MTE) &&
-	    id_aa64pfr1_mte(info->reg_id_aa64pfr1)) {
+	if (gmid_el1_accessible(info))
 		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
 					      info->reg_gmid, boot->reg_gmid);
-	}
 
 	/*
 	 * If we don't have AArch32 at all then skip the checks entirely
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -502,7 +502,7 @@ static void __cpuinfo_store_cpu(struct c
 	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
 	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (gmid_el1_accessible(info))
 		info->reg_gmid = read_cpuid(GMID_EL1);
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))


