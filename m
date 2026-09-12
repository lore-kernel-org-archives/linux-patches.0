Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A316241D648;
	Sat, 12 Sep 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204701; cv=none; b=l8mjR2SGrRV0blA4d45dwnFoGD4XjFF+fRUDN/Lpao+MWOjZc/n6NDlKQCzYdKjg9s+WaQfuFCQ6RWpjeEFrFWtRFe1ZIm+QCgZW3xwxQD4KrWXFMa1Kq/n00BZLnqYOhj4uceVneOxM9hOwSa0Vko6UcoSiCnR6kw/VZNzZJtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204701; c=relaxed/simple;
	bh=LCjNImAXkDbgeAoZay1TYYGj8rAcbS2JyPZHcYtQOYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD200lb9A6IcLKTwARb8C/4r+hBvo82w2unokYL4ObxDpG5YR4bIeLo5NcKReQ9vH+/bnfUch3iZBiL3F4eTKe3SUxkzpsWn7W2HmYU0b6vUwbL2NmT+L4JHm/hUPxBQN5/fhmb2pgQyRn0tlstu70Hp5GliHCHJIh8V+WresV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABxb1lAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABxb1lAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A551F000FF;
	Sat, 12 Sep 2026 09:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204698;
	bh=LXCb/kvyBpFFMjPDzDhL9wthTJ4yp/mTsSHmUeG5XAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABxb1lAV9rlb5mGA9Bux7CTmyVV70H6WBxuAFaj23tUwXiJJ55GtkFkIzpamTiHV6
	 3GIKaa386DCiDuh2+Y+36Fpm4eZZsKVZV+AZ5Dj1qOnmlrvLI2Ag/Zh9xeiU/8Zinv
	 e0YjHwRkfBO4lQ+mB86JAr6uHfjQS8dsJDPPCCHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rustam Adilov <adilov@disroot.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Carlo Szelinsky <github@szelinsky.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1666/1815] irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()
Date: Sat, 12 Sep 2026 08:56:56 +0200
Message-ID: <20260912065728.101237566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rustam Adilov <adilov@disroot.org>

[ Upstream commit 58b34b72b64bfbfc5f8ad4d8f229942aff76597e ]

When CONFIG_SWAP_IO_SPACE is enabled, readl() performs a swap from little
endian device to big endian CPU and vice versa for writel().

This is incorrect for Realtek Interrupt controller as that is a big endian
device and so the LE to BE conversions are unwanted.

Fix this by converting the MMIO accesses to readl_be() and writel_be().

Fixes: 9f3a0f34b84a ("irqchip: Add support for Realtek RTL838x/RTL839x interrupt controller")
Signed-off-by: Rustam Adilov <adilov@disroot.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Carlo Szelinsky <github@szelinsky.de>
Link: https://patch.msgid.link/20260820162017.28507-1-adilov@disroot.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 9f792d4cb503b..90fb1a14c1f13 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -1,5 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
+ * Realtek Interrupt controller.
+ *
+ * The Realtek Interrupt controller is a big endian device found in the
+ * Realtek MIPS SoCs.
+ *
  * Copyright (C) 2020 Birger Koblitz <mail@birger-koblitz.de>
  * Copyright (C) 2020 Bert Vermeulen <bert@biot.com>
  * Copyright (C) 2020 John Crispin <john@phrozen.org>
@@ -46,18 +51,18 @@ static inline void enable_gimr(unsigned int cpu, unsigned int hw_irq)
 {
 	u32 gimr;
 
-	gimr = readl(REG(cpu, RTL_ICTL_GIMR));
+	gimr = readl_be(REG(cpu, RTL_ICTL_GIMR));
 	gimr |= BIT(hw_irq);
-	writel(gimr, REG(cpu, RTL_ICTL_GIMR));
+	writel_be(gimr, REG(cpu, RTL_ICTL_GIMR));
 }
 
 static inline void disable_gimr(unsigned int cpu, unsigned int hw_irq)
 {
 	u32 gimr;
 
-	gimr = readl(REG(cpu, RTL_ICTL_GIMR));
+	gimr = readl_be(REG(cpu, RTL_ICTL_GIMR));
 	gimr &= ~BIT(hw_irq);
-	writel(gimr, REG(cpu, RTL_ICTL_GIMR));
+	writel_be(gimr, REG(cpu, RTL_ICTL_GIMR));
 }
 
 static void write_irr(unsigned int cpu, int hw_irq, u32 value)
@@ -67,9 +72,9 @@ static void write_irr(unsigned int cpu, int hw_irq, u32 value)
 	unsigned int shift = IRR_SHIFT(hw_irq);
 	u32 irr;
 
-	irr = readl(irr0 + offset) & ~(0xf << shift);
+	irr = readl_be(irr0 + offset) & ~(0xf << shift);
 	irr |= (value & 0xf) << shift;
-	writel(irr, irr0 + offset);
+	writel_be(irr, irr0 + offset);
 }
 
 static void realtek_ictl_unmask_irq(struct irq_data *i)
@@ -139,7 +144,8 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 	unsigned int hw_irq;
 
 	chained_irq_enter(chip, desc);
-	pending = readl(REG(cpu, RTL_ICTL_GIMR)) & readl(REG(cpu, RTL_ICTL_GISR)) & output->mask;
+	pending = readl_be(REG(cpu, RTL_ICTL_GIMR)) &
+		  readl_be(REG(cpu, RTL_ICTL_GISR)) & output->mask;
 
 	if (unlikely(!pending)) {
 		spurious_interrupt();
-- 
2.53.0



