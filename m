Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D71D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029DC433EF;
	Mon, 30 Jan 2023 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087640;
	bh=NEcAUwmfP1Pl4DqjkoblaE/AK37RaHOFEb56yhnWZh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh6qKCO7h4Ok7ji6/PkxazxwIq4hqfsXBFqTAmVxLGMItZZw9so82PuDYkvNB4+X2
	 nJNt3RWz98k0OA56+PWzUNCYAEG6k2pq96fu+fWfxGHWWbc9SPL7WcpzYc9UakQiqF
	 HXjcKGc5gu5P0lbcW2dlqRI1zjNM6wDvFbvTopMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/313] platform/x86: asus-wmi: Fix kbd_dock_devid tablet-switch reporting
Date: Mon, 30 Jan 2023 14:51:51 +0100
Message-Id: <20230130134349.586677161@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fdcc0602d64f22185f61c70747214b630049cc33 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 8e317d57ecc3..02bf28692418 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -225,6 +225,7 @@ struct asus_wmi {
 
 	int tablet_switch_event_code;
 	u32 tablet_switch_dev_id;
+	bool tablet_switch_inverted;
 
 	enum fan_type fan_type;
 	enum fan_type gpu_fan_type;
@@ -493,6 +494,13 @@ static bool asus_wmi_dev_is_present(struct asus_wmi *asus, u32 dev_id)
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
@@ -501,7 +509,7 @@ static void asus_wmi_tablet_sw_init(struct asus_wmi *asus, u32 dev_id, int event
 	result = asus_wmi_get_devstate_simple(asus, dev_id);
 	if (result >= 0) {
 		input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
-		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		asus_wmi_tablet_sw_report(asus, result);
 		asus->tablet_switch_dev_id = dev_id;
 		asus->tablet_switch_event_code = event_code;
 	} else if (result == -ENODEV) {
@@ -534,6 +542,7 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 	case asus_wmi_no_tablet_switch:
 		break;
 	case asus_wmi_kbd_dock_devid:
+		asus->tablet_switch_inverted = true;
 		asus_wmi_tablet_sw_init(asus, ASUS_WMI_DEVID_KBD_DOCK, NOTIFY_KBD_DOCK_CHANGE);
 		break;
 	case asus_wmi_lid_flip_devid:
@@ -573,10 +582,8 @@ static void asus_wmi_tablet_mode_get_state(struct asus_wmi *asus)
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
-- 
2.39.0



