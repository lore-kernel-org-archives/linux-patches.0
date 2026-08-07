Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF43557F3;
	Fri,  7 Aug 2026 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116598; cv=none; b=OywQ/PmlQzInJvE7ZaN6X0o6zFytwakcvivh2j6gZ+Di1x2ytJyOGAOKduZOGhKIT/UFQn+foi74NenAdU6cpdG8cRCOdAT8hN7aj7E5JPH3/DMGnLTp6yV4+tGtjz3zbkm48Ojltozn8CFiqROKZP9bR7bxt8R2FOzXTNoQlhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116598; c=relaxed/simple;
	bh=qS1H2VWWTNIImdvMB9DYieruioIeV6Nnv21x/DpI+vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5rZM1n0I8XcXLVF91DgJSwwU3FYbEfXA8J5Oi/x2lg0bnIehCjenG5i9g0Z/hwqRaxogSi8ZbxBw1gegbxhSfOFqRo4klaRGalKyypMfK41wy1Ut+kYGwGIXVMMLsc5r12v7NMuqDiajIAWaNgHxDilcHhmLQ9Q5yOsDnSM2QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mf33AyCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mf33AyCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798821F000E9;
	Fri,  7 Aug 2026 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116597;
	bh=b5iGQ5/9qh8oEzEP5TykcGzIoiItG5zfJKKSQKM1aNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mf33AyCNboimzEbdFe1NHjWoxH9jIBkB6TYCPOduuGJm6AD9QFy9iCQE5rZH8oIWU
	 3AGBdVh949J4iQMe7VKr77ABfc5Yf2kegUL2R2nu/3tPhcjbPRBae5uBCXj6sUkn3d
	 oMVZ/A6kVehLjvJN8f4dJD7UAj4bL6kBLuS8o5Ok=
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
Subject: [PATCH 7.1 009/438] pinctrl: qcom: Unconditionally mark gpio as wakeup enable
Date: Fri,  7 Aug 2026 16:33:25 +0200
Message-ID: <20260807143428.210346177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 45b3a2763eb85..6a24f9b5e4a97 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1242,12 +1242,12 @@ static int msm_gpio_irq_reqres(struct irq_data *d)
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
@@ -1275,7 +1275,7 @@ static void msm_gpio_irq_relres(struct irq_data *d)
 	unsigned long flags;
 
 	/* Disable the wakeup_enable bit if it has been set in msm_gpio_irq_reqres() */
-	if (test_bit(d->hwirq, pctrl->skip_wake_irqs) && g->intr_wakeup_present_bit) {
+	if (g->intr_wakeup_present_bit) {
 		u32 intr_cfg;
 
 		raw_spin_lock_irqsave(&pctrl->lock, flags);
-- 
2.53.0



