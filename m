Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECC02F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D19C433EF;
	Wed, 12 Apr 2023 08:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288930;
	bh=8P+j4cMOzpq5pFSKOJhnaDz7DYFGAZx0gdsMmHNXhWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHvBYLWaxSQAufg9WPG2p+pkS+GKO9Apzn8ZjXb45CQksynwKczl2BB0YO/ayhNcM
	 vWzw5iiqJGJVRaMHb1C8Bm1cCp5k+Y5GLOga5tM25yqC72g6pu1Avu2b819UlqMGHR
	 4ptMQDFujYTsdPH8JLr4aL6wPnEtM9aD3yOB7QWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@ge.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 071/164] drivers: iio: adc: ltc2497: fix LSB shift
Date: Wed, 12 Apr 2023 10:33:13 +0200
Message-Id: <20230412082839.802486650@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ian Ray <ian.ray@ge.com>

commit 6327a930ab7bfa1ab33bcdffd5f5f4b1e7131504 upstream.

Correct the "sub_lsb" shift for the ltc2497 and drop the sub_lsb element
which is now constant.

An earlier version of the code shifted by 14 but this was a consequence
of reading three bytes into a __be32 buffer and using be32_to_cpu(), so
eight extra bits needed to be skipped.  Now we use get_unaligned_be24()
and thus the additional skip is wrong.

Fixes: 2187cfeb3626 ("drivers: iio: adc: ltc2497: LTC2499 support")
Signed-off-by: Ian Ray <ian.ray@ge.com>
Link: https://lore.kernel.org/r/20230127125714.44608-1-ian.ray@ge.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ltc2497.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ltc2497.c b/drivers/iio/adc/ltc2497.c
index 17370c5eb6fe..ec198c6f13d6 100644
--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -28,7 +28,6 @@ struct ltc2497_driverdata {
 	struct ltc2497core_driverdata common_ddata;
 	struct i2c_client *client;
 	u32 recv_size;
-	u32 sub_lsb;
 	/*
 	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
@@ -65,10 +64,10 @@ static int ltc2497_result_and_measure(struct ltc2497core_driverdata *ddata,
 		 * equivalent to a sign extension.
 		 */
 		if (st->recv_size == 3) {
-			*val = (get_unaligned_be24(st->data.d8) >> st->sub_lsb)
+			*val = (get_unaligned_be24(st->data.d8) >> 6)
 				- BIT(ddata->chip_info->resolution + 1);
 		} else {
-			*val = (be32_to_cpu(st->data.d32) >> st->sub_lsb)
+			*val = (be32_to_cpu(st->data.d32) >> 6)
 				- BIT(ddata->chip_info->resolution + 1);
 		}
 
@@ -122,7 +121,6 @@ static int ltc2497_probe(struct i2c_client *client)
 	st->common_ddata.chip_info = chip_info;
 
 	resolution = chip_info->resolution;
-	st->sub_lsb = 31 - (resolution + 1);
 	st->recv_size = BITS_TO_BYTES(resolution) + 1;
 
 	return ltc2497core_probe(dev, indio_dev);
-- 
2.40.0



