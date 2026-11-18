Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048719;
	b=gp+JxowmnnWXQVJeg/v2LzRRBC3vdONYtDlRP9igeGT4H+AuaAHXdsjDKl77rJCZtT0x
	 PciJW95wH08Ueoj4of+MIRJXP8cJFTypGUd9jOIxiCIj9DM42qGhVDFTaNHkML7dXZvOX
	 fFCHKH42erqeYLHF3YqbINyfIynZaDLoXR/W8kkYHvdZsAV6sIWlaw6G3whtFZhX/GMfa
	 Q1ghrwTmwcf5zh2kfIF5NjtWfGVk+KLdwQrhsKn2dibD+HJk8u87OXTder7uj/e6K3BEo
	 W/H3+eybSAWyy8mCoy7SxBC8p4dZIHAo11tlwfNFdBETkZGjg0MMLTpoPREB35J1/2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AKz48fEs52fnaiFTmLRGWXuUS4XeIs8+PPRFy1uN6HQ=;
	b=K0xB6LCNAT1Tzf89imtc2uDI9wmZk7kGLPTitfqyElm7VPuLU3aRK1k/HMhwliLbj15Y
	 j0bM+BF1LPROZQyk12hUtlYx4RRKGhlRicn9B4ZqRm4w09bwhLKdvYUjT2KYd2NGRffB4
	 yBFc3dbTkmbA7cOA11GRhjKpWDtUKm2+3MBE3VIN6B30b9s1HlbzhjjxMWMWK2UPhQbUz
	 T49/nJl3Ul6xt+BoUG0axu98kAvh7c6Frrk4v5Sud3/5BGpEdvaof0bUnMS1D0yeRbwCt
	 PTj2KKCYcyCLE/c8DBH6mrGsbrMFbV0C6fPGlOSSsnc85z5hMAKZ+XS1foQar5Tmylw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j9Ga/xqn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A1B606A31C;
	Thu, 19 Nov 2026 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9Ga/xqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBD31F000C4;
	Thu, 19 Nov 2026 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048719;
	bh=AKz48fEs52fnaiFTmLRGWXuUS4XeIs8+PPRFy1uN6HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9Ga/xqnQXomNRo/rYezb5hu/+y75Qy6DvbtX57zRc566mAr8CHr3Ojhywvs1TrGj
	 7h4j3NFfhjcNMHhhT4AW98xxiwheuXy9E7VApqFIkqh/C6yrcEUYK/B5x/G92yzNL+
	 45GsO0cu/pPFK6hG+0l9BN3cpSgQciEfL7gHr0As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Maxwell Doose <maxwell@maxwelld.cc>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2095/2857] staging: iio: adc: ad7816: Serialize SPI operations
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150316.840094515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit 8f99c766605a484663764b52da56a0b160f9d9c3 ]

The ad7816_spi_read() and ad7816_spi_write() functions perform a
sequence of GPIO state changes followed by an SPI transfer. If multiple
operations occur simultaneously, the GPIO state could be changed by one
thread while another is in the middle of a transfer, leading to a race
condition.

Introduce a mutex to serialize the operations, ensuring that the GPIO
toggling and the SPI transfer are treated as a single atomic operation.
The mutex is placed right after the pointers in the device state
structure to avoid padding holes.

Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Reviewed-by: Maxwell Doose <maxwell@maxwelld.cc>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: b96187644664 ("staging: iio: adc: ad7816: Protect sysfs attributes with mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index 6a402e8877605..ade1b8db197d4 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -5,12 +5,14 @@
  * Copyright 2010 Analog Devices Inc.
  */
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 #include <linux/sysfs.h>
@@ -47,6 +49,7 @@ struct ad7816_chip_info {
 	struct gpio_desc *rdwr_pin;
 	struct gpio_desc *convert_pin;
 	struct gpio_desc *busy_pin;
+	struct mutex lock; /* protect device state during SPI transfers */
 	u8  oti_data[AD7816_CS_MAX + 1];
 	u8  channel_id;	/* 0 always be temperature */
 	u8  mode;
@@ -67,6 +70,8 @@ static int ad7816_spi_read(struct ad7816_chip_info *chip, u16 *data)
 	int ret;
 	__be16 buf;
 
+	guard(mutex)(&chip->lock);
+
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
 	ret = spi_write_then_read(spi_dev, &chip->channel_id, sizeof(chip->channel_id), NULL, 0);
@@ -107,6 +112,8 @@ static int ad7816_spi_write(struct ad7816_chip_info *chip, u8 data)
 	struct spi_device *spi_dev = chip->spi_dev;
 	int ret;
 
+	guard(mutex)(&chip->lock);
+
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
 	ret = spi_write_then_read(spi_dev, &data, sizeof(data), NULL, 0);
@@ -362,6 +369,10 @@ static int ad7816_probe(struct spi_device *spi_dev)
 	/* this is only used for device removal purposes */
 	dev_set_drvdata(&spi_dev->dev, indio_dev);
 
+	ret = devm_mutex_init(&spi_dev->dev, &chip->lock);
+	if (ret)
+		return ret;
+
 	chip->spi_dev = spi_dev;
 	for (i = 0; i <= AD7816_CS_MAX; i++)
 		chip->oti_data[i] = 203;
-- 
2.53.0



