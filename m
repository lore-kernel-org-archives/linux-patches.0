Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D608C51C44;
	Mon, 11 Dec 2023 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rszLHVfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEBFC433C8;
	Mon, 11 Dec 2023 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320827;
	bh=vgMdfa40MQw1hqG3rs4AwOGwDEEiJavJ8QP0gr07yes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rszLHVfJtjK8IJKZ/cO/l3zd3OQqRom+GCkbyfaUhr6RUIQ7A8rySK3goitiMI/1u
	 qs4laTvxLnaEcjcdsZNOowQbNBvDxr/+rKbBm2Ba+9GaXVcMwVE609SvwIR7teZjqJ
	 mwaMa+j+LcWJMeYEckeatJuPgeW7F7W4ZqXuLKK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/141] platform/x86: asus-wmi: Simplify tablet-mode-switch probing
Date: Mon, 11 Dec 2023 19:21:10 +0100
Message-ID: <20231211182026.984378270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c98dc61ee08f833e68337700546e120e2edac7c9 ]

The 3 different tablet-mode-switch initialization paths repeat a lot
of the same code. Add a helper function for this.

This also makes the error-handling for the kbd_dock_devid case consistent
with the other 2 cases.

Cc: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220824151145.1448010-1-hdegoede@redhat.com
Stable-dep-of: b52cbca22cbf ("platform/x86: asus-wmi: Move i8042 filter install to shared asus-wmi code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 55 +++++++++++++--------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 8b7a86c6c363f..35b2fbb466b45 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -364,13 +364,28 @@ static bool asus_wmi_dev_is_present(struct asus_wmi *asus, u32 dev_id)
 }
 
 /* Input **********************************************************************/
+static void asus_wmi_tablet_sw_init(struct asus_wmi *asus, u32 dev_id, int event_code)
+{
+	struct device *dev = &asus->platform_device->dev;
+	int result;
+
+	result = asus_wmi_get_devstate_simple(asus, dev_id);
+	if (result < 0)
+		asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
+	if (result >= 0) {
+		input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
+		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+	} else if (result == -ENODEV) {
+		dev_err(dev, "This device has tablet-mode-switch quirk but got ENODEV checking it. This is a bug.");
+	} else {
+		dev_err(dev, "Error checking for tablet-mode-switch: %d\n", result);
+	}
+}
 
 static int asus_wmi_input_init(struct asus_wmi *asus)
 {
-	struct device *dev;
-	int err, result;
-
-	dev = &asus->platform_device->dev;
+	struct device *dev = &asus->platform_device->dev;
+	int err;
 
 	asus->inputdev = input_allocate_device();
 	if (!asus->inputdev)
@@ -390,39 +405,13 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 	case asus_wmi_no_tablet_switch:
 		break;
 	case asus_wmi_kbd_dock_devid:
-		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_KBD_DOCK);
-		if (result >= 0) {
-			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
-			input_report_switch(asus->inputdev, SW_TABLET_MODE, !result);
-		} else if (result != -ENODEV) {
-			dev_err(dev, "Error checking for keyboard-dock: %d\n", result);
-		}
+		asus_wmi_tablet_sw_init(asus, ASUS_WMI_DEVID_KBD_DOCK, NOTIFY_KBD_DOCK_CHANGE);
 		break;
 	case asus_wmi_lid_flip_devid:
-		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
-		if (result < 0)
-			asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
-		if (result >= 0) {
-			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
-			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
-		} else if (result == -ENODEV) {
-			dev_err(dev, "This device has lid_flip quirk but got ENODEV checking it. This is a bug.");
-		} else {
-			dev_err(dev, "Error checking for lid-flip: %d\n", result);
-		}
+		asus_wmi_tablet_sw_init(asus, ASUS_WMI_DEVID_LID_FLIP, NOTIFY_LID_FLIP);
 		break;
 	case asus_wmi_lid_flip_rog_devid:
-		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP_ROG);
-		if (result < 0)
-			asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
-		if (result >= 0) {
-			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
-			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
-		} else if (result == -ENODEV) {
-			dev_err(dev, "This device has lid-flip-rog quirk but got ENODEV checking it. This is a bug.");
-		} else {
-			dev_err(dev, "Error checking for lid-flip: %d\n", result);
-		}
+		asus_wmi_tablet_sw_init(asus, ASUS_WMI_DEVID_LID_FLIP_ROG, NOTIFY_LID_FLIP_ROG);
 		break;
 	}
 
-- 
2.42.0



