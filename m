Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CB6611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6607BC433D2;
	Sun, 28 May 2023 19:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303432;
	bh=h5aiiAEjyEl1uNNhvlVTcntRTiG83g6Js8kuozyrJd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3yp1NeRNw5aFNILBcTCUmvPRhSy/ith/45g2STWJvB2d+wQm2tyOeCG9hjANUq0B
	 x+smi0TrRzZSr/BKgWC9VgJzSul9x7QA0gibuRTkdpaVkPitkC/QuNfQSgz+4yl9pp
	 4jHxgWGhNB7bnuPX4lXheJuEmbi2LNnOuG+Si+34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+4b3f8190f6e13b3efd74@syzkaller.appspotmail.com
Subject: [PATCH 5.15 34/69] media: radio-shark: Add endpoint checks
Date: Sun, 28 May 2023 20:11:54 +0100
Message-Id: <20230528190829.635285025@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alan Stern <stern@rowland.harvard.edu>

commit 76e31045ba030e94e72105c01b2e98f543d175ac upstream.

The syzbot fuzzer was able to provoke a WARNING from the radio-shark2
driver:

------------[ cut here ]------------
usb 1-1: BOGUS urb xfer, pipe 1 != type 3
WARNING: CPU: 0 PID: 3271 at drivers/usb/core/urb.c:504 usb_submit_urb+0xed2/0x1880 drivers/usb/core/urb.c:504
Modules linked in:
CPU: 0 PID: 3271 Comm: kworker/0:3 Not tainted 6.1.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0xed2/0x1880 drivers/usb/core/urb.c:504
Code: 7c 24 18 e8 00 36 ea fb 48 8b 7c 24 18 e8 36 1c 02 ff 41 89 d8 44 89 e1 4c 89 ea 48 89 c6 48 c7 c7 a0 b6 90 8a e8 9a 29 b8 03 <0f> 0b e9 58 f8 ff ff e8 d2 35 ea fb 48 81 c5 c0 05 00 00 e9 84 f7
RSP: 0018:ffffc90003876dd0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8880750b0040 RSI: ffffffff816152b8 RDI: fffff5200070edac
RBP: ffff8880172d81e0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880285c5040 R14: 0000000000000002 R15: ffff888017158200
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe03235b90 CR3: 000000000bc8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 usb_start_wait_urb+0x101/0x4b0 drivers/usb/core/message.c:58
 usb_bulk_msg+0x226/0x550 drivers/usb/core/message.c:387
 shark_write_reg+0x1ff/0x2e0 drivers/media/radio/radio-shark2.c:88
...

The problem was caused by the fact that the driver does not check
whether the endpoints it uses are actually present and have the
appropriate types.  This can be fixed by adding a simple check of
these endpoints (and similarly for the radio-shark driver).

Link: https://syzkaller.appspot.com/bug?extid=4b3f8190f6e13b3efd74
Reported-and-tested-by: syzbot+4b3f8190f6e13b3efd74@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/e2858ab4-4adf-46e5-bbf6-c56742034547@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/radio/radio-shark.c  |   10 ++++++++++
 drivers/media/radio/radio-shark2.c |   10 ++++++++++
 2 files changed, 20 insertions(+)

--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -316,6 +316,16 @@ static int usb_shark_probe(struct usb_in
 {
 	struct shark_device *shark;
 	int retval = -ENOMEM;
+	static const u8 ep_addresses[] = {
+		SHARK_IN_EP | USB_DIR_IN,
+		SHARK_OUT_EP | USB_DIR_OUT,
+		0};
+
+	/* Are the expected endpoints present? */
+	if (!usb_check_int_endpoints(intf, ep_addresses)) {
+		dev_err(&intf->dev, "Invalid radioSHARK device\n");
+		return -EINVAL;
+	}
 
 	shark = kzalloc(sizeof(struct shark_device), GFP_KERNEL);
 	if (!shark)
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -282,6 +282,16 @@ static int usb_shark_probe(struct usb_in
 {
 	struct shark_device *shark;
 	int retval = -ENOMEM;
+	static const u8 ep_addresses[] = {
+		SHARK_IN_EP | USB_DIR_IN,
+		SHARK_OUT_EP | USB_DIR_OUT,
+		0};
+
+	/* Are the expected endpoints present? */
+	if (!usb_check_int_endpoints(intf, ep_addresses)) {
+		dev_err(&intf->dev, "Invalid radioSHARK2 device\n");
+		return -EINVAL;
+	}
 
 	shark = kzalloc(sizeof(struct shark_device), GFP_KERNEL);
 	if (!shark)


