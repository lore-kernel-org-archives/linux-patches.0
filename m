Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D64216E14;
	Thu, 12 Dec 2024 16:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022472; cv=none; b=lBIjecPPKBOeVmIoMdM+T3oVgx53oj59jqEnp2YLVA9udmaIiU9CDWlppchDqMWPThmfpl0sCucG45qUTODqVK3A2wUY8YJCMmZoXE68BvD9vtk9uunAaeTyvyLRJ/7HaTYHMVdasg7GOll/8568dYWGTmJQAMhsXiVByPfdSH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022472; c=relaxed/simple;
	bh=b7N95HF+mJftPkJ9YAUfgh6ltAtM6C/3udkIow/9gK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtdcIOxE5gaVJ35GQkrzKdDPWPRGmNan86/zYa4mY1ePcLHiqwTKI83xtIEbYCZwIWgPIPgbwrrL5MtG7xc/lbsV7dcE0Z0ZZUaXEdx4elcILNw3USPfVcqScXsLfnGTt6KXCiELEb2vURZlCvMINtLbXMZsZjWZnm0kwIwI8Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxZuwQIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxZuwQIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B00C4CED0;
	Thu, 12 Dec 2024 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022472;
	bh=b7N95HF+mJftPkJ9YAUfgh6ltAtM6C/3udkIow/9gK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxZuwQIT1kfk2AcPkOTp/W6MAzC07l+162ljWsQhwwwqTQp38EeTC4TQLSWyaOE/S
	 fan7mNASSW+it+uoM7aRTBfllRcfD7+aasu7F0GYPWcVapLAGNk75qnT4rW7q1igpK
	 0G8nuemUj04Uj4BHLBdbJcSVoduGAQ6d9Aaah1SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/565] f2fs: open code allocate_segment_by_default
Date: Thu, 12 Dec 2024 15:57:24 +0100
Message-ID: <20241212144321.321542899@linuxfoundation.org>
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
index 91c7593965c47..cb37c711b1f61 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2922,31 +2922,20 @@ static int get_ssr_segment(struct f2fs_sb_info *sbi, int type,
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
@@ -2999,7 +2988,8 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 		return;
 alloc:
 	old_segno = curseg->segno;
-	allocate_segment_by_default(sbi, type, true);
+	new_curseg(sbi, type, true);
+	stat_inc_seg_type(sbi, curseg);
 	locate_dirty_segment(sbi, old_segno);
 }
 
@@ -3444,11 +3434,19 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
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



