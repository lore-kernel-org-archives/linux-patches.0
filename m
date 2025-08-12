Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02543FE7;
	Tue, 12 Aug 2025 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025285; cv=none; b=CLj2xx1uqOCuuCPRjMNXWoXfmlnHTe2TfuXdJ1PM5ZM4LWm0BIFZ1HkAbSezCNAWPjug/PtEabgxsj/65LJ5VOGMqLsHHuoIR8whpHf6g4l+DvXG41DgSBrEmfVz2W9iYtm78YwfNaWhjqCFTemJmRH1bpe+pb035RaFEAGMTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025285; c=relaxed/simple;
	bh=d9U8zbehAYMPWk1HYKUZWzK6KSdovq1pugob9EqkXpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc9pgaKcFDxiY5zE8BFRfRuUcsB/K/z38f4Ih6oqzTvm2urrJ6ed2NTnojCiyaP1M3HSHakLg0AeUxgcktRgJO7OFEXS63LyFBylNc5vNv3nkb2vHSKHcxvk3KTAmY7R114BFd1u+jVvOwVVuB4VodTvBufF4pJYFDZGDPeth7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqu4U/9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqu4U/9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399E5C4CEF0;
	Tue, 12 Aug 2025 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025285;
	bh=d9U8zbehAYMPWk1HYKUZWzK6KSdovq1pugob9EqkXpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqu4U/9lQSMYj5navzwMnJbNAj4Qi4z/D8VSsEE6YYASPj/4E2RrvLWYVYrUOyqxM
	 /tqVaGiw0Vv6XrTJs82fPB4j45Vykl7YA06GIihVkrrddfUPCK7w9uLCI8ewaxMxIM
	 GeeqI8GnTa6NRRMriU2PvR933dhMKrB2PwaMCWn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 624/627] HID: apple: avoid setting up battery timer for devices without battery
Date: Tue, 12 Aug 2025 19:35:19 +0200
Message-ID: <20250812173455.613134293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit c061046fe9ce3ff31fb9a807144a2630ad349c17 upstream.

Currently, the battery timer is set up for all devices using hid-apple,
irrespective of whether they actually have a battery or not.

APPLE_RDESC_BATTERY is a quirk that indicates the device has a battery
and needs the battery timer. This patch checks for this quirk before
setting up the timer, ensuring that only devices with a battery will
have the timer set up.

Fixes: 6e143293e17a ("HID: apple: Report Magic Keyboard battery over USB")
Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -934,10 +934,12 @@ static int apple_probe(struct hid_device
 		return ret;
 	}
 
-	timer_setup(&asc->battery_timer, apple_battery_timer_tick, 0);
-	mod_timer(&asc->battery_timer,
-		  jiffies + msecs_to_jiffies(APPLE_BATTERY_TIMEOUT_MS));
-	apple_fetch_battery(hdev);
+	if (quirks & APPLE_RDESC_BATTERY) {
+		timer_setup(&asc->battery_timer, apple_battery_timer_tick, 0);
+		mod_timer(&asc->battery_timer,
+			  jiffies + msecs_to_jiffies(APPLE_BATTERY_TIMEOUT_MS));
+		apple_fetch_battery(hdev);
+	}
 
 	if (quirks & APPLE_BACKLIGHT_CTL)
 		apple_backlight_init(hdev);
@@ -951,7 +953,9 @@ static int apple_probe(struct hid_device
 	return 0;
 
 out_err:
-	timer_delete_sync(&asc->battery_timer);
+	if (quirks & APPLE_RDESC_BATTERY)
+		timer_delete_sync(&asc->battery_timer);
+
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -960,7 +964,8 @@ static void apple_remove(struct hid_devi
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
-	timer_delete_sync(&asc->battery_timer);
+	if (asc->quirks & APPLE_RDESC_BATTERY)
+		timer_delete_sync(&asc->battery_timer);
 
 	hid_hw_stop(hdev);
 }


