Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7DA79950;
	Mon,  4 Mar 2024 21:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589132; cv=none; b=hC5Q7sgeOeZ//fW6Z8IBVwJZP6Px+DlDb5OfBHCcRe1TcSr6AL0ZZ+JxEE3S7rf4bZZ/GM7rwMsY7bR69pwHReaYsAotOI5QxgISbJvfmkCsXuXNgGrgbGBr/5iwQujqMVMRDUYJmtZIeMkk6kvGKeeBaIVLxrY6l+YNGYjB8Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589132; c=relaxed/simple;
	bh=YxrDZW0yiJ5h1TMhc8IcSGdBv4dMoatjw899kjtkHpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbIl6kjfH/xCZ1kRNgALNrqaLrjW6LCPWUcbCNRaPuSkGhHTj+Q7EU4gGtjAGKnX4UVcnsnkcaPAC5rKfqBN2Jq9czlMSQdSgCyrK7WuLayf8zuWY4JNJqFN4G/tvBwAxZvwIMd4EOuqo+MQ6th9PwJX+58SPE60bnlQaX/3rtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PONd86HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PONd86HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D64FC433F1;
	Mon,  4 Mar 2024 21:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589132;
	bh=YxrDZW0yiJ5h1TMhc8IcSGdBv4dMoatjw899kjtkHpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PONd86HJs7O4MBhqtga8lgRPtB5CwHNWhhd+irkc1wPBUkPu1uCKqHCWGetVNOd2X
	 +hWNcuKaSbGKSRolOp0ywjeS3KvO1/TtJn14GcSJWKsnjqCbgt/DIElA9fMmQxMJYc
	 7TFa4XP9gRByOjy2nQn0Z4jE52anwXmJaxEHyO7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arturas Moskvinas <arturas.moskvinas@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/215] gpio: 74x164: Enable output pins after registers are reset
Date: Mon,  4 Mar 2024 21:24:23 +0000
Message-ID: <20240304211603.328264611@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arturas Moskvinas <arturas.moskvinas@gmail.com>

[ Upstream commit 530b1dbd97846b110ea8a94c7cc903eca21786e5 ]

Chip outputs are enabled[1] before actual reset is performed[2] which might
cause pin output value to flip flop if previous pin value was set to 1.
Fix that behavior by making sure chip is fully reset before all outputs are
enabled.

Flip-flop can be noticed when module is removed and inserted again and one of
the pins was changed to 1 before removal. 100 microsecond flipping is
noticeable on oscilloscope (100khz SPI bus).

For a properly reset chip - output is enabled around 100 microseconds (on 100khz
SPI bus) later during probing process hence should be irrelevant behavioral
change.

Fixes: 7ebc194d0fd4 (gpio: 74x164: Introduce 'enable-gpios' property)
Link: https://elixir.bootlin.com/linux/v6.7.4/source/drivers/gpio/gpio-74x164.c#L130 [1]
Link: https://elixir.bootlin.com/linux/v6.7.4/source/drivers/gpio/gpio-74x164.c#L150 [2]
Signed-off-by: Arturas Moskvinas <arturas.moskvinas@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-74x164.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-74x164.c b/drivers/gpio/gpio-74x164.c
index e00c333105170..753e7be039e4d 100644
--- a/drivers/gpio/gpio-74x164.c
+++ b/drivers/gpio/gpio-74x164.c
@@ -127,8 +127,6 @@ static int gen_74x164_probe(struct spi_device *spi)
 	if (IS_ERR(chip->gpiod_oe))
 		return PTR_ERR(chip->gpiod_oe);
 
-	gpiod_set_value_cansleep(chip->gpiod_oe, 1);
-
 	spi_set_drvdata(spi, chip);
 
 	chip->gpio_chip.label = spi->modalias;
@@ -153,6 +151,8 @@ static int gen_74x164_probe(struct spi_device *spi)
 		goto exit_destroy;
 	}
 
+	gpiod_set_value_cansleep(chip->gpiod_oe, 1);
+
 	ret = gpiochip_add_data(&chip->gpio_chip, chip);
 	if (!ret)
 		return 0;
-- 
2.43.0



