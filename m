Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD5145A03;
	Thu, 13 Feb 2025 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459942; cv=none; b=Ac4d0hoEYHMaukiaQfbQiV6bD6OesdznqfQa6CCTRv2Wbb8DA0oTXaKkNQhPesTl+gkoaKyiJL+Zqz76R0p4lmd/Q2lt0SBjZ1eZDKRpfuiF9gnjfXBPr36c/qbVVM75iRwGkqbXh0p6PbPniqOW+bVD6ps1QmzvHj3jpP8lu3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459942; c=relaxed/simple;
	bh=sKzxIir9Yb/rk6AVSsOTyK0DmXoqDJHHaf2iLyJxA74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyJq5dSlvhAtoh/FLJsEK2AU5CBZ7WPROKVOXFBSvTgzSnwCcFIUeYpW2AN9s0hYXchirRlb3/ghyRTKMl8sN8wvjT61GUULDTpvhbqPRaamyy/8bGWjEgPo5NVUbpXZfKIYxaYCL5Rjbdr7LxNry5D4dma6+qXqNaWvj3N3Gxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOwTR1Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOwTR1Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53735C4CED1;
	Thu, 13 Feb 2025 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459941;
	bh=sKzxIir9Yb/rk6AVSsOTyK0DmXoqDJHHaf2iLyJxA74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOwTR1VgjMAV+31c40xUUErAHb2zmJm3cRbyK1Aod8+zVUw9azsTF0/bMbOm60nuK
	 BleDQWbQtfePKJYIXQd3NrqGH9GS8SXgEx6/RygVKb60THQvND71kFYBasqq/AusJH
	 TsapUu5NN48MIs2WhcraLlrQondw3PWnKKgBzE/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Chan <towinchenmi@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 409/443] irqchip/apple-aic: Only handle PMC interrupt as FIQ when configured so
Date: Thu, 13 Feb 2025 15:29:34 +0100
Message-ID: <20250213142456.391001024@linuxfoundation.org>
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

From: Nick Chan <towinchenmi@gmail.com>

commit 698244bbb3bfd32ddf9a0b70a12b1c7d69056497 upstream.

The CPU PMU in Apple SoCs can be configured to fire its interrupt in one of
several ways, and since Apple A11 one of the methods is FIQ, but the check
of the configuration register fails to test explicitely for FIQ mode. It
tests whether the IMODE bitfield is zero or not and the PMCRO_IACT bit is
set. That results in false positives when the IMODE bitfield is not zero,
but does not have the mode PMCR0_IMODE_FIQ.

Only handle the PMC interrupt as a FIQ when the CPU PMU has been configured
to fire FIQs, i.e. the IMODE bitfield value is PMCR0_IMODE_FIQ and
PMCR0_IACT is set.

Fixes: c7708816c944 ("irqchip/apple-aic: Wire PMU interrupts")
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250118163554.16733-1-towinchenmi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-apple-aic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -577,7 +577,8 @@ static void __exception_irq_entry aic_ha
 						  AIC_FIQ_HWIRQ(AIC_TMR_EL02_VIRT));
 	}
 
-	if (read_sysreg_s(SYS_IMP_APL_PMCR0_EL1) & PMCR0_IACT) {
+	if ((read_sysreg_s(SYS_IMP_APL_PMCR0_EL1) & (PMCR0_IMODE | PMCR0_IACT)) ==
+			(FIELD_PREP(PMCR0_IMODE, PMCR0_IMODE_FIQ) | PMCR0_IACT)) {
 		int irq;
 		if (cpumask_test_cpu(smp_processor_id(),
 				     &aic_irqc->fiq_aff[AIC_CPU_PMU_P]->aff))


