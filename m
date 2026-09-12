Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B6E3815F8;
	Sat, 12 Sep 2026 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242034; cv=none; b=W+l0emtzGdiTyK6CtUTzmMYorip6J2p1Cwztbro4MBDXiBVqGOVHXCuoshHSMKEz4cFfEdfMmlcMHYM6B2/mbwnW1Avo0tGMnsc2PEArVInbvBOBojyF5wTFMYBDnTzx0NMYCu34WTLvCVPxdIeWvQBFWBRxSeYylkw6kwvjC70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242034; c=relaxed/simple;
	bh=TEjJOc3Ehy3Vn5zOi7jbztFeLUvzj4R4ToEACB9XMOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC7cAqy9c76+BgOc4n9zfTL5ZYp5RnOYhcUz5KhtNbspX6eQ3Xz0CQKyTwZ7hege7oK88ZBjBvfqqx6X4AXx8QOVwIOzaI5W0j2zxHi5MRJrGXuxuWcxjQhN4DOWY7QRy0aoZ6p8eXzKewXt/dYLldnyluYJpQPoafDwgwZKP/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZS0HTaxP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZS0HTaxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC6B1F000FF;
	Sat, 12 Sep 2026 19:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242033;
	bh=dCOiA0z7ijQs0QDwbZ3u2e44X3T1twlFl7+IbP0PmQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZS0HTaxPyqUaHRt4ls4i5kZCg8/fqdvZJIhhNBOb29pHXUPa6kwCxIRkCvETxIPV5
	 gjPXVuaOo34DgXVLin+2EPqwnxoqVegfCR+5Q/TZrUtOJUisadplXHz3QfILaT+VGL
	 uUK0jBWIVg43++qgc+y73JObr1PzVguvUhHGn9tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxwell Doose <m32285159@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 262/798] iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()
Date: Sat, 12 Sep 2026 08:58:10 +0200
Message-ID: <20260912065523.163573483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,7 +244,7 @@ static int hid_temperature_probe(struct
 	if (ret)
 		goto error_remove_trigger;
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret)
 		goto error_remove_callback;
 
@@ -264,6 +264,7 @@ static int hid_temperature_remove(struct
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct temperature_state *temp_st = iio_priv(indio_dev);
 
+	iio_device_unregister(indio_dev);
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TEMPERATURE);
 	hid_sensor_remove_trigger(indio_dev, &temp_st->common_attributes);
 


