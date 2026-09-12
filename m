Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5315C3446AD;
	Sat, 12 Sep 2026 12:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216994; cv=none; b=J6HWrfDVI8av4XPvDohs3nMLSKZ/KyKe6e4vp89ObAOAMzfjf/T/wp0vgcxcGHmrW2zs3gGcbnygC22rGm6Pil8yUh9RDTvmpplU9RX639bC8OWK9NgewaXa/cs1ujx24SJ95rCrB8Zf4RpnU59ic2n0v9T8+KsGvtmREOv72g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216994; c=relaxed/simple;
	bh=a8kJtqAOUtjRB2xY0pZgrbDe3m9MbI6mHZHoYUobbEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6ZmSUGU+Cce+9Hsg49d0w9IO/5G+ux8spCEoWN9YHgx0H5lp0e3zBRADv9jmjivjkWotKInvi65CdM6thUyoSUhVp8e4eqw4lHsvZFlG7fP1s3VMzhVuHTtZS2+2Iw/AyD2JTyHQxfJzqyG79l3hKj9wuQ/oN6gKphiPXC8ZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0a3E8LP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0a3E8LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E001F000FF;
	Sat, 12 Sep 2026 12:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216993;
	bh=lDM+5NJM8HtKFHV29WYXlEPJvoVPUO4aLgQqyiCWrfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0a3E8LPonR3hrOcF0mjS4JjVWlZSZS5+kaWLbzfbneMKW/GvT21s3023q4u7TfAc
	 oDFDLpbiH6ovb9o6y8Q9qxK9hy1AmtbwUSxh2voQ2iXVfPztYJemkaK5rG9JAPu+3B
	 VITqWY02lDMKEtDjpUe+7rjMI1qrYvu/d25EyYoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com,
	Slawomir Stepien <sst@poczta.fm>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0851/1376] wifi: zd1211rw: reject secondary interfaces to prevent conflicts
Date: Sat, 12 Sep 2026 08:54:37 +0200
Message-ID: <20260912065626.524418130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slawomir Stepien <sst@poczta.fm>

[ Upstream commit 0e4532ec658606f76f62eb277e7a933919d36cbb ]

The zd1211rw driver is designed for single-function Wi-Fi dongles and
hardcodes its USB endpoints. When a malformed USB device exposes multiple
interfaces that match the driver's device ID, the driver blindly binds to
all of them.

During probe(), the driver calls usb_reset_device(), which iterates over
all interfaces and invokes the pre_reset() callback for each bound
interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
called sequentially for each instance, acquiring their respective
&mac->chip.mutex. Because all instances initialize their mutexes with the
same lock class, lockdep detects a task acquiring a lock of the same class
it already holds and flags it as a possible recursive deadlock:

WARNING: possible recursive locking detected
kworker/0:1/11 is trying to acquire lock:
ffff88810371dde0 (&chip->mutex){+.+.}-{4:4}, at:
zd_chip_disable_rxtx+0x20/0x50
drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465

but task is already holding lock:
ffff8881138ddde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505

Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
0) during probe(). This ensures that only a single instance of the driver
binds to the device, eliminating the recursive locking scenario.

Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
Link: https://syzkaller.appspot.com/ai_job?id=00724ef7-fd77-4cde-9779-895b8f63c2f6
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
Link: https://patch.msgid.link/20260730065231.1644030-1-sst@poczta.fm
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 9ae10f65f2af0..8b8abcfbbfc8f 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1352,6 +1352,14 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct zd_usb *usb;
 	struct ieee80211_hw *hw = NULL;
 
+	/*
+	 * ZD1211 devices are single-function. Reject secondary interfaces
+	 * to prevent multiple instances from conflicting on hardcoded endpoints
+	 * and triggering recursive locking warnings.
+	 */
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
+		return -ENODEV;
+
 	print_id(udev);
 
 	if (id->driver_info & DEVICE_INSTALLER)
-- 
2.53.0



