Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DDA3C4542;
	Sat, 30 May 2026 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165712; cv=none; b=SxqFfrYfs0VSGswbfklU28KfbLSxNnJrS8bYjG2X00PTyCHPkISDu8gVS8H73Of8yrsBsihfF55zsrMZC4986X8iROCqx94qUOIlEUPQCiJDTZpZq0mjFVI6ALbrJmebQHKsD2M0rq6iUEQ6GKsqgnSo8fblTZOzSv84KNZ61mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165712; c=relaxed/simple;
	bh=FyIQw+nVC/SRQbcxBXS2U7a01zOPH7LCfNnW+edCjWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRm1FWa3RzcempwcGdAw0V+wPbyLa9S2Xvth/pzWl9i8OFjjSxPpvASOCayq1j1rphu2/0wdWhcbW8JHzxotAu2af4cTksBdT8qHoxKiuuFMhGmTo+H+RCpdYYSTEpmeuZdlIoquKj2pmKFj7IQ8WLrqXItv0/gdEQRrctj5PZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ef3pO+e3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ef3pO+e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE2D1F00899;
	Sat, 30 May 2026 18:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165711;
	bh=AEK0R/CPkT48G4FVKxZPcDKz2VpWNnzmADb5GyYy4js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ef3pO+e3RG8B11KSkheuEHvlHPDwsXUgk2xdCRmMeG0+y1DSCnVmtRc9GVGM2l4Pm
	 e/kz47qF7Z254aUMOP5Rf0NloNMVq7oWVu+d3C1MOeAU1SIOo7zndzYGUEnRc+2ts1
	 sFqtQwzabrbtAbmbNhjbniYBv1UVrKBZUs7+BKO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 159/589] ext2: reject inodes with zero i_nlink and valid mode in ext2_iget()
Date: Sat, 30 May 2026 18:00:40 +0200
Message-ID: <20260530160228.963765471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit 25947cc5b2374cd5bf627fe3141496444260d04f upstream.

ext2_iget() already rejects inodes with i_nlink == 0 when i_mode is
zero or i_dtime is set, treating them as deleted. However, the case of
i_nlink == 0 with a non-zero mode and zero dtime slips through. Since
ext2 has no orphan list, such a combination can only result from
filesystem corruption - a legitimate inode deletion always sets either
i_dtime or clears i_mode before freeing the inode.

A crafted image can exploit this gap to present such an inode to the
VFS, which then triggers WARN_ON inside drop_nlink() (fs/inode.c) via
ext2_unlink(), ext2_rename() and ext2_rmdir():

WARNING: CPU: 3 PID: 609 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 3 UID: 0 PID: 609 Comm: syz-executor Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_unlink+0x26c/0x300 fs/ext2/namei.c:295
 vfs_unlink+0x2fc/0x9b0 fs/namei.c:4477
 do_unlinkat+0x53e/0x730 fs/namei.c:4541
 __x64_sys_unlink+0xc6/0x110 fs/namei.c:4587
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

WARNING: CPU: 0 PID: 646 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 0 UID: 0 PID: 646 Comm: syz.0.17 Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_rename+0x35e/0x850 fs/ext2/namei.c:374
 vfs_rename+0xf2f/0x2060 fs/namei.c:5021
 do_renameat2+0xbe2/0xd50 fs/namei.c:5178
 __x64_sys_rename+0x7e/0xa0 fs/namei.c:5223
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

WARNING: CPU: 0 PID: 634 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
CPU: 0 UID: 0 PID: 634 Comm: syz-executor Not tainted 6.12.77+ #1
Call Trace:
 <TASK>
 inode_dec_link_count include/linux/fs.h:2518 [inline]
 ext2_rmdir+0xca/0x110 fs/ext2/namei.c:311
 vfs_rmdir+0x204/0x690 fs/namei.c:4348
 do_rmdir+0x372/0x3e0 fs/namei.c:4407
 __x64_sys_unlinkat+0xf0/0x130 fs/namei.c:4577
 do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Extend the existing i_nlink == 0 check to also catch this case,
reporting the corruption via ext2_error() and returning -EFSCORRUPTED.
This rejects the inode at load time and prevents it from reaching any
of the namei.c paths.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20260404152011.2590197-1-kovalev@altlinux.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/inode.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1443,9 +1443,17 @@ struct inode *ext2_iget (struct super_bl
 	 * the test is that same one that e2fsck uses
 	 * NeilBrown 1999oct15
 	 */
-	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ei->i_dtime)) {
-		/* this inode is deleted */
-		ret = -ESTALE;
+	if (inode->i_nlink == 0) {
+		if (inode->i_mode == 0 || ei->i_dtime) {
+			/* this inode is deleted */
+			ret = -ESTALE;
+		} else {
+			ext2_error(sb, __func__,
+				   "inode %lu has zero i_nlink with mode 0%o and no dtime, "
+				   "filesystem may be corrupt",
+				   ino, inode->i_mode);
+			ret = -EFSCORRUPTED;
+		}
 		goto bad_inode;
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);


