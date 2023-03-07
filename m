Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A990BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D19C433EF;
	Tue,  7 Mar 2023 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213727;
	bh=kCgNdSzQTwPIWxIxvSQ83sqFxd3ROzKZoY0gQDyaL+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ghBWg+23bgGU+0NV3SjF1xaNP+L/ZQeD6eCVmhh63UcwKOLoHhzZOSkpe5dtcHtK
	 2RBXOQMkWFAqKwIF/1h/jprYb0YVqq82JhCILW1ZoU1Ii76FbzjJsuH+lGDVwod11p
	 lCXK7QrD0OV2kAgYdHglVdcwviL97l0DpSEBm4h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyuan Liang <jingyliang@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 598/885] HID: Add Mapping for System Microphone Mute
Date: Tue,  7 Mar 2023 17:58:52 +0100
Message-Id: <20230307170028.329353447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jingyuan Liang <jingyliang@chromium.org>

[ Upstream commit 2d60f9f4f26785a00273cb81fe60eff129ebd449 ]

HUTRR110 added a new usage code for a key that is supposed to
mute/unmute microphone system-wide.

Map the new usage code(0x01 0xa9) to keycode KEY_MICMUTE.
Additionally hid-debug is adjusted to recognize this keycode as well.

Signed-off-by: Jingyuan Liang <jingyliang@chromium.org>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-debug.c | 1 +
 drivers/hid/hid-input.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 2ca6ab600bc9f..15e35702773cd 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -972,6 +972,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_KBD_LAYOUT_NEXT] = "KbdLayoutNext",
 	[KEY_EMOJI_PICKER] = "EmojiPicker",
 	[KEY_DICTATE] = "Dictate",
+	[KEY_MICMUTE] = "MicrophoneMute",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7e94ca1822afb..8797ec7b29322 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -793,6 +793,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
+		if ((usage->hid & 0xf0) == 0xa0) {	/* SystemControl */
+			switch (usage->hid & 0xf) {
+			case 0x9: map_key_clear(KEY_MICMUTE); break;
+			default: goto ignore;
+			}
+			break;
+		}
+
 		if ((usage->hid & 0xf0) == 0xb0) {	/* SC - Display */
 			switch (usage->hid & 0xf) {
 			case 0x05: map_key_clear(KEY_SWITCHVIDEOMODE); break;
-- 
2.39.2



