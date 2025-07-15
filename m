Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DE12E54C1;
	Tue, 15 Jul 2025 13:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585959; cv=none; b=Vfr7ShN+5rXx7h3Gj89E371hPI4UABlvxpjHFYxVgoYNoOrF8gUoKg6FvuCmEY+2/8Uruq5MX9mXbBhElLqWy0EtWzkWn9hxOqJPsaNK3ey10WFBW2QIHvRJXNkLskTVI5XQvOa+9NIoDFo5bMgK7TTOfAC/c+w7VDqsuV7mjuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585959; c=relaxed/simple;
	bh=jthzPBQwlVeviJ5+gHXiTbwNIkrTy4QQwRR99gxUQ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnwEf1hzWTmwPHAmXP788ouJLpXjuqJjazoyCCQI53ADnxJMpmhE13g0C0xs+c8R9N5x5/7ggEg3Dt8ATFU97iPTCDruWoMQLTw0S9ztwrDgQET0AT2DRkfaLUFSz1jYn5plb9KZiux0BKVixH5w5F/EMRpyBLtGCYx2S4WccfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+wN9Ezu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+wN9Ezu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD29C4CEE3;
	Tue, 15 Jul 2025 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585959;
	bh=jthzPBQwlVeviJ5+gHXiTbwNIkrTy4QQwRR99gxUQ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+wN9EzuuAGPj0jBNo/LBnVROwIn+bOXpoIgW06PvQ5fu5UapO6rHz6dhc2EokQgc
	 byURFL2RijESlEEowu0UWJmgMh5nvoVA4XSUSr0IT76WJ/E4GcKnsQ1jbv84/Jxjhw
	 BAt6QgSeV9Jhl3EMIHOdNE+46OSNyHJc+DXM2JpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 041/109] pinctrl: qcom: msm: mark certain pins as invalid for interrupts
Date: Tue, 15 Jul 2025 15:12:57 +0200
Message-ID: <20250715130800.524420202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 93712205ce2f1fb047739494c0399a26ea4f0890 upstream.

On some platforms, the UFS-reset pin has no interrupt logic in TLMM but
is nevertheless registered as a GPIO in the kernel. This enables the
user-space to trigger a BUG() in the pinctrl-msm driver by running, for
example: `gpiomon -c 0 113` on RB2.

The exact culprit is requesting pins whose intr_detection_width setting
is not 1 or 2 for interrupts. This hits a BUG() in
msm_gpio_irq_set_type(). Potentially crashing the kernel due to an
invalid request from user-space is not optimal, so let's go through the
pins and mark those that would fail the check as invalid for the irq chip
as we should not even register them as available irqs.

This function can be extended if we determine that there are more
corner-cases like this.

Fixes: f365be092572 ("pinctrl: Add Qualcomm TLMM driver")
Cc: stable@vger.kernel.org
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/20250612091448.41546-1-brgl@bgdev.pl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1031,6 +1031,25 @@ static bool msm_gpio_needs_dual_edge_par
 	       test_bit(d->hwirq, pctrl->skip_wake_irqs);
 }
 
+static void msm_gpio_irq_init_valid_mask(struct gpio_chip *gc,
+					 unsigned long *valid_mask,
+					 unsigned int ngpios)
+{
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+	const struct msm_pingroup *g;
+	int i;
+
+	bitmap_fill(valid_mask, ngpios);
+
+	for (i = 0; i < ngpios; i++) {
+		g = &pctrl->soc->groups[i];
+
+		if (g->intr_detection_width != 1 &&
+		    g->intr_detection_width != 2)
+			clear_bit(i, valid_mask);
+	}
+}
+
 static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -1392,6 +1411,7 @@ static int msm_gpio_init(struct msm_pinc
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_bad_irq;
 	girq->parents[0] = pctrl->irq;
+	girq->init_valid_mask = msm_gpio_irq_init_valid_mask;
 
 	ret = gpiochip_add_data(&pctrl->chip, pctrl);
 	if (ret) {


