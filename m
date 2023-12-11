Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC5FFBE1;
	Mon, 11 Dec 2023 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1lrP6Ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDF2C433C9;
	Mon, 11 Dec 2023 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320079;
	bh=5mrLp0vk96ZITWgxIqxTTdFDTNSQuOjP2DVTB/ib5rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1lrP6AbbGOkv/Q6nXDNq6c6jxXrR+dzL+EqkE6Ke3Kt+Pozq6MQWDjfvx7w8O8sF
	 gnQD1/2QWdVsRAH5VERdffYGKxUaK9/d1DgfGe4VrSCeE39N/1ZTsGebeECHdaHXJf
	 37dby4Hjqyd0OcGubQfLMDJHrxqaQtnBUuuR2hDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 88/97] platform/x86: asus-wmi: Fix kbd_dock_devid tablet-switch reporting
Date: Mon, 11 Dec 2023 19:22:31 +0100
Message-ID: <20231211182023.609831944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit fdcc0602d64f22185f61c70747214b630049cc33 upstream.

Commit 1ea0d3b46798 ("platform/x86: asus-wmi: Simplify tablet-mode-switch
handling") unified the asus-wmi tablet-switch handling, but it did not take
into account that the value returned for the kbd_dock_devid WMI method is
inverted where as the other ones are not inverted.

This causes asus-wmi to report an inverted tablet-switch state for devices
which use the kbd_dock_devid, which causes libinput to ignore touchpad
events while the affected T10x model 2-in-1s are docked.

Add inverting of the return value in the kbd_dock_devid case to fix this.

Fixes: 1ea0d3b46798 ("platform/x86: asus-wmi: Simplify tablet-mode-switch handling")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230120143441.527334-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-wmi.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -202,6 +202,7 @@ struct asus_wmi {
 
 	int tablet_switch_event_code;
 	u32 tablet_switch_dev_id;
+	bool tablet_switch_inverted;
 
 	enum fan_type fan_type;
 	int fan_pwm_mode;
@@ -354,6 +355,13 @@ static bool asus_wmi_dev_is_present(stru
 }
 
 /* Input **********************************************************************/
+static void asus_wmi_tablet_sw_report(struct asus_wmi *asus, bool value)
+{
+	input_report_switch(asus->inputdev, SW_TABLET_MODE,
+			    asus->tablet_switch_inverted ? !value : value);
+	input_sync(asus->inputdev);
+}
+
 static void asus_wmi_tablet_sw_init(struct asus_wmi *asus, u32 dev_id, int event_code)
 {
 	struct device *dev = &asus->platform_device->dev;
@@ -362,7 +370,7 @@ static void asus_wmi_tablet_sw_init(stru
 	result = asus_wmi_get_devstate_simple(asus, dev_id);
 	if (result >= 0) {
 		input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
-		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		asus_wmi_tablet_sw_report(asus, result);
 		asus->tablet_switch_dev_id = dev_id;
 		asus->tablet_switch_event_code = event_code;
 	} else if (result == -ENODEV) {
@@ -395,6 +403,7 @@ static int asus_wmi_input_init(struct as
 	case asus_wmi_no_tablet_switch:
 		break;
 	case asus_wmi_kbd_dock_devid:
+		asus->tablet_switch_inverted = true;
 		asus_wmi_tablet_sw_init(asus, ASUS_WMI_DEVID_KBD_DOCK, NOTIFY_KBD_DOCK_CHANGE);
 		break;
 	case asus_wmi_lid_flip_devid:
@@ -434,10 +443,8 @@ static void asus_wmi_tablet_mode_get_sta
 		return;
 
 	result = asus_wmi_get_devstate_simple(asus, asus->tablet_switch_dev_id);
-	if (result >= 0) {
-		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
-		input_sync(asus->inputdev);
-	}
+	if (result >= 0)
+		asus_wmi_tablet_sw_report(asus, result);
 }
 
 /* dGPU ********************************************************************/


