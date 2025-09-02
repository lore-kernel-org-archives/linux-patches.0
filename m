Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D683081CB;
	Tue,  2 Sep 2025 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819457; cv=none; b=t4GiSIOeFKw7EFXzgsgmenmleNAoDYYpSNn23CIh7iA+2wMmnlzUomaDQdWbtmesxejt2oiMshRqhDfkzXaGnlZ9kfo5unPTrqGwXWfnedQcTMpYGSpoGcu/CbYO3I2XekL3Wwo9U+mrnOgFrmHKCCE025G2clCb2SVwVFgKD/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819457; c=relaxed/simple;
	bh=Vi3DFsTSXUQV7SL+rFCf35fsyR4DJhZqhUS/o/2HTp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDo8R4cl4jDrRl2VWwSl0rhDMytYujl3t8HeAHZiZs3JNyKPdyxbeIsPCHmD5Igh6rqy6RakpaMp8klo0rsTAEDufaMuNHC7TrfrN+OEK9W8IUDzHLD+oeSZ4IqhmhW/nRSI+podMuUThFU4g/bJB9aCDv0dYCWRHfKbrQkctm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEYzEF+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEYzEF+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D91C4CEED;
	Tue,  2 Sep 2025 13:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819456;
	bh=Vi3DFsTSXUQV7SL+rFCf35fsyR4DJhZqhUS/o/2HTp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEYzEF+SV9MWLTcvPv629nz3esPO11HcvZf0UINSUimAJrHJhEpJSH7GgIjaujr+t
	 YXIUa5tPTREx6aRlC4+VGVd6raV6mG05WMSUfC6FuU3DfKA8UOSkPlYDao49tmJqz1
	 jdjgVaV6hXk2h/jKRfn3XWgeAK3O0YF0qb0Y1qvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 040/142] HID: input: report battery status changes immediately
Date: Tue,  2 Sep 2025 15:19:02 +0200
Message-ID: <20250902131949.683697169@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit e94536e1d1818b0989aa19b443b7089f50133c35 ]

Previously, the battery status (charging/discharging) was not reported
immediately to user-space. 

For most input devices, this wasn't problematic because changing their
battery status requires connecting them to a different bus.
For example, a gamepad would report a discharging status while
connected via Bluetooth and a charging status while connected via USB.

However, certain devices are not connected or disconnected when their
battery status changes. For example, a phone battery changes its status
without connecting or disconnecting it.
In these cases, the battery status was not reported immediately to user
space.

Report battery status changes immediately to user space to support
these kinds of devices.

Fixes: a608dc1c0639 ("HID: input: map battery system charging")
Reported-by: 卢国宏 <luguohong@xiaomi.com>
Closes: https://lore.kernel.org/linux-input/aI49Im0sGb6fpgc8@fedora/T/
Tested-by: 卢国宏 <luguohong@xiaomi.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 262787e6eb204..f45f856a127fe 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -609,13 +609,19 @@ static bool hidinput_update_battery_charge_status(struct hid_device *dev,
 	return false;
 }
 
-static void hidinput_update_battery(struct hid_device *dev, int value)
+static void hidinput_update_battery(struct hid_device *dev, unsigned int usage,
+				    int value)
 {
 	int capacity;
 
 	if (!dev->battery)
 		return;
 
+	if (hidinput_update_battery_charge_status(dev, usage, value)) {
+		power_supply_changed(dev->battery);
+		return;
+	}
+
 	if (value == 0 || value < dev->battery_min || value > dev->battery_max)
 		return;
 
@@ -642,13 +648,8 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
 {
 }
 
-static bool hidinput_update_battery_charge_status(struct hid_device *dev,
-						  unsigned int usage, int value)
-{
-	return false;
-}
-
-static void hidinput_update_battery(struct hid_device *dev, int value)
+static void hidinput_update_battery(struct hid_device *dev, unsigned int usage,
+				    int value)
 {
 }
 #endif	/* CONFIG_HID_BATTERY_STRENGTH */
@@ -1515,11 +1516,7 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 		return;
 
 	if (usage->type == EV_PWR) {
-		bool handled = hidinput_update_battery_charge_status(hid, usage->hid, value);
-
-		if (!handled)
-			hidinput_update_battery(hid, value);
-
+		hidinput_update_battery(hid, usage->hid, value);
 		return;
 	}
 
-- 
2.50.1



