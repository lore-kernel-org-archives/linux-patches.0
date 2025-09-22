Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE61285C92;
	Mon, 22 Sep 2025 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570003; cv=none; b=NxqFk5xRKJkfLPZQkkWooJM13hmFF1+99yO5r3OmjiRXsdZfDsfKz89uK701uVqO/JKqIAxXCF/RwfEIdwkGtm+pk3KAEKiAaU4UJECAhJi7xqTRtlI0nsGJnDwzx6BJSOqcmBXoEi5ZcZEaOoAQ0IcoplnW7lENjbFfAXOrMeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570003; c=relaxed/simple;
	bh=aItRL1nPMpeZf7MBEXBj2pkgSL7zvpjDfXa+s8ja9a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XeVFwDQ5Dhj/7o62j0FRI3o5SpF7YUc35DzB7seeNg6T/pqPLmAxEGBrdn5bkl6wM9ZhpxYObll9MZ6FonRS3SrDKr4vaoVUT7IPII8r/A/IkqlT8pYsyMI9SAfZwBLzvN9LtFkWY6hen7EFONiPg8W6+Q2KrxiEvdHskr+LcQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWmCoBvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWmCoBvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9BBC4CEF0;
	Mon, 22 Sep 2025 19:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570003;
	bh=aItRL1nPMpeZf7MBEXBj2pkgSL7zvpjDfXa+s8ja9a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWmCoBvOViARMCVsjERcRJ8r5ZHOsP/FHDeLbUo8LilCbYfKVm4Zc6+MrsH+Qrahu
	 Hd4bEjGcfldiWl30epuoLgX8Pg7eQhFPYZvr/nI6sxG5FXo5fPtQVcNr2ZP/jZ9Cc3
	 3taIuArItyRkCAGGirVeaSbpjmEIvJBjtoqdeADY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 085/105] platform/x86: asus-wmi: Fix ROG button mapping, tablet mode on ASUS ROG Z13
Date: Mon, 22 Sep 2025 21:30:08 +0200
Message-ID: <20250922192411.128629919@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 132bfcd24925d4d4531a19b87acb8474be82a017 upstream.

On commit 9286dfd5735b ("platform/x86: asus-wmi: Fix spurious rfkill on
UX8406MA"), Mathieu adds a quirk for the Zenbook Duo to ignore the code
0x5f (WLAN button disable). On that laptop, this code is triggered when
the device keyboard is attached.

On the ASUS ROG Z13 2025, this code is triggered when pressing the side
button of the device, which is used to open Armoury Crate in Windows.

As this is becoming a pattern, where newer Asus laptops use this keycode
for emitting events, let's convert the wlan ignore quirk to instead
allow emitting codes, so that userspace programs can listen to it and
so that it does not interfere with the rfkill state.

With this patch, the Z13 wil emit KEY_PROG3 and the Duo will remain
unchanged and emit no event. While at it, add a quirk for the Z13 to
switch into tablet mode when removing the keyboard.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250808154710.8981-2-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-nb-wmi.c |   23 +++++++++++++++++++----
 drivers/platform/x86/asus-wmi.h    |    3 ++-
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -146,7 +146,12 @@ static struct quirk_entry quirk_asus_ign
 };
 
 static struct quirk_entry quirk_asus_zenbook_duo_kbd = {
-	.ignore_key_wlan = true,
+	.key_wlan_event = ASUS_WMI_KEY_IGNORE,
+};
+
+static struct quirk_entry quirk_asus_z13 = {
+	.key_wlan_event = ASUS_WMI_KEY_ARMOURY,
+	.tablet_switch_mode = asus_wmi_kbd_dock_devid,
 };
 
 static int dmi_matched(const struct dmi_system_id *dmi)
@@ -538,6 +543,15 @@ static const struct dmi_system_id asus_q
 		},
 		.driver_data = &quirk_asus_zenbook_duo_kbd,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS ROG Z13",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow Z13"),
+		},
+		.driver_data = &quirk_asus_z13,
+	},
 	{},
 };
 
@@ -635,6 +649,7 @@ static const struct key_entry asus_nb_wm
 	{ KE_IGNORE, 0xCF, },	/* AC mode */
 	{ KE_KEY, 0xFA, { KEY_PROG2 } },           /* Lid flip action */
 	{ KE_KEY, 0xBD, { KEY_PROG2 } },           /* Lid flip action on ROG xflow laptops */
+	{ KE_KEY, ASUS_WMI_KEY_ARMOURY, { KEY_PROG3 } },
 	{ KE_END, 0},
 };
 
@@ -654,9 +669,9 @@ static void asus_nb_wmi_key_filter(struc
 		if (atkbd_reports_vol_keys)
 			*code = ASUS_WMI_KEY_IGNORE;
 		break;
-	case 0x5F: /* Wireless console Disable */
-		if (quirks->ignore_key_wlan)
-			*code = ASUS_WMI_KEY_IGNORE;
+	case 0x5F: /* Wireless console Disable / Special Key */
+		if (quirks->key_wlan_event)
+			*code = quirks->key_wlan_event;
 		break;
 	}
 }
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -18,6 +18,7 @@
 #include <linux/i8042.h>
 
 #define ASUS_WMI_KEY_IGNORE (-1)
+#define ASUS_WMI_KEY_ARMOURY	0xffff01
 #define ASUS_WMI_BRN_DOWN	0x2e
 #define ASUS_WMI_BRN_UP		0x2f
 
@@ -40,7 +41,7 @@ struct quirk_entry {
 	bool wmi_force_als_set;
 	bool wmi_ignore_fan;
 	bool filter_i8042_e1_extended_codes;
-	bool ignore_key_wlan;
+	int key_wlan_event;
 	enum asus_wmi_tablet_switch_mode tablet_switch_mode;
 	int wapf;
 	/*


