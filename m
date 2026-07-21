Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CCD471254;
	Tue, 21 Jul 2026 21:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667871; cv=none; b=mMUZ+j/5zzBywcR25Quao4J8gyLzBDqBlabrV+j3BWKa/D4uPOK9zFVEuhKvIrbMseUktU5kS7d9h6wz5tncjEh5v7e+ZPBP4SKIzPA+dZqvYeiJE6i4RuBs+0/hYsd9NIVlDig4KXvtbkcVBPqcCXOngh2Fs7FZmXttvv0cS5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667871; c=relaxed/simple;
	bh=3/tMdR0LLRGQ3+Ir0NpjyFeSz979uVN83f4g/zBnqwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIJ1NVqkpMeMBeIiHpLxd5H/BA/qo8/7ORDED+YJML9h4I2MvyVhn21wf9By3XMgTUqPpREpr2azaWnS0y3nb8vPa8KZIwTB6HfClvC1G8uMg4Y7CSIhiBurnoJD6zdVfT9Z5DUwb6LgxxfTMIFwkpAuDPliaDbv7HgcMIwVVaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwFrxWFY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwFrxWFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934341F00A3A;
	Tue, 21 Jul 2026 21:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667867;
	bh=Nw064lWm9gqnyXSkfhzi6CyhqV8VElahiIMy5rNAAak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwFrxWFYHWAksJTC6TOcDg2ws3c03HhjwIupKWKv1ruwxloIp+3bTI8ot9fGiXFsu
	 0RDHhvvW1jfu0M/7EL5n2MtTgFGiSZmELSQ9go1/bZL+cQ/3w4RDOIhApMrpAv3q5Z
	 YBGr0r0lus8LNCQ0ISs1byHfIfHARRxpvIRGTNkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+ce1e5a1b4e086b43e56d@syzkaller.appspotmail.com,
	syzbot+306212936b13e520679d@syzkaller.appspotmail.com,
	syzbot+457452d30bcdda75ead2@syzkaller.appspotmail.com,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>,
	Andrey Tsygunka <aitsygunka@yandex.ru>
Subject: [PATCH 6.6 1223/1266] usb: atm: ueagle-atm: wait for pre-firmware load in .disconnect()
Date: Tue, 21 Jul 2026 17:27:40 +0200
Message-ID: <20260721152509.172503601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit e2674dfbed8a30d57e2bc872c4bfa6c3eec918bf ]

ueagle-atm uses the asynchronous request_firmware_nowait() in .probe(),
but does not wait for its completion, not even in .disconnect(); so, if the
device is unplugged meanwhile, its teardown runs concurrently with that.

Even though this inconsistency is worth addressing on its own, it has also
triggered several bug reports in syzbot over the years (some auto-closed)
where the firmware sysfs fallback mechanism (CONFIG_FW_LOADER_USER_HELPER)
creates a firmware subdirectory in the device directory during its removal,
which might hit unexpected conditions in kernfs, apparently, depending at
which point the add and remove operations raced. (See links.)

The pattern is:

usb ?-?: Direct firmware load for ueagle-atm/eagle?.fw failed with error -2
usb ?-?: Falling back to sysfs fallback for: ueagle-atm/eagle?.fw
<ERROR>
Call trace:
 ...
 kernfs_create_dir_ns
 sysfs_create_dir_ns
 create_dir
 kobject_add_internal
 kobject_add_varg
 kobject_add
 class_dir_create_and_add
 get_device_parent
 device_add
 fw_load_sysfs_fallback
 fw_load_from_user_helper
 firmware_fallback_sysfs
 _request_firmware
 request_firmware_work_func
 ...

(Some variations are observed, after fw_load_sysfs_fallback(), e.g., [1].)

While the kernfs side is being looked at, the ueagle-atm side can be fixed
by waiting for the pre-firmware load in the .disconnect() handler.

This change has a similar approach to previous work by Andrey Tsygunka [2]
(wait_for_completion() in .disconnect()), but it is relatively different in
design/implementation; using the Originally-by tag for credit assignment.

This has been tested with:
- synthetic reproducer to check the error path;
- USB gadget (virtual device) to check the firmware upload path;
- QEMU device emulator to check the device ID re-enumeration path;
(The latter two were written by Claude; no other code/text in this commit.)

