Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C0914A619;
	Tue, 25 Aug 2026 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666445; cv=none; b=iViOaf1dQdYncNGcEdj+Ggu9OtfkCL5QOCOoyv0XdeepgHfIiCZAyczTkKBb8MKnaGvmIL+I9OfkZ/gZzvbGwFZRGL2/Ga83WSCf8U4f//lr/k1Jf3KUC51Bl5eogHcGdGVrI5wzqND5DX2Bkp+VS+nHr7mBczCkUF7iVZzlicw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666445; c=relaxed/simple;
	bh=iY+7ufKWwO8qV3jZgkY7aDtudBTHgZyPZT/plYZpvYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noMPyB7FUQrq3qxJwN8d1h9NAXU/J9G6xG5HK7o59MeN6NnXMdb/njnAdpY9na501601YLt4vFOO71o7/sN69YL2D+btuPZolOkQYYczAvSimQPclM4GVo2Mk0doCRGCL/OFyVL1Td/mq+QwQbQ5bbbsv0Klx1/JJeQr6IjT8bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnHoFxn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnHoFxn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679C31F00A3A;
	Tue, 25 Aug 2026 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666444;
	bh=ndvCnGS/OG6bIMtcBhK6kKKceq6PthkEMNIzk8P+5z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnHoFxn9dGG1BSnL3HN9XpC5aI4VVq58NdBJMJVm2e2n2aFiJ5atD1lPH42BuK9Hx
	 SlWnqc/w1iIl4bStvsQ09qIoUWZs88jeseauxB3zSCY/sj3c1eAcPUca2WnhkQySLW
	 AzPqmXOnYtsILaJ192QKbvr6svVceSDCdFkh45nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Junjie Cao <junjie.cao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/57] gpio: ml-ioh: use raw_spinlock_t for the register lock
Date: Tue, 25 Aug 2026 15:27:06 +0200
Message-ID: <20260825132543.058453036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit 600411ea1f2443fdf5b1af9b6480f616d7aff9d0 ]

ioh_irq_type() is registered as the irq_chip .irq_set_type callback and
takes chip->spinlock with spin_lock_irqsave().  This callback is reached
from __setup_irq() -> __irq_set_trigger() -> chip->irq_set_type() while
the caller holds desc->lock, a raw_spinlock_t, with hardirqs disabled.
That context is not sleepable, but on PREEMPT_RT a regular spinlock_t is
an rtmutex-backed sleeping lock, so acquiring it there is invalid.
ioh_irq_enable() and ioh_irq_disable() take the same lock from the
.irq_enable/.irq_disable callbacks, which are likewise invoked with
desc->lock held.

Convert the register lock to raw_spinlock_t.  The same lock also
serializes the GPIO direction/value callbacks and the suspend/resume
register save/restore, and those critical sections only perform short
sequences of MMIO register accesses (ioread32()/iowrite32()); the
.irq_set_type callback additionally emits a dev_warn() on an unsupported
type.  None of these are sleepable operations, so keeping this register
lock non-sleeping is appropriate for the irqchip callbacks and does not
change the GPIO-side locking contract.

This is the same fix as commit a02b8950d619 ("gpio: pch: use
raw_spinlock_t for the register lock"); this driver shares the same
structure as gpio-pch.

Fixes: 54be566317b6 ("gpio-ml-ioh: Support interrupt function")
Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260731032747.2987292-1-junjie.cao@intel.com
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-ml-ioh.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -84,7 +84,7 @@ struct ioh_gpio {
 	u32 gpio_use_sel;
 	int ch;
 	int irq_base;
-	spinlock_t spinlock;
+	raw_spinlock_t spinlock;
 };
 
 static const int num_ports[] = {6, 12, 16, 16, 15, 16, 16, 12};
@@ -95,7 +95,7 @@ static void ioh_gpio_set(struct gpio_chi
 	struct ioh_gpio *chip =	gpiochip_get_data(gpio);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	reg_val = ioread32(&chip->reg->regs[chip->ch].po);
 	if (val)
 		reg_val |= (1 << nr);
@@ -103,7 +103,7 @@ static void ioh_gpio_set(struct gpio_chi
 		reg_val &= ~(1 << nr);
 
 	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
 static int ioh_gpio_get(struct gpio_chip *gpio, unsigned nr)
@@ -121,7 +121,7 @@ static int ioh_gpio_direction_output(str
 	u32 reg_val;
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->regs[chip->ch].pm) &
 					((1 << num_ports[chip->ch]) - 1);
 	pm |= (1 << nr);
@@ -134,7 +134,7 @@ static int ioh_gpio_direction_output(str
 		reg_val &= ~(1 << nr);
 	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
 
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -145,12 +145,12 @@ static int ioh_gpio_direction_input(stru
 	u32 pm;
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->regs[chip->ch].pm) &
 				((1 << num_ports[chip->ch]) - 1);
 	pm &= ~(1 << nr);
 	iowrite32(pm, &chip->reg->regs[chip->ch].pm);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -256,7 +256,7 @@ static int ioh_irq_type(struct irq_data
 	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d type=%d\n",
 		__func__, irq, type, ch, im_pos, type);
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -296,7 +296,7 @@ static int ioh_irq_type(struct irq_data
 	ien = ioread32(&chip->reg->regs[chip->ch].ien);
 	iowrite32(ien | BIT(ch), &chip->reg->regs[chip->ch].ien);
 end:
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -326,11 +326,11 @@ static void ioh_irq_disable(struct irq_d
 	unsigned long flags;
 	u32 ien;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	ien = ioread32(&chip->reg->regs[chip->ch].ien);
 	ien &= ~(1 << (d->irq - chip->irq_base));
 	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
 static void ioh_irq_enable(struct irq_data *d)
@@ -340,11 +340,11 @@ static void ioh_irq_enable(struct irq_da
 	unsigned long flags;
 	u32 ien;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	ien = ioread32(&chip->reg->regs[chip->ch].ien);
 	ien |= 1 << (d->irq - chip->irq_base);
 	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
 static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
@@ -441,7 +441,7 @@ static int ioh_gpio_probe(struct pci_dev
 		chip->base = base;
 		chip->reg = chip->base;
 		chip->ch = i;
-		spin_lock_init(&chip->spinlock);
+		raw_spin_lock_init(&chip->spinlock);
 		ioh_gpio_setup(chip, num_ports[i]);
 		ret = gpiochip_add_data(&chip->gpio, chip);
 		if (ret) {
@@ -529,9 +529,9 @@ static int ioh_gpio_suspend(struct pci_d
 	struct ioh_gpio *chip = pci_get_drvdata(pdev);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	ioh_gpio_save_reg_conf(chip);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	ret = pci_save_state(pdev);
 	if (ret) {
@@ -563,11 +563,11 @@ static int ioh_gpio_resume(struct pci_de
 	}
 	pci_restore_state(pdev);
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	iowrite32(0x01, &chip->reg->srst);
 	iowrite32(0x00, &chip->reg->srst);
 	ioh_gpio_restore_reg_conf(chip);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }


