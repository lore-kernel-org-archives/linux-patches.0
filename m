Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E364D24CEEA;
	Sat, 12 Sep 2026 10:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210464; cv=none; b=fBE88MGHjV8ahDongBH3ptIJZH3m6l1AXMvkerg/RIOV04w/aSPmBY+Q5BeOlhDiywzBjfvH+pS97C1rJHcTtl+zEJxRe8sUlSeXg6k2sYaSsDfKVaJKWivJHE9slRCWx9jiYDtspQhI1ssLlafc9QnB5hZ19uRhGwVRr+GBsN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210464; c=relaxed/simple;
	bh=vrtSSFZsXFT074DmKQ6dXn91jqvsEywnEOQUqlpUvkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9bbLsIpY0oCeLvv1CH/fHK3UAWQen0t9vfB2/OLe+hfJLO58M2GUbimMxOpPXk4ZlpeSOeFJxVzNu4Xu+X0EPVWi8Kf6rufnWmae6Rd2DdfPeMC3i6xTpdtcpg1csHPA1pR4CfaRVa+bcXDyEda9edevLLM0cRknWRcflAyw70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsLEIpFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsLEIpFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBEC1F000FF;
	Sat, 12 Sep 2026 10:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210462;
	bh=8ylYdJQtov7/JOYHzRNrjmX6jDxitXXNOsalqKBm7pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsLEIpFmQfavJgFR99IshrTVr9EMAYVxzQNrG0S+3cqAYGNGB+1O67f9WXJvLOOry
	 AO+EDKyiFksdN5U4Z4oQ/iN/bR+DHS2mjEaIZCM4CFodW9lPQVdM5DRXVUIIcz2HGr
	 eTkSSM2dFWrdExbA8GMtG14sXsOa5lFUNIheDm2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1031/1518] Bluetooth: btmtk: add MT7902 SDIO support
Date: Sat, 12 Sep 2026 08:53:20 +0200
Message-ID: <20260912065646.773593849@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 7f2c3c49ba0d3fead557a8026a021ebe23f919d6 ]

Add MT7902 Bluetooth SDIO support by introducing chip data and
registering the device ID.

Runtime PM is not yet supported by the driver, but normal operation
is unaffected.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: b0c0b3794011 ("Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 42 ++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index d2583bc742632..d262f60fd3917 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -42,24 +42,35 @@ struct btmtksdio_data {
 	const char *fwname;
 	u16 chipid;
 	bool lp_mbox_supported;
+	bool pm_runtime_supported;
 };
 
 static const struct btmtksdio_data mt7663_data = {
 	.fwname = FIRMWARE_MT7663,
 	.chipid = 0x7663,
 	.lp_mbox_supported = false,
+	.pm_runtime_supported = true,
 };
 
 static const struct btmtksdio_data mt7668_data = {
 	.fwname = FIRMWARE_MT7668,
 	.chipid = 0x7668,
 	.lp_mbox_supported = false,
+	.pm_runtime_supported = true,
 };
 
 static const struct btmtksdio_data mt7921_data = {
 	.fwname = FIRMWARE_MT7961,
 	.chipid = 0x7921,
 	.lp_mbox_supported = true,
+	.pm_runtime_supported = true,
+};
+
+static const struct btmtksdio_data mt7902_data = {
+	.fwname = FIRMWARE_MT7902,
+	.chipid = 0x7902,
+	.lp_mbox_supported = false,
+	.pm_runtime_supported = false,
 };
 
 static const struct sdio_device_id btmtksdio_table[] = {
@@ -69,6 +80,8 @@ static const struct sdio_device_id btmtksdio_table[] = {
 	 .driver_data = (kernel_ulong_t)&mt7668_data },
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MEDIATEK, SDIO_DEVICE_ID_MEDIATEK_MT7961),
 	 .driver_data = (kernel_ulong_t)&mt7921_data },
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MEDIATEK, SDIO_DEVICE_ID_MEDIATEK_MT7902),
+	.driver_data = (kernel_ulong_t)&mt7902_data },
 	{ }	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(sdio, btmtksdio_table);
@@ -1091,6 +1104,7 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 	set_bit(BTMTKSDIO_HW_TX_READY, &bdev->tx_state);
 
 	switch (bdev->data->chipid) {
+	case 0x7902:
 	case 0x7921:
 		if (test_bit(BTMTKSDIO_HW_RESET_ACTIVE, &bdev->tx_state)) {
 			err = btmtksdio_mtk_reg_read(hdev, MT7921_DLSTATUS,
@@ -1168,22 +1182,24 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 	delta = ktime_sub(rettime, calltime);
 	duration = (unsigned long long)ktime_to_ns(delta) >> 10;
 
-	pm_runtime_set_autosuspend_delay(bdev->dev,
-					 MTKBTSDIO_AUTOSUSPEND_DELAY);
-	pm_runtime_use_autosuspend(bdev->dev);
+	if (bdev->data->pm_runtime_supported) {
+		pm_runtime_set_autosuspend_delay(bdev->dev,
+						 MTKBTSDIO_AUTOSUSPEND_DELAY);
+		pm_runtime_use_autosuspend(bdev->dev);
 
-	err = pm_runtime_set_active(bdev->dev);
-	if (err < 0)
-		return err;
+		err = pm_runtime_set_active(bdev->dev);
+		if (err < 0)
+			return err;
 
-	/* Default forbid runtime auto suspend, that can be allowed by
-	 * enable_autosuspend flag or the PM runtime entry under sysfs.
-	 */
-	pm_runtime_forbid(bdev->dev);
-	pm_runtime_enable(bdev->dev);
+		/* Default forbid runtime auto suspend, that can be allowed by
+		 * enable_autosuspend flag or the PM runtime entry under sysfs.
+		 */
+		pm_runtime_forbid(bdev->dev);
+		pm_runtime_enable(bdev->dev);
 
-	if (enable_autosuspend)
-		pm_runtime_allow(bdev->dev);
+		if (enable_autosuspend)
+			pm_runtime_allow(bdev->dev);
+	}
 
 	bt_dev_info(hdev, "Device setup in %llu usecs", duration);
 
-- 
2.53.0



