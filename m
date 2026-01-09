Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E873835A92E;
	Fri,  9 Jan 2026 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960062; cv=none; b=fhXYJE5pyunRq0zuCU0XBLQGTVYZwzJgIcmAaZkm5noYx4EyiC6CpRd0v2GIIXcmlCQTueas55TST8nr21gmHNn+E96A0VvWaeTpfeUBY0YG2nue9pnms+ONEEuyDLCq6pIukREMFCJWYRXEbF+vRoWR0l8J+1J6/8ho0OSFY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960062; c=relaxed/simple;
	bh=c2xtxgH6noESJqXYTo+rZIcTI9JwWQNPuEwPstNEqGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJK0HCqz1wqMlteNpYiS9GuBzrdv/mFWwhhU6lBUMEtX3kIHvHc9rJhBfuVf5ze2W2F21Rqq3LMHXOAYNIjazy2z1Z7hSsNa94sk0LKM8TIuKm61l/2bsKvS9uM/u5ZncAIUXH3EEfgYXkT3nBgRwh3JW5G+VzHgim1wlqDodXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INeW/mJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INeW/mJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213E1C16AAE;
	Fri,  9 Jan 2026 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960061;
	bh=c2xtxgH6noESJqXYTo+rZIcTI9JwWQNPuEwPstNEqGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INeW/mJg2VUl/8/zHHvhOwvZB1taMcWcWk1J2e6PxFAyiNQcMl2t1vg+tnnrVjJdj
	 D7lvUN1KNPzsixkDRYkqK3uyfWwqmYWffSWheKs5x6uC2q2BU3L0hc12BoZ04cDgl6
	 G4KWisPETF0teIcCYJQg5LHuwVIvqPXWgKvXJkig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/737] platform/x86: asus-wmi: use brightness_set_blocking() for kbd led
Date: Fri,  9 Jan 2026 12:36:50 +0100
Message-ID: <20260109112144.193856586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Khirnov <anton@khirnov.net>

[ Upstream commit ccb61a328321ba3f8567e350664c9ca7a42b6c70 ]

kbd_led_set() can sleep, and so may not be used as the brightness_set()
callback.

Otherwise using this led with a trigger leads to system hangs
accompanied by:
BUG: scheduling while atomic: acpi_fakekeyd/2588/0x00000003
CPU: 4 UID: 0 PID: 2588 Comm: acpi_fakekeyd Not tainted 6.17.9+deb14-amd64 #1 PREEMPT(lazy)  Debian 6.17.9-1
Hardware name: ASUSTeK COMPUTER INC. ASUS EXPERTBOOK B9403CVAR/B9403CVAR, BIOS B9403CVAR.311 12/24/2024
Call Trace:
 <TASK>
 [...]
 schedule_timeout+0xbd/0x100
 __down_common+0x175/0x290
 down_timeout+0x67/0x70
 acpi_os_wait_semaphore+0x57/0x90
 [...]
 asus_wmi_evaluate_method3+0x87/0x190 [asus_wmi]
 led_trigger_event+0x3f/0x60
 [...]

Fixes: 9fe44fc98ce4 ("platform/x86: asus-wmi: Simplify the keyboard brightness updating process")
Signed-off-by: Anton Khirnov <anton@khirnov.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Denis Benato <benato.denis96@gmail.com>
Link: https://patch.msgid.link/20251129101307.18085-3-anton@khirnov.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 2c894ea8aa817..b56be64fcc631 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1405,14 +1405,14 @@ static void do_kbd_led_set(struct led_classdev *led_cdev, int value)
 	kbd_led_update(asus);
 }
 
-static void kbd_led_set(struct led_classdev *led_cdev,
-			enum led_brightness value)
+static int kbd_led_set(struct led_classdev *led_cdev, enum led_brightness value)
 {
 	/* Prevent disabling keyboard backlight on module unregister */
 	if (led_cdev->flags & LED_UNREGISTERING)
-		return;
+		return 0;
 
 	do_kbd_led_set(led_cdev, value);
+	return 0;
 }
 
 static void kbd_led_set_by_kbd(struct asus_wmi *asus, enum led_brightness value)
@@ -1565,7 +1565,7 @@ static int asus_wmi_led_init(struct asus_wmi *asus)
 		asus->kbd_led_wk = led_val;
 		asus->kbd_led.name = "asus::kbd_backlight";
 		asus->kbd_led.flags = LED_BRIGHT_HW_CHANGED;
-		asus->kbd_led.brightness_set = kbd_led_set;
+		asus->kbd_led.brightness_set_blocking = kbd_led_set;
 		asus->kbd_led.brightness_get = kbd_led_get;
 		asus->kbd_led.max_brightness = 3;
 
-- 
2.51.0



