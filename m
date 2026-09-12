Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0F0364059;
	Sat, 12 Sep 2026 08:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201519; cv=none; b=KMqHsQ5DZsDXFTdUCCMYBMrJr1NjWFEx9Su/FLWbeqmYLG9TPA0HazPqvFM2oEs1AotSToAXCWTv9ldY9gjYEF12ypMttMr/BiZsCLQ6JTXNrKOn3v6RuHGIIJ0Z4XMVGndCACkaj7QGG/8CThOqoXB3g1++9HnC26z3I8w0BcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201519; c=relaxed/simple;
	bh=Z1Ji+4kKL09HGQAag7xNv/sMCEZzG9D8pkhxHmpz+1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fi8rqNu/lsKdrZSDEgYm5eLJtC5l5xOtgOP5MBOuVhElc13dBkwiKZaFhMvTLk+zdkry7pj7p3dL7gIGDnhgy1qwAu3RDP+eiYlbDx3Htu7DOrqezbugM+40EiBTjRxGvll0P7aio2Kkhir3sOZhFK5tzutIkW8oF3EUWjPtQmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPYj2un0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPYj2un0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD92E1F000FF;
	Sat, 12 Sep 2026 08:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201518;
	bh=V4Ume41HmZ4WVZ+KPNVMECTz0RlTpI45bpN5SPb8/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPYj2un0UaPwbIjmRtlqric2IIaSTbjbKVnOlqsVRLy6S2Onl0oFKqdHgAflG+y00
	 NSjWMeuJ3ePPomJmAvlM17pjdaZXGl0ti/KdSf1+IrB95impObQrk66mfr5K+5wPjb
	 wHgy/muwTA83ATc9EPOJoBqh094afSyXHg+S1p4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1013/1815] HID: steam: Improve logging and other cleanup
Date: Sat, 12 Sep 2026 08:46:03 +0200
Message-ID: <20260912065712.789411613@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit de435b770cd9492b803346b84df69fe345b845f2 ]

