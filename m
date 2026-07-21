Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F846EF9C;
	Tue, 21 Jul 2026 20:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664338; cv=none; b=rJR5g+QK5aUz+WwlyDBMf2sT2r8+QcE4ZYPGyMC30wJ8NeUnvB84W0PWsMkw0BNVP5Rgd7hSiejUmZTgwOWQcS5vp8G2baNtK1J2bU0OcS6FOeYB4tQWv3RPkm15D1ICuRWUrgUz5GmdEL7IUITkrW4z8Zs8UOLhOdQHJDKqFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664338; c=relaxed/simple;
	bh=mmAE+NJXGe1PSbCeVY4+YfO9IC7zmD9RJlc+3gmj+/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP5htvuJ/s6qlx+0QdeFudenGEBLaLN2OdOu/0pQ3M/nt2pICfI8dAxF2KDZrWT718hgm9XNUSz9ieyAtUGecs4gSbeYXCbpWgATk3vGOlfvz/qn1dwJvs3ZuFkMuIJnMdSQHyZtecJAfCMjSIQxltFQmzMI8ZIaRPKg401BIdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJXMZith; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJXMZith"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278FD1F000E9;
	Tue, 21 Jul 2026 20:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664336;
	bh=4mS7Iw0dikl/HjBHwAOCWdqoTz4kXKCX3wPEaG7Z5gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJXMZithU2ODKPsZv5w/KOPk3ooOd7USLMuKzLNHeJAzy7msys/LM7rU2FZGTia/3
	 203wGNqn/Ita7LV4dur8duIfUN7lTk9TFtmi7W+3NjJY/07TT7lEMXKUYZd81Og89z
	 DaWgW7iQHATJDjk9Nxc2P5TfI/dzxP6IVbHVYw7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1163/1276] gpio: sch: use raw_spinlock_t in the irq startup path
Date: Tue, 21 Jul 2026 17:26:46 +0200
Message-ID: <20260721152512.045462235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 286533cb14a3c8a8bd39ff64ea2fc8e1aa0f638b ]

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
[ dropped the `return 0;` and kept sch_gpio_set()'s void signature since 6.12 lacks the GPIO setter-return-value conversion ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 
@@ -122,9 +122,9 @@ static void sch_gpio_set(struct gpio_chi
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GLV, val);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned int gpio_num,
@@ -133,9 +133,9 @@ static int sch_gpio_direction_out(struct
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GIO, 0);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	/*
 	 * according to the datasheet, writing to the level register has no
@@ -195,14 +195,14 @@ static int sch_irq_type(struct irq_data
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
@@ -214,9 +214,9 @@ static void sch_irq_ack(struct irq_data
 	irq_hw_number_t gpio_num = irqd_to_hwirq(d);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GTS, 1);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_irq_mask_unmask(struct gpio_chip *gc, irq_hw_number_t gpio_num, int val)
@@ -224,9 +224,9 @@ static void sch_irq_mask_unmask(struct g
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GGPE, val);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_irq_mask(struct irq_data *d)
@@ -267,12 +267,12 @@ static u32 sch_gpio_gpe_handler(acpi_han
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
@@ -342,7 +342,7 @@ static int sch_gpio_probe(struct platfor
 
 	sch->regs = regs;
 
-	spin_lock_init(&sch->lock);
+	raw_spin_lock_init(&sch->lock);
 	sch->chip = sch_gpio_chip;
 	sch->chip.label = dev_name(dev);
 	sch->chip.parent = dev;


