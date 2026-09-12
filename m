Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395D2F617C;
	Sat, 12 Sep 2026 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238650; cv=none; b=XNa2SK6uJy0avapn8Hj07oOArTOJXpvMn4PmjAl17vdo5uyBx5fjdd9712eKsd9GGnx1K5sLnwuxyuVhJvKLn3CbKIqyeYVphQ7vozDQBCSHnoqbziGbicdzqEUth/HEE2MVhFDhCdnbTcJL9iqBN8Z7xKcOocC/s7Qi8CNiaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238650; c=relaxed/simple;
	bh=NjauW7yxQSAizTZD8gXRW0B1pvOfo0XktUe2+FBfCas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zpn5KeD3TJQYuLH+kQNwgZeVWmrOjDRhB0ca3JKLziwQLazpF6RTSQrTWynkIJBur0zPhplyl9LqZaP7gJQFPYx5p/l71N9Mma2G0kycTs8NmnBsJO0xsbNvMJ/38j+671DpaA03oWVsxzkVSQ8X8MN2IKfuoCIu9Ql0csTSKWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O43xrgEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O43xrgEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047F71F000FF;
	Sat, 12 Sep 2026 18:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238648;
	bh=7ElN2Hrdq7Rf2eEl8FLv8WRgQvOa3wSeaAdbfIsjuio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O43xrgEU7m+gNhtnLTgDG8QFsms6GKkk/45RROKDS5NZz4pZxI28oFfr5WLsYBEZL
	 nhgHWnxK87YPtXo1y36EsWB/J4ZREWsfSpBCW/WRaI+IsUfk7d4Y1zoh/vE6UtyZYS
	 gMuiXXfmrGEc37NHJwTUPLuYH+ht0Nkqyey4tY6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 506/935] misc: rtsx_usb: avoid USB I/O in runtime autosuspend
Date: Sat, 12 Sep 2026 08:58:56 +0200
Message-ID: <20260912065538.422555392@linuxfoundation.org>
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

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit 483c948324a3823871c004560a92545759d3253c ]

The runtime autosuspend callback currently queries card status and
clears OCP by issuing USB register accesses. This can run from the
USB runtime-PM path itself, which is the wrong place to start more
device I/O.

Keep a cached copy of the card-status bits from normal status reads
instead. During runtime autosuspend, use that cached value only to
preserve the existing Memory Stick autosuspend deferral.

Do not treat raw SD_CD as an autosuspend blocker, because tray-based
SD readers can assert SD_CD with an empty tray. A real SD card is
protected by the SD/MMC child runtime-PM usage once powered.

Also stop clearing OCP from the runtime autosuspend callback, so the
callback does not issue USB commands.

Fixes: bb400d2120bd ("mfd: rtsx_usb: Defer autosuspend while card exists")
Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_usb.c | 23 ++++++++++++++++++++---
 include/linux/rtsx_usb.h           |  3 +++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/cardreader/rtsx_usb.c b/drivers/misc/cardreader/rtsx_usb.c
index f546b050cb495..0a585be7f0860 100644
--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -312,6 +312,9 @@ int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status)
 	if (ret < 0)
 		return ret;
 
+	ucr->card_status_cache = *status;
+	ucr->card_status_valid = true;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtsx_usb_get_card_status);
@@ -619,6 +622,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 {
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
 	struct rtsx_ucr *ucr;
+	u16 status;
 	int ret;
 
 	dev_dbg(&intf->dev,
@@ -655,6 +659,9 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	if (ret)
 		goto out_init_fail;
 
+	/* Prime cached status for runtime autosuspend decisions. */
+	rtsx_usb_get_card_status(ucr, &status);
+
 	/* initialize USB SG transfer timer */
 	timer_setup(&ucr->sg_timer, rtsx_usb_sg_timed_out, 0);
 
@@ -709,17 +716,27 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	struct rtsx_ucr *ucr =
 		(struct rtsx_ucr *)usb_get_intfdata(intf);
 	u16 val = 0;
+	bool valid = false;
 
 	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
 			__func__, message.event);
 
 	if (PMSG_IS_AUTO(message)) {
 		if (mutex_trylock(&ucr->dev_mutex)) {
-			rtsx_usb_get_card_status(ucr, &val);
+			valid = ucr->card_status_valid;
+			if (valid)
+				val = ucr->card_status_cache;
 			mutex_unlock(&ucr->dev_mutex);
 
-			/* Defer the autosuspend if card exists */
-			if (val & (SD_CD | MS_CD)) {
+			/*
+			 * Do not issue USB commands from runtime autosuspend.
+			 * Raw SD_CD is not authoritative on tray-based readers,
+			 * while a real SD card is protected by the SD/MMC child
+			 * runtime-PM reference once the card is powered. Keep
+			 * the historical Memory Stick autosuspend deferral when
+			 * the cached status says MS media is present.
+			 */
+			if (valid && (val & MS_CD)) {
 				device_for_each_child(&intf->dev, NULL, rtsx_usb_resume_child);
 				return -EAGAIN;
 			}
diff --git a/include/linux/rtsx_usb.h b/include/linux/rtsx_usb.h
index 3247ed8e9ff0f..5933751cf7219 100644
--- a/include/linux/rtsx_usb.h
+++ b/include/linux/rtsx_usb.h
@@ -57,6 +57,9 @@ struct rtsx_ucr {
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;
+
+	u16			card_status_cache;
+	bool			card_status_valid;
 };
 
 /* buffer size */
-- 
2.53.0



