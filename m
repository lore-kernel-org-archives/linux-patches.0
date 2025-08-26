Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE8E2EE296;
	Tue, 26 Aug 2025 11:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207740; cv=none; b=ViuMKlYBcvc2GqpTQ8zhaAYqkZPizZc7/6SHZYSxyJ43xWEVQcc8wpeAppNpxcFxJMhel0fm8K1I7ZC+Trio1A2b6pUbBIS462CJblMdcQPMuNS/haPfkOKUwWVdXsbbABFTBqCO1dAOD1zkYIs1LE7cbZ9r5cTK4xtS84GMG08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207740; c=relaxed/simple;
	bh=1jtlinWirPBSgN8J/vIJ5CymY92TtZrww26pBz84qWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cdgJ2HIFax+Cca61+5ZKH8a0CkSbZHMFQe2gtycPqBstdBOqxy5uaFuhjqqBPurEZgwpvBeD8GSMfmbife39jEW1hJdBY7Xvvz9wMQnAgSL2P/e4zuUmnY5TYsRGowOdYnd6/Cmk6Fi0yBivjKMF/yypgiUpSX4QFJG11he6G4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fU0W0uAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fU0W0uAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B522C4CEF1;
	Tue, 26 Aug 2025 11:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207739;
	bh=1jtlinWirPBSgN8J/vIJ5CymY92TtZrww26pBz84qWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fU0W0uAM/YEZqVkfL/D+m9HGCJPnG2vSv/Fb/L4euVQYvTsLsC1KlMbwUIs9QQhvT
	 4gYtp8EXRuxa4nZ3DHnW7npp4z3nxX3uS5DZdP7zEIXIVRU7s+WOcBsezUvh22xt0r
	 byyWOpsOy1ACE4A6Bp+extqD8cJRr77Y6Db9+om8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 299/457] iio: adc: ad7124: fix channel lookup in syscalib functions
Date: Tue, 26 Aug 2025 13:09:43 +0200
Message-ID: <20250826110944.766161401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 197e299aae42ffa19028eaea92b2f30dd9fb8445 upstream.

Fix possible incorrect channel lookup in the syscalib functions by using
the correct channel address instead of the channel number.

In the ad7124 driver, the channel field of struct iio_chan_spec is the
input pin number of the positive input of the channel. This can be, but
is not always the same as the index in the channels array. The correct
index in the channels array is stored in the address field (and also
scan_index). We use the address field to perform the correct lookup.

Fixes: 47036a03a303 ("iio: adc: ad7124: Implement internal calibration at probe time")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250726-iio-adc-ad7124-fix-channel-lookup-in-syscalib-v1-1-b9d14bb684af@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -855,7 +855,7 @@ enum {
 static int ad7124_syscalib_locked(struct ad7124_state *st, const struct iio_chan_spec *chan)
 {
 	struct device *dev = &st->sd.spi->dev;
-	struct ad7124_channel *ch = &st->channels[chan->channel];
+	struct ad7124_channel *ch = &st->channels[chan->address];
 	int ret;
 
 	if (ch->syscalib_mode == AD7124_SYSCALIB_ZERO_SCALE) {
@@ -871,8 +871,8 @@ static int ad7124_syscalib_locked(struct
 		if (ret < 0)
 			return ret;
 
-		dev_dbg(dev, "offset for channel %d after zero-scale calibration: 0x%x\n",
-			chan->channel, ch->cfg.calibration_offset);
+		dev_dbg(dev, "offset for channel %lu after zero-scale calibration: 0x%x\n",
+			chan->address, ch->cfg.calibration_offset);
 	} else {
 		ch->cfg.calibration_gain = st->gain_default;
 
@@ -886,8 +886,8 @@ static int ad7124_syscalib_locked(struct
 		if (ret < 0)
 			return ret;
 
-		dev_dbg(dev, "gain for channel %d after full-scale calibration: 0x%x\n",
-			chan->channel, ch->cfg.calibration_gain);
+		dev_dbg(dev, "gain for channel %lu after full-scale calibration: 0x%x\n",
+			chan->address, ch->cfg.calibration_gain);
 	}
 
 	return 0;
@@ -930,7 +930,7 @@ static int ad7124_set_syscalib_mode(stru
 {
 	struct ad7124_state *st = iio_priv(indio_dev);
 
-	st->channels[chan->channel].syscalib_mode = mode;
+	st->channels[chan->address].syscalib_mode = mode;
 
 	return 0;
 }
@@ -940,7 +940,7 @@ static int ad7124_get_syscalib_mode(stru
 {
 	struct ad7124_state *st = iio_priv(indio_dev);
 
-	return st->channels[chan->channel].syscalib_mode;
+	return st->channels[chan->address].syscalib_mode;
 }
 
 static const struct iio_enum ad7124_syscalib_mode_enum = {


