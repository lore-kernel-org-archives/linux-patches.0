Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5B413CA93;
	Thu, 12 Dec 2024 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024130; cv=none; b=ZfdT3XcxAvbBLKZGIh0g/59SVgYD0rF0eaUzC3zNvcVsc3oBwxou7Fz5VlRjwY4Poki57SmK6//PH4Y+2IN+pR9GN6/NP9px+XjUwcEw7VktfwOcUxdX1ayfO8PIx6MC+zvTe/v3UB0zZbEJpWkcGGOXbBvaHYpiA3GYCqCYdLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024130; c=relaxed/simple;
	bh=OS7nIoeu/ppbyszEVi7l3HFPUYLzeURGM7wEhYXj2TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZUBZvGqbdwnX+ygwZjPY+yQrnhhsXNZBgmxCzFGDILXc5QlNep8Umki8mGN6CoEzSeYi0c38cc8RgIZOWWopvQrra4luXDfazv8p0nL6L0JDfU+cGPRoSAky3UYAEi5RNR+lbzegP5S0MnXmO4fniCUlO3BjuCpoT717eUNmes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNOyrx24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNOyrx24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984E2C4CECE;
	Thu, 12 Dec 2024 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024130;
	bh=OS7nIoeu/ppbyszEVi7l3HFPUYLzeURGM7wEhYXj2TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNOyrx24Q9bxkDHeBjcLopxUbN02tl/WpWiU3Ui0HcSDQudTYHvMKAP/4BbGBgXCz
	 XJ3gpNFMfVK0HjlwYvV8oprc6VFXgqcOZRqXwwzbSf83Cj+MFZ2LQd8Pq1zF0XMnVr
	 q4P3f7aCUDPhnJwL/ycoR+9ydb51DfgYz0KcBFIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/459] f2fs: avoid using native allocate_segment_by_default()
Date: Thu, 12 Dec 2024 15:58:54 +0100
Message-ID: <20241212144301.311628280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 509f1010e4fc55e2dbfc036317afd573ccd0931c ]

As we did for other cases, in fix_curseg_write_pointer(), let's
use wrapped f2fs_allocate_new_section() instead of native
allocate_segment_by_default(), by this way, it fixes to cover
segment allocation with curseg_lock and sentry_lock.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 43563069e1c1 ("f2fs: check curseg->inited before write_sum_page in change_curseg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/file.c    |  2 +-
 fs/f2fs/segment.c | 18 ++++++++++--------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 3da7be53a3de4..10231d5bba159 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3366,7 +3366,7 @@ void f2fs_get_new_segment(struct f2fs_sb_info *sbi,
 			unsigned int *newseg, bool new_sec, int dir);
 void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
 					unsigned int start, unsigned int end);
-void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type);
+void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type, bool force);
 void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi);
 int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range);
 bool f2fs_exist_trim_candidates(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7ce22137afbe9..9ecf39c2b47d9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1689,7 +1689,7 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 		down_write(&sbi->pin_sem);
 
 		f2fs_lock_op(sbi);
-		f2fs_allocate_new_section(sbi, CURSEG_COLD_DATA_PINNED);
+		f2fs_allocate_new_section(sbi, CURSEG_COLD_DATA_PINNED, false);
 		f2fs_unlock_op(sbi);
 
 		map.m_seg_type = CURSEG_COLD_DATA_PINNED;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a37f88cc7c485..d2aad633529eb 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2937,7 +2937,7 @@ void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
 }
 
 static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
-								bool new_sec)
+						bool new_sec, bool force)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
 	unsigned int old_segno;
@@ -2945,7 +2945,7 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 	if (!curseg->inited)
 		goto alloc;
 
-	if (curseg->next_blkoff ||
+	if (force || curseg->next_blkoff ||
 		get_valid_blocks(sbi, curseg->segno, new_sec))
 		goto alloc;
 
@@ -2957,16 +2957,17 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 	locate_dirty_segment(sbi, old_segno);
 }
 
-static void __allocate_new_section(struct f2fs_sb_info *sbi, int type)
+static void __allocate_new_section(struct f2fs_sb_info *sbi,
+						int type, bool force)
 {
-	__allocate_new_segment(sbi, type, true);
+	__allocate_new_segment(sbi, type, true, force);
 }
 
-void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type)
+void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type, bool force)
 {
 	down_read(&SM_I(sbi)->curseg_lock);
 	down_write(&SIT_I(sbi)->sentry_lock);
-	__allocate_new_section(sbi, type);
+	__allocate_new_section(sbi, type, force);
 	up_write(&SIT_I(sbi)->sentry_lock);
 	up_read(&SM_I(sbi)->curseg_lock);
 }
@@ -2978,7 +2979,7 @@ void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi)
 	down_read(&SM_I(sbi)->curseg_lock);
 	down_write(&SIT_I(sbi)->sentry_lock);
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++)
-		__allocate_new_segment(sbi, i, false);
+		__allocate_new_segment(sbi, i, false, false);
 	up_write(&SIT_I(sbi)->sentry_lock);
 	up_read(&SM_I(sbi)->curseg_lock);
 }
@@ -4867,7 +4868,8 @@ static int fix_curseg_write_pointer(struct f2fs_sb_info *sbi, int type)
 
 	f2fs_notice(sbi, "Assign new section to curseg[%d]: "
 		    "curseg[0x%x,0x%x]", type, cs->segno, cs->next_blkoff);
-	allocate_segment_by_default(sbi, type, true);
+
+	f2fs_allocate_new_section(sbi, type, true);
 
 	/* check consistency of the zone curseg pointed to */
 	if (check_zone_write_pointer(sbi, zbd, &zone))
-- 
2.43.0