Links (year first reported):
 2025 https://syzbot.org/bug?extid=ce1e5a1b4e086b43e56d
 2025 https://syzbot.org/bug?extid=9af8471255ac36e34fd4
 2024 https://syzbot.org/bug?extid=306212936b13e520679d
 2023 https://syzkaller.appspot.com/bug?extid=457452d30bcdda75ead2
 2022 https://syzbot.org/bug?extid=782984d6f1701b526edb
 2021 https://syzbot.org/bug?id=f3f221579f4ef7e9691281f3c6f56c05f83e8490
 2021 https://syzbot.org/bug?id=84d86f0d71394829df6fc53daf6642c045983881
 2021 https://syzbot.org/bug?id=3302dc1c0e2b9c94f2e8edb404eabc9267bc6f90

[1] https://syzkaller.appspot.com/bug?extid=457452d30bcdda75ead2
[2] https://lore.kernel.org/lkml/20250410093146.3776801-2-aitsygunka@yandex.ru/

Cc: stable <stable@kernel.org>
Reported-by: syzbot+ce1e5a1b4e086b43e56d@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=ce1e5a1b4e086b43e56d
Reported-by: syzbot+306212936b13e520679d@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=306212936b13e520679d
Reported-by: syzbot+457452d30bcdda75ead2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=457452d30bcdda75ead2
Originally-by: Andrey Tsygunka <aitsygunka@yandex.ru>
Fixes: b72458a80c75 ("[PATCH] USB: Eagle and ADI 930 usb adsl modem driver")
Assisted-by: Claude:claude-opus-4.7 # usb gadget & qemu device for testing
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260526-ueagle-atm_req-fw-sync-v3-1-93c01961daaf@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/atm/ueagle-atm.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -599,7 +599,9 @@ static int uea_send_modem_cmd(struct usb
 static void uea_upload_pre_firmware(const struct firmware *fw_entry,
 								void *context)
 {
-	struct usb_device *usb = context;
+	struct usb_interface *intf = context;
+	struct usb_device *usb = interface_to_usbdev(intf);
+	struct completion *fw_done = usb_get_intfdata(intf);
 	const u8 *pfw;
 	u8 value;
 	u32 crc = 0;
@@ -670,15 +672,17 @@ err_fw_corrupted:
 err:
 	release_firmware(fw_entry);
 	uea_leaves(usb);
+	complete(fw_done);
 }
 
 /*
  * uea_load_firmware - Load usb firmware for pre-firmware devices.
  */
-static int uea_load_firmware(struct usb_device *usb, unsigned int ver)
+static int uea_load_firmware(struct usb_interface *intf, unsigned int ver)
 {
 	int ret;
 	char *fw_name = EAGLE_FIRMWARE;
+	struct usb_device *usb = interface_to_usbdev(intf);
 
 	uea_enters(usb);
 	uea_info(usb, "pre-firmware device, uploading firmware\n");
@@ -702,7 +706,7 @@ static int uea_load_firmware(struct usb_
 	}
 
 	ret = request_firmware_nowait(THIS_MODULE, 1, fw_name, &usb->dev,
-					GFP_KERNEL, usb,
+					GFP_KERNEL, intf,
 					uea_upload_pre_firmware);
 	if (ret)
 		uea_err(usb, "firmware %s is not available\n", fw_name);
@@ -2598,8 +2602,23 @@ static int uea_probe(struct usb_interfac
 
 	usb_reset_device(usb);
 
-	if (UEA_IS_PREFIRM(id))
-		return uea_load_firmware(usb, UEA_CHIP_VERSION(id));
+	if (UEA_IS_PREFIRM(id)) {
+		struct completion *fw_done;
+
+		/* Wait for the firmware load to be done, in .disconnect() */
+		fw_done = kzalloc(sizeof(*fw_done), GFP_KERNEL);
+		if (!fw_done)
+			return -ENOMEM;
+
+		init_completion(fw_done);
+		usb_set_intfdata(intf, fw_done);
+
+		ret = uea_load_firmware(intf, UEA_CHIP_VERSION(id));
+		if (ret)
+			kfree(fw_done);
+
+		return ret;
+	}
 
 	ret = usbatm_usb_probe(intf, id, &uea_usbatm_driver);
 	if (ret == 0) {
@@ -2630,6 +2649,13 @@ static void uea_disconnect(struct usb_in
 		usbatm_usb_disconnect(intf);
 		mutex_unlock(&uea_mutex);
 		uea_info(usb, "ADSL device removed\n");
+	} else if (usb->config->desc.bNumInterfaces == 1) {
+		struct completion *fw_done = usb_get_intfdata(intf);
+
+		uea_dbg(usb, "pre-firmware device, waiting firmware upload\n");
+		wait_for_completion(fw_done);
+		uea_dbg(usb, "pre-firmware device, finished waiting\n");
+		kfree(fw_done);
 	}
 
 	uea_leaves(usb);


