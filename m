Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002EB30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B51FC433C8;
	Wed, 20 Sep 2023 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212769;
	bh=e0JCpb3R/BRg1Ej76RFlFg9/uSlXElh6oQVspBgUg5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+NY5lxzwBA++kJ/iD5Xl1rhZ1IYZ0xiJDsL2jRjFhsUFxCJsE820BF0w/jfJKF3B
	 dUVkubEIjw6FrELE8mX1NRQ9iOyGH3O+c6igR0SxoejTGGfmEYDI4ATbznvOHc2shj
	 wt+LVvzqYeVtDw5Apexut1933LkTaaHGARsaq/pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Lech Perczak <lech.perczak@camlingroup.com>
Subject: [PATCH 5.4 012/367] serial: sc16is7xx: fix bug when first setting GPIO direction
Date: Wed, 20 Sep 2023 13:26:29 +0200
Message-ID: <20230920112858.822435098@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1166,9 +1166,18 @@ static int sc16is7xx_gpio_direction_outp
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


