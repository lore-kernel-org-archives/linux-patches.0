Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B68137932;
	Tue, 26 Aug 2025 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214777; cv=none; b=QAPNgMUsUfA7BLoRpPlNY3T24gYKTTkG0Z1Vm+etdKm/A0JR1h7PmG1v6X2AMyXCu+mxbMGhojPUllmyrOKf7LUwZXa9zdrCwsE3tb/ULToY3bmYwqT6lH0LZ/QIC+s7UOjqGHMQrqt3cCTL7JxjHrFDmEJcfFUmKHbX+u1UCF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214777; c=relaxed/simple;
	bh=Mlzt0YmEe3t1a+XoA5Ez2AN5RtD6RbiOmkS9c0t95P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOYF7163AvmaxXbwvtRW3S0ZtC3wGjK2hqIeUQ7dr7y7/Cw6efrY1KhtplKZ/b//CS+ufPYCJGLBY762KloSnxuRxMnDtzScCGFx9/u5BtnKY8OihzybLTNQy82LcoaZzeLv17ihEg52MWRnjB1BxAwVp59uPp0JxpuSHlYgNH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQ4Jj3Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQ4Jj3Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A42C4CEF1;
	Tue, 26 Aug 2025 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214777;
	bh=Mlzt0YmEe3t1a+XoA5Ez2AN5RtD6RbiOmkS9c0t95P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQ4Jj3SeWYlSMQHtyz+1jW9onDduWSNzX5sldtGIizD+GByY6DjAVkWOEqmoDZa3M
	 1cTbHfuoMegjqr19DlL0dbUstpf+4XiYEyP6T+X5h7eagr2j9G9RK0ycRcF6AiFGFb
	 vt6mBG26rZe6lCEvrtO6Y2eEGg6cxMkq9I+IcXnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 266/482] HID: apple: avoid setting up battery timer for devices without battery
Date: Tue, 26 Aug 2025 13:08:39 +0200
Message-ID: <20250826110937.338591221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/hid/hid-apple.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -824,10 +824,12 @@ static int apple_probe(struct hid_device
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
@@ -839,7 +841,8 @@ static void apple_remove(struct hid_devi
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
-	del_timer_sync(&asc->battery_timer);
+	if (asc->quirks & APPLE_RDESC_BATTERY)
+		del_timer_sync(&asc->battery_timer);
 
 	hid_hw_stop(hdev);
 }


