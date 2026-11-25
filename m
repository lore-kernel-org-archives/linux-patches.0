Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623739;
	b=GD7rf3MLmATrKeo8reVP6lKwygmQuZLpUVbvBCIPvI+nG8o+Nsm6cGKc+nwB121eXj08
	 wiRTAvkXTrFxGnakaj/Z0XvaO8JQTzDM5X3xKAkihc2IN3aVQUKN0hgOEK3/jlwlSd04R
	 OppFlqK75JCtFnJo0MWLQWUHFuzcATEq3lvWh2CEIOFEheoKFlQeWQML1N3KrAUWhzOpQ
	 rAqwA/duiJLkm8ueyD1NY9YUa91yxVJOu3ZDvTUbHpE44eQgbFc4jtz0FSbu3Gf3If556
	 6hKEmVDKLVYYvhwGfrIZLxW3YC8pOeMBqxxFCCwIWYILTxQmOz1iBkjRU7vMb1mu7WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLAOPrlJ+yFpQa8g1fHSw69B6StkUPhuY+WJy7D7Ug0=;
	b=CPZJRbTZ0JzlcooTJ1lj8QjwsaCX/+kooQEkKsSJIQov+xAIZipG74Ntgux8Z/McUl3r
	 BNp4m8GSu/j5L2XoiONaasSmi8mQA6Jy2ct66XMI4qMbx0QhmYWgJvsC3qj8byJAubqjn
	 OsCxPZARvWQFyaiO6kgqaSyI2zE8BnS2PlkarwuWIdSiHSAgWb/rfzvqTv1vFey88duzq
	 cXBX+CV9PRrO/gDGiZmhfTk6DakJ3apkG4iT6QDqkZrBz9/voKFXGwe52KnH1hyrCZVya
	 iY5OLFG+dIkPbAOH0kh0UTbNb1goq/ri2RgCpHXun5fbvC+Kh0+IjRlr1amWiT/zqrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuHhyNHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F39C606A321;
	Wed, 25 Nov 2026 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuHhyNHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FB21F000C6;
	Wed, 25 Nov 2026 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623738;
	bh=KLAOPrlJ+yFpQa8g1fHSw69B6StkUPhuY+WJy7D7Ug0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XuHhyNHK8uZIK+uqqiZvathEUqUecion704Q5xliLhrfGAKnL6Nb+T84L8a6viIc3
	 j7O5GU4C6QOp1DSq9e29BF47jBU7gmWV2sJ7N3VjrVoywACwvr3EYOqfNVakwOTlX3
	 l2GUpfcN/THQO17KOjG4KxA9bYddE54cghuBy3Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 955/990] iio: imu: inv_icm42600: fix parsing of all FIFO frames for odr change
Date: Wed, 25 Nov 2026 15:38:42 +0100
Message-ID: <20261125143844.358255473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 4a141623442888458d147f4e61fe47411c0e4e17 upstream.

For getting all odr change events, we need to parse all FIFO frames
in each iio device. Fix this correctly by sending effectively all
frames to all iio devices.

Previously only batches of frames containing a matching sensor event
were sent to the corresponding iio device.

Fixes: f670d4d34773 ("iio: imu: inv_icm42600: fix odr change not caught in certain cases")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   24 ++++++++-------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -513,22 +513,20 @@ int inv_icm42600_buffer_fifo_parse(struc
 		ts = &gyro_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.watermark.eff_gyro,
 						st->timestamp.gyro);
-		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
-		if (ret)
-			return ret;
 	}
 
+	ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
+	if (ret)
+		return ret;
+
 	/* handle accelerometer timestamp and FIFO data parsing */
 	if (st->fifo.nb.accel > 0) {
 		ts = &accel_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.watermark.eff_accel,
 						st->timestamp.accel);
-		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return inv_icm42600_accel_parse_fifo(st->indio_accel);
 }
 
 int inv_icm42600_buffer_hwfifo_flush(struct inv_icm42600_state *st,
@@ -553,20 +551,18 @@ int inv_icm42600_buffer_hwfifo_flush(str
 	if (st->fifo.nb.gyro > 0) {
 		ts = &gyro_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.gyro, gyro_ts);
-		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
-		if (ret)
-			return ret;
 	}
 
+	ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
+	if (ret)
+		return ret;
+
 	if (st->fifo.nb.accel > 0) {
 		ts = &accel_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.accel, accel_ts);
-		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return inv_icm42600_accel_parse_fifo(st->indio_accel);
 }
 
 int inv_icm42600_buffer_init(struct inv_icm42600_state *st)


