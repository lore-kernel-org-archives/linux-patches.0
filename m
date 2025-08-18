Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E72E22B0;
	Mon, 18 Aug 2025 14:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526286; cv=none; b=fiovbkI7FveUphwCjiFlFu+VTAeIH52ahGz+Lef4uEwZj9CIXYo1WLEOHIDZJAIpP/nXS8mfPB273S/CVeSYEKTUh9fRo7GGTUbSOq26qMTL41hM/1JCgDPOzyAEVf2MDdjKRG7ca7Kw8j19kw8LDuXzpbXYW2jaUT4yfDBXew0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526286; c=relaxed/simple;
	bh=iI/AbgmJs5/hniUYGRJoLDVvoMJ/DG4N0nRTruDLr+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoBD/+7kPmFL3nSCMCJzLynF6OAFhNNjdcIJvjFd3lFayEJaVOLxamPAngYbsVk63ypl0ntPHMdV0dlrMgDh5JlTdoFS9f+xTehenVQc+8GHcO5FL+NY3oEC2dmIAiSrIBh1vHBvNvcAdc2eRALly9H6AKNbyPo8TverW56IMF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2wxTN0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2wxTN0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94024C4CEEB;
	Mon, 18 Aug 2025 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526286;
	bh=iI/AbgmJs5/hniUYGRJoLDVvoMJ/DG4N0nRTruDLr+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2wxTN0E7IaDUKWOBcznTiOy12BMpm0Ao424cyx7zBBo3uKGpccd6FfKAyxn8H0cL
	 iD0TclIAWJ6WM7c/gS6Itge0sMHuM5zkxB4+obx7HN0hP62KGG8rTqz9ahqgfdMX3w
	 JPo2hNqQ8RHhbw8kn1kbBF6kzfmvn2ToRg3uBF50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 483/570] x86/sev: Improve handling of writes to intercepted TSC MSRs
Date: Mon, 18 Aug 2025 14:47:50 +0200
Message-ID: <20250818124524.490094761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikunj A Dadhania <nikunj@amd.com>

[ Upstream commit 5eb1bcdb6a8c088514019c3a9bda5d565beed1af ]

Currently, when a Secure TSC enabled SNP guest attempts to write to the
intercepted GUEST_TSC_FREQ MSR (a read-only MSR), the guest kernel response
incorrectly implies a VMM configuration error, when in fact it is the usual
VMM configuration to intercept writes to read-only MSRs, unless explicitly
documented.

Modify the intercepted TSC MSR #VC handling:
* Write to GUEST_TSC_FREQ will generate a #GP instead of terminating the
  guest
* Write to MSR_IA32_TSC will generate a #GP instead of silently ignoring it

However, continue to terminate the guest when reading from intercepted
GUEST_TSC_FREQ MSR with Secure TSC enabled, as intercepted reads indicate an
improper VMM configuration for Secure TSC enabled SNP guests.

  [ bp: simplify comment. ]

Fixes: 38cc6495cdec ("x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/20250722074853.22253-1-nikunj@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/sev/vc-handle.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index faf1fce89ed4..c3b4acbde0d8 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -371,29 +371,30 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
  * executing with Secure TSC enabled, so special handling is required for
  * accesses of MSR_IA32_TSC and MSR_AMD64_GUEST_TSC_FREQ.
  */
-static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
+static enum es_result __vc_handle_secure_tsc_msrs(struct es_em_ctxt *ctxt, bool write)
 {
+	struct pt_regs *regs = ctxt->regs;
 	u64 tsc;
 
 	/*
-	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is enabled.
-	 * Terminate the SNP guest when the interception is enabled.
+	 * Writing to MSR_IA32_TSC can cause subsequent reads of the TSC to
+	 * return undefined values, and GUEST_TSC_FREQ is read-only. Generate
+	 * a #GP on all writes.
 	 */
-	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
-		return ES_VMM_ERROR;
+	if (write) {
+		ctxt->fi.vector = X86_TRAP_GP;
+		ctxt->fi.error_code = 0;
+		return ES_EXCEPTION;
+	}
 
 	/*
-	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
-	 *         to return undefined values, so ignore all writes.
-	 *
-	 * Reads: Reads of MSR_IA32_TSC should return the current TSC value, use
-	 *        the value returned by rdtsc_ordered().
+	 * GUEST_TSC_FREQ read should not be intercepted when Secure TSC is
+	 * enabled. Terminate the guest if a read is attempted.
 	 */
-	if (write) {
-		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
-		return ES_OK;
-	}
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
+		return ES_VMM_ERROR;
 
+	/* Reads of MSR_IA32_TSC should return the current TSC value. */
 	tsc = rdtsc_ordered();
 	regs->ax = lower_32_bits(tsc);
 	regs->dx = upper_32_bits(tsc);
@@ -416,7 +417,7 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	case MSR_IA32_TSC:
 	case MSR_AMD64_GUEST_TSC_FREQ:
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
-			return __vc_handle_secure_tsc_msrs(regs, write);
+			return __vc_handle_secure_tsc_msrs(ctxt, write);
 		break;
 	default:
 		break;
-- 
2.50.1



