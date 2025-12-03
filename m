Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB9432E692;
	Wed,  3 Dec 2025 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777052; cv=none; b=QOsuSLhBE76w0SL0lT3UtJ2lCQ/g1xxzjDRJ0n9fRKcsHtcfQ1X2G8/PgukMGI+K1PuqSv0OKHDZ+swCXGdt0nDfAvfX/dJhTD+S/qlYEfUENM/pLJipJbwECN8p5mYwTFE0+Ee6Q0jItQXRrrJssehCV8V0Roig5K/j4R1W+d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777052; c=relaxed/simple;
	bh=hyGgJ+8kTwEsuHBwCPoUyjZnjvRg8fdxUk3hPSdrYPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pd4yZBa2LivtLAGN3decS4HC0ROipfUPo/T80eePqz77s8SFqMiq0W+ZzC+rDafJJaf2hK5Kt2WT4E6glrHgiyKuN9Mnl7h9Am0B83b7lsVDM57NIZt7IcAcosS9QaT1cZQeDnILgZa8ujBOhtZhk3MkBXdSSR+n3+SPIyD5Y2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMFQLieR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMFQLieR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DAAC4CEF5;
	Wed,  3 Dec 2025 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777052;
	bh=hyGgJ+8kTwEsuHBwCPoUyjZnjvRg8fdxUk3hPSdrYPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMFQLieRHqOyTT/Sn0B8T/25Uh589s1Wc5g/XpqQD4RAJYp81Gt1RjQNnINEgH6tE
	 RRx+m4bx9AHb3HW1TOAU5nXgEMNq8ExFd9LysRbd0FPFr32hinRwD2rc2UoBmV4Akf
	 KlL1Uo49KnkcKdlO1D8Kwce4mnmy4nH9EDGFuamw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 066/146] iio: adc: ad7124: fix temperature channel
Date: Wed,  3 Dec 2025 16:27:24 +0100
Message-ID: <20251203152348.882862864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit e2cc390a6629c76924a2740c54b144b9b28fca59 upstream.

Fix temperature channel not working due to gain and offset not being
initialized.  For channels other than the voltage ones calibration is
skipped (which is OK).  However that results in the calibration register
values tracked in st->channels[i].cfg all being zero.  These zeros are
later written to hardware before a measurement is made which caused the
raw temperature readings to be always 8388608 (0x800000).

To fix it, we just make sure the gain and offset values are set to the
default values and still return early without doing an internal
calibration.

While here, add a comment explaining why we don't bother calibrating
the temperature channel.

Fixes: 47036a03a303 ("iio: adc: ad7124: Implement internal calibration at probe time")
Reviewed-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -1196,10 +1196,6 @@ static int __ad7124_calibrate_all(struct
 	int ret, i;
 
 	for (i = 0; i < st->num_channels; i++) {
-
-		if (indio_dev->channels[i].type != IIO_VOLTAGE)
-			continue;
-
 		/*
 		 * For calibration the OFFSET register should hold its reset default
 		 * value. For the GAIN register there is no such requirement but
@@ -1210,6 +1206,14 @@ static int __ad7124_calibrate_all(struct
 		st->channels[i].cfg.calibration_gain = st->gain_default;
 
 		/*
+		 * Only the main voltage input channels are important enough
+		 * to be automatically calibrated here. For everything else,
+		 * just use the default values set above.
+		 */
+		if (indio_dev->channels[i].type != IIO_VOLTAGE)
+			continue;
+
+		/*
 		 * Full-scale calibration isn't supported at gain 1, so skip in
 		 * that case. Note that untypically full-scale calibration has
 		 * to happen before zero-scale calibration. This only applies to


