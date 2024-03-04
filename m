Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03611C687;
	Mon,  4 Mar 2024 21:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588147; cv=none; b=Q/LbIKDFLVefLEyBXmhUv8ZtMvGn7tEijfBD1ulMK5UkeciTchsanju/7H7X+vXh5YJSR2xglTul5ezX47Jg14Nj92H5xW/jxpqZDcBiurSAcauUXrZ1pKgbc+OKEKbV9bR+vOQq8IPqp0eZrFs8IL3cPvCXUJJJReJMdWv1Fwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588147; c=relaxed/simple;
	bh=RNBYVDNRBh/vlmNfxUQ/7DR+595fWmRNueKzu2UogZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljfohNYqbOqOcPk3SqQjXH5z6r7TxW9tRGVipar25JLH4kLllkq/VNDv6B+2KRaksiHnWIvqaTon9k4ClLLJuP7V2CKRCO/8kV5iVBYxZy11LRfzt3OStW4n94yO5hkUlsDhbuGDJFnnSX1TzcDKvT46vEceZFOSzRA0RhJCBzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCTS2bfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCTS2bfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089CAC433F1;
	Mon,  4 Mar 2024 21:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588146;
	bh=RNBYVDNRBh/vlmNfxUQ/7DR+595fWmRNueKzu2UogZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCTS2bfeDqnjtmVael9bYGVGPCHFYd53CePDenSR97+I+lLInrK30xo9xyHAk704z
	 LY5f9tPI9l2waK5GKbY43cbqYPctn4SIeCb5k8iiMKz/1+t5s6zK2XjupGXn/zERbf
	 kIe7jLmkMGloLE/Lz8DGxZDRyGPTD7z1tz+D3qPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arturas Moskvinas <arturas.moskvinas@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/42] gpio: 74x164: Enable output pins after registers are reset
Date: Mon,  4 Mar 2024 21:24:05 +0000
Message-ID: <20240304211538.936947207@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 05637d5851526..1b50470c4e381 100644
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



