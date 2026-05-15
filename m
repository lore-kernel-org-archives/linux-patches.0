Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09582305669;
	Fri, 15 May 2026 15:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860728; cv=none; b=d2DjJbt1wdN5/pKdSMFnRXExVKDojKjJnWmbYjjKts/zf5xZl7oL3gbzb8UW0+FwWsyaHiilUPYumoWkBlFzcOoGSAFtO1bRjReIQRr0SbvELETkgo+EPDP6u6OD5i8d0mvV77I30ddXlTl493yXu9wzDILMpNDWLyqhdj6Ntpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860728; c=relaxed/simple;
	bh=L0/BcD1LWCY7fw3QSpDfDr3R+P/cayJCRaV6eQw/eXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crPBGnHR5IqyKxLP/qhpks/Acy8SZUyaVb77rsahuGmBHeQjCsd9030Wou79PvprU9bMGAkgJ8M53y3RQT2lQwh158NfmWeVOVPKOQWhs2qb2HTHBzZ1xFmfC2P5PeT2aES0ZgY1oysHe67R4IgEhA8A6tsGEWay+XYLySYfze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF/3oPeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF/3oPeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862F3C2BCB0;
	Fri, 15 May 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860727;
	bh=L0/BcD1LWCY7fw3QSpDfDr3R+P/cayJCRaV6eQw/eXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF/3oPeVXMCFJa97fwys41trwjq7aRuzoVpoBz4K53qAsCpaVghGwOL7knKfUWNot
	 libbYDYE3k8TNlCxmZCi/MLflCl0AlVJ/a8/iFma2BapURuXEl+zw5bpa2BUxBkf/W
	 fceQ9nl3csstb4Jt59+lwUP3QOCQ+jkTD/Y5m9iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 055/474] iio: adc: ti-ads7950: use iio_push_to_buffers_with_ts_unaligned()
Date: Fri, 15 May 2026 17:42:44 +0200
Message-ID: <20260515154716.236939235@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

commit 7806c060cceb2d6895efbb6cff2f2f17cf1ec5de upstream.

Use iio_push_to_buffers_with_ts_unaligned() to avoid unaligned access
when writing the timestamp in the rx_buf.

The previous implementation would have been fine on architectures that
support 4-byte alignment of 64-bit integers but could cause issues on
architectures that require 8-byte alignment.

Fixes: 902c4b2446d4 ("iio: adc: New driver for TI ADS7950 chips")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -47,8 +47,6 @@
 #define TI_ADS7950_MAX_CHAN	16
 #define TI_ADS7950_NUM_GPIOS	4
 
-#define TI_ADS7950_TIMESTAMP_SIZE (sizeof(int64_t) / sizeof(__be16))
-
 /* val = value, dec = left shift, bits = number of bits of the mask */
 #define TI_ADS7950_EXTRACT(val, dec, bits) \
 	(((val) >> (dec)) & ((1 << (bits)) - 1))
@@ -105,8 +103,7 @@ struct ti_ads7950_state {
 	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	u16 rx_buf[TI_ADS7950_MAX_CHAN + 2 + TI_ADS7950_TIMESTAMP_SIZE]
-		__aligned(IIO_DMA_MINALIGN);
+	u16 rx_buf[TI_ADS7950_MAX_CHAN + 2] __aligned(IIO_DMA_MINALIGN);
 	u16 tx_buf[TI_ADS7950_MAX_CHAN + 2];
 	u16 single_tx;
 	u16 single_rx;
@@ -313,8 +310,10 @@ static irqreturn_t ti_ads7950_trigger_ha
 	if (ret < 0)
 		goto out;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, &st->rx_buf[2],
-					   iio_get_time_ns(indio_dev));
+	iio_push_to_buffers_with_ts_unaligned(indio_dev, &st->rx_buf[2],
+					      sizeof(*st->rx_buf) *
+					      TI_ADS7950_MAX_CHAN,
+					      iio_get_time_ns(indio_dev));
 
 out:
 	mutex_unlock(&st->slock);


