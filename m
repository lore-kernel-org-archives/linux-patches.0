Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6FE257AD4;
	Thu, 17 Apr 2025 18:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916181; cv=none; b=J2ceHcNlfLSYHEQQg35fvoozbT2IuqIQF+M9yV7uTRPgsQMAaMg8kAVV3djyYtzJyyLG3ji0njxb14ajuWfzpM8otcZfjXrNn37LHrj3IdKTztb+TXsEH3pQEbT2uXtVgXWV/KZRswD0w+83dzp+0pzwyvrfqhOaVxBZTEqjz1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916181; c=relaxed/simple;
	bh=i5uH9gL8y+ufOPOk8uNNsmfOkg+Ft/5/70fQyQ3+PgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2g41Eycsh1p1CBn25XclhmZjRq3czXLxNyNeHcaD6/XzFAAxfLt3cFMOQcd+5E8kYrmViGmakocF1SND4bjO//Qmi67u5FvbhKdP8jo+7MV03e7nihIqXdXKC+Qwv/2aVe96xgPjVZrRSL2omqcv9bUoRXJMNdrlBtdNZkf2eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZoH87xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZoH87xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF86C4CEE7;
	Thu, 17 Apr 2025 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916180;
	bh=i5uH9gL8y+ufOPOk8uNNsmfOkg+Ft/5/70fQyQ3+PgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZoH87xdMKLZrpSNmNbgR8tnQu9q7+64nrH5Im1JfqhoqNS0AS8ekSTK1mAnvGx+Y
	 6pLpk850qAEQ3eAAJ3qNtW9CIShaulJci084pv5WToF1TynSU3ZFw65JbcqjgQ6cA0
	 2NSq+q52SjQNtbngARdUjkEWcHkt1BC95VK8BP6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.12 369/393] pinctrl: qcom: Clear latched interrupt status when changing IRQ type
Date: Thu, 17 Apr 2025 19:52:58 +0200
Message-ID: <20250417175122.442906604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit e225128c3f8be879e7d4eb71a25949e188b420ae upstream.

When submitting the TLMM test driver, Bjorn reported that some of the test
cases are failing for GPIOs that not are backed by PDC (i.e. "non-wakeup"
GPIOs that are handled directly in pinctrl-msm). Basically, lingering
latched interrupt state is still being delivered at IRQ request time, e.g.:

  ok 1 tlmm_test_silent_rising
  tlmm_test_silent_falling: ASSERTION FAILED at drivers/pinctrl/qcom/tlmm-test.c:178
  Expected atomic_read(&priv->intr_count) == 0, but
      atomic_read(&priv->intr_count) == 1 (0x1)
  not ok 2 tlmm_test_silent_falling
  tlmm_test_silent_low: ASSERTION FAILED at drivers/pinctrl/qcom/tlmm-test.c:178
  Expected atomic_read(&priv->intr_count) == 0, but
      atomic_read(&priv->intr_count) == 1 (0x1)
  not ok 3 tlmm_test_silent_low
  ok 4 tlmm_test_silent_high

Whether to report interrupts that came in while the IRQ was unclaimed
doesn't seem to be well-defined in the Linux IRQ API. However, looking
closer at these specific cases, we're actually reporting events that do not
match the interrupt type requested by the driver:

 1. After "ok 1 tlmm_test_silent_rising", the GPIO is in low state and
    configured for IRQF_TRIGGER_RISING.

 2. (a) In preparation for "tlmm_test_silent_falling", the GPIO is switched
        to high state. The rising interrupt gets latched.
    (b) The GPIO is re-configured for IRQF_TRIGGER_FALLING, but the latched
        interrupt isn't cleared.
    (c) The IRQ handler is called for the latched interrupt, but there
        wasn't any falling edge.

 3. (a) For "tlmm_test_silent_low", the GPIO remains in high state.
    (b) The GPIO is re-configured for IRQF_TRIGGER_LOW. This seems to
        result in a phantom interrupt that gets latched.
    (c) The IRQ handler is called for the latched interrupt, but the GPIO
        isn't in low state.

 4. (a) For "tlmm_test_silent_high", the GPIO is switched to low state.
    (b) This doesn't result in a latched interrupt, because RAW_STATUS_EN
        was cleared when masking the level-triggered interrupt.

Fix this by clearing the interrupt state whenever making any changes to the
interrupt configuration. This includes previously disabled interrupts, but
also any changes to interrupt polarity or detection type.

With this change, all 16 test cases are now passing for the non-wakeup
GPIOs in the TLMM.

Cc: stable@vger.kernel.org
Fixes: cf9d052aa600 ("pinctrl: qcom: Don't clear pending interrupts when enabling")
Reported-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Closes: https://lore.kernel.org/r/20250227-tlmm-test-v1-1-d18877b4a5db@oss.qualcomm.com/
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/20250312-pinctrl-msm-type-latch-v1-1-ce87c561d3d7@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1044,8 +1044,7 @@ static int msm_gpio_irq_set_type(struct
 	const struct msm_pingroup *g;
 	u32 intr_target_mask = GENMASK(2, 0);
 	unsigned long flags;
-	bool was_enabled;
-	u32 val;
+	u32 val, oldval;
 
 	if (msm_gpio_needs_dual_edge_parent_workaround(d, type)) {
 		set_bit(d->hwirq, pctrl->dual_edge_irqs);
@@ -1107,8 +1106,7 @@ static int msm_gpio_irq_set_type(struct
 	 * internal circuitry of TLMM, toggling the RAW_STATUS
 	 * could cause the INTR_STATUS to be set for EDGE interrupts.
 	 */
-	val = msm_readl_intr_cfg(pctrl, g);
-	was_enabled = val & BIT(g->intr_raw_status_bit);
+	val = oldval = msm_readl_intr_cfg(pctrl, g);
 	val |= BIT(g->intr_raw_status_bit);
 	if (g->intr_detection_width == 2) {
 		val &= ~(3 << g->intr_detection_bit);
@@ -1161,9 +1159,11 @@ static int msm_gpio_irq_set_type(struct
 	/*
 	 * The first time we set RAW_STATUS_EN it could trigger an interrupt.
 	 * Clear the interrupt.  This is safe because we have
-	 * IRQCHIP_SET_TYPE_MASKED.
+	 * IRQCHIP_SET_TYPE_MASKED. When changing the interrupt type, we could
+	 * also still have a non-matching interrupt latched, so clear whenever
+	 * making changes to the interrupt configuration.
 	 */
-	if (!was_enabled)
+	if (val != oldval)
 		msm_ack_intr_status(pctrl, g);
 
 	if (test_bit(d->hwirq, pctrl->dual_edge_irqs))


