Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D483DE422;
	Mon,  4 May 2026 13:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903156; cv=none; b=CpHsmx39nZMnQpVXKLvhJFcbbRUVNrxmlblV4CrEcsH2vYdwqNnbL3fXTwl4qU9BceKqWPX7Vfx7M2UvcAPvaT7rMJwT+/CtDKRDwUX/sA3FG5LIMUEU+VMwxAbyaIFbhbuzPCLt82dvdMNbAM2LGkMt3sY6aXYgkLzh0MeRl2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903156; c=relaxed/simple;
	bh=1v5k0Rj/W2L2y9YiXX10gl2QswdvWSgA5lGPiJM8hu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFx2jSBFHAGaTtV+hwlFc+imtL6uXV+m6WmUQdrNHkJRu+vZ/b9mWMdxfLF3YcVl5x/b/slgz8jGRV1b6zxMfH3FyLKmwL5Sl2etArGldhZchjd7i3/gx07FHnhN+ABZjI2NtDvdlAOz/lEFAu3WzsM+/T1Xuvcc8skfq94xsMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBtW8+TM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBtW8+TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E8FC2BCB8;
	Mon,  4 May 2026 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903156;
	bh=1v5k0Rj/W2L2y9YiXX10gl2QswdvWSgA5lGPiJM8hu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBtW8+TM0thMykm1tnAs1R9s0eUdlT8qsdjxLcZTjXMBCNe5cV89xV2UuXyIi1gEw
	 B7pUiBKBBit+ToIDvStcMi5zjobZpuJezAymmNk7NB1H6SYEabFWRsEDXqXYwe3ql3
	 Q6uO+DTphu28KejbLn0CrZ9o/HqAKnlOFgXL0Lfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 7.0 125/307] iio: adc: ad7768-1: remove switch to one-shot mode
Date: Mon,  4 May 2026 15:50:10 +0200
Message-ID: <20260504135147.497253231@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

commit 81fdc3127d013a552465c3bf9829afbed5184406 upstream.

wideband low ripple FIR Filter is not available in one-shot mode. In
order to make direct reads work for all filter options, remove the
switch for one-shot mode and guarantee device is always in continuous
conversion mode.

Fixes: fb1d3b24ebf5 ("iio: adc: ad7768-1: add filter type and oversampling ratio attributes")
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -463,17 +463,8 @@ static int ad7768_scan_direct(struct iio
 	struct ad7768_state *st = iio_priv(indio_dev);
 	int readval, ret;
 
-	ret = ad7768_set_mode(st, AD7768_ONE_SHOT);
-	if (ret < 0)
-		return ret;
-
 	reinit_completion(&st->completion);
 
-	/* One-shot mode requires a SYNC pulse to generate a new sample */
-	ret = ad7768_send_sync_pulse(st);
-	if (ret)
-		return ret;
-
 	ret = wait_for_completion_timeout(&st->completion,
 					  msecs_to_jiffies(1000));
 	if (!ret)
@@ -492,14 +483,6 @@ static int ad7768_scan_direct(struct iio
 	if (st->oversampling_ratio == 8)
 		readval >>= 8;
 
-	/*
-	 * Any SPI configuration of the AD7768-1 can only be
-	 * performed in continuous conversion mode.
-	 */
-	ret = ad7768_set_mode(st, AD7768_CONTINUOUS);
-	if (ret < 0)
-		return ret;
-
 	return readval;
 }
 
@@ -1257,6 +1240,10 @@ static int ad7768_setup(struct iio_dev *
 			return ret;
 	}
 
+	ret = ad7768_set_mode(st, AD7768_CONTINUOUS);
+	if (ret)
+		return ret;
+
 	/* For backwards compatibility, try the adi,sync-in-gpios property */
 	st->gpio_sync_in = devm_gpiod_get_optional(&st->spi->dev, "adi,sync-in",
 						   GPIOD_OUT_LOW);


