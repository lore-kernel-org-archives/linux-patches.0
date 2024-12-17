Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317D5140E38;
	Tue, 17 Dec 2024 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456369; cv=none; b=mMkV6z68jrP+loI2XDTyPx3eCS+kFWSfL3DpVSetY/6sdpmo7R6QH5Tf+PiBBuewn8Hg49rYg8syDesvnuRnb+WCMx1t+gZnxm5PgXTYphyR0X8ZZirbI71vIZAtc8eMuj9TvJ4e4E25Wj90qClwr1hzVPXUwL9pBJTX6UODky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456369; c=relaxed/simple;
	bh=YQywXysbKDXgAcPqN0mla4n7vAZF71vHK4H+6JjsCus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgcD73J++71J+UzR75RdhMMS7Ae0wJbudiD3YcbtUg9mb5/zMJe15OeX4CJrjc6elo3YD15UTxtBewU4a4tcrbBI+9Hh/EsIicw39w6AcoeMtQhmiUr0U4PTJZodfIPZ5P8Gt0OikT06aH+NeXlSe6QIlaB7mXa4L42NAeOw+co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF88tyQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF88tyQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3F2C4CED7;
	Tue, 17 Dec 2024 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456369;
	bh=YQywXysbKDXgAcPqN0mla4n7vAZF71vHK4H+6JjsCus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF88tyQ/HWiB7KY2cBa4rKwnohUrpc7Ffxch9cpBi6YSLpcHNSjedTDM+3Gq9Zdtg
	 OXYK43U6SWUo9+SzphKl0W1BSAdRGnkFRDKWWsVU/anOynPRETyl+pOit2xV4waZ2r
	 +7P/HVhVF97E7SKgEZttV1eEQZBcwVd7QkQuP3HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 037/172] gpio: graniterapids: Check if GPIO line can be used for IRQs
Date: Tue, 17 Dec 2024 18:06:33 +0100
Message-ID: <20241217170547.799776367@linuxfoundation.org>
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

commit c0ec4890d6454980c53c3cc164140115c4a671f2 upstream.

GPIO line can only be used as interrupt if its INTSEL register is
programmed by the BIOS.

Cc: stable@vger.kernel.org
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-7-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-graniterapids.c b/drivers/gpio/gpio-graniterapids.c
index b12abe77299c..3a972d460fe2 100644
--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -39,6 +39,7 @@
 
 #define GNR_CFG_DW_HOSTSW_MODE	BIT(27)
 #define GNR_CFG_DW_RX_MASK	GENMASK(23, 22)
+#define GNR_CFG_DW_INTSEL_MASK	GENMASK(21, 14)
 #define GNR_CFG_DW_RX_DISABLE	FIELD_PREP(GNR_CFG_DW_RX_MASK, 2)
 #define GNR_CFG_DW_RX_EDGE	FIELD_PREP(GNR_CFG_DW_RX_MASK, 1)
 #define GNR_CFG_DW_RX_LEVEL	FIELD_PREP(GNR_CFG_DW_RX_MASK, 0)
@@ -227,10 +228,18 @@ static void gnr_gpio_irq_unmask(struct irq_data *d)
 static int gnr_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	irq_hw_number_t pin = irqd_to_hwirq(d);
-	u32 mask = GNR_CFG_DW_RX_MASK;
+	struct gnr_gpio *priv = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	u32 reg;
 	u32 set;
 
+	/* Allow interrupts only if Interrupt Select field is non-zero */
+	reg = readl(gnr_gpio_get_padcfg_addr(priv, hwirq));
+	if (!(reg & GNR_CFG_DW_INTSEL_MASK)) {
+		dev_dbg(gc->parent, "GPIO %lu cannot be used as IRQ", hwirq);
+		return -EPERM;
+	}
+
 	/* Falling edge and level low triggers not supported by the GPIO controller */
 	switch (type) {
 	case IRQ_TYPE_NONE:
@@ -248,7 +257,7 @@ static int gnr_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	return gnr_gpio_configure_line(gc, pin, mask, set);
+	return gnr_gpio_configure_line(gc, hwirq, GNR_CFG_DW_RX_MASK, set);
 }
 
 static const struct irq_chip gnr_gpio_irq_chip = {
-- 
2.47.1



