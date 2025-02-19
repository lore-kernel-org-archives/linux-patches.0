Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501A21CAA68;
	Wed, 19 Feb 2025 08:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955471; cv=none; b=PGr7TxHYol/6+cMI4cHwv5n16+m1Fw5nzr9dCZgaPVnqtAqhl8Iz7Vgwjf5C0xof7TYQNHnZozg2t4eqNUTyKsSb+Fkdot2OsS4yGb9EPKEKG5UMOYWTV3eJM0MzNVamxWtft/N1PPoAILZyf5nOkp1XvV1Q3Bwh6eSonMBKLu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955471; c=relaxed/simple;
	bh=gs2yJcTUFfQbt3AT2hY7KWfWyvPh/uHYFn/+2msdmYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvsoOJPld2Ektam3VywsRkk6tUofuyH7PcBqX1mxm12YjMYXKwY4c1DEJ8kfZ+xqdyggvkM+9QfUc+2nynhLitvPphSK36V5mIAr6wSpeaVH8ksXBQWBVzZfl7RfOC5fFV71DxxCVqb6IqzjgyB+8uYFEdDnllihtjAD40yV2uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoV+GPCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoV+GPCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56BBC4CED1;
	Wed, 19 Feb 2025 08:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955471;
	bh=gs2yJcTUFfQbt3AT2hY7KWfWyvPh/uHYFn/+2msdmYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoV+GPCz42LaAUZBEMINliQYOCX4PEc6xdAK+6I9Qp2S45rE7tv1L13cmMRlU/wYY
	 QmGQEjIJzrkVJQ65ytYQOfg1SbURmGDUcERZZwOvqsIipBUjACxUGZvKfioFJeGhIJ
	 gbHLnT7heH3riv8OR5rbdpDqIW6KE/zc67BoGaqQ=
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
Subject: [PATCH 6.6 017/152] gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0
Date: Wed, 19 Feb 2025 09:27:10 +0100
Message-ID: <20250219082550.708100507@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5321ef98f4427..77bd4ec93a231 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -86,11 +86,12 @@ static void bcm_kona_gpio_lock_gpio(struct bcm_kona_gpio *kona_gpio,
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
@@ -102,11 +103,12 @@ static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
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



