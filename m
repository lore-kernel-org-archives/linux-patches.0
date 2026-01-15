Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4936C3AA1A8;
	Thu, 15 Jan 2026 17:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498465; cv=none; b=VoR/PwiQ4f26q37rZ+mh0Ynnw72krWUyIk6uzziuQGVD5MNyE6U/g4zbRPPdfEKD+oW5jLs+xCQbG1MVSj8/xNUA1Ug5Z3YmZxs8QqQbk0X7GSGITvHMZwbAtm29Gh2ISD1nXzdxfP3AStqnc4FmaAiebKbp/vbh5CMIIdH1YkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498465; c=relaxed/simple;
	bh=y31KjVAwaDhT675RqBEPNAtXVNNy9YwPtd4MA8eHMTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ+jhgU6GxMIUo9zoTPn+cY5Hk5YbcoH/23UWoVmVvvtcGS3OSwuJPT5A8zyjAKzy35pY85kFj+DWOByPhWG4/QvlosP4i0DiqcVXwfKsmc5Y+4EHTN2PEJsQ/EszzJc6Dld3BlluwW+S0xaElAb98fff00eh/429Qn9b1jsuI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM8VFv6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM8VFv6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75F9C116D0;
	Thu, 15 Jan 2026 17:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498465;
	bh=y31KjVAwaDhT675RqBEPNAtXVNNy9YwPtd4MA8eHMTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tM8VFv6tMprgo5BodMKnzYiYfP56HdJQKIYZjjzGXlQ1kR9/LADyertkbbTOSj6J/
	 bShW3gYe0TWrveBaPwdFr7D23Y3dAWMD0Q3sBCxGNg+5fVyAtL8ZqIiiwpUEFaX1fK
	 XmfWCXT2McZXsxwxfjNB5CVhyZb1fpop3fxo5LLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/554] f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()
Date: Thu, 15 Jan 2026 17:48:27 +0100
Message-ID: <20260115164302.228804133@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 68d05693f8c031257a0822464366e1c2a239a512 ]

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
[ folio => page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/recovery.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -343,7 +343,7 @@ static int recover_inode(struct inode *i
 }
 
 static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
-				bool check_only)
+				bool check_only, bool *new_inode)
 {
 	struct curseg_info *curseg;
 	struct page *page = NULL;
@@ -400,6 +400,8 @@ static int find_fsync_dnodes(struct f2fs
 			if (IS_ERR(entry)) {
 				err = PTR_ERR(entry);
 				if (err == -ENOENT) {
+					if (check_only)
+						*new_inode = true;
 					err = 0;
 					goto next;
 				}
@@ -805,6 +807,7 @@ int f2fs_recover_fsync_data(struct f2fs_
 	unsigned long s_flags = sbi->sb->s_flags;
 	bool need_writecp = false;
 	bool fix_curseg_write_pointer = false;
+	bool new_inode = false;
 #ifdef CONFIG_QUOTA
 	int quota_enabled;
 #endif
@@ -829,8 +832,8 @@ int f2fs_recover_fsync_data(struct f2fs_
 	down_write(&sbi->cp_global_sem);
 
 	/* step #1: find fsynced inode numbers */
-	err = find_fsync_dnodes(sbi, &inode_list, check_only);
-	if (err || list_empty(&inode_list))
+	err = find_fsync_dnodes(sbi, &inode_list, check_only, &new_inode);
+	if (err < 0 || (list_empty(&inode_list) && (!check_only || !new_inode)))
 		goto skip;
 
 	if (check_only) {


