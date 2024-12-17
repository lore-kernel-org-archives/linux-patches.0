Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6A71F866E;
	Tue, 17 Dec 2024 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456357; cv=none; b=W1LQCBkrP37cHFdKc1uKSc6NWNVOYVvwYqidLuOzTgDo4KPsMmcpomEv3ny5E8v7xVrL94KxOrZNySYlQlQ/PRQsz8JxaOkj5Ud0cD64NWNpc9AdXp2d4qtXEMS98KThTDTdlgJE5/f5yyjhWiRpDRH60C25HV1IlGxAt8XJ78E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456357; c=relaxed/simple;
	bh=2Sk97q94lSbUDhrS5t8QbR5anYjciXmjrYOcYOE/pOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvkye6lELngR9n/2FpJnxVChZwxXMZfnnjdXfpYZnrQqlscyWVINTxgqU+i4nKD1qXzAxvi0mhmJ5fxYAIUFwa1UiOqwHhqkjqA0rJBRLLtdi+RUtooetmB2wNL+8QX4SdGOlIuVloqbLO+eRQw4f71SeXAlzuXD/jbtJjfqHfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkZFkGDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkZFkGDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ADBC4CED3;
	Tue, 17 Dec 2024 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456357;
	bh=2Sk97q94lSbUDhrS5t8QbR5anYjciXmjrYOcYOE/pOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkZFkGDaPjPswB8hg6vM0QxV67MoArEbzcYm7ihMx/GedLXMQQGoX2YniWBQg2V5W
	 5VXs7FQIC+aJTpBxXuze9+ljX9Y2PMF0qcM29uQ/SiqKmwSVadLN7fFLDGrHnR0SbC
	 JtYwBFi2XA4AqyPj+Db7GX8LEbR7kECoTWrtNbEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 033/172] gpio: graniterapids: Fix incorrect BAR assignment
Date: Tue, 17 Dec 2024 18:06:29 +0100
Message-ID: <20241217170547.634909293@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit 7382d2f0e802077c36495e325da8d253a15fb441 upstream.

Base Address of vGPIO MMIO register is provided directly by the BIOS
instead of using offsets. Update address assignment to reflect this
change in driver.

Cc: stable@vger.kernel.org
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-3-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -32,7 +32,7 @@
 #define GNR_PINS_PER_REG 32
 #define GNR_NUM_REGS DIV_ROUND_UP(GNR_NUM_PINS, GNR_PINS_PER_REG)
 
-#define GNR_CFG_BAR		0x00
+#define GNR_CFG_PADBAR		0x00
 #define GNR_CFG_LOCK_OFFSET	0x04
 #define GNR_GPI_STATUS_OFFSET	0x20
 #define GNR_GPI_ENABLE_OFFSET	0x24
@@ -50,6 +50,7 @@
  * struct gnr_gpio - Intel Granite Rapids-D vGPIO driver state
  * @gc: GPIO controller interface
  * @reg_base: base address of the GPIO registers
+ * @pad_base: base address of the vGPIO pad configuration registers
  * @ro_bitmap: bitmap of read-only pins
  * @lock: guard the registers
  * @pad_backup: backup of the register state for suspend
@@ -57,6 +58,7 @@
 struct gnr_gpio {
 	struct gpio_chip gc;
 	void __iomem *reg_base;
+	void __iomem *pad_base;
 	DECLARE_BITMAP(ro_bitmap, GNR_NUM_PINS);
 	raw_spinlock_t lock;
 	u32 pad_backup[];
@@ -65,7 +67,7 @@ struct gnr_gpio {
 static void __iomem *gnr_gpio_get_padcfg_addr(const struct gnr_gpio *priv,
 					      unsigned int gpio)
 {
-	return priv->reg_base + gpio * sizeof(u32);
+	return priv->pad_base + gpio * sizeof(u32);
 }
 
 static int gnr_gpio_configure_line(struct gpio_chip *gc, unsigned int gpio,
@@ -292,6 +294,7 @@ static int gnr_gpio_probe(struct platfor
 	struct gnr_gpio *priv;
 	void __iomem *regs;
 	int irq, ret;
+	u32 offset;
 
 	priv = devm_kzalloc(dev, struct_size(priv, pad_backup, num_backup_pins), GFP_KERNEL);
 	if (!priv)
@@ -303,6 +306,10 @@ static int gnr_gpio_probe(struct platfor
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
+	priv->reg_base = regs;
+	offset = readl(priv->reg_base + GNR_CFG_PADBAR);
+	priv->pad_base = priv->reg_base + offset;
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
@@ -312,8 +319,6 @@ static int gnr_gpio_probe(struct platfor
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to request interrupt\n");
 
-	priv->reg_base = regs + readl(regs + GNR_CFG_BAR);
-
 	gnr_gpio_init_pin_ro_bits(dev, priv->reg_base + GNR_CFG_LOCK_OFFSET,
 				  priv->ro_bitmap);
 


