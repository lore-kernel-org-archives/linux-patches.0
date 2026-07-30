Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD3D392831;
	Thu, 30 Jul 2026 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424693; cv=none; b=Keo51nzQU+rBVQEtLNKOTozBZd/H4PnLxkHCjakd95iCrz1f7Z6NbQ4k5T5s0/FZ9KKnd0iRoEDNaw218GRmPv92lN1K2MDBOmlFxUMn5wIexgbphW4qoxsuVE4XHMKIx2wX+R62dXNcGY3wWnx5/M5gJDJDGzbV9llAfsV4qmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424693; c=relaxed/simple;
	bh=JtnG1yDfxtyZGuS/Wj1IlTjUanCFjou/BIINdru6O5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqRz4Qm175yUWRTCG4Q7ADN2bE9XT1TaKqaa7yortgpcjjc+tH6C2wkPT7A4ggEDnE3xcDedkWij9geOwY9f0A1NbDCSTtaNAKOsT1eIzPYrUeeEqfuyirCOYgsT1F+i8MddJnXorPYLeyK0Rv8aLTkNlZQlcI1A3X0gJ0/hHZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2FUOclG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2FUOclG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A03C1F000E9;
	Thu, 30 Jul 2026 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424691;
	bh=3eBdNoeH7z43etAw3Aa8g3rBrMpTvGw6Y7rbDUHyHa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2FUOclGR0IJRaNSvokhYmr6T3FnyvVVWzbcLSmXU4dicw+Z2fcWjL26YBGhFsIls
	 vutlaONvtsP25NWRdfSgcM3MlQ+YPIH4fwrfC04/mJLGlpNOb55AUjckQSiHLbJp3l
	 eoMC0BpOPJSEjbpjXNsasOnRgaNWFXNNB1YzLiIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 483/675] serial: sc16is7xx: implement gpio get_direction() callback
Date: Thu, 30 Jul 2026 16:13:33 +0200
Message-ID: <20260730141455.390676380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -1328,6 +1328,17 @@ static int sc16is7xx_gpio_set(struct gpi
 	return 0;
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
@@ -1405,6 +1416,7 @@ static int sc16is7xx_setup_gpio_chip(str
 	s->gpio.parent		 = dev;
 	s->gpio.label		 = dev_name(dev);
 	s->gpio.init_valid_mask	 = sc16is7xx_gpio_init_valid_mask;
+	s->gpio.get_direction	 = sc16is7xx_gpio_get_direction;
 	s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
 	s->gpio.get		 = sc16is7xx_gpio_get;
 	s->gpio.direction_output = sc16is7xx_gpio_direction_output;


