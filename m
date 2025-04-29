Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675D9253B42;
	Tue, 29 Apr 2025 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950563; cv=none; b=XjEHURqma/fteOTODZNW73q+PllmUpB73z3zzna7GQIafvZi0cTKnZgQigZW8ayfJ3i4EDON6D4D9sdn+lY2YeGzwIp84ydEcglkIMhSr+j83eJl/9+dHXR2suGdP9rkhameu61kkAgoodW5FJyy4lJ0KdXnRwu4VhFnzbjGtIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950563; c=relaxed/simple;
	bh=ZtmkJp0cJDDZ5i4FzO43rccvqSvz3jm1Mxg+MLd9Iic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0/83FzZyvBp/JGirGEOpW/ScPb7S3us0apW8Ji3UyXfmZh0M9qm6RlNyUOizZOEcj8B35PNSon59YkXzkOLoYH8BZs2VaKQXWoCa/ljALoD6SQrfKVNPv6mK3RHlqpe5QtLnjSLsS1uslo0NT7t2LRBPRw96Q5cLuztZ7/WRSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGTta4Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGTta4Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E4EC4CEE3;
	Tue, 29 Apr 2025 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950563;
	bh=ZtmkJp0cJDDZ5i4FzO43rccvqSvz3jm1Mxg+MLd9Iic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGTta4CrhEk36IqIxsBa2TPeCaylu67zCoKJPv5whxzT71GG++YkvZpqU8AVatbjE
	 Zi7LajM3lqhk9MRR/H8v7ahaP04oCextVbmMldAyqi4l8+fD4nAP5NuJv1EBEfsIr2
	 Bb/EwYr8HuJ2jtFvVCDhUiK0JLShegx374v3HPOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.6 095/204] misc: microchip: pci1xxxx: Fix Kernel panic during IRQ handler registration
Date: Tue, 29 Apr 2025 18:43:03 +0200
Message-ID: <20250429161103.324495041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Rengarajan S <rengarajan.s@microchip.com>

commit 18eb77c75ed01439f96ae5c0f33461eb5134b907 upstream.

Resolve kernel panic while accessing IRQ handler associated with the
generated IRQ. This is done by acquiring the spinlock and storing the
current interrupt state before handling the interrupt request using
generic_handle_irq.

A previous fix patch was submitted where 'generic_handle_irq' was
replaced with 'handle_nested_irq'. However, this change also causes
the kernel panic where after determining which GPIO triggered the
interrupt and attempting to call handle_nested_irq with the mapped
IRQ number, leads to a failure in locating the registered handler.

Fixes: 194f9f94a516 ("misc: microchip: pci1xxxx: Resolve kernel panic during GPIO IRQ handling")
Cc: stable <stable@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20250313170856.20868-2-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
@@ -37,6 +37,7 @@
 struct pci1xxxx_gpio {
 	struct auxiliary_device *aux_dev;
 	void __iomem *reg_base;
+	raw_spinlock_t wa_lock;
 	struct gpio_chip gpio;
 	spinlock_t lock;
 	int irq_base;
@@ -254,6 +255,7 @@ static irqreturn_t pci1xxxx_gpio_irq_han
 	struct pci1xxxx_gpio *priv = dev_id;
 	struct gpio_chip *gc =  &priv->gpio;
 	unsigned long int_status = 0;
+	unsigned long wa_flags;
 	unsigned long flags;
 	u8 pincount;
 	int bit;
@@ -277,7 +279,9 @@ static irqreturn_t pci1xxxx_gpio_irq_han
 			writel(BIT(bit), priv->reg_base + INTR_STATUS_OFFSET(gpiobank));
 			spin_unlock_irqrestore(&priv->lock, flags);
 			irq = irq_find_mapping(gc->irq.domain, (bit + (gpiobank * 32)));
-			handle_nested_irq(irq);
+			raw_spin_lock_irqsave(&priv->wa_lock, wa_flags);
+			generic_handle_irq(irq);
+			raw_spin_unlock_irqrestore(&priv->wa_lock, wa_flags);
 		}
 	}
 	spin_lock_irqsave(&priv->lock, flags);


