Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7018E3D522C;
	Wed,  8 Apr 2026 18:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673405; cv=none; b=fwQAa+xeCucMg9XENl40YBJTzC6JmBsI+D0BueoDwZ6YcENRBQbDcIKtoTsKpUOlalhL+dM0kLhBqD2r8kD2K8XOxsWKNX4BhM1Jec5MS6jqw2m8uz9n2KvjemZuvGsZepWPopcjVDeJ8QhQwOya9YuGO6Bfoiwy5QRotEtxNbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673405; c=relaxed/simple;
	bh=bs2zepuK05dlO9JVpCD4e8rRAbfHHhcNjgraYZolqF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrWW4jx+JvfEZQO3Iryk1fxp9bX+FEot5XwZ6wC7rquKAjDp9TKooS/sTTWZ4T3CtX74B+gjAjcc6q6O+Cx8xmBR4dEwhhyJEGiuAGEhETyGpcNds5160+xyAkjaC8Q8TF/dWR8xvTNO0yy6sOGc0yMjyar7iIwDR8Kn14qu//g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fER4J921; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fER4J921"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065A2C19421;
	Wed,  8 Apr 2026 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673405;
	bh=bs2zepuK05dlO9JVpCD4e8rRAbfHHhcNjgraYZolqF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fER4J9213WDkUxQquAXovHnBajSnrYELSuuMh6lztfijUjQFf0q+VXH7IvG5Z4vtu
	 1ZABbok0tIoHazmu4IXNN48LIp4iMaIXUohgEYLmiqScSL+28u44uR5xOWK5x1lWbs
	 QL3GHQPglj4C0QNE/7s6JLH3+VUMrnuPE19oQWzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 187/277] iio: light: vcnl4035: fix scan buffer on big-endian
Date: Wed,  8 Apr 2026 20:02:52 +0200
Message-ID: <20260408175940.846918558@linuxfoundation.org>
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
@@ -103,17 +103,23 @@ static irqreturn_t vcnl4035_trigger_cons
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
@@ -381,7 +387,7 @@ static const struct iio_chan_spec vcnl40
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_LE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -395,7 +401,7 @@ static const struct iio_chan_spec vcnl40
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_LE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


