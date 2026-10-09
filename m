Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A772D399CE9;
	Fri,  9 Oct 2026 14:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556847; cv=none; b=dBf5ekyCN7UBDCHiS2ghJ9aWW7PW23MT1AtbmqlnauEES4u2WTBAYOIl5wu4G9LCZHwGUs1GTE9YneQfojAHQUfTaDk9PYlBJzNtKHgTqAneeSwiPGr/Ahc9lZlytUcVTymfhIJyUg+Amt03NTDrrA6Q1UJfcqIRbu4AiJPC7JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556847; c=relaxed/simple;
	bh=MMI89PuISIdnHP45hd+uzYFYL7CYqHgDZIGdUcGDq8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRewsbDLo7wLPMfk7cjEKK5fDB/EK17lALHGkAO75yP0QvUssMZ0GUz7lfSCQIPbffh9pfAyZs+/x/RoPSWFXNYd7LeHh6DGNGDMNqSo1wru0ogeBnurUkHsArnuJRbaZatOacUfZZmNJ2z/CJ7VdXqXOvwInouigacPLHVUPmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdtuI8B7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdtuI8B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104411F000FF;
	Fri,  9 Oct 2026 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556846;
	bh=WF1kIE4YtXFKXiJIYYgMkORk6RGuKemHXg6WEI1ZioM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdtuI8B7+VVT/MK/sZbNWX5Y2YRkT1vO2r/rOPZvm2QeMDj/ik++iDnKOV6hwlG9e
	 WhJOHpQTNLIGPhU/pO5t6WCdABgmJ3plBg8LNwqFYqwgP/+tZR+1tiZ182x6ZTSnTP
	 eOGioeU5oJfpkOnpBWaV8Z9woKZZtlxGcCVEeHhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 302/403] iio: adc: ad_sigma_delta: fix use-after-free on unbind
Date: Fri,  9 Oct 2026 16:11:03 +0200
Message-ID: <20261009140959.275464718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 9ee8306121495d2a25aa5d1bfd519f2748786b83 upstream.

ad_sd_buffer_postenable() allocates sigma_delta->samples_buf with
devm_krealloc() at runtime, so its devres entry sits after all
probe-time entries of the driver. devm resources are released in
reverse allocation order, which means unbind frees samples_buf before
iio_device_unregister() disables the buffers and detaches the trigger
pollfunc. The data ready IRQ is still enabled at that point, so
ad_sd_trigger_handler() can still run and memcpy() incoming samples
into the freed samples_buf.

Fix this by preallocating the buffer in
devm_ad_sd_setup_buffer_and_trigger(), before the triggered buffer and
the IRQ are set up, so it is freed only after iio_device_unregister()
has drained the trigger handler via free_irq(). Size it for the worst
case of all sequencer slots being active; ad_sd_validate_scan_mask()
already caps the number of active channels at num_slots.

This issue was found by an in-house static analysis tool.

Fixes: 8bea9af887de ("iio: adc: ad_sigma_delta: Add sequencer support")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -496,7 +496,6 @@ static int ad_sd_buffer_postenable(struc
 	const struct iio_scan_type *scan_type = &indio_dev->channels[0].scan_type;
 	struct spi_transfer *xfer = sigma_delta->sample_xfer;
 	unsigned int i, slot, channel;
-	u8 *samples_buf;
 	int ret;
 
 	if (sigma_delta->num_slots == 1) {
@@ -528,7 +527,7 @@ static int ad_sd_buffer_postenable(struc
 		xfer[1].bits_per_word = scan_type->realbits;
 		xfer[1].len = spi_bpw_to_bytes(scan_type->realbits);
 	} else {
-		unsigned int samples_buf_size, scan_size;
+		unsigned int scan_size;
 
 		if (sigma_delta->active_slots > 1) {
 			ret = ad_sigma_delta_append_status(sigma_delta, true);
@@ -536,17 +535,6 @@ static int ad_sd_buffer_postenable(struc
 				return ret;
 		}
 
-		samples_buf_size =
-			ALIGN(slot * BITS_TO_BYTES(scan_type->storagebits),
-			      sizeof(s64));
-		samples_buf_size += sizeof(s64);
-		samples_buf = devm_krealloc(&sigma_delta->spi->dev,
-					    sigma_delta->samples_buf,
-					    samples_buf_size, GFP_KERNEL);
-		if (!samples_buf)
-			return -ENOMEM;
-
-		sigma_delta->samples_buf = samples_buf;
 		scan_size = BITS_TO_BYTES(scan_type->realbits + scan_type->shift);
 		/* For 24-bit data, there is an extra byte of padding. */
 		xfer[1].rx_buf = &sigma_delta->rx_buf[scan_size == 3 ? 1 : 0];
@@ -853,6 +841,23 @@ int devm_ad_sd_setup_buffer_and_trigger(
 
 		indio_dev->setup_ops = &ad_sd_buffer_setup_ops;
 	} else {
+		const struct iio_scan_type *scan_type =
+			&indio_dev->channels[0].scan_type;
+		unsigned int samples_buf_size;
+
+		/*
+		 * Worst-case size: all sequencer slots can be active, capped
+		 * at num_slots by ad_sd_validate_scan_mask().
+		 */
+		samples_buf_size =
+			ALIGN(sigma_delta->num_slots *
+			      BITS_TO_BYTES(scan_type->storagebits),
+			      sizeof(s64));
+		samples_buf_size += sizeof(s64);
+		sigma_delta->samples_buf = devm_kzalloc(dev, samples_buf_size, GFP_KERNEL);
+		if (!sigma_delta->samples_buf)
+			return -ENOMEM;
+
 		ret = devm_iio_triggered_buffer_setup(dev, indio_dev,
 						      &iio_pollfunc_store_time,
 						      &ad_sd_trigger_handler,


