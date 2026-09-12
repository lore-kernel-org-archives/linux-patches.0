Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FE42D23A6;
	Sat, 12 Sep 2026 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222368; cv=none; b=AuCIE1loUJpP+qRpLaTMQ1sP+kTic1iDh1Xzxh9I0LARXQ/PoM5kaPRDkfOiIdAZl2R+g6lnFQmQskxa1n95llR2uGaTnCZ5uXh3FI3hUvHKT/qnvlXa1rbmpTxw51FAAe6tJZWGCkN9Hsbm+b1n7ol8NcOBKDJ4oASjeuLOa1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222368; c=relaxed/simple;
	bh=OE2zuBwcNDZnPlMtl1HbLuH1gajZbwL6NBJ5Zqaupwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC3xtl0U15EzkFURwy+VUfrN3fdLlp5Pn5MPAAZIXQjOatRtL43BHS2txlcHRxBcVv4mtIfL3NEsKsdhHdXBJppboKxLlXfSTdmmaKKclZAo+1MV+DBz1b40kYNJstrSvsX/wXNLMLPI6KKQ93cqvPDGdILMHtC93T9K5SFbmfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2Hx5mbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2Hx5mbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFB71F000FF;
	Sat, 12 Sep 2026 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222366;
	bh=aZEDEOt/ojHW9YGnhBlT2eN8yT2WwtFe/FBq1YwqN4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2Hx5mbZFvVILSDR7hOiOR0KE/zR5PHIPZc6Uaeqi2Xlstqsa6PUWFu4dshDa/T+I
	 dNv+UW6elmJzkrKV39v2mL1/1tYI+lOA5QMB3oIS/yXsSkoQIPeR7EW0msCGJuIGz+
	 f55OlrUAdD9wGIgcARluERs8gy0HVlEatngURK80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Philipp Weber <kernel@phwe.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0571/1424] HID: core: quiesce input in hid_hw_stop() to prevent use-after-free
Date: Sat, 12 Sep 2026 08:50:03 +0200
Message-ID: <20260912065620.088655298@linuxfoundation.org>
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
index b924980b5783e..241dfec35d1c0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2370,9 +2370,16 @@ EXPORT_SYMBOL_GPL(hid_hw_start);
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



