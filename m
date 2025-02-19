Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3301D515B;
	Wed, 19 Feb 2025 09:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957293; cv=none; b=oktpNpboiilgmQQ7LkLC9c+gDIyHrVBPIoOEDScATPfHpDYCTBdx53R9KU+xMK1Ah6gKAamYYRkA83JxdPp2dTuEQ03kqO6l8ZIZkl3PZHKoinhqcMjfdS/zm7SzWDhnsT2h6/mVYY5BNzuAeptf9n7YsitxSWRrycuxYH2I9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957293; c=relaxed/simple;
	bh=wpyUJGgwRsuaC/LPo2qOD/qGafYkNI/wDQTOaWz/UBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uij4NHbbrb2M9+hwerT2Wp2JlsWRalnYTxUky58noGGxB/wCBpeUxfwmrx3JUivyf0+YX29ycpL3vkOR6T1cAUyhMlNW6wldSdKG9Maoz/AW1t0K4yraOEbBIY3NtlrCaxNh/Zq/k/WBKHDKeVTYIM8iNYBIxqqL7myU95gskhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1eGWNmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1eGWNmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340A9C4CED1;
	Wed, 19 Feb 2025 09:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957293;
	bh=wpyUJGgwRsuaC/LPo2qOD/qGafYkNI/wDQTOaWz/UBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1eGWNmEitcbjfS8OSAy0CP07jF2AyNGWdsp1+McoZasY5LlN9tMQJQKgk3Ea8FvZ
	 EZUSQkwXM1QPghukROAW5jFSb2tzy+BqfsWAFDITrx9BPiMDZgP/diHFLA+M4H11af
	 H2e4GSCLQs5jW/8h/Lt+8C0O/dIWT6V1OYZIKVjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 475/578] gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0
Date: Wed, 19 Feb 2025 09:27:59 +0100
Message-ID: <20250219082711.689940459@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit de1d0d160f64ee76df1d364d521b2faf465a091c ]

The GPIO lock/unlock functions clear/write a bit to the relevant
register for each bank. However, due to an oversight the bit that
was being written was based on the total GPIO number, not the index
of the GPIO within the relevant bank, causing it to fail for any
GPIO above 32 (thus any GPIO for banks above bank 0).

Fix lock/unlock for these banks by using the correct bit.

Fixes: bdb93c03c550 ("gpio: bcm281xx: Centralize register locking")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250206-kona-gpio-fixes-v2-1-409135eab780@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-bcm-kona.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 70770429ba483..7e8adc5cc15a0 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -85,11 +85,12 @@ static void bcm_kona_gpio_lock_gpio(struct bcm_kona_gpio *kona_gpio,
 	u32 val;
 	unsigned long flags;
 	int bank_id = GPIO_BANK(gpio);
+	int bit = GPIO_BIT(gpio);
 
 	raw_spin_lock_irqsave(&kona_gpio->lock, flags);
 
 	val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
-	val |= BIT(gpio);
+	val |= BIT(bit);
 	bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
 
 	raw_spin_unlock_irqrestore(&kona_gpio->lock, flags);
@@ -101,11 +102,12 @@ static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
 	u32 val;
 	unsigned long flags;
 	int bank_id = GPIO_BANK(gpio);
+	int bit = GPIO_BIT(gpio);
 
 	raw_spin_lock_irqsave(&kona_gpio->lock, flags);
 
 	val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
-	val &= ~BIT(gpio);
+	val &= ~BIT(bit);
 	bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
 
 	raw_spin_unlock_irqrestore(&kona_gpio->lock, flags);
-- 
2.39.5



