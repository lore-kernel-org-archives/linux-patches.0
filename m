Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FCD330D47;
	Mon, 29 Dec 2025 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025741; cv=none; b=M8G4qlW4/fw47GAgnmxd5QvNw2Qfulkyc0Ik40H0Ln+2gQfnGCS6Yy93QiwgY5RQ184e+r4dTZ1OJz5AhSlh+1lkICnmsXi+3mIJ71NGLfm5bUaDtX1X5h9+fVLP/JhABCZNsjJGOsKVGud3OMKuZvqRsJhLRzbZgeZi0IypQWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025741; c=relaxed/simple;
	bh=SoTDAScK1aoIKBT+oQ/2pmwEHO8fwzsTEXByDUleAfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAt1T/+fMV9oVreW9pHepdMFBTqPuNwLzqaaTY4pxVGEoyK1sNUGRYMX7mMDbE+RJDDF4za+r7+l7c94NTBN5RoG7Zz/edfsybjEoaATaxdDKbb6Rs18NMG8iZFc36u6cJMlQhBL64+5d4UmSQss8nJq7GVeBS9vPbraLxOjGYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8G79ABQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8G79ABQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF35C4CEF7;
	Mon, 29 Dec 2025 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025741;
	bh=SoTDAScK1aoIKBT+oQ/2pmwEHO8fwzsTEXByDUleAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8G79ABQAGX0hQHLgmT1LAueXHiD6J5/bn+Y/HNNsvKH5X+OJX/fR366CNjWWX0lK
	 CFjobgZjsTEneCTjuO6CDd4vUP6wOtxnNgutOcyFQtj5CzQM5dVI+zs2BIRAJBB/i4
	 e/3kVA4ma4nYxhoZ6ByC9PPUSZUk5wAcQHskRjlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 321/430] f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()
Date: Mon, 29 Dec 2025 17:12:03 +0100
Message-ID: <20251229160736.142550595@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 68d05693f8c031257a0822464366e1c2a239a512 upstream.

mkfs.f2fs -f /dev/vdd
mount /dev/vdd /mnt/f2fs
touch /mnt/f2fs/foo
sync		# avoid CP_UMOUNT_FLAG in last f2fs_checkpoint.ckpt_flags
touch /mnt/f2fs/bar
f2fs_io fsync /mnt/f2fs/bar
f2fs_io shutdown 2 /mnt/f2fs
umount /mnt/f2fs
blockdev --setro /dev/vdd
mount /dev/vdd /mnt/f2fs
mount: /mnt/f2fs: WARNING: source write-protected, mounted read-only.

For the case if we create and fsync a new inode before sudden power-cut,
without norecovery or disable_roll_forward mount option, the following
mount will succeed w/o recovering last fsynced inode.

The problem here is that we only check inode_list list after
find_fsync_dnodes() in f2fs_recover_fsync_data() to find out whether
there is recoverable data in the iamge, but there is a missed case, if
last fsynced inode is not existing in last checkpoint, then, we will
fail to get its inode due to nat of inode node is not existing in last
checkpoint, so the inode won't be linked in inode_list.

Let's detect such case in dyrun mode to fix this issue.

After this change, mount will fail as expected below:
mount: /mnt/f2fs: cannot mount /dev/vdd read-only.
       dmesg(1) may have more information after failed mount system call.
demsg:
F2FS-fs (vdd): Need to recover fsync data, but write access unavailable, please try mount w/ disable_roll_forward or norecovery

Cc: stable@kernel.org
Fixes: 6781eabba1bd ("f2fs: give -EINVAL for norecovery and rw mount")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/recovery.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -399,7 +399,7 @@ static int sanity_check_node_chain(struc
 }
 
 static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
-				bool check_only)
+				bool check_only, bool *new_inode)
 {
 	struct curseg_info *curseg;
 	block_t blkaddr, blkaddr_fast;
@@ -447,16 +447,19 @@ static int find_fsync_dnodes(struct f2fs
 				quota_inode = true;
 			}
 
-			/*
-			 * CP | dnode(F) | inode(DF)
-			 * For this case, we should not give up now.
-			 */
 			entry = add_fsync_inode(sbi, head, ino_of_node(folio),
 								quota_inode);
 			if (IS_ERR(entry)) {
 				err = PTR_ERR(entry);
-				if (err == -ENOENT)
+				/*
+				 * CP | dnode(F) | inode(DF)
+				 * For this case, we should not give up now.
+				 */
+				if (err == -ENOENT) {
+					if (check_only)
+						*new_inode = true;
 					goto next;
+				}
 				f2fs_folio_put(folio, true);
 				break;
 			}
@@ -875,6 +878,7 @@ int f2fs_recover_fsync_data(struct f2fs_
 	int ret = 0;
 	unsigned long s_flags = sbi->sb->s_flags;
 	bool need_writecp = false;
+	bool new_inode = false;
 
 	f2fs_notice(sbi, "f2fs_recover_fsync_data: recovery fsync data, "
 					"check_only: %d", check_only);
@@ -890,8 +894,8 @@ int f2fs_recover_fsync_data(struct f2fs_
 	f2fs_down_write(&sbi->cp_global_sem);
 
 	/* step #1: find fsynced inode numbers */
-	err = find_fsync_dnodes(sbi, &inode_list, check_only);
-	if (err || list_empty(&inode_list))
+	err = find_fsync_dnodes(sbi, &inode_list, check_only, &new_inode);
+	if (err < 0 || (list_empty(&inode_list) && (!check_only || !new_inode)))
 		goto skip;
 
 	if (check_only) {


