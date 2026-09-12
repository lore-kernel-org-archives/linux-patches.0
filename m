Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC47274B46;
	Sat, 12 Sep 2026 18:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237644; cv=none; b=jnWMosl5ogyvf30iCdA225eN+6ZkIupCaFUtgzrgTfOCN2j7bE999llmdF+ZMByV0Fu3OdB34THxjxH6reFCPtFozkz3XE7CtjECkk257EULryfHkHbHTiesHcJ3d/x8qn2X0ZCEx+JeCkQ2rzpilxpvS7ridc3f1hA98s9gnGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237644; c=relaxed/simple;
	bh=Mc/KYBRCbRZhSSqHvpldxd06+Mvg6QEN3wlwYSQfCTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJk11v8QzzBThQGYiDhC1gIKGrejfrI3mmsfKmDctByhxz86GkasYsJaz8WCfiQU74ZnR+u/oN4PVngqPxy1WRkPUyo0GTMUEs9+88JI/Ia97LlTu0KCejme5V9kK3dqUCE6ahW2x+JxI7h19STzaFUtH8zAwW+vZSRhl+S/vD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9u1vFyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9u1vFyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1077F1F000FF;
	Sat, 12 Sep 2026 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237642;
	bh=lZrmS8FAaNWHt44XJPIZsUPlnz5dWgd8r84YzEo0/1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9u1vFypLBJaNa6oRTPeBdud96etBn9aG+X9pWNCIneY/Oe/htASyF9Tr45cFTyc7
	 AqQF8r3AHvLBLDVuHTQNvgeSu7BgEj7RPyDgIy8eYKUaPzg2VQX+1wSgKwaEYCmC8l
	 6xb/J+gJ6qiDmZvx0/nDpzkGIHoGzErqzdkyfQt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxwell Doose <m32285159@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 298/935] iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()
Date: Sat, 12 Sep 2026 08:55:28 +0200
Message-ID: <20260912065533.644513215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


