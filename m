Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620968;
	b=ubtHd3x1iSsY16eWhLSlzh1/yJgyd2rVcSHjP3vsNDnlMU/3B/FSzk63CMqZZcCS/3Gk
	 UOI8UUS6AOdogTDtcS/H0Wgry3C/Vr0joyZTtBLoZUm3IaA1Iu8wgmZkgFqHDTPTWRT84
	 v+dHeZUIqvo0exvD+HE5g9l4gO5obcvjjG+iBZfYt41L19qCxe/StKbTuoMURw+GNVqws
	 K6oHSwZuzQCUx/Dn1D2sEgddh1Z0HrUIfMSv0ZujEPYqz9HuDN3rPa/HK2xsj7BLlgZPS
	 6bslhQrhqRej/0hjhlnfWPiIj7z7PF02Nz+C/iH8dAFrK3YjeUUReRPAPFSecF5rXbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kY1IhUau8r6sJhOhhHuTPkAky1lHHX6U2J2IyQcBUPY=;
	b=CgGRvHqNVnIF6sUo+0dKBThUsimkk1JosCNg95ctst8Dk++sZLUQA8sdlZLZIuVyT/uU
	 KQKUVwaQv++pmSECF8klji6MbeBTPAa5xHnK7WvahzQ/U5HJHkwcDNvXVv+aJMmpVsYSF
	 baJOVWDjhQWFpcOlPiXfiSOQ549uwQnvGYhpDV9wZ6QDV4P902+py8kTgrWVipoTaGvQV
	 g0xkcytuQcleh5fsOYzV3Pi3KZr40FWNgnd4sBehiO/xJ0wYiutvaubL0qeIpLhLD+0kx
	 X/ZUDrfUe39NNgRfgMlA0wv7v4XwaQAWEb4HIsfA/sQ0Td8HUFMZ+N4yBJ1HLvdv1mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOo8g9lS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D78606A6B0;
	Wed, 25 Nov 2026 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOo8g9lS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EFB1F000F0;
	Wed, 25 Nov 2026 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620967;
	bh=kY1IhUau8r6sJhOhhHuTPkAky1lHHX6U2J2IyQcBUPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOo8g9lS5F5KHnMPCgXCU4FGFD+wGaNeO2R5idXFj5OGf0pi8qFJY+66cofkSSf/G
	 CGv+OThZ7p3hC18h4STbh8ZBuYXQKYGwKD5fl2iVNrqQB6tPvZBR7Vk9blKoi3j0Se
	 7LKexc1uWafo9DojGuuSHRNkq9lDuMtG1VF8zyBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/990] 9p: fall back to the normal open path for non-regular files
Date: Wed, 25 Nov 2026 15:24:07 +0100
Message-ID: <20261125143823.962569675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>

[ Upstream commit ff1baa01a6e1f24741f7428119e6f3a61b995604 ]

v9fs_vfs_atomic_open() and v9fs_vfs_atomic_open_dotl() call
finish_open(file, dentry, generic_file_open) regardless of the file
type the server reported for the created dentry.  The supplied
callback replaces f_op->open in do_dentry_open(), so blkdev_open()
never runs for a server-reported device node: an open() with O_CREAT
succeeds with f_op = def_blk_fops while f_mapping still points at the
9p inode, because the bdev mapping swap only happens inside
blkdev_open().  The block file methods then derive their block_device
from that inode with I_BDEV(); the loads land at the tail of a
656-byte v9fs_inode_cache object (offsets +624 and +632), which KASAN
reports as slab-out-of-bounds, and the garbage they read is then
dereferenced, so the first read(), write(), ioctl() or close() ends
in a NULL pointer write and a panic.  In the ioctl(BLKGETSIZE64)
variant the value read this way is returned to userspace.

The server controls the file type reported for the create, so a
malicious server can crash the client this way.  KASAN report of the
read() variant, on a build of linux-stable 2709dd5ae32f:

BUG: KASAN: slab-out-of-bounds in blkdev_read_iter+0x3cd/0x440
Read of size 8 at addr ffff88800828ceb0 by task repro/1

Call Trace:
 <TASK>
 dump_stack_lvl+0x7b/0xa0
 print_report+0xd0/0x630
 kasan_report+0xe5/0x120
 blkdev_read_iter+0x3cd/0x440
 vfs_read+0x718/0xa50
 ksys_read+0x10f/0x200
 do_syscall_64+0xdd/0x4a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The buggy address belongs to the object at ffff88800828cc40
 which belongs to the cache v9fs_inode_cache of size 656
The buggy address is located 624 bytes inside of
 allocated 656-byte region [ffff88800828cc40, ffff88800828ced0)

A plain open() without O_CREAT is not affected: it runs blkdev_open()
and either maps the device correctly or fails with -ENXIO for an rdev
with no registered device.  When the created inode is not a regular
file, clunk the fid the create opened.  The unopened fid is already
on the dentry.  Set FMODE_CREATED and return finish_no_open(file, NULL)
so the VFS keeps its dentry reference and calls the inode's ->open.
Regular files still use finish_open() with generic_file_open.

Fixes: be12af3ef5e6 ("getting rid of 'opened' argument of ->atomic_open() - part 1")
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Message-ID: <908FC420-EC1F-46FC-8526-698F646961A8@stu.pku.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c      | 10 ++++++++++
 fs/9p/vfs_inode_dotl.c | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 11fbb8686b87d..32a2b45743f03 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -811,6 +811,16 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	v9fs_invalidate_inode_attr(dir);
 	inode = d_inode(dentry);
 	v9inode = V9FS_I(inode);
+	if (!S_ISREG(inode->i_mode)) {
+		/*
+		 * Not a regular file.  v9fs_create() already stored the
+		 * unopened fid on the dentry.  Clunk the opened fid from
+		 * the create and let the VFS call ->open.
+		 */
+		p9_fid_put(fid);
+		file->f_mode |= FMODE_CREATED;
+		return finish_no_open(file, NULL);
+	}
 	err = finish_open(file, dentry, generic_file_open);
 	if (unlikely(err)) {
 		p9_fid_put(fid);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 72aca3106d76f..f154b7a45d4f9 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -313,6 +313,18 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	v9fs_fid_add(dentry, &fid);
 	d_instantiate(dentry, inode);
 
+	if (!S_ISREG(inode->i_mode)) {
+		/*
+		 * Not a regular file.  The unopened fid is already on the
+		 * dentry.  Clunk the opened create fid and let the VFS call
+		 * ->open.
+		 */
+		p9_fid_put(ofid);
+		ofid = NULL;
+		file->f_mode |= FMODE_CREATED;
+		err = finish_no_open(file, NULL);
+		goto out;
+	}
 	/* Since we are opening a file, assign the open fid to the file */
 	err = finish_open(file, dentry, generic_file_open);
 	if (err)
-- 
2.53.0



