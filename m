Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76851A9F89;
	Tue, 12 Aug 2025 19:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026936; cv=none; b=R6NDSNVc8Psn+sJ0ZXVKCtL5YhMx4bP8ZfPNajFcrHY17yupkAd0ssqt0doWc30D0AKP5TSjbnqdNBza1scveulwqm+SJtkzUwW/YGVOVhKZpU3zdC9eVOgl6U9VwNLfzUwmqnmwQaVDvnjt897FQ0EdfkBIPvq+TKwi4gS+Mk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026936; c=relaxed/simple;
	bh=Ls3wrE9YLHShnzv4o7o1xkn+BurV1Oz89anElS7t30U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=so7cgvTrJe0cmfZYu42jZvDwFYk6KkoawfrefuJa81q+ksl2Aze4TwmkkO0vg34SsMfImXWK5A4yKhRiPN1EA9BtbsgHw8FQB7PwxHpOlgi7doKqD9swaECDaUgrJHcsUywlJKBsysYpAGK/YAnXwHLHAh50A/P9o1LVEQLFbCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJU3dGDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJU3dGDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E2FC4CEF0;
	Tue, 12 Aug 2025 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026936;
	bh=Ls3wrE9YLHShnzv4o7o1xkn+BurV1Oz89anElS7t30U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJU3dGDKENkQ15DxUmLozY4smQ7e5Oh1pylPL/xqu0EkurIgoFM6AXSa1wpLE5ghe
	 xe7rTLGe+0d1Lmmmp6kpeX6ZeObwrFnmA+Kx+5aGZHTfzW/qU6cpJCe58MKRcJaJMj
	 ML2YedHXe+EMRhDBM9tr7D6b9b5INc7fA6IJKr+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.15 478/480] HID: apple: avoid setting up battery timer for devices without battery
Date: Tue, 12 Aug 2025 19:51:26 +0200
Message-ID: <20250812174417.084753108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


