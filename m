Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4C207E10;
	Fri,  6 Dec 2024 15:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498766; cv=none; b=DbKTw9Mfk+hOZ0qfaYLwcq1JzhmzBclDmIbKh5yesIhiKJdBUtwOX65b1KFkNhlwOzbpPdtbKfIeCVTuCeRLDqfFBw4NnytWqrj5NJjN4HssXM7aYz+AckdF6KyY4F/EvljLrSMIlJdvfmnr28qVrW/LUnRJc7r+n1ze6iwZ6A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498766; c=relaxed/simple;
	bh=jZ6DtAzHhB1LMaxYytkCBFKQ5K93oN0zsU1qUdjMT44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRebJX0MxmLLca7ozXLFRiJ6Oc2wx5ce8DkfBCRpbcjLrOdKs81nlHvjQsP13zqA5PvZKHKXgCJM3jTVbWs0NipDa0NrZsvVVuAAXlDEoBe7snrXMA8zWvsQoTempawGcmf6Y7uDXaIgEddVFRZygpsexlazfBOUDNJqY300tds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsCuUaK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsCuUaK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95058C4CED1;
	Fri,  6 Dec 2024 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498766;
	bh=jZ6DtAzHhB1LMaxYytkCBFKQ5K93oN0zsU1qUdjMT44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsCuUaK0JdW/405by/TaN68caWJH805eo55fiRScQ6H6I/df5j4CZE+RAggDCluB1
	 HYhavzFHvihJu2ZXl8qbHGbSgEvNb66qlPa2uubFpDNUS623QYwdQohARiDFXMibgi
	 HtwpHep02ZIl8ajUCJA4HcVwmFs98Yhs0CvKSkbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 660/676] iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer
Date: Fri,  6 Dec 2024 15:37:59 +0100
Message-ID: <20241206143719.148921512@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 3a4187ec454e19903fd15f6e1825a4b84e59a4cd upstream.

The AD7923 was updated to support devices with 8 channels, but the size
of tx_buf and ring_xfer was not increased accordingly, leading to a
potential buffer overflow in ad7923_update_scan_mode().

Fixes: 851644a60d20 ("iio: adc: ad7923: Add support for the ad7908/ad7918/ad7928")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241029134637.2261336-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7923.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -48,7 +48,7 @@
 
 struct ad7923_state {
 	struct spi_device		*spi;
-	struct spi_transfer		ring_xfer[5];
+	struct spi_transfer		ring_xfer[9];
 	struct spi_transfer		scan_single_xfer[2];
 	struct spi_message		ring_msg;
 	struct spi_message		scan_single_msg;
@@ -64,7 +64,7 @@ struct ad7923_state {
 	 * Length = 8 channels + 4 extra for 8 byte timestamp
 	 */
 	__be16				rx_buf[12] __aligned(IIO_DMA_MINALIGN);
-	__be16				tx_buf[4];
+	__be16				tx_buf[8];
 };
 
 struct ad7923_chip_info {


