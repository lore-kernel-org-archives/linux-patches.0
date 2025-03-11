Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385DD25E821;
	Tue, 11 Mar 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706976; cv=none; b=HW7qT3NhzFiHAWt8XhAx+YBamJNy5oVr/+9DnVkV/Hb81QZbC8Qk4TNF/4r4zenQ57u7hbpuljN5jFrmY384jwEyvAH8mlbfG6k96stin0bbP6VkZTt78VKADcTbFktMBonOau4vBc+AVM3noOEwTNfbCs3XGzFDV7AuIsiHCkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706976; c=relaxed/simple;
	bh=wF2gyanEkHYaLqC4+QOuM1ZzEn+uHMepywsdkRTMu+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ugJrDtOsEs8m9HlW4fvTEnqYh80FI92t9l8ya624r5L/PO3ttEqrhcEbbs+t2kSgFf1zEzq1afsanBhgrGSemdXMaGxtxDfdh+/7Xh1Z7Q9F5G/ksNCQOPnQtkxcekIke0ey+F0bv/zJ+hhuyGbQ5Oz+gFwLn7GLsD0HFyCuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGIQQ2ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGIQQ2ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D8BC4CEE9;
	Tue, 11 Mar 2025 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706976;
	bh=wF2gyanEkHYaLqC4+QOuM1ZzEn+uHMepywsdkRTMu+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGIQQ2htfjaOvudkTxJlO6JEKkR8/f5tWQCOVlV3/kVjY1RjnW8tQwXBCyG7r5plD
	 xijJPn7g5OmvjhD2k1P5rd6pbpHiGXnnILejAVXmDKJos2I04GBxlUkuQLq0uY1+V1
	 ysylYvGLFD1orOtoBlcLCVSVLp5YVEEgx8jZhvEw=
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
Subject: [PATCH 5.10 232/462] gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0
Date: Tue, 11 Mar 2025 15:58:18 +0100
Message-ID: <20250311145807.532703365@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1e6b427f2c4a2..1cb663da85e76 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -93,11 +93,12 @@ static void bcm_kona_gpio_lock_gpio(struct bcm_kona_gpio *kona_gpio,
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
@@ -109,11 +110,12 @@ static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
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



