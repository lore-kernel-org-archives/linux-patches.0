Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD68848C8D9;
	Mon, 31 Aug 2026 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185217; cv=none; b=eW/DVum3w+g3mOcLYUdAtSBwYyWZpIJp98eajLKfCMl0N5LPQnky1uNuXEzWKLUbrZb41fxB72iSo8cU2OOBxOZTNifCN4upAfeKyVgYjqImRkDamkW30oT6+DF31Yc+9aKonRZ7oHiihTCnetydQRgBqakS8djYJkh4w9iEtc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185217; c=relaxed/simple;
	bh=4upBi0eqLp+v5i0cynGzx68OH8R7E7rnjMIi8XGpyOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7gyRExhuhsxEHi7J8mm21Zy0+zVNz+HETV0QfSDu0sonGtJTHMsxeQyPiaLKMm78UL8uncKq4ImmLQzsMey4B/rtvVTRDQYOnvdRBqGx8fR1kDPTJTvIbdu6PQif3VhnhNADJeqG4aMra2aKdEZh5C2U6oF2m+0SKfPQ9dUyWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAZvr9Pi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAZvr9Pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1386E1F000E9;
	Mon, 31 Aug 2026 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185214;
	bh=uo011geDhX5G4bKQrByKDrkBzyxor945n9n6Eazhwdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAZvr9Pi9qpF0qt0r1tqXfRrc8G694NfFEAR0mF9LJWMtFs0t13tPkXPmBZtjgu6l
	 cccSdbZbYvsVnvdRRtebf/P0z8idVy6JPjMqQiyFGngTnlliGBNPuqiaimawbNy3IH
	 GS1rDXgjPeOdCAw7/OwJkMFfH2QiYVxkuM92RE00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jose=20Villase=C3=B1or=20Montfort?= <pepemontfort@gmail.com>,
	Alec Hall <signshop.alec@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/43] HID: input: read battery capacity from its actual report offset
Date: Mon, 31 Aug 2026 15:35:31 +0200
Message-ID: <20260831133359.611158910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Villaseñor Montfort <pepemontfort@gmail.com>

[ Upstream commit d07644524b6511b622ee7b0e2e68c9ee43d522a4 ]

hidinput_query_battery_capacity() assumes the state-of-charge value is
the first byte following the report ID (buf[1]) and ignores where the
battery field actually sits within the report.

An Apple Magic Trackpad 2 precedes the AbsoluteStateOfCharge byte with a
byte of status flags in its battery reports, so this query returns the
flags byte instead of the charge level.

The device happens to make that easy to observe, because it exposes the
same cell twice: its report descriptor declares AbsoluteStateOfCharge in
two reports (0x90 and 0x9b), so hidinput_setup_battery() registers two
power supplies. Only the first one is refreshed by hid-magicmouse -- it
uses hid_get_battery(), which returns the first battery of the list --
and that refresh goes through the report event path, which parses the
field correctly. Nothing ever reports the second one, so every read of
its capacity takes the query path above. On a USB-C Magic Trackpad over
USB, on an unpatched 7.1.5:

  hid-<serial>-battery-144 = 100%  (Charging)      <- report event path
  hid-<serial>-battery-155 =   3%  (Discharging)   <- query path

Both are the same physical battery. A raw HIDIOCGINPUT of the two
reports at that same moment:

  report 0x90 -> [90 03 64]
  report 0x9b -> [9b 03 64 64 00 00 10 00 00 00 00 00 00 00]
                     ^flags ^SoC = 0x64 = 100%

The device answers correctly in both cases; only the offset the kernel
reads the capacity from is wrong. 0x03 is the flags byte (present,
charging), reported as "3%".

Bluetooth takes the same query path for its capacity, where the trackpad
reported a bogus near-constant ~4% -- 0b100, the FullyCharged flag --
regardless of the real charge.

Store the battery field's offset within the report at setup time and use
it when querying, so the capacity is read from its real position. The
report event path already parses the field correctly through the HID
core; only the explicit GET_REPORT query was wrong.

Devices whose capacity field is the first field in the report have a
report_offset of 0 and are unaffected (buf[1 + 0] == buf[1]).

Fixes: 581c4484769e ("HID: input: map digitizer battery usage")
Cc: stable@vger.kernel.org
Signed-off-by: Jose Villaseñor Montfort <pepemontfort@gmail.com>
Reviewed-by: Alec Hall <signshop.alec@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-input.c |   17 +++++++++++++----
 include/linux/hid.h     |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -358,19 +358,27 @@ static int hidinput_query_battery_capaci
 {
 	u8 *buf;
 	int ret;
+	/*
+	 * The capacity field may not be the first field in the report: some
+	 * devices (e.g. the Apple Magic Trackpad 2 over Bluetooth) precede it
+	 * with status flags. Read it from its actual byte offset in the report
+	 * (report_offset is in bits; the leading byte is the report id).
+	 */
+	int offset = 1 + dev->battery_report_offset / 8;
+	int len = offset + 1;
 
-	buf = kmalloc(4, GFP_KERNEL);
+	buf = kmalloc(max(len, 4), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 4,
+	ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, max(len, 4),
 				 dev->battery_report_type, HID_REQ_GET_REPORT);
-	if (ret < 2) {
+	if (ret < len) {
 		kfree(buf);
 		return -ENODATA;
 	}
 
-	ret = hidinput_scale_battery_capacity(dev, buf[1]);
+	ret = hidinput_scale_battery_capacity(dev, buf[offset]);
 	kfree(buf);
 	return ret;
 }
@@ -487,6 +495,7 @@ static int hidinput_setup_battery(struct
 	dev->battery_max = max;
 	dev->battery_report_type = report_type;
 	dev->battery_report_id = field->report->id;
+	dev->battery_report_offset = field->report_offset;
 
 	/*
 	 * Stylus is normally not connected to the device and thus we
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -616,6 +616,7 @@ struct hid_device {							/* device repo
 	__s32 battery_max;
 	__s32 battery_report_type;
 	__s32 battery_report_id;
+	__s32 battery_report_offset;					/* bit offset of the capacity field within its report */
 	enum hid_battery_status battery_status;
 	bool battery_avoid_query;
 #endif


