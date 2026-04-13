Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8C730C361;
	Mon, 13 Apr 2026 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098272; cv=none; b=qXacECj9C1/L/+IyPgMlpPwAUPbPtJWR+W28EgPCbkxGyqf6Et3jcRm1AMbv8OYnu4/oS7/8JzPYvzz8u2E0nQe97xQtqXvOKPWElUowTD/yeQI0U4x7n5ZIiy05gGObhVxMYYwMF5dairBC9y+LuvWrebrwTc968RgWN3r4oao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098272; c=relaxed/simple;
	bh=e/crhs7Z8/RzLHgeA/J/9KH1LmHdK92x8T7k6drX6TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6oWOLuaE4sQ3e0nfY0sT92ZpIPapN5tL2Pw+rMOgm0COy4mPp7LCNn/v93eI6tjQOH7GFGe1+XFDXk7kjZIAXuXTX+uI9SW0B41k0MpbATxJ6urbB0y6/+ScjcxsFmn/KZnC2yv0uYEPNev+7no8Fght0gaiJ6HCNqUEfThEyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPPlQQoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPPlQQoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADA3C2BCB3;
	Mon, 13 Apr 2026 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098272;
	bh=e/crhs7Z8/RzLHgeA/J/9KH1LmHdK92x8T7k6drX6TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPPlQQoOUktlP36yXY6mt2+GLbPJjZO+l4g5EVWMV9/4n9YVnU15pZOFmf4iwaM/K
	 POQd7iCZSUCZUuPi9BgEBeOafMPkzKmmUIqY8ZU8Z6axpay49asmnhBvdLD2mBaucB
	 J5XBhhaQ2tf00oyuafz6Q4zjN6zBtD2BhmJQDUe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 460/570] iio: light: vcnl4035: fix scan buffer on big-endian
Date: Mon, 13 Apr 2026 17:59:51 +0200
Message-ID: <20260413155847.702386476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -378,7 +384,7 @@ static const struct iio_chan_spec vcnl40
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_LE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -392,7 +398,7 @@ static const struct iio_chan_spec vcnl40
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_LE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


