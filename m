Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFD41170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED71C433C7;
	Mon, 11 Sep 2023 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441785;
	bh=pojM55RK9NRzl/TKPPPYQIhSVjfzEcQ48BLCxO+wt7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5U7AVwvmAqw5Ex4BNNog2DgU/9b9xqCEHLt0fsK89mRbFAYLgwnVP+GIZfMiER5o
	 HFuodI//Q+zY6Rnoz9w33YgArjEVqUEYUdqkQgIX06OE0nN6s8v//Tah9wrv5rliEG
	 UK77XUmwUZ85uwdMnV812gpiLaHZ9vUnfUn0HAMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nils Fuhler <nils@nilsfuhler.de>,
	Illia Ostapyshyn <ostapyshyn@sra.uni-hannover.de>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 536/739] HID: input: Support devices sending Eraser without Invert
Date: Mon, 11 Sep 2023 15:45:35 +0200
Message-ID: <20230911134706.073679309@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Illia Ostapyshyn <ostapyshyn@sra.uni-hannover.de>

[ Upstream commit 276e14e6c3993317257e1787e93b7166fbc30905 ]

Some digitizers (notably XP-Pen Artist 24) do not report the Invert
usage when erasing.  This causes the device to be permanently stuck with
the BTN_TOOL_RUBBER tool after sending Eraser, as Invert is the only
usage that can release the tool.  In this state, Touch and Inrange are
no longer reported to userspace, rendering the pen unusable.

Prior to commit 87562fcd1342 ("HID: input: remove the need for
HID_QUIRK_INVERT"), BTN_TOOL_RUBBER was never set and Eraser events were
simply translated into BTN_TOUCH without causing an inconsistent state.

Introduce HID_QUIRK_NOINVERT for such digitizers and detect them during
hidinput_configure_usage().  This quirk causes the tool to be released
as soon as Eraser is reported as not set.  Set BTN_TOOL_RUBBER in
input->keybit when mapping Eraser.

Fixes: 87562fcd1342 ("HID: input: remove the need for HID_QUIRK_INVERT")
Co-developed-by: Nils Fuhler <nils@nilsfuhler.de>
Signed-off-by: Nils Fuhler <nils@nilsfuhler.de>
Signed-off-by: Illia Ostapyshyn <ostapyshyn@sra.uni-hannover.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 18 ++++++++++++++++--
 include/linux/hid.h     |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 851ee86eff32a..40a5645f8fe81 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -988,6 +988,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			return;
 
 		case 0x3c: /* Invert */
+			device->quirks &= ~HID_QUIRK_NOINVERT;
 			map_key_clear(BTN_TOOL_RUBBER);
 			break;
 
@@ -1013,9 +1014,13 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x45: /* ERASER */
 			/*
 			 * This event is reported when eraser tip touches the surface.
-			 * Actual eraser (BTN_TOOL_RUBBER) is set by Invert usage when
-			 * tool gets in proximity.
+			 * Actual eraser (BTN_TOOL_RUBBER) is set and released either
+			 * by Invert if tool reports proximity or by Eraser directly.
 			 */
+			if (!test_bit(BTN_TOOL_RUBBER, input->keybit)) {
+				device->quirks |= HID_QUIRK_NOINVERT;
+				set_bit(BTN_TOOL_RUBBER, input->keybit);
+			}
 			map_key_clear(BTN_TOUCH);
 			break;
 
@@ -1580,6 +1585,15 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 		else if (report->tool != BTN_TOOL_RUBBER)
 			/* value is off, tool is not rubber, ignore */
 			return;
+		else if (*quirks & HID_QUIRK_NOINVERT &&
+			 !test_bit(BTN_TOUCH, input->key)) {
+			/*
+			 * There is no invert to release the tool, let hid_input
+			 * send BTN_TOUCH with scancode and release the tool after.
+			 */
+			hid_report_release_tool(report, input, BTN_TOOL_RUBBER);
+			return;
+		}
 
 		/* let hid-input set BTN_TOUCH */
 		break;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 39e21e3815ad4..9e8f87800e21a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -360,6 +360,7 @@ struct hid_item {
 #define HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP	BIT(18)
 #define HID_QUIRK_HAVE_SPECIAL_DRIVER		BIT(19)
 #define HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE	BIT(20)
+#define HID_QUIRK_NOINVERT			BIT(21)
 #define HID_QUIRK_FULLSPEED_INTERVAL		BIT(28)
 #define HID_QUIRK_NO_INIT_REPORTS		BIT(29)
 #define HID_QUIRK_NO_IGNORE			BIT(30)
-- 
2.40.1



