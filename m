Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9AB3FD96B;
	Fri,  7 Aug 2026 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113766; cv=none; b=Fw6sRyIYBFwv4j9jxdI6eMp7btrw54AfUQnLepD4CdGhCjVnW5uQknV+82Wj+8G6N4bT2iKFFaSU2WuwEyLpImAyKKduIU6FhYUFojiz5+Hyu46DUDLJFsSFKVgOaI4YB0bAW/l0TlVmytcH2BPM+/gP9ExX2X7kHbepKeOZinE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113766; c=relaxed/simple;
	bh=JuBmBmrI4VLEG+tT/l5qprFAeFEymnEv0ixKhkVneqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZ9RV3LbeX+4ybgfJ6cVyCDkSx3FtoDJq/4mhhh4hBykpU8pdfMUOj5aOyl5dj1Edcz871gNhNqw2qBvw9DXPQSgRA8HXsRvW3S5bNJoeKb88oq1ZO7rylJjkmW8J7n8eG6LlKwi2qoTpsURMrCWg7QOirWMDx7dKVhNfGFlCNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4591Yph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4591Yph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157BE1F00ADB;
	Fri,  7 Aug 2026 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113742;
	bh=PEV5L0BjsEAlikaGORdk5guK1TICZy+GhuEplkj1J/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4591YphUWMZ9lLV3Ksj/RuuRU/Wy0vkLIV+X8j6yEBrVhM8rfb9UYrOJ0t6lcG80
	 iliy0yoRugvrMLmelXcRVsztu41g/u7SUTNaRkFMRW1GkcIMjQMgaDZxX3thBg+a/o
	 85BwsqoEDRvJ+OFfKtKe8pzmMHELUfZm8npzecn8=
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
Subject: [PATCH 6.12 020/337] pinctrl: qcom: Unconditionally mark gpio as wakeup enable
Date: Fri,  7 Aug 2026 16:33:43 +0200
Message-ID: <20260807143418.956759553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 27eb585bf42df..994f46c4c3b6b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1247,12 +1247,12 @@ static int msm_gpio_irq_reqres(struct irq_data *d)
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
@@ -1280,7 +1280,7 @@ static void msm_gpio_irq_relres(struct irq_data *d)
 	unsigned long flags;
 
 	/* Disable the wakeup_enable bit if it has been set in msm_gpio_irq_reqres() */
-	if (test_bit(d->hwirq, pctrl->skip_wake_irqs) && g->intr_wakeup_present_bit) {
+	if (g->intr_wakeup_present_bit) {
 		u32 intr_cfg;
 
 		raw_spin_lock_irqsave(&pctrl->lock, flags);
-- 
2.53.0



