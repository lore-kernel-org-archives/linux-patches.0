Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B26262BE;
	Mon, 27 May 2024 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838160; cv=none; b=rN2Ma2FAAxXmAq5MXG5+8M2kAsfzdiLozScoQOFnANfJTjrlhCHD2GZCkKZcsmTjjJU5sp8hGCwaS4bGPdsR/JBgnt9tLKhLPcQn0TkC47rm/sGaaPKGn7XzYCuV77L1T4dreND5696caXvgJMl9MTnXh/+ieHhQEwmZ9p6jXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838160; c=relaxed/simple;
	bh=N573PKPvUwi4evaeNmeX7TG5MjNW/SQB12ptkw2x03U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0O92qqHrNXtx7IEYTjJkSCktRYWleb7KZs1p0CNCYN/exJvJaE3rfolU2X+m0F2dBcRA3izW2LN63U6yjIXludxYZ2mVQocyCr7QoCm3SNhB9pOTpgYCZCZ3tnutc2L3sfYT/BjDfAIchWmRo96VBRPZjOVyFNOnUNHdvet4S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kajXb+xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kajXb+xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95301C2BBFC;
	Mon, 27 May 2024 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838159;
	bh=N573PKPvUwi4evaeNmeX7TG5MjNW/SQB12ptkw2x03U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kajXb+xWBe3AoHlExbEci9otiuoDKnhqsWVM5ybedsDlN9ESjjGIIj4MOMeZcmWhW
	 KB/+AT/KWHWlF/8LnxCGV9RfDbj3o0EI/jjRFN+u9dgxo2lPFgkbyMZZpC6CDOY4Vz
	 GtKejLMdC7Pm/IC0RyxgdoBDlI6s5rvRWrn3+AmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Liu <JJLIU0@nuvoton.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 289/493] gpio: nuvoton: Fix sgpio irq handle error
Date: Mon, 27 May 2024 20:54:51 +0200
Message-ID: <20240527185639.768375111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Liu <jim.t90615@gmail.com>

[ Upstream commit 7f45fe2ea3b8c85787976293126a4a7133b107de ]

The generic_handle_domain_irq() function calls irq_resolve_mapping().
Thus delete a duplicative irq_find_mapping() call
so that a stack trace and an RCU stall will be avoided.

Fixes: c4f8457d17ce ("gpio: nuvoton: Add Nuvoton NPCM sgpio driver")
Signed-off-by: Jim Liu <JJLIU0@nuvoton.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240506064244.1645922-1-JJLIU0@nuvoton.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-npcm-sgpio.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-npcm-sgpio.c b/drivers/gpio/gpio-npcm-sgpio.c
index d31788b43abcc..2605706145434 100644
--- a/drivers/gpio/gpio-npcm-sgpio.c
+++ b/drivers/gpio/gpio-npcm-sgpio.c
@@ -434,7 +434,7 @@ static void npcm_sgpio_irq_handler(struct irq_desc *desc)
 	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
 	struct irq_chip *ic = irq_desc_get_chip(desc);
 	struct npcm_sgpio *gpio = gpiochip_get_data(gc);
-	unsigned int i, j, girq;
+	unsigned int i, j;
 	unsigned long reg;
 
 	chained_irq_enter(ic, desc);
@@ -443,11 +443,9 @@ static void npcm_sgpio_irq_handler(struct irq_desc *desc)
 		const struct npcm_sgpio_bank *bank = &npcm_sgpio_banks[i];
 
 		reg = ioread8(bank_reg(gpio, bank, EVENT_STS));
-		for_each_set_bit(j, &reg, 8) {
-			girq = irq_find_mapping(gc->irq.domain,
-						i * 8 + gpio->nout_sgpio + j);
-			generic_handle_domain_irq(gc->irq.domain, girq);
-		}
+		for_each_set_bit(j, &reg, 8)
+			generic_handle_domain_irq(gc->irq.domain,
+						  i * 8 + gpio->nout_sgpio + j);
 	}
 
 	chained_irq_exit(ic, desc);
-- 
2.43.0



