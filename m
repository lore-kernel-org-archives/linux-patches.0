Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F389B176AA1;
	Thu, 12 Dec 2024 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024133; cv=none; b=suRH5g2lWvWVBFYNWpjDp6LPWl7gyValgH6eoGfPw6kQY+CWOyTbi/f6vJziQoVBYejhsPMulCEhE34X5wSt8vwoRIZ8v8loDRdW7/ZBS0RS6of99AH3zNhChW4g3wI+m7sJtELO92b7/bNwinyuMmQn1kZaia+wqeQwQTTCBfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024133; c=relaxed/simple;
	bh=Kn1/IU91qTG6sLE3Zb06fy9ThfWYDdJS6hJ0lTiwaYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsURgN2hlh2Dpg9qrV5vH1xpbJ6ByVuVWwjg8w2KIbu0woCLyPmi0nSDWE1uzphliCMkksgzT2OrSLzo+1sNUoJd7BbmYrdZ9jdSc1waH6hFiU5WCY4wsNTpSg5cUUcsOXzpZ65iG86UaXV7sfDvUuZQF0oC0xb4opRhNEfP2oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih1KnGqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih1KnGqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A053C4CECE;
	Thu, 12 Dec 2024 17:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024132;
	bh=Kn1/IU91qTG6sLE3Zb06fy9ThfWYDdJS6hJ0lTiwaYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih1KnGqt2EHeUrsGy6fJHsHAxW0eX1mK/06ue1ols6ZAjsKz2KY6TsSC4MpONIgGs
	 8h5GwQhHeGhGEJh0QQzyov2teMu2U4r0E98fQlfw564MKElfpozJPlUX46sZBnyj/1
	 n7PGsIoeWT1YCIBxEjEwLWkGGZVgXzifUnQuhLqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/459] f2fs: remove struct segment_allocation default_salloc_ops
Date: Thu, 12 Dec 2024 15:58:55 +0100
Message-ID: <20241212144301.351493198@linuxfoundation.org>
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
index d2aad633529eb..82f8a86d7d701 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2953,7 +2953,7 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 		return;
 alloc:
 	old_segno = curseg->segno;
-	SIT_I(sbi)->s_ops->allocate_segment(sbi, type, true);
+	allocate_segment_by_default(sbi, type, true);
 	locate_dirty_segment(sbi, old_segno);
 }
 
@@ -2984,10 +2984,6 @@ void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi)
 	up_read(&SM_I(sbi)->curseg_lock);
 }
 
-static const struct segment_allocation default_salloc_ops = {
-	.allocate_segment = allocate_segment_by_default,
-};
-
 bool f2fs_exist_trim_candidates(struct f2fs_sb_info *sbi,
 						struct cp_control *cpc)
 {
@@ -3401,7 +3397,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			get_atssr_segment(sbi, type, se->type,
 						AT_SSR, se->mtime);
 		else
-			sit_i->s_ops->allocate_segment(sbi, type, false);
+			allocate_segment_by_default(sbi, type, false);
 	}
 	/*
 	 * segment dirty status should be updated after segment allocation,
@@ -4337,9 +4333,6 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 		return -ENOMEM;
 #endif
 
-	/* init SIT information */
-	sit_i->s_ops = &default_salloc_ops;
-
 	sit_i->sit_base_addr = le32_to_cpu(raw_super->sit_blkaddr);
 	sit_i->sit_blocks = sit_segs << sbi->log_blocks_per_seg;
 	sit_i->written_valid_blocks = 0;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 665e0e186687d..720951ce2f9d1 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -227,10 +227,6 @@ struct sec_entry {
 	unsigned int valid_blocks;	/* # of valid blocks in a section */
 };
 
-struct segment_allocation {
-	void (*allocate_segment)(struct f2fs_sb_info *, int, bool);
-};
-
 #define MAX_SKIP_GC_COUNT			16
 
 struct inmem_pages {
@@ -240,8 +236,6 @@ struct inmem_pages {
 };
 
 struct sit_info {
-	const struct segment_allocation *s_ops;
-
 	block_t sit_base_addr;		/* start block address of SIT area */
 	block_t sit_blocks;		/* # of blocks used by SIT area */
 	block_t written_valid_blocks;	/* # of valid blocks in main area */
-- 
2.43.0



