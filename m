Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A043AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62946C4339B;
	Wed,  7 Jun 2023 20:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169760;
	bh=0pcqTTqlR3Qj/f34cBU6JnVRvGQ3xgIzQ3rAh732/FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpHQWYPOuUhUVchjPI1MwJ4gMVyC9TrViA3Qk8qw9H8SfLQFe+9K54QaUisDNMj8E
	 Tv8j98DX8ZB1qHd+nQuWtzTG0CGrAmmdFa1MUfNEaPuNZKDfmZlOQL5/OW0AGLiunU
	 6mFJT23irxPhvBmYESmwaGmMWsKeNCaq8sOaRzI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.3 204/286] iio: addac: ad74413: fix resistance input processing
Date: Wed,  7 Jun 2023 22:15:03 +0200
Message-ID: <20230607200929.920400068@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 24febc99ca725dcf42d57168a2f4e8a75a5ade92 upstream.

On success, ad74413r_get_single_adc_result() returns IIO_VAL_INT aka
1. So currently, the IIO_CHAN_INFO_PROCESSED case is effectively
equivalent to the IIO_CHAN_INFO_RAW case, and we never call
ad74413r_adc_to_resistance_result() to convert the adc measurement to
ohms.

Check ret for being negative rather than non-zero.

Fixes: fea251b6a5dbd (iio: addac: add AD74413R driver)
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230503095817.452551-1-linux@rasmusvillemoes.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/ad74413r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -981,7 +981,7 @@ static int ad74413r_read_raw(struct iio_
 
 		ret = ad74413r_get_single_adc_result(indio_dev, chan->channel,
 						     val);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		ad74413r_adc_to_resistance_result(*val, val);


