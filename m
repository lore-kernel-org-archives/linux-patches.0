Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6A7522A;
	Wed,  5 Feb 2025 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765146; cv=none; b=dyDsSCkD94hijujF8yu+OGJunqG8TycQBg0Cvw0zcEzXY+iATWAFBxJxCr4K3RoXFaNegkvU258AH4UwKILGhtQ7QaTNxjpDvjhmekgUNfKX7RWoN7Ih6zTOPhjnfY4f51uGaGtJIFORP3hBxudp44IWSL77mD5aCU7p0yPULfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765146; c=relaxed/simple;
	bh=vXO7Q5ePcTqPWNUoK36bAAo3c+rj/8wQ9Nw+jgfjCow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpVQfkZrZPav1mGbhmLn8VmR+otrTjFjzizrUH0+wNuwLKI3QN/vyX96g9/TrysHZL/Sr+wtM3FalEMMWCd8sjyi7YaCLzcS5nfZO+u1Rcx7x8dwMBNSW3Yq+Bhnl8rDekeI0L1+gWDQKYRpS/A/H2pUDeEBcpJ3BwPSxZNcZ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS7P5FLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS7P5FLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95741C4CED1;
	Wed,  5 Feb 2025 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765146;
	bh=vXO7Q5ePcTqPWNUoK36bAAo3c+rj/8wQ9Nw+jgfjCow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS7P5FLwJ9MTKCXZs3mP+PzImIEd+5g3H5IljzOAId7k/b/KCGjbQifeOv0JID13v
	 EOEtoy80vW++6PdoMrV5ISdGzZ/itrGKVArX0/58wYl5X589k+/lHtXurTidxjp0c9
	 fcHIrjosgbDD/Bqzhu9Is7QYBbMpooYNW9vKnSA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Aseda Aboagye <aaboagye@chromium.org>,
	Carlos Llamas <cmllamas@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 147/623] HID: fix generic desktop D-Pad controls
Date: Wed,  5 Feb 2025 14:38:09 +0100
Message-ID: <20250205134501.858815745@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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
index d11e9c9a5f159..cdc0dc13c87fe 100644
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



