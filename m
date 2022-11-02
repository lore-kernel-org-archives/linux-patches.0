Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F837E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0406AC433C1;
	Wed,  2 Nov 2022 02:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357983;
	bh=i+FsnbGFTN6tTpcL0ZMvMGaWZtMRklgZmpYaVlO14vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TU7mSx44lwPjIBEf+8rQP3esBL5UiQAr0+DdT+Xcsxf+eva54yHawpq+aUNTjSHP5
	 KCHExvzxTQIsIrYqo91tiBdx1lVmQYQV6CaExDkxJ3z182xlVVl/DZ8DYT9TLxkhpd
	 prCuERAWzqY15K64Vub7ANPU8rehknAdfgCbNBHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin.tanislav@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 022/132] iio: temperature: ltc2983: allocate iio channels once
Date: Wed,  2 Nov 2022 03:32:08 +0100
Message-Id: <20221102022100.209755717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cosmin Tanislav <cosmin.tanislav@analog.com>

commit 4132f19173211856d35180958d2754f5c56d520a upstream.

Currently, every time the device wakes up from sleep, the
iio_chan array is reallocated, leaking the previous one
until the device is removed (basically never).

Move the allocation to the probe function to avoid this.

Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221014123724.1401011-2-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1376,13 +1376,6 @@ static int ltc2983_setup(struct ltc2983_
 		return ret;
 	}
 
-	st->iio_chan = devm_kzalloc(&st->spi->dev,
-				    st->iio_channels * sizeof(*st->iio_chan),
-				    GFP_KERNEL);
-
-	if (!st->iio_chan)
-		return -ENOMEM;
-
 	ret = regmap_update_bits(st->regmap, LTC2983_GLOBAL_CONFIG_REG,
 				 LTC2983_NOTCH_FREQ_MASK,
 				 LTC2983_NOTCH_FREQ(st->filter_notch_freq));
@@ -1494,6 +1487,12 @@ static int ltc2983_probe(struct spi_devi
 	if (ret)
 		return ret;
 
+	st->iio_chan = devm_kzalloc(&spi->dev,
+				    st->iio_channels * sizeof(*st->iio_chan),
+				    GFP_KERNEL);
+	if (!st->iio_chan)
+		return -ENOMEM;
+
 	ret = ltc2983_setup(st, true);
 	if (ret)
 		return ret;


