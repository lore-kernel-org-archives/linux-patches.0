Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629528C87C;
	Wed,  8 Apr 2026 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673241; cv=none; b=sL5o5Rcs5WAYFk05Puc7BtrLn83F9Qp0y0k82ezBX5oB9q/clO2xHWjkKjm52yRE5bwsN6wTowO+XcxgAkzL2IKkvOvjholpo4AXXXWX7ayllJ6xvSHfN85pDZHz8WPjqUhJ/2i79NcND8OaKpJgs4HkWSgPgy6k9qyDgVj3bgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673241; c=relaxed/simple;
	bh=2kJKQGOLc8iraUU0H+zgUmrRerEd2IgWKak+hD0ZnKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTqGodG6vJMUOdLWUXZWHYuLG240X89ESj7P71Mrzi36i8kj6Pfv/Hq08QW9JRld6Fwnq9X8IutCt4uJ+00A1kInHZPcY+cIbxctsmcKp/9oyzmclEAdWvdTkV17QizeSDn2cHnlFT1t13t9HXdH6K/1+FFMpvtp1m58dVadPFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXRng1dZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXRng1dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61FDC19421;
	Wed,  8 Apr 2026 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673241;
	bh=2kJKQGOLc8iraUU0H+zgUmrRerEd2IgWKak+hD0ZnKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXRng1dZqvVa0gIvONMQm2y76lG/Y5X7Q9BdkSSBDsCOkqXVWsmVBh5ZyhAu820Et
	 nObSoBfM+1dzJxBzPm/vgsDgglC7LWhOfag8WE69hN3g2hlLfXdYYETpJ6gORv6A8J
	 Y7K+sO0hr0jCpbCuQrifaEBl9jjRhioG/eE4Beqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 156/277] iio: adc: ti-adc161s626: fix buffer read on big-endian
Date: Wed,  8 Apr 2026 20:02:21 +0200
Message-ID: <20260408175939.696296942@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


