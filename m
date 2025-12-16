Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA3343203;
	Tue, 16 Dec 2025 12:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888503; cv=none; b=FmDNzH4due+wtzpL2LyNi+RieQF4l3tIjQMmmYjorWo1nHab/oGPitvfbv5jrqXePailJrdpp2TPJztFAH4YC7RZFn+bo4ftVg+Zqu6dxMvH9PNWmFyiTvEZxi8EAMy7VQowVNgDKW6zCfaJtQt6YdwzchLJSNg0SS9aQGZn/zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888503; c=relaxed/simple;
	bh=O6ds15YvJNmTWiPp63CxJn1zhH8TQkdAj/TFC1UQ21g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MxTg1fB9iHWfwJVGi0t1jJ31A/w1wKsU82KR/X5O1gOzzHlGw9qP84Cl10cngv0MM4egMXERwN6R+nKK31n/jqY1wWaxEYmP3WSEJMm4YRodXvYil5zEpHlZdP8Zv6EglKAM/QpvfELB91Triqkt7psgtINFMFinwtX3blWlP/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhcF0XYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhcF0XYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76011C4CEF5;
	Tue, 16 Dec 2025 12:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888502;
	bh=O6ds15YvJNmTWiPp63CxJn1zhH8TQkdAj/TFC1UQ21g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhcF0XYmQUFcllFi6ISfGNqchYBM7lrnJvjhtdJQbjJCWTXUhACx+8xsNCVk1iWEN
	 QSgD8Vhi+o4/Kt8Um7+fn7cuRciGu315RPkfRrJf7SLZ++3O5+1FURVk37xd8871wU
	 gOUDQ3Sjcbn/T2MID9CqqLjaNfDZgfsIMj6DmzKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 553/614] platform/x86: asus-wmi: use brightness_set_blocking() for kbd led
Date: Tue, 16 Dec 2025 12:15:20 +0100
Message-ID: <20251216111421.415445118@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e72a2b5d158e9..8e3300f5c2943 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1619,14 +1619,14 @@ static void do_kbd_led_set(struct led_classdev *led_cdev, int value)
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
@@ -1802,7 +1802,7 @@ static int asus_wmi_led_init(struct asus_wmi *asus)
 		asus->kbd_led_wk = led_val;
 		asus->kbd_led.name = "asus::kbd_backlight";
 		asus->kbd_led.flags = LED_BRIGHT_HW_CHANGED;
-		asus->kbd_led.brightness_set = kbd_led_set;
+		asus->kbd_led.brightness_set_blocking = kbd_led_set;
 		asus->kbd_led.brightness_get = kbd_led_get;
 		asus->kbd_led.max_brightness = 3;
 
-- 
2.51.0



