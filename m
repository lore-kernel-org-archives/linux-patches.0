Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD326AC5;
	Sat, 12 Sep 2026 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230854; cv=none; b=kCZdtVF+HwSfrEJEUDdSOrOgV2gdS+lPn3A1efn9aWNUcoyk02D67VSd5c69rCuXktJxF6wfipdjvsiHEv8HHfM0GvyXHYvaFkFIaWAI+IedxK7i5iqGHdyng2Y8uKSbO6Ya/Xay2TYbJCMNPzciMO4blMOhmJJq3i7UVUwreoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230854; c=relaxed/simple;
	bh=+qR4pteQWU5LTONhuiV38Snawb86PNvEJIlTCQpGXWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lkv5IGSmTJqw0TyuNoNIoPtbz59BtJuak48LMVFC5ywS0oN2svazTwIwdtshWot7HxLfHMVe/d3aSZNxxpxdOBvLnenQTksJolTf2Jx3zAaSpSDt1fGTEMq+aF/sg/4K5gQsRE3tIt2xL8zYxHJ6H0gZvySitDEsEmmeolOKo7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk7ujx6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk7ujx6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB541F000FF;
	Sat, 12 Sep 2026 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230852;
	bh=SDUnPKL7cDaCTvZ/B9A0fUk1sadtc+Cf75C0cRiINBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wk7ujx6gYdtPi3qL2IpJVvKceXsjBjZ+Ib1gvc75Hf8bn85WRMprFHv90UEfxmXAi
	 UIrNkJcudoP10szcZNWSDGdiDPO2D62NQ+UU+rj3uvUP0Xq0lkGKoGs+GkoxhcDYhG
	 b3IMso7HJPgGRqENWaIet8sQ5LVe0Mts/k8nU8DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0836/1191] HID: split apart hid_device_probe to make logic more apparent
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065607.037530839@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 207733f9266194b3cd90ddae723a1f82eb64030b ]

hid_device_probe() has a complex flow and locks and unlocks a mutex.
Move the most of the logic into __hid_device_probe() and
hid_check_device_match() and leave the locking in hid_device_probe()
which makes the code more clear.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 207853d46f7e ("HID: synchronize input before cleaning up a failed probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 101 ++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 47 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9b4c071d57d38..b09ff4cabd53a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2639,64 +2639,71 @@ bool hid_compare_device_paths(struct hid_device *hdev_a,
 }
 EXPORT_SYMBOL_GPL(hid_compare_device_paths);
 
+static bool hid_check_device_match(struct hid_device *hdev,
+				   struct hid_driver *hdrv,
+				   const struct hid_device_id **id)
+{
+	*id = hid_match_device(hdev, hdrv);
+	if (!*id)
+		return -ENODEV;
+
+	if (hdrv->match)
+		return hdrv->match(hdev, hid_ignore_special_drivers);
+
+	/*
+	 * hid-generic implements .match(), so we must be dealing with a
+	 * different HID driver here, and can simply check if
+	 * hid_ignore_special_drivers is set or not.
+	 */
+	return !hid_ignore_special_drivers;
+}
+
+static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
+{
+	const struct hid_device_id *id;
+	int ret;
+
+	if (!hid_check_device_match(hdev, hdrv, &id))
+		return -ENODEV;
+
+	/* reset the quirks that has been previously set */
+	hdev->quirks = hid_lookup_quirk(hdev);
+	hdev->driver = hdrv;
+
+	if (hdrv->probe) {
+		ret = hdrv->probe(hdev, id);
+	} else { /* default probe */
+		ret = hid_open_report(hdev);
+		if (!ret)
+			ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	}
+
+	if (ret) {
+		hid_close_report(hdev);
+		hdev->driver = NULL;
+	}
+
+	return ret;
+}
+
 static int hid_device_probe(struct device *dev)
 {
-	struct hid_driver *hdrv = to_hid_driver(dev->driver);
 	struct hid_device *hdev = to_hid_device(dev);
-	const struct hid_device_id *id;
+	struct hid_driver *hdrv = to_hid_driver(dev->driver);
 	int ret = 0;
 
-	if (down_interruptible(&hdev->driver_input_lock)) {
-		ret = -EINTR;
-		goto end;
-	}
-	hdev->io_started = false;
+	if (down_interruptible(&hdev->driver_input_lock))
+		return -EINTR;
 
+	hdev->io_started = false;
 	clear_bit(ffs(HID_STAT_REPROBED), &hdev->status);
 
-	if (!hdev->driver) {
-		id = hid_match_device(hdev, hdrv);
-		if (id == NULL) {
-			ret = -ENODEV;
-			goto unlock;
-		}
+	if (!hdev->driver)
+		ret = __hid_device_probe(hdev, hdrv);
 
-		if (hdrv->match) {
-			if (!hdrv->match(hdev, hid_ignore_special_drivers)) {
-				ret = -ENODEV;
-				goto unlock;
-			}
-		} else {
-			/*
-			 * hid-generic implements .match(), so if
-			 * hid_ignore_special_drivers is set, we can safely
-			 * return.
-			 */
-			if (hid_ignore_special_drivers) {
-				ret = -ENODEV;
-				goto unlock;
-			}
-		}
-
-		/* reset the quirks that has been previously set */
-		hdev->quirks = hid_lookup_quirk(hdev);
-		hdev->driver = hdrv;
-		if (hdrv->probe) {
-			ret = hdrv->probe(hdev, id);
-		} else { /* default probe */
-			ret = hid_open_report(hdev);
-			if (!ret)
-				ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-		}
-		if (ret) {
-			hid_close_report(hdev);
-			hdev->driver = NULL;
-		}
-	}
-unlock:
 	if (!hdev->io_started)
 		up(&hdev->driver_input_lock);
-end:
+
 	return ret;
 }
 
-- 
2.53.0



