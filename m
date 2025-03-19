Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5007720B803;
	Wed, 19 Mar 2025 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395000; cv=none; b=emSUuergN5yd13/JDcjY3NDrKvnqgKegVYeHqA0u/Vv8v/87wzJo3vnJrxtIIxh5Xt0oli+ARaVxHb+THfCD4D+DkRgn5yUWgL6zvViIPy+RYgYrRCnQbQH2a4gQhQlGiAHzWRa+4jiEr+QODXA5KDj/UWvyxpv51cx9kNqoC08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395000; c=relaxed/simple;
	bh=aMZZzEjhgCmrZ4J1Ai5nhjEPf9weWP919QOwFl+tdzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlNmf40LOqkuOOvIPWNSCbmyE07PiyNvBSi9WJtWR+z4EqAadt2pf0F0AXHr//y4/DtCrQWnfAibbiIPuBY8XylEbyN404sy+IzlflC1d8+YobUMQpq8IGIgWEIKXF9d3mmPNPTQawgTECu8sUXXnFSndz034dB7BqWdqA8n6tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRDtpS1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRDtpS1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25671C4CEE9;
	Wed, 19 Mar 2025 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395000;
	bh=aMZZzEjhgCmrZ4J1Ai5nhjEPf9weWP919QOwFl+tdzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRDtpS1ATxMmfvIDXPh6nh/L0uzEp9mUTMYyk37nqazX+Jpb7MDjD2cHquJe16FyQ
	 Cdd1z2ywRR83tzYuMQk+9WIUwLsK5B1Apnmv5+2/L+RnQDY0c136mG9mAwfK0PdU/a
	 M1ez/cPuqZWL7WD4AAJvrW9ZUlxVDR0WKaczO5kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.13 240/241] HID: apple: disable Fn key handling on the Omoton KB066
Date: Wed, 19 Mar 2025 07:31:50 -0700
Message-ID: <20250319143033.673634860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Alex Henrie <alexhenrie24@gmail.com>

commit 221cea1003d8a412e5ec64a58df7ab19b654f490 upstream.

Remove the fixup to make the Omoton KB066's F6 key F6 when not holding
Fn. That was really just a hack to allow typing F6 in fnmode>0, and it
didn't fix any of the other F keys that were likewise untypable in
fnmode>0. Instead, because the Omoton's Fn key is entirely internal to
the keyboard, completely disable Fn key translation when an Omoton is
detected, which will prevent the hid-apple driver from interfering with
the keyboard's built-in Fn key handling. All of the F keys, including
F6, are then typable when Fn is held.

The Omoton KB066 and the Apple A1255 both have HID product code
05ac:022c. The self-reported name of every original A1255 when they left
the factory was "Apple Wireless Keyboard". By default, Mac OS changes
the name to "<username>'s keyboard" when pairing with the keyboard, but
Mac OS allows the user to set the internal name of Apple keyboards to
anything they like. The Omoton KB066's name, on the other hand, is not
configurable: It is always "Bluetooth Keyboard". Because that name is so
generic that a user might conceivably use the same name for a real Apple
keyboard, detect Omoton keyboards based on both having that exact name
and having HID product code 022c.

Fixes: 819083cb6eed ("HID: apple: fix up the F6 key on the Omoton KB066 keyboard")
Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Reviewed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -378,6 +378,12 @@ static bool apple_is_non_apple_keyboard(
 	return false;
 }
 
+static bool apple_is_omoton_kb066(struct hid_device *hdev)
+{
+	return hdev->product == USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI &&
+		strcmp(hdev->name, "Bluetooth Keyboard") == 0;
+}
+
 static inline void apple_setup_key_translation(struct input_dev *input,
 		const struct apple_key_translation *table)
 {
@@ -546,9 +552,6 @@ static int hidinput_apple_event(struct h
 		}
 	}
 
-	if (usage->hid == 0xc0301) /* Omoton KB066 quirk */
-		code = KEY_F6;
-
 	if (usage->code != code) {
 		input_event_with_scancode(input, usage->type, code, usage->hid, value);
 
@@ -728,7 +731,7 @@ static int apple_input_configured(struct
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
-	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
+	if (((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) || apple_is_omoton_kb066(hdev)) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
 		asc->quirks &= ~APPLE_HAS_FN;
 	}


