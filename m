Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB56D1DDE9;
	Thu, 30 Jan 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246519; cv=none; b=Ilq56/FXXo5OAhBe8sPKa7icFb1CxSjmGZXd7PN9NjLaDGkk9KIl4iHZEZ+FYh5pTZQtguB4mhMcWVZtGdZGuK7kDczF5UJMPMXxzlyij+6YNa96LEP7aTYDPnBojbg4nBSan45GWVFjB/7zHz9/Bc1f33Qs/2hJ9ize5cUYhSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246519; c=relaxed/simple;
	bh=RTOZUo+0rXsvIHJsE4AxarJ2Ge0ygROUoJoyH1oF9wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psd4A+Zsy07EXah81WCuPq8wj7mQOrTrcvzLf27CW1Fvw1rNMxNXirro8PSSaxUfVsFGjJmYH3vpQxhe7+ohYYlIoSZ1/dUipIuZIuaA/f5DIRpHTBU5lFuYuTEfDCrX+PBpaMjwPU10PsMo2bdGk7EruFr3kViwZ3OjDvEa+ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7eviYxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7eviYxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364C9C4CED2;
	Thu, 30 Jan 2025 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246519;
	bh=RTOZUo+0rXsvIHJsE4AxarJ2Ge0ygROUoJoyH1oF9wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7eviYxV0/C32V+N6/iEDkrZwMufboN5YvoTZoxcd5+n1CPoMuPpCFMiPHcb9QYL5
	 9mxQZKAfW+UHxSIt4/241hpiV6P+tb4DsqEpx7JTTbfp4msp+79AcGiI0X5Td/wDjA
	 8bk2H5nyPpa3aYUngKxUxun5Wq+pB9Nc3o2vXCfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/43] irqchip/sunxi-nmi: Add missing SKIP_WAKE flag
Date: Thu, 30 Jan 2025 14:59:14 +0100
Message-ID: <20250130133459.196036268@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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
index e760b1278143d..262b625c30c10 100644
--- a/drivers/irqchip/irq-sunxi-nmi.c
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -186,7 +186,8 @@ static int __init sunxi_sc_nmi_irq_init(struct device_node *node,
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



