Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1048229B18;
	Mon,  2 Jun 2025 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875190; cv=none; b=WqYj1K50i5jmMnJRD6UrkQ0ysAoKpQY+v2Da7azB5vMNh2F6Qfe51cpjU1NaK3KgMCuRioZP+GL6wzCg6LxxtE7EwxE7TJjEthJ3tDPXdWAyOyjhKbLk7kZDejOQjusY56UBiWS3UZo5YZqHJ8a/qB7OIZoXx0Vkn5ZpHUi7k30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875190; c=relaxed/simple;
	bh=ScRBQD0FuN+KdxINNlK9XmUrNHeh9lZdXz2oywGyhBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPCjSopqkzLnICSBe3m0r2OIylr0myick80TibVIhnlAgn5r1jmGPcz+xSZUZ8rmumI0uffRd4SL2lkCn2akiGOHgk0HZeKiAJVShZ8lYXtTl/GfTAUbPKRfMcisaZalHz3FZWBHIAulASQJXU6vnBuGy5VrUxgGbtrfpQkQJpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va5X4fbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va5X4fbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F89C4CEEB;
	Mon,  2 Jun 2025 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875190;
	bh=ScRBQD0FuN+KdxINNlK9XmUrNHeh9lZdXz2oywGyhBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Va5X4fbFd7+udK4b+gulxJup9KhFiUSdiqniTBwtwtFF6zi26VD0/HUwIVx2hRrsU
	 2YxB0Oyu3/2FVCWpYX1YnJJwqIluHvhiLvocORi7omNiUvPJA1ul3CBbRIxTvEmPy/
	 QNFvfjQ3qEvARZVtmdoW0Qvs9d4FsGfYJq1m8jXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 056/270] staging: iio: adc: ad7816: Correct conditional logic for store mode
Date: Mon,  2 Jun 2025 15:45:41 +0200
Message-ID: <20250602134309.485494585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 2e922956277187655ed9bedf7b5c28906e51708f upstream.

The mode setting logic in ad7816_store_mode was reversed due to
incorrect handling of the strcmp return value. strcmp returns 0 on
match, so the `if (strcmp(buf, "full"))` block executed when the
input was not "full".

This resulted in "full" setting the mode to AD7816_PD (power-down) and
other inputs setting it to AD7816_FULL.

Fix this by checking it against 0 to correctly check for "full" and
"power-down", mapping them to AD7816_FULL and AD7816_PD respectively.

Fixes: 7924425db04a ("staging: iio: adc: new driver for AD7816 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/stable/20250414152920.467505-1-gshahrouzi%40gmail.com
Link: https://patch.msgid.link/20250414154050.469482-1-gshahrouzi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/adc/ad7816.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -136,7 +136,7 @@ static ssize_t ad7816_store_mode(struct
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ad7816_chip_info *chip = iio_priv(indio_dev);
 
-	if (strcmp(buf, "full")) {
+	if (strcmp(buf, "full") == 0) {
 		gpiod_set_value(chip->rdwr_pin, 1);
 		chip->mode = AD7816_FULL;
 	} else {


