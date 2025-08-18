Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BF02E22A6;
	Mon, 18 Aug 2025 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522805; cv=none; b=OyUpNg/Src5mQsfmyHn25ukj3/hrKGwOyQboVWwy3ShlCe7+hjmLw/OGwktJNrJPTFm5xKPcicAWNOB0CfXUHFPgLxHklluNrJkVehJpXI8q8sYNM43jLxXRdkF20hxSMh5d2PxGh9x86tGeUjMCFbcPiBarY6BdPrtDTsmsrpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522805; c=relaxed/simple;
	bh=k0h2sFAS8BumTsRGchkcYqwUglI+E8CQWi1RqxsCyhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnWD1SkiehAizfuCHF93zc91rzJO9qvD/y+6cQLUhjGmdItm4b/33qwQBFT86XK6fmFtVB6AWQdXxwK0og3aQ+JK4uTq/IQvKe6faznRaMbQJ7Te64UBPBWlbzcYCPr+5VEJCYcwJ0/ZsNR+qckHVQaOUfdOgr9h2ILwZPwDgcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8tR5X/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8tR5X/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61C3C4CEEB;
	Mon, 18 Aug 2025 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522805;
	bh=k0h2sFAS8BumTsRGchkcYqwUglI+E8CQWi1RqxsCyhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8tR5X/WNJQKT5s7/reXdI3h9799HOOARMDMH+pUl14/1OovQMqAdMoQwVGhmy85j
	 phhONBkdFp6q37fK6BkTlUuZMf7qk9v9aPyDeNh+JGVmuF3Vi0yBmKjXQuCeCWZLAD
	 UalpjynrlS/4dFdXrAFVirXdBVodcGD8N/w9+A5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 425/444] HID: apple: avoid setting up battery timer for devices without battery
Date: Mon, 18 Aug 2025 14:47:31 +0200
Message-ID: <20250818124504.874531702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
-	del_timer_sync(&asc->battery_timer);
+	if (quirks & APPLE_RDESC_BATTERY)
+		del_timer_sync(&asc->battery_timer);
+
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -960,7 +964,8 @@ static void apple_remove(struct hid_devi
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
-	del_timer_sync(&asc->battery_timer);
+	if (asc->quirks & APPLE_RDESC_BATTERY)
+		del_timer_sync(&asc->battery_timer);
 
 	hid_hw_stop(hdev);
 }


