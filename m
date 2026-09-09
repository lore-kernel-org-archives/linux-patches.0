Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA49581241;
	Wed,  9 Sep 2026 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963861; cv=none; b=d5kj2clf/WqxoU696Udi80RaQCFVVgWQtKzmeuWGV3skY2S3iUw8alKPh/Jj9XGUc+3PN9edVG6OtbiRpPQB3VfkDIn2MV5ywee7l4Cf7OGRAqXI/Crx7HPPd1FEDUpNaMEdhGCa/wYRvAy3VlDCRqFDyq37vICeX6Rn6/rUprc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963861; c=relaxed/simple;
	bh=5wveHL6sRLX6sYUeBYnzKUzn9BWsGlKySvZwEL6Xgyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HX1g+tCFq0YxggFzwWwSi9DST+DTaxS2eiEn28NUX7Dn8vRSvsVL+jx4zxb4sfCISmqTRhG3MoD7wQPv6mhnoWiFBxUt8yc2kZyws+J+kZwD2J1VRFpOoJz/RbF3Dm+/85DVoqlrlAvfw9aZLP2dl6miPlC7lOcN3EYBEAcE/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NM3Nap2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NM3Nap2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30B01F00A3A;
	Wed,  9 Sep 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963860;
	bh=HJZwIea43nLHdPBbSVsLm0K5tZ2CIGLpLVMTZnpr2IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NM3Nap2Q3HaHSAauoYceHDroprYjzQZt4x/D86Q+QtwMLXrzOqXG4zsY21NcXRW5Z
	 rGUxBHkjk1gzYKaA/Lo+aLNfbSmCIWhXdB/bZ5+PpWGt0VjldoQiMR0a7cfRCdZuFr
	 OoQDPM13+sBfI6nBjllF1KPAi9ibtDjhyn9O6zDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxwell Doose <m32285159@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 221/583] iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()
Date: Wed,  9 Sep 2026 15:38:26 +0200
Message-ID: <20260909134245.812702842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -264,6 +264,7 @@ static void hid_temperature_remove(struc
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct temperature_state *temp_st = iio_priv(indio_dev);
 
+	iio_device_unregister(indio_dev);
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TEMPERATURE);
 	hid_sensor_remove_trigger(indio_dev, &temp_st->common_attributes);
 }


