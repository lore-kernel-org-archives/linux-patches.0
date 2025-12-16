Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D034106D;
	Tue, 16 Dec 2025 11:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884902; cv=none; b=jm/s6eqAj7DlBH8ttNvez6PF3Hpy+PwqzOtA9WuTgn70eUOKpj6OXKaS5SbtiAJL1lYsS174osb7TYuFXTlww8g4AN+FvNGcz+JKxipWW0Qq1Bi1b1CD9lwpFSp1iWm2Np08RAYOoljgjWEvV2PsWDzhduV4BmcDtwZ0SoSe0J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884902; c=relaxed/simple;
	bh=hlXrOqk8dI2jUMV7CrY5HMkCZsxnjE4fm3HI+C4bMrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FgBPTJXq3aVhjH89jn1reoJRyOpe5YBL77pIXv/UNOE83cTnydQVBHILtkFEbGiPNXbB5QI/oLDBMCimU1PSlW7soI6UGEp1eMs7nPygIVLej863G7BycDrLrCTaBDRWzY0ahp1DXgAYNi7NbnlN0Q/sbxQfFxgYa6Qz2L3pvrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsRdj1Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsRdj1Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CE8C4CEF1;
	Tue, 16 Dec 2025 11:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884902;
	bh=hlXrOqk8dI2jUMV7CrY5HMkCZsxnjE4fm3HI+C4bMrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsRdj1LkoBp1srvr8VWPzY8C/Pm33WaIOCuN3jnRjH+IQ4vQQQjhBmKhhS2bGGGsF
	 t9NEEZUuYkzCWmOHpClhRsjHF3S+tv2xEHMGkYcCW64H1rtgfXIhC/Zw7wO+EMIyUl
	 E4sqrSX2ohPB16N+b685bmiwsEN7WyJo7yjav4qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/354] platform/x86: asus-wmi: use brightness_set_blocking() for kbd led
Date: Tue, 16 Dec 2025 12:14:43 +0100
Message-ID: <20251216111332.359305385@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d79c5ea8b495..92ce975d900d0 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1577,14 +1577,14 @@ static void do_kbd_led_set(struct led_classdev *led_cdev, int value)
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
@@ -1760,7 +1760,7 @@ static int asus_wmi_led_init(struct asus_wmi *asus)
 		asus->kbd_led_wk = led_val;
 		asus->kbd_led.name = "asus::kbd_backlight";
 		asus->kbd_led.flags = LED_BRIGHT_HW_CHANGED;
-		asus->kbd_led.brightness_set = kbd_led_set;
+		asus->kbd_led.brightness_set_blocking = kbd_led_set;
 		asus->kbd_led.brightness_get = kbd_led_get;
 		asus->kbd_led.max_brightness = 3;
 
-- 
2.51.0



