Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893F52F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12211C433D2;
	Wed, 12 Apr 2023 08:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288849;
	bh=EdpYzf4bxsF/rjNqfm3GUhurqL+YcdYY7WV78Fjr9JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elWybx4UA5neyGiQAsJ8E58dVqTNHWBrdlDj+Oa+/4EQ4yvB/2PD9IRFOZC0No5fC
	 pe4ZYLDWh8jA7G5ufhN9a14/BpqkV8vpriUO/p5AjffWFT+mrcjrjs/B25pPwfjPbS
	 vGJyTrCjcDFIOhMSkd3Hmx7AnnHeGr30X85FC+KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Keerthy <j-keerthy@ti.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/164] gpio: davinci: Do not clear the bank intr enable bit in save_context
Date: Wed, 12 Apr 2023 10:32:42 +0200
Message-Id: <20230412082838.562885914@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit fe092498cb9638418c96675be320c74a16306b48 ]

The interrupt enable bits might be set if we want to use the GPIO as
wakeup source. Clearing this will mean disabling of interrupts in the GPIO
banks that we may want to wakeup from.
Thus remove the line that was clearing this bit from the driver's save
context function.

Cc: Devarsh Thakkar <devarsht@ti.com>
Fixes: 0651a730924b ("gpio: davinci: Add support for system suspend/resume PM")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 59c4c48d8296b..7aff8a65002c9 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -645,9 +645,6 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
 		context->set_falling = readl_relaxed(&g->set_falling);
 	}
 
-	/* Clear Bank interrupt enable bit */
-	writel_relaxed(0, base + BINTEN);
-
 	/* Clear all interrupt status registers */
 	writel_relaxed(GENMASK(31, 0), &g->intstat);
 }
-- 
2.39.2



