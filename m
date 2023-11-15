Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D393A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvEDpMdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA825C433C8;
	Wed, 15 Nov 2023 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077646;
	bh=qzV9xhw7TGgj1vs7RrBaMc2gUSJ+JC9z9EEUT95m8Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvEDpMdFjQxXzOKJHmclRkFMKlG2+mKLvi86PzN5LBkGmJz40Ih27qRvXmZdHCO7I
	 3NhSLTqMOax2dCcBOS9r9n/y9twgy7uEFCwVLXa3XifQNVUxBvxYhfDef7Ne+1isIQ
	 0L5jWzNJ5Yn9YltAqQyvTNQBBvZJnPGjtGkyQtsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 432/603] pinctrl: renesas: rzg2l: Make reverse order of enable() for disable()
Date: Wed, 15 Nov 2023 14:16:17 -0500
Message-ID: <20231115191642.723612388@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit dd462cf53e4dff0f4eba5e6650e31ceddec74c6f ]

We usually do reverse order of enable() for disable(). Currently, the
ordering of irq_chip_disable_parent() is not correct in
rzg2l_gpio_irq_disable(). Fix the incorrect order.

Fixes: db2e5f21a48e ("pinctrl: renesas: pinctrl-rzg2l: Add IRQ domain to handle GPIO interrupt")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230918123355.262115-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 37cdfe4b04f9a..2ea6ef99cc70b 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -1175,6 +1175,8 @@ static void rzg2l_gpio_irq_disable(struct irq_data *d)
 	u32 port;
 	u8 bit;
 
+	irq_chip_disable_parent(d);
+
 	port = RZG2L_PIN_ID_TO_PORT(hwirq);
 	bit = RZG2L_PIN_ID_TO_PIN(hwirq);
 
@@ -1189,7 +1191,6 @@ static void rzg2l_gpio_irq_disable(struct irq_data *d)
 	spin_unlock_irqrestore(&pctrl->lock, flags);
 
 	gpiochip_disable_irq(gc, hwirq);
-	irq_chip_disable_parent(d);
 }
 
 static void rzg2l_gpio_irq_enable(struct irq_data *d)
-- 
2.42.0



