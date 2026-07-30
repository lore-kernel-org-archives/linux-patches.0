Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06842373C1A;
	Thu, 30 Jul 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426305; cv=none; b=gIPCL/q7tR/XbXhSwtYRW8IPqne/GU2sCBMm1qaSaki5VNtNUMljyWH6b0FwCpvqBHHXTC5r0dHpGudV9B5n1cxthcpZBkzVlvvUGAA5Bw9hTpTO7HjxCJyzpOiAgO57pGxVWQNI5pwMcZ1JyA65HE3iEmPQbS6ReJPxRjzOzAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426305; c=relaxed/simple;
	bh=wWLPTP1/UgoG1DmMA09Twid3LDIAcVJeNZrncj0sAAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbqWbMPru5Y9l4C1W1RUAXNhUyBH44eg5SzzD+UHFrhACziJuWHiRbpbQ2vQ0wTWJ6DRWz6g0o2DO55C8vHZbHi4j7QcnI0/HCu/YXbRX6iKX4584v4GQFC1XwPkCfB0tL0a0VuJ8HFyQOv+Th2P2szuPfsNHiTrdNaoiPUbvfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7/lgbSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7/lgbSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609991F000E9;
	Thu, 30 Jul 2026 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426303;
	bh=METoLY7bFUdTOWyBx/03bk4asRGJXOWMPXHwg+/TMwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7/lgbSC25uhN2pzbhb3BC/ptKVzu0JEGIp1y3IWjXDfazSJa9Vbbtl4Fz2OHRbst
	 gmb/rQI/xqPY4ltpU7fKEvIQ5hxiYtKrSRjbOp0W/CLbF0aPnwxNT9PRyeKlKdOS3B
	 hxCf3r0TxNmmvAnQH/OuqBfPYU2/irDbls+gbchw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 370/602] serial: sc16is7xx: implement gpio get_direction() callback
Date: Thu, 30 Jul 2026 16:12:42 +0200
Message-ID: <20260730141443.736856387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit af071d9e07e57cfff239e8d09d2f3b05ebc9c667 upstream.

It's strongly recommended for GPIO drivers to always implement the
.get_direction() callback - even when the direction is tracked in
software. The GPIO core emits a warning when the callback is missing
and a user reads the direction of a line, e.g. via
/sys/kernel/debug/gpio.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable <stable@kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260716210813.2582826-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1302,6 +1302,17 @@ static void sc16is7xx_gpio_set(struct gp
 			      val ? BIT(offset) : 0);
 }
 
+static int sc16is7xx_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
+{
+	struct sc16is7xx_port *s = gpiochip_get_data(chip);
+	struct uart_port *port = &s->p[0].port;
+	unsigned int val;
+
+	val = sc16is7xx_port_read(port, SC16IS7XX_IODIR_REG);
+
+	return val & BIT(offset) ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
 static int sc16is7xx_gpio_direction_input(struct gpio_chip *chip,
 					  unsigned offset)
 {
@@ -1379,6 +1390,7 @@ static int sc16is7xx_setup_gpio_chip(str
 	s->gpio.parent		 = dev;
 	s->gpio.label		 = dev_name(dev);
 	s->gpio.init_valid_mask	 = sc16is7xx_gpio_init_valid_mask;
+	s->gpio.get_direction	 = sc16is7xx_gpio_get_direction;
 	s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
 	s->gpio.get		 = sc16is7xx_gpio_get;
 	s->gpio.direction_output = sc16is7xx_gpio_direction_output;


