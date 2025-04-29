Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD9C224222;
	Tue, 29 Apr 2025 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949847; cv=none; b=uq4GleRJwYXPsvjIbUkzi9xXjjJPJacTCo67/Ykq5KhGhSH/P7GZtRMJkqdwB1NwVaCXSxVdT4XsX5BioNEqZ8BuL++6H48tqBQM9XA7reIOYsIQHcjg7l3srRzRErljw60Mf+xlh4VDxX4SBnpqNd4D3O3djWMJh78oGLbWFXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949847; c=relaxed/simple;
	bh=QCIW8QTCoAPJDg9CjD9HeYmvuNbb+sRCLyM1TgtF3HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZMGMArDFh/Jt3kzF9SGoUChIfkntLz27pHieTICC4wIucvIpo2yNo+CsYiZ1qlHMykffQAqmu440HcMj8oJ1wraOQj1E+t/g0TnoKjLXnO44MCGw9Qp0u3H1PqDRijoOFF+RhRR0svWAiGk/4kqzsaBjdxGlYJc93emXG9Lfxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYmlqQPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYmlqQPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A8C4CEE3;
	Tue, 29 Apr 2025 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949846;
	bh=QCIW8QTCoAPJDg9CjD9HeYmvuNbb+sRCLyM1TgtF3HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYmlqQPLoC94RN7RDE94MBlCsphqcS8zd8BmhHeMzJv9AbtX2ydUncEZjZW7jpjyp
	 9hdDTdF/xxOlHAiN967U47j0B5AH6meMM7pTSY4kz0sUS1uj3RH1StqM0zVOkz0zpx
	 peX8/Vca8PYns/NMSrXiEHEVqg7eI2fBWIdpFfcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.1 076/167] misc: microchip: pci1xxxx: Fix Kernel panic during IRQ handler registration
Date: Tue, 29 Apr 2025 18:43:04 +0200
Message-ID: <20250429161054.837446053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -250,6 +251,7 @@ static irqreturn_t pci1xxxx_gpio_irq_han
 	struct pci1xxxx_gpio *priv = dev_id;
 	struct gpio_chip *gc =  &priv->gpio;
 	unsigned long int_status = 0;
+	unsigned long wa_flags;
 	unsigned long flags;
 	u8 pincount;
 	int bit;
@@ -273,7 +275,9 @@ static irqreturn_t pci1xxxx_gpio_irq_han
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


