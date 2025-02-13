Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B271FF5F7;
	Thu, 13 Feb 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458792; cv=none; b=IbbSZ7uyizhse7L7qk+cZ0VDAbBFlaTLEUY6hWlMR6Ygp+rx1HIZE+TYrpVSMcZ0kp6wc1DMFq9hmyUTjwQ/kdL3JMVOXRFk+dF/4Ixv0ibgegcnhXcyd3ZA28MVUDp0bKqK9Mue4g673fW2LEy+5D74tA9GxFSK6YKj2mIuMaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458792; c=relaxed/simple;
	bh=cE8p8kuV1NuAB1Vqc/5GV8E9kKbkvvGhxGw4e+UYCt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGVfSLDZwa6Mv7jyyogjC1x1krlpT68YjvSA1pNFzoZsTvzJJAILscl9cCIgw2QcHsq3wrWGD6mzYDNp31aH6wgMObhhm020ZGmcKH9nsD7i/gDNoTvorqZjrmUPD+JOPYujQBdpITF33mZ2nGrPfvZWzdVs0PMSEM4fDgC30FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNJBn2eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNJBn2eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C29C4CEE5;
	Thu, 13 Feb 2025 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458792;
	bh=cE8p8kuV1NuAB1Vqc/5GV8E9kKbkvvGhxGw4e+UYCt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNJBn2eCaOHyy/OYNjV+68PQ6PiSg/+3dstLB1rWETji2ROcsrmWS00fiyb775QXJ
	 OEqR1BDkyF9jlD0hqf6p2TN8tOYBieQyKbquGrW8klt9n3OUSsCUhca6DIV2ThY+wT
	 dlCP7DK76hlULJaF5xUbbcM4No3RQHCEf+93qLHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Connor Belli <connorbelli2003@gmail.com>,
	Jan Schmidt <jan@centricular.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 080/443] HID: hid-asus: Disable OOBE mode on the ProArt P16
Date: Thu, 13 Feb 2025 15:24:05 +0100
Message-ID: <20250213142443.698746365@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 506c6f377e7d6..46e3e42f9eb5f 100644
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



