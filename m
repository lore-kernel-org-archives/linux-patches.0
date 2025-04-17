Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC8619ABC6;
	Thu, 17 Apr 2025 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915746; cv=none; b=MVV3LtFMYabHyDGxripMx1kf7nKARCLUT+wIUQd1yGoxcqwL9aAZmmD+j+3z25uRxlgQKCkvOJMKesIZzda2A714mv2jolmo2N0a14Ph6ufgjN237HXcOwtv5I30C4KslJnBtfjqpr61smjfA2YmZntY76zumo3fsJNHnP/a3Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915746; c=relaxed/simple;
	bh=9++g2dztjblfgwyjJ8I6FqBIGUwwOE/Gwf6C6bFmc0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzxsAKzrrmtj3LTljlPj75MKW+lx2pyZOVDhiRyC2mL05HfVc4xXqfcX9kNYrrDgqmDpceLyR766UracrGgbMDkBCcdYR94Kh5/tVI5/uqU5JJY30jboLLP8kKk0GqyjFc7Fyg6ycT4ONITkfVl8CvQkXqVFAfRSMaQNpxgfjv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiWn542O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiWn542O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A310CC4CEE4;
	Thu, 17 Apr 2025 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915746;
	bh=9++g2dztjblfgwyjJ8I6FqBIGUwwOE/Gwf6C6bFmc0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiWn542O4t86CoRo+9DREZ5qNr2Rg0e6nlT84XjLctiWGPyE9Rzk/pmyqfcx4urGA
	 sLY1v1pV/SPE2eUdnobFn9ifrTzhVRh2XR5eSyAUubQbcB/WHNSZXs6bA8U7nwIMJQ
	 Lhj1lOyZJH28HMUbkIvsmJ5AAeZ8A8kDu6UzS19w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/393] HID: pidff: Fix set_device_control()
Date: Thu, 17 Apr 2025 19:49:55 +0200
Message-ID: <20250417175115.072691518@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit e2fa0bdf08a70623f24ed52f2037a330999d9800 ]

As the search for Device Control report is permissive, make sure the
desired field was actually found, before trying to set it.

Fix bitmask clearing as it was erronously using index instead of
index - 1 (HID arrays index is 1-based).

Add last two missing Device Control usages to the defined array.
PID_PAUSE and PID_CONTINUE.

Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 6eb7934c8f53b..8dfd2c554a276 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -118,7 +118,9 @@ static const u8 pidff_pool[] = { 0x80, 0x83, 0xa9 };
 #define PID_DISABLE_ACTUATORS	1
 #define PID_STOP_ALL_EFFECTS	2
 #define PID_RESET		3
-static const u8 pidff_device_control[] = { 0x97, 0x98, 0x99, 0x9a };
+#define PID_PAUSE		4
+#define PID_CONTINUE		5
+static const u8 pidff_device_control[] = { 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c };
 
 #define PID_CONSTANT	0
 #define PID_RAMP	1
@@ -551,21 +553,29 @@ static void pidff_set_gain_report(struct pidff_device *pidff, u16 gain)
 }
 
 /*
- * Clear device control report
+ * Send device control report to the device
  */
 static void pidff_set_device_control(struct pidff_device *pidff, int field)
 {
-	int i, tmp;
+	int i, index;
 	int field_index = pidff->control_id[field];
 
+	if (field_index < 1)
+		return;
+
 	/* Detect if the field is a bitmask variable or an array */
 	if (pidff->device_control->flags & HID_MAIN_ITEM_VARIABLE) {
 		hid_dbg(pidff->hid, "DEVICE_CONTROL is a bitmask\n");
+
 		/* Clear current bitmask */
 		for(i = 0; i < sizeof(pidff_device_control); i++) {
-			tmp = pidff->control_id[i];
-			pidff->device_control->value[tmp] = 0;
+			index = pidff->control_id[i];
+			if (index < 1)
+				continue;
+
+			pidff->device_control->value[index - 1] = 0;
 		}
+
 		pidff->device_control->value[field_index - 1] = 1;
 	} else {
 		hid_dbg(pidff->hid, "DEVICE_CONTROL is an array\n");
-- 
2.39.5



