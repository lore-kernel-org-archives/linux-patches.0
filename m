Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFC761FDF;
	Mon, 27 May 2024 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838694; cv=none; b=gfjsgJ2CRWoOxy3q0cFM93Oy1263z4fXFlLR6QNrBR1K0tvlp4Saej04Dk/A2PSl10WmGKsCVTR2NQ2oAAf4OMJc33YZ3SXKicO0xMrTm+mf6hnyvW2bORJnFM3ITOqVk0RAoxprGoldoKMmol1urbUsv+LB8JmXZ3MBTXl/OHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838694; c=relaxed/simple;
	bh=AGQJsZnwUaDM9RaBeiCn1wKsGNSzBl5SnloAN/uSbB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFK8M5mrmP0r4y5j5pkZEXW5g8Dc0InTluppLU0/fnKVS+SKtdIRrgkEIZUJysNnkD0Y1Jp66mePtyxGceKheVoFefRARO5uvs6hKL9RpmtNJZHhPOKpnSpNHvA3OqFHJ0N6/ciILg4LhHxqC7rWEhsrIMb5cKp9DkzQq01vO2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWPBVP0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWPBVP0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6290BC32781;
	Mon, 27 May 2024 19:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838694;
	bh=AGQJsZnwUaDM9RaBeiCn1wKsGNSzBl5SnloAN/uSbB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWPBVP0zm6/Wexo+S6HOUB/xAkV/C4kO85pJYbxJiMBrOOcDrecdym7iGulR8jDSa
	 H3KDt0/WmlV22nUD13WR69u4NZqJKs17WX0xYg3f22SDMfQOmmekaBHpO+/MXdqiHB
	 VqiY/q3YKpaIh4dX9tJB/BmQ7/22XPgyfwzOBpkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 493/493] net: txgbe: fix GPIO interrupt blocking
Date: Mon, 27 May 2024 20:58:15 +0200
Message-ID: <20240527185646.258015434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit b4a2496c17ed645f8d51061047c9c249b58c74ba ]

The register of GPIO interrupt status is masked before MAC IRQ
is enabled. This is because of hardware deficiency. So manually
clear the interrupt status before using them. Otherwise, GPIO
interrupts will never be reported again. There is a workaround for
clearing interrupts to set GPIO EOI in txgbe_up_complete().

Fixes: aefd013624a1 ("net: txgbe: use irq_domain for interrupt controller")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://lore.kernel.org/r/20240301092956.18544-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 27 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 88ea20946e6ec..8c7a74981b907 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -81,6 +81,7 @@ static void txgbe_up_complete(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
 
+	txgbe_reinit_gpio_intr(wx);
 	wx_control_hw(wx, true);
 	wx_configure_vectors(wx);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 3c9bb4ab98681..93295916b1d2b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -491,6 +491,33 @@ irqreturn_t txgbe_gpio_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+void txgbe_reinit_gpio_intr(struct wx *wx)
+{
+	struct txgbe *txgbe = wx->priv;
+	irq_hw_number_t hwirq;
+	unsigned long gpioirq;
+	struct gpio_chip *gc;
+	unsigned long flags;
+
+	/* for gpio interrupt pending before irq enable */
+	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
+
+	gc = txgbe->gpio;
+	for_each_set_bit(hwirq, &gpioirq, gc->ngpio) {
+		int gpio = irq_find_mapping(gc->irq.domain, hwirq);
+		struct irq_data *d = irq_get_irq_data(gpio);
+		u32 irq_type = irq_get_trigger_type(gpio);
+
+		txgbe_gpio_irq_ack(d);
+
+		if ((irq_type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+			raw_spin_lock_irqsave(&wx->gpio_lock, flags);
+			txgbe_toggle_trigger(gc, hwirq);
+			raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
+		}
+	}
+}
+
 static int txgbe_gpio_init(struct txgbe *txgbe)
 {
 	struct gpio_irq_chip *girq;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
index 9855d44076cb8..8a026d804fe24 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -5,6 +5,7 @@
 #define _TXGBE_PHY_H_
 
 irqreturn_t txgbe_gpio_irq_handler(int irq, void *data);
+void txgbe_reinit_gpio_intr(struct wx *wx);
 irqreturn_t txgbe_link_irq_handler(int irq, void *data);
 int txgbe_init_phy(struct txgbe *txgbe);
 void txgbe_remove_phy(struct txgbe *txgbe);
-- 
2.43.0



