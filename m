Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404AA18DB2A;
	Tue, 26 Aug 2025 13:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213386; cv=none; b=TSp1s4daN92B9aQ2Q+1NUB7sFapPh+X4cCRRWYvxUVqn3dPNsi+vj/OxFv4Q1A6507gsrbo2rIb14wXcPoWR+uNBO0SSw4tZ9O/3bI5m8xu+nW/crY7C9OBH++ip+ZM02X/9a4LepBqybEFwFE6O8NIFAzA64OLA36FA5o7gDBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213386; c=relaxed/simple;
	bh=P+/CJMcZFcKJ8/Tg/SGA/QFz8jzzV4K4/M0Hgol6bVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2aauHim+IvqEixa/UwTbuf+G/Rl3mqgDgOOU2Oye+TQH2pk0IO008cnI4AmiRoCmn6rYADtkjjevOYBQPeogZvEZ+OwaejfAIPeygg5Jno1AC/iVPPY5wxTG/MCQNse74K/lngeGRWgZEk8MfuCC2nhJxiQkoWOwxfSMD626UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etCDH1m2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etCDH1m2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF92C4CEF1;
	Tue, 26 Aug 2025 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213385;
	bh=P+/CJMcZFcKJ8/Tg/SGA/QFz8jzzV4K4/M0Hgol6bVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etCDH1m2KpObU3w20bcLPRKSrL9y6Fq/8jAYHvV5kQ9Q5PCU1b/10QJJvIvAZpPjC
	 D1nbccEAxaN0k8ZRPHhxuQYnDtktwk77AvF9xa36Q1TApjE1XnCp5Nj4J2Ikv6A6lN
	 FmM88y1RXZlcKJifG0y8pvWoBVBP3cAccSt+6Kvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 327/587] HID: apple: avoid setting up battery timer for devices without battery
Date: Tue, 26 Aug 2025 13:07:56 +0200
Message-ID: <20250826111001.232866315@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -858,10 +858,12 @@ static int apple_probe(struct hid_device
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
@@ -873,7 +875,8 @@ static void apple_remove(struct hid_devi
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
-	del_timer_sync(&asc->battery_timer);
+	if (asc->quirks & APPLE_RDESC_BATTERY)
+		del_timer_sync(&asc->battery_timer);
 
 	hid_hw_stop(hdev);
 }


