Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1550A2D5A14;
	Wed,  4 Feb 2026 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218303; cv=none; b=qvIAPIxLDtPSRhtKKAKFcfMBZ/8iDpONtjk9wMNa7xE79c3J3mWkjVFcKTobSxWOfTSVr44EuIjyIWpi91aYxboMwIgDUqVoenY2YuBUGqQRiJFISu6SThISkhEbrZKgW2VeRGtOH151nE6gZHAqsrALgN69VNdZb/IAZDStYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218303; c=relaxed/simple;
	bh=HQeaG6J06uq/VOAhgATsflV/Mqd8qmbE/uN5eKDw/Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6Sp2z5qyblaByMMpUeGu6LcY9BnawNw+c/eS88FHi4lGV7Cel8aVy/6FvA2FH3XsfIZddD8Eohq47684KqN9iycdBvt4lnN+BWecxmReGLs+ctNL225PmFQqj0hC2/d9DGkU7iqmKaPe5OowPcDCOTd5G1wAk0I1+tpJyA+vEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3m+XwUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3m+XwUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA70C4CEF7;
	Wed,  4 Feb 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218302;
	bh=HQeaG6J06uq/VOAhgATsflV/Mqd8qmbE/uN5eKDw/Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3m+XwUgXt/pIJKtwG5QoPbIhMS5/zD789oV1aI3E+CxrWXzojyy2G/yzaAVENf5/
	 Mcj6sN6OxOOrp0iWY9dKGsNNYRWSObCV/p6M3aGJdfWJJYUnnzrHuxKk+QHsNUvrFI
	 n9PdaAWZTH/6QFRYOMj2x5jHCT5kdmTUHBrIJ6bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/280] iio: chemical: scd4x: fix reported channel endianness
Date: Wed,  4 Feb 2026 15:40:11 +0100
Message-ID: <20260204143918.153535636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Fiona Klute <fiona.klute@gmx.de>

[ Upstream commit 81d5a5366d3c20203fb9d7345e1aa46d668445a2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd4x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/chemical/scd4x.c
+++ b/drivers/iio/chemical/scd4x.c
@@ -518,7 +518,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -533,7 +533,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -546,7 +546,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


