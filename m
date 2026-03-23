Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6666D3B8D6B;
	Mon, 23 Mar 2026 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274367; cv=none; b=KuNP3bLNSjDeg2B6NAaQoc7LRyg5WYP7udm8ZSONgUOP1xu/HyPS5BbtiihV/pV+qPsUBZWf90AyxJ753JrCHIq2BEcHr7j9OIM4WIJTAg6LM//Zi3FYa0FcIrd4PtBzp7INdxDh1PI3N3ru0lgibpxhvwOs24WNKDUcUMNfnWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274367; c=relaxed/simple;
	bh=qR1DKnVCfvgpPdxDrfWX5zb1LdrQ58tpi7so6a1L+c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzVg/UaKV+lgQC10SQyaTymYp4/ELD7j787lsonk9KYGLw3OBFT5xNvBhlOSiY1CnOl+SIwLnuZruK8JnFm9qBDcZD3WDdb0RfWK0LAO2XnzIBq2HvMroLdHysr1x/XinBj1Enl8QzdCKjzRlrYxq/M9NLrlq7RjNE8JGzA3hYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EA6f6+cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EA6f6+cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB11AC4CEF7;
	Mon, 23 Mar 2026 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274367;
	bh=qR1DKnVCfvgpPdxDrfWX5zb1LdrQ58tpi7so6a1L+c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EA6f6+cRfwGojLrIlRulJ4iZtspWDKU6Nun1EeWvTGTflZ8sd2IEStQ6MCMN973on
	 wZ2I7CskE2RB/Z8/7ER7xxFnvZQMzMh59R5nRNoqmMUTH+9EXoqyTXz00ahYTIWhjr
	 nByQQY9RYj5MT3PE2HmecMlw0/Y1Y926tf6Uvxn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Roche <william.roche@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 6.19 195/220] x86/mce/amd: Check SMCA feature bit before accessing SMCA MSRs
Date: Mon, 23 Mar 2026 14:46:12 +0100
Message-ID: <20260323134510.746273669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Roche <william.roche@oracle.com>

commit 201bc182ad6333468013f1af0719ffe125826b6a upstream.

People do effort to inject MCEs into guests in order to simulate/test
handling of hardware errors. The real use case behind it is testing the
handling of SIGBUS which the memory failure code sends to the process.

If that process is QEMU, instead of killing the whole guest, the MCE can
be injected into the guest kernel so that latter can attempt proper
handling and kill the user *process*  in the guest, instead, which
caused the MCE. The assumption being here that the whole injection flow
can supply enough information that the guest kernel can pinpoint the
right process. But that's a different topic...

Regardless of virtualization or not, access to SMCA-specific registers
like MCA_DESTAT should only be done after having checked the smca
feature bit. And there are AMD machines like Bulldozer (the one before
Zen1) which do support deferred errors but are not SMCA machines.

Therefore, properly check the feature bit before accessing related MSRs.

  [ bp: Rewrite commit message. ]

Fixes: 7cb735d7c0cb ("x86/mce: Unify AMD DFR handler with MCA Polling")
Signed-off-by: William Roche <william.roche@oracle.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260218163025.1316501-1-william.roche@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index da13c1e37f87..a030ee4cecc2 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -875,13 +875,18 @@ void amd_clear_bank(struct mce *m)
 {
 	amd_reset_thr_limit(m->bank);
 
-	/* Clear MCA_DESTAT for all deferred errors even those logged in MCA_STATUS. */
-	if (m->status & MCI_STATUS_DEFERRED)
-		mce_wrmsrq(MSR_AMD64_SMCA_MCx_DESTAT(m->bank), 0);
+	if (mce_flags.smca) {
+		/*
+		 * Clear MCA_DESTAT for all deferred errors even those
+		 * logged in MCA_STATUS.
+		 */
+		if (m->status & MCI_STATUS_DEFERRED)
+			mce_wrmsrq(MSR_AMD64_SMCA_MCx_DESTAT(m->bank), 0);
 
-	/* Don't clear MCA_STATUS if MCA_DESTAT was used exclusively. */
-	if (m->kflags & MCE_CHECK_DFR_REGS)
-		return;
+		/* Don't clear MCA_STATUS if MCA_DESTAT was used exclusively. */
+		if (m->kflags & MCE_CHECK_DFR_REGS)
+			return;
+	}
 
 	mce_wrmsrq(mca_msr_reg(m->bank, MCA_STATUS), 0);
 }
-- 
2.53.0



