Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B2C14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsvWU64d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C0AC433C7;
	Mon, 23 Oct 2023 11:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059613;
	bh=yjWgMNh2yHAZw2CC2vku21wqE6T3Bj8ZxEEYSOTwYBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsvWU64df/lVROYbfZ9FDLGKPl/7za97oYXM24260QhBEtt744yKXhsRH15KGx31G
	 uV/ez08dotYGTtiCPi4L2+4IYkGQ4Gf3Dk/pBi1lTOx8/KJsKRZPskCYUJeReXbC1V
	 My0fnwGn2gIGmRBIGL9hdCi4Z0zUmoqKp3JXbeCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James John <me@donjajo.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.5 209/241] platform/x86: asus-wmi: Only map brightness codes when using asus-wmi backlight control
Date: Mon, 23 Oct 2023 12:56:35 +0200
Message-ID: <20231023104838.946931312@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit a5b92be2482e5f9ef30be4e4cda12ed484381493 upstream.

Older Asus laptops change the backlight level themselves and then send
WMI events with different codes for different backlight levels.

The asus-wmi.c code maps the entire range of codes reported on
brightness down keypresses to an internal ASUS_WMI_BRN_DOWN code:

define NOTIFY_BRNUP_MIN                0x11
define NOTIFY_BRNUP_MAX                0x1f
define NOTIFY_BRNDOWN_MIN              0x20
define NOTIFY_BRNDOWN_MAX              0x2e

        if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
                code = ASUS_WMI_BRN_UP;
        else if (code >= NOTIFY_BRNDOWN_MIN && code <= NOTIFY_BRNDOWN_MAX)
                code = ASUS_WMI_BRN_DOWN;

This mapping is causing issues on new laptop models which actually
send 0x2b events for printscreen presses and 0x2c events for
capslock presses, which get translated into spurious brightness-down
presses.

This mapping is really only necessary when asus-wmi has registered
a backlight-device for backlight control. In this case the mapping
was used to decide to filter out the keypresss since in this case
the firmware has already modified the brightness itself and instead
of reporting a keypress asus-wmi will just report the new brightness
value to userspace.

OTOH when the firmware does not adjust the brightness itself then
it seems to always report 0x2e for brightness-down presses and
0x2f for brightness up presses independent of the actual brightness
level. So in this case the mapping of the code is not necessary
and this translation actually leads to spurious brightness-down
presses being send to userspace when pressing printscreen or capslock.

Modify asus_wmi_handle_event_code() to only do the mapping
when using asus-wmi backlight control to fix the spurious
brightness-down presses.

Reported-by: James John <me@donjajo.com>
Closes: https://lore.kernel.org/platform-driver-x86/a2c441fe-457e-44cf-a146-0ecd86b037cf@donjajo.com/
Closes: https://bbs.archlinux.org/viewtopic.php?pid=2123716
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231017090725.38163-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-wmi.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3268,7 +3268,6 @@ static void asus_wmi_handle_event_code(i
 {
 	unsigned int key_value = 1;
 	bool autorelease = 1;
-	int orig_code = code;
 
 	if (asus->driver->key_filter) {
 		asus->driver->key_filter(asus->driver, &code, &key_value,
@@ -3277,16 +3276,10 @@ static void asus_wmi_handle_event_code(i
 			return;
 	}
 
-	if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
-		code = ASUS_WMI_BRN_UP;
-	else if (code >= NOTIFY_BRNDOWN_MIN && code <= NOTIFY_BRNDOWN_MAX)
-		code = ASUS_WMI_BRN_DOWN;
-
-	if (code == ASUS_WMI_BRN_DOWN || code == ASUS_WMI_BRN_UP) {
-		if (acpi_video_get_backlight_type() == acpi_backlight_vendor) {
-			asus_wmi_backlight_notify(asus, orig_code);
-			return;
-		}
+	if (acpi_video_get_backlight_type() == acpi_backlight_vendor &&
+	    code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNDOWN_MAX) {
+		asus_wmi_backlight_notify(asus, code);
+		return;
 	}
 
 	if (code == NOTIFY_KBD_BRTUP) {


