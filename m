Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6351F76C3;
	Tue, 17 Dec 2024 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456770; cv=none; b=j162iIZDcl7Dt3pH1uVuEjgUmAa+g/IgDYGsE2wi8ntrpVEq0bV1hSlkd3Y3BfTIhCcCCfb91NISlBgWQvCqiY32DP5PvX2o5P6MM2bMdvq/GXFAo/8Smc9K/Qzq5crYfs7TzdA0dHl81Msl+mItpT4RuyXBHiZ2wh0TrbSvWMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456770; c=relaxed/simple;
	bh=hbI+wDu29hvPeY4huTBkmbnUJm3in6n7GzJ+jTBxCm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv7lzyMmz2JDa00BjJ8KTzaPhvP1laexw3s35YN7JnNsvgntiY31OKQZyMQ9WsB+xwPJ4J2QZ5LMddDwK+pOZnJWw0JheccKF7pnNIo3hUJxs9HiPMFoHrTPdlPDhwXigUuzkr3s8a9O7xVbvcZbok4KEl3Yk21AKjICOdbZqHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf9C+DNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf9C+DNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80610C4CED3;
	Tue, 17 Dec 2024 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456769;
	bh=hbI+wDu29hvPeY4huTBkmbnUJm3in6n7GzJ+jTBxCm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pf9C+DNUWyGCn/1xgtBgSTG1FWop4gFBOBk4iS3UTCYrcr2b62bjHXjgTxvG1f7Ww
	 otT2GAeC11B/qttzih927II6RANboujLZXymIUCIxB6LR4EbwJ223VrOknSWvTa07c
	 mKkQRbWPo0/ZGJ3bTXrYqcygnE1tsdNIgAvY3CaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weizhao Ouyang <o451686892@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/172] kselftest/arm64: abi: fix SVCR detection
Date: Tue, 17 Dec 2024 18:08:36 +0100
Message-ID: <20241217170552.966621483@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weizhao Ouyang <o451686892@gmail.com>

[ Upstream commit ce03573a1917532da06057da9f8e74a2ee9e2ac9 ]

When using svcr_in to check ZA and Streaming Mode, we should make sure
that the value in x2 is correct, otherwise it may trigger an Illegal
instruction if FEAT_SVE and !FEAT_SME.

Fixes: 43e3f85523e4 ("kselftest/arm64: Add SME support to syscall ABI test")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241211111639.12344-1-o451686892@gmail.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/arm64/abi/syscall-abi-asm.S     | 32 +++++++++----------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/syscall-abi-asm.S b/tools/testing/selftests/arm64/abi/syscall-abi-asm.S
index df3230fdac39..66ab2e0bae5f 100644
--- a/tools/testing/selftests/arm64/abi/syscall-abi-asm.S
+++ b/tools/testing/selftests/arm64/abi/syscall-abi-asm.S
@@ -81,32 +81,31 @@ do_syscall:
 	stp	x27, x28, [sp, #96]
 
 	// Set SVCR if we're doing SME
-	cbz	x1, 1f
+	cbz	x1, load_gpr
 	adrp	x2, svcr_in
 	ldr	x2, [x2, :lo12:svcr_in]
 	msr	S3_3_C4_C2_2, x2
-1:
 
 	// Load ZA and ZT0 if enabled - uses x12 as scratch due to SME LDR
-	tbz	x2, #SVCR_ZA_SHIFT, 1f
+	tbz	x2, #SVCR_ZA_SHIFT, load_gpr
 	mov	w12, #0
 	ldr	x2, =za_in
-2:	_ldr_za 12, 2
+1:	_ldr_za 12, 2
 	add	x2, x2, x1
 	add	x12, x12, #1
 	cmp	x1, x12
-	bne	2b
+	bne	1b
 
 	// ZT0
 	mrs	x2, S3_0_C0_C4_5	// ID_AA64SMFR0_EL1
 	ubfx	x2, x2, #ID_AA64SMFR0_EL1_SMEver_SHIFT, \
 			 #ID_AA64SMFR0_EL1_SMEver_WIDTH
-	cbz	x2, 1f
+	cbz	x2, load_gpr
 	adrp	x2, zt_in
 	add	x2, x2, :lo12:zt_in
 	_ldr_zt 2
-1:
 
+load_gpr:
 	// Load GPRs x8-x28, and save our SP/FP for later comparison
 	ldr	x2, =gpr_in
 	add	x2, x2, #64
@@ -125,9 +124,9 @@ do_syscall:
 	str	x30, [x2], #8		// LR
 
 	// Load FPRs if we're not doing neither SVE nor streaming SVE
-	cbnz	x0, 1f
+	cbnz	x0, check_sve_in
 	ldr	x2, =svcr_in
-	tbnz	x2, #SVCR_SM_SHIFT, 1f
+	tbnz	x2, #SVCR_SM_SHIFT, check_sve_in
 
 	ldr	x2, =fpr_in
 	ldp	q0, q1, [x2]
@@ -148,8 +147,8 @@ do_syscall:
 	ldp	q30, q31, [x2, #16 * 30]
 
 	b	2f
-1:
 
+check_sve_in:
 	// Load the SVE registers if we're doing SVE/SME
 
 	ldr	x2, =z_in
@@ -256,32 +255,31 @@ do_syscall:
 	stp	q30, q31, [x2, #16 * 30]
 
 	// Save SVCR if we're doing SME
-	cbz	x1, 1f
+	cbz	x1, check_sve_out
 	mrs	x2, S3_3_C4_C2_2
 	adrp	x3, svcr_out
 	str	x2, [x3, :lo12:svcr_out]
-1:
 
 	// Save ZA if it's enabled - uses x12 as scratch due to SME STR
-	tbz	x2, #SVCR_ZA_SHIFT, 1f
+	tbz	x2, #SVCR_ZA_SHIFT, check_sve_out
 	mov	w12, #0
 	ldr	x2, =za_out
-2:	_str_za 12, 2
+1:	_str_za 12, 2
 	add	x2, x2, x1
 	add	x12, x12, #1
 	cmp	x1, x12
-	bne	2b
+	bne	1b
 
 	// ZT0
 	mrs	x2, S3_0_C0_C4_5	// ID_AA64SMFR0_EL1
 	ubfx	x2, x2, #ID_AA64SMFR0_EL1_SMEver_SHIFT, \
 			#ID_AA64SMFR0_EL1_SMEver_WIDTH
-	cbz	x2, 1f
+	cbz	x2, check_sve_out
 	adrp	x2, zt_out
 	add	x2, x2, :lo12:zt_out
 	_str_zt 2
-1:
 
+check_sve_out:
 	// Save the SVE state if we have some
 	cbz	x0, 1f
 
-- 
2.39.5



