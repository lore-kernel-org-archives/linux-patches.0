Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180C7207E14;
	Tue,  8 Apr 2025 11:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111390; cv=none; b=nh0Wrhqy8X91uxdBEKlW0DslNeZP9GlXwNt91AT44Z1h1bd2bmt0ILwQcpawn/pL3SLLznTkLPEfgyiQHWiB9jKnh2MCHT02i58BzcaNBGOZNaVD0l++mnobUGxo85TsMRU8i/Nfa4bIdN6N1TKB1yepODOD6rnhT0TnFWCKfIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111390; c=relaxed/simple;
	bh=1G+r4Y1rJST+LSI+VoIPfkRxZ+Jh6VAlR45f2N4MB00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJdL1Tjdaoq2hWvwpDEqMMgJPEXyc1+DFxncPhSqD8sA/WIxaD9ePknMYX+nxVLE48kROnD8oGah7tRWMzsjz4BOeAjC2LBBYQOlSqBvi3lRuCq6iSFPH9CqL+cph6RnrTYJfytetMEOnhNNG/mpd81w497ihvG7OPJ6Hx0baG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdvw2q0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdvw2q0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F87AC4CEE5;
	Tue,  8 Apr 2025 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111390;
	bh=1G+r4Y1rJST+LSI+VoIPfkRxZ+Jh6VAlR45f2N4MB00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdvw2q0s8R7dHK6/oDPLlf9GKn1v3B9/F68PsEzg8TIeaS8p04iU14X1Wpigh5WU2
	 dMNgYIbeT+pBASmt/2OM2xHcnBnT0HQFg62QEb2HZD5BTQ/taMgWGhvFJsu0wnFLUS
	 F/ciuyc1WaPiW+a94sZMCtpf/BK1GqM+vTtEYU4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 414/731] pinctrl: bcm2835: dont -EINVAL on alternate funcs from get_direction()
Date: Tue,  8 Apr 2025 12:45:11 +0200
Message-ID: <20250408104923.905062697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 75f87f5d04f73645136d7a603c331d844fc5704a ]

Since commit 9d846b1aebbe ("gpiolib: check the return value of
gpio_chip::get_direction()") we check the return value of the
get_direction() callback as per its API contract. This driver returns
-EINVAL if the pin in question is set to one of the alternative
(non-GPIO) functions. This isn't really an error that should be
communicated to GPIOLIB so default to returning the "safe" value of
INPUT in this case. The GPIO subsystem does not have the notion of
"unknown" direction.

Fixes: 9d846b1aebbe ("gpiolib: check the return value of gpio_chip::get_direction()")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/Z7VFB1nST6lbmBIo@finisterre.sirena.org.uk/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/20250219102750.38519-1-brgl@bgdev.pl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index cc1fe0555e196..eaeec096bc9a9 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -346,14 +346,14 @@ static int bcm2835_gpio_get_direction(struct gpio_chip *chip, unsigned int offse
 	struct bcm2835_pinctrl *pc = gpiochip_get_data(chip);
 	enum bcm2835_fsel fsel = bcm2835_pinctrl_fsel_get(pc, offset);
 
-	/* Alternative function doesn't clearly provide a direction */
-	if (fsel > BCM2835_FSEL_GPIO_OUT)
-		return -EINVAL;
-
-	if (fsel == BCM2835_FSEL_GPIO_IN)
-		return GPIO_LINE_DIRECTION_IN;
+	if (fsel == BCM2835_FSEL_GPIO_OUT)
+		return GPIO_LINE_DIRECTION_OUT;
 
-	return GPIO_LINE_DIRECTION_OUT;
+	/*
+	 * Alternative function doesn't clearly provide a direction. Default
+	 * to INPUT.
+	 */
+	return GPIO_LINE_DIRECTION_IN;
 }
 
 static void bcm2835_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
2.39.5



