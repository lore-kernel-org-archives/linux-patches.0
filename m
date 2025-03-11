Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6FD25D8E8;
	Tue, 11 Mar 2025 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705881; cv=none; b=giymLpiaKZhfumJECWrPfgzLELTF/7TCMdXFpvu1cHeyWZDhsS0hMWmEC1GTRdgmCtC5/YcRV+dN+6E8nvHDtwFZxwTW402gixPSZ0P73+vsYwZIK+1rg5e63zXCX2fkvjBhmz8dO3DCmA/oUqbXP7zuQeOWjr8ZiBVihGBuNfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705881; c=relaxed/simple;
	bh=9a+MV44M84iZuMiPMf7XHBxR9rLJ8BB49JtcdfHE1DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+2FMvta1cqKh2zb+Vw8G/jE8mLIZzG4xIIgRYhFWuX+EgQklmpeANcpVb0snZxqQ68EZz4XzyKDuO9NGKSiVwY1O2G6/tK6sAoRwn0o7k3bEDObRRnr3GI6g4DDDmQcxDJ/E27EH48ndBYkJPRY2P5f5jH9khja9V1PrI3yMaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QlNjj/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QlNjj/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71515C4CEEA;
	Tue, 11 Mar 2025 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705880;
	bh=9a+MV44M84iZuMiPMf7XHBxR9rLJ8BB49JtcdfHE1DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QlNjj/hdDf+biUkV1Wcy3/Zegd/vDxu44Nqu0fLMR1RqGUCD2Z2RHldMV7VurQ0T
	 2i3ha6M36Uon8ABMCVz/w+2+U7fCL/hTrvEh7sscOu90cld/mP+ACmgdmj0Ug6TL6b
	 X+J3QYbyYQhjQPegFc7YLpgndF/xliO6RGOXxbNs=
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
Subject: [PATCH 5.4 167/328] gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0
Date: Tue, 11 Mar 2025 15:58:57 +0100
Message-ID: <20250311145721.542999571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 100575973e1fd..840a4b7e6c4d1 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -94,11 +94,12 @@ static void bcm_kona_gpio_lock_gpio(struct bcm_kona_gpio *kona_gpio,
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
@@ -110,11 +111,12 @@ static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
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



