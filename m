Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6035A1494D9;
	Fri,  6 Dec 2024 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496275; cv=none; b=odrHDwL4AAsl2uP6su/Seuf26bJokeWU/8/3OaLL161PpkVUImc5XYQUyei9/8/2orz60HJYZIYy03s9G0aqbb3ziXW7mqZVsJ2h1Qbs+M4AfxOhKJG4yxtTWnf60cv9/WHSkRCZFSq6OPAfNYbAgse7F9Fe85mBr2M9Lo0qH6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496275; c=relaxed/simple;
	bh=ogYz/uCBaHv7o04nEhrYI89gDB6awv4KHm3Nz86ZyPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdI+moLxKGkhCFiZCWP9Vc3Vty42HvLQF+ZO6Pt7RJqRrFsRstmwPdHtuHexIyh1Wv2kdiV0kP1H9PWIDKIoSb0HJ3ruApVCylDy4IeShavMwKAFtqKal6X3MQFNS+ZGVRd3EhQ4ZXdebkLMP0fFBuYwgaLHMzhtp/BFKUhPEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEQ3hTCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEQ3hTCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C354AC4CED1;
	Fri,  6 Dec 2024 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496275;
	bh=ogYz/uCBaHv7o04nEhrYI89gDB6awv4KHm3Nz86ZyPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEQ3hTCyHq77nsutmanLUbqC6W+MjwOV43Pi2Z1uHdkDtUJf4nu+ky2irB4Z8kvbd
	 JOfaA60zla6KtfE6//TNzLFrjL7hJbQDf8DbrJQXuNtZmZ3oaEVEzbH4k0R9X8MRCd
	 FcEFnaf12sj6pxkVzeXpqMWF+D5OtgExRDCGQaZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 104/146] iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer
Date: Fri,  6 Dec 2024 15:37:15 +0100
Message-ID: <20241206143531.661696473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


