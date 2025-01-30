Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD461E522;
	Thu, 30 Jan 2025 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247288; cv=none; b=ZaHOXaMO+shCRGx3b7IM5kpeq83VxaZ3x7QcWbR9p0iFs0Z5QQba40JiHfb+AuEFT21MFHFGzwc9pBH4Y3Wxic7gUu/EMURs/m7mGRepNea3PQ4hCt6J3Xd7ptAKEJiNO45sTN7RdDWpqo4qW6vumUOUcPa/z1UIROse0NBReMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247288; c=relaxed/simple;
	bh=Wjh1F6PIxS1YlxTaQFcT3HQ/JJZUT1dpvgSC1d1lUI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUS2oR/XMYFsF6eAwYLL/3dmzw2v48wl7b/AQTa6o6gf05Wt6R7OS2eeYwEFJBymGNzrNKamOlcw5ZijlM3Vn2din2dCAcuf+NSw0gMCTgt5m0KXlxFIj7YigmssfuLGf2alMZIMYOWMeNO2ZVUj6t/uxYMEdxpV8JlWAkzOnCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+BXskHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+BXskHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294ECC4CED2;
	Thu, 30 Jan 2025 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247288;
	bh=Wjh1F6PIxS1YlxTaQFcT3HQ/JJZUT1dpvgSC1d1lUI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+BXskHwrtHEspucMo+lEWr8qbMwnJ101NN7VN33vMULxiXUwsvNwZ71A7cHapGCE
	 vJ0Jvsx3ya/JMPkbdWlVmzhAMC8KAu5WTT9AsSJt5CkW2ba+it8BNYEjMhGtQ/DNF3
	 /+4r/2Lh1++KoDvrNYND1/cO0KIXqp9OsbQBnwTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/24] irqchip/sunxi-nmi: Add missing SKIP_WAKE flag
Date: Thu, 30 Jan 2025 15:01:57 +0100
Message-ID: <20250130140127.513721537@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 21d49791f8552..83c7417611fa5 100644
--- a/drivers/irqchip/irq-sunxi-nmi.c
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -187,7 +187,8 @@ static int __init sunxi_sc_nmi_irq_init(struct device_node *node,
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



