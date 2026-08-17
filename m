Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EFC43B495;
	Mon, 17 Aug 2026 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979543; cv=none; b=eI6RWWiXy85TFB8V0V36q2QK5AlEI74+x/6G09JgYG9U8T82stcPNBFVZFQmniggxhC3h4SDh5sfDzHW2XuLYBR3dLjYImnCTPyE8WtGI6j0IUZIRYpW9JicXg1AhZWRUVufq+LZOdyJx3yY/7jIeHENodcP3bk7pRDod7KlgRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979543; c=relaxed/simple;
	bh=+Gx5yA4z3uHZTpsXACpqatY8B6PSC0LOqRDmSvE9R/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnKfW6TSUex2S1rf6n5mwsbl/hy99UUfS+c+EwHJnmVnA+wcRh9bWK2wG8Op0pFGXP3qGZAnti1P6BdwJNprz/Fuidi8fuQB88MoRYNZeHoMQr4hHOE24LKa9jcK3EDmo/3QTbiDBe+oX534lsUXqdKCO7PIum+g3y+SviPCK6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WyiqfWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WyiqfWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31641F000E9;
	Mon, 17 Aug 2026 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979542;
	bh=0zBTDrKpdvA7i+CfJ1PHaC0hqCriINbEFLMESInSOvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WyiqfWYfW8Ww75oyj0tpyjB3KNpylKNyUza+tOVYVrjtRMz+H+O90eiIzV6zPevB
	 B6et0Nt6YyBuAHJBDheH2QTgAVmJ2qebZcDzWxwVioCjq+8ds6iUsYG7pVXfIN5DIE
	 pG4Xidbg+/JiafCl4WbdxL2sb89eaVGU/Wew3Y8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 235/609] serial: sc16is7xx: implement gpio get_direction() callback
Date: Mon, 17 Aug 2026 15:28:51 +0200
Message-ID: <20260817132551.947183601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -1311,6 +1311,17 @@ static void sc16is7xx_gpio_set(struct gp
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
@@ -1388,6 +1399,7 @@ static int sc16is7xx_setup_gpio_chip(str
 	s->gpio.parent		 = dev;
 	s->gpio.label		 = dev_name(dev);
 	s->gpio.init_valid_mask	 = sc16is7xx_gpio_init_valid_mask;
+	s->gpio.get_direction	 = sc16is7xx_gpio_get_direction;
 	s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
 	s->gpio.get		 = sc16is7xx_gpio_get;
 	s->gpio.direction_output = sc16is7xx_gpio_direction_output;


