Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7B269808;
	Tue,  8 Apr 2025 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114786; cv=none; b=tFm40ghO7nho+kPDf6TbQ/K/vS4dkxjsrdObqOnse7rFt3mqNdfxgrePKDEMs3m1c004vNCBlljcwUzf16KvYBy/vIZCc16MhC7AwyEk3YUKvdoGatwcx8aMc+BCHaOQd6KG3rboC6J/kg1i+RMjW1QGNHYXHDxLGCo2ERXZ9W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114786; c=relaxed/simple;
	bh=d02v8P02q50v2ZtMZLNFxhMXR8WvXBf5rJELNJEj4Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfCIgug43l7vf+UevPtmlM7lMjaxkFikBFevPhsUEsG3d2tN+kQHi3nRTI3gmNomZNCQ/BuhiwojGLr6/tikDTY2NN4qEZIqfE2Riw6Zcf0ZoCJrsZ2EY5LCLIW6rfl+cOz9G1EZjheHbK8e3iFbBx2lSCR0Qs047v1SwFOjHmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7K+3yDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7K+3yDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955E9C4CEE5;
	Tue,  8 Apr 2025 12:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114785;
	bh=d02v8P02q50v2ZtMZLNFxhMXR8WvXBf5rJELNJEj4Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7K+3yDnhE48dbvU6Jt1wUpb4HGDJyd7R/sgmh2hYpGpK3JKKLPurv5KdPi7ad3EY
	 MxZqROANnUjrjpAvRKKOlb81G7Qt6lyxg5cP2BL6v4nf4fetX0InWs34GT+ZS+z6Tp
	 V3feOZy8/dkGn90wg2v4iqKyPuT+qCrgXGwth0IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 234/499] iio: adc: ad7768-1: set MOSI idle state to prevent accidental reset
Date: Tue,  8 Apr 2025 12:47:26 +0200
Message-ID: <20250408104857.050037770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

[ Upstream commit 2416cec859299be04d021b4cf98eff814f345af7 ]

Datasheet recommends Setting the MOSI idle state to high in order to
prevent accidental reset of the device when SCLK is free running.
This happens when the controller clocks out a 1 followed by 63 zeros
while the CS is held low.

Check if SPI controller supports SPI_MOSI_IDLE_HIGH flag and set it.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Link: https://patch.msgid.link/c2a2b0f3d54829079763a5511359a1fa80516cfb.1741268122.git.Jonathan.Santos@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 113703fb72454..6f8816483f1a0 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -574,6 +574,21 @@ static int ad7768_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	st = iio_priv(indio_dev);
+	/*
+	 * Datasheet recommends SDI line to be kept high when data is not being
+	 * clocked out of the controller and the spi clock is free running,
+	 * to prevent accidental reset.
+	 * Since many controllers do not support the SPI_MOSI_IDLE_HIGH flag
+	 * yet, only request the MOSI idle state to enable if the controller
+	 * supports it.
+	 */
+	if (spi->controller->mode_bits & SPI_MOSI_IDLE_HIGH) {
+		spi->mode |= SPI_MOSI_IDLE_HIGH;
+		ret = spi_setup(spi);
+		if (ret < 0)
+			return ret;
+	}
+
 	st->spi = spi;
 
 	st->vref = devm_regulator_get(&spi->dev, "vref");
-- 
2.39.5



