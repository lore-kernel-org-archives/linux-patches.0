Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0FE8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1B7C433C7;
	Sun, 16 Jul 2023 20:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539193;
	bh=BqRPCCjNx5edPFKIYGK+vZcrn/MO1EpQ+6LPMAEEsGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPOhdzYLlwt0b/oQt48V/xQBtJPZoVFhw49iZaGH0O5RVPn++25UU4GSNfKN9XPOr
	 cheMRgYtbSa3aS18QhjC79unCLrzNDzAj1dM93tFFdVikpjcL9ZMKMwNvyVYeAciON
	 XHWnibG1wyRXDm7mQKvPDhShYc/0osySFIpySZyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@kernel.org>,
	Chong Qiao <qiaochong@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.4 719/800] irqchip/loongson-liointc: Fix IRQ trigger polarity
Date: Sun, 16 Jul 2023 21:49:32 +0200
Message-ID: <20230716195005.819777587@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianmin Lv <lvjianmin@loongson.cn>

commit 1d7471b4e0ebba5a4bf9db4ade43619e8f2d333d upstream.

For the INT_POLARITY register of Loongson-2K series IRQ
controller, '0' indicates high level or rising edge triggered,
'1' indicates low level or falling edge triggered, and we
can find out the information from the Loongson 2K1000LA User
Manual v1.0, Table 9-2, Section 9.3 (中断寄存器描述 / Description
of the Interrupt Registers).

For Loongson-3 CPU series, setting INT_POLARITY register is not
supported and writting it has no effect.

So trigger polarity setting shouled be fixed for Loongson-2K CPU
series.

Fixes: 17343d0b4039 ("irqchip/loongson-liointc: Support to set IRQ type for ACPI path")
Cc: stable@vger.kernel.org
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Co-developed-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230614115936.5950-4-lvjianmin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-liointc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-liointc.c b/drivers/irqchip/irq-loongson-liointc.c
index 8d00a9ad5b00..5dd9db8f8fa8 100644
--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -32,6 +32,10 @@
 #define LIOINTC_REG_INTC_EN_STATUS	(LIOINTC_INTC_CHIP_START + 0x04)
 #define LIOINTC_REG_INTC_ENABLE	(LIOINTC_INTC_CHIP_START + 0x08)
 #define LIOINTC_REG_INTC_DISABLE	(LIOINTC_INTC_CHIP_START + 0x0c)
+/*
+ * LIOINTC_REG_INTC_POL register is only valid for Loongson-2K series, and
+ * Loongson-3 series behave as noops.
+ */
 #define LIOINTC_REG_INTC_POL	(LIOINTC_INTC_CHIP_START + 0x10)
 #define LIOINTC_REG_INTC_EDGE	(LIOINTC_INTC_CHIP_START + 0x14)
 
@@ -116,19 +120,19 @@ static int liointc_set_type(struct irq_data *data, unsigned int type)
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
 		liointc_set_bit(gc, LIOINTC_REG_INTC_EDGE, mask, false);
-		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, true);
+		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, false);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		liointc_set_bit(gc, LIOINTC_REG_INTC_EDGE, mask, false);
-		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, false);
+		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, true);
 		break;
 	case IRQ_TYPE_EDGE_RISING:
 		liointc_set_bit(gc, LIOINTC_REG_INTC_EDGE, mask, true);
-		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, true);
+		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, false);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		liointc_set_bit(gc, LIOINTC_REG_INTC_EDGE, mask, true);
-		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, false);
+		liointc_set_bit(gc, LIOINTC_REG_INTC_POL, mask, true);
 		break;
 	default:
 		irq_gc_unlock_irqrestore(gc, flags);
-- 
2.41.0



