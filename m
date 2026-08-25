Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D1345D1A4;
	Tue, 25 Aug 2026 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665606; cv=none; b=cVNp131N7FVmXlsFkRZv/CBAK2tb4qsPWqORcXS5hFEFVK21pV+TanxI5iyyumOFAJIpAaCmZne25rSHxzC1Ppgtw8I2n0Fk5yRXb3eEe9/PwF9fi8oB57ZixeEAswyKXmYhVWDjSBjCMduxONK527KmPPVozI8+3V9c5rnv8Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665606; c=relaxed/simple;
	bh=O3DpBbcaYQqQkkP0NbD/NPgSRPxh+fFUOJZKar3HSh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ls+TT/7uS0qDXySed6q3IOjLft/6kZoSNY7eoy5GgiPW3b1sVwXw7j+rAV9wAtNNzQRVCdMzIOFRa2VO8jK1BfUyPO4jro1uCMW5Wj63XGsJ9epQq7W13Z6VvgVehY+oFbOsnO+c/becirvKY2zATgxrRRe5jjz1pxN32ra9Ges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=din7gX+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="din7gX+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A0D1F00A3A;
	Tue, 25 Aug 2026 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665601;
	bh=03bAM6IxQZf8FxqLx5Hxedx2313STscAxc0Zc+Z8asw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=din7gX+nNeSEdh5IUKOsVOSoO7hHSIDhTjwCr1/p+E+UTJOatyRNu/Ja6WRw/sOgm
	 MJyt07+W8p5XJeA1ZSz9H4u6SwLxlAEm9AWjMSEi2gqoJ7WXwwr2GBIa0ktwZHWvmj
	 +AhP3wtY2H2TeD/to3BhZVvv+umIP+Pq0Je5/PGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jose=20Villase=C3=B1or=20Montfort?= <pepemontfort@gmail.com>,
	Alec Hall <signshop.alec@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 59/77] HID: magicmouse: do not keep a stale msc->input if no input is claimed
Date: Tue, 25 Aug 2026 15:26:21 +0200
Message-ID: <20260825132543.876554096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -872,6 +872,16 @@ static int magicmouse_probe(struct hid_d
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


