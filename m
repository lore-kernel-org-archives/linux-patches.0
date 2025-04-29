Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DB322A81D;
	Tue, 29 Apr 2025 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946105; cv=none; b=FO28i30H4yFXDCNSb8ImXAwleL1IJwNqo0gRVeuofRJL2KEAgOTywZoZbOYp9jo7QDurAyFSjWHtAqJc2Ztxb/SK7LCC72I7IgJ5uVk7BDEfQGxkE9rspU+VsUJGFQ9zr+bS9m71n7uP/spsoa/Vt87ORZ/Vu+MJDsFYaJ+eLco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946105; c=relaxed/simple;
	bh=Wa1yKznHluu1jvYERo5wPpc8yMalO3xMHiFm15CGAQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOxMIVyFlirqJyRQJk69bWOJrAQfO7ZSgXDPWPRs0LTz4QofhkAZSkbZ4sIMZ30ClviRQRzAFMZ7QvZKTphFJ7ZAMXcw3C0YCJINmMl4UScOPBJQJGekkoZEPNgzIHKbGJa48yvCPNXExwDTpXGuoCCvmMJXy8D3TEqAGS4bb3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/QoXLy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/QoXLy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D203AC4CEE3;
	Tue, 29 Apr 2025 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946105;
	bh=Wa1yKznHluu1jvYERo5wPpc8yMalO3xMHiFm15CGAQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/QoXLy63G4k2J4dShD2UyNRtu46Wp2cpoYQmEgVP8a6c+k4Q6HTD9rFmMUvVdTtD
	 JU0XDDPpCYueU7DsfDcoF03zFSGfILR65IWQ8aWbWJH1fMBAMMPi0SeI79IoPNoFgy
	 L93REctlKzmtTiKOhiuyf3i0Ac/AjvzLVzy59O+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.14 149/311] misc: microchip: pci1xxxx: Fix Kernel panic during IRQ handler registration
Date: Tue, 29 Apr 2025 18:39:46 +0200
Message-ID: <20250429161127.143442151@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,6 +258,7 @@ static irqreturn_t pci1xxxx_gpio_irq_han
 	struct pci1xxxx_gpio *priv = dev_id;
 	struct gpio_chip *gc =  &priv->gpio;
 	unsigned long int_status = 0;
+	unsigned long wa_flags;
 	unsigned long flags;
 	u8 pincount;
 	int bit;
@@ -280,7 +282,9 @@ static irqreturn_t pci1xxxx_gpio_irq_han
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


