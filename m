Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156414B95A;
	Thu, 13 Feb 2025 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457556; cv=none; b=U40FNOhHkm7mBQYUR0e4tfsGJ3i8a0X9eO0qIqWLwULNCCvOG6iKveCUuT08GXR6cfhhf6asCXuHCZDvQ4mkFml6svmuCPKfpeqIa4/QOUqL8KEtUQeLOGINjd/5eEfEvms19E7OpEblK+Yrs8CJyepPQw9c5Li2dT7sDPnbu5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457556; c=relaxed/simple;
	bh=VVi5N8EYiDLAXJY7vB0JxjOTLCpUZkvXlCidPJkiYXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLCcWtKTP7NPWQQpxfZ6zzNZM7q2PlKglLug29G8XqWpplXKyfy1EZnh6eyAA5/NahbUNENeumYyGXjb0yCmKkrF4sGCOKvKjh7T5LCsUJC+XiT4smSjTKYgeahq21rWHkXluxKzFoYTmoqklt1ZeyhiBH7MLndClKgx7Z4wYMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbmWd7Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbmWd7Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E392C4CED1;
	Thu, 13 Feb 2025 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457555;
	bh=VVi5N8EYiDLAXJY7vB0JxjOTLCpUZkvXlCidPJkiYXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbmWd7ZcwVPMx0FKCbYkqKE0WaaBIo1FaocUeUHRHCxyuZuJGwOqjukTRYRhtvuP+
	 7CHhHSZv4df5dc067Qghej0nPwmMZ3jKvJ1YLmDAj8wcXBxHYCEobCDNqQWJFVLI2S
	 oVTPg076mOeuRdt2iIDVHkNSdme4lJXf8ACee/oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 145/422] arm64/mm: Override PARange for !LPA2 and use it consistently
Date: Thu, 13 Feb 2025 15:24:54 +0100
Message-ID: <20250213142442.143831891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 62cffa496aac0c2c4eeca00d080058affd7a0172 upstream.

When FEAT_LPA{,2} are not implemented, the ID_AA64MMFR0_EL1.PARange and
TCR.IPS values corresponding with 52-bit physical addressing are
reserved.

Setting the TCR.IPS field to 0b110 (52-bit physical addressing) has side
effects, such as how the TTBRn_ELx.BADDR fields are interpreted, and so
it is important that disabling FEAT_LPA2 (by overriding the
ID_AA64MMFR0.TGran fields) also presents a PARange field consistent with
that.

So limit the field to 48 bits unless LPA2 is enabled, and update
existing references to use the override consistently.

Fixes: 352b0395b505 ("arm64: Enable 52-bit virtual addressing for 4k and 16k granule configs")
Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241212081841.2168124-10-ardb+git@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h    |    5 +++++
 arch/arm64/kernel/cpufeature.c        |    2 +-
 arch/arm64/kernel/pi/idreg-override.c |    9 +++++++++
 arch/arm64/kernel/pi/map_kernel.c     |    6 ++++++
 arch/arm64/mm/init.c                  |    7 ++++++-
 5 files changed, 27 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -350,6 +350,11 @@ alternative_cb_end
 	// Narrow PARange to fit the PS field in TCR_ELx
 	ubfx	\tmp0, \tmp0, #ID_AA64MMFR0_EL1_PARANGE_SHIFT, #3
 	mov	\tmp1, #ID_AA64MMFR0_EL1_PARANGE_MAX
+#ifdef CONFIG_ARM64_LPA2
+alternative_if_not ARM64_HAS_VA52
+	mov	\tmp1, #ID_AA64MMFR0_EL1_PARANGE_48
+alternative_else_nop_endif
+#endif
 	cmp	\tmp0, \tmp1
 	csel	\tmp0, \tmp1, \tmp0, hi
 	bfi	\tcr, \tmp0, \pos, #3
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3390,7 +3390,7 @@ static void verify_hyp_capabilities(void
 		return;
 
 	safe_mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
-	mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 
 	/* Verify VMID bits */
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -74,6 +74,15 @@ static bool __init mmfr2_varange_filter(
 		id_aa64mmfr0_override.val |=
 			(ID_AA64MMFR0_EL1_TGRAN_LPA2 - 1) << ID_AA64MMFR0_EL1_TGRAN_SHIFT;
 		id_aa64mmfr0_override.mask |= 0xfU << ID_AA64MMFR0_EL1_TGRAN_SHIFT;
+
+		/*
+		 * Override PARange to 48 bits - the override will just be
+		 * ignored if the actual PARange is smaller, but this is
+		 * unlikely to be the case for LPA2 capable silicon.
+		 */
+		id_aa64mmfr0_override.val |=
+			ID_AA64MMFR0_EL1_PARANGE_48 << ID_AA64MMFR0_EL1_PARANGE_SHIFT;
+		id_aa64mmfr0_override.mask |= 0xfU << ID_AA64MMFR0_EL1_PARANGE_SHIFT;
 	}
 #endif
 	return true;
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -136,6 +136,12 @@ static void noinline __section(".idmap.t
 {
 	u64 sctlr = read_sysreg(sctlr_el1);
 	u64 tcr = read_sysreg(tcr_el1) | TCR_DS;
+	u64 mmfr0 = read_sysreg(id_aa64mmfr0_el1);
+	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
+							   ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	tcr &= ~TCR_IPS_MASK;
+	tcr |= parange << TCR_IPS_SHIFT;
 
 	asm("	msr	sctlr_el1, %0		;"
 	    "	isb				;"
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -278,7 +278,12 @@ void __init arm64_memblock_init(void)
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
 		extern u16 memstart_offset_seed;
-		u64 mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
+
+		/*
+		 * Use the sanitised version of id_aa64mmfr0_el1 so that linear
+		 * map randomization can be enabled by shrinking the IPA space.
+		 */
+		u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 		int parange = cpuid_feature_extract_unsigned_field(
 					mmfr0, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
 		s64 range = linear_region_size -


