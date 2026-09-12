Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8CA33993;
	Sat, 12 Sep 2026 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222643; cv=none; b=R8j4ATM40c8EHIOXWonId86fESnbrwFCfPM0Zb3OhLZDURZfX2L97rg9Pd/vabj1jKQgkSsjGUJnyoku5CRM1iZ0ZagjnG/x1Pva5bmiDqfMCt6KQELb4NFaMqvm7D/2AVrd5Tux2aOuj8lnUyGM1pCvquKMSOHG86Yl/limp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222643; c=relaxed/simple;
	bh=4tqPrUwdaQecaIvG2ZrJzeI8BRY6SRHGBSi+IyMeItQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKzs4yb8DbixoONuSnwpQC9sHu10zOJD7u8yfhK3TWdDZG4iLpR3ZF4w8oONgK8HWfCHej1krmUU8J+zk7DUHURQN5g9VeELS8xF+h2A2q9CjYsAp7HKJqwutDOFcioB9aFQhph91IYyG4ZtLtpY3fiMg/ElgDVtcCBS+DiGQ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SwF7+Fi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SwF7+Fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A411F000FF;
	Sat, 12 Sep 2026 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222642;
	bh=19r8o2zeZeskDyIKEg+ZWmW3bY1027gEGIuRS9KBqzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SwF7+FiInyzEQ6tVKzk5c2AItJULg4h7k2rY+MFYsFEDR7d4jOe84BdilPvbQ77T
	 IpOVfr9aUG/cRRXhhaQWki8G0p6v7axB7dT7GVi5phFYfe3HEDTx9olgKlXdp6wBYg
	 myL0vXizLsH+11vMWfQCQTFcK0D+cCa5iSh3iE3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0626/1424] iio: orientation: hid-sensor-rotation: Avoid race between callback setup and device exposure
Date: Sat, 12 Sep 2026 08:50:58 +0200
Message-ID: <20260912065621.308995954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



