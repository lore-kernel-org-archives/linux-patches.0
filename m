Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5158632F765;
	Mon, 13 Apr 2026 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099548; cv=none; b=P63+UcUySkJx4nrE4VQXTQyJ1l337l0fluUb2yhML/nYCgwfIMi3yMEPlPl/I2NKpq2UpPCkf0q2MQp5/Rum/6uJVOl+pEaTPiU0HKuiWd6u1LZBz5CAVZ8rZD7xan6ApGMhDsVFKiBlCV2pSa6LA4BY01GECdxu4y4JaK1E38U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099548; c=relaxed/simple;
	bh=mi4ZtdEgAxGfxxokyFMxnTrcSCkYIxK80pQenFS/uBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4BuXJPmAxUn7+EJPEFE9ELTmiUyaKIDoc3xpXwK24KCg5AvFQn4L4opmxcX8YupNO8Ele9Oo9/6xtiXE4g8UxxmxjXX8+tIFG7mPe4bF5Ma0I9wd+P9sDGGo+gFQB8sDpgPbJAp/3/pMn7Ab9fM8tQpMXEyR6f1+c5+k7gby0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmqpEBbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmqpEBbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7004C2BCAF;
	Mon, 13 Apr 2026 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099548;
	bh=mi4ZtdEgAxGfxxokyFMxnTrcSCkYIxK80pQenFS/uBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmqpEBbHhFXiw6krw9QtdqTUF2zJu+V/vDI/5b05s4+1e73Rzc/NAY6ZIujh+i0NC
	 b04lKYMwNAkL3EgNwy7+xmjxOZG8ZJR47LBFaRdDjxtkqC2Mlwg97OI4DXTe0KikDS
	 uoxpBBPwoT+GenAvsuMksMo8g0m8eg12J7rys6PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 381/491] iio: light: vcnl4035: fix scan buffer on big-endian
Date: Mon, 13 Apr 2026 18:00:26 +0200
Message-ID: <20260413155833.296524451@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit fdc7aa54a5d44c05880a4aad7cfb41aacfd16d7b upstream.

Rework vcnl4035_trigger_consumer_handler() so that we are not passing
what should be a u16 value as an int * to regmap_read(). This won't
work on bit endian systems.

Instead, add a new unsigned int variable to pass to regmap_read(). Then
copy that value into the buffer struct.

The buffer array is replaced with a struct since there is only one value
being read. This allows us to use the correct u16 data type and has a
side-effect of simplifying the alignment specification.

Also fix the endianness of the scan format from little-endian to CPU
endianness. Since we are using regmap to read the value, it will be
CPU-endian.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -105,17 +105,23 @@ static irqreturn_t vcnl4035_trigger_cons
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4035_data *data = iio_priv(indio_dev);
 	/* Ensure naturally aligned timestamp */
-	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8) = { };
+	struct {
+		u16 als_data;
+		aligned_s64 timestamp;
+	} buffer = { };
+	unsigned int val;
 	int ret;
 
-	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, (int *)buffer);
+	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, &val);
 	if (ret < 0) {
 		dev_err(&data->client->dev,
 			"Trigger consumer can't read from sensor.\n");
 		goto fail_read;
 	}
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
-					iio_get_time_ns(indio_dev));
+
+	buffer.als_data = val;
+	iio_push_to_buffers_with_timestamp(indio_dev, &buffer,
+					   iio_get_time_ns(indio_dev));
 
 fail_read:
 	iio_trigger_notify_done(indio_dev->trig);
@@ -380,7 +386,7 @@ static const struct iio_chan_spec vcnl40
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_LE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -394,7 +400,7 @@ static const struct iio_chan_spec vcnl40
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_LE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


