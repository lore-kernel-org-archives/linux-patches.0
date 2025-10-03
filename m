Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA929E0E1;
	Fri,  3 Oct 2025 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507712; cv=none; b=R+bLxkIOiwUiXiET+S8Pvy2ib3Qn6Wi9CSjYytJJ3FPgDcD1Mi85l1DLVpdgklfn2XDne6v1pUFWLk4K2GCLuwxwHZCqJT87oBtaslmxnEiTy9RXbk3Y/DX5+92n+rukzX0+bTBmzOUiaYUvJ35RaSkubf3RPC21FXCi2VZ4B0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507712; c=relaxed/simple;
	bh=49PV/xH6VOR3oaagqdQNz/aYRXewxStzhoQ0FBna+uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtmWBopXMLv+vDAKjs9S6mjXOOao58uLGYK8blmfTfdlKrNS4fK9PViTe4Ung5B4gfBTjayq1ci3j4+viXPsHCpWbx3MfxqwDSu7yVEuUKH+8Sbs7SZ5MwG1zKD43ExKA38G7aCfYHMsb8se5ewf4QSZ8D8h7Ce72pFpDBgXzt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BS4iID8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BS4iID8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A138C4CEF5;
	Fri,  3 Oct 2025 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507712;
	bh=49PV/xH6VOR3oaagqdQNz/aYRXewxStzhoQ0FBna+uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS4iID8B/jjg2wIOHXLvyVkISJvDVzQlOCuB0ccIXmM9G0UklM8HkO6kuzqhDZ7kS
	 h+Bg2uoyq+Z8pRKyLG+sy0Fl2uCitOpK59Dby3Q2zrb6WBbA50JQaZxdnslzkKT2de
	 UXf4vNA8+mTejKm8fSCHOSZUxTLaAFwJ0MMmKW6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1a69784f6efe748c3bf@syzkaller.appspotmail.com,
	Larshin Sergey <Sergey.Larshin@kaspersky.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 06/10] media: rc: fix races with imon_disconnect()
Date: Fri,  3 Oct 2025 18:05:53 +0200
Message-ID: <20251003160338.645758932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larshin Sergey <Sergey.Larshin@kaspersky.com>

commit fa0f61cc1d828178aa921475a9b786e7fbb65ccb upstream.

Syzbot reports a KASAN issue as below:
BUG: KASAN: use-after-free in __create_pipe include/linux/usb.h:1945 [inline]
BUG: KASAN: use-after-free in send_packet+0xa2d/0xbc0 drivers/media/rc/imon.c:627
Read of size 4 at addr ffff8880256fb000 by task syz-executor314/4465

CPU: 2 PID: 4465 Comm: syz-executor314 Not tainted 6.0.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:317 [inline]
print_report.cold+0x2ba/0x6e9 mm/kasan/report.c:433
kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
__create_pipe include/linux/usb.h:1945 [inline]
send_packet+0xa2d/0xbc0 drivers/media/rc/imon.c:627
vfd_write+0x2d9/0x550 drivers/media/rc/imon.c:991
vfs_write+0x2d7/0xdd0 fs/read_write.c:576
ksys_write+0x127/0x250 fs/read_write.c:631
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

The iMON driver improperly releases the usb_device reference in
imon_disconnect without coordinating with active users of the
device.

Specifically, the fields usbdev_intf0 and usbdev_intf1 are not
protected by the users counter (ictx->users). During probe,
imon_init_intf0 or imon_init_intf1 increments the usb_device
reference count depending on the interface. However, during
disconnect, usb_put_dev is called unconditionally, regardless of
actual usage.

As a result, if vfd_write or other operations are still in
progress after disconnect, this can lead to a use-after-free of
the usb_device pointer.

Thread 1 vfd_write                      Thread 2 imon_disconnect
                                        ...
                                        if
                                          usb_put_dev(ictx->usbdev_intf0)
                                        else
                                          usb_put_dev(ictx->usbdev_intf1)
...
while
  send_packet
    if
      pipe = usb_sndintpipe(
        ictx->usbdev_intf0) UAF
    else
      pipe = usb_sndctrlpipe(
        ictx->usbdev_intf0, 0) UAF

Guard access to usbdev_intf0 and usbdev_intf1 after disconnect by
checking ictx->disconnected in all writer paths. Add early return
with -ENODEV in send_packet(), vfd_write(), lcd_write() and
display_open() if the device is no longer present.

Set and read ictx->disconnected under ictx->lock to ensure memory
synchronization. Acquire the lock in imon_disconnect() before setting
the flag to synchronize with any ongoing operations.

Ensure writers exit early and safely after disconnect before the USB
core proceeds with cleanup.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Reported-by: syzbot+f1a69784f6efe748c3bf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f1a69784f6efe748c3bf
Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Cc: stable@vger.kernel.org

Signed-off-by: Larshin Sergey <Sergey.Larshin@kaspersky.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -536,7 +536,9 @@ static int display_open(struct inode *in
 
 	mutex_lock(&ictx->lock);
 
-	if (!ictx->display_supported) {
+	if (ictx->disconnected) {
+		retval = -ENODEV;
+	} else if (!ictx->display_supported) {
 		pr_err("display not supported by device\n");
 		retval = -ENODEV;
 	} else if (ictx->display_isopen) {
@@ -598,6 +600,9 @@ static int send_packet(struct imon_conte
 	int retval = 0;
 	struct usb_ctrlrequest *control_req = NULL;
 
+	if (ictx->disconnected)
+		return -ENODEV;
+
 	/* Check if we need to use control or interrupt urb */
 	if (!ictx->tx_control) {
 		pipe = usb_sndintpipe(ictx->usbdev_intf0,
@@ -949,12 +954,14 @@ static ssize_t vfd_write(struct file *fi
 	static const unsigned char vfd_packet6[] = {
 		0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
 
-	if (ictx->disconnected)
-		return -ENODEV;
-
 	if (mutex_lock_interruptible(&ictx->lock))
 		return -ERESTARTSYS;
 
+	if (ictx->disconnected) {
+		retval = -ENODEV;
+		goto exit;
+	}
+
 	if (!ictx->dev_present_intf0) {
 		pr_err_ratelimited("no iMON device present\n");
 		retval = -ENODEV;
@@ -1029,11 +1036,13 @@ static ssize_t lcd_write(struct file *fi
 	int retval = 0;
 	struct imon_context *ictx = file->private_data;
 
-	if (ictx->disconnected)
-		return -ENODEV;
-
 	mutex_lock(&ictx->lock);
 
+	if (ictx->disconnected) {
+		retval = -ENODEV;
+		goto exit;
+	}
+
 	if (!ictx->display_supported) {
 		pr_err_ratelimited("no iMON display present\n");
 		retval = -ENODEV;
@@ -2499,7 +2508,11 @@ static void imon_disconnect(struct usb_i
 	int ifnum;
 
 	ictx = usb_get_intfdata(interface);
+
+	mutex_lock(&ictx->lock);
 	ictx->disconnected = true;
+	mutex_unlock(&ictx->lock);
+
 	dev = ictx->dev;
 	ifnum = interface->cur_altsetting->desc.bInterfaceNumber;
 


