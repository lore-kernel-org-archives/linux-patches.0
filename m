Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626281;
	b=KG0iTWXMePXs3lzPui5hxkMtoiGrJlI/NdBb45ABk5eFhXkx8jiRXJpyyrFv0BmQhpjI
	 HaQ6GrurhqX682sDP4ZbGwemwHeqaghM/TavETnJLpVlGriY5FLViRpgrQzR+aUKAqhri
	 k0OxZvSwf1bnjKPfkxPLa8fUiclDaqe9cyVkuk5QxYo0PJ3kLTZ+fDOCxKuhUkkIXabCO
	 g/5Fz2A3JQDdMRIy6LdGfIjMZMUcXdiYSh2prcKOzpWP63Mjaipqdlgsz9a/A847kUjmE
	 88QY9FCI0At8i5DtNF1xvCIIylYki+tuBx6X0QoTxrVMRtF7vwG9A9yOlvWOBVlkdmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/tTzEnWjJqkl24HpNyM2nwu2uRzUbRYoDzFmeqn4QQ=;
	b=Z7lhW5jpPc4M3TBnuaSvJl3CaseRcI3wzsJdGdHVQSgzpCImkkClPc2HQlcSu7MBLlgB
	 F/c+2l5nwh/jibkdnG7CuE5C5TA3QNWyR21An+z6lxQyJB3zrke1zTB20GwgGvZC9BSwB
	 Xzhww/3qCdYbV1oHfc/4u85R4tGjw+fKoKktl0KinRYQ4Cr2iwc+SUN8KXhj5aNZhvyF/
	 ZH+/GJZEdgGkIdAJlD6mAjDBHsR4pdObf8CTA3LEk5CzoqRMABldcFt3a+iOaVVDUvwv1
	 nFgCHZEfpQT4EYLNqtimRFN/GmJuAQeYeOJiLxZfyp2jPSWgl+ThKbP7N6oO4i7b4pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuWah5m3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B905606A31E;
	Wed, 25 Nov 2026 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuWah5m3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FB11F000C4;
	Wed, 25 Nov 2026 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626281;
	bh=1/tTzEnWjJqkl24HpNyM2nwu2uRzUbRYoDzFmeqn4QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuWah5m3zCy+Cr2SVhjRK2qeP70YxUKw8TljKjAuBUy8MMHrjKaejjT5u2CHZtVeN
	 JB1NCU1zGF5ycA2lgDEMBydybHvZnnPwtcWTkGtlFmlRN6iwhMcnXRjESNV/W9WIIl
	 zNXtIGvFIBc0XB7vfepq6EzUXqm1hgHgUNpG3cXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 790/816] iio: imu: inv_icm42600: fix parsing of all FIFO frames for odr change
Date: Wed, 25 Nov 2026 15:38:58 +0100
Message-ID: <20261125143907.458339760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -532,22 +532,20 @@ int inv_icm42600_buffer_fifo_parse(struc
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
@@ -572,20 +570,18 @@ int inv_icm42600_buffer_hwfifo_flush(str
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


