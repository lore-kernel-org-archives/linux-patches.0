Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065BD3D6D;
	Mon, 23 Dec 2024 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970180; cv=none; b=QjgQyWHcz1bu+4PNDwO7cTiRizsTAtCaVyCYbErDE4+yxH04M4L/WoRpVxYawEFL4yibl6vYvI8xDy8zBFShFaMRAptr7rKZe/SfkdRK4udyN7NFS2eKR+fT+bFLGY20fqyF6NaFEWUBLuew1DaPLWeXe0kaLT/cquXXozedBDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970180; c=relaxed/simple;
	bh=0yAvLj9pyxsxv1sk3CT5ljHYywZsjUj9Al+yC1USBuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJbUxQXwz6LJPKX3tpMgpIyA5bU7xMImmjiVxsJkUjAGIFsP1YQnGpzc6401WvdcyrAFK0YQDYg1ResZhLA85+eUsZX65wn3WHfnO5qma2i3dbO+xcm1OvvY6zVabhJeHZFB49NRxEXWDS+Vc9NFn4qGjfHZw1mBrMycfKgkPuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Um43NQDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Um43NQDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C19EC4CED3;
	Mon, 23 Dec 2024 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970179;
	bh=0yAvLj9pyxsxv1sk3CT5ljHYywZsjUj9Al+yC1USBuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Um43NQDvSva1Een2QwmRdCRzExIUY2yboz8/2lNRXmp/Al58r5Os8raPFCicmOR3t
	 G1JBhqiGKCwjI5/v0rCSIQJBs/VWSj+6EZuLytVSWjEnJL5Xga01S7+6BW071kIFzM
	 yi2YAjDGYds+U3WlDb5Fa5hz2BzshaPJgcGynr1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 144/160] nilfs2: prevent use of deleted inode
Date: Mon, 23 Dec 2024 16:59:15 +0100
Message-ID: <20241223155414.364580807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 901ce9705fbb9f330ff1f19600e5daf9770b0175 upstream.

syzbot reported a WARNING in nilfs_rmdir. [1]

Because the inode bitmap is corrupted, an inode with an inode number that
should exist as a ".nilfs" file was reassigned by nilfs_mkdir for "file0",
causing an inode duplication during execution.  And this causes an
underflow of i_nlink in rmdir operations.

The inode is used twice by the same task to unmount and remove directories
".nilfs" and "file0", it trigger warning in nilfs_rmdir.

Avoid to this issue, check i_nlink in nilfs_iget(), if it is 0, it means
that this inode has been deleted, and iput is executed to reclaim it.

[1]
WARNING: CPU: 1 PID: 5824 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
...
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
 vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
 do_rmdir+0x3b5/0x580 fs/namei.c:4453
 __do_sys_rmdir fs/namei.c:4472 [inline]
 __se_sys_rmdir fs/namei.c:4470 [inline]
 __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lkml.kernel.org/r/20241209065759.6781-1-konishi.ryusuke@gmail.com
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9260555647a5132edd48
Tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/inode.c |    8 +++++++-
 fs/nilfs2/namei.c |    5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -579,8 +579,14 @@ struct inode *nilfs_iget(struct super_bl
 	inode = nilfs_iget_locked(sb, root, ino);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
+
+	if (!(inode->i_state & I_NEW)) {
+		if (!inode->i_nlink) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
 		return inode;
+	}
 
 	err = __nilfs_read_inode(sb, root, ino, inode);
 	if (unlikely(err)) {
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -67,6 +67,11 @@ nilfs_lookup(struct inode *dir, struct d
 		inode = NULL;
 	} else {
 		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
+		if (inode == ERR_PTR(-ESTALE)) {
+			nilfs_error(dir->i_sb,
+					"deleted inode referenced: %lu", ino);
+			return ERR_PTR(-EIO);
+		}
 	}
 
 	return d_splice_alias(inode, dentry);


