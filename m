Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8DB1E9907;
	Thu, 30 Jan 2025 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246859; cv=none; b=pZ3cX53YAFTVTap1aAWy545kj0BncX32oJDR5+cp3PA8VlVkxA7aE7pV0gyCwEARmN5KGA/GkABIZwAj6bFPBEcE2idkzRSKBqcpeIDETjL40bdAmTWtAGfcE47bbetJaIXNUfkjXU/A+Oir5itOHDgs5/NLmPrRbKsUZZOH4/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246859; c=relaxed/simple;
	bh=0krmCgXSr/I7V7J4dHZzasswKt+865EscLdFecDv0ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qik5UPvSCriIHgOqOt/WMwaSbHhhTrRLShj4STXfdiDdk1UKtaaciuV4JK/ZGHkbcXf1fpmTkKabItiKzg9En/JTaQz05DzMIIJtqTKhpust2W34/kUPqJ+nvvU8HvFjKUKgQgvlQQ1XjN5KIT7rPEjRCP0QCyhmNqqySqr1MxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhkfbC8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhkfbC8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C702BC4CED2;
	Thu, 30 Jan 2025 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246859;
	bh=0krmCgXSr/I7V7J4dHZzasswKt+865EscLdFecDv0ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhkfbC8shE99fxFd6oYUGCVVcR+04Mr/asNW64m5lMlOZ0wCYBVcMoHrKLx2zkLBh
	 r7X/6Gchz9Y4uTW8/PZ3xGpTf+95pZpFWPqMMxv1OWoybRAUhaQ+ZFFCrq8YZiPNgn
	 rLEwWZzobu+WiE2p6F0ZBg9sZflo1nRx0WbPdrFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 77/91] irqchip/sunxi-nmi: Add missing SKIP_WAKE flag
Date: Thu, 30 Jan 2025 15:01:36 +0100
Message-ID: <20250130140136.778666019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philippe Simons <simons.philippe@gmail.com>

[ Upstream commit 3a748d483d80f066ca4b26abe45cdc0c367d13e9 ]

Some boards with Allwinner SoCs connect the PMIC's IRQ pin to the SoC's NMI
pin instead of a normal GPIO. Since the power key is connected to the PMIC,
and people expect to wake up a suspended system via this key, the NMI IRQ
controller must stay alive when the system goes into suspend.

Add the SKIP_WAKE flag to prevent the sunxi NMI controller from going to
sleep, so that the power key can wake up those systems.

[ tglx: Fixed up coding style ]

Signed-off-by: Philippe Simons <simons.philippe@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250112123402.388520-1-simons.philippe@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sunxi-nmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sunxi-nmi.c b/drivers/irqchip/irq-sunxi-nmi.c
index a412b5d5d0fac..a2aadfdc47728 100644
--- a/drivers/irqchip/irq-sunxi-nmi.c
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -200,7 +200,8 @@ static int __init sunxi_sc_nmi_irq_init(struct device_node *node,
 	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit;
 	gc->chip_types[0].chip.irq_eoi		= irq_gc_ack_set_bit;
 	gc->chip_types[0].chip.irq_set_type	= sunxi_sc_nmi_set_type;
-	gc->chip_types[0].chip.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED;
+	gc->chip_types[0].chip.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED |
+						  IRQCHIP_SKIP_SET_WAKE;
 	gc->chip_types[0].regs.ack		= reg_offs->pend;
 	gc->chip_types[0].regs.mask		= reg_offs->enable;
 	gc->chip_types[0].regs.type		= reg_offs->ctrl;
-- 
2.39.5



