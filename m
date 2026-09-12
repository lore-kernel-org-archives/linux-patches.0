Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB483BCD19;
	Sat, 12 Sep 2026 07:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196931; cv=none; b=o+pjcQucmt7qWsUdUFAwQrkL8j74Il0lEupUlo3Sw5haSQMp3lNO+Url1xHxQbwab5WzHRTSA7dbFOzoIkFsl/cN+Je5Y1hKswt+PKv4b6EGoP31YJEwkzPatgOgY7xQSl41xuYxm+tiGIyshHjsW7O9bl1xezXHS7gHbVErHGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196931; c=relaxed/simple;
	bh=lGSGue5zSxnYkVqFDKDG8WSe09tQH2dS3BxYuR60RBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4Bl6EMVnGYI04pk7tSEoBvUnOlctaDMU0XLDaPjJUqhSjqdGIRSvlcgGMiF1azys//+pZn+VvTBQJxvBBqDtBN3YWFkHreJIuXVkXe1mRqb0tfflPm3m3zuNj1T0D3J/eMI6+1wkUtOH0etrq/CFmrIP+ruzAoGEoQ6toRihmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=surlvQoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="surlvQoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0E81F000FF;
	Sat, 12 Sep 2026 07:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196930;
	bh=z7DROgJmJ8g8Qz9U4QFsIcefnE8N3I5t6EnV6R2csBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=surlvQoTpV1ujh5zjQMW2t7PXrKr7zXawhOBnpw+8wgXzXQhd7QafP9SOzsSSmi6O
	 KcKY1JDCFbpWSwWjxiXKVBEyD22wdUQHnhZ4q9fT2D0Oo89Q0tJ71qtMlr5oAPFpZr
	 B104ZyWPz2uROzFqHZHO6xwnDOMZTUFYzpmZ/kxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Philipp Weber <kernel@phwe.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0066/1815] HID: core: quiesce input in hid_hw_stop() to prevent use-after-free
Date: Sat, 12 Sep 2026 08:30:16 +0200
Message-ID: <20260912065650.557934612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Weber <kernel@phwe.de>

[ Upstream commit a4bc41504690b7d7064931909874f5b98cd148b6 ]

A driver's probe calls hid_device_io_start() to enable input delivery,
then fails at a later initialization step and unwinds via hid_hw_stop().
The unwind frees struct hidraw via hidraw_disconnect() while in-flight
HID reports may still be running on another CPU, dereferencing the
freed object through hidraw_report_event(). syzbot reports the
resulting use-after-free for the corsair-psu HID driver.

Edward Adam Davis posted a per-driver fix for corsair-psu that adds
an explicit hid_device_io_stop() before hid_hw_stop() in the probe
error path ("hwmon: prevent packets from going to driver for probe",
2026-04-28). Auditing the tree shows 15 drivers call
hid_device_io_start(); 7 also call hid_device_io_stop() and 8 do not:

  drivers calling hid_device_io_start() without a matching
  hid_device_io_stop() before hid_hw_stop():
    drivers/hwmon/corsair-psu.c       (fix posted by Edward)
    drivers/hwmon/corsair-cpro.c
    drivers/hwmon/nzxt-kraken3.c
    drivers/hwmon/nzxt-smart2.c
    drivers/hwmon/gigabyte_waterforce.c
    drivers/hid/hid-logitech-dj.c
    drivers/hid/hid-nintendo.c
    drivers/hid/hid-mcp2221.c

Roughly half of all callers of the API are exposed. Centralize the
quiesce in hid_hw_stop() so callers do not have to remember the
matching stop: if a driver has left hdev->io_started true on entry,
call hid_device_io_stop() before hid_disconnect().

For the 7 drivers that already call hid_device_io_stop() correctly,
hdev->io_started is false on entry, the guard short-circuits, and
behavior is unchanged.

No Fixes: tag because the affected drivers gained their
hid_device_io_start() calls independently over years; the bug is a
class-wide API misuse rather than a regression from one commit.

Reported-by: syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9eebf5f6544c5e873858
Signed-off-by: Philipp Weber <kernel@phwe.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d6fbc2111facd..5add6c9f2807a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2454,9 +2454,16 @@ EXPORT_SYMBOL_GPL(hid_hw_start);
  *
  * This is usually called from remove function or from probe when something
  * failed and hid_hw_start was called already.
+ *
+ * If the caller enabled HID input via hid_device_io_start() and is unwinding
+ * without an explicit hid_device_io_stop(), quiesce input first so that
+ * in-flight reports cannot reach handlers (e.g. hidraw_report_event) whose
+ * backing objects hid_disconnect() is about to free.
  */
 void hid_hw_stop(struct hid_device *hdev)
 {
+	if (hdev->io_started)
+		hid_device_io_stop(hdev);
 	hid_disconnect(hdev);
 	hdev->ll_driver->stop(hdev);
 }
-- 
2.53.0



