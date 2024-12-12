Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052213CA93;
	Thu, 12 Dec 2024 17:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024136; cv=none; b=YWBR193iIMEsT8jy72myN3HVIlw46O3fY114Zwq1w+sZHRQKE0LZYSy+wntooL0/Csm0WR3BzPJte8JWaw0IzeZ+UJ8w/w0uJpRUnXF7ksYLO4e3yBQzyTg3UsB6DjCuF0Nw4BKaNzqJ+X2S/LosgSo0WEmKpd5FPlqbu2Cqtq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024136; c=relaxed/simple;
	bh=XI2qEDV3/j+6ECgBx+DNw4fRxZhMXw0Pb5ZlgsyD92M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM9ZsXU1szqQwLHLkhZ+aTpGKGkkwA370vHKrU/D661oqMoNwLA/MZUZD+IZy9R/BrJUxGAlboPAkNhQQmiShlc6wZbgYUynU7vOCEDWSaAYMkHsK30yyLzfF/snMdZtPv+XcrYtA9TnxLo+Frbyh86lnXlsDpexbL3+T3BoYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUd/fild; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUd/fild"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2DBC4CECE;
	Thu, 12 Dec 2024 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024136;
	bh=XI2qEDV3/j+6ECgBx+DNw4fRxZhMXw0Pb5ZlgsyD92M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUd/fildPLgs1sJfE/TflUo69fQV1xcn6e9vS0tf70mAEJykTwXjQr/I2MON0YRDE
	 c14ixTLm45TWE/IKFGLGJFnsP88OtHlCkcnKruIZfefn4SByTBnq+Iiw2+99EEzeNH
	 5iWd1+Sz7lBYaiin8qdHZP0a8EdCmxF6cyoKjhS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/459] f2fs: open code allocate_segment_by_default
Date: Thu, 12 Dec 2024 15:58:56 +0100
Message-ID: <20241212144301.389851845@linuxfoundation.org>
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

[ Upstream commit 8442d94b8ac8d5d8300725a9ffa9def526b71170 ]

allocate_segment_by_default has just two callers, which use very
different code pathes inside it based on the force paramter.  Just
open code the logic in the two callers using a new helper to decided
if a new segment should be allocated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 43563069e1c1 ("f2fs: check curseg->inited before write_sum_page in change_curseg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 50 +++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 82f8a86d7d701..7d6f2ee2f0177 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2876,31 +2876,20 @@ static int get_ssr_segment(struct f2fs_sb_info *sbi, int type,
 	return 0;
 }
 
-/*
- * flush out current segment and replace it with new segment
- * This function should be returned with success, otherwise BUG
- */
-static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
-						int type, bool force)
+static bool need_new_seg(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
 
-	if (force)
-		new_curseg(sbi, type, true);
-	else if (!is_set_ckpt_flags(sbi, CP_CRC_RECOVERY_FLAG) &&
-					curseg->seg_type == CURSEG_WARM_NODE)
-		new_curseg(sbi, type, false);
-	else if (curseg->alloc_type == LFS &&
-			is_next_segment_free(sbi, curseg, type) &&
-			likely(!is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
-		new_curseg(sbi, type, false);
-	else if (f2fs_need_SSR(sbi) &&
-			get_ssr_segment(sbi, type, SSR, 0))
-		change_curseg(sbi, type, true);
-	else
-		new_curseg(sbi, type, false);
-
-	stat_inc_seg_type(sbi, curseg);
+	if (!is_set_ckpt_flags(sbi, CP_CRC_RECOVERY_FLAG) &&
+	    curseg->seg_type == CURSEG_WARM_NODE)
+		return true;
+	if (curseg->alloc_type == LFS &&
+	    is_next_segment_free(sbi, curseg, type) &&
+	    likely(!is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
+		return true;
+	if (!f2fs_need_SSR(sbi) || !get_ssr_segment(sbi, type, SSR, 0))
+		return true;
+	return false;
 }
 
 void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
@@ -2953,7 +2942,8 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 		return;
 alloc:
 	old_segno = curseg->segno;
-	allocate_segment_by_default(sbi, type, true);
+	new_curseg(sbi, type, true);
+	stat_inc_seg_type(sbi, curseg);
 	locate_dirty_segment(sbi, old_segno);
 }
 
@@ -3393,11 +3383,19 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	update_sit_entry(sbi, old_blkaddr, -1);
 
 	if (!__has_curseg_space(sbi, curseg)) {
-		if (from_gc)
+		/*
+		 * Flush out current segment and replace it with new segment.
+		 */
+		if (from_gc) {
 			get_atssr_segment(sbi, type, se->type,
 						AT_SSR, se->mtime);
-		else
-			allocate_segment_by_default(sbi, type, false);
+		} else {
+			if (need_new_seg(sbi, type))
+				new_curseg(sbi, type, false);
+			else
+				change_curseg(sbi, type, true);
+			stat_inc_seg_type(sbi, curseg);
+		}
 	}
 	/*
 	 * segment dirty status should be updated after segment allocation,
-- 
2.43.0



