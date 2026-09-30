Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCAB50E5AF;
	Wed, 30 Sep 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784832; cv=none; b=lJbwuGKs2+Vhnpzur9PQXmxOBgnDRQlO6dtUXPk/04agpPodurR78E1diZnZT68RDFjgOMGlSaDNse3e/qbWh/qcFFwM3QIdpFX5cxyCIUJHqqDWTpCjV9TXRt/hs2Vucpmj2LitAprNC6ZAkJiomR2Zrzadsd/W1mljQd3JHM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784832; c=relaxed/simple;
	bh=a3+SHKIuGMVGMeyKhGpBkasFv5m6ufMOS8VEwrkHs9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpOZOBOsWXkucxTwE8Hnd/Sx0HyjLrwALRhcN7BZeC67OPkMkDdMvyMTWiMuALyLeqlaK3q+53ndaTqpAIAZ61oCuCsTp1qJC+ZSicBa2Cdzc61QNs4pIJZHgapaDur8o0tUSzlnXGzkOEWqVV1JuQKYyXDnAQQbTdg6fTZRvA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jf5Lwxl0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jf5Lwxl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16D11F00893;
	Wed, 30 Sep 2026 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784827;
	bh=65Wuu3L/We9T329pzN84wEhhg7nRgtZQJL65X2Ex4j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jf5Lwxl0JpCEfkLjI8ttpVbyPv3Zyg4/XLLtgoSurTKXVZt9M8WB+9jrTgJEovnTp
	 mzBK78hU4f9GNN2XoXQTClYhFOSDmHUN4WHxFTKGX89THSbF0iXjrPJqlHXjyjlUgB
	 oW8nTypOYQP6ecm6ely73LqFHd7hRSBR1YUMR670=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/982] gpio: dwapb: Mask interrupts at hardware initialization
Date: Wed, 30 Sep 2026 17:16:32 +0200
Message-ID: <20260930152422.295550927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b7d47a52b10a..8c07776725dda 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -200,6 +200,22 @@ static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
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
 	struct gpio_chip *gc = &gpio->ports[0].gc;
@@ -461,6 +477,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	girq = &gc->irq;
 	girq->handler = handle_bad_irq;
 	girq->default_type = IRQ_TYPE_NONE;
+	girq->init_hw = dwapb_irq_init_hw;
 
 	port->pirq = pirq;
 
-- 
2.53.0



