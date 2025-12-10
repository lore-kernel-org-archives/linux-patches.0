Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA2F303CB0;
	Wed, 10 Dec 2025 07:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352186; cv=none; b=W8dCoahG5c8OdPXeocjbTo9ujdD8egHes4srQ+3np9i7yNenXNqfqN21QUxrmOm8E24rceXQvcjL76UEBOiGz1yntfATCg03gJ5uWNzj4lbjiJI+tjLyKKngACTlRJITttLnLLNFeavBu3JKTcBAxGCiFjIdBLofXo7rkfk4/Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352186; c=relaxed/simple;
	bh=Ezr+KbQLWHtJ5xXsOK6AQvaxBBCNc1FXQ2coqRZIPRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dufLCZXyoHG3BswT84wtyZGPGGzmwCxGU4JKMGQ/l3wqKS/eqr1sjF+xbN6S+EtctSDeezzb7SKo2i4lbK66ntA8iLWDeAFGSOVp36hERMW7cUUbjfspOgIqMdMOgeWAgMRK+0Gz5mUX/xD65x3s/m3GZ9pS+vaQgvkCalKVXN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peibbrts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peibbrts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B746C4CEF1;
	Wed, 10 Dec 2025 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352186;
	bh=Ezr+KbQLWHtJ5xXsOK6AQvaxBBCNc1FXQ2coqRZIPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peibbrts+5UDBMvrEtBPZU+B23klAbzZi9b1y0zqQeIWflAF7mudzYEsTBRJEWy07
	 BKUOlSoBfCCFbGq2smPFBu1AlEwJBqRNGwf0v+KKSebI0b0c7MM4KKmlCFdydDPze6
	 Nbk4TR93fkuiSVPWGBtAQZxJprql1DSVn32AHyhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 23/29] iio: adc: ad4080: fix chip identification
Date: Wed, 10 Dec 2025 16:30:33 +0900
Message-ID: <20251210072944.990167913@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


