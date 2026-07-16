Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F9A2475F7;
	Thu, 16 Jul 2026 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209106; cv=none; b=l6PNRrXJSPkN1tgniQ5tOUoOcMcEFyL6Vk81jpgkV0bKnxZijrk6nx3AWZjI52CCTbnxL5WFgRJ1AfeXfc42kMQzr3IR6gUQIb4sgXDuJTZNSK3RPoI6sRnuscvM58w/11sxlciXFH/oF8gN9SN/oa56V6ZUeL9W7iRqCJQmLfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209106; c=relaxed/simple;
	bh=nSeWyk0Vav+vjHvc1DOegHk61ACQCUTJ9tgeqpYeggU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPYqu/4hwhocTS91cLsGCsN6g0mrke8VCOXOUQM09IsEgz0oDchEorlBSKKJnzE3dQeMlWvIPTUqAx++sr/Oex5dvw+gLS36dLJ/1ihCB+1uN+IElYDSat0q8WiwvQcIFhuCDhlO6mrVHGlDKkp2XecJ2cpWsqj6Yh6y/myONSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfNq0lRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfNq0lRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D041F000E9;
	Thu, 16 Jul 2026 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209105;
	bh=/JGtZgSbFQTCdv+6w9Rdbxsv8xRnwcSsrAbsrN4ewsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfNq0lRXckULq69NCgl48+1pVGMQ5Xjf4FXvGk0JmtpWEbdW4TNu+PHB5K1P4zkY3
	 9h1Jp6rMmS6CxafABrvR8Om2mSF2Aan2rhGrCDlvQZ1GyY+QWmpAmRgG/6Cq669VYl
	 4K6GPrp5rniItR0OvK8XIgfMsExrDORmpQLpiTVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 058/518] iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading
Date: Thu, 16 Jul 2026 15:25:26 +0200
Message-ID: <20260716133049.054839314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit affe3f077d7a4eeb25937f5323ff059a54b4712c upstream.

Timestamps are made by measuring the chip clock using the watermark
interrupts. If we read more than watermark samples as done today, we
are reducing the period between interrupts and distort the time
measurement. Fix that by reading only watermark samples in the
interrupt case.

Fixes: 7f85e42a6c54 ("iio: imu: inv_icm42600: add buffer support in iio devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |    9 +++++----
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -248,6 +248,7 @@ int inv_icm42600_buffer_update_watermark
 
 	/* compute watermark value in bytes */
 	wm_size = watermark * packet_size;
+	st->fifo.watermark.value = watermark;
 
 	/* changing FIFO watermark requires to turn off watermark interrupt */
 	ret = regmap_update_bits_check(st->map, INV_ICM42600_REG_INT_SOURCE0,
@@ -454,11 +455,10 @@ int inv_icm42600_buffer_fifo_read(struct
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
@@ -574,6 +574,7 @@ int inv_icm42600_buffer_init(struct inv_
 
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


