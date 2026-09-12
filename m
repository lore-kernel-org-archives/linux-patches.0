Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF22C21F7;
	Sat, 12 Sep 2026 09:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206014; cv=none; b=K4DplIYwQVGyMHnYOVJALL0dr3wQpSQKrcIUikV2beKJ2v7+ssuD7dvDWRzwLAFHDn1y2vEkaP9A3EHLrSKLFacrGQFntDkRc3LEYbxoTswgTeJdZE47UHSDYOfa/CukpCQgttzVCgO5Y8OemuECakYGR9N1yRYdnt+M9rW9s+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206014; c=relaxed/simple;
	bh=ILBn/zIsjMUStIQfuiiG2I1t0i7dKO2cPr8xQ9sL4jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rq1N4kJNnD5gPOnsEl5pVFyfMR0AOmbXh4QvBW48QGFMe2gWlnEFrao6/ElYkMn5jlk8FbUpQ46qhmu24ALy62jczO/MdbW2lSVnmqOq0olfO/bWaqabdNQ//TlFH+0WnM4AVtKYNYb1v2YtbmneU0iBqFkUtTzd9XWvvNRvOXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzqSfUVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzqSfUVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BF51F000FF;
	Sat, 12 Sep 2026 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206012;
	bh=FRkkB3pdhct4yz6qvpDdr+9/7ksbCu6Nl4lzCjF7shs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzqSfUVhHLTOq4vH7b0LK4nEXH9wWNkSt9TH7DvjbQR5XPAD3aJGA/gpvL8ljerOA
	 BmLPOI5duyZc7Ips50U9jdHTED7XdFMbAfCUmFNHmck0dRT+LFeNk2QYUiO5MqfXdd
	 KveaXQ6OtRjmXezCYFSoEjY4qNTF3T2iHGOn6iR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Philipp Weber <kernel@phwe.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0119/1518] HID: core: quiesce input in hid_hw_stop() to prevent use-after-free
Date: Sat, 12 Sep 2026 08:38:08 +0200
Message-ID: <20260912065626.181611894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 7f442a2798d8f..55990d17c5669 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2450,9 +2450,16 @@ EXPORT_SYMBOL_GPL(hid_hw_start);
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



