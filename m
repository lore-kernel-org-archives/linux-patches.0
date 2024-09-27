Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085CD17B515;
	Fri, 27 Sep 2024 12:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440073; cv=none; b=TnEGC/tQvtgMAi6FvN/ZoZlbzNqpN4gFrm21S62SV3T52TX3+EROtqlnWr7mhd4B+9iSWhCGTnEJs7n1pFWf/5NUB0mJFeA2YprY4WpEuJKyxLRm45QFhGSiVWolhJZNmEZD+bSx+9i9AsM/T9RL87g3OTKFzTjWQ9bY6r8rAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440073; c=relaxed/simple;
	bh=NJF4bPA27JM3fnBkScQpgb4SSg0gbq18AL+cr/SAwDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyEhoyZmFHhC987oq2+mW2TdBBGbUzLHhfVFmCZyqQWWA4HUTiMy73UNDSoLjR/l641rkcjFq2eyZ3FytxuBKVen2sVPGlCa7Ss3qqQ/3moUxDDgblpvT5safkT71PNOuzwuuZhtk2VEBK5I2Uc3PnEU7TDdWRHF3/Akq7Klcos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJ/YuBpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJ/YuBpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8162BC4CEC4;
	Fri, 27 Sep 2024 12:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440072;
	bh=NJF4bPA27JM3fnBkScQpgb4SSg0gbq18AL+cr/SAwDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJ/YuBpVZ3g5lxm5VklRVMMsgBh0OrFYHx789wH7AwkdenWKy80oCjOJE70eNk6pA
	 rYTTyevfegsx105dpQZkD/2xrgS7NLIxfcTro/fTkR9GMNbs7FsgoQk/9MKyD7rXHH
	 Yl4W08K8Ma9EDxn4Me00qvNSOCkNsMPGoba6BQso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Blocher <thomas.blocher@ek-dev.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 08/58] pinctrl: at91: make it work with current gpiolib
Date: Fri, 27 Sep 2024 14:23:10 +0200
Message-ID: <20240927121719.139907187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Blocher <thomas.blocher@ek-dev.de>

[ Upstream commit 752f387faaae0ae2e84d3f496922524785e77d60 ]

pinctrl-at91 currently does not support the gpio-groups devicetree
property and has no pin-range.
Because of this at91 gpios stopped working since patch
commit 2ab73c6d8323fa1e ("gpio: Support GPIO controllers without pin-ranges")
This was discussed in the patches
commit fc328a7d1fcce263 ("gpio: Revert regression in sysfs-gpio (gpiolib.c)")
commit 56e337f2cf132632 ("Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"")

As a workaround manually set pin-range via gpiochip_add_pin_range() until
a) pinctrl-at91 is reworked to support devicetree gpio-groups
b) another solution as mentioned in
commit 56e337f2cf132632 ("Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"")
is found

Signed-off-by: Thomas Blocher <thomas.blocher@ek-dev.de>
Link: https://lore.kernel.org/5b992862-355d-f0de-cd3d-ff99e67a4ff1@ek-dev.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 5aa9d5c533c6a..d7b66928a4e50 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1409,8 +1409,11 @@ static int at91_pinctrl_probe(struct platform_device *pdev)
 
 	/* We will handle a range of GPIO pins */
 	for (i = 0; i < gpio_banks; i++)
-		if (gpio_chips[i])
+		if (gpio_chips[i]) {
 			pinctrl_add_gpio_range(info->pctl, &gpio_chips[i]->range);
+			gpiochip_add_pin_range(&gpio_chips[i]->chip, dev_name(info->pctl->dev), 0,
+				gpio_chips[i]->range.pin_base, gpio_chips[i]->range.npins);
+		}
 
 	dev_info(dev, "initialized AT91 pinctrl driver\n");
 
-- 
2.43.0



