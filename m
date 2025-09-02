Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3919830ACFE;
	Tue,  2 Sep 2025 13:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819688; cv=none; b=l1qoz/i6qNo+o+gJhOhLLCIXBxoPstHkezdCcCzUynMWOPt3SHSHKeceKaRysmAuhaz6qGyx4XgsBlRePtHNvzd5t7LfhZDrOKFjgHd2rR2nt92PMwZ3J7BT4qkdjKNKm346PlmXyC1iYSlFQZnRz6x275Eb74v6bGvbOIb3WJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819688; c=relaxed/simple;
	bh=7fAppNOECfEX9chDs9S7yBSzNCo1LOr6wlzdSWQddTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDjd8uM5W1qGOSpghlP22nYWlape+B2wcOEy5IUViXF7H/0YqLyaXrDr7459hyERCqWi9CXSGoNMv6a8TgcaBo6lKSB9eBr+TJ05eRGBi9xL4sYfRGgA5BYDoAB15Hv5w0ewXMFonVvxfp1urtapzIGXp62YSXgqf1qOI7I2rJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxI/fZQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxI/fZQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6B2C4CEED;
	Tue,  2 Sep 2025 13:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819688;
	bh=7fAppNOECfEX9chDs9S7yBSzNCo1LOr6wlzdSWQddTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxI/fZQ929XYECvat4EX2s4MzckO8cHMFIetlGSV+20d5b7U7zpD9zZRvqH2A1z8K
	 t5zKqLu7osJVlOqfVfYyf4vEzavJKvjmqYQ2I5bNqFJVtAxYllnHlCmZ0Pjv3OoDLM
	 C3QHsZPUIgnc+jR7H8J3vFTrmy6rTSY5IPW/0zhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 110/142] HID: multitouch: fix slab out-of-bounds access in mt_report_fixup()
Date: Tue,  2 Sep 2025 15:20:12 +0200
Message-ID: <20250902131952.490618221@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 0379eb8691b9c4477da0277ae0832036ca4410b4 upstream.

A malicious HID device can trigger a slab out-of-bounds during
mt_report_fixup() by passing in report descriptor smaller than
607 bytes. mt_report_fixup() attempts to patch byte offset 607
of the descriptor with 0x25 by first checking if byte offset
607 is 0x15 however it lacks bounds checks to verify if the
descriptor is big enough before conducting this check. Fix
this bug by ensuring the descriptor size is at least 608
bytes before accessing it.

Below is the KASAN splat after the out of bounds access happens:

[   13.671954] ==================================================================
[   13.672667] BUG: KASAN: slab-out-of-bounds in mt_report_fixup+0x103/0x110
[   13.673297] Read of size 1 at addr ffff888103df39df by task kworker/0:1/10
[   13.673297]
[   13.673297] CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted 6.15.0-00005-gec5d573d83f4-dirty #3
[   13.673297] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/04
[   13.673297] Call Trace:
[   13.673297]  <TASK>
[   13.673297]  dump_stack_lvl+0x5f/0x80
[   13.673297]  print_report+0xd1/0x660
[   13.673297]  kasan_report+0xe5/0x120
[   13.673297]  __asan_report_load1_noabort+0x18/0x20
[   13.673297]  mt_report_fixup+0x103/0x110
[   13.673297]  hid_open_report+0x1ef/0x810
[   13.673297]  mt_probe+0x422/0x960
[   13.673297]  hid_device_probe+0x2e2/0x6f0
[   13.673297]  really_probe+0x1c6/0x6b0
[   13.673297]  __driver_probe_device+0x24f/0x310
[   13.673297]  driver_probe_device+0x4e/0x220
[   13.673297]  __device_attach_driver+0x169/0x320
[   13.673297]  bus_for_each_drv+0x11d/0x1b0
[   13.673297]  __device_attach+0x1b8/0x3e0
[   13.673297]  device_initial_probe+0x12/0x20
[   13.673297]  bus_probe_device+0x13d/0x180
[   13.673297]  device_add+0xe3a/0x1670
[   13.673297]  hid_add_device+0x31d/0xa40
[...]

Fixes: c8000deb6836 ("HID: multitouch: Add support for GT7868Q")
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1461,6 +1461,14 @@ static const __u8 *mt_report_fixup(struc
 	if (hdev->vendor == I2C_VENDOR_ID_GOODIX &&
 	    (hdev->product == I2C_DEVICE_ID_GOODIX_01E8 ||
 	     hdev->product == I2C_DEVICE_ID_GOODIX_01E9)) {
+		if (*size < 608) {
+			dev_info(
+				&hdev->dev,
+				"GT7868Q fixup: report descriptor is only %u bytes, skipping\n",
+				*size);
+			return rdesc;
+		}
+
 		if (rdesc[607] == 0x15) {
 			rdesc[607] = 0x25;
 			dev_info(