Adds more logging as appropriate, reindents an enum to match surrounding
style, as well as cleaning up some places where we can use guard() instead
of doing locking and unlocking manually.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 33ff7b49c38b ("HID: steam: Reject short reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 56 ++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index efecbc9d8e014..3383a62646f9e 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -245,14 +245,14 @@ enum {
 /* Input report identifiers */
 enum
 {
-	ID_CONTROLLER_STATE = 1,
-	ID_CONTROLLER_DEBUG = 2,
-	ID_CONTROLLER_WIRELESS = 3,
-	ID_CONTROLLER_STATUS = 4,
-	ID_CONTROLLER_DEBUG2 = 5,
-	ID_CONTROLLER_SECONDARY_STATE = 6,
-	ID_CONTROLLER_BLE_STATE = 7,
-	ID_CONTROLLER_DECK_STATE = 9
+	ID_CONTROLLER_STATE		= 1,
+	ID_CONTROLLER_DEBUG		= 2,
+	ID_CONTROLLER_WIRELESS		= 3,
+	ID_CONTROLLER_STATUS		= 4,
+	ID_CONTROLLER_DEBUG2		= 5,
+	ID_CONTROLLER_SECONDARY_STATE	= 6,
+	ID_CONTROLLER_BLE_STATE		= 7,
+	ID_CONTROLLER_DECK_STATE	= 9,
 };
 
 /* Read-only attributes */
@@ -378,9 +378,16 @@ static int steam_recv_report(struct steam_device *steam,
 	ret = hid_hw_raw_request(steam->hdev, 0x00,
 			buf, hid_report_len(r) + 1,
 			HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
-	if (ret > 0)
-		memcpy(data, buf + 1, min(size, ret - 1));
+	if (ret > 0) {
+		ret = min(size, ret - 1);
+		memcpy(data, buf + 1, ret);
+	}
 	kfree(buf);
+
+	if (ret < 0)
+		hid_err(steam->hdev, "%s: error %d\n", __func__, ret);
+	else
+		hid_dbg(steam->hdev, "Received report %*ph\n", ret, data);
 	return ret;
 }
 
@@ -408,6 +415,8 @@ static int steam_send_report(struct steam_device *steam,
 	/* The report ID is always 0 */
 	memcpy(buf + 1, cmd, size);
 
+	hid_dbg(steam->hdev, "Sending report %*ph\n", size, cmd);
+
 	/*
 	 * Sometimes the wireless controller fails with EPIPE
 	 * when sending a feature report.
@@ -480,22 +489,21 @@ static int steam_get_serial(struct steam_device *steam)
 	u8 cmd[] = {ID_GET_STRING_ATTRIBUTE, sizeof(steam->serial_no), ATTRIB_STR_UNIT_SERIAL};
 	u8 reply[3 + STEAM_SERIAL_LEN + 1];
 
-	mutex_lock(&steam->report_mutex);
+	guard(mutex)(&steam->report_mutex);
 	ret = steam_send_report(steam, cmd, sizeof(cmd));
 	if (ret < 0)
-		goto out;
+		return ret;
 	ret = steam_recv_report(steam, reply, sizeof(reply));
 	if (ret < 0)
-		goto out;
+		return ret;
 	if (reply[0] != ID_GET_STRING_ATTRIBUTE || reply[1] < 1 ||
 	    reply[1] > sizeof(steam->serial_no) || reply[2] != ATTRIB_STR_UNIT_SERIAL) {
-		ret = -EIO;
-		goto out;
+		hid_err(steam->hdev, "%s: invalid reply (%*ph)\n", __func__,
+				(int)sizeof(reply), reply);
+		return -EIO;
 	}
 	reply[3 + STEAM_SERIAL_LEN] = 0;
 	strscpy(steam->serial_no, reply + 3, reply[1]);
-out:
-	mutex_unlock(&steam->report_mutex);
 	return ret;
 }
 
@@ -515,8 +523,11 @@ static int steam_get_attributes(struct steam_device *steam)
 	ret = steam_recv_report(steam, reply, sizeof(reply));
 	if (ret < 0)
 		return ret;
-	if (reply[0] != ID_GET_ATTRIBUTES_VALUES || reply[1] < 2)
+	if (reply[0] != ID_GET_ATTRIBUTES_VALUES || reply[1] < 2) {
+		hid_err(steam->hdev, "%s: invalid reply (%*ph)\n", __func__,
+				(int)sizeof(reply), reply);
 		return -EIO;
+	}
 
 	size = min(reply[1], sizeof(reply) - 2);
 	for (i = 0; i + sizeof(*attr) <= size; i += sizeof(*attr)) {
@@ -538,11 +549,8 @@ static int steam_get_attributes(struct steam_device *steam)
  */
 static inline int steam_request_conn_status(struct steam_device *steam)
 {
-	int ret;
-	mutex_lock(&steam->report_mutex);
-	ret = steam_send_report_byte(steam, ID_DONGLE_GET_WIRELESS_STATE);
-	mutex_unlock(&steam->report_mutex);
-	return ret;
+	guard(mutex)(&steam->report_mutex);
+	return steam_send_report_byte(steam, ID_DONGLE_GET_WIRELESS_STATE);
 }
 
 /*
@@ -1165,6 +1173,7 @@ static void steam_mode_switch_cb(struct work_struct *work)
 		return;
 
 	steam->gamepad_mode = !steam->gamepad_mode;
+	hid_dbg(steam->hdev, "%s: switching gamepad mode to %i\n", __func__, steam->gamepad_mode);
 	if (steam->gamepad_mode)
 		steam_set_lizard_mode(steam, false);
 	else {
@@ -1831,6 +1840,7 @@ static void steam_do_deck_input_event(struct steam_device *steam,
 		steam->did_mode_switch = false;
 		cancel_delayed_work(&steam->mode_switch);
 	} else if (!steam->client_opened && start_pressed && !steam->did_mode_switch) {
+		hid_dbg(steam->hdev, "%s: doing mode switch\n", __func__);
 		steam->did_mode_switch = true;
 		schedule_delayed_work(&steam->mode_switch, 45 * HZ / 100);
 	}
-- 
2.53.0



