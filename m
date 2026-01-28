Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E842E06ED;
	Wed, 28 Jan 2026 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614612; cv=none; b=uO5vjVfV1crOYNILJFOtMUY9e+1uxlPp/tZk0/OLpYsYmKEwS56NXZGB7ag94IWct82U1u8lgdPSkqh9P9AMfMp6ZV77LESjYXEe0YTncMSTm2XnN6PK3lEjwPsp7gVt/L5uPgN6bY9mzyF/3oNtTnghCgusYE5foolG0kQYu2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614612; c=relaxed/simple;
	bh=5IuL+YEThGIZfXNlo50ol9DkjnJi23lHfPA+Ck04LSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=An6R4HD7MlO5zg8uC5O2nKjLyD9PNwF4CfL6oss+uzbop2hBG03GBaQf7eT44W9Ci9l4VvQl1hbhlHqWzKI5oWcbfIhO77kWmBio4EsWlRB5W66WSQSQ3oy6m1onepwOg4XIxqc/GcmWgkSO/j+ovhhgd9XjlAuwFuYatY6ZW6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Whz3ubS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Whz3ubS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABBFC4CEF1;
	Wed, 28 Jan 2026 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614611;
	bh=5IuL+YEThGIZfXNlo50ol9DkjnJi23lHfPA+Ck04LSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Whz3ubSdjU3QviCzSqBa2q52CpMZabZAtwd3D50zyoJtsm0327eX2vUUcx2Rgu1k
	 WsUcwMozL2fs9UkvgICvy1E05FQ7iNXyBkUvYL6ybcnZ1fXtbxWsPVMrND2hrruqHp
	 HqekAV7RQW+1G5WYi0ht8lEIBNhiG/NmFNyi+fSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 190/254] iio: chemical: scd4x: fix reported channel endianness
Date: Wed, 28 Jan 2026 16:22:46 +0100
Message-ID: <20260128145351.636745067@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fiona Klute <fiona.klute@gmx.de>

commit 81d5a5366d3c20203fb9d7345e1aa46d668445a2 upstream.

The driver converts values read from the sensor from BE to CPU
endianness in scd4x_read_meas(). The result is then pushed into the
buffer in scd4x_trigger_handler(), so on LE architectures parsing the
buffer using the reported BE type gave wrong results.

scd4x_read_raw() which provides sysfs *_raw values is not affected, it
used the values returned by scd4x_read_meas() without further
conversion.

Fixes: 49d22b695cbb6 ("drivers: iio: chemical: Add support for Sensirion SCD4x CO2 sensor")
Signed-off-by: Fiona Klute <fiona.klute@gmx.de>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd4x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/chemical/scd4x.c
+++ b/drivers/iio/chemical/scd4x.c
@@ -585,7 +585,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -600,7 +600,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -613,7 +613,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


