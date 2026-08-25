Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E3E47CA72;
	Tue, 25 Aug 2026 13:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664621; cv=none; b=j9ngE2M39tLbMYGJwso/1N7I6GMXaaq0JArPdtXsLY9V6Z8JlUsdFc1LKaD4mn5y4gotfWSWVnyGdr7A1QtKGeknBMBN/fZbW95+dgjBydQKQJrETMYShi7H3185uYamjOk1UY+5Ga7MXx6R00vIXQ5iJLYUPi9XsPmsNFi/BG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664621; c=relaxed/simple;
	bh=l08HOGVQhY1w5LZ0GIFlvwKH+Au60thvPpGIKihNhPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5R1s8aWOfmgUPHW8CM6VUYe9NMNqo48HADMsn5byPdGhfLkf375clIawKY1FLMUFvtRDMnE6tsnY+uBrMf3x52loM0KOLehJeQDEFXvdGYw+GaMNHaIpCkovU7fe/aCCPvJLQsdaBn5HJm8e1mAKKPx1aBDnqvsbgu0t2ZgmSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Un7NWzrX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Un7NWzrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F95E1F000E9;
	Tue, 25 Aug 2026 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664615;
	bh=/J0ehQ/8c3tKhUwlN3BrXGnb+SVAfJ2IwxqOUorPHYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Un7NWzrXlbuVOHEGUwM0f3nykbGvIEllekpi/d3GKvx2hBzzXF9YY37qmsTWQUQRY
	 gnogYaBjCCEXlxKcJJ4GrbuSy6GryyTd9dAIRsiYFnFjy9c9jQLY+yh7Tb4S16Tr+e
	 Ce9XzAo0Y5gh55pshWjQhITD0/vH6EGmgHuX0fNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.2 29/82] ext4: propagate errors from fast commit range replay
Date: Tue, 25 Aug 2026 15:25:16 +0200
Message-ID: <20260825132542.654140474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

commit d8b8dd3530bf41e14b118702cdaf9de64bb96885 upstream.

ext4_fc_replay() stops replaying fast commit tags only when a tag
handler returns a negative error. However, ext4_fc_replay_add_range()
and ext4_fc_replay_del_range() currently return 0 from their common
exit paths even after internal failures.

This hides errors from ext4_fc_record_modified_inode(),
ext4_map_blocks(), ext4_find_extent(), ext4_ext_insert_extent(),
ext4_ext_replay_update_ex(), and ext4_ext_remove_space(). As a result,
a failed ADD_RANGE or DEL_RANGE replay can be treated as successful and
the replay code may continue with subsequent fast commit tags.

This is particularly problematic for DEL_RANGE because it may already
have marked blocks as free before ext4_ext_remove_space() fails. If the
error is swallowed, replay may continue from a partially applied range
operation.

Return the saved error from the common exit paths and make the
ERR_PTR() cases in ADD_RANGE store PTR_ERR() before jumping to out.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/tencent_E3622146846A84C75C31C7D32AC4D5AD0605@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2196,8 +2196,11 @@ static int ext4_fc_replay_add_range(stru
 		if (ret == 0) {
 			/* Range is not mapped */
 			path = ext4_find_extent(inode, cur, path, 0);
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				path = NULL;
 				goto out;
+			}
 			memset(&newex, 0, sizeof(newex));
 			newex.ee_block = cpu_to_le32(cur);
 			ext4_ext_store_pblock(
@@ -2209,8 +2212,11 @@ static int ext4_fc_replay_add_range(stru
 			path = ext4_ext_insert_extent(NULL, inode,
 						      path, &newex, 0);
 			up_write((&EXT4_I(inode)->i_data_sem));
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				path = NULL;
 				goto out;
+			}
 			goto next;
 		}
 
@@ -2257,10 +2263,11 @@ next:
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+	ret = 0;
 out:
 	ext4_free_ext_path(path);
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 /* Replay DEL_RANGE tag */
@@ -2320,9 +2327,10 @@ ext4_fc_replay_del_range(struct super_bl
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);
+	ret = 0;
 out:
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)


