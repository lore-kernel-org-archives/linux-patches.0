Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92526200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owgvNyoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFA5C433C8;
	Mon,  6 Nov 2023 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276022;
	bh=hXcx/OmnOM81Y0uHMjdFFwbONHGvILY2x3xgmb1sK14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owgvNyoYReTJKXIZMMJQ8gGwVFzcHUTJbuAMr/ixQE4olGrdl/E24QwmUVsXwmB55
	 /h+okMqJZGd9zDPlklmL4JmZHYku5PBOZBb/5m3M6bRCU9LgGTMavcKZ1CSuWRkXTD
	 RQBxJ4l6ADUS9P6kDNzheaoCD3/3SAxbUNoW+wwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	George Kennedy <george.kennedy@oracle.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 42/48] vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF
Date: Mon,  6 Nov 2023 14:03:33 +0100
Message-ID: <20231106130259.293714493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Kennedy <george.kennedy@oracle.com>

commit 226fae124b2dac217ea5436060d623ff3385bc34 upstream.

After a call to console_unlock() in vcs_read() the vc_data struct can be
freed by vc_deallocate(). Because of that, the struct vc_data pointer
load must be done at the top of while loop in vcs_read() to avoid a UAF
when vcs_size() is called.

Syzkaller reported a UAF in vcs_size().

BUG: KASAN: use-after-free in vcs_size (drivers/tty/vt/vc_screen.c:215)
Read of size 4 at addr ffff8881137479a8 by task 4a005ed81e27e65/1537

CPU: 0 PID: 1537 Comm: 4a005ed81e27e65 Not tainted 6.2.0-rc5 #1
Hardware name: Red Hat KVM, BIOS 1.15.0-2.module
Call Trace:
  <TASK>
__asan_report_load4_noabort (mm/kasan/report_generic.c:350)
vcs_size (drivers/tty/vt/vc_screen.c:215)
vcs_read (drivers/tty/vt/vc_screen.c:415)
vfs_read (fs/read_write.c:468 fs/read_write.c:450)
...
  </TASK>

Allocated by task 1191:
...
kmalloc_trace (mm/slab_common.c:1069)
vc_allocate (./include/linux/slab.h:580 ./include/linux/slab.h:720
     drivers/tty/vt/vt.c:1128 drivers/tty/vt/vt.c:1108)
con_install (drivers/tty/vt/vt.c:3383)
tty_init_dev (drivers/tty/tty_io.c:1301 drivers/tty/tty_io.c:1413
     drivers/tty/tty_io.c:1390)
tty_open (drivers/tty/tty_io.c:2080 drivers/tty/tty_io.c:2126)
chrdev_open (fs/char_dev.c:415)
do_dentry_open (fs/open.c:883)
vfs_open (fs/open.c:1014)
...

Freed by task 1548:
...
kfree (mm/slab_common.c:1021)
vc_port_destruct (drivers/tty/vt/vt.c:1094)
tty_port_destructor (drivers/tty/tty_port.c:296)
tty_port_put (drivers/tty/tty_port.c:312)
vt_disallocate_all (drivers/tty/vt/vt_ioctl.c:662 (discriminator 2))
vt_ioctl (drivers/tty/vt/vt_ioctl.c:903)
tty_ioctl (drivers/tty/tty_io.c:2776)
...

The buggy address belongs to the object at ffff888113747800
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 424 bytes inside of
  1024-byte region [ffff888113747800, ffff888113747c00)

The buggy address belongs to the physical page:
page:00000000b3fe6c7c refcount:1 mapcount:0 mapping:0000000000000000
     index:0x0 pfn:0x113740
head:00000000b3fe6c7c order:3 compound_mapcount:0 subpages_mapcount:0
     compound_pincount:0
anon flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
raw: 0017ffffc0010200 ffff888100042dc0 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888113747880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888113747900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888113747980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                   ^
  ffff888113747a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888113747a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
Disabling lock debugging due to kernel taint

Fixes: ac751efa6a0d ("console: rename acquire/release_console_sem() to console_lock/unlock()")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Suggested-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Link: https://lore.kernel.org/r/1674577014-12374-1-git-send-email-george.kennedy@oracle.com
[ 4.14: Adjust context ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -219,10 +219,6 @@ vcs_read(struct file *file, char __user
 	console_lock();
 
 	attr = (currcons & 128);
-	ret = -ENXIO;
-	vc = vcs_vc(inode, &viewed);
-	if (!vc)
-		goto unlock_out;
 
 	ret = -EINVAL;
 	if (pos < 0)
@@ -238,6 +234,11 @@ vcs_read(struct file *file, char __user
 		ssize_t orig_count;
 		long p = pos;
 
+		ret = -ENXIO;
+		vc = vcs_vc(inode, &viewed);
+		if (!vc)
+			goto unlock_out;
+
 		/* Check whether we are above size each round,
 		 * as copy_to_user at the end of this loop
 		 * could sleep.


