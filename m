Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE62B9B3;
	Tue, 14 May 2024 11:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687152; cv=none; b=IxVPMZzxAAuwHaW8s0LRA250nZMQqTQ6lXZWDRP1QQRZPR0aXgc6obU++Qurq5h11Q1T4pHJRtzUDS5kZaZcOyejSYp7bfp2ninLG82dOXCNC8mlaoSEqmb+NsW8RD5sZREHgUQMLrV2vRNAvv35JsSoZVgJ/c5XOtupFnFR+Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687152; c=relaxed/simple;
	bh=iIIo3YaWZMTsTbVT2kuSfTqFZC4Y7jSZqeUdUFqkYvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjlu3xLYy8ipdej0Mh6/Q87m+BxYNN72/8NoOXnJA70SEWX4c42/S+j6JNYDJn6ONIJ+pZboDmenh6tdlpu19Gfu7vkz0g+RqAq5Nzqk9vvXClk6+Bv/eGZ0DBo5+kxr7OIvVdTn24cgg4AuXUgatowIUjhFWsKY0tR6b6dR1A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYU8lL1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYU8lL1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12770C2BD10;
	Tue, 14 May 2024 11:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687152;
	bh=iIIo3YaWZMTsTbVT2kuSfTqFZC4Y7jSZqeUdUFqkYvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYU8lL1X0zEwX5IEbsQZqAJmhzMv7rMkAWNcPGa+fTPJFKAz1/1iNcB5lh2kIFsit
	 ghaMW6AmX3SnGgygp4KWSGrC4+itINgfMF07+0nvE208LA+/Jr++E/52mvj3f0FoND
	 r2SYBrPJn6pFNZvnxGt3Dvq+mrTIKAEacdvRbpKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 82/84] pinctrl: mediatek: Fix some off by one bugs
Date: Tue, 14 May 2024 12:20:33 +0200
Message-ID: <20240514100954.768127546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3385ab72d995fc0b876818a36203bf2429445686 upstream.

These comparisons should be >= instead of > to prevent accessing one
element beyond the end of the hw->soc->pins[] array.

Fixes: 3de7deefce69 ("pinctrl: mediatek: Check gpio pin number and use binary search in mtk_hw_pin_field_lookup()")
Fixes: 184d8e13f9b1 ("pinctrl: mediatek: Add support for pin configuration dump via debugfs.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200218055247.74s2xa7veqx2do34@kili.mountain
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -610,7 +610,7 @@ static int mtk_gpio_get_direction(struct
 	const struct mtk_pin_desc *desc;
 	int value, err;
 
-	if (gpio > hw->soc->npins)
+	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
@@ -628,7 +628,7 @@ static int mtk_gpio_get(struct gpio_chip
 	const struct mtk_pin_desc *desc;
 	int value, err;
 
-	if (gpio > hw->soc->npins)
+	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
@@ -645,7 +645,7 @@ static void mtk_gpio_set(struct gpio_chi
 	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 	const struct mtk_pin_desc *desc;
 
-	if (gpio > hw->soc->npins)
+	if (gpio >= hw->soc->npins)
 		return;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
@@ -657,7 +657,7 @@ static int mtk_gpio_direction_input(stru
 {
 	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 
-	if (gpio > hw->soc->npins)
+	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
 	return pinctrl_gpio_direction_input(chip->base + gpio);
@@ -668,7 +668,7 @@ static int mtk_gpio_direction_output(str
 {
 	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 
-	if (gpio > hw->soc->npins)
+	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
 	mtk_gpio_set(chip, gpio, value);


