Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA2038DC7B;
	Sat, 12 Sep 2026 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238298; cv=none; b=ZnfMefhD8aP5uf2MP6FCKHQw7pXvSK09I+AqGzu2yz3Azsy8PbQerHBB4EVvtWB4Yw6KLMVw+PVv6e3GBnsiuzp28gVHKO3BWybeuypNPiWLMlfEVQR7H1y3lDC9Kmad5T2Ojzl1fiH0Oq1wxW7fjMZ49k0EH0Tcl/OQ/eeSoO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238298; c=relaxed/simple;
	bh=oZ6J9BE7IdRkATV/gL1bxqTXIZjylNoxLevLJx6V53A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXpC3zy6FtDC6vrawv8t6jUfycGgyl81oH7jArdAUF+uwCMlJhIVst+sZ64lQae4+y7ByOkvmmralOz++ajstPfcCfYfkS86KPBKj0dyY65Q5RedHZBWujrv36vsDT5shv67+CEG07mraf2qnVNzT1D5FF9VfyvdtQzzFr/eo+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIRMwLzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIRMwLzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D61F000FF;
	Sat, 12 Sep 2026 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238296;
	bh=lX3/YY3YrkKxhCPohAqWxjj2ok2P9AVju3BYyU4lQis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIRMwLzdQsV8mtQUz4LiR3kn4Z9l7YqVdkbT2MIGovFNdyRnJ95+0tNKrsPMXzOrw
	 OF+ftGvxP8XUAT68jDpy8P+VpeSNqFthQz7Wa+0LakL7gRvXRs2fmvuQt6N0Z/uRwI
	 42HhqcTuZtR87bbk8Vl+kbyF0owLiQKDSdmzdgfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/935] iio: orientation: hid-sensor-rotation: Avoid race between callback setup and device exposure
Date: Sat, 12 Sep 2026 08:57:42 +0200
Message-ID: <20260912065536.736268302@linuxfoundation.org>
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

[ Upstream commit 0e32649a7cf3cd784862f8dc0c68a5134731bfff ]

The driver currently exposes the IIO device to userspace before
completing sensor hub callback registration, and similarly removes
callbacks while the device can still be accessed during teardown.

This creates a timing window where userspace may enable the buffer
before callbacks are available. In such cases:
- samples can be dropped,
- buffered reads may observe stale or no data.

Reorder probe and remove paths to ensure callbacks are active before
device exposure and are removed after device is no longer accessible.

This avoids a race window leading to data loss.

Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Fixes: fc18dddc0625 ("iio: hid-sensors: Added device rotation support")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/orientation/hid-sensor-rotation.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/orientation/hid-sensor-rotation.c b/drivers/iio/orientation/hid-sensor-rotation.c
index f124062af383b..0d2aca1d36ae5 100644
--- a/drivers/iio/orientation/hid-sensor-rotation.c
+++ b/drivers/iio/orientation/hid-sensor-rotation.c
@@ -337,12 +337,6 @@ static int hid_dev_rot_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = iio_device_register(indio_dev);
-	if (ret) {
-		dev_err(&pdev->dev, "device register failed\n");
-		goto error_remove_trigger;
-	}
-
 	rot_state->callbacks.send_event = dev_rot_proc_event;
 	rot_state->callbacks.capture_sample = dev_rot_capture_sample;
 	rot_state->callbacks.pdev = pdev;
@@ -350,13 +344,19 @@ static int hid_dev_rot_probe(struct platform_device *pdev)
 					&rot_state->callbacks);
 	if (ret) {
 		dev_err(&pdev->dev, "callback reg failed\n");
-		goto error_iio_unreg;
+		goto error_remove_trigger;
+	}
+
+	ret = iio_device_register(indio_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "device register failed\n");
+		goto error_remove_callback;
 	}
 
 	return 0;
 
-error_iio_unreg:
-	iio_device_unregister(indio_dev);
+error_remove_callback:
+	sensor_hub_remove_callback(hsdev, hsdev->usage);
 error_remove_trigger:
 	hid_sensor_remove_trigger(indio_dev, &rot_state->common_attributes);
 	return ret;
@@ -369,8 +369,8 @@ static int hid_dev_rot_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct dev_rot_state *rot_state = iio_priv(indio_dev);
 
-	sensor_hub_remove_callback(hsdev, hsdev->usage);
 	iio_device_unregister(indio_dev);
+	sensor_hub_remove_callback(hsdev, hsdev->usage);
 	hid_sensor_remove_trigger(indio_dev, &rot_state->common_attributes);
 
 	return 0;
-- 
2.53.0



