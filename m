Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C731E522;
	Thu, 30 Jan 2025 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247210; cv=none; b=pkIDGK46ITbK9Ph71bBofSJdTT1/5tW6ANHun7GeBxeodG8Ujqg2Q/6+ZAKupdD/n3sIhlbGllwnq8f4yVqEtKo/lbUBhuwk91Zl500mAniCaQVWG6lqXFebK2iD/Ru+BZbk6y6l9Yn0JoA701K+YAyZS7kv2aMEyojeE+DEjlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247210; c=relaxed/simple;
	bh=xpVTSzHEnHnL37B2LCVVBDY2jDGT1sxWjheweOjPrkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzmmgTvfy8S0iPg7smJRPr8BcbzVRQq2R1luPXYD82DsAMkjRIqxEpwWfFOPLC47mIp0oU5sOlM09CTU4GDxqqUOaO5tzx4o8ZFH6CsQm92PwPWzh3pJ1sNswOf1vOQOrTJWIK5G8NRFxnIL4sLOYcilcHShzxqPtoa5jHLDRE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBCAVpMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBCAVpMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6173EC4CED2;
	Thu, 30 Jan 2025 14:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247209;
	bh=xpVTSzHEnHnL37B2LCVVBDY2jDGT1sxWjheweOjPrkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBCAVpMDGuOukm1UFZqmilAxa0eklZF+wn340bNLSlXkpg5vnGtDxH1Od2HnP+nWW
	 yuHYGCA19o/HCe3GJbFjbmt/3WmQqeVEQcNHbfCA9snD6dIqOhcoEmhbPiPxppkbr9
	 4gOpd33nZ1mNWSmSz53zSr+/gwZzas+eCGrO+Kuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/133] irqchip/sunxi-nmi: Add missing SKIP_WAKE flag
Date: Thu, 30 Jan 2025 15:01:48 +0100
Message-ID: <20250130140147.320399762@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



