Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFED61EB5B;
	Sun,  1 Sep 2024 17:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210113; cv=none; b=Roi20CfzhUXJV4Yp67hZwEUnqbPztH2Y+8AL/VAMjCVEmbpm0gsef3vaGGUBO8Ei/xp9Q/9maFXV3EN/OVns0sOi2yaFAwAbbA+lWrdTQuiA5+GKW6HjEl97gI8o+jdGBn7d1bFSZ1nm0eMSgk1o6EHXF4YqGkOD6GW0F0m1QXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210113; c=relaxed/simple;
	bh=yAxzC4j+rVNenIS6gMwgLiCYQHwSyryjV5AcAUW+As8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyaKABn/FLO1nuq7RF+ZgMrJ4UtohyK9rJvZtmYYDZLE4Hq5YbM0iml54jeJV7jz0RAimE85og5SfX0AbQxqJayLRVywT2VuymXVqH3HrJ06aDGKkos6XHL4SZMppI5ZUg2vklk6Uny7VmDsGo7X3MOIZO0Vurul4/3OLQWM/lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz9E7qMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz9E7qMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC9AC4CEC3;
	Sun,  1 Sep 2024 17:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210113;
	bh=yAxzC4j+rVNenIS6gMwgLiCYQHwSyryjV5AcAUW+As8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tz9E7qMqVJuznq8aoB8I3gTu/SnVHy03cxiFXykYFNrQQ6xU4OVmYjLMfRrOeMqrW
	 Lbv3qDacEHM3Yxn1/Prv3YGwqRFt7CY2e6Yg/ioIZeGLv8yrRF36OjyY33xVZfbpxO
	 hoP3Wf37Gg0sh7ykXAAXSJ2NQI6/V3VqWsoYrMVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/215] f2fs: fix to do sanity check in update_sit_entry
Date: Sun,  1 Sep 2024 18:16:44 +0200
Message-ID: <20240901160826.830312779@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 1c69dc91c3292..dc33b4e5c07b8 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2269,6 +2269,8 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 #endif
 
 	segno = GET_SEGNO(sbi, blkaddr);
+	if (segno == NULL_SEGNO)
+		return;
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
@@ -3443,8 +3445,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
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



