Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6A302CC0;
	Wed, 10 Dec 2025 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352109; cv=none; b=Z2cWuD7/f/GHGW0+nqtt7ygfUrk99aTc1ZrRE673uDLZNqlzVwiCir6DB9yBaFoQ16vRMu2ezrMXvsfKgu3AghDrWV5aM+8wxECyo89DI77ZXzB+rRuOZl5RW37TJzeGBftqxkJo7u+eKgTWWV94V+FD/gVka5Kd9OoJq3rOy8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352109; c=relaxed/simple;
	bh=xi8ou3VJLwoueaA01I5CqKl+PtrODXhddjk6FNdqCeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdIz0ZpXpgd1jf526IVjnKizrfriAb3pdXe9/CczZcTeur1Joc35nMsPPxS1qfvDyoHY3FCnLyq/v6kztGe7cPXUEcyM+fYXy3el3BoVfz65W1o7SCDVkpPGLTwVHMpNOXLIGGpcs6zrrK05nVUv0VXQH2SYGgwf8QNNLEUxFFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLijUdph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLijUdph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37AEC4CEF1;
	Wed, 10 Dec 2025 07:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352108;
	bh=xi8ou3VJLwoueaA01I5CqKl+PtrODXhddjk6FNdqCeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLijUdphuPMiWo+YkVb93AVK/1lOKIUQdInZwYf9lzhlwPy4nsYxvS+9RkzA1Za09
	 K39QAxOPjA2AZof41L24sHkqEolOeis5J3W3fjN4YAKTng9yjNX9fO5K7siR1cA0Jb
	 D6zteriLkKwd4CqQoGjBx024+1R3iQst/vU0I+BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 54/60] iio: adc: ad4080: fix chip identification
Date: Wed, 10 Dec 2025 16:30:24 +0900
Message-ID: <20251210072949.210814187@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit b66cddc8be7278fd14650ff9182f3794397f8b31 upstream.

Fix AD4080 chip identification by using the correct 16-bit product ID
(0x0050) instead of GENMASK(2, 0). Update the chip reading logic to
use regmap_bulk_read to read both PRODUCT_ID_L and PRODUCT_ID_H
registers and combine them into a 16-bit value.

The original implementation was incorrectly reading only 3 bits,
which would not correctly identify the AD4080 chip.

Fixes: 6b31ba1811b6 ("iio: adc: ad4080: add driver support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4080.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ad4080.c
+++ b/drivers/iio/adc/ad4080.c
@@ -125,7 +125,7 @@
 
 /* Miscellaneous Definitions */
 #define AD4080_SPI_READ						BIT(7)
-#define AD4080_CHIP_ID						GENMASK(2, 0)
+#define AD4080_CHIP_ID						0x0050
 
 #define AD4080_LVDS_CNV_CLK_CNT_MAX				7
 
@@ -445,7 +445,8 @@ static int ad4080_setup(struct iio_dev *
 {
 	struct ad4080_state *st = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(st->regmap);
-	unsigned int id;
+	__le16 id_le;
+	u16 id;
 	int ret;
 
 	ret = regmap_write(st->regmap, AD4080_REG_INTERFACE_CONFIG_A,
@@ -458,10 +459,12 @@ static int ad4080_setup(struct iio_dev *
 	if (ret)
 		return ret;
 
-	ret = regmap_read(st->regmap, AD4080_REG_CHIP_TYPE, &id);
+	ret = regmap_bulk_read(st->regmap, AD4080_REG_PRODUCT_ID_L, &id_le,
+			       sizeof(id_le));
 	if (ret)
 		return ret;
 
+	id = le16_to_cpu(id_le);
 	if (id != AD4080_CHIP_ID)
 		dev_info(dev, "Unrecognized CHIP_ID 0x%X\n", id);
 


