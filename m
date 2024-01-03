Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100D01BDDE;
	Wed,  3 Jan 2024 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja2aORFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C97C433C7;
	Wed,  3 Jan 2024 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301660;
	bh=Y6XLQSf3n9n6k9r3mTOPK/ddLmZY7ureyQyeR43OK7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ja2aORFZPGKihW35Ln1l8EUhp1bV0m9c0m43Koq5HaEJyu68daBiadJwIEcbEAedQ
	 AjGYd8ObHDb0KnIkUEXKCV/z42JeSMsmvhv2VjW7egPJgndXnN/Rhgutn0PSJsyyM0
	 4CasnF4zpv9TcbHGxWQdl0PgL6KP9OZ2gdbz9v0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Riwen Lu <luriwen@kylinos.cn>,
	xiongxin <xiongxin@kylinos.cn>,
	Serge Semin <fancer.lancer@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.15 61/95] gpio: dwapb: mask/unmask IRQ when disable/enale it
Date: Wed,  3 Jan 2024 17:55:09 +0100
Message-ID: <20240103164903.109982411@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xiongxin <xiongxin@kylinos.cn>

commit 1cc3542c76acb5f59001e3e562eba672f1983355 upstream.

In the hardware implementation of the I2C HID driver based on DesignWare
GPIO IRQ chip, when the user continues to use the I2C HID device in the
suspend process, the I2C HID interrupt will be masked after the resume
process is finished.

This is because the disable_irq()/enable_irq() of the DesignWare GPIO
driver does not synchronize the IRQ mask register state. In normal use
of the I2C HID procedure, the GPIO IRQ irq_mask()/irq_unmask() functions
are called in pairs. In case of an exception, i2c_hid_core_suspend()
calls disable_irq() to disable the GPIO IRQ. With low probability, this
causes irq_unmask() to not be called, which causes the GPIO IRQ to be
masked and not unmasked in enable_irq(), raising an exception.

Add synchronization to the masked register state in the
dwapb_irq_enable()/dwapb_irq_disable() function. mask the GPIO IRQ
before disabling it. After enabling the GPIO IRQ, unmask the IRQ.

Fixes: 7779b3455697 ("gpio: add a driver for the Synopsys DesignWare APB GPIO block")
Cc: stable@kernel.org
Co-developed-by: Riwen Lu <luriwen@kylinos.cn>
Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-dwapb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -277,13 +277,15 @@ static void dwapb_irq_enable(struct irq_
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 val;
 
 	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
-	val = dwapb_read(gpio, GPIO_INTEN);
-	val |= BIT(irqd_to_hwirq(d));
+	val = dwapb_read(gpio, GPIO_INTEN) | BIT(hwirq);
 	dwapb_write(gpio, GPIO_INTEN, val);
+	val = dwapb_read(gpio, GPIO_INTMASK) & ~BIT(hwirq);
+	dwapb_write(gpio, GPIO_INTMASK, val);
 	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
@@ -291,12 +293,14 @@ static void dwapb_irq_disable(struct irq
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 val;
 
 	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
-	val = dwapb_read(gpio, GPIO_INTEN);
-	val &= ~BIT(irqd_to_hwirq(d));
+	val = dwapb_read(gpio, GPIO_INTMASK) | BIT(hwirq);
+	dwapb_write(gpio, GPIO_INTMASK, val);
+	val = dwapb_read(gpio, GPIO_INTEN) & ~BIT(hwirq);
 	dwapb_write(gpio, GPIO_INTEN, val);
 	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }


