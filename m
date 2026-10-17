Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13F3AF665;
	Sat, 17 Oct 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255438; cv=none; b=J+6XJPwRFJyuG8CoPKG6fhBm6+uF/NN6np1hA8wyN4rjOrgRk3D6gWTWUcGNa62qcpCMLCdCEzm0RpAaPMskfRQ73QHLPUdMGQtraB3fkhoq8lmqFDBXqb7RpzyZxkpLSgp4R9qGBT0d9r6B/AvlykVbgJdeZHHQvK/CcGcrUtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255438; c=relaxed/simple;
	bh=fKvdv2AzVc3q7h1IZCwXEWbQxac7x0R0nYShica7vk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=duRKgTS7uMH3d4eC8lBOUPlN3JWIL+FuYfdQO1DacJfH5OfOHI7V074mIUv8xpY8bVProM/qdbd3bSWEXBkIv++MKKDbgu2vyvcGuVpF/LmuFGU3o3zpCD3h16TdQTK9wzKGh9FuUShpSkSs4afHFcfdVGGiH4mVeGNv60SB8/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3SAdSga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3SAdSga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9E21F000C4;
	Sat, 17 Oct 2026 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255437;
	bh=37BJhOT8x1/3cLqEXLEp7FNMZjRUqniitnRn0vHFh9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3SAdSga9ixW4+TVmM/k9l755dViAWtaiNXrpBj8J8MFH746Lnsv4KGoTI488rdwX
	 +mPUeKwMuYgxRhzDBUtFIG0MJVHs2W+r26B1PVm75Lu4wxkzZnoEkGLvBQM4LrCUEN
	 h+YlAdfGqAVLUpQEKCt7UuUHSQBrwNG/2T2ohzjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 749/869] gpiolib: wrap gpio_chip::set()
Date: Sat, 17 Oct 2026 17:59:50 +0200
Message-ID: <20261017160056.138744030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit d36058b89a4aa30865d4cfeb101bbfd1d1dcb22f ]

We have three places where we dereference the gpio_chip::set() callback.
In order to make it easier to incorporate the upcoming new variant of
this callback (one returning an integer value), wrap it in a helper so
that the dereferencing only happens once.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250220-gpio-set-retval-v2-3-bc4cfd38dae3@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: c87c9046c4e0 ("pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e73c1e1444f7d..68fa92b79137c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2722,6 +2722,17 @@ int gpiod_direction_input(struct gpio_desc *desc)
 }
 EXPORT_SYMBOL_GPL(gpiod_direction_input);
 
+static int gpiochip_set(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	lockdep_assert_held(&gc->gpiodev->srcu);
+
+	if (WARN_ON(unlikely(!gc->set)))
+		return -EOPNOTSUPP;
+
+	gc->set(gc, offset, value);
+	return 0;
+}
+
 static int gpiod_direction_output_raw_commit(struct gpio_desc *desc, int value)
 {
 	int val = !!value, ret = 0;
@@ -2758,7 +2769,9 @@ static int gpiod_direction_output_raw_commit(struct gpio_desc *desc, int value)
 		 * If we can't actively set the direction, we are some
 		 * output-only chip, so just drive the output as desired.
 		 */
-		guard.gc->set(guard.gc, gpio_chip_hwgpio(desc), val);
+		ret = gpiochip_set(guard.gc, gpio_chip_hwgpio(desc), val);
+		if (ret)
+			return ret;
 	}
 
 	if (!ret)
@@ -3390,9 +3403,7 @@ static int gpiod_set_raw_value_commit(struct gpio_desc *desc, bool value)
 		return -ENODEV;
 
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
-	guard.gc->set(guard.gc, gpio_chip_hwgpio(desc), value);
-
-	return 0;
+	return gpiochip_set(guard.gc, gpio_chip_hwgpio(desc), value);
 }
 
 /*
@@ -3417,7 +3428,7 @@ static void gpio_chip_set_multiple(struct gpio_chip *gc,
 
 		/* set outputs if the corresponding mask bit is set */
 		for_each_set_bit(i, mask, gc->ngpio)
-			gc->set(gc, i, test_bit(i, bits));
+			gpiochip_set(gc, i, test_bit(i, bits));
 	}
 }
 
-- 
2.53.0



