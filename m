Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF001974FC;
	Thu,  6 Jun 2024 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682947; cv=none; b=BFudlkdT4+OOCenailzC9CRCxTS74XRG23qLLwmYax/YX2asplGvN6i6lz76CKBfjAJ9bBL9+sz/ECP6N0Ks05OQxZ/ENv8knWd1x+pmWaoyxOWPXtIfLGDKyLgtGURc1If4jG+nHhc1dYUAqN7PkPG0VfKQ8h7GiivwRIu0r8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682947; c=relaxed/simple;
	bh=4XqMno6kw2aAbAKIvEWr6WhZv1e1nK2ojH50OTRvI5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSVf7jfCZPZMhDhEkZBpJ++lXFElQ5i4yScm2v1hMPO1Lk1Mv3UJOBZlIr7iGa/cBHaGbEpxw1DjN3T8sCRDp3wcNnUoqFJGSLDqgfpm/6zmBV/891E6XYD/KlFgxlsSAK7kr4UZXNXZFpp96KxPMCxIu7ugteprHB8hUiPFdwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t48EqYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t48EqYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8747C32781;
	Thu,  6 Jun 2024 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682946;
	bh=4XqMno6kw2aAbAKIvEWr6WhZv1e1nK2ojH50OTRvI5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0t48EqYn/hNMBUqZ6aoVSiJ9ZH0NtjthghvBlUmReSRil8cpp5RiKVChP41+ZF7t2
	 RfjPes8x6QxUzDTAcRzBEINPuWlxRSeuUmMi/3BWfOsTjCJlsInlwgwXiS0eqaGjHq
	 yIlpk7n5RQtm66GraCsLQhxfQ41GpIzWlmj73XaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 108/374] f2fs: compress: fix error path of inc_valid_block_count()
Date: Thu,  6 Jun 2024 16:01:27 +0200
Message-ID: <20240606131655.538452494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 043c832371cd9023fbd725138ddc6c7f288dc469 ]

If inc_valid_block_count() can not allocate all requested blocks,
it needs to release block count in .total_valid_block_count and
resevation blocks in inode.

Fixes: 54607494875e ("f2fs: compress: fix to avoid inconsistence bewteen i_blocks and dnode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fced2b7652f40..07b3675ea1694 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2309,7 +2309,7 @@ static inline void f2fs_i_blocks_write(struct inode *, block_t, bool, bool);
 static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 				 struct inode *inode, blkcnt_t *count, bool partial)
 {
-	blkcnt_t diff = 0, release = 0;
+	long long diff = 0, release = 0;
 	block_t avail_user_block_count;
 	int ret;
 
@@ -2329,26 +2329,27 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	percpu_counter_add(&sbi->alloc_valid_block_count, (*count));
 
 	spin_lock(&sbi->stat_lock);
-	sbi->total_valid_block_count += (block_t)(*count);
-	avail_user_block_count = get_available_block_count(sbi, inode, true);
 
-	if (unlikely(sbi->total_valid_block_count > avail_user_block_count)) {
+	avail_user_block_count = get_available_block_count(sbi, inode, true);
+	diff = (long long)sbi->total_valid_block_count + *count -
+						avail_user_block_count;
+	if (unlikely(diff > 0)) {
 		if (!partial) {
 			spin_unlock(&sbi->stat_lock);
+			release = *count;
 			goto enospc;
 		}
-
-		diff = sbi->total_valid_block_count - avail_user_block_count;
 		if (diff > *count)
 			diff = *count;
 		*count -= diff;
 		release = diff;
-		sbi->total_valid_block_count -= diff;
 		if (!*count) {
 			spin_unlock(&sbi->stat_lock);
 			goto enospc;
 		}
 	}
+	sbi->total_valid_block_count += (block_t)(*count);
+
 	spin_unlock(&sbi->stat_lock);
 
 	if (unlikely(release)) {
-- 
2.43.0



