Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065603;
	b=5YA3gH9qZE6fYMRS1NzNS79Kc7M3Hq3xiF8N8qWagbVmQK9/imEf9X0FMoVwpVpFElGv
	 S5IQ8h93czCzbM63q7Wr+elBljyna5iXg56Jqp+Rx+dkYYfnAd1WtlW83dodwOn6mztka
	 P2fyEi94qx/hRGUYoULyZoSFsd/Ss3ZrjTbha/RSgpIiuGSmx7XclN4KiLya4dpHQ1GZj
	 Mgi/U8/cklVTgPAqO6MmDQqaJC3KembtXpZlkJa9uSrg19WjqwV67X85lnGoHmuKg7O0g
	 moeTFi3zauzaVw2LUTGUCO+EOnZmQKbU57GN0gplEHr3rQRmSO/Rdl3yGMyvAiIKTiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwBuojXDfc7LVwgepm2tP/1e5xTMDbKNTJgUgJhg8Wg=;
	b=3T+ev2fgGz1xrQEW82x+u9RQKSc3p+K8rky7Bz3WRHAMQH1fi2VsSkT0SXOr3R/LhxIA
	 Piyb8QS8p2l5aWalX54XjsYLfxhF+nlbvlwZl7C0n30Sx1qmFUO9EGJoYkpKbXaHGXJGK
	 PqUKVdFcGgPPXCDUmUCh+TnC0KbaVI8ZxwdluTGZmXTfeda42wmdz1XGrINuMpQLCQZjR
	 T6sZ0bu0F4BP2AUPXCziJewDeN8ObByUonYAaNiRKWoGNapzQYNgnpg0UKUE3xd+O8kka
	 d5ed3ULW5n7kwbMFsOMVpz2GjI0GBWia6BfupRAKnvUA9AtZsCwS39wOfW60EBjItUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4JxQOfm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90E606A32C;
	Sat,  7 Nov 2026 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4JxQOfm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484A51F008A1;
	Sat,  7 Nov 2026 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065603;
	bh=AwBuojXDfc7LVwgepm2tP/1e5xTMDbKNTJgUgJhg8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4JxQOfmv3t2VyqEfszBwwfasYCHraoYvqIXTvA9Re4t/3jVmyB44QbCOdDiHPY22
	 BXmOr/MwXMvdreQtXL/0gt4URc/5diwCo38STOuCqftuO6vW6IGIV1Yf6VPwYrYezr
	 uq2pVQ+kn9b3qHfia/fbTTTO/8O5jAoWBNcNEP8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1246/1257] backing-file: enforce append-only and immutable backing inodes
Date: Sat,  7 Nov 2026 08:59:02 -0500
Message-ID: <20261107135013.739648775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 19b18e01d0361ce495be153ecce80b581086ab3f ]

FUSE passthrough opens the backing file anew whenever the FUSE file is
opened. fuse_passthrough_open() passes the flags of that open to
backing_file_open() which opens the backing file with vfs_open() and the
credentials of the server. But vfs_open() doesn't go through may_open().
So the backing inode is never checked for S_APPEND and S_IMMUTABLE. The
checks that did run were done on the FUSE inode and that one never has
either flag.

So anyone who may open the FUSE file for writing can overwrite an
append-only backing file anywhere or write to an immutable one. The
server only has to register the file and a read-only or even an O_PATH
file descriptor is enough for that. Registering requires CAP_SYS_ADMIN
but the writer can be any user that the server lets open the file.

The FUSE inode is checked instead of the backing inode in a few more
places:

- do_mmap() refuses a shared mapping of an append-only file that was
  opened for writing. A FUSE file opened with O_RDWR | O_APPEND passes
  the open check and can then be mapped shared and written to at any
  offset.

- fcntl(F_SETFL) and RWF_NOAPPEND refuse to take append mode away from a
  file on an append-only inode. On the FUSE file both succeed. A
  synchronous write still appends because the backing file was opened
  with O_APPEND. But an asynchronous write is submitted with the flags
  of the user's kiocb and lands at the given offset.

Do the checks on the backing inode. backing_file_open() refuses to open
an immutable inode for writing and an append-only inode for writing
without O_APPEND, just like may_open(). backing_file_mmap() refuses a
shared mapping of an append-only inode, just like do_mmap(). And writes
and splices to a backing file in append mode fail if append mode was
taken away from the user file.

A FUSE file that was opened before the backing file became append-only
can still write anywhere. That's what happens on the native filesystem
as well and the backing file of such a file isn't in append mode. Two
differences remain. F_SETFL succeeds and the next write fails. And FUSE
reports EIO for a refused open because it turns every error from opening
the backing file into EIO.

overlayfs uses the same helpers but it mirrors S_APPEND and S_IMMUTABLE
in its own inode and a chattr through the overlay never sets them on the
upper inode. So for overlayfs this only changes something if the upper
inode is changed behind the overlay's back.

Fixes: 4a90451bbc7f ("fuse: implement open in passthrough mode")
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org # v6.9+
Link: https://patch.msgid.link/20261029-work-fs-ai-fixes-v1-2-88f22792f6f7@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/backing-file.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index cc101143f9212..37253f2e3084f 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -36,9 +36,21 @@ struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct cred *cred)
 {
 	const struct path *user_path = file_user_path(user_file);
+	struct inode *real_inode = d_inode(real_path->dentry);
 	struct file *f;
 	int error;
 
+	/*
+	 * may_open() checked the inode of the user file, which need not carry
+	 * S_APPEND and S_IMMUTABLE of the backing inode.
+	 */
+	if ((flags & O_ACCMODE) != O_RDONLY) {
+		if (IS_IMMUTABLE(real_inode))
+			return ERR_PTR(-EPERM);
+		if (IS_APPEND(real_inode) && !(flags & O_APPEND))
+			return ERR_PTR(-EPERM);
+	}
+
 	f = alloc_empty_backing_file(flags, cred, user_file);
 	if (IS_ERR(f))
 		return f;
@@ -263,6 +275,14 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 	if (!iov_iter_count(iter))
 		return 0;
 
+	/*
+	 * F_SETFL and RWF_NOAPPEND can take append mode away from the user
+	 * file. They checked its inode, not the backing one.
+	 */
+	if ((file->f_flags & O_APPEND) && !(flags & IOCB_APPEND) &&
+	    IS_APPEND(file_inode(file)))
+		return -EPERM;
+
 	ret = file_remove_privs(iocb->ki_filp);
 	if (ret)
 		return ret;
@@ -309,6 +329,10 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	if (!out->f_op->splice_write)
 		return -EINVAL;
 
+	/* splice refuses a user file in append mode, so F_SETFL cleared it */
+	if ((out->f_flags & O_APPEND) && IS_APPEND(file_inode(out)))
+		return -EPERM;
+
 	ret = file_remove_privs(iocb->ki_filp);
 	if (ret)
 		return ret;
@@ -338,6 +362,10 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 	if (!can_mmap_file(file))
 		return -ENODEV;
 
+	/* do_mmap() checked the inode of the user file */
+	if ((vma->vm_flags & VM_SHARED) && IS_APPEND(file_inode(file)))
+		return -EACCES;
+
 	vma_set_file(vma, file);
 
 	scoped_with_creds(ctx->cred) {
-- 
2.53.0



