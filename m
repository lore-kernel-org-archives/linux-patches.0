Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBF727464F;
	Mon, 13 Oct 2025 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369333; cv=none; b=gxNLnErVe15Xc2iKTTPqyJuTxjxKi4U/lfp8zE4arzajV5WQvjc4K3J+7Hc0wT0bqhisfyNCCbFmQNUBKKiBn9GsKGDo4kFTfZ1MBcNvB8/ZSt39XQ2jnkavn9q8hHMD2F/emm9xw/hRcuHgt8vTFVv1kWANBiIaVvggzrBw0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369333; c=relaxed/simple;
	bh=7C52uuAFIXtoyyPj4P4T9Wh3n5YZTnVYHqU6HMylkrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9ECTOLD4mGyEGuDMyFJjgij/4XnZmaYJzejw9jgxYGyOVXl7uuCMJrsI1xmvxWA21DUfMgah08yiL8gSXbUq+gXJ2QOgX6pLU1KwEIWevuQj9OZ2/lO7aslnBlOUE7kFxzzbfN+jgnbGQZoti/wgFd7p7gfYDTvPBoOUEkeKoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WO8fPBBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WO8fPBBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6D9C4CEE7;
	Mon, 13 Oct 2025 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369333;
	bh=7C52uuAFIXtoyyPj4P4T9Wh3n5YZTnVYHqU6HMylkrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WO8fPBBFWvDRNiegC+Ttpy1H2pzYcfKhnXx1zJOls4TUCRq1kutnyjjDIIy1wOV8D
	 xMvcyx0SjYdTo94G13S8F/lV7AkK4gDU8w7V4c1wkQ8fGhFgobfRbkBcg/k3g7Z/Fe
	 yYKN+g297ckNBoAavdLlEa4YZ+es7ymCutzxJ5Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 210/563] mfd: max77705: Setup the core driver as an interrupt controller
Date: Mon, 13 Oct 2025 16:41:11 +0200
Message-ID: <20251013144418.892662080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 605c9820e44de2da7d67acf66484136561da63a2 ]

Current implementation describes only MFD's own topsys interrupts.
However, max77705 has a register which indicates interrupt source, i.e.
it acts as an interrupt controller. There's 4 interrupt sources in
max77705: topsys, charger, fuelgauge, usb type-c manager.

Setup max77705 MFD parent as an interrupt controller. Delete topsys
interrupts because currently unused.

Remove shared interrupt flag, because we're are an interrupt controller
now, and subdevices should request interrupts from us.

Fixes: c8d50f029748 ("mfd: Add new driver for MAX77705 PMIC")

Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250909-max77705-fix_interrupt_handling-v3-1-233c5a1a20b5@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max77705.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/max77705.c b/drivers/mfd/max77705.c
index ff07d0e0d5f8e..e1a9bfd658560 100644
--- a/drivers/mfd/max77705.c
+++ b/drivers/mfd/max77705.c
@@ -61,21 +61,21 @@ static const struct regmap_config max77705_regmap_config = {
 	.max_register = MAX77705_PMIC_REG_USBC_RESET,
 };
 
-static const struct regmap_irq max77705_topsys_irqs[] = {
-	{ .mask = MAX77705_SYSTEM_IRQ_BSTEN_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_SYSUVLO_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_SYSOVLO_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_TSHDN_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_TM_INT, },
+static const struct regmap_irq max77705_irqs[] = {
+	{ .mask = MAX77705_SRC_IRQ_CHG, },
+	{ .mask = MAX77705_SRC_IRQ_TOP, },
+	{ .mask = MAX77705_SRC_IRQ_FG, },
+	{ .mask = MAX77705_SRC_IRQ_USBC, },
 };
 
-static const struct regmap_irq_chip max77705_topsys_irq_chip = {
-	.name		= "max77705-topsys",
-	.status_base	= MAX77705_PMIC_REG_SYSTEM_INT,
-	.mask_base	= MAX77705_PMIC_REG_SYSTEM_INT_MASK,
+static const struct regmap_irq_chip max77705_irq_chip = {
+	.name		= "max77705",
+	.status_base	= MAX77705_PMIC_REG_INTSRC,
+	.ack_base	= MAX77705_PMIC_REG_INTSRC,
+	.mask_base	= MAX77705_PMIC_REG_INTSRC_MASK,
 	.num_regs	= 1,
-	.irqs		= max77705_topsys_irqs,
-	.num_irqs	= ARRAY_SIZE(max77705_topsys_irqs),
+	.irqs		= max77705_irqs,
+	.num_irqs	= ARRAY_SIZE(max77705_irqs),
 };
 
 static int max77705_i2c_probe(struct i2c_client *i2c)
@@ -113,19 +113,12 @@ static int max77705_i2c_probe(struct i2c_client *i2c)
 
 	ret = devm_regmap_add_irq_chip(dev, max77705->regmap,
 					i2c->irq,
-					IRQF_ONESHOT | IRQF_SHARED, 0,
-					&max77705_topsys_irq_chip,
+					IRQF_ONESHOT, 0,
+					&max77705_irq_chip,
 					&irq_data);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add IRQ chip\n");
 
-	/* Unmask interrupts from all blocks in interrupt source register */
-	ret = regmap_update_bits(max77705->regmap,
-				 MAX77705_PMIC_REG_INTSRC_MASK,
-				 MAX77705_SRC_IRQ_ALL, (unsigned int)~MAX77705_SRC_IRQ_ALL);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "Could not unmask interrupts in INTSRC\n");
-
 	domain = regmap_irq_get_domain(irq_data);
 
 	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE,
-- 
2.51.0



