Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D0D1514F6;
	Thu, 13 Feb 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458454; cv=none; b=WzZrClPR6vq66fi1uoVfmbzdSAjmuu1Q1XTwHnZit1+HHZLI75BwtPW5yh1F6Yul85mnwlO/fu2oGzgXmu/oo5ZNwb0WHfAT6EaPNd/6Ktb0zAsZSQMYgOnnog7/tDKQ2F+e2dkNFd6z8sENIeobIKg8Sh3x6EUXAUXgUFZ2zWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458454; c=relaxed/simple;
	bh=M7eUIUbigO6D+uRSulpNV/V8tiP1wssG3BE3m9FRh9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WK8TAh3kdoCWs7UfvOmPnur0Ugb+4cVlb+gSgn0pya5d89kp1htkMKXrvw6Uz+W2aIvS0GWe6Mg+m7lIKRm7wqPo+/VKpYXNBdsHAwgKgbwwIJdrH39alRdLKUfyJDXQjP9fWDjHqf/tGAdEE+JwRb3TvZRGkZyrnILkYjh11nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiaasJ6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiaasJ6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A9FC4CEE4;
	Thu, 13 Feb 2025 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458454;
	bh=M7eUIUbigO6D+uRSulpNV/V8tiP1wssG3BE3m9FRh9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xiaasJ6rnq9TcZPKeWCDnsIHcPet/9/9I2ql/MGdXNzgvg6COaORGLSEnNxtQX8Kl
	 8xe0ycCAv+b5NYIlx8ixxdY9VFqPoL2IEJzOJEdf1dtedPZWkM2c3xLxIGFkfnLsEK
	 Xj1bHz3cIQhkRSOkmEQhZlf9FMXTBHcLwyQjnLfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Chan <towinchenmi@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 372/422] irqchip/apple-aic: Only handle PMC interrupt as FIQ when configured so
Date: Thu, 13 Feb 2025 15:28:41 +0100
Message-ID: <20250213142450.903616895@linuxfoundation.org>
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


