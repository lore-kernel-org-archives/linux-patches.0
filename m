Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6943C00BF;
	Thu, 15 Jan 2026 17:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499819; cv=none; b=daEFruytlBW3QY5wZlZg/htQMHgAbx1OAklUOX2N0Y7N+quxA5euEGyhC32sKlVuD9Hoz2g68ganKjLxFXDztZY2tpoucAKa9ag9Nnm/NIVmlmt64EzoDr52gAr9MW8cBfm2QV95WFOk3l2f+8zOpFMTKLm3M+5ER+bkLHobwHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499819; c=relaxed/simple;
	bh=406/Y7kub0NSF8x4ngCR9Tlxk6xwMbdlCXoF2Pp0758=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnvLLEyzRqstM1dUP0D4j/V9XTmZp6zEYb5OtzfJ8ft8bc+wfZAJTppaTsaHKURGGstKzLhTXS6RUX0ajynximAxeDWSBoSMDCe8LDQ62ARuub2Ej8f965qENGQYhshwO3oP1iKF7Fjotj0md3au8uwBgp1yNWQouvhxjeWMDxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0tVtA6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0tVtA6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAD9C116D0;
	Thu, 15 Jan 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499819;
	bh=406/Y7kub0NSF8x4ngCR9Tlxk6xwMbdlCXoF2Pp0758=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0tVtA6CoICOVYIb+TH+FUYKd/8En+7+Rf6xmJ2PYTwqn2us7LMU+e/usHtybT86B
	 PIFE4ofnJCi3aCvH08E68YIWEBYfahTehuMyJiZqIpVkqQOw2REs0aTNTOtJI94cA5
	 YB21VNJ4BOyh1CKEWiVPhLHUZbMqr+dQonNCXUcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/451] f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()
Date: Thu, 15 Jan 2026 17:49:21 +0100
Message-ID: <20260115164243.928210270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -328,7 +328,7 @@ static int recover_inode(struct inode *i
 }
 
 static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
-				bool check_only)
+				bool check_only, bool *new_inode)
 {
 	struct curseg_info *curseg;
 	struct page *page = NULL;
@@ -385,6 +385,8 @@ static int find_fsync_dnodes(struct f2fs
 			if (IS_ERR(entry)) {
 				err = PTR_ERR(entry);
 				if (err == -ENOENT) {
+					if (check_only)
+						*new_inode = true;
 					err = 0;
 					goto next;
 				}
@@ -789,6 +791,7 @@ int f2fs_recover_fsync_data(struct f2fs_
 	unsigned long s_flags = sbi->sb->s_flags;
 	bool need_writecp = false;
 	bool fix_curseg_write_pointer = false;
+	bool new_inode = false;
 #ifdef CONFIG_QUOTA
 	int quota_enabled;
 #endif
@@ -813,8 +816,8 @@ int f2fs_recover_fsync_data(struct f2fs_
 	mutex_lock(&sbi->cp_mutex);
 
 	/* step #1: find fsynced inode numbers */
-	err = find_fsync_dnodes(sbi, &inode_list, check_only);
-	if (err || list_empty(&inode_list))
+	err = find_fsync_dnodes(sbi, &inode_list, check_only, &new_inode);
+	if (err < 0 || (list_empty(&inode_list) && (!check_only || !new_inode)))
 		goto skip;
 
 	if (check_only) {


