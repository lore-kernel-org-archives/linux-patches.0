Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC421DE4C9;
	Wed, 19 Mar 2025 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395154; cv=none; b=QjRHUPItGzHSudc0sgyySOZvZz3QFh/fo+UxE/ryIskldv376mB7SM//6+u5EA6o7FlXLImVB3KTSq/aneHZJ5mxn+snpG4hzi7hl+6SmaJ4/G5jEWCmMfq4+JvW9yNld/lwLKJ8XMh/tWJzvIFNoFMZOlRYF18XD2EDwAuPuYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395154; c=relaxed/simple;
	bh=0mUbuOg2g9QJUGtenOXRAhIqJNiPCEyqZrgbuDBFDvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et7/R+BerKsEmyryFEm7cdsQNtZJEG3JJ7S4pBraeub0ZyMKdO4AFbeKmMn4Ke8Dj+cRA5s+qElhtJf7ffeC2eawHMobaEVGZuwruMl69/pt5swTc/XDraXZqZoz6sVUCpD8bNCesr5uZaOjHqhH4YWcrnaLTRW5j8NAq2bhq/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cesiRGd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cesiRGd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2AC4CEE4;
	Wed, 19 Mar 2025 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395154;
	bh=0mUbuOg2g9QJUGtenOXRAhIqJNiPCEyqZrgbuDBFDvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cesiRGd6B3WRyuoQDfjF3DyE5RsqragG1tGtUQTrx5dnNrSLx21SxJYvzQPK1tjJW
	 GUSZZKMeDGdc4eWiMz7biocGAkpFYzVEFiWjEK/manieaTY14GCUnYQ0OE+S3UvDNI
	 Q3TNxUusRfFCvcu9rN/5BifygQsLNuNzFbZ81al8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 230/231] HID: apple: disable Fn key handling on the Omoton KB066
Date: Wed, 19 Mar 2025 07:32:03 -0700
Message-ID: <20250319143032.522635845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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


