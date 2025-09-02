Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D913054F4;
	Tue,  2 Sep 2025 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820401; cv=none; b=L6L2fs/QULvzdMznL5Mx3V5NOeW3vhTe7sH06vl/1V0t2GhXNQ+798Z3EMq8RVk/pgMKe6pTV+V8n9/Av3PdYdFGrMGXmH0/fWbYNSbJK402dwiVTuxecfyLfNPaRBCeP9gHET9rtrorx+aJgjLk1TwUn1A/tDbwPY2wimZOpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820401; c=relaxed/simple;
	bh=LjBpK3jrCVLyzx/XEw74gKrSd3KpT8gpiyMdT/BSnFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XS5BYZyS+jv9BTZaudGxi8ErX26hcxvAiMW30eYr1sSPvNRJRiyld8Zc6l8KiyXf+rTbSGEK6K2QlHMONmcRfIzbVNq0fnREuFYevXMu8rvTwM4yAx2kEaY1fUHhh2jKm40lyvCWttHbvzSbfBa+5zQYkQYsX/uus4Z+iJn8uCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZPd/3kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZPd/3kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19049C4CEED;
	Tue,  2 Sep 2025 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820400;
	bh=LjBpK3jrCVLyzx/XEw74gKrSd3KpT8gpiyMdT/BSnFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZPd/3kcMXiTbcdTBazNg1fiq1hex/VaTlM9I+88BW19ba1adVxaqu4E3lDjMQCD2
	 D/wDpRRiS9U3vbvBJGhdOsPwsKbhNGocry2vox8ja7hksa5k9WOj0tevcdLjvB8SMZ
	 uud/oVGhtygdRItEoOAen3aVQFwCPJk0oci2kGgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/50] HID: input: report battery status changes immediately
Date: Tue,  2 Sep 2025 15:21:08 +0200
Message-ID: <20250902131931.202694188@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 51be30b7c1851..cd9d031858438 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -623,13 +623,19 @@ static bool hidinput_update_battery_charge_status(struct hid_device *dev,
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
 
@@ -656,13 +662,8 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
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
@@ -1509,11 +1510,7 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
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



