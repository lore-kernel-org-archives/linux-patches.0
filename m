Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA9B2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303B1C433D2;
	Sun, 22 Jan 2023 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401083;
	bh=36VC45yWBlHgCVVtBlxXMVUJpUbHQgJ2EdXDE8T2Yag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XWFbut3kVhaZvO4wNzkgX/drLaWE2fpNxsoW1zQOxTVRK61Slz4jv39SK6Aw/MIw
	 QI2FMaYF07jhW1pAolkpfUOKyoeTme7AYv2z3OyO9HIIFe/EZhtqCP2/nqefKc/9bY
	 YytewOaayMZB8uXK8JUQam2gdwrr/HZ47xyj5nIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+33d7ad66d65044b93f16@syzkaller.appspotmail.com,
	Gerald Lee <sundaywind2004@gmail.com>
Subject: [PATCH 6.1 104/193] USB: gadgetfs: Fix race between mounting and unmounting
Date: Sun, 22 Jan 2023 16:03:53 +0100
Message-Id: <20230122150251.077931039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

commit d18dcfe9860e842f394e37ba01ca9440ab2178f4 upstream.

The syzbot fuzzer and Gerald Lee have identified a use-after-free bug
in the gadgetfs driver, involving processes concurrently mounting and
unmounting the gadgetfs filesystem.  In particular, gadgetfs_fill_super()
can race with gadgetfs_kill_sb(), causing the latter to deallocate
the_device while the former is using it.  The output from KASAN says,
in part:

BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
BUG: KASAN: use-after-free in atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:176 [inline]
BUG: KASAN: use-after-free in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
BUG: KASAN: use-after-free in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
BUG: KASAN: use-after-free in refcount_dec_and_test include/linux/refcount.h:333 [inline]
BUG: KASAN: use-after-free in put_dev drivers/usb/gadget/legacy/inode.c:159 [inline]
BUG: KASAN: use-after-free in gadgetfs_kill_sb+0x33/0x100 drivers/usb/gadget/legacy/inode.c:2086
Write of size 4 at addr ffff8880276d7840 by task syz-executor126/18689

CPU: 0 PID: 18689 Comm: syz-executor126 Not tainted 6.1.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
...
 atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:176 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 put_dev drivers/usb/gadget/legacy/inode.c:159 [inline]
 gadgetfs_kill_sb+0x33/0x100 drivers/usb/gadget/legacy/inode.c:2086
 deactivate_locked_super+0xa7/0xf0 fs/super.c:332
 vfs_get_super fs/super.c:1190 [inline]
 get_tree_single+0xd0/0x160 fs/super.c:1207
 vfs_get_tree+0x88/0x270 fs/super.c:1531
 vfs_fsconfig_locked fs/fsopen.c:232 [inline]

The simplest solution is to ensure that gadgetfs_fill_super() and
gadgetfs_kill_sb() are serialized by making them both acquire a new
mutex.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+33d7ad66d65044b93f16@syzkaller.appspotmail.com
Reported-and-tested-by: Gerald Lee <sundaywind2004@gmail.com>
Link: https://lore.kernel.org/linux-usb/CAO3qeMVzXDP-JU6v1u5Ags6Q-bb35kg3=C6d04DjzA9ffa5x1g@mail.gmail.com/
Fixes: e5d82a7360d1 ("vfs: Convert gadgetfs to use the new mount API")
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Y6XCPXBpn3tmjdCC@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -229,6 +229,7 @@ static void put_ep (struct ep_data *data
  */
 
 static const char *CHIP;
+static DEFINE_MUTEX(sb_mutex);		/* Serialize superblock operations */
 
 /*----------------------------------------------------------------------*/
 
@@ -2010,13 +2011,20 @@ gadgetfs_fill_super (struct super_block
 {
 	struct inode	*inode;
 	struct dev_data	*dev;
+	int		rc;
 
-	if (the_device)
-		return -ESRCH;
+	mutex_lock(&sb_mutex);
+
+	if (the_device) {
+		rc = -ESRCH;
+		goto Done;
+	}
 
 	CHIP = usb_get_gadget_udc_name();
-	if (!CHIP)
-		return -ENODEV;
+	if (!CHIP) {
+		rc = -ENODEV;
+		goto Done;
+	}
 
 	/* superblock */
 	sb->s_blocksize = PAGE_SIZE;
@@ -2053,13 +2061,17 @@ gadgetfs_fill_super (struct super_block
 	 * from binding to a controller.
 	 */
 	the_device = dev;
-	return 0;
+	rc = 0;
+	goto Done;
 
-Enomem:
+ Enomem:
 	kfree(CHIP);
 	CHIP = NULL;
+	rc = -ENOMEM;
 
-	return -ENOMEM;
+ Done:
+	mutex_unlock(&sb_mutex);
+	return rc;
 }
 
 /* "mount -t gadgetfs path /dev/gadget" ends up here */
@@ -2081,6 +2093,7 @@ static int gadgetfs_init_fs_context(stru
 static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
+	mutex_lock(&sb_mutex);
 	kill_litter_super (sb);
 	if (the_device) {
 		put_dev (the_device);
@@ -2088,6 +2101,7 @@ gadgetfs_kill_sb (struct super_block *sb
 	}
 	kfree(CHIP);
 	CHIP = NULL;
+	mutex_unlock(&sb_mutex);
 }
 
 /*----------------------------------------------------------------------*/


