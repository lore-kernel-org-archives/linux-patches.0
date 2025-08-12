Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E8B2FE599;
	Tue, 12 Aug 2025 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025273; cv=none; b=nqNc7MxKQ8XJr/M02a2ND0uTvGZD1PKY4FyN6pDDD/EH/rVqWeI4l6Q66WnmuE59jwGRwUyk5gO+VSsMeiH4ZkG9qfG6wHqDJ69rbWf5FAHdAq6co8TneY7GUJpNoKur5EGjiVfP5N6y9u8qHLvWjuRCKgR5jYNTP8PSnw1oecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025273; c=relaxed/simple;
	bh=n6ZgCNJmPK2GHxEodiWTmb3yFSo9J3NvRSmFhqB08Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sP64XVghbGx1dJJxlU+3VN65BFxkASXi82OYjp9Y7KL1mA5dKNQcvbxJ4T0G/D63fguVxB04r1tSbkn9vOwwViWcSikCqPp3RLnowjBSoltqfc0HVMBBalFoqgQ0hXwmMuHkbeFD+ceh4tBUc8dGs5FpE/GzNwUI3KZBL4vtC2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIM+hkor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIM+hkor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C109FC4CEF0;
	Tue, 12 Aug 2025 19:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025273;
	bh=n6ZgCNJmPK2GHxEodiWTmb3yFSo9J3NvRSmFhqB08Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIM+hkorsVic8TUld7vf6BwhTqxFhYlZxdXoLdA2nC+kyyEebhkQhqDt7cdNoquHD
	 RInIkyRlXxtPBE1EoYVZBOkIB0Xl900aqYfPEbiuu4yOulbHL9xbcsifJUT6wk6Veq
	 iaxWmpaV/Qp0Y4ZnX54qCxzLRaIqKvSu56r8gfWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.16 620/627] HID: apple: validate feature-report field count to prevent NULL pointer dereference
Date: Tue, 12 Aug 2025 19:35:15 +0200
Message-ID: <20250812173455.466885657@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

commit 1bb3363da862e0464ec050eea2fb5472a36ad86b upstream.

A malicious HID device with quirk APPLE_MAGIC_BACKLIGHT can trigger a NULL
pointer dereference whilst the power feature-report is toggled and sent to
the device in apple_magic_backlight_report_set(). The power feature-report
is expected to have two data fields, but if the descriptor declares one
field then accessing field[1] and dereferencing it in
apple_magic_backlight_report_set() becomes invalid
since field[1] will be NULL.

An example of a minimal descriptor which can cause the crash is something
like the following where the report with ID 3 (power report) only
references a single 1-byte field. When hid core parses the descriptor it
will encounter the final feature tag, allocate a hid_report (all members
of field[] will be zeroed out), create field structure and populate it,
increasing the maxfield to 1. The subsequent field[1] access and
dereference causes the crash.

  Usage Page (Vendor Defined 0xFF00)
  Usage (0x0F)
  Collection (Application)
    Report ID (1)
    Usage (0x01)
    Logical Minimum (0)
    Logical Maximum (255)
    Report Size (8)
    Report Count (1)
    Feature (Data,Var,Abs)

    Usage (0x02)
    Logical Maximum (32767)
    Report Size (16)
    Report Count (1)
    Feature (Data,Var,Abs)

    Report ID (3)
    Usage (0x03)
    Logical Minimum (0)
    Logical Maximum (1)
    Report Size (8)
    Report Count (1)
    Feature (Data,Var,Abs)
  End Collection

Here we see the KASAN splat when the kernel dereferences the
NULL pointer and crashes:

  [   15.164723] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN NOPTI
  [   15.165691] KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
  [   15.165691] CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted 6.15.0 #31 PREEMPT(voluntary)
  [   15.165691] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
  [   15.165691] RIP: 0010:apple_magic_backlight_report_set+0xbf/0x210
  [   15.165691] Call Trace:
  [   15.165691]  <TASK>
  [   15.165691]  apple_probe+0x571/0xa20
  [   15.165691]  hid_device_probe+0x2e2/0x6f0
  [   15.165691]  really_probe+0x1ca/0x5c0
  [   15.165691]  __driver_probe_device+0x24f/0x310
  [   15.165691]  driver_probe_device+0x4a/0xd0
  [   15.165691]  __device_attach_driver+0x169/0x220
  [   15.165691]  bus_for_each_drv+0x118/0x1b0
  [   15.165691]  __device_attach+0x1d5/0x380
  [   15.165691]  device_initial_probe+0x12/0x20
  [   15.165691]  bus_probe_device+0x13d/0x180
  [   15.165691]  device_add+0xd87/0x1510
  [...]

To fix this issue we should validate the number of fields that the
backlight and power reports have and if they do not have the required
number of fields then bail.

Fixes: 394ba612f941 ("HID: apple: Add support for magic keyboard backlight on T2 Macs")
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Orlando Chamberlain <orlandoch.dev@gmail.com>
Tested-by: Aditya Garg <gargaditya08@live.com>
Link: https://patch.msgid.link/20250713233008.15131-1-qasdev00@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -890,7 +890,8 @@ static int apple_magic_backlight_init(st
 	backlight->brightness = report_enum->report_id_hash[APPLE_MAGIC_REPORT_ID_BRIGHTNESS];
 	backlight->power = report_enum->report_id_hash[APPLE_MAGIC_REPORT_ID_POWER];
 
-	if (!backlight->brightness || !backlight->power)
+	if (!backlight->brightness || backlight->brightness->maxfield < 2 ||
+	    !backlight->power || backlight->power->maxfield < 2)
 		return -ENODEV;
 
 	backlight->cdev.name = ":white:" LED_FUNCTION_KBD_BACKLIGHT;


