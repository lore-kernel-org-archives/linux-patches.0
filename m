Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD2C72223;
	Mon, 29 Jan 2024 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548505; cv=none; b=q3smr3yGU7RVntLPknQtoi2eT+KkKcH7IvWWw6Yn2O6ZiiM/hyprzW0aysUHkUeike+GoYG8BMfeCL6JW+oD9xKE3rKMrb4oXbIBUlBZ8FVhFsj5g17+TrIvOzThxRzy5kVar7hrbAiAeqNVauEjaISM9LWju6UmHaVNWPZfLhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548505; c=relaxed/simple;
	bh=oT1xGV0jRieGWBxkEPdx1aF/BAUwkF2yAoJXurF2Xqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6fTewZv80tK/632kbT3N4tZbPr1rmFijjFX6jCnAKXxXLx1asVoko007X8FwT9VWzlgpVYLZ2V5XTO7605LFYY+0Ky/qGzQav+W/ygeM8k9cx+duyyuaptvl6jGY8FkazbsAr741Lj0IVVUR8/KRICuVFHbYyJ7QBzL/y/c8lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mo+JJzOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mo+JJzOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D61C433C7;
	Mon, 29 Jan 2024 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548505;
	bh=oT1xGV0jRieGWBxkEPdx1aF/BAUwkF2yAoJXurF2Xqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mo+JJzOYQvpaPAvdqjFQSoIzCyqI/rI+FDCXfTqFiQ7Nw/cBUNdvl6RrYqhwx8Q23
	 eSr8KdvRQZb3Xvfy5TGGEN4ci4OnxSum/Ghm45SLC9InevtW+TzEleqk7jouYFW0rz
	 xUj/ilDlp2sPCFBH6WIpPDMOqZhA3Dp9qR0YEB9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 134/331] serial: sc16is7xx: fix invalid sc16is7xx_lines bitfield in case of probe error
Date: Mon, 29 Jan 2024 09:03:18 -0800
Message-ID: <20240129170018.864785775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 8a1060ce974919f2a79807527ad82ac39336eda2 upstream.

If an error occurs during probing, the sc16is7xx_lines bitfield may be left
in a state that doesn't represent the correct state of lines allocation.

For example, in a system with two SC16 devices, if an error occurs only
during probing of channel (port) B of the second device, sc16is7xx_lines
final state will be 00001011b instead of the expected 00000011b.

This is caused in part because of the "i--" in the for/loop located in
the out_ports: error path.

Fix this by checking the return value of uart_add_one_port() and set line
allocation bit only if this was successful. This allows the refactor of
the obfuscated for(i--...) loop in the error path, and properly call
uart_remove_one_port() only when needed, and properly unset line allocation
bits.

Also use same mechanism in remove() when calling uart_remove_one_port().

Fixes: c64349722d14 ("sc16is7xx: support multiple devices")
Cc:  <stable@vger.kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   44 ++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -409,19 +409,6 @@ static void sc16is7xx_port_update(struct
 	regmap_update_bits(one->regmap, reg, mask, val);
 }
 
-static int sc16is7xx_alloc_line(void)
-{
-	int i;
-
-	BUILD_BUG_ON(SC16IS7XX_MAX_DEVS > BITS_PER_LONG);
-
-	for (i = 0; i < SC16IS7XX_MAX_DEVS; i++)
-		if (!test_and_set_bit(i, &sc16is7xx_lines))
-			break;
-
-	return i;
-}
-
 static void sc16is7xx_power(struct uart_port *port, int on)
 {
 	sc16is7xx_port_update(port, SC16IS7XX_IER_REG,
@@ -1532,6 +1519,13 @@ static int sc16is7xx_probe(struct device
 		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
+		s->p[i].port.line = find_first_zero_bit(&sc16is7xx_lines,
+							SC16IS7XX_MAX_DEVS);
+		if (s->p[i].port.line >= SC16IS7XX_MAX_DEVS) {
+			ret = -ERANGE;
+			goto out_ports;
+		}
+
 		/* Initialize port data */
 		s->p[i].port.dev	= dev;
 		s->p[i].port.irq	= irq;
@@ -1551,14 +1545,8 @@ static int sc16is7xx_probe(struct device
 		s->p[i].port.rs485_supported = sc16is7xx_rs485_supported;
 		s->p[i].port.ops	= &sc16is7xx_ops;
 		s->p[i].old_mctrl	= 0;
-		s->p[i].port.line	= sc16is7xx_alloc_line();
 		s->p[i].regmap		= regmaps[i];
 
-		if (s->p[i].port.line >= SC16IS7XX_MAX_DEVS) {
-			ret = -ENOMEM;
-			goto out_ports;
-		}
-
 		mutex_init(&s->p[i].efr_lock);
 
 		ret = uart_get_rs485_mode(&s->p[i].port);
@@ -1576,8 +1564,13 @@ static int sc16is7xx_probe(struct device
 		kthread_init_work(&s->p[i].tx_work, sc16is7xx_tx_proc);
 		kthread_init_work(&s->p[i].reg_work, sc16is7xx_reg_proc);
 		kthread_init_delayed_work(&s->p[i].ms_work, sc16is7xx_ms_proc);
+
 		/* Register port */
-		uart_add_one_port(&sc16is7xx_uart, &s->p[i].port);
+		ret = uart_add_one_port(&sc16is7xx_uart, &s->p[i].port);
+		if (ret)
+			goto out_ports;
+
+		set_bit(s->p[i].port.line, &sc16is7xx_lines);
 
 		/* Enable EFR */
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_LCR_REG,
@@ -1644,10 +1637,9 @@ static int sc16is7xx_probe(struct device
 #endif
 
 out_ports:
-	for (i--; i >= 0; i--) {
-		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
-	}
+	for (i = 0; i < devtype->nr_uart; i++)
+		if (test_and_clear_bit(s->p[i].port.line, &sc16is7xx_lines))
+			uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
 
 	kthread_stop(s->kworker_task);
 
@@ -1669,8 +1661,8 @@ static void sc16is7xx_remove(struct devi
 
 	for (i = 0; i < s->devtype->nr_uart; i++) {
 		kthread_cancel_delayed_work_sync(&s->p[i].ms_work);
-		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
+		if (test_and_clear_bit(s->p[i].port.line, &sc16is7xx_lines))
+			uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
 		sc16is7xx_power(&s->p[i].port, 0);
 	}
 


