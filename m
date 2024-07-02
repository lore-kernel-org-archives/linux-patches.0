Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D361C0DE3;
	Tue,  2 Jul 2024 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941662; cv=none; b=i4/rPSfdSi5QrwJk8TfF98kbsrJ0nYXKsbe1UKvfOWxU7ixoLZvDkoEbNYZEL7cjmeNE+/GTOt2bhs3Vf/BFwv0eNnwTebGbeOd6gFRE2ZbJWZoA8YxcHhQtAiV9Tdxjm74fUDxPVOvxi7/oVN1Zv4twtCE1py6YcH0gLEcH3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941662; c=relaxed/simple;
	bh=dFIxSSN8TO6d6LAfmSucnIXK+BHKSdVv6RBOtWX6bQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=es7e+PkS+rnUAZv2wK7u/mlz17DkhuLXFex2MImtZyKR/NFNKmTC4OsBKwPputZ2CMbAPmvY9flUhY2mDmrXt/a1SWOendlYmy8nSShfBL/ldk9mDx9vJBIJtVqrEKiHiy3jp2hgRaHi0HRbOnS+33if5TrDLhkwrp1RoB2KIb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OE6nG6P3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OE6nG6P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C0EC4AF07;
	Tue,  2 Jul 2024 17:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941662;
	bh=dFIxSSN8TO6d6LAfmSucnIXK+BHKSdVv6RBOtWX6bQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OE6nG6P3iwQBUAF2UI5/P2igIvRE7ccXVo/SYuNSEKBWfu1mkw+cbHOUhApd6dyvn
	 ZTuANjjCIPTJ0o6TRZIULkgmje1WLG4aBAZeJf6YoTLBJTpGCyhD2A96KH5YqEZWQK
	 aZi4FrVehkw2E3UbU3JR9cC1Ig0M86zzk+pmYiLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianli Xiong <xiongtianli@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 099/128] irqchip/loongson-liointc: Set different ISRs for different cores
Date: Tue,  2 Jul 2024 19:05:00 +0200
Message-ID: <20240702170229.966256517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit a9c3ee5d0fdb069b54902300df6ac822027f3b0a upstream.

The liointc hardware provides separate Interrupt Status Registers (ISR) for
each core. The current code uses always the ISR of core #0, which works
during boot because by default all interrupts are routed to core #0.

When the interrupt routing changes in the firmware configuration then this
causes interrupts to be lost because they are not configured in the
corresponding core.

Use the core index to access the correct ISR instead of a hardcoded 0.

[ tglx: Massaged changelog ]

Fixes: 0858ed035a85 ("irqchip/loongson-liointc: Add ACPI init support")
Co-developed-by: Tianli Xiong <xiongtianli@loongson.cn>
Signed-off-by: Tianli Xiong <xiongtianli@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240622043338.1566945-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-liointc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -28,7 +28,7 @@
 
 #define LIOINTC_INTC_CHIP_START	0x20
 
-#define LIOINTC_REG_INTC_STATUS	(LIOINTC_INTC_CHIP_START + 0x20)
+#define LIOINTC_REG_INTC_STATUS(core)	(LIOINTC_INTC_CHIP_START + 0x20 + (core) * 8)
 #define LIOINTC_REG_INTC_EN_STATUS	(LIOINTC_INTC_CHIP_START + 0x04)
 #define LIOINTC_REG_INTC_ENABLE	(LIOINTC_INTC_CHIP_START + 0x08)
 #define LIOINTC_REG_INTC_DISABLE	(LIOINTC_INTC_CHIP_START + 0x0c)
@@ -196,7 +196,7 @@ static int liointc_init(phys_addr_t addr
 		goto out_free_priv;
 
 	for (i = 0; i < LIOINTC_NUM_CORES; i++)
-		priv->core_isr[i] = base + LIOINTC_REG_INTC_STATUS;
+		priv->core_isr[i] = base + LIOINTC_REG_INTC_STATUS(i);
 
 	for (i = 0; i < LIOINTC_NUM_PARENT; i++)
 		priv->handler[i].parent_int_map = parent_int_map[i];


