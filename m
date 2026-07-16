Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9275A3F54B6;
	Thu, 16 Jul 2026 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211730; cv=none; b=JqQY7sFwxbhi5whTZWljKwDFYYP7OEWFg1R+YJa+D3cHP4dGbC/pLkIAUEQne4frAb1TnBtOxcZezZLtW6VmGR9vrOgg+ty10A89edxx1WeDkZCPv4uF25WTblJF2n8kScUzAs7NW2PrHSZrsWXUPd1ukmq//2kVybMnEI3tLJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211730; c=relaxed/simple;
	bh=B4vu9AtkjZ1J+1ESwk8CRAmNpHyblMHTlGyFNNG14Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP2I6usgCl1VqyJ6mvWP3GijMl7rDFGwruZUkBeTQ9ak1S4SU1FctCsrpCNIoMe9ZbpaAT1y6nErxK03X7TuFp7z0XJGn9UkguAodA95chDKFAHM8omlBn3tDNt8d7dniHkwZfmT6khvqmnMT9uzA0j4ITKVQ04Xht6H0dhToLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6P2yV+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6P2yV+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DDE1F00A3A;
	Thu, 16 Jul 2026 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211729;
	bh=yz3Ex11xaOFWUC+KQxk06+SGVwh8z/M0E3GYX9Dmy2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6P2yV+5vecacvHIaRUp1taGQMJ7746gA7/InB9l8+dGxm3mVRzPUyL1RMUtlm8xC
	 VYqJA6OPC+nhjx4PkkHd2LSvHgT+N2L06WhcgNz6Xe3LURVSZFN1fNyw3mtSkuA2lb
	 +RfcXMslNq4Mbz5TfNbo5lFMlDuoOV8RIXxxEQTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 059/349] iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading
Date: Thu, 16 Jul 2026 15:29:53 +0200
Message-ID: <20260716133034.647965891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,6 +257,7 @@ int inv_icm42600_buffer_update_watermark
 
 	/* compute watermark value in bytes */
 	wm_size = watermark * packet_size;
+	st->fifo.watermark.value = watermark;
 
 	/* changing FIFO watermark requires to turn off watermark interrupt */
 	ret = regmap_update_bits_check(st->map, INV_ICM42600_REG_INT_SOURCE0,
@@ -473,11 +474,10 @@ int inv_icm42600_buffer_fifo_read(struct
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
@@ -593,6 +593,7 @@ int inv_icm42600_buffer_init(struct inv_
 
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


