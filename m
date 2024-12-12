Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19889216E14;
	Thu, 12 Dec 2024 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022469; cv=none; b=pukfok70ZQZMYlSuf9NKrMDkZTFVzTtzwMWKCMAf7rgfU7QRHLt52tOzhIiH9F3reZw0SYzUvwi7OPSAe055M7YYXh4hStu4wappWs2hqeddh4qXwePYUPivywvBK7NTHBiOfNdoaWlrcg+JnXRxp0k3YYQNqKWRp9JSbb4IaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022469; c=relaxed/simple;
	bh=eEYjobiDbq0AAVZxkFPa8ZPD5IHG1WJPjwaPC7hVnfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OARsl8SIagPQ+wPxTEJtRl7XX2TsWmDL/vc5iLIojXBOknX/WB2PGSXFf90iHSH/RmMsRi7gyHpbMMmQn9aZZGwhGmgtHg4WKo1xdCm0CfAZ5u19eP0Nv0vveAanLGYqpEhMCB1DpsM4bWasZ5fxOS+H5R6M+7/W+giVhxI1ZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/+26j4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/+26j4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ABCC4CED3;
	Thu, 12 Dec 2024 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022468;
	bh=eEYjobiDbq0AAVZxkFPa8ZPD5IHG1WJPjwaPC7hVnfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/+26j4M0lv22V56CdY43roc0M6hh/1N2S0z0vhqKmLlKBLAQgdLqWOT+4TU/7hyR
	 eNd/U3aIpibcOpAv79Iy8hqKjUHlNKhxyjm9YLWuHFpmzCsu3FoCN9xCvW4qdotDnL
	 LFLsoLVG+XZ116eAay6rQo3ZY2Y84853bAEVBRFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/565] f2fs: remove struct segment_allocation default_salloc_ops
Date: Thu, 12 Dec 2024 15:57:23 +0100
Message-ID: <20241212144321.282224948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1c8a8ec0a0e9a1176022a35c4daf04fe1594d270 ]

There is only  single instance of these ops, so remove the indirection
and call allocate_segment_by_default directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 43563069e1c1 ("f2fs: check curseg->inited before write_sum_page in change_curseg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 11 ++---------
 fs/f2fs/segment.h |  6 ------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9e6c4a475d6d0..91c7593965c47 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2999,7 +2999,7 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 		return;
 alloc:
 	old_segno = curseg->segno;
-	SIT_I(sbi)->s_ops->allocate_segment(sbi, type, true);
+	allocate_segment_by_default(sbi, type, true);
 	locate_dirty_segment(sbi, old_segno);
 }
 
@@ -3030,10 +3030,6 @@ void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi)
 	up_read(&SM_I(sbi)->curseg_lock);
 }
 
-static const struct segment_allocation default_salloc_ops = {
-	.allocate_segment = allocate_segment_by_default,
-};
-
 bool f2fs_exist_trim_candidates(struct f2fs_sb_info *sbi,
 						struct cp_control *cpc)
 {
@@ -3452,7 +3448,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			get_atssr_segment(sbi, type, se->type,
 						AT_SSR, se->mtime);
 		else
-			sit_i->s_ops->allocate_segment(sbi, type, false);
+			allocate_segment_by_default(sbi, type, false);
 	}
 	/*
 	 * segment dirty status should be updated after segment allocation,
@@ -4434,9 +4430,6 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 		return -ENOMEM;
 #endif
 
-	/* init SIT information */
-	sit_i->s_ops = &default_salloc_ops;
-
 	sit_i->sit_base_addr = le32_to_cpu(raw_super->sit_blkaddr);
 	sit_i->sit_blocks = sit_segs << sbi->log_blocks_per_seg;
 	sit_i->written_valid_blocks = 0;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 2c1165e8f1283..e59b330ed8335 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -225,10 +225,6 @@ struct sec_entry {
 	unsigned int valid_blocks;	/* # of valid blocks in a section */
 };
 
-struct segment_allocation {
-	void (*allocate_segment)(struct f2fs_sb_info *, int, bool);
-};
-
 #define MAX_SKIP_GC_COUNT			16
 
 struct inmem_pages {
@@ -238,8 +234,6 @@ struct inmem_pages {
 };
 
 struct sit_info {
-	const struct segment_allocation *s_ops;
-
 	block_t sit_base_addr;		/* start block address of SIT area */
 	block_t sit_blocks;		/* # of blocks used by SIT area */
 	block_t written_valid_blocks;	/* # of valid blocks in main area */
-- 
2.43.0



