Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088CB37FF60;
	Sat, 12 Sep 2026 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218701; cv=none; b=mfEpxF2EsgxB08YPALWMUxsRJlR7gP317FABk7rAbPoOMPnU11JkX441r9jfc4VouffRFiEoJ36QkDX8bD4qLRa1fomry1lTXAYORGu/4QhKq+pqvpR5lqR3CTu3nr/ZGR+bayNWorzKXyFsLs2RSGIzgLoo9J7QSesc0/ewEyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218701; c=relaxed/simple;
	bh=YRckvyxYaI48FXfReNltFn2Ol3vDHSMaM95ECeFpfT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY7xSYh51wyLt0uC6PGgWKnYmT2munAEx6zBPWPU7DwUhAjr9lQDrCT91bjsjUB8i4dJscAkL6UknbBdVYMI711t1FwgvQaEjs04n1bpD371A7pPQzafq+QJDlnCnYxI8jLLrCKrKofGVSrmP34suOZlQ5zUuWrSdt/EiLM4zSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDCMx7zR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDCMx7zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D171F000FF;
	Sat, 12 Sep 2026 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218699;
	bh=O9Dq3Wzf9pEpS4vVL3Jsyk5HrjPxgH71wCVLUUOJn8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDCMx7zRT4RO/w0nqiX8GSOUHi8uMVAfzOPKsL0RHmMAPtXAs0g6IYqP0s/PXXm+P
	 cSM3mhOtz//VSPs/SaM6HvD9spKcXU3dRmyvqIt8PgFlVWp7fgERmv0laEXiCA098K
	 NyeOHOkK+I3bPRl3OuEW0Fkg1RHrICwbUzhztDio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1196/1376] f2fs: fix to parse temperature correctly in f2fs_get_segment_temp()
Date: Sat, 12 Sep 2026 09:00:22 +0200
Message-ID: <20260912065634.205253559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit 9395fb09e897dcd96f601715e63018fc5c69cf03 ]

In __get_segment_type(), __get_segment_type_6() may return
CURSEG_COLD_DATA_PINNED or CURSEG_ALL_DATA_ATGC log type, but
following f2fs_get_segment_temp() can only handle persistent
log type, fix it.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 0a1703eba237 ("f2fs: fix to avoid pinfile fragment on fragment:{block, segment} mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  5 +++--
 fs/f2fs/file.c    |  4 ++--
 fs/f2fs/segment.c | 33 +++++++++++++++++++++++++--------
 fs/f2fs/segment.h |  4 ----
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e1cbd3917b9d9..5b6a19aea806b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1035,7 +1035,7 @@ static inline void set_new_dnode(struct dnode_of_data *dn, struct inode *inode,
 #define NR_CURSEG_PERSIST_TYPE	(NR_CURSEG_DATA_TYPE + NR_CURSEG_NODE_TYPE)
 #define NR_CURSEG_TYPE		(NR_CURSEG_INMEM_TYPE + NR_CURSEG_PERSIST_TYPE)
 
-enum {
+enum log_type {
 	CURSEG_HOT_DATA	= 0,	/* directory entry blocks */
 	CURSEG_WARM_DATA,	/* data blocks */
 	CURSEG_COLD_DATA,	/* multimedia or GCed data blocks */
@@ -3823,7 +3823,8 @@ void f2fs_replace_block(struct f2fs_sb_info *sbi, struct dnode_of_data *dn,
 			block_t old_addr, block_t new_addr,
 			unsigned char version, bool recover_curseg,
 			bool recover_newaddr);
-int f2fs_get_segment_temp(int seg_type);
+enum temp_type f2fs_get_segment_temp(struct f2fs_sb_info *sbi,
+						enum log_type seg_type);
 int f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			block_t old_blkaddr, block_t *new_blkaddr,
 			struct f2fs_summary *sum, int type,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3e95755f6087f..129cdee4149ac 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -5022,8 +5022,8 @@ static void f2fs_dio_write_submit_io(const struct iomap_iter *iter,
 {
 	struct inode *inode = iter->inode;
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	int seg_type = f2fs_rw_hint_to_seg_type(sbi, inode->i_write_hint);
-	enum temp_type temp = f2fs_get_segment_temp(seg_type);
+	enum log_type type = f2fs_rw_hint_to_seg_type(sbi, inode->i_write_hint);
+	enum temp_type temp = f2fs_get_segment_temp(sbi, type);
 
 	bio->bi_write_hint = f2fs_io_type_to_rw_hint(sbi, DATA, temp);
 	submit_bio(bio);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 4e47826b570a5..4a2964de47c80 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3610,18 +3610,35 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 	}
 }
 
-int f2fs_get_segment_temp(int seg_type)
+enum temp_type f2fs_get_segment_temp(struct f2fs_sb_info *sbi,
+						enum log_type type)
 {
-	if (IS_HOT(seg_type))
-		return HOT;
-	else if (IS_WARM(seg_type))
-		return WARM;
-	return COLD;
+	struct curseg_info *curseg = CURSEG_I(sbi, type);
+	enum temp_type temp = COLD;
+
+	switch (curseg->seg_type) {
+	case CURSEG_HOT_NODE:
+	case CURSEG_HOT_DATA:
+		temp = HOT;
+		break;
+	case CURSEG_WARM_NODE:
+	case CURSEG_WARM_DATA:
+		temp = WARM;
+		break;
+	case CURSEG_COLD_NODE:
+	case CURSEG_COLD_DATA:
+		temp = COLD;
+		break;
+	default:
+		f2fs_bug_on(sbi, 1);
+	}
+
+	return temp;
 }
 
 static int __get_segment_type(struct f2fs_io_info *fio)
 {
-	int type = 0;
+	enum log_type type = CURSEG_HOT_DATA;
 
 	switch (F2FS_OPTION(fio->sbi).active_logs) {
 	case 2:
@@ -3637,7 +3654,7 @@ static int __get_segment_type(struct f2fs_io_info *fio)
 		f2fs_bug_on(fio->sbi, true);
 	}
 
-	fio->temp = f2fs_get_segment_temp(type);
+	fio->temp = f2fs_get_segment_temp(fio->sbi, type);
 
 	return type;
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index f8f94301350cf..5e913db63360b 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -32,10 +32,6 @@ static inline void sanity_check_seg_type(struct f2fs_sb_info *sbi,
 	f2fs_bug_on(sbi, seg_type >= NR_PERSISTENT_LOG);
 }
 
-#define IS_HOT(t)	((t) == CURSEG_HOT_NODE || (t) == CURSEG_HOT_DATA)
-#define IS_WARM(t)	((t) == CURSEG_WARM_NODE || (t) == CURSEG_WARM_DATA)
-#define IS_COLD(t)	((t) == CURSEG_COLD_NODE || (t) == CURSEG_COLD_DATA)
-
 #define IS_CURSEG(sbi, seg)						\
 	(((seg) == CURSEG_I(sbi, CURSEG_HOT_DATA)->segno) ||	\
 	 ((seg) == CURSEG_I(sbi, CURSEG_WARM_DATA)->segno) ||	\
-- 
2.53.0



