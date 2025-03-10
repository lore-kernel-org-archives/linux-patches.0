Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A676227EA0;
	Mon, 10 Mar 2025 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629580; cv=none; b=VNPzlrj13RzWfetgeNGn0HtZprHSRjx9KNF5IXp9DG0LccLICjoQWNK2zBa4T2Uz6Z1ms/9y1CXnfxTcQpsqNeNuIwc62+v+/0+Ky4jVTOmaYOx7qiNbf8IlVbDzCwuez8Uc5gpMjgwjbykfne2W3EdEd+ZqKQ0Yw+lDJM7k3Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629580; c=relaxed/simple;
	bh=pSQ8WTataX3JGaPcPpIavkIXb4yaA6K7Wx9e0rUFykw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+BqObTKIoKfb5nvihLRtSO0UbX1IxhJ5tUbzcfkLOCUBOwv4OHjlDlfanNnXVE8z1dhgoC2gVOtLHTdH/8n/DYcu/VAznOA0CDzU3r0FxUE4bAz4bZQDncb/OkTnAX0XMfsTVg6CeyJf3RKmXfnJY1x1WnDydVS9TBQGnI5ua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr0YP/Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr0YP/Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6163C4CEE5;
	Mon, 10 Mar 2025 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629580;
	bh=pSQ8WTataX3JGaPcPpIavkIXb4yaA6K7Wx9e0rUFykw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr0YP/Fnpg/BQOL7FVmiaU7nFIsOeNVQHmOTZM+9qg+lZXH0tzauZLIw9uwQ3LbkW
	 ONWXaPtlA3+H6j4Rq7inxN+jmtUzUu4LwQYhS5FVO0XwBdzTRcfWV1qCTYUd7A8bRw
	 t8tJTJehNYE9H6oG+Eru6n2a41OHyP6dLAgziJIw=
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
Subject: [PATCH 5.15 343/620] gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0
Date: Mon, 10 Mar 2025 18:03:09 +0100
Message-ID: <20250310170559.152037876@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d329a143f5ec9..c83968384904e 100644
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



