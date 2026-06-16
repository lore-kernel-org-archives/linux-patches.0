Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4693D8125;
	Tue, 16 Jun 2026 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635664; cv=none; b=tXK3gO4SZGpJgnGW8l8tAFppdYKjh+l4uchUGWkMceOk7mbgoYAooocNtGFH1Eg6arnwvoLyZGYegCt9C1ZQwjx183Xx2hVH/3jA9vNkQKyh4IA2ke4Uhy6KMhpFPyFMJM6HNd8NYhSKUM6MWYoRp+znUGe5EfJSh3l7YoVZsks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635664; c=relaxed/simple;
	bh=QN/0R1EFQHXlUeAomdOpIl2OaVqNc4fO9OtVrRiOKmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ9q2TCH8sPSX/qwVrORgmazFgM1cuXKhTdpR9Iq/WuNDd5WKafxlCzdcviM5Nok/cZU5uTPugFgNNlXKRuqKE8SPIgXjoo36pWYwGOyfMqEQ+xUHKgxnyFqkjzIZsFOweCcsALAJ+bEV6wkYABZSOnOS8Xo5/sk+qoyNOuIL6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdjjBvy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdjjBvy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709C11F000E9;
	Tue, 16 Jun 2026 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635663;
	bh=PmrEwbjfMJnsAtLIeAQUsNmu28NvJFq5Yaskvgbd7kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdjjBvy9Y4HjUdDLQ63IRs94PaDJkagsfHw7jeRg54KA779rJNWrbtW7a4FRXPO6L
	 YirzDnmJT2xY/lIcwMNIxY19AWb8m0nKeDAj6Ji0oD9TcybjzfhJKYQ4lJieGBYM05
	 HIzHsuxZIYSiIr1YvU6xMDhqzeX+/xV8oQ1/3TSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 058/342] iio: dac: ad5686: fix input raw value check
Date: Tue, 16 Jun 2026 20:25:54 +0530
Message-ID: <20260616145050.965132708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

commit d01220ee5e43c65a206df827b39bf5cf5f7b9dce upstream.

Fix range check for input raw value, which is off by one, i.e., for a
10-bit DAC the max valid value is 1023, but 1 << 10 equals 1024, which
passes the previous check, allowing an out-of-range write. The issue
exists since the ad5686 driver was first introduced.

Fixes: c2f37c8dcadc ("iio: dac: New driver for AD5686R, AD5685R, AD5684R Digital to analog converters")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -154,7 +154,7 @@ static int ad5686_write_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val > (1 << chan->scan_type.realbits) || val < 0)
+		if (val >= (1 << chan->scan_type.realbits) || val < 0)
 			return -EINVAL;
 
 		mutex_lock(&st->lock);


