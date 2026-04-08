Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826262727F3;
	Wed,  8 Apr 2026 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672149; cv=none; b=Gsd28aJZEIOr6ibTUkctHcvhg3KMprZZyWRi9n1zakuthUxkpHGIiNEIw5zKMayrr+Vd+56+c3PNByogBSZDYZU7JJayjPZ6xN0OAmY8qfGlSPC32oecf3/+Lv0mKhYcyn5X8EDsWuM70psZIGXkknIwTQKidx100D2mGt76FjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672149; c=relaxed/simple;
	bh=cpZIUfyht+Uv5e8/oRx1BRePF4xghTtaSWTO2NUTCcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMbkxp0A/Vnn9HpI8uvi84GeWxu2Hx4qLotEUz7O9m1r3kgnCk2xV1FAqB2gxtnBrg1KKDC+tbCV/a9Pcdo8Pp017jTcKDr1kSDtuW+41oHygDZS6UZhbWs4Ul0e6xQ8WIYFLraZHs1QN8Tyq935+ocrTQ2IG3/hTsugr4CSrIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HamIwFhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HamIwFhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175E0C19421;
	Wed,  8 Apr 2026 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672149;
	bh=cpZIUfyht+Uv5e8/oRx1BRePF4xghTtaSWTO2NUTCcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HamIwFhR5Zp+Bnh0YWm8QuoEWNiQGVocYLO2PwmvaXRVnvghThQGnw6T4wraro9Xq
	 ATUQs8OvoQdH/eO8uA34Fa7s7fs80EXEl0JHCbK8B3b+D3jkmchpNnm3rEkRqT+dyC
	 AW0XVip7M3dwlCH8FI0YG+Ojow2Gow9xEBdWtGXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 209/312] iio: adc: ti-adc161s626: fix buffer read on big-endian
Date: Wed,  8 Apr 2026 20:02:06 +0200
Message-ID: <20260408175941.566362986@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: David Lechner <dlechner@baylibre.com>

commit 24869650dff34a6fc8fd1cc91b2058a72f9abc95 upstream.

Rework ti_adc_trigger_handler() to properly handle data on big-endian
architectures. The scan data format is 16-bit CPU-endian, so we can't
cast it to a int * on big-endian and expect it to work. Instead, we
introduce a local int variable to read the data into, and then copy it
to the buffer.

Since the buffer isn't passed to any SPI functions, we don't need it to
be DMA-safe. So we can drop it from the driver data struct and just
use stack memory for the scan data.

Since there is only one data value (plus timestamp), we don't need an
array and can just declare a struct with the correct data type instead.

Also fix alignment of iio_get_time_ns() to ( while we are touching this.

Fixes: 4d671b71beef ("iio: adc: ti-adc161s626: add support for TI 1-channel differential ADCs")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-adc161s626.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/iio/adc/ti-adc161s626.c
+++ b/drivers/iio/adc/ti-adc161s626.c
@@ -70,8 +70,6 @@ struct ti_adc_data {
 
 	u8 read_size;
 	u8 shift;
-
-	u8 buffer[16] __aligned(IIO_DMA_MINALIGN);
 };
 
 static int ti_adc_read_measurement(struct ti_adc_data *data,
@@ -114,15 +112,20 @@ static irqreturn_t ti_adc_trigger_handle
 	struct iio_poll_func *pf = private;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ti_adc_data *data = iio_priv(indio_dev);
-	int ret;
+	struct {
+		s16 data;
+		aligned_s64 timestamp;
+	} scan = { };
+	int ret, val;
+
+	ret = ti_adc_read_measurement(data, &indio_dev->channels[0], &val);
+	if (ret)
+		goto exit_notify_done;
 
-	ret = ti_adc_read_measurement(data, &indio_dev->channels[0],
-				     (int *) &data->buffer);
-	if (!ret)
-		iio_push_to_buffers_with_timestamp(indio_dev,
-					data->buffer,
-					iio_get_time_ns(indio_dev));
+	scan.data = val;
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan, iio_get_time_ns(indio_dev));
 
+ exit_notify_done:
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;


