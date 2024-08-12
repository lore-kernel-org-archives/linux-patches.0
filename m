Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13465187356;
	Mon, 12 Aug 2024 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478849; cv=none; b=EjSVFoDukIsXOpfWRP+XoJ5C0yBwziTu/rgtHHD9/HRpWPIRwdP1CVdLg49uJ1ZmTGSLZCWsw2Q+nXBOv4444PZ9e5+dCkOBSdZslPuLPsRYuX/tVgHFVs3iBdLOYh/wsSSwwsBIepLXDywXkM8Uq0O9D+Byfhd15ffiwUrAN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478849; c=relaxed/simple;
	bh=DXYCKroz83YlonsSrJFo8K3BFMzCtcVQm3nRn27VP60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up5E+t8WJE5J+SzdSsjVVZbZDLYbIUC18N/9gjDZRSJjdDTbSHhTEOGEJgudir1MsfbMuLoRQ4ppeH+fndQ/DmpY3SkiZza0zkv2C0ggOTZwV6mYf8SyJNOWrAYXWNDbFbzxRuO5nXh0T9lYxpHvBs44G4ovbtzr8FfRe+mK2jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAbDuGch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAbDuGch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E4C32782;
	Mon, 12 Aug 2024 16:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478848;
	bh=DXYCKroz83YlonsSrJFo8K3BFMzCtcVQm3nRn27VP60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAbDuGchoiKA3Qg8YLrQJ6P/fVOlzc8GXKhH7ycOBc5H8m3rQUhfkeh+tk74S10YF
	 Vo/lbviabyjZOz76GPJMA0r+v7WsqWeYwP9U/07KdIcoFFtsTOE+4kK2mx2NW28dQV
	 YYJWemVJ41xgnkpbTctFqX+lIZoc2uvph0ttbzT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 054/150] irqchip/meson-gpio: Convert meson_gpio_irq_controller::lock to raw_spinlock_t
Date: Mon, 12 Aug 2024 18:02:15 +0200
Message-ID: <20240812160127.254419738@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

commit f872d4af79fe8c71ae291ce8875b477e1669a6c7 upstream.

This lock is acquired under irq_desc::lock with interrupts disabled.

When PREEMPT_RT is enabled, 'spinlock_t' becomes preemptible, which results
in invalid lock acquire context;

  [ BUG: Invalid wait context ]
  swapper/0/1 is trying to lock:
  ffff0000008fed30 (&ctl->lock){....}-{3:3}, at: meson_gpio_irq_update_bits0
  other info that might help us debug this:
  context-{5:5}
  3 locks held by swapper/0/1:
   #0: ffff0000003cd0f8 (&dev->mutex){....}-{4:4}, at: __driver_attach+0x90c
   #1: ffff000004714650 (&desc->request_mutex){+.+.}-{4:4}, at: __setup_irq0
   #2: ffff0000047144c8 (&irq_desc_lock_class){-.-.}-{2:2}, at: __setup_irq0
  stack backtrace:
  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.9.9-sdkernel #1
  Call trace:
   _raw_spin_lock_irqsave+0x60/0x88
   meson_gpio_irq_update_bits+0x34/0x70
   meson8_gpio_irq_set_type+0x78/0xc4
   meson_gpio_irq_set_type+0x30/0x60
   __irq_set_trigger+0x60/0x180
   __setup_irq+0x30c/0x6e0
   request_threaded_irq+0xec/0x1a4

Fixes: 215f4cc0fb20 ("irqchip/meson: Add support for gpio interrupt controller")
Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240729131850.3015508-1-avkrasnov@salutedevices.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-meson-gpio.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -168,7 +168,7 @@ struct meson_gpio_irq_controller {
 	void __iomem *base;
 	u32 channel_irqs[MAX_NUM_CHANNEL];
 	DECLARE_BITMAP(channel_map, MAX_NUM_CHANNEL);
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 static void meson_gpio_irq_update_bits(struct meson_gpio_irq_controller *ctl,
@@ -177,14 +177,14 @@ static void meson_gpio_irq_update_bits(s
 	unsigned long flags;
 	u32 tmp;
 
-	spin_lock_irqsave(&ctl->lock, flags);
+	raw_spin_lock_irqsave(&ctl->lock, flags);
 
 	tmp = readl_relaxed(ctl->base + reg);
 	tmp &= ~mask;
 	tmp |= val;
 	writel_relaxed(tmp, ctl->base + reg);
 
-	spin_unlock_irqrestore(&ctl->lock, flags);
+	raw_spin_unlock_irqrestore(&ctl->lock, flags);
 }
 
 static void meson_gpio_irq_init_dummy(struct meson_gpio_irq_controller *ctl)
@@ -234,12 +234,12 @@ meson_gpio_irq_request_channel(struct me
 	unsigned long flags;
 	unsigned int idx;
 
-	spin_lock_irqsave(&ctl->lock, flags);
+	raw_spin_lock_irqsave(&ctl->lock, flags);
 
 	/* Find a free channel */
 	idx = find_first_zero_bit(ctl->channel_map, ctl->params->nr_channels);
 	if (idx >= ctl->params->nr_channels) {
-		spin_unlock_irqrestore(&ctl->lock, flags);
+		raw_spin_unlock_irqrestore(&ctl->lock, flags);
 		pr_err("No channel available\n");
 		return -ENOSPC;
 	}
@@ -247,7 +247,7 @@ meson_gpio_irq_request_channel(struct me
 	/* Mark the channel as used */
 	set_bit(idx, ctl->channel_map);
 
-	spin_unlock_irqrestore(&ctl->lock, flags);
+	raw_spin_unlock_irqrestore(&ctl->lock, flags);
 
 	/*
 	 * Setup the mux of the channel to route the signal of the pad
@@ -557,7 +557,7 @@ static int meson_gpio_irq_of_init(struct
 	if (!ctl)
 		return -ENOMEM;
 
-	spin_lock_init(&ctl->lock);
+	raw_spin_lock_init(&ctl->lock);
 
 	ctl->base = of_iomap(node, 0);
 	if (!ctl->base) {


