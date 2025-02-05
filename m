Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F338015198D;
	Wed,  5 Feb 2025 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764596; cv=none; b=b7lgk27uPvywqv8Zu1gVmiMc58o+HeHUq7QkbONd8vkqq78B2nTBg4JjilqrPhXHx4RaFjXPfj+PLOYKgcs4m9nXn+4NYtk48S+4oQHsYtNL8oH3x6qGC371NpGng8akJauw7vEPhKzXjTJAagtLq0pNVagMEMg8s3edzBtnjPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764596; c=relaxed/simple;
	bh=A51x4AxD0MclPMlpgeaUMV63uy40HEhM0uuMQDHnVuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzZ+3DIZDJBX1pnvOFunKeKBrpXDXTEp3E70CbRKafSjdVggGCyO5GxyEKN5kDLlVSPsqHgsi7Z68wqBD7DZ8WRUokG9KQj76+ZxzwHMeEiOnT5grbFkdFfjjTgtLpLtLBbsKfNw0crFAkp6rjmTQA4mwKOkAElDwUZ+uTqKrEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvHkq0Zy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvHkq0Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E71C4CED1;
	Wed,  5 Feb 2025 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764595;
	bh=A51x4AxD0MclPMlpgeaUMV63uy40HEhM0uuMQDHnVuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvHkq0ZyBAMJI1QU/G3b/1LaNIir+uK5gUIwdIQpRu+w3tTdNTzHEzjIAMbh/tKsI
	 C1ztAHwzOot8knFnKN7UdM006RGp+o/ZXLg5JfoM7djkC9zZEK32Tjj2NZQs8xSnsh
	 6zEDw6hF/tekcWIX5B5DjIN0yXNQ6R1NW0Mioivc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Aseda Aboagye <aaboagye@chromium.org>,
	Carlos Llamas <cmllamas@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/590] HID: fix generic desktop D-Pad controls
Date: Wed,  5 Feb 2025 14:38:16 +0100
Message-ID: <20250205134500.664823308@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Terry Tritton <terry.tritton@linaro.org>

[ Upstream commit 80818fdc068eaab729bb793d790ae9fd053f7053 ]

The addition of the "System Do Not Disturb" event code caused the Generic
Desktop D-Pad configuration to be skipped. This commit allows both to be
configured without conflicting with each other.

Fixes: 22d6d060ac77 ("input: Add support for "Do Not Disturb"")
Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Reviewed-by: Aseda Aboagye <aaboagye@chromium.org>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 37 +++++++++++++++++--------------------
 include/linux/hid.h     |  1 +
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index fda9dce3da998..9d80635a91ebd 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -810,10 +810,23 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
-		if ((usage->hid & 0xf0) == 0x90) { /* SystemControl*/
-			switch (usage->hid & 0xf) {
-			case 0xb: map_key_clear(KEY_DO_NOT_DISTURB); break;
-			default: goto ignore;
+		if ((usage->hid & 0xf0) == 0x90) { /* SystemControl & D-pad */
+			switch (usage->hid) {
+			case HID_GD_UP:	   usage->hat_dir = 1; break;
+			case HID_GD_DOWN:  usage->hat_dir = 5; break;
+			case HID_GD_RIGHT: usage->hat_dir = 3; break;
+			case HID_GD_LEFT:  usage->hat_dir = 7; break;
+			case HID_GD_DO_NOT_DISTURB:
+				map_key_clear(KEY_DO_NOT_DISTURB); break;
+			default: goto unknown;
+			}
+
+			if (usage->hid <= HID_GD_LEFT) {
+				if (field->dpad) {
+					map_abs(field->dpad);
+					goto ignore;
+				}
+				map_abs(ABS_HAT0X);
 			}
 			break;
 		}
@@ -844,22 +857,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		if (field->application == HID_GD_SYSTEM_CONTROL)
 			goto ignore;
 
-		if ((usage->hid & 0xf0) == 0x90) {	/* D-pad */
-			switch (usage->hid) {
-			case HID_GD_UP:	   usage->hat_dir = 1; break;
-			case HID_GD_DOWN:  usage->hat_dir = 5; break;
-			case HID_GD_RIGHT: usage->hat_dir = 3; break;
-			case HID_GD_LEFT:  usage->hat_dir = 7; break;
-			default: goto unknown;
-			}
-			if (field->dpad) {
-				map_abs(field->dpad);
-				goto ignore;
-			}
-			map_abs(ABS_HAT0X);
-			break;
-		}
-
 		switch (usage->hid) {
 		/* These usage IDs map directly to the usage codes. */
 		case HID_GD_X: case HID_GD_Y: case HID_GD_Z:
diff --git a/include/linux/hid.h b/include/linux/hid.h
index a7d60a1c72a09..dd33423012538 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -218,6 +218,7 @@ struct hid_item {
 #define HID_GD_DOWN		0x00010091
 #define HID_GD_RIGHT		0x00010092
 #define HID_GD_LEFT		0x00010093
+#define HID_GD_DO_NOT_DISTURB	0x0001009b
 /* Microsoft Win8 Wireless Radio Controls CA usage codes */
 #define HID_GD_RFKILL_BTN	0x000100c6
 #define HID_GD_RFKILL_LED	0x000100c7
-- 
2.39.5



