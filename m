Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E2D34B1A6;
	Tue, 21 Jul 2026 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670480; cv=none; b=Cw3nZkEkB4g326k3br6XeOeT44rNeOzLqVeh+TN0U/GojO6B7H5HxpQ19nrNhNPn9RYheBWQDEjq97KCl/kNPN9TrtPziyXDgtXYmgEgjPw7MWHWoF+FEwqyg/X8/LJcFrktqf8CSI9BTqAt3iWpFBpx9Yl+EcbFCiB/A/M9hJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670480; c=relaxed/simple;
	bh=SEO8kgN+TTISQR1Dg86PGE4meOHJUo78+dswI/OBu3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubhrszS7FNxOgjoMUTXzVOcfPyrgDCs+C93wyIheC7SfGSPok5L6tZ0mJfKoyAQEgKwINcAh7ZpRZuYlm47Jh2X/dgpNs5BA9KlAosXmFC3RRJcbh2E5icCZHCoizi0tU+o0H+pnhVIDAlwsvgeo5iu3XL9QlHKlvJI0tlf7tR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inujrJV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inujrJV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFCA1F000E9;
	Tue, 21 Jul 2026 21:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670479;
	bh=eDe+eznI6NFsIQlJibXgqeyS9PbtMXMVQokV/zLs6w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inujrJV3lDH5Yi3mCM8xhnDe1EYDw9OTh45J08CqVQlGg69TnLRltLnGHYaC5L9Xp
	 Bk9TNyRzS0RtPn/t7TLqckfzp+NAKINAvA6TX4iEZn0dC8/kBPLy2HalcIiXEkRWwb
	 TFZnihl4gp6WiXfRkwz9kmyVRGFO1sRN4bwPDLHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0949/1067] iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading
Date: Tue, 21 Jul 2026 17:25:50 +0200
Message-ID: <20260721152445.768740624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit affe3f077d7a4eeb25937f5323ff059a54b4712c ]

Timestamps are made by measuring the chip clock using the watermark
interrupts. If we read more than watermark samples as done today, we
are reducing the period between interrupts and distort the time
measurement. Fix that by reading only watermark samples in the
interrupt case.

Fixes: 7f85e42a6c54 ("iio: imu: inv_icm42600: add buffer support in iio devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |    9 +++++----
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -257,6 +257,7 @@ int inv_icm42600_buffer_update_watermark
 
 	/* compute watermark value in bytes */
 	wm_size = watermark * packet_size;
+	st->fifo.watermark.value = watermark;
 
 	/* changing FIFO watermark requires to turn off watermark interrupt */
 	ret = regmap_update_bits_check(st->map, INV_ICM42600_REG_INT_SOURCE0,
@@ -476,11 +477,10 @@ int inv_icm42600_buffer_fifo_read(struct
 	st->fifo.nb.accel = 0;
 	st->fifo.nb.total = 0;
 
-	/* compute maximum FIFO read size */
+	/* compute maximum FIFO read size (watermark for max = 0 interrupt case) */
 	if (max == 0)
-		max_count = sizeof(st->fifo.data);
-	else
-		max_count = max * inv_icm42600_get_packet_size(st->fifo.en);
+		max = st->fifo.watermark.value;
+	max_count = max * inv_icm42600_get_packet_size(st->fifo.en);
 
 	/* read FIFO count value */
 	raw_fifo_count = (__be16 *)st->buffer;
@@ -592,6 +592,7 @@ int inv_icm42600_buffer_init(struct inv_
 
 	st->fifo.watermark.eff_gyro = 1;
 	st->fifo.watermark.eff_accel = 1;
+	st->fifo.watermark.value = 1;
 
 	/*
 	 * Default FIFO configuration (bits 7 to 5)
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h
@@ -34,6 +34,7 @@ struct inv_icm42600_fifo {
 		unsigned int accel;
 		unsigned int eff_gyro;
 		unsigned int eff_accel;
+		unsigned int value;
 	} watermark;
 	size_t count;
 	struct {


