Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6036228EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CDAC43442;
	Mon, 30 Jan 2023 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087126;
	bh=fm2vkAPAuvmLAqg53aBKenO79zZeboA+dZK2XykHyS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTfb2YkbljCPK7a6oLLiYpEVgeWyY7rl3OJ8ntTSQYnXcIwp1vEZexa4Ac3INO6Si
	 xucDM0JA9DtywjkNuKrLK+jPQ2qSuItKUX8bUW3lymwP2OT7pq6u8mUcTZc2GnwtSd
	 K/t2MIUsn6M8ZyQjYlKiJ5mJMU7n6fjzMfbGVvkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Marek Vasut <marex@denx.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/313] gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode
Date: Mon, 30 Jan 2023 14:48:30 +0100
Message-Id: <20230130134340.141752442@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8e88a0feebb241cab0253698b2f7358b6ebec802 ]

Always configure GPIO pins which are used as interrupt source as INPUTs.
In case the default pin configuration is OUTPUT, or the prior stage does
configure the pins as OUTPUT, then Linux will not reconfigure the pin as
INPUT and no interrupts are received.

Always configure the interrupt source GPIO pin as input to fix the above case.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 07bd1a6cc7cbb ("MXC arch: Add gpio support for the whole platform")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 6cc98a5684ae..dd91908c72f1 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -210,7 +210,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 
 	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 
-	return 0;
+	return port->gc.direction_input(&port->gc, gpio_idx);
 }
 
 static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
-- 
2.39.0



