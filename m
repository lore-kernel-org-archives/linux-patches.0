Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9660F155A24;
	Sun,  1 Sep 2024 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207661; cv=none; b=T0Z1oObJ0Y3cszYgYj+4sUiSIZ/Vfg3Id0/2EhgIc3woDTz+4xX8RNMHnhYeVWlm1CiHtAMc5d2es95pBBsl/tEvtIYHkmkXNzy7k2uLvM3VklZOPSfmi0h90ae4ucI3ndOlIj3sNz9ALKAvjc29qMlYsp2MBvSmPMAMbar5i4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207661; c=relaxed/simple;
	bh=GWfp588RcYpSH6lXUQq0/Z3iRXzVrv9wCqtmJD6gZz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk9crUnjzMwqcVagNBj/lm9Bkn5tfR7UR1pfmNLUYlc6pj57w7fU9jFLOSJeivmxfmnlUo7w5Ugi2ri2rIVl5X31X9SJsA3UFb9sQ1gV94VtHADkJ0ZtAEVHVBMGLFXhfWxmr4AQXkIgcEW+Kn2yvsvsVjhQZr+66BfKbef3WPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ur8Qaxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ur8Qaxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05051C4CEC3;
	Sun,  1 Sep 2024 16:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207661;
	bh=GWfp588RcYpSH6lXUQq0/Z3iRXzVrv9wCqtmJD6gZz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ur8QaxqIcvIXXw+XC1siLjoWylgdAe4RZn1xbWk4puaQpl25gK70wnnSYVfy0K/b
	 /K++y/sjZ2IgA4nrDfHV2YLVGKk0l+2sWqtuMKxpY55kFWmNd6Te6xbmVvyYkrPXx4
	 ULrB44hz4fYe9Sm1I9nFfcnSlKgfcqdcEjabOylk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/98] f2fs: fix to do sanity check in update_sit_entry
Date: Sun,  1 Sep 2024 18:16:10 +0200
Message-ID: <20240901160805.211763724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 34090edc8ce25..6750cda692cc3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2018,6 +2018,8 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 #endif
 
 	segno = GET_SEGNO(sbi, blkaddr);
+	if (segno == NULL_SEGNO)
+		return;
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
@@ -2935,8 +2937,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	update_sit_entry(sbi, *new_blkaddr, 1);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
-		update_sit_entry(sbi, old_blkaddr, -1);
+	update_sit_entry(sbi, old_blkaddr, -1);
 
 	if (!__has_curseg_space(sbi, type))
 		sit_i->s_ops->allocate_segment(sbi, type, false);
-- 
2.43.0



