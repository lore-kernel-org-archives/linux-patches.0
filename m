Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFE44FD792;
	Thu, 17 Sep 2026 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664835; cv=none; b=K9gwpAoWJdF1n4+ZjD/nOtBpowZiFkjuJERnYAQ1tFnaJ6b0TasgEmNnYuixz+t9ex7onsJi8Tab7inNbJjPaD5h9BGqRwez0f+pTY0zgyRlICc31/Je0uIqJq/Mpfi+UK+kMHAvPtOyTRJtD59+4KZ3MM0fWCIANHkptmIXLBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664835; c=relaxed/simple;
	bh=yFMzAVjgjQ8QmHU0Dh+OSvSAj5ohqJ1kjzsZGALwS64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5qvirgVxlGnpvCg7lBLUqC9LtmPC9g8YE7UQn+oggsLy2fzAXuswIbIRu3vINUxdVtR74QaZjqeKJuHmkHDyUgnwsFyS/lWU9Yb6ptez5bSLro8Jx2tS5Dq9oBwe6o8h0d5XfCRvj0MoDOndhdLdIBbtWbROInJWRvvgu/HIyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW8BH5zT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW8BH5zT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886D31F00893;
	Thu, 17 Sep 2026 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664832;
	bh=P/tAerCaKdpx7Dgho6Q+6dqulaxybKRy0VNJjTerM9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qW8BH5zThuhdTYdXtUPGj5JXASNwjsbvhFvP7sfbee9FL15pRHl3XFBBMS8ygELvH
	 3AtlbS5HgV8ex4St88gq5mNS9fOd3XBTLH9E8rZgsXDYunvv8k2IAU4a32tRcSY0sn
	 oq5CCNeX11QIyPsc2q8lKLpBrnlf3qtIvuHdy8hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0502/1250] gpio: dwapb: Mask interrupts at hardware initialization
Date: Thu, 17 Sep 2026 16:04:57 +0100
Message-ID: <20260917151605.566126130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Hao <haohlliang@gmail.com>

[ Upstream commit aaf7766ba3b99a3834319e7cf939838afc705574 ]

GPIO interrupts may retain stale state across warm reboots when
peripherals remain powered. If a GPIO line is not explicitly
configured for interrupts, this can result in interrupt storms
due to missing handlers.

Fix this by ensuring all interrupts are masked and disabled at
hardware initialization time via the init_hw() callback. Pending
interrupts are also cleared to start from a known-safe state.

Interrupts will be unmasked only when explicitly configured by
userspace or kernel drivers.

Signed-off-by: Liang Hao <haohlliang@gmail.com>
Link: https://patch.msgid.link/20260705074759.47863-1-haohlliang@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-dwapb.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 0259c65973323..6ece05f3afe2d 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -201,6 +201,22 @@ static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
 	dwapb_write(gpio, GPIO_INT_POLARITY, pol);
 }
 
+static int dwapb_irq_init_hw(struct gpio_chip *gc)
+{
+	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
+
+	/*
+	 * GPIO interrupts may retain stale state across warm reboots when
+	 * peripherals stay powered. Force a known-safe state before the GPIO
+	 * irqchip and irq domain are set up.
+	 */
+	dwapb_write(gpio, GPIO_INTEN, 0);
+	dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
+	dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
+
+	return 0;
+}
+
 static u32 dwapb_do_irq(struct dwapb_gpio *gpio)
 {
 	struct gpio_generic_chip *gen_gc = &gpio->ports[0].chip;
@@ -472,6 +488,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	girq = &gc->irq;
 	girq->handler = handle_bad_irq;
 	girq->default_type = IRQ_TYPE_NONE;
+	girq->init_hw = dwapb_irq_init_hw;
 
 	port->pirq = pirq;
 
-- 
2.53.0



