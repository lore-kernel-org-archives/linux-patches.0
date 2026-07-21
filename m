Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7083B4E87;
	Tue, 21 Jul 2026 21:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670633; cv=none; b=u+GzzgwDIUUG1i4oWXmH2SqEzWr/v7hH3G46lJKUdizvMDRnz4yAQ3kCzHrrtl8arxq9P9mq5Tr8DFMdwNYWqomUUWNHGjZ8XAQXEEZzjjsiWfWshaGVVYCzwkwS39IHY9zuMKSUBp0AaqvAG7FEgHyJG7JQTPhorLKIIQlhujY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670633; c=relaxed/simple;
	bh=nynCW4lnrktfsv7rmP45kuQ0e9dRIAkhd8K6BiZfvfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVG43XRIMSpf5ilXkn0hrq6qUVbzgZRXqOW9Sk67T9Uy4ACRl9LTNX5xG5GqCgUDNBid18V/mKqu31r6WrS0ZuYdkOUiGKz3SBfDLfIFKbB2Wkw+VpTnAFOMDPUm7eF6/oLiVYSvF/NwehOoVnfrmPxGGXv7QtOQmghRggOQjcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir4PB/gT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir4PB/gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852531F000E9;
	Tue, 21 Jul 2026 21:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670632;
	bh=lTmC4MgpOw0/0bpMPonIXP+WiFeEGM4zWOu+Mxxs7WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir4PB/gTuvghVegEhH7Tvw5ZlekZ4Hs+Q2B8jm57dz7bDx+2M5lkmFM2pBM/RJYdR
	 UMUbCHPtisRL4aYQopuIltcGF81cIuWqxXhW+hED9HIJSH8t4d/ZosM67LjUTXVuPv
	 2lOdXIkx/NgmY8WdM81eYh7o0rAWak6rU/Ly7imU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0979/1067] gpio: sch: use raw_spinlock_t in the irq startup path
Date: Tue, 21 Jul 2026 17:26:20 +0200
Message-ID: <20260721152446.453670221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ adjusted context for 6.6's pre-MMIO `iobase` port I/O and void `sch_gpio_set()` (no set_rv `return 0;`) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sch.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -38,7 +38,7 @@
 
 struct sch_gpio {
 	struct gpio_chip chip;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	unsigned short iobase;
 	unsigned short resume_base;
 
@@ -102,9 +102,9 @@ static int sch_gpio_direction_in(struct
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GIO, 1);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 	return 0;
 }
 
@@ -120,9 +120,9 @@ static void sch_gpio_set(struct gpio_chi
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GLV, val);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned int gpio_num,
@@ -131,9 +131,9 @@ static int sch_gpio_direction_out(struct
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GIO, 0);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	/*
 	 * according to the datasheet, writing to the level register has no
@@ -193,14 +193,14 @@ static int sch_irq_type(struct irq_data
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
@@ -212,9 +212,9 @@ static void sch_irq_ack(struct irq_data
 	irq_hw_number_t gpio_num = irqd_to_hwirq(d);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GTS, 1);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_irq_mask_unmask(struct gpio_chip *gc, irq_hw_number_t gpio_num, int val)
@@ -222,9 +222,9 @@ static void sch_irq_mask_unmask(struct g
 	struct sch_gpio *sch = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 	sch_gpio_reg_set(sch, gpio_num, GGPE, val);
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 }
 
 static void sch_irq_mask(struct irq_data *d)
@@ -265,12 +265,12 @@ static u32 sch_gpio_gpe_handler(acpi_han
 	int offset;
 	u32 ret;
 
-	spin_lock_irqsave(&sch->lock, flags);
+	raw_spin_lock_irqsave(&sch->lock, flags);
 
 	core_status = inl(sch->iobase + CORE_BANK_OFFSET + GTS);
 	resume_status = inl(sch->iobase + RESUME_BANK_OFFSET + GTS);
 
-	spin_unlock_irqrestore(&sch->lock, flags);
+	raw_spin_unlock_irqrestore(&sch->lock, flags);
 
 	pending = (resume_status << sch->resume_base) | core_status;
 	for_each_set_bit(offset, &pending, sch->chip.ngpio)
@@ -336,7 +336,7 @@ static int sch_gpio_probe(struct platfor
 				 pdev->name))
 		return -EBUSY;
 
-	spin_lock_init(&sch->lock);
+	raw_spin_lock_init(&sch->lock);
 	sch->iobase = res->start;
 	sch->chip = sch_gpio_chip;
 	sch->chip.label = dev_name(&pdev->dev);


