Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9261514F6;
	Mon,  6 Jan 2025 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178200; cv=none; b=GAIdPiAeBcliGLm1zY43vvljv6lnFzop7SaFg8QVV0+pEFDWoSooWUlLE6xy0wG0YQHdt0BNDXFjq3lZZqMBTXXHZUAuY6H34fJc3nmKX3O06Z6FLPmJXahjnWwH2Ero/VR3e62YoWwWgvyUHYU1CS39XfApAub+bhMdTFUy3uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178200; c=relaxed/simple;
	bh=MvDTab2X20FijBt08Rxtiekg+Gdcf391CvJmeicHS+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq4ap8/85RoerKOKBVqhyXlHeiTS0NpKpnzpOBSKx8WvANcuF2BJjXOveg42qc4JL5rVIJ14loUm2P7i0Tv7KthunWkQFea6/Iui8B/8IS91GiBIIotHOR/4GigVZaiSvrA5/fe1kwLrMrw8Ow5UZ/syrKY/Ld+3Rg11nAsw4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9WXxJ8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9WXxJ8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF184C4CED2;
	Mon,  6 Jan 2025 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178200;
	bh=MvDTab2X20FijBt08Rxtiekg+Gdcf391CvJmeicHS+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9WXxJ8eqMe3SmqIZYfHQV2JevAgVwS8TeiDM9AFMBoaZU6JkiLv1m7BPXSs9GbgT
	 Tthj3Jcq6HHfNAz3tlZ+GSxISJd6sAWOp3yrIGsLZNMnSwOP2E//g4vq0XIEo8zvrl
	 wSKulh96SpSmgrDbnpQF59HJZ6H1TL4F5I1DfH+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 038/138] nilfs2: prevent use of deleted inode
Date: Mon,  6 Jan 2025 16:16:02 +0100
Message-ID: <20250106151134.664873767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -618,8 +618,14 @@ struct inode *nilfs_iget(struct super_bl
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


