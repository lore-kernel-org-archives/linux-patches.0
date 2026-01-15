Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DA22FDC4D;
	Thu, 15 Jan 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496969; cv=none; b=M5gA34iB7aHKcRG+qMsUXS+jMIJMsbwm0hZDZHuHS0uKSt3+JoJzeoOFbgBZ2bQa8sv7A7RgNQVD2FSdo+PzsS2uXGWwbncnri4pzWBYdlLSCwgYztAKzdMhG1spReQu1/4KdDmgfD4m1LCraKaI9rTVkTUWGOcHrE4DCIm2zvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496969; c=relaxed/simple;
	bh=Ne4x8Obt43xZ71TGy985rrCSIGx3YrL/p9FnCsnfQYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFSYt4i26uiCGXcY8pbXd0wHC+k/x/Su6lHIIHdOzgVbRrLO+SiKJ1CWPhfTiz4h40kTYblcdQ/d634WoE6DjiAhDImLcAqJ7lRH7YBLI69fwRylrgZk55glGL6zUEQsGSoM84kzvNgn8ebQyxswiH4cgPBfOvC9M+vinFI4slA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMYn6v8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMYn6v8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D035C19422;
	Thu, 15 Jan 2026 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496969;
	bh=Ne4x8Obt43xZ71TGy985rrCSIGx3YrL/p9FnCsnfQYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMYn6v8VCGG4WIPR5JdR/mPGnd9oSpu6aQPumvMNsqNgDx2Fn1uB/MgTr2mJ0lkr0
	 rTDeTlR0Ac5KpbH3E6hseoamhvREJEyvnyXGCReBNqHkXqa5siXOYEw4PbI9PEkzGX
	 KWPeoeIRT57XHdlpbNXjC0A4jlODXNkNzBAAIW28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Potin Lai <potin.lai.pt@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 46/88] gpio: pca953x: Add support for level-triggered interrupts
Date: Thu, 15 Jan 2026 17:48:29 +0100
Message-ID: <20260115164147.977655526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Potin Lai <potin.lai.pt@gmail.com>

[ Upstream commit 417b0f8d08f878615de9481c6e8827fbc8b57ed2 ]

Adds support for level-triggered interrupts in the PCA953x GPIO
expander driver. Previously, the driver only supported edge-triggered
interrupts, which could lead to missed events in scenarios where an
interrupt condition persists until it is explicitly cleared.

By enabling level-triggered interrupts, the driver can now detect and
respond to sustained interrupt conditions more reliably.

Signed-off-by: Potin Lai <potin.lai.pt@gmail.com>
Link: https://lore.kernel.org/r/20250409-gpio-pca953x-level-triggered-irq-v3-1-7f184d814934@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 014a17deb412 ("gpio: pca953x: handle short interrupt pulses on PCAL devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index de965e6353c5b..6b9bfdebadb5a 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -207,6 +207,8 @@ struct pca953x_chip {
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
 	DECLARE_BITMAP(irq_trig_raise, MAX_LINE);
 	DECLARE_BITMAP(irq_trig_fall, MAX_LINE);
+	DECLARE_BITMAP(irq_trig_level_high, MAX_LINE);
+	DECLARE_BITMAP(irq_trig_level_low, MAX_LINE);
 #endif
 	atomic_t wakeup_path;
 
@@ -767,6 +769,8 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
 
 	bitmap_or(irq_mask, chip->irq_trig_fall, chip->irq_trig_raise, gc->ngpio);
+	bitmap_or(irq_mask, irq_mask, chip->irq_trig_level_high, gc->ngpio);
+	bitmap_or(irq_mask, irq_mask, chip->irq_trig_level_low, gc->ngpio);
 	bitmap_complement(reg_direction, reg_direction, gc->ngpio);
 	bitmap_and(irq_mask, irq_mask, reg_direction, gc->ngpio);
 
@@ -784,13 +788,15 @@ static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 	struct device *dev = &chip->client->dev;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
-	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
+	if (!(type & IRQ_TYPE_SENSE_MASK)) {
 		dev_err(dev, "irq %d: unsupported type %d\n", d->irq, type);
 		return -EINVAL;
 	}
 
 	assign_bit(hwirq, chip->irq_trig_fall, type & IRQ_TYPE_EDGE_FALLING);
 	assign_bit(hwirq, chip->irq_trig_raise, type & IRQ_TYPE_EDGE_RISING);
+	assign_bit(hwirq, chip->irq_trig_level_low, type & IRQ_TYPE_LEVEL_LOW);
+	assign_bit(hwirq, chip->irq_trig_level_high, type & IRQ_TYPE_LEVEL_HIGH);
 
 	return 0;
 }
@@ -803,6 +809,8 @@ static void pca953x_irq_shutdown(struct irq_data *d)
 
 	clear_bit(hwirq, chip->irq_trig_raise);
 	clear_bit(hwirq, chip->irq_trig_fall);
+	clear_bit(hwirq, chip->irq_trig_level_low);
+	clear_bit(hwirq, chip->irq_trig_level_high);
 }
 
 static void pca953x_irq_print_chip(struct irq_data *data, struct seq_file *p)
@@ -833,6 +841,7 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	DECLARE_BITMAP(cur_stat, MAX_LINE);
 	DECLARE_BITMAP(new_stat, MAX_LINE);
 	DECLARE_BITMAP(trigger, MAX_LINE);
+	DECLARE_BITMAP(edges, MAX_LINE);
 	int ret;
 
 	ret = pca953x_read_regs(chip, chip->regs->input, cur_stat);
@@ -850,13 +859,26 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 
 	bitmap_copy(chip->irq_stat, new_stat, gc->ngpio);
 
-	if (bitmap_empty(trigger, gc->ngpio))
-		return false;
+	if (bitmap_empty(chip->irq_trig_level_high, gc->ngpio) &&
+	    bitmap_empty(chip->irq_trig_level_low, gc->ngpio)) {
+		if (bitmap_empty(trigger, gc->ngpio))
+			return false;
+	}
 
 	bitmap_and(cur_stat, chip->irq_trig_fall, old_stat, gc->ngpio);
 	bitmap_and(old_stat, chip->irq_trig_raise, new_stat, gc->ngpio);
-	bitmap_or(new_stat, old_stat, cur_stat, gc->ngpio);
-	bitmap_and(pending, new_stat, trigger, gc->ngpio);
+	bitmap_or(edges, old_stat, cur_stat, gc->ngpio);
+	bitmap_and(pending, edges, trigger, gc->ngpio);
+
+	bitmap_and(cur_stat, new_stat, chip->irq_trig_level_high, gc->ngpio);
+	bitmap_and(cur_stat, cur_stat, chip->irq_mask, gc->ngpio);
+	bitmap_or(pending, pending, cur_stat, gc->ngpio);
+
+	bitmap_complement(cur_stat, new_stat, gc->ngpio);
+	bitmap_and(cur_stat, cur_stat, reg_direction, gc->ngpio);
+	bitmap_and(old_stat, cur_stat, chip->irq_trig_level_low, gc->ngpio);
+	bitmap_and(old_stat, old_stat, chip->irq_mask, gc->ngpio);
+	bitmap_or(pending, pending, old_stat, gc->ngpio);
 
 	return !bitmap_empty(pending, gc->ngpio);
 }
-- 
2.51.0



