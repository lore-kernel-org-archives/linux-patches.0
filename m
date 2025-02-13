Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2FB202C25;
	Thu, 13 Feb 2025 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459078; cv=none; b=Z0d+TgLXTcDlvbvCSRky9223r1k/LixEQEmNDLKjBwlkH12n0JfRgl1ynev0ODDxntDCw2LdtA4Wvi6Zi8+41upHtv1KbhJf5ZKQap9GWCMXQoJBQvJeSW+LKnDEw4tHkLM1Rka/VZfSlP+xZ4ZtCuUux7cZu6HjaaUqPJH+OeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459078; c=relaxed/simple;
	bh=rxLr+1hRhAJrdj3npQRJa8hKZu/9ooM+CyrUjUwsRcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzHSB27skDPLszv5uoEzUn46NHbIMhikcZ1ETibRTmCkGnfePYsyzVI0qHA0k75Hgj8OOJDbGH1oyqdQHNqIz1z7CnmbFX/uPyD6z8O89F3DuMAFLxwnXSbHTLRZYxL7IKmfB7qDlW1cSIMHLQuN7SpJ8BfscTPNTQ+DyQPa01o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2p5+6U9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2p5+6U9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A8BC4CED1;
	Thu, 13 Feb 2025 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459078;
	bh=rxLr+1hRhAJrdj3npQRJa8hKZu/9ooM+CyrUjUwsRcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2p5+6U9UeFhkQspjlqMusjY/SzjhqKrRTg5C1F0Ncb47aZ2w0Vv0cg6utdjG3jfk
	 2rOtAXpITj2JiOkxBS/vcVewbadChy9WqxpLDCocEK3R+PGs/hdhGvZBoVYqRukPyV
	 xq9bbasSQzATATyXNGoJNzDTn8FVuZtHDrtthzn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 161/443] arm64/mm: Override PARange for !LPA2 and use it consistently
Date: Thu, 13 Feb 2025 15:25:26 +0100
Message-ID: <20250213142446.809469664@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -343,6 +343,11 @@ alternative_cb_end
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
@@ -3492,7 +3492,7 @@ static void verify_hyp_capabilities(void
 		return;
 
 	safe_mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
-	mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 
 	/* Verify VMID bits */
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -83,6 +83,15 @@ static bool __init mmfr2_varange_filter(
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
@@ -279,7 +279,12 @@ void __init arm64_memblock_init(void)
 
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


