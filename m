Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCCC13473B;
	Tue, 23 Jan 2024 01:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971932; cv=none; b=aKLL+/MojtgmhKQO24yrjJgQLdGLIH097ykkdgAaIpP1rMO74Axff2yIBaOJcoWCIn+dXrgF4m1iYtnS/VxzGPqFR4RYAsnkFKqS/YhleKY6TXwbsx0RYPN0Gp0gXX3Cr/vlI7zMGVrTlFptngO7tjUHYvdqJwVLFBjBkLjKOuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971932; c=relaxed/simple;
	bh=NDSHDBEms2jHIf3fkT/117ovDhGzdN2w7DZup1a+7o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfA3jYj8P4SmI2RrHnNOurg/eynWpZ4VXaqPs8R0HB8eqYuL/zoEvDz247enNFdx4eVHEBN1ndpMB2A1KffelBTtwxRiQe4M/nv37Hp7p8+WsqAB0aCcEc4QCZDFIOKsY1RncYGkBkX4cJEQDet/PlhBF7aalhMkkWPL1ZNLTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTunK5g1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTunK5g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE84C433F1;
	Tue, 23 Jan 2024 01:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971932;
	bh=NDSHDBEms2jHIf3fkT/117ovDhGzdN2w7DZup1a+7o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTunK5g1G9titcqM0vAUxh+hLshMQR/qTf9L8oHetwf7kTGeMVV70EGCxsCkPz1UU
	 +4XOqgq+fQBzlubm6q05vtk9PVU+lTi84zVmIObDzWh2dYqpiJ9bgEwKxSaKQ2r6v3
	 hMUgq7/DQ3YN9ArWjV251tqayK6vT1WyM3bR/PEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/286] iio: adc: ad9467: fix reset gpio handling
Date: Mon, 22 Jan 2024 15:59:15 -0800
Message-ID: <20240122235741.655283582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 76f028539cf360f750efd8cde560edda298e4c6b ]

The reset gpio was being handled with inverted polarity. This means that
as far as gpiolib is concerned we were actually leaving the pin asserted
(in theory, this would mean reset). However, inverting the polarity in
devicetree made things work. Fix it by doing it the proper way and how
gpiolib expects it to be done.

While at it, moved the handling to it's own function and dropped
'reset_gpio' from the 'struct ad9467_state' as we only need it during
probe. On top of that, refactored things so that we now request the gpio
asserted (i.e in reset) and then de-assert it. Also note that we now use
gpiod_set_value_cansleep() instead of gpiod_direction_output() as we
already request the pin as output.

Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231207-iio-backend-prep-v2-1-a4a33bc4d70e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index 92837dcbc170..f2620dcd2a2c 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -121,7 +121,6 @@ struct ad9467_state {
 	unsigned int			output_mode;
 
 	struct gpio_desc		*pwrdown_gpio;
-	struct gpio_desc		*reset_gpio;
 };
 
 static int ad9467_spi_read(struct spi_device *spi, unsigned int reg)
@@ -378,6 +377,21 @@ static int ad9467_preenable_setup(struct adi_axi_adc_conv *conv)
 	return ad9467_outputmode_set(st->spi, st->output_mode);
 }
 
+static int ad9467_reset(struct device *dev)
+{
+	struct gpio_desc *gpio;
+
+	gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR_OR_NULL(gpio))
+		return PTR_ERR_OR_ZERO(gpio);
+
+	fsleep(1);
+	gpiod_set_value_cansleep(gpio, 0);
+	fsleep(10 * USEC_PER_MSEC);
+
+	return 0;
+}
+
 static int ad9467_probe(struct spi_device *spi)
 {
 	const struct ad9467_chip_info *info;
@@ -406,18 +420,9 @@ static int ad9467_probe(struct spi_device *spi)
 	if (IS_ERR(st->pwrdown_gpio))
 		return PTR_ERR(st->pwrdown_gpio);
 
-	st->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
-						 GPIOD_OUT_LOW);
-	if (IS_ERR(st->reset_gpio))
-		return PTR_ERR(st->reset_gpio);
-
-	if (st->reset_gpio) {
-		udelay(1);
-		ret = gpiod_direction_output(st->reset_gpio, 1);
-		if (ret)
-			return ret;
-		mdelay(10);
-	}
+	ret = ad9467_reset(&spi->dev);
+	if (ret)
+		return ret;
 
 	spi_set_drvdata(spi, st);
 
-- 
2.43.0



