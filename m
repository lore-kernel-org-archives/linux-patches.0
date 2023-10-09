Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6F71A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N14JFHDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918D3C433C8;
	Mon,  9 Oct 2023 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859290;
	bh=9WzIXwGp5TwX8oZ9+eWiRyGuecpgT8y3AkS87is+ZUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N14JFHDcfGnE7GjSKWFv1Ma31x21cTfWidj02BP8jCxJpr5NSY7WnXuaZbXNBrcrZ
	 TgKHR9By+VnYDvJE4fkV9YI1mtY+hZuyXArPrlHuzYxNNStqBUp44DHujl0SVW/ecm
	 2ZP31pLdV4VgFW1HfTE3JRA4SKenCr4j7KnVgb98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	George Kennedy <george.kennedy@oracle.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 31/55] vc_screen: reload load of struct vc_data pointer in vcs_write() to avoid UAF
Date: Mon,  9 Oct 2023 15:06:30 +0200
Message-ID: <20231009130108.897054428@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Kennedy <george.kennedy@oracle.com>

commit 8fb9ea65c9d1338b0d2bb0a9122dc942cdd32357 upstream.

After a call to console_unlock() in vcs_write() the vc_data struct can be
freed by vc_port_destruct(). Because of that, the struct vc_data pointer
must be reloaded in the while loop in vcs_write() after console_lock() to
avoid a UAF when vcs_size() is called.

Syzkaller reported a UAF in vcs_size().

BUG: KASAN: slab-use-after-free in vcs_size (drivers/tty/vt/vc_screen.c:215)
Read of size 4 at addr ffff8880beab89a8 by task repro_vcs_size/4119

Call Trace:
 <TASK>
__asan_report_load4_noabort (mm/kasan/report_generic.c:380)
vcs_size (drivers/tty/vt/vc_screen.c:215)
vcs_write (drivers/tty/vt/vc_screen.c:664)
vfs_write (fs/read_write.c:582 fs/read_write.c:564)
...
 <TASK>

Allocated by task 1213:
kmalloc_trace (mm/slab_common.c:1064)
vc_allocate (./include/linux/slab.h:559 ./include/linux/slab.h:680
    drivers/tty/vt/vt.c:1078 drivers/tty/vt/vt.c:1058)
con_install (drivers/tty/vt/vt.c:3334)
tty_init_dev (drivers/tty/tty_io.c:1303 drivers/tty/tty_io.c:1415
    drivers/tty/tty_io.c:1392)
tty_open (drivers/tty/tty_io.c:2082 drivers/tty/tty_io.c:2128)
chrdev_open (fs/char_dev.c:415)
do_dentry_open (fs/open.c:921)
vfs_open (fs/open.c:1052)
...

Freed by task 4116:
kfree (mm/slab_common.c:1016)
vc_port_destruct (drivers/tty/vt/vt.c:1044)
tty_port_destructor (drivers/tty/tty_port.c:296)
tty_port_put (drivers/tty/tty_port.c:312)
vt_disallocate_all (drivers/tty/vt/vt_ioctl.c:662 (discriminator 2))
vt_ioctl (drivers/tty/vt/vt_ioctl.c:903)
tty_ioctl (drivers/tty/tty_io.c:2778)
...

The buggy address belongs to the object at ffff8880beab8800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 424 bytes inside of
 freed 1024-byte region [ffff8880beab8800, ffff8880beab8c00)

The buggy address belongs to the physical page:
page:00000000afc77580 refcount:1 mapcount:0 mapping:0000000000000000
    index:0x0 pfn:0xbeab8
head:00000000afc77580 order:3 entire_mapcount:0 nr_pages_mapped:0
    pincount:0
flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
page_type: 0xffffffff()
raw: 000fffffc0010200 ffff888100042dc0 ffffea000426de00 dead000000000002
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880beab8880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880beab8900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880beab8980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff8880beab8a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880beab8a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
Disabling lock debugging due to kernel taint

Fixes: ac751efa6a0d ("console: rename acquire/release_console_sem() to console_lock/unlock()")
Cc: stable <stable@kernel.org>
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/1683889728-10411-1-git-send-email-george.kennedy@oracle.com
[ Adjust context due to missing commit
  71d4abfab322 ("vc_screen: rewrite vcs_size to accept vc, not inode")
  in 4.14.y stable ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -437,10 +437,17 @@ vcs_write(struct file *file, const char
 			}
 		}
 
-		/* The vcs_size might have changed while we slept to grab
-		 * the user buffer, so recheck.
+		/* The vc might have been freed or vcs_size might have changed
+		 * while we slept to grab the user buffer, so recheck.
 		 * Return data written up to now on failure.
 		 */
+		vc = vcs_vc(inode, &viewed);
+		if (!vc) {
+			if (written)
+				break;
+			ret = -ENXIO;
+			goto unlock_out;
+		}
 		size = vcs_size(inode);
 		if (size < 0) {
 			if (written)


