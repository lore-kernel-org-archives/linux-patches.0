Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D61A28AB1E;
	Tue,  2 Sep 2025 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820579; cv=none; b=B561yC884DrjCPwEZR1C8w0FgMr/VlV6625rpjoOB3LoBFvPDHzCqnp8TiaxreTLVTTPJCPwmESq+p4SnTR5y7i0kW2g0oPzFpg2GlndTWpUaHyCtdRRdAUARtLXgDKiBhyztS9+h50G8oEn49DDfjogmld+xcjn7In7yocDarE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820579; c=relaxed/simple;
	bh=saRsNWTDGlmtNqdQFyv1I2qK3gVyPA6LtpQzmR6whsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+FhviKX/HLGx3MLl7SUN+Q36EGI2/+kC6gOm3E+FRDW7z7b1e0r4I+Pte5gFjeNiMwx0Ui/H0CNiSFjIUftbvAx1dMS5If+H0zOtZHoRRry3oJL8T8NAqbUMwA1vOyf+8x76te6SQJs4kfoBFYvOH9Pr92YmIH4lkPlTH1UcEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fc5V8hEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fc5V8hEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E617C4CEED;
	Tue,  2 Sep 2025 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820579;
	bh=saRsNWTDGlmtNqdQFyv1I2qK3gVyPA6LtpQzmR6whsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc5V8hECWkGvWjIKI6pUT/OTVpqXXgKDQCVGJSVsSvraffG2vCRRieMXcE8bYwFEG
	 dQfQHFbbUmG//SxSyBo/v7e2LUNF8ljmtIS/fV+iolDPZRO3sSog6BZjBOB9J5Wius
	 /PwSimswtJI/IDu4aqstL0Y2Qfa/SEjbRtVHmEAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 23/33] HID: multitouch: fix slab out-of-bounds access in mt_report_fixup()
Date: Tue,  2 Sep 2025 15:21:41 +0200
Message-ID: <20250902131927.966372482@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1448,6 +1448,14 @@ static __u8 *mt_report_fixup(struct hid_
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


