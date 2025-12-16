Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E5B341AB8;
	Tue, 16 Dec 2025 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884786; cv=none; b=RpbObwzOolfAyz92SqxrD93AaZpAsf7FDg8Kil2xnBliaOUedivx5tjUaq29lmBkLgY68jGJ+gFqpCesG0MLCmJUHSNg434NnS3nX4D9dDqfCY3uk3TUByOu3s0mZAuWL2KXyt5fQy4Vq1dE1I5d2fyifcoZjW4nV9byEy59Nn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884786; c=relaxed/simple;
	bh=bY0wXpbjzTRYHVk9MRUi6GGskesI2nTZkVLwL5N/ibo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJPy8enKNx2jT9yUtpiqJS8ERkty/A9EMFHuB5xE6HKoozQfHfo5KV791MyNa28Pk/WL6RZbhyJh6u6c8Tg5y2HHLuBK2694HS3Ig2a51SKwvLmSGNzHP9bo/H0UVI1goXIQHo4X3iU9ErDhzt71Hij4jN2KfZ/fijveEVKBDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X66HTMw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X66HTMw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E93C4CEF1;
	Tue, 16 Dec 2025 11:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884786;
	bh=bY0wXpbjzTRYHVk9MRUi6GGskesI2nTZkVLwL5N/ibo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X66HTMw5/+KHEJp7SFQTuu9IRs69cqVzjuo4klW13ke/6y15H8jkKLXs/KU8ArJ+U
	 G94ygBEEil0s1Mjru7K1mdjblxZa33enn/bNlySSD/FmUHTHlFD69APEsimt+TX0mL
	 NTech4V5CdipAsXqyHx+rto1rryRX/tx1CDDFTWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	wangzijie <wangzijie1@honor.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/354] f2fs: introduce reserved_pin_section sysfs entry
Date: Tue, 16 Dec 2025 12:14:25 +0100
Message-ID: <20251216111331.707828968@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 59c1c89e9ba8cefff05aa982dd9e6719f25e8ec5 ]

This patch introduces /sys/fs/f2fs/<dev>/reserved_pin_section for tuning
@needed parameter of has_not_enough_free_secs(), if we configure it w/
zero, it can avoid f2fs_gc() as much as possible while fallocating on
pinned file.

Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: wangzijie <wangzijie1@honor.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e462fc48ceb8 ("f2fs: maintain one time GC mode is enabled during whole zoned GC cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 9 +++++++++
 fs/f2fs/f2fs.h                          | 3 +++
 fs/f2fs/file.c                          | 5 ++---
 fs/f2fs/super.c                         | 4 ++++
 fs/f2fs/sysfs.c                         | 9 +++++++++
 5 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 87b32ca7f3a46..ade7da6352de6 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -858,3 +858,12 @@ Description:	This is a read-only entry to show the value of sb.s_encoding_flags,
 		SB_ENC_STRICT_MODE_FL            0x00000001
 		SB_ENC_NO_COMPAT_FALLBACK_FL     0x00000002
 		============================     ==========
+
+What:		/sys/fs/f2fs/<disk>/reserved_pin_section
+Date:		June 2025
+Contact:	"Chao Yu" <chao@kernel.org>
+Description:	This threshold is used to control triggering garbage collection while
+		fallocating on pinned file, so, it can guarantee there is enough free
+		reserved section before preallocating on pinned file.
+		By default, the value is ovp_sections, especially, for zoned ufs, the
+		value is 1.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 08bab3de5c50d..695f74875b8f1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1702,6 +1702,9 @@ struct f2fs_sb_info {
 	/* for skip statistic */
 	unsigned long long skipped_gc_rwsem;		/* FG_GC only */
 
+	/* free sections reserved for pinned file */
+	unsigned int reserved_pin_section;
+
 	/* threshold for gc trials on pinned files */
 	unsigned short gc_pin_file_threshold;
 	struct f2fs_rwsem pin_sem;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index be32f672497d6..67053bf6ca3ec 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1850,9 +1850,8 @@ static int f2fs_expand_inode_data(struct inode *inode, loff_t offset,
 			}
 		}
 
-		if (has_not_enough_free_secs(sbi, 0, f2fs_sb_has_blkzoned(sbi) ?
-			ZONED_PIN_SEC_REQUIRED_COUNT :
-			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
+		if (has_not_enough_free_secs(sbi, 0,
+				sbi->reserved_pin_section)) {
 			f2fs_down_write(&sbi->gc_lock);
 			stat_inc_gc_call_count(sbi, FOREGROUND);
 			err = f2fs_gc(sbi, &gc_control);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ee8352246ce47..ae72639544040 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4705,6 +4705,10 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* get segno of first zoned block device */
 	sbi->first_seq_zone_segno = get_first_seq_zone_segno(sbi);
 
+	sbi->reserved_pin_section = f2fs_sb_has_blkzoned(sbi) ?
+			ZONED_PIN_SEC_REQUIRED_COUNT :
+			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi));
+
 	/* Read accumulated write IO statistics if exists */
 	seg_i = CURSEG_I(sbi, CURSEG_HOT_NODE);
 	if (__exist_node_summaries(sbi))
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 309b73421dd92..624ce79f08fd2 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -847,6 +847,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "reserved_pin_section")) {
+		if (t > GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 	*ui = (unsigned int)t;
 
 	return count;
@@ -1153,6 +1160,7 @@ F2FS_SBI_GENERAL_RO_ATTR(unusable_blocks_per_sec);
 F2FS_SBI_GENERAL_RW_ATTR(blkzone_alloc_policy);
 #endif
 F2FS_SBI_GENERAL_RW_ATTR(carve_out);
+F2FS_SBI_GENERAL_RW_ATTR(reserved_pin_section);
 
 /* STAT_INFO ATTR */
 #ifdef CONFIG_F2FS_STAT_FS
@@ -1343,6 +1351,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(last_age_weight),
 	ATTR_LIST(max_read_extent_count),
 	ATTR_LIST(carve_out),
+	ATTR_LIST(reserved_pin_section),
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs);
-- 
2.51.0



