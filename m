Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A0F13B2B4;
	Tue, 27 Feb 2024 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042848; cv=none; b=aaabOtx6N/xhWRAbQoKWNLM/kprYdo9/NR4Eos+ikz84kJj3ZABMACESk7W9SQzzzswNll/o8mPE2ZQnuumn8/3wruzPoJOSejlJC5scSLSWlvjBRevBJOWrmzuAEGaJSeVwupdmPJw0FI6TIpNeSVinDrbLe80vXondR3z/RgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042848; c=relaxed/simple;
	bh=abQCwja0iB4c2gGxgn8swbcrtpEUbuB+Jm71TgpMe+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKQiu6SN9X/BSZK8BdFD+8mrz/l/8Q2JzrsCrrC4/wgS0aRLUdIXWrVjVxWGzVzOAfSTclCZU6h3cFPhCzDIss2F2wkNpphWXN983tMlzwdL+OPaim1oivHit1fjviPdBX7nCYUeqGZACNfsl+FjiPqmvzcXDw4KTmCGaanQUj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwkj2udy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwkj2udy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C3FC43390;
	Tue, 27 Feb 2024 14:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042847;
	bh=abQCwja0iB4c2gGxgn8swbcrtpEUbuB+Jm71TgpMe+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwkj2udyRCCiltSrtqFG07ov/T2U3U1r7aq1fyVYZhHtILyKX/aElGtiQAl0myuPP
	 AIjlHIf5DSXdL7zDywyF3Q8P4eH3nr6QI2TIRiZN7HNznPim4VruEli+V2T1yaCz7p
	 u8W7hu4nUNuuwCjx8rg4ifZt/RdcrDi8/79xFOis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungki Lee <dominicus79@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/245] f2fs: write checkpoint during FG_GC
Date: Tue, 27 Feb 2024 14:25:30 +0100
Message-ID: <20240227131619.829058930@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Byungki Lee <dominicus79@gmail.com>

[ Upstream commit a9163b947ae8f7af7cb8d63606cd87b9facbfe74 ]

If there's not enough free sections each of which consistis of large segments,
we can hit no free section for upcoming section allocation. Let's reclaim some
prefree segments by writing checkpoints.

Signed-off-by: Byungki Lee <dominicus79@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d016504fad4b9..2c13f308c74e3 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1782,23 +1782,31 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 	if (sync)
 		goto stop;
 
-	if (has_not_enough_free_secs(sbi, sec_freed, 0)) {
-		if (skipped_round <= MAX_SKIP_GC_COUNT ||
-					skipped_round * 2 < round) {
-			segno = NULL_SEGNO;
-			goto gc_more;
-		}
+	if (!has_not_enough_free_secs(sbi, sec_freed, 0))
+		goto stop;
 
-		if (first_skipped < last_skipped &&
-				(last_skipped - first_skipped) >
-						sbi->skipped_gc_rwsem) {
-			f2fs_drop_inmem_pages_all(sbi, true);
-			segno = NULL_SEGNO;
-			goto gc_more;
-		}
-		if (gc_type == FG_GC && !is_sbi_flag_set(sbi, SBI_CP_DISABLED))
+	if (skipped_round <= MAX_SKIP_GC_COUNT || skipped_round * 2 < round) {
+
+		/* Write checkpoint to reclaim prefree segments */
+		if (free_sections(sbi) < NR_CURSEG_PERSIST_TYPE &&
+				prefree_segments(sbi) &&
+				!is_sbi_flag_set(sbi, SBI_CP_DISABLED)) {
 			ret = f2fs_write_checkpoint(sbi, &cpc);
-	}
+			if (ret)
+				goto stop;
+		}
+		segno = NULL_SEGNO;
+		goto gc_more;
+	}
+	if (first_skipped < last_skipped &&
+			(last_skipped - first_skipped) >
+					sbi->skipped_gc_rwsem) {
+		f2fs_drop_inmem_pages_all(sbi, true);
+		segno = NULL_SEGNO;
+		goto gc_more;
+	}
+	if (gc_type == FG_GC && !is_sbi_flag_set(sbi, SBI_CP_DISABLED))
+		ret = f2fs_write_checkpoint(sbi, &cpc);
 stop:
 	SIT_I(sbi)->last_victim[ALLOC_NEXT] = 0;
 	SIT_I(sbi)->last_victim[FLUSH_DEVICE] = init_segno;
-- 
2.43.0



