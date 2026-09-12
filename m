Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E9C38F255;
	Sat, 12 Sep 2026 19:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242943; cv=none; b=gxQemgneRPulhdzkafvW+wAovoWOWC7RVHuQjfI9zZ0ftpg8U/vkY9cHGiH/sYon/kO0sC98XlmIY5VV1JGGqjOpV2+emoF1tfusybt5SvIi09hOrvgTZdOOUzUx26ry89pemxNnwst0Juynki/AvZhlBA/b/CwqyUSQC1FsxQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242943; c=relaxed/simple;
	bh=oQWovGGeI40QyrwKprikjXftCJZjSryMfLy0+wSOTZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNfY3ScbfSGAK5CDUyb0BKkfnoTNFlMZmVSKXny81KGZtrDyBFQCbJOfh5/WyhfVM7X3uuN4O/qlXnFno3fLrJ+5Egge1QLYuLbJI6rn3lqPLOd8gNE6lA9fUJIeUdu/uGPktDgCKbJpIk8j5uX8eycSDv/p0WjhM8uXGYD4Wsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVG/l8X4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVG/l8X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567D71F000FF;
	Sat, 12 Sep 2026 19:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242941;
	bh=OowBjB0ylq1S5/YScbv8y6vb0Lrls9IeGbSLk+De4uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVG/l8X4wZ4sVx3FNpPZanIuloAMZawm+mUjNVwOGMyJgUME5tsRPfNJ1P8+cHPjq
	 ExIIXIgAFI0CbYzRwWCvzjzUpLwBJ+qZjYEbcB56kL36+K0HwwCaivhwbr83o7tiN0
	 1/rFS9Ai1yTg/Ba7LITOgjhvwFw9XKw34YFx2mtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 581/798] HID: ensure timely release of driver-allocated resources
Date: Sat, 12 Sep 2026 09:03:29 +0200
Message-ID: <20260912065530.445136456@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 62c68e7cee332e08e625af3bca3318814086490d ]

More and more drivers rely on devres to manage their resources, however
if bus' probe() and release() methods are not trivial and control some
of resources as well (for example enable or disable clocks, or attach
device to a power domain), we need to make sure that driver-allocated
resources are released immediately after driver's remove() method
returns, and not postponed until driver core gets around to releasing
resources.

In case of HID we should not try to close the report and release
associated memory until after all devres callbacks are executed. To fix
that we open a new devres group before calling driver's probe() and
explicitly release it when we return from driver's remove().

This is similar to what we did for I2C bus in commit 5b5475826c52 ("i2c:
ensure timely release of driver-allocated resources"). It is tempting to
try and move this into driver core, but actually doing so is challenging,
we need to split bus' remove() method into pre- and post-remove methods,
which would make the logic even less clear.

Reported-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230505232417.1377393-1-swboyd@chromium.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 207853d46f7e ("HID: synchronize input before cleaning up a failed probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 17 +++++++++++++++++
 include/linux/hid.h    |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 32422f25c4cd4..68d1b9bfb6441 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2343,6 +2343,10 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 	if (!hid_check_device_match(hdev, hdrv, &id))
 		return -ENODEV;
 
+	hdev->devres_group_id = devres_open_group(&hdev->dev, NULL, GFP_KERNEL);
+	if (!hdev->devres_group_id)
+		return -ENOMEM;
+
 	/* reset the quirks that has been previously set */
 	hdev->quirks = hid_lookup_quirk(hdev);
 	hdev->driver = hdrv;
@@ -2355,7 +2359,16 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 			ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	}
 
+	/*
+	 * Note that we are not closing the devres group opened above so
+	 * even resources that were attached to the device after probe is
+	 * run are released when hid_device_remove() is executed. This is
+	 * needed as some drivers would allocate additional resources,
+	 * for example when updating firmware.
+	 */
+
 	if (ret) {
+		devres_release_group(&hdev->dev, hdev->devres_group_id);
 		hid_close_report(hdev);
 		hdev->driver = NULL;
 	}
@@ -2398,6 +2411,10 @@ static int hid_device_remove(struct device *dev)
 			hdrv->remove(hdev);
 		else /* default remove */
 			hid_hw_stop(hdev);
+
+		/* Release all devres resources allocated by the driver */
+		devres_release_group(&hdev->dev, hdev->devres_group_id);
+
 		hid_close_report(hdev);
 		hdev->driver = NULL;
 	}
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 68fec22033a55..5f5790f505b94 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -599,6 +599,7 @@ struct hid_device {							/* device report descriptor */
 	struct semaphore driver_input_lock;				/* protects the current driver */
 	struct device dev;						/* device */
 	struct hid_driver *driver;
+	void *devres_group_id;						/* ID of probe devres group	*/
 
 	struct hid_ll_driver *ll_driver;
 	struct mutex ll_open_lock;
-- 
2.53.0



