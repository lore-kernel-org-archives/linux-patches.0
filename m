Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4ED3F3265;
	Mon, 17 Aug 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976253; cv=none; b=YW5B1rzXYID0aJlKtPEYyBqo4YZVIyoCTiZT6E/0gtg5ebbuyFLmlGDQ7zGEJ8Pch6kdNia/Sm2LNAlcqLJ393V1uWn2X+tFwsTrIIUn8whidVyJFldc9uLT69y1Hrqu4fP6tbo+UpdjjqYaY0T+d7cIMhXpsyDk8M06D8hZ3H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976253; c=relaxed/simple;
	bh=EK5RtgR9fdOdYAs0/qlJ8kZEpr90f1puvpa2zBpvZ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jf4XETxBZt/NuFcZCbx23LzEPBgG0ALxhGDrLxHIuSqjbgEa5oSBIVm9kwyn0qyp0yUMwDSML8YnWwsTJEF4l3iAjkWOdRndnjm77N0GZbUtFYC0xnS+VGGvq7CmPXL4G/QOSZ3RTEBB8uMLuhQgqzAuNUdtTbufFCCGh2agmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjsPbJNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjsPbJNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41A31F000E9;
	Mon, 17 Aug 2026 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976252;
	bh=iciMSqZzeMUxCh58NQqGZgyrhKd6SMM7eM3U91MR9HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjsPbJNGRGLLBp3sIBvKWd+6UOdZuPSXF0f5Q6hriV34t7/Jp9BE6ZhYL+qQjL45W
	 lazLTkrb1c0SH4336uVvPkywdpmpzADTKCswguJTybIbxbcJZEfGwvWae/5o0GCiTU
	 //kL6CrG5Pj5NZKh80g7ooRbOA0oJ21J3w4pBEpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/389] gpio: pch: use raw_spinlock_t for the register lock
Date: Mon, 17 Aug 2026 15:32:27 +0200
Message-ID: <20260817132551.033304146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

[ Upstream commit a02b8950d619123da64f69b70fe1dadef217dfe4 ]

pch_irq_type() is registered as the irq_chip .irq_set_type callback and
takes chip->spinlock with spin_lock_irqsave().  This callback is reached
from __setup_irq() -> __irq_set_trigger() -> chip->irq_set_type() while
the caller holds desc->lock, a raw_spinlock_t, with hardirqs disabled.
That context is not sleepable, but on PREEMPT_RT a regular spinlock_t is
an rtmutex-backed sleeping lock, so acquiring it there is invalid.

This was confirmed on a PREEMPT_RT kernel with lockdep
(PROVE_RAW_LOCK_NESTING and DEBUG_ATOMIC_SLEEP).  A grounded PoC mirrored
pch_irq_type()'s locking and drove it through the real genirq carrier
irq_set_irq_type() -> __irq_set_trigger() -> chip->irq_set_type(), i.e.
the same __irq_set_trigger() edge that __setup_irq() takes for a
requested IRQ.  With the original spin_lock_irqsave() edge lockdep
reported an invalid wait context, immediately followed by:

  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 95, name: insmod
  hardirqs last disabled at (3784): _raw_spin_lock_irqsave+0x4f/0x60
   rt_spin_lock+0x3a/0x1c0
   repro_irq_set_type+0x64/0xa0 [pch_repro]
   __irq_set_trigger+0x69/0x140
   irq_set_irq_type+0x78/0xd0

Switching the mirrored lock to raw_spinlock_t made both splats go away.

Convert the register lock to raw_spinlock_t.  The same lock also
serializes the GPIO direction/value callbacks and the suspend/resume
register save/restore, but all of those critical sections only perform
MMIO register accesses (ioread32()/iowrite32()) and
irq_set_handler_locked(); none of them contain sleepable operations.
Keeping this register lock non-sleeping is therefore appropriate for the
irqchip callbacks and does not change the GPIO-side locking contract.

This is the same class of issue and fix as recently addressed for other
GPIO controllers, e.g. commit 286533cb14a3 ("gpio: sch: use raw_spinlock_t
in the irq startup path") and commit 90f0109019e6 ("gpio: eic-sprd: use
raw_spinlock_t in the irq startup path").

Fixes: 38eb18a6f92d ("gpio-pch: Support interrupt function")
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260723014129.1129730-1-junjie.cao@intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
(cherry picked from commit a02b8950d619123da64f69b70fe1dadef217dfe4)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pch.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index a552df298a974..af4b3b7f3033d 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -92,7 +92,7 @@ struct pch_gpio {
 	struct pch_gpio_reg_data pch_gpio_reg;
 	int irq_base;
 	enum pch_type_t ioh;
-	spinlock_t spinlock;
+	raw_spinlock_t spinlock;
 };
 
 static void pch_gpio_set(struct gpio_chip *gpio, unsigned int nr, int val)
@@ -101,7 +101,7 @@ static void pch_gpio_set(struct gpio_chip *gpio, unsigned int nr, int val)
 	struct pch_gpio *chip =	gpiochip_get_data(gpio);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	reg_val = ioread32(&chip->reg->po);
 	if (val)
 		reg_val |= BIT(nr);
@@ -109,7 +109,7 @@ static void pch_gpio_set(struct gpio_chip *gpio, unsigned int nr, int val)
 		reg_val &= ~BIT(nr);
 
 	iowrite32(reg_val, &chip->reg->po);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
 static int pch_gpio_get(struct gpio_chip *gpio, unsigned int nr)
@@ -127,7 +127,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned int nr,
 	u32 reg_val;
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 
 	reg_val = ioread32(&chip->reg->po);
 	if (val)
@@ -141,7 +141,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned int nr,
 	pm |= BIT(nr);
 	iowrite32(pm, &chip->reg->pm);
 
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -152,12 +152,12 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned int nr)
 	u32 pm;
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	pm = ioread32(&chip->reg->pm);
 	pm &= BIT(gpio_pins[chip->ioh]) - 1;
 	pm &= ~BIT(nr);
 	iowrite32(pm, &chip->reg->pm);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -259,7 +259,7 @@ static int pch_irq_type(struct irq_data *d, unsigned int type)
 		return 0;
 	}
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 
 	/* Set interrupt mode */
 	im = ioread32(im_reg) & ~(PCH_IM_MASK << (im_pos * 4));
@@ -271,7 +271,7 @@ static int pch_irq_type(struct irq_data *d, unsigned int type)
 	else if (type & IRQ_TYPE_EDGE_BOTH)
 		irq_set_handler_locked(d, handle_edge_irq);
 
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 	return 0;
 }
 
@@ -378,7 +378,7 @@ static int pch_gpio_probe(struct pci_dev *pdev,
 
 	chip->reg = chip->base;
 	pci_set_drvdata(pdev, chip);
-	spin_lock_init(&chip->spinlock);
+	raw_spin_lock_init(&chip->spinlock);
 	pch_gpio_setup(chip);
 
 	ret = devm_gpiochip_add_data(&pdev->dev, &chip->gpio, chip);
@@ -415,9 +415,9 @@ static int __maybe_unused pch_gpio_suspend(struct device *dev)
 	struct pch_gpio *chip = dev_get_drvdata(dev);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	pch_gpio_save_reg_conf(chip);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
@@ -427,11 +427,11 @@ static int __maybe_unused pch_gpio_resume(struct device *dev)
 	struct pch_gpio *chip = dev_get_drvdata(dev);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&chip->spinlock, flags);
 	iowrite32(0x01, &chip->reg->reset);
 	iowrite32(0x00, &chip->reg->reset);
 	pch_gpio_restore_reg_conf(chip);
-	spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
-- 
2.53.0



