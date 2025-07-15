Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F080C2EB5AC;
	Tue, 15 Jul 2025 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586584; cv=none; b=dWELh2tXYczBA/Q4x3wn8U00fd3lG0p0StS/WHJ/ndI86ZuSNBk9+WmizfTo6E56L0oJMjc7uLElJv7lzxIjOsum96akPBiwOM42W83NvonMLJXPippzcuyzcrYRbCIkidQUEAcQ38gZoTM6U5TKiWKkwZd0onOK5qT9zCHG1oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586584; c=relaxed/simple;
	bh=DusmBOJnCVSZ4YTJnWFx5rLNO+1Bzq2V5Z940axG6aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+VbX8e0EdAE3BBsom6cEnXFlZgM1c7XnUNZNFY/rpzSAN0HnysLTmBmr9YyiYGFqru++p7u+sK0tNuUt+lz7zz4qD3s1AsKNJQkWYcifQodt7DWCEJ48WvrHPBYUP6PXOlYUVTqE/UJH6kMHqohGf78hrhkjDpkJsAkhroSCB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZods1yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZods1yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A6CC4CEF1;
	Tue, 15 Jul 2025 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586583;
	bh=DusmBOJnCVSZ4YTJnWFx5rLNO+1Bzq2V5Z940axG6aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZods1yFZOsoFeX/OTK4TLoopmSa+lrxtVAA6W5MuUOSyqblHE8wglDWByO0OnS7E
	 4uDwOUww4HqmE82aw7XrYKhzvRppZ730C3ca4tBP0D3q7r8Zf48m4olLPLbRvcEcHT
	 3UOs45NntNTOlSVX7aH9ibzRzJtMXeLTUs6h5jKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 120/148] pinctrl: qcom: msm: mark certain pins as invalid for interrupts
Date: Tue, 15 Jul 2025 15:14:02 +0200
Message-ID: <20250715130805.104949684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -812,6 +812,25 @@ static void msm_gpio_irq_ack(struct irq_
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
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
@@ -1039,6 +1058,7 @@ static int msm_gpio_init(struct msm_pinc
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_bad_irq;
 	girq->parents[0] = pctrl->irq;
+	girq->init_valid_mask = msm_gpio_irq_init_valid_mask;
 
 	ret = gpiochip_add_data(&pctrl->chip, pctrl);
 	if (ret) {


