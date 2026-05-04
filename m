Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E826F1ADC83;
	Mon,  4 May 2026 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903545; cv=none; b=vARk9q9CjH3yGe66d1uN/MldmtEEmwvNs1TJfU70xN0nKhW3nOu/hs77nk+hu78T2ENSAOmHFKBk5c4DMTi9+b9BDT2f42Voz+sS/MxhN2Lhf169zLoVtVHaRfJn3V5bz8UbdF7biaccJzw8JWpjRBFxKeZuY66Mq1gfEcLQGtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903545; c=relaxed/simple;
	bh=+3afG4Fn1XZ6Xqu+7DhNJT6RNB9KDk9lGvBYcv2pC+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgIkp+TBBG4Z0EIb/TsnJ4psElJM50hXcVwnLk84s8cWTx2vcAbzRMIXdiXJipGqRdLcbmwHzk74MXtfu1Y5QHtiI897/2mzjKGdxADDRJlRLXYR7CfmRHnnVSjggORAozkSMm2kEhoACBG/onAj+DZLKfqDn7HX8nCV5rfl1xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WV6JRavJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WV6JRavJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396CAC2BCB8;
	Mon,  4 May 2026 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903544;
	bh=+3afG4Fn1XZ6Xqu+7DhNJT6RNB9KDk9lGvBYcv2pC+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WV6JRavJkKtmmHmUU+Ume7lBv7OL05A2nVLl8tRQjW8wx/OtBUxG2rWugwIs4S1y2
	 PfePuHRLfINvO/dV+eH8SGEjymQ61Kv+7sfnmLyRVRhhYJVMmQheJ5FCSNsacAQ5E4
	 xA2iDnn4vFGxNH/W5qd503i1dVuWHTrivH47t1lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Eikmeyer?= <andre.eikmeyer@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.0 243/307] HID: apple: ensure the keyboard backlight is off if suspending
Date: Mon,  4 May 2026 15:52:08 +0200
Message-ID: <20260504135151.974617406@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 1f95a6cd5ad78ed27a31a20cbd1facff6f10b33d upstream.

Some users reported that upon suspending their keyboard backlight
remained on. Fix this by adding the missing LED_CORE_SUSPENDRESUME flag.

Cc: stable@vger.kernel.org
Fixes: 394ba612f941 ("HID: apple: Add support for magic keyboard backlight on T2 Macs")
Fixes: 9018eacbe623 ("HID: apple: Add support for keyboard backlight on certain T2 Macs.")
Reported-by: André Eikmeyer <andre.eikmeyer@gmail.com>
Tested-by: André Eikmeyer <andre.eikmeyer@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -858,6 +858,7 @@ static int apple_backlight_init(struct h
 	asc->backlight->cdev.name = "apple::kbd_backlight";
 	asc->backlight->cdev.max_brightness = rep->backlight_on_max;
 	asc->backlight->cdev.brightness_set_blocking = apple_backlight_led_set;
+	asc->backlight->cdev.flags = LED_CORE_SUSPENDRESUME;
 
 	ret = apple_backlight_set(hdev, 0, 0);
 	if (ret < 0) {
@@ -926,6 +927,7 @@ static int apple_magic_backlight_init(st
 	backlight->cdev.name = ":white:" LED_FUNCTION_KBD_BACKLIGHT;
 	backlight->cdev.max_brightness = backlight->brightness->field[0]->logical_maximum;
 	backlight->cdev.brightness_set_blocking = apple_magic_backlight_led_set;
+	backlight->cdev.flags = LED_CORE_SUSPENDRESUME;
 
 	apple_magic_backlight_set(backlight, 0, 0);
 


