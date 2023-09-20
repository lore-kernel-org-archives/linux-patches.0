Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27082AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738D8C433C9;
	Wed, 20 Sep 2023 12:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211241;
	bh=Nm68toKpyzulpn0QZT1GyvuS/ZGqo+msQLYOotqMp2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQi4GDEP2qj5/2NWP6Hjvd75QUoZMj/rbRXu3RZALw6QcPEld3kcR/s7OYgZPfXhm
	 vgnYv7RxtIUhjal1s/WxOlv8tKiiqEFpYSpLEglxN57VfVeaQ0i2Ghb0iWWgV6f78B
	 jzWqxnst7AcxpfiUk1ZzQLVbpM4whI2gJqnuvGOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Lech Perczak <lech.perczak@camlingroup.com>
Subject: [PATCH 4.14 009/186] serial: sc16is7xx: fix bug when first setting GPIO direction
Date: Wed, 20 Sep 2023 13:28:32 +0200
Message-ID: <20230920112837.183097279@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 9baeea723c0fb9c3ba9a336369f758ed9bc6831d upstream.

When configuring a pin as an output pin with a value of logic 0, we
end up as having a value of logic 1 on the output pin. Setting a
logic 0 a second time (or more) after that will correctly output a
logic 0 on the output pin.

By default, all GPIO pins are configured as inputs. When we enter
sc16is7xx_gpio_direction_output() for the first time, we first set the
desired value in IOSTATE, and then we configure the pin as an output.
The datasheet states that writing to IOSTATE register will trigger a
transfer of the value to the I/O pin configured as output, so if the
pin is configured as an input, nothing will be transferred.

Therefore, set the direction first in IODIR, and then set the desired
value in IOSTATE.

This is what is done in NXP application note AN10587.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Lech Perczak <lech.perczak@camlingroup.com>
Tested-by: Lech Perczak <lech.perczak@camlingroup.com>
Link: https://lore.kernel.org/r/20230807214556.540627-6-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1171,9 +1171,18 @@ static int sc16is7xx_gpio_direction_outp
 		state |= BIT(offset);
 	else
 		state &= ~BIT(offset);
-	sc16is7xx_port_write(port, SC16IS7XX_IOSTATE_REG, state);
+
+	/*
+	 * If we write IOSTATE first, and then IODIR, the output value is not
+	 * transferred to the corresponding I/O pin.
+	 * The datasheet states that each register bit will be transferred to
+	 * the corresponding I/O pin programmed as output when writing to
+	 * IOSTATE. Therefore, configure direction first with IODIR, and then
+	 * set value after with IOSTATE.
+	 */
 	sc16is7xx_port_update(port, SC16IS7XX_IODIR_REG, BIT(offset),
 			      BIT(offset));
+	sc16is7xx_port_write(port, SC16IS7XX_IOSTATE_REG, state);
 
 	return 0;
 }


