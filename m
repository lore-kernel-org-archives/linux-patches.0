Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23026375F81;
	Tue, 21 Jul 2026 22:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673215; cv=none; b=Qq9eY5W9mxEGNseW6JkXM5nkDYyWGQDdVYkbz+vFTuf/MfmljyUs/JKKA0Y5jOwet1szxvzkBtdJUaDabJa7M40KZJsXyIes0gHTvKWZBBPZfSxxgh0J5C7XEme5MhlCj/nsIAIszHHwXRSyWjt0EsMdkUA8+Vd8NMEEMvpS39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673215; c=relaxed/simple;
	bh=DtlQ571hUWz9YISBn4MUI2TkMy7Or6tWR1da6VEjyNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dwah1JDuExGq6Z5D3WZKdMTHQEoIeXoFteYreX4oSQml0SOIuOIelnQFiWUzAZh/BVfDXZoIQ+7DAnmn8aKaAqE8fJWwhCkozrQAgfgaPIj+0gEwqfQ6Mi1EuBdcBpw04U4VFwNFltaU51s8/YwJdtXutolwo9dnvjrcnG+G03s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agWU6wQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agWU6wQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D951F000E9;
	Tue, 21 Jul 2026 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673214;
	bh=vcKlhRfzot11+ckssz4qAxjN7K00/wy5cm9Bg737jdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agWU6wQ17fEUpm4Wasnruhh67QNiRYIfEIKLNErZIxT8aL5lDF8oA9n8898m2MM/L
	 hpyU1wlQR0oM5TprqH5OXWk9vdQo2QW8ZS8p6g8pE9pPl6Xexw5tC3E+V6hk1NjQvw
	 XbxWrcFc8qQR8hRWTfzBgA+iW52WB0XVy2QEoOmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 076/699] gpio: eic-sprd: use raw_spinlock_t in the irq startup path
Date: Tue, 21 Jul 2026 17:17:15 +0200
Message-ID: <20260721152357.420305815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 90f0109019e6817eb40a486671b7722d1544ae29 upstream.

sprd_eic_irq_unmask() enables the GPIO IRQ and then updates controller
state through sprd_eic_update(), which takes sprd_eic->lock with
spin_lock_irqsave().  The callback can be reached from irq_startup()
while setting up a requested IRQ.  That path is not sleepable, but on
PREEMPT_RT a regular spinlock_t becomes a sleeping lock.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the request_threaded_irq() -> __setup_irq() ->
irq_startup() -> sprd_eic_irq_unmask() -> sprd_eic_update() carrier and
used the original spin_lock_irqsave(&sprd_eic->lock) edge.  Lockdep
reported:

  BUG: sleeping function called from invalid context
  hardirqs last disabled at ... __setup_irq.constprop.0 ... [vuln_msv]
  sprd_rt_spin_lock_irqsave+0x1c/0x30 [vuln_msv]
  sprd_eic_update.constprop.0+0x48/0x90 [vuln_msv]
  sprd_eic_irq_unmask.constprop.0+0x35/0x50 [vuln_msv]
  __setup_irq.constprop.0+0xd/0x30 [vuln_msv]

Convert the Spreadtrum EIC controller lock to raw_spinlock_t.  The
locked section only serializes MMIO register updates and does not contain
sleepable operations, so keeping it non-sleeping is appropriate for the
irqchip callbacks.

Fixes: 25518e024e3a ("gpio: Add Spreadtrum EIC driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260617154035.1199948-3-runyu.xiao@seu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-eic-sprd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-eic-sprd.c
+++ b/drivers/gpio/gpio-eic-sprd.c
@@ -94,7 +94,7 @@ struct sprd_eic {
 	struct irq_chip intc;
 	void __iomem *base[SPRD_EIC_MAX_BANK];
 	enum sprd_eic_type type;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	int irq;
 };
 
@@ -146,7 +146,7 @@ static void sprd_eic_update(struct gpio_
 	unsigned long flags;
 	u32 tmp;
 
-	spin_lock_irqsave(&sprd_eic->lock, flags);
+	raw_spin_lock_irqsave(&sprd_eic->lock, flags);
 	tmp = readl_relaxed(base + reg);
 
 	if (val)
@@ -155,7 +155,7 @@ static void sprd_eic_update(struct gpio_
 		tmp &= ~BIT(SPRD_EIC_BIT(offset));
 
 	writel_relaxed(tmp, base + reg);
-	spin_unlock_irqrestore(&sprd_eic->lock, flags);
+	raw_spin_unlock_irqrestore(&sprd_eic->lock, flags);
 }
 
 static int sprd_eic_read(struct gpio_chip *chip, unsigned int offset, u16 reg)
@@ -606,7 +606,7 @@ static int sprd_eic_probe(struct platfor
 	if (!sprd_eic)
 		return -ENOMEM;
 
-	spin_lock_init(&sprd_eic->lock);
+	raw_spin_lock_init(&sprd_eic->lock);
 	sprd_eic->type = pdata->type;
 
 	sprd_eic->irq = platform_get_irq(pdev, 0);


