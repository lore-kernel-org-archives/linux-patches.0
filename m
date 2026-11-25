Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624029;
	b=BNNdDuRGsL6wOCJFtJf4Eht22BBDfC68wQcMSd7ueI7iu5aVU8T977wGllnqTo01Hwax
	 alvYsVsWSUnuFUIuFM2Vq7EXhDyGRircjF5zCEcabGT4qjqaGiFKjGZTNyS/7p1lUkCjP
	 O33zeR1Y3+OUAqjecgntaCaX+rn+SGie9VvQbsuSPlORl+uSmfMS1EBDi6emyrH0apH8J
	 gxq91/EZIjCBysh49XkcoyhvuyIOk3nU5U9jQyn3Z4TsA2eZa9yot2MpyjEehuvWJdLXq
	 LRrzwq2FicUJqQlYjW48XozVQ6TiC8DHNlyJ3Fb8GzH099CBvg+Kxt4AYqrtXMvFefg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sJfyrjRwJ8CLATEpRhEkAR8YEToOMecv2rnd/gSIW1c=;
	b=VUi3cgMuakmMVJEd8PvFRgI3jwaoHpPdHQLjzAop096Xh7U7uw/2WmaVW5sU629QCS+I
	 +XptZ6KMOky9NHHCin7HRS4FKvdlebCJvGIo3lyImS7TyraiLcN6AbClp0oSzPlW9h31/
	 k70STGOdevvSk9quhcMN06M5Yd8Irdewh1OOQzGMIyvKuKp1iszgS3GxYiLiZFSkuYEZQ
	 rYLdf7vaaNlk3AwXns4YyuHudMEFl0+wSo2nT4CaSf4lNosfUVKC1jD1ECVeUiPT3xeoO
	 z4etv+5PNNqXFhiKCe0Tba/Hi8JrOrjtoqdJTJvvS46xVeFC051QWZxuphky6fKzQIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWtqAZoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0A4606A323;
	Wed, 25 Nov 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWtqAZoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9612D1F000EE;
	Wed, 25 Nov 2026 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624029;
	bh=sJfyrjRwJ8CLATEpRhEkAR8YEToOMecv2rnd/gSIW1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWtqAZoPrCNB7Ld80DG8D3O/vfwdzfF2XjapiUluEXz5tFfqaziXBVUl9aahgpClH
	 xHeX8YVrlmt3Mc5EazRv86GZQ5KhZVMzl83nAZCBYDFcbLKgOQPH9nHVw3SiqBNxgw
	 Qcchu7IKoBum2m0G/V02R9WXd0vlNorz4q9RyDVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/816] 9p: fall back to the normal open path for non-regular files
Date: Wed, 25 Nov 2026 15:26:50 +0100
Message-ID: <20261125143850.656142403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7cb3f4b89dcc3..f0c1805d60c42 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -821,6 +821,16 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
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
 	if (err)
 		goto error;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 40a4fc65a5441..3f916a8d10540 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -317,6 +317,18 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
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



