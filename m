Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEF8309F08;
	Sat, 12 Sep 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228262; cv=none; b=a7C3ji+vLUA42iDpW8vCtfEvsNxC2lrqI+ykfBUjKgu5IJ3jf3bzeASPJCRTqofkvE1TCQT3C7E2kT5ONt3y/l9Fc2ZlauJJJB3yNkI6eF2u4Eoj9fOqF0J4imNxjAtXffqT7KYwbblROG3r9kS9+tPUOHVbYLNodGxHIfPTxKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228262; c=relaxed/simple;
	bh=m9zsbxb60fI6hZ3afyP9IwfiDDme2O5q6PRo3+Qa0ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA7aIdt5Zs/YMR/PJSUfs65JFr5O8u5dBJWKfj1QskmkS2VmCB1bD5DWT9vDAUfItPZSKFZVurodcK8kOvkaAZubA31bBPyFjUAi8kLJeFmfbxBhG+fli7yreyEtspMIO4b6oS8yjc809l39W7eG+Kg9QuUnlZzzUB90oh8Q+GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNFhW55d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNFhW55d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EAA1F000FF;
	Sat, 12 Sep 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228260;
	bh=yWeD46Cty7w3itiSP0Mhzbjzx7XLBa3x12x+LftUXac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNFhW55daBUHLJfoyOVE1MU2dfOv3uuA6Iu801QUeKCj+MmilDjzsZ5mr82oOVOpI
	 bbdkTQdh+NB9sKUvPvSQAatXtI89SWOHw52Oe/FY/uuevWuUURG40aSbrWcZYj5J9E
	 5GZqDdyRAEGAfoAQv747uAqXnMz1OVvzQSaF8h2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxwell Doose <m32285159@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0349/1191] iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()
Date: Sat, 12 Sep 2026 08:51:17 +0200
Message-ID: <20260912065556.066936639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

commit 967d066f5334740f656577bc51c381a1bb707b61 upstream.

Avoid using devm_iio_device_register(), as this driver requires explicit
error handling and teardown ordering.

With devm_iio_device_register(), IIO device remains registered until the
devres cleanup phase. However, driver's remove() callback removes the
sensor hub callback and trigger support. This can create a race window
where IIO device is still visible and read_raw() requests are issued.
These requests might call sensor_hub_input_attr_get_raw_value(), which
waits up to 5 seconds for a response from the sensor hub callback that
has already been removed.

Add an explicit iio_device_unregister() call in the teardown path to
ensure deterministic cleanup, so that userspace can no longer access the
device once backend resources begin to be dismantled.

Fixes: 59d0f2da3569 ("iio: hid: Add temperature sensor support")
Cc: stable@vger.kernel.org
Reviewed-by: Maxwell Doose <m32285159@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/hid-sensor-temperature.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/temperature/hid-sensor-temperature.c
+++ b/drivers/iio/temperature/hid-sensor-temperature.c
@@ -243,7 +243,7 @@ static int hid_temperature_probe(struct
 	if (ret)
 		goto error_remove_trigger;
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret)
 		goto error_remove_callback;
 
@@ -263,6 +263,7 @@ static int hid_temperature_remove(struct
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct temperature_state *temp_st = iio_priv(indio_dev);
 
+	iio_device_unregister(indio_dev);
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TEMPERATURE);
 	hid_sensor_remove_trigger(indio_dev, &temp_st->common_attributes);
 


