Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F95FDA8;
	Tue, 13 Feb 2024 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845187; cv=none; b=gMK5L4lMlA6oyASH+VP40/5Ldgb4I8N0SYOsHoHVnaCStLI9K8lvkh81tjXqRL9KwwqxnmBZKzBjGRS5gPYccqx6p/S8+Kw5Rt5zKZAMoHaj3BlhhZoEDr/oLtYH0dgUgpQDzc6iK0acR4SXLBjhaWpdK6Bn2tqYCGwP+k4TOic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845187; c=relaxed/simple;
	bh=8fuReOTt0Yq86Ic/HI7q2hGLsZow9vroO4NPyv77vdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKXaX3zvxLW0I7HaXgguYfoYUobPS5FsFV46tmfB0V977F1SBDkEynSIrjwFJml5J05DM+kmko+T8NriZBw3VaSF6YoO68llqSh5YwPjh0G/mpd5p5F2q638y4dqw9XoTmUQiQck20L4IAN3pennRSJ5ziWCXO+52tUupvWnJGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWBSm+pC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWBSm+pC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB61DC43394;
	Tue, 13 Feb 2024 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845187;
	bh=8fuReOTt0Yq86Ic/HI7q2hGLsZow9vroO4NPyv77vdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWBSm+pCuc7YKgv85rWVZTEOgbT6WmXru8LRE7wR1njeELTfxFa2/Rhg2npnwBt5o
	 vAum+C7bFTqykRnJ6WKiPD7/+isY+e99TjUwF8VmeQ/gmTnz9DQ6fFwB8smn9RZKYG
	 Btwac1lhe5OtHmpnL9ZpFRSpGBcMFyMIII7Nf7co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/121] ext4: regenerate buddy after block freeing failed if under fc replay
Date: Tue, 13 Feb 2024 18:20:10 +0100
Message-ID: <20240213171852.994776726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit c9b528c35795b711331ed36dc3dbee90d5812d4e ]

This mostly reverts commit 6bd97bf273bd ("ext4: remove redundant
mb_regenerate_buddy()") and reintroduces mb_regenerate_buddy(). Based on
code in mb_free_blocks(), fast commit replay can end up marking as free
blocks that are already marked as such. This causes corruption of the
buddy bitmap so we need to regenerate it in that case.

Reported-by: Jan Kara <jack@suse.cz>
Fixes: 6bd97bf273bd ("ext4: remove redundant mb_regenerate_buddy()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1fd4ed19060d..529ca47da035 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1232,6 +1232,24 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 	atomic64_add(period, &sbi->s_mb_generation_time);
 }
 
+static void mb_regenerate_buddy(struct ext4_buddy *e4b)
+{
+	int count;
+	int order = 1;
+	void *buddy;
+
+	while ((buddy = mb_find_buddy(e4b, order++, &count)))
+		mb_set_bits(buddy, 0, count);
+
+	e4b->bd_info->bb_fragments = 0;
+	memset(e4b->bd_info->bb_counters, 0,
+		sizeof(*e4b->bd_info->bb_counters) *
+		(e4b->bd_sb->s_blocksize_bits + 2));
+
+	ext4_mb_generate_buddy(e4b->bd_sb, e4b->bd_buddy,
+		e4b->bd_bitmap, e4b->bd_group, e4b->bd_info);
+}
+
 /* The buddy information is attached the buddy cache inode
  * for convenience. The information regarding each group
  * is loaded via ext4_mb_load_buddy. The information involve
@@ -1920,6 +1938,8 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			ext4_mark_group_bitmap_corrupted(
 				sb, e4b->bd_group,
 				EXT4_GROUP_INFO_BBITMAP_CORRUPT);
+		} else {
+			mb_regenerate_buddy(e4b);
 		}
 		goto done;
 	}
-- 
2.43.0



