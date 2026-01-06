Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5973563C4;
	Tue,  6 Jan 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720528; cv=none; b=sobVgdPEOYHeSz5G3d7r1mEB57qK6nSJTIwayO6hGJDer+b2CcODNbNRGsMKcns8I27uuLD2YCQ/Vy+sU4g0HrfIRh/lblTCHYK30/5w86zCjT2Sm8yddwyO9Vhod4Cug2MhdqkzBBUdRwd4AFHmZMbFa/Ii9HdCdxluWo02avU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720528; c=relaxed/simple;
	bh=Kwy2B1ylEI93NG8T00SXfWMZhoz+9Hy2Cdm8fCPnDXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtSmaV7ozdqwel41UJyxpA4DCXR6xe8Scht+w9hBDzqwct46/AqKBEcFvNZ2oOKeKr1/Tlr2PQmlmP7q9L9h8v5CrJnSFkpBzZ38FlA0SV3u0pwrWcSryhb76pzzOO7PQ1I6KZS6P5rcLOfExZJhP+SqXPx/815EFkhsCE/DFz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0We0mCfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0We0mCfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFECC16AAE;
	Tue,  6 Jan 2026 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720528;
	bh=Kwy2B1ylEI93NG8T00SXfWMZhoz+9Hy2Cdm8fCPnDXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0We0mCfej/NENl7ZCs7oRRpRLhs+Mue9/GjRMgQ7gwRQ9ZNbVDn0Hu5192eMho/hJ
	 2QQr/pXfw7rYJPkX8bU+JwU1guTAhWpMx9IvMSYUPmSxf0FZpUhupZ5YcazZgQL6Qb
	 TgKqWJIom0kCN5/7LBR8/kWn5pxs/ftvoxfjmeCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jan Kotas <jank@cadence.com>,
	Marc Zyngier <maz@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 6.12 264/567] arm64: Revamp HCR_EL2.E2H RES1 detection
Date: Tue,  6 Jan 2026 18:00:46 +0100
Message-ID: <20260106170501.090825673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit ca88ecdce5f51874a7c151809bd2c936ee0d3805 ]

We currently have two ways to identify CPUs that only implement FEAT_VHE
and not FEAT_E2H0:

- either they advertise it via ID_AA64MMFR4_EL1.E2H0,
- or the HCR_EL2.E2H bit is RAO/WI

However, there is a third category of "cpus" that fall between these
two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
is zero.

A consequence of this is that on systems such as Neoverse V2, a NV
guest cannot reliably detect that it is in a VHE-only configuration
(E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
best effort to repaint the id register.

Replace the RAO/WI test by a sequence that makes use of the VHE
register remnapping between EL1 and EL2 to detect this situation,
and work out whether we get the VHE behaviour even after having
set HCR_EL2.E2H to 0.

This solves the NV problem, and provides a more reliable acid test
for CPUs that do not completely follow the letter of the architecture
while providing a RES1 behaviour for HCR_EL2.E2H.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Jan Kotas <jank@cadence.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/el2_setup.h |   38 +++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -24,22 +24,48 @@
 	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
 	 * can reset into an UNKNOWN state and might not read as 1 until it has
 	 * been initialized explicitly.
-	 *
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
-	 * don't advertise it (they predate this relaxation).
-	 *
 	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
 	 * indicating whether the CPU is running in E2H mode.
 	 */
 	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
 	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
 	cmp	x1, #0
-	b.ge	.LnVHE_\@
+	b.lt	.LnE2H0_\@
+
+	/*
+	 * Unfortunately, HCR_EL2.E2H can be RES1 even if not advertised
+	 * as such via ID_AA64MMFR4_EL1.E2H0:
+	 *
+	 * - Fruity CPUs predate the !FEAT_E2H0 relaxation, and seem to
+	 *   have HCR_EL2.E2H implemented as RAO/WI.
+	 *
+	 * - On CPUs that lack FEAT_FGT, a hypervisor can't trap guest
+	 *   reads of ID_AA64MMFR4_EL1 to advertise !FEAT_E2H0. NV
+	 *   guests on these hosts can write to HCR_EL2.E2H without
+	 *   trapping to the hypervisor, but these writes have no
+	 *   functional effect.
+	 *
+	 * Handle both cases by checking for an essential VHE property
+	 * (system register remapping) to decide whether we're
+	 * effectively VHE-only or not.
+	 */
+	msr	hcr_el2, x0	// Setup HCR_EL2 as nVHE
+	isb
+	mov	x1, #1		// Write something to FAR_EL1
+	msr	far_el1, x1
+	isb
+	mov	x1, #2		// Try to overwrite it via FAR_EL2
+	msr	far_el2, x1
+	isb
+	mrs	x1, far_el1	// If we see the latest write in FAR_EL1,
+	cmp	x1, #2		// we can safely assume we are VHE only.
+	b.ne	.LnVHE_\@	// Otherwise, we know that nVHE works.
 
+.LnE2H0_\@:
 	orr	x0, x0, #HCR_E2H
-.LnVHE_\@:
 	msr	hcr_el2, x0
 	isb
+.LnVHE_\@:
 .endm
 
 .macro __init_el2_sctlr


