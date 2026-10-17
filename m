Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB16255E43;
	Sat, 17 Oct 2026 17:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257074; cv=none; b=cp5XfHMMOaGcB00cVgVjoHVpbAp5zHjPZAZHYcgcqYMYbyhXTn8wIY/MJNKjrJo8zxgRzQrag3kF635FXYKKvnfy6sELIqLTtJuXeUJ5fjFS8dYzRVVX2A40JJ+jWU3KYaBe9or23Fn33EZUut3engutmTKzF/OpUb6P80jTau0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257074; c=relaxed/simple;
	bh=V3UgXoauIPBOoMNmvgEAHrAJ6/npU+wOlnzPdOga+zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6on56t58/1yVPYUpx39t3Xo6ksNBVrPJ19eyM1IBVC6C6NKSXWWrXcwqQErn7+rol34Og6hOLlTMzXNtzAK6BHgm7qWIkup32quHjqOI0jLiRegjFsRibC94jcccN+2/SjEkMYpn6aBkN/4vou6Ei6e53YkGrIvrpamwd7qGaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTSXqZtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTSXqZtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6683F1F000C4;
	Sat, 17 Oct 2026 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257073;
	bh=mz8Z/TXiBn3uzSjaqEFfFwHriAaD7MGWFQygYHpiV4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTSXqZtF8PoeFFC57v6JQJ7YhK//EkfCDlTYHNrbgKaJdiIUPrGZf0qxG8YasRKNI
	 mT9La8uln2HSOMYMaqMJ3tY6hqIrG6P1qoV7XV1jfdH8AMiWKIm/bZ7iTNQ5GgNlel
	 g4qOLMG21mfejKFQBS3rZctoELsaKnEMzNMsD+Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0444/1674] iio: adc: ad_sigma_delta: fix use-after-free on unbind
Date: Sat, 17 Oct 2026 17:45:16 +0200
Message-ID: <20261017160442.519925478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 9ee8306121495d2a25aa5d1bfd519f2748786b83 ]

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
[ sashal: Adapted allocation to setup without SPI offload using direct channel scan_type.storagebits access. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 914274ed899ec..45e0f638c0ed1 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -343,9 +343,8 @@ EXPORT_SYMBOL_NS_GPL(ad_sigma_delta_single_conversion, IIO_AD_SIGMA_DELTA);
 static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
-	unsigned int i, slot, samples_buf_size;
+	unsigned int i, slot;
 	unsigned int channel;
-	uint8_t *samples_buf;
 	int ret;
 
 	if (sigma_delta->num_slots == 1) {
@@ -378,15 +377,6 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 			return ret;
 	}
 
-	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits / 8, 8);
-	samples_buf_size += sizeof(int64_t);
-	samples_buf = devm_krealloc(&sigma_delta->spi->dev, sigma_delta->samples_buf,
-				    samples_buf_size, GFP_KERNEL);
-	if (!samples_buf)
-		return -ENOMEM;
-
-	sigma_delta->samples_buf = samples_buf;
-
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
 	sigma_delta->keep_cs_asserted = true;
@@ -620,6 +610,7 @@ static int devm_ad_sd_probe_trigger(struct device *dev, struct iio_dev *indio_de
 int devm_ad_sd_setup_buffer_and_trigger(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
+	unsigned int samples_buf_size;
 	int ret;
 
 	sigma_delta->slots = devm_kcalloc(dev, sigma_delta->num_slots,
@@ -627,6 +618,19 @@ int devm_ad_sd_setup_buffer_and_trigger(struct device *dev, struct iio_dev *indi
 	if (!sigma_delta->slots)
 		return -ENOMEM;
 
+	/*
+	 * Worst-case size: all sequencer slots can be active, capped
+	 * at num_slots by ad_sd_validate_scan_mask().
+	 */
+	samples_buf_size =
+		ALIGN(sigma_delta->num_slots *
+		      BITS_TO_BYTES(indio_dev->channels[0].scan_type.storagebits),
+		      sizeof(s64));
+	samples_buf_size += sizeof(s64);
+	sigma_delta->samples_buf = devm_kzalloc(dev, samples_buf_size, GFP_KERNEL);
+	if (!sigma_delta->samples_buf)
+		return -ENOMEM;
+
 	ret = devm_iio_triggered_buffer_setup(dev, indio_dev,
 					      &iio_pollfunc_store_time,
 					      &ad_sd_trigger_handler,
-- 
2.53.0



