Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC950226540;
	Thu, 12 Dec 2024 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020554; cv=none; b=SwWHlZJO1MTBuycTG0juV8YHSq4yQlomOorYaNB594hpLn286NpZolkXT4/MJqrt9Ky5fxKugbT5wpBT6HUFV++7rFTSk/yHBWvCdHZMQ8lpI6WVoGPAxNeXNsCYEkES9uvNqMrSmU7ZKmIREyKWSiPgVOp3TULwYpvzYdXra2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020554; c=relaxed/simple;
	bh=DtFcX9cVAUTi4kBnJvMoiPSVMOm0QSG4fUlmfCw0KSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2jdt+/Gcrvn345i7wnHpU+xV021cnbr9ki/t5wkCV8vCz8hCV1mh89zrhYRC5FkJvXhKRCl3OtVj5kO9gVH+b4QA06r+n5MyneqGf0kgKSQh0b0lnTCQ7NlhxRZp3xlAwrVEXHTShIKKNGpbaE5MYtZr93z/8wcREoCFfwx89o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUwxAUhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUwxAUhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4049C4CECE;
	Thu, 12 Dec 2024 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020554;
	bh=DtFcX9cVAUTi4kBnJvMoiPSVMOm0QSG4fUlmfCw0KSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUwxAUhvo6lxeXo4ImRUqkgaE1/qH7TlOjk3GJLNgZqSK5e5wasqiP3OoyUfMkRYC
	 62PyMgrFjKq+56Ex3I+tqas6Bo3IojRP0CNu/bUZpLNxmQh6a/v/YSOpG91cgHqnjg
	 9sDqRp3vW2ixsIJxnBy0Ii1NCSFSq+5YBvWw2HUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 498/772] iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer
Date: Thu, 12 Dec 2024 15:57:23 +0100
Message-ID: <20241212144410.533853808@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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


