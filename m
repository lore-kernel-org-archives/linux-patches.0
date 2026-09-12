Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56939022B;
	Sat, 12 Sep 2026 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242940; cv=none; b=jSUdTbnpFMimuEZA9IcDSNlO80I9/M8iLlrot6B7vB/qCpWZ7lAFnxFM8X/k4mK1WulO+py0f35FUI8jJK4q569XrTdOnyckLwaoZhaiaCrwNw8Wkg6oGiys20cPoUzuYq28Hp5S1jD5JPXF/ZoU15+mWnQL/i6ryHzrlZRqtnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242940; c=relaxed/simple;
	bh=oOG4veo5yv34ufdpOVRqTRWJZ04z95itBYnxOpP8/Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF1LAnKU0+Gg4HBmbHvaqY9CpXG+aQsNAMXVl4nh/K1xSHpq/6N63YT6NEsR6zsRI5sRMgws1XKAtPRsd4N5KCtZp4J2teir3fEiltUy+2p5MzW9VZGYTuZ79ZfQ3H1eteSAWE8S4hlMYQPBDPOiJzhBJ9EF645OnpLiDDTBPKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16ig9Dv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16ig9Dv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F211F000FF;
	Sat, 12 Sep 2026 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242939;
	bh=4VHaFUhH4NfcVvv+83KZigD8rR67eu4DaPu8zWrCXqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16ig9Dv94kmihG0OQpc1XXyTK/VcD8TbI1Z3Ql9idxmeVDUxj14FgKqDJSknS71Rw
	 SsXZR1G/3S9+t0Mk3czkiq7lTCRV4Hlxh87U/4ZHu3yALi/8d0oTh1HesIqPRFgGbn
	 X9WTKXDvM4e0SXZSQuyY2KCvfLf2l2Q8tXzCwbdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 580/798] HID: split apart hid_device_probe to make logic more apparent
Date: Sat, 12 Sep 2026 09:03:28 +0200
Message-ID: <20260912065530.423392498@linuxfoundation.org>
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
index 7a6507b625546..32422f25c4cd4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2316,64 +2316,71 @@ bool hid_compare_device_paths(struct hid_device *hdev_a,
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



