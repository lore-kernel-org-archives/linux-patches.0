Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0684749C1;
	Tue, 25 Aug 2026 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666260; cv=none; b=KWs9nABo/oU5xoP3yoywnrE7ueTrCVuKdMPV8LrJrfnJHfw09Pep8oZpp6KYg3j9dc9Lok3RBesC/VDJ1msHHzVezD30kXD1eWxF+mOjhp22LK9Pt405OWNumkPabs2D2CdOgS4pGDVv3fOXMxtqmK2+xV+pwz7uuYlZ28bbjlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666260; c=relaxed/simple;
	bh=P/mGyZf8m9/3LZ/mW5INOngdOyPMFr5LkTYHeAn154g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oq9kPUSULkN6I1M+RHtyJyIUU6D2LqCWHa/pqDYW/i6xpgzuIBOPb1e/Xmy0m4gEyC8iuQy1dIqzyeWEfNQeKwys58P52rHkNtmCSqwQMowo9jJ/603E0+lZ4LkGF3Nyt8iABDSnkxqw6XgWVZg8yvvyi4HPV7NxKRdQuU/AQaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6WUTQsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6WUTQsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583E01F000E9;
	Tue, 25 Aug 2026 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666258;
	bh=AbCWTmgpYNHGaFegB18nIV85aDT58yp9b7WKf4x1kKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6WUTQsXBniY/ZzeEj3KQxG88jZh92b7c3GRHZ2YErpqF7MEHhgpiGGfwFbqZqfUo
	 dF6tCWJaQxXXZlbkpFgexfZHy4lZ/eR7AWr5mzJ0HGrGhsdXwIjhsZgQOXcdTkxLUr
	 +4tucS3K/k5ec2+wompI6xfQluxB6X3UHMeW1Pas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jose=20Villase=C3=B1or=20Montfort?= <pepemontfort@gmail.com>,
	Alec Hall <signshop.alec@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 59/76] HID: magicmouse: do not keep a stale msc->input if no input is claimed
Date: Tue, 25 Aug 2026 15:26:52 +0200
Message-ID: <20260825132543.891280570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Villaseñor Montfort <pepemontfort@gmail.com>

commit 0af3b89705688af01aa06025b84fa7a1e06ba6cc upstream.

magicmouse_input_mapping() caches the first hid_input's input_dev in
msc->input while the report descriptor is parsed, and the rest of the
driver treats a non-NULL msc->input as proof that an input device was
registered.

That does not hold on the hid-input error path. If hidinput_connect()
fails -- for instance because input_register_device() returns an error --
it unwinds through hidinput_disconnect(), which frees every input_dev it
created, including the one cached in msc->input.

The failure does not abort the probe. hid_connect() only skips the claim:

	if ((connect_mask & HID_CONNECT_HIDINPUT) && !hidinput_connect(hdev,
				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
		hdev->claimed |= HID_CLAIMED_INPUT;

and the "device has no listeners" bailout below it does not fire for this
driver, which sets ->raw_event; on the USB Magic Mouse 2 / Magic Trackpad
2 paths hidraw and hiddev are claimed as well. hid_hw_start() therefore
returns 0 and magicmouse_probe() continues with msc->input pointing at
freed memory. Being non-NULL, it passes the "input not registered" check
in probe and the NULL checks in ->raw_event and ->event, so the next
input report dereferences freed memory.

Clear msc->input when the HID core did not claim an input device, so the
existing NULL checks cover this case as well.

Fixes: f1a9a149abc8 ("HID: magicmouse: fix race between input_register() and probe()")
Link: https://lore.kernel.org/linux-input/20260728185542.65F091F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Jose Villaseñor Montfort <pepemontfort@gmail.com>
Reviewed-by: Alec Hall <signshop.alec@gmail.com>
Tested-by: Alec Hall <signshop.alec@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -830,6 +830,16 @@ static int magicmouse_probe(struct hid_d
 		return ret;
 	}
 
+	/*
+	 * When hidinput_connect() fails it frees every input device it
+	 * created, but that does not fail hid_hw_start(): the core simply
+	 * does not claim an input. msc->input, cached in ->input_mapping
+	 * while the report descriptor was parsed, would then be a dangling
+	 * pointer that passes every NULL check. Trust the core's claim.
+	 */
+	if (!(hdev->claimed & HID_CLAIMED_INPUT))
+		msc->input = NULL;
+
 	if (is_usb_magicmouse2(id->vendor, id->product) ||
 	    is_usb_magictrackpad2(id->vendor, id->product)) {
 		timer_setup(&msc->battery_timer, magicmouse_battery_timer_tick, 0);


