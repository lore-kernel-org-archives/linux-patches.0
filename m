Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A585427FA6;
	Thu, 16 Jul 2026 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209430; cv=none; b=HjgEG6w3CAKgdokn6hKw5j27o+QnYzoy4jyBRxH3f7jszL2/oWATeXKYBZIDsuTpu8jIPb16Tvv8BotoA/mky+OxHd3GiBqaD2uW+bfd3pFcPy62r7cHgDwet6wVCeu2s07A3SE1zU723FLHXZxwIehaxb8U9mTyJ6RFi8EnBD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209430; c=relaxed/simple;
	bh=k9+busSwEgctHCQvQmnovYSj56FAffHi10UWfimMkUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF1D3KzdZsCZMX2b8xMti6mEVt+Mo9p1znBuPnunwRyxb/pL4BiWrSiwlZEgcToLzX2JaD70EwMNTuHcnPiyz6FMT8g5n519A9buBiMMac/5XIi+j1mB/i+/CzMXOP1rOR3Gti7CJ0V+MaoWhaySpDB5T8Pu8RVFuRkVIHENEr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+j5b1F0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+j5b1F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5481F000E9;
	Thu, 16 Jul 2026 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209426;
	bh=76sE83dmhbubnotlKBAkN+zmfa+Fti9gGR1ojqCeRDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+j5b1F0glW3kY++Of3G6YylIEDCfwWff/nRHrvoX6qUsQXaTO8/RsO45bMqpgKuo
	 EhG38HSdsXwMmgpyUO5RQDAdwKWw51j7TCtB+6nBtgcbaWPEZv0EE4enGuqzPrDJh+
	 K0iXF/O/5Kofq765gzy362sO5ERFd4kH1lI9Lf/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.1 182/518] gpio: sch: use raw_spinlock_t in the irq startup path
Date: Thu, 16 Jul 2026 15:27:30 +0200
Message-ID: <20260716133051.817916098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 286533cb14a3c8a8bd39ff64ea2fc8e1aa0f638b upstream.

sch_irq_unmask() enables the GPIO IRQ and then updates the controller
state through sch_irq_mask_unmask(), which takes sch->lock with
spin_lock_irqsave().  The callback can be reached from irq_startup()
while setting up a requested IRQ.  That path is not sleepable, but on
PREEMPT_RT a regular spinlock_t becomes a sleeping lock.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the request_threaded_irq() -> __setup_irq() ->
irq_startup() -> sch_irq_unmask() -> sch_irq_mask_unmask() carrier and
used the original spin_lock_irqsave(&sch->lock) edge.  Lockdep reported:

  BUG: sleeping function called from invalid context
  hardirqs last disabled at ... __setup_irq.constprop.0 ... [vuln_msv]
  sch_rt_spin_lock_irqsave+0x1c/0x30 [vuln_msv]
  sch_irq_mask_unmask.constprop.0+0x31/0x70 [vuln_msv]
  __setup_irq.constprop.0+0xd/0x30 [vuln_msv]

Convert the SCH controller lock to raw_spinlock_t.  The same lock is
also used by the GPIO direction and value callbacks, but those critical
sections only update MMIO-backed GPIO registers and do not contain
sleepable operations.  Keeping this register lock non-sleeping is
therefore appropriate for the irqchip callbacks and does not change the
GPIO-side locking contract.

Fixes: 7a81638485c1 ("gpio: sch: Add edge event support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260617154035.1199948-2-runyu.xiao@seu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sch.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -39,7 +39,7 @@
 struct sch_gpio {
 	struct gpio_chip chip;
 	void __iomem *regs;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	unsigned short resume_base;
 
 	/* GPE handling */
@@ -104,9 +104,9 @@ static int sch_gpio_direction_in(struct
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GIO, 1);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 	return 0;
 }
 
@@ -122,9 +122,9 @@ static int sch_gpio_set(struct gpio_chip
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GLV, val);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	return 0;
 }
@@ -135,9 +135,9 @@ static int sch_gpio_direction_out(struct
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GIO, 0);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	/*
 	 * according to the datasheet, writing to the level register has no
@@ -196,14 +196,14 @@ static int sch_irq_type(struct irq_data
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 
 	sch_gpio_reg_set(sch, gpio_num, GTPE, rising);
 	sch_gpio_reg_set(sch, gpio_num, GTNE, falling);
 
 	irq_set_handler_locked(d, handle_edge_irq);
 
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	return 0;
 }
@@ -215,9 +215,9 @@ static void sch_irq_ack(struct irq_data
 	irq_hw_number_t gpio_num = irqd_to_hwirq(d);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GTS, 1);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_irq_mask_unmask(struct gpio_chip *gc, irq_hw_number_t gpio_num, int val)
@@ -225,9 +225,9 @@ static void sch_irq_mask_unmask(struct g
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GGPE, val);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_irq_mask(struct irq_data *d)
@@ -268,12 +268,12 @@ static u32 sch_gpio_gpe_handler(acpi_han
 	int offset;
 	u32 ret;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 
 	core_status = ioread32(sch->regs + CORE_BANK_OFFSET + GTS);
 	resume_status = ioread32(sch->regs + RESUME_BANK_OFFSET + GTS);
 
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	pending = (resume_status << sch->resume_base) | core_status;
 	for_each_set_bit(offset, &pending, sch->chip.ngpio)
@@ -343,7 +343,7 @@ static int sch_gpio_probe(struct platfor
 
 	sch->regs = regs;
 
-	spin_lock_init(&sch->lock);
+	raw_spin_lock_init(&sch->lock);
 	sch->chip = sch_gpio_chip;
 	sch->chip.label = dev_name(dev);
 	sch->chip.parent = dev;


