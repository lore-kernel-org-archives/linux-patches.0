Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7C63EA62
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5qg1rI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19B7C433CA;
	Wed, 15 Nov 2023 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078345;
	bh=kHtOanCkFyETtAVESHWCDN/wa+0+MHPpoEwEJ0wTLpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5qg1rI2rWbZUG4O+i+beXWIwp0cqoBRP/RK5nteYgkBS6AiQ6GxprNKyELZmgdS8
	 /w0gELnNJWiWEDXSRN4BcyW+Y704SZxj7fGIYDGGHbcAotdUokgsFsXLFm3k20T168
	 ugI1ydSCLIU9BhAwmBZ0G71DjL6zkUsrVXPsDyyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/379] pinctrl: renesas: rzg2l: Make reverse order of enable() for disable()
Date: Wed, 15 Nov 2023 14:25:40 -0500
Message-ID: <20231115192700.807223910@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2a617832a7e60..159812fe1c97c 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -1173,6 +1173,8 @@ static void rzg2l_gpio_irq_disable(struct irq_data *d)
 	u32 port;
 	u8 bit;
 
+	irq_chip_disable_parent(d);
+
 	port = RZG2L_PIN_ID_TO_PORT(hwirq);
 	bit = RZG2L_PIN_ID_TO_PIN(hwirq);
 
@@ -1187,7 +1189,6 @@ static void rzg2l_gpio_irq_disable(struct irq_data *d)
 	spin_unlock_irqrestore(&pctrl->lock, flags);
 
 	gpiochip_disable_irq(gc, hwirq);
-	irq_chip_disable_parent(d);
 }
 
 static void rzg2l_gpio_irq_enable(struct irq_data *d)
-- 
2.42.0



