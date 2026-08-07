Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21B23B9943;
	Fri,  7 Aug 2026 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114689; cv=none; b=TXNOQnc9E4KSSH32a9F13PeO7HVFDVqq9Dyttf/mhG1092RoxZD18Tp7SRYIySKrPoGBtPKbwcwh4JfDl5P9gWDUcO4d036e601+3dMHfYPNMjGwADSvX8PUGWGREngXcn0mm7GoVSIHlzpbX0OUHn9K/KRYJIxOzCzmn4Mo8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114689; c=relaxed/simple;
	bh=LAD9MFqLB7mLV34nkD29TuIIyDrgCXqdr3Z2wXg1DaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPdYTfQGV/zRPj2RU/Cdtv0qY7c1H1caDd6vvnsNwRLpkO5MouH53Nf3MPRMA6BCLtFtDA6JCv0P8qUWW2Re8+u6XIzE1t5H7sc1PO0toTW/F1Y/csaAu1Y5wcWT1tDwFBpcgkx2kpfBbRvh0Z66To1pVv5QdLCBteZjks6rZBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4wV/OAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4wV/OAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194AD1F000E9;
	Fri,  7 Aug 2026 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114687;
	bh=I4O0Y6PU4mbNyshzyZL5RrYy1nUNY0FxpQzpvizi0RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4wV/OAPhT6SaioHfzU+pWmfPbXCkVzLZP3ev7pv7gAgTJdGQxVjWjI9kMl4IAcbO
	 B9C8Omwn93MJC+0lTYtnXdC1c2cTi90VRt1FVPko8LWgdYYSdIz2aviGelCXNOOmXV
	 QxU9KoNmD4h8lu550owYKcfmNHIQgAWVMJxawx+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/396] pinctrl: qcom: Unconditionally mark gpio as wakeup enable
Date: Fri,  7 Aug 2026 16:32:54 +0200
Message-ID: <20260807143424.585355313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sneh Mankad <sneh.mankad@oss.qualcomm.com>

[ Upstream commit 859e02a369ab328a77dfcabf59562100e55f9c5c ]

GPIO interrupts that are wakeup capable need to be forwarded to wakeup
capable parent irqchip. This is done via writing to it's wakeup_enable bit.

Currently the bit is set only for PDC irqchip by checking skip_wake_irqs.
skip_wake_irqs is set to differentiate between parent irqchips MPM and
PDC. It is set when the parent irqchip is PDC to inform pinctrl about
skipping the IRQ setting up at TLMM.

However, the functionality to forward GPIO interrupts during SoC low
power mode is needed regardless of which parent irqchip it is.
Without the functionality it is impossible for MPM irqchip to detect the
GPIO interrupt during SoC low power mode since for MPM irqchip the
skip_wake_irqs is always false.

Remove skip_wake_irqs condition when setting wakeup enable bit to allow
forwarding GPIO interrupts for SoCs using MPM irqchip too.

Fixes: 76b446f5b86e ("pinctrl: qcom: handle intr_target_reg wakeup_present/enable bits")
Signed-off-by: Sneh Mankad <sneh.mankad@oss.qualcomm.com>
Reviewed-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260616-enable_wakeup_capable_gpios-v3-1-fb59647d89cb@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index e99871b90ab9c..424b14bc29e96 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1226,12 +1226,12 @@ static int msm_gpio_irq_reqres(struct irq_data *d)
 	/*
 	 * If the wakeup_enable bit is present and marked as available for the
 	 * requested GPIO, it should be enabled when the GPIO is marked as
-	 * wake irq in order to allow the interrupt event to be transfered to
-	 * the PDC HW.
+	 * wake irq in order to allow the interrupt event to be transferred to
+	 * the PDC/MPM HW.
 	 * While the name implies only the wakeup event, it's also required for
 	 * the interrupt event.
 	 */
-	if (test_bit(d->hwirq, pctrl->skip_wake_irqs) && g->intr_wakeup_present_bit) {
+	if (g->intr_wakeup_present_bit) {
 		u32 intr_cfg;
 
 		raw_spin_lock_irqsave(&pctrl->lock, flags);
@@ -1259,7 +1259,7 @@ static void msm_gpio_irq_relres(struct irq_data *d)
 	unsigned long flags;
 
 	/* Disable the wakeup_enable bit if it has been set in msm_gpio_irq_reqres() */
-	if (test_bit(d->hwirq, pctrl->skip_wake_irqs) && g->intr_wakeup_present_bit) {
+	if (g->intr_wakeup_present_bit) {
 		u32 intr_cfg;
 
 		raw_spin_lock_irqsave(&pctrl->lock, flags);
-- 
2.53.0



