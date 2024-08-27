Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1B1A072D;
	Tue, 27 Aug 2024 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772347; cv=none; b=PMrfHEtnipazypuv+qLWCoNGDvoQ7jJEw6LyyfXWLU7M7cJyzD9HR1sZc4pVTy4vsMtyVuYBjPYwuUskF+AXU1PyPQEhgxSn47STYFfIEykCfSC5x4Sy/F+faoR7ty5+JupcCjqBMT2PcZ9eHn0xoSKmdZrhXuA+70sWiOuv/WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772347; c=relaxed/simple;
	bh=s2TGYNV4ztuek0xbxTVSuypRca5HkGAWN8e3OsV1wDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4wpnUP3KBbTjxQcTWD5jxBPIgv/GNqVQtOFgVgGVelhqtmqm4hhoJARGNqjDoblb7kPYZ/tE9op4OVH7Kh7TgCgHCEwTied92oUPsFQRlPHr3ZGEr483LZ1xXrAl5MkBNLLcsmizuHj8IUxn1rO6L5UCLA6SvgeXYyB/Vfl4Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctoNl3c+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctoNl3c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3027C6107A;
	Tue, 27 Aug 2024 15:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772347;
	bh=s2TGYNV4ztuek0xbxTVSuypRca5HkGAWN8e3OsV1wDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctoNl3c+8QKtft1jlWh49fanF3bpw+HNhJL1HdzsjqnKFGzHTS1Uueo9HyHNrPWaI
	 iwZJJbQCkJ0OLn9OfZ3Xwl5/X7goYxjCSdCHDItw71FrN8MOkCqRseJ/AXOJ4DVy2j
	 lYLM6cMY2sdoZwwq0mfK3fAqz5tuhSGAmNL9y7io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/321] f2fs: fix to do sanity check in update_sit_entry
Date: Tue, 27 Aug 2024 16:38:15 +0200
Message-ID: <20240827143845.349787237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 36959d18c3cf09b3c12157c6950e18652067de77 ]

If GET_SEGNO return NULL_SEGNO for some unecpected case,
update_sit_entry will access invalid memory address,
cause system crash. It is better to do sanity check about
GET_SEGNO just like update_segment_mtime & locate_dirty_segment.

Also remove some redundant judgment code.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1264a350d4d75..947849e66b0a7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2191,6 +2191,8 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 #endif
 
 	segno = GET_SEGNO(sbi, blkaddr);
+	if (segno == NULL_SEGNO)
+		return;
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
@@ -3286,8 +3288,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	update_sit_entry(sbi, *new_blkaddr, 1);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
-		update_sit_entry(sbi, old_blkaddr, -1);
+	update_sit_entry(sbi, old_blkaddr, -1);
 
 	if (!__has_curseg_space(sbi, curseg)) {
 		if (from_gc)
-- 
2.43.0



