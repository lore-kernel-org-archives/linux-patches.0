Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AA3281353;
	Thu, 13 Feb 2025 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457285; cv=none; b=nBC5j/U1at4isqkaxZB6VlBRXouvST3jnVs+YAv5ky6GduMJ+PQf5DqQjgSLKX8zYlTcHw8Xy2dAAUhOFPbAvD5SErU+BcGVr1tY7+FZ5nDhx3jxY10uy+nJHGQP0m+EXv7iCEB1lcK3jj0rMYIXfO5I5DRda0K/8EHxwr8YdPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457285; c=relaxed/simple;
	bh=yKkpstYxnTE6WVaV5oQGbKj/Alv4wTJxVuAiXSCy5ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5ZLDn7xQSZTCt36mxVSlsJolM0u+Xa9EPvUZBz/hD3NDuXmUmeAcgcC1GGkmcrkL2BeSdHWAlivNbu8C2HFAxWfAsqT+Y2MTPo/EsuclVFH6KwvqYcYzRktMM/yGN76Doik+LQv22eiUmjPu9WW1Tc0AzbCaRYsP7dOR4xtpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+qlFdz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+qlFdz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230FBC4CEE4;
	Thu, 13 Feb 2025 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457285;
	bh=yKkpstYxnTE6WVaV5oQGbKj/Alv4wTJxVuAiXSCy5ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+qlFdz1lmCCFlYE+Eb8N7uu1BrYa/GJ+5UTWI5zd3WX1bpHyXBwt8bnMwq1n2+ot
	 cmxOUHx0AhazR3tU0khX1HjHBBPqnP8AsXGDGmH/AmVr6/bKakuzTuhqEQ8k7LcLEL
	 OFFoie7e2NkcYUw4+8DnG1q8WGJOExmJX00sgs/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Connor Belli <connorbelli2003@gmail.com>,
	Jan Schmidt <jan@centricular.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/422] HID: hid-asus: Disable OOBE mode on the ProArt P16
Date: Thu, 13 Feb 2025 15:23:38 +0100
Message-ID: <20250213142439.222255548@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 53078a736fbc60e5d3a1e14f4cd4214003815026 ]

The new ASUS ProArt 16" laptop series come with their keyboards stuck in
an Out-Of-Box-Experience mode. While in this mode most functions will
not work such as LED control or Fn key combos. The correct init sequence
is now done to disable this OOBE.

This patch addresses only the ProArt series so far and it is unknown if
there may be others, in which case a new quirk may be required.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Co-developed-by: Connor Belli <connorbelli2003@gmail.com>
Signed-off-by: Connor Belli <connorbelli2003@gmail.com>
Tested-by: Jan Schmidt <jan@centricular.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c                     | 26 ++++++++++++++++++++++
 include/linux/platform_data/x86/asus-wmi.h |  5 +++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index a4b47319ad8ea..bcdd168cdc6d7 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -432,6 +432,26 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
 	return ret;
 }
 
+static int asus_kbd_disable_oobe(struct hid_device *hdev)
+{
+	const u8 init[][6] = {
+		{ FEATURE_KBD_REPORT_ID, 0x05, 0x20, 0x31, 0x00, 0x08 },
+		{ FEATURE_KBD_REPORT_ID, 0xBA, 0xC5, 0xC4 },
+		{ FEATURE_KBD_REPORT_ID, 0xD0, 0x8F, 0x01 },
+		{ FEATURE_KBD_REPORT_ID, 0xD0, 0x85, 0xFF }
+	};
+	int ret;
+
+	for (size_t i = 0; i < ARRAY_SIZE(init); i++) {
+		ret = asus_kbd_set_report(hdev, init[i], sizeof(init[i]));
+		if (ret < 0)
+			return ret;
+	}
+
+	hid_info(hdev, "Disabled OOBE for keyboard\n");
+	return 0;
+}
+
 static void asus_schedule_work(struct asus_kbd_leds *led)
 {
 	unsigned long flags;
@@ -534,6 +554,12 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 		ret = asus_kbd_init(hdev, FEATURE_KBD_LED_REPORT_ID2);
 		if (ret < 0)
 			return ret;
+
+		if (dmi_match(DMI_PRODUCT_FAMILY, "ProArt P16")) {
+			ret = asus_kbd_disable_oobe(hdev);
+			if (ret < 0)
+				return ret;
+		}
 	} else {
 		/* Initialize keyboard */
 		ret = asus_kbd_init(hdev, FEATURE_KBD_REPORT_ID);
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 365e119bebaa2..783e2a336861b 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -184,6 +184,11 @@ static const struct dmi_system_id asus_use_hid_led_dmi_ids[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ROG Flow"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "ProArt P16"),
+		},
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GA403U"),
-- 
2.39.5



