Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E1227EBC;
	Thu, 13 Feb 2025 14:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457553; cv=none; b=djZDign7hnoMEdlufMTqZLdseZUUxOL1q8x2ThtXxMePZn+2ooIvp6iSFIF3P63WvRF6+38lXBJUftzQ2S6j9Y8wh77xHjk08/I39IT+aUkEb7ceZmcF2U3xndvvpU+rEDKQgBrN0fIXdePnt6OqCic7l2BH6vURJz5RVZb3NuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457553; c=relaxed/simple;
	bh=kZCH8sUHK1BXZXNgvIeDSUAoRCDQAG2Em4KmpV0PmY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYr7rA9uRNZRp/RIwVjBLfBpWjHQ66WzHoAN18TVwA9GGZsaqrO2w/U2LpQ1fAmTEyOqu9LVB1Mc3IEFZHH+BbS3ukEoTDTbqSlUIVoZGOEBzR7Ku7kyOELd0vt1reXDfJhBWWbOtNZ6k2WZAG1x6Ku3mLJmFlAtcukQNYZOlx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqr7Ilmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqr7Ilmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4DAC4CED1;
	Thu, 13 Feb 2025 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457552;
	bh=kZCH8sUHK1BXZXNgvIeDSUAoRCDQAG2Em4KmpV0PmY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqr7Ilmt8OByBranKCFEOIvDp1bfqtRs3ZivXWqdCO0Df8DUP/YFsOL9/Z30xWSVA
	 eTmU26/nj9E38oAri31adzc48OijkN6TacR581C6P1+e0PvU6aTVP293G1etwfwtdO
	 /AUgMXYI0+yPZd1UCLwG4nPboqGJ6FGUvvAx2H3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 144/422] arm64/kvm: Configure HYP TCR.PS/DS based on host stage1
Date: Thu, 13 Feb 2025 15:24:53 +0100
Message-ID: <20250213142442.104452250@linuxfoundation.org>
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

commit f0da16992aef7e246b2f3bba1492e3a52c38ca0e upstream.

When the host stage1 is configured for LPA2, the value currently being
programmed into TCR_EL2.T0SZ may be invalid unless LPA2 is configured
at HYP as well.  This means kvm_lpa2_is_enabled() is not the right
condition to test when setting TCR_EL2.DS, as it will return false if
LPA2 is only available for stage 1 but not for stage 2.

Similary, programming TCR_EL2.PS based on a limited IPA range due to
lack of stage2 LPA2 support could potentially result in problems.

So use lpa2_is_enabled() instead, and set the PS field according to the
host's IPS, which is capped at 48 bits if LPA2 support is absent or
disabled. Whether or not we can make meaningful use of such a
configuration is a different question.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241212081841.2168124-11-ardb+git@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1998,8 +1998,7 @@ static int kvm_init_vector_slots(void)
 static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
-	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	unsigned long tcr;
+	unsigned long tcr, ips;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
@@ -2013,6 +2012,7 @@ static void __init cpu_prepare_hyp_mode(
 	params->mair_el2 = read_sysreg(mair_el1);
 
 	tcr = read_sysreg(tcr_el1);
+	ips = FIELD_GET(TCR_IPS_MASK, tcr);
 	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
 		tcr |= TCR_EPD1_MASK;
 	} else {
@@ -2022,8 +2022,8 @@ static void __init cpu_prepare_hyp_mode(
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
 	tcr &= ~TCR_EL2_PS_MASK;
-	tcr |= FIELD_PREP(TCR_EL2_PS_MASK, kvm_get_parange(mmfr0));
-	if (kvm_lpa2_is_enabled())
+	tcr |= FIELD_PREP(TCR_EL2_PS_MASK, ips);
+	if (lpa2_is_enabled())
 		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
 


