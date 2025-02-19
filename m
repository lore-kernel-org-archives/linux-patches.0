Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55F1A314B;
	Wed, 19 Feb 2025 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957167; cv=none; b=lm4RF+1X7VxCc9Ezrcx5DqgbjoBxu4w1gMmmVPTyvqRtxrbHPlQbh2w5QWlD2AWpqGLP7CxBoAwclBqUJUt2yQElXvtdxw5ni0y0fBEjbKKALTeqvcjc7uBIn3cSfkCyRszCCCZmvHzWl1TMs6zzCWv32+3RemzbG2O+yJyl3Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957167; c=relaxed/simple;
	bh=MoDb0wII72tEZJ6sT7CiraQIbEWB4uDuKsnWS6gYx44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kxt/7H6mBzWMRxMOEYr73Es1gxOjsADd+HB1GZTaueAARTwUvKmEyvSxaRVzfeOwp6G/9PLtJyAl2lWfZ3jaND0Gl+sJwGGGmO11ffr+9m8stwoK7YSPnYHJuCTwTFXqUOqw7OKzBzcrCH6tgO4NHMpBumWK016vrCibXvnjKFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hz07W8Y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hz07W8Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562C6C4CED1;
	Wed, 19 Feb 2025 09:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957166;
	bh=MoDb0wII72tEZJ6sT7CiraQIbEWB4uDuKsnWS6gYx44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hz07W8Y5VlRpQmhjADntFj2cTsEucGywHYh/LiI7A8KLwo1Kc/M13GN0bxZT/Y5ux
	 /50DGt9vILzhe/1OQuMaHLzNpZYYSHn8vM0UJO4Z4PfYMRq6vjBOj7Pr2mUAznRndZ
	 nnYc02uwQEpsAvUnCCWpQ/qRb5WNJ6FfxyPC7quU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Chan <towinchenmi@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 432/578] irqchip/apple-aic: Only handle PMC interrupt as FIQ when configured so
Date: Wed, 19 Feb 2025 09:27:16 +0100
Message-ID: <20250219082710.006267601@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -555,7 +555,8 @@ static void __exception_irq_entry aic_ha
 						  AIC_FIQ_HWIRQ(AIC_TMR_EL02_VIRT));
 	}
 
-	if (read_sysreg_s(SYS_IMP_APL_PMCR0_EL1) & PMCR0_IACT) {
+	if ((read_sysreg_s(SYS_IMP_APL_PMCR0_EL1) & (PMCR0_IMODE | PMCR0_IACT)) ==
+			(FIELD_PREP(PMCR0_IMODE, PMCR0_IMODE_FIQ) | PMCR0_IACT)) {
 		int irq;
 		if (cpumask_test_cpu(smp_processor_id(),
 				     &aic_irqc->fiq_aff[AIC_CPU_PMU_P]->aff))


