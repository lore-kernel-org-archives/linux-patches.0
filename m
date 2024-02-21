Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C96D7E0E8;
	Wed, 21 Feb 2024 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524434; cv=none; b=uvILF6Hwsa0wZJS53TnGqhC4/GgXQ2OOjiiXWqksKGFGWXDDyEIAuPqRbHnN07URKuL79lMe0hV4MaMm4SB64koI3Um9W39U2WLg7zj+uz1+ioK3eITarTpEnoNj82T72NwjeMaukqUaMKXvJ/eNwqrs+96MuIR73pDosA7cur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524434; c=relaxed/simple;
	bh=a658GTPPwGmuiWS4F3Q68j0VbqFvVunfRtQKftZhGTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDMCVGoQT17DVBk3E9bqgNTUTvb6a+2tF2uDIaY+GcpxYh9V1how0fGyFjVn23aqxFy6AbI/gUZc9sMPIUQNC7WvKv+hfGl9+ChV0ZMCFj/gfo8eRAZQA4l9P+G8nt4MukqWbRErFoJz3WCNtX9ESJdhuUdnTDtjMqi7FJV17eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B61C/43A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B61C/43A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D86FC433C7;
	Wed, 21 Feb 2024 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524434;
	bh=a658GTPPwGmuiWS4F3Q68j0VbqFvVunfRtQKftZhGTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B61C/43AL4LxtWNXzkdvInfZVbObZ/d2bN9MEaOasthKK4gUsypu8W/qnTtBJjtJ8
	 M+hwVff99fKw4Y49xmWUpPS7glk0ii/P++eJpZXoKttaTEsCbU6nFyToioKejzqlqm
	 1Tb9+6WxIE7KwAHB/g+r3jsnpVrrCe7zOEDDw7oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <bberg@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Aseda Aboagye <aaboagye@chromium.org>
Subject: [PATCH 5.10 242/379] HID: apple: Add 2021 magic keyboard FN key mapping
Date: Wed, 21 Feb 2024 14:07:01 +0100
Message-ID: <20240221130002.071612684@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <bberg@redhat.com>

commit 531cb56972f2773c941499fcfb639cd5128dfb27 upstream.

The new 2021 apple models have a different FN key assignment. Add a new
translation table and use that for the 2021 magic keyboard.

Signed-off-by: Benjamin Berg <bberg@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Aseda Aboagye <aaboagye@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -70,6 +70,28 @@ struct apple_key_translation {
 	u8 flags;
 };
 
+static const struct apple_key_translation apple2021_fn_keys[] = {
+	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_ENTER,	KEY_INSERT },
+	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
+	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
+	{ KEY_F3,	KEY_SCALE,          APPLE_FLAG_FKEY },
+	{ KEY_F4,	KEY_SEARCH,         APPLE_FLAG_FKEY },
+	{ KEY_F5,	KEY_MICMUTE,        APPLE_FLAG_FKEY },
+	{ KEY_F6,	KEY_SLEEP,          APPLE_FLAG_FKEY },
+	{ KEY_F7,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
+	{ KEY_F8,	KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
+	{ KEY_F9,	KEY_NEXTSONG,       APPLE_FLAG_FKEY },
+	{ KEY_F10,	KEY_MUTE,           APPLE_FLAG_FKEY },
+	{ KEY_F11,	KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
+	{ KEY_F12,	KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
+	{ KEY_UP,	KEY_PAGEUP },
+	{ KEY_DOWN,	KEY_PAGEDOWN },
+	{ KEY_LEFT,	KEY_HOME },
+	{ KEY_RIGHT,	KEY_END },
+	{ }
+};
+
 static const struct apple_key_translation macbookair_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
 	{ KEY_ENTER,	KEY_INSERT },
@@ -204,7 +226,9 @@ static int hidinput_apple_event(struct h
 	}
 
 	if (fnmode) {
-		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
+		if (hid->product == USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021)
+			table = apple2021_fn_keys;
+		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
 			table = macbookair_fn_keys;
 		else if (hid->product < 0x21d || hid->product >= 0x300)
@@ -363,6 +387,9 @@ static void apple_setup_input(struct inp
 	for (trans = apple_iso_keyboard; trans->from; trans++)
 		set_bit(trans->to, input->keybit);
 
+	for (trans = apple2021_fn_keys; trans->from; trans++)
+		set_bit(trans->to, input->keybit);
+
 	if (swap_fn_leftctrl) {
 		for (trans = swapped_fn_leftctrl_keys; trans->from; trans++)
 			set_bit(trans->to, input->keybit);


