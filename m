Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186A231E107;
	Fri,  9 Jan 2026 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961973; cv=none; b=eQqZ1sZ7wgTiDRl4kEuu62fk7fo1TDE9pYM4gE+E5vaBiVS9AsZwF3/Ert4Rqy1yRdaT5FudlvLyb718woQiVKxuSNC3B9jtHGATQnzoQqgwbW+4W/eg2+NWmH1Co1/nhMJz+rG5o2rRuvkb5F8WnxVY7kxSYJ9HznsUr7XV/10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961973; c=relaxed/simple;
	bh=PT/BSTb7I0iBrv1AdMlmGkAcLUIKP0BpRjmp4VbmL1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBOUVOXkKpJGLSuGOTbGAeNLY+Q9wYx9snw8QmizV3SGptuoPrPqUvZMKDMmdGJGJa3JsrXRNKlsrKFwUrH3+aPaTDp2sNPpx6d6GxhyRfhoXFtz08nJM0QMipGDIjaShrZO4NXE/K8FdGPsS/XoPoiO3tGlwczkMssvJUs+MOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqIRFrA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqIRFrA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2B2C4CEF1;
	Fri,  9 Jan 2026 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961972;
	bh=PT/BSTb7I0iBrv1AdMlmGkAcLUIKP0BpRjmp4VbmL1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqIRFrA0dOGx1yzUX4grpcfNi5Na8lCQmClOeLteI2kmd2kbJU3N79XXNSByUhU9x
	 8D5gBxeSxUVrl0DwDhkt/o6Mc1eSzMkWH+jayy768DqYC0uLMv4SqIugNcE+geZbxP
	 QzA/DOSFDogfrplAlDcGSNIJk34JPRdddHkcOUx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/634] platform/x86: asus-wmi: use brightness_set_blocking() for kbd led
Date: Fri,  9 Jan 2026 12:37:58 +0100
Message-ID: <20260109112124.959576991@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 33eacb4fc4c45..ed6ea8782558c 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1046,14 +1046,14 @@ static void do_kbd_led_set(struct led_classdev *led_cdev, int value)
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
@@ -1206,7 +1206,7 @@ static int asus_wmi_led_init(struct asus_wmi *asus)
 		asus->kbd_led_wk = led_val;
 		asus->kbd_led.name = "asus::kbd_backlight";
 		asus->kbd_led.flags = LED_BRIGHT_HW_CHANGED;
-		asus->kbd_led.brightness_set = kbd_led_set;
+		asus->kbd_led.brightness_set_blocking = kbd_led_set;
 		asus->kbd_led.brightness_get = kbd_led_get;
 		asus->kbd_led.max_brightness = 3;
 
-- 
2.51.0



