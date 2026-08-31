Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3EF47F76A;
	Mon, 31 Aug 2026 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184783; cv=none; b=mYsmrehBQ93OsNpwqHheUb91ODUB4N44tW7GlS2f3gFyb8mwao0BbNRrcP/TTZ+Q19321p+eTqtdGWWZ5DdFh7YY9YF2du4wqdoDjLlAySC04TLx+Up+yfD33XvvOu0d3VX2buBFS22yUzqCcR+E/kMmJF1GoKga4yxuRsEXV1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184783; c=relaxed/simple;
	bh=1yBhCj7io3QCjHzKKpK7qyxyDKkuDO9YvWV9iH0eQZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVBUXPAJ60yJPnA2RXgm1Lhwz/MYm5Nhbe0NSzYz6Sv+c2l75THcBCW3iHHAh5QdWQWrVFPMPSR4rfUtsSuUcY1j3QeBkwVuqmjtNorVqI12ULc+8pQ3lUNJs2VLEQBGRiQyffz4hfBRLpREJ0t2HLNIt9r8JMAGfWwIN1YtC5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bD42JDHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bD42JDHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53251F000E9;
	Mon, 31 Aug 2026 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184782;
	bh=7PPu+wL2xqP4jGucjjiaHBNFcP71qR040q3d3CKXeA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bD42JDHtAw5ekRH6isMCzWGgctIAoM+GIgCxSwyiFpbxp3OWHOcwz5f96c5i07eeM
	 RktZqPYMITAeJNlDP1VJ9upS9FgZo1pRpuvXhkLrzogbT9hgHETtx7qlBnVWTjLT+8
	 DrVrTUTHjprQyYHgDbNmGHxVbZsvQvpWXcyVQ11s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/92] ext4: propagate errors from fast commit range replay
Date: Mon, 31 Aug 2026 15:34:35 +0200
Message-ID: <20260831133401.628773012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit d8b8dd3530bf41e14b118702cdaf9de64bb96885 ]

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
[ kept the existing `ext4_find_extent(inode, cur, NULL, 0)` call and dropped the `ext4_ext_insert_extent()` error-capture hunk, since this tree's extents API predates the ppath rework and already returns errors via `int` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1821,8 +1821,10 @@ static int ext4_fc_replay_add_range(stru
 		if (ret == 0) {
 			/* Range is not mapped */
 			path = ext4_find_extent(inode, cur, NULL, 0);
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
 				goto out;
+			}
 			memset(&newex, 0, sizeof(newex));
 			newex.ee_block = cpu_to_le32(cur);
 			ext4_ext_store_pblock(
@@ -1883,9 +1885,10 @@ next:
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+	ret = 0;
 out:
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 /* Replay DEL_RANGE tag */
@@ -1946,9 +1949,10 @@ ext4_fc_replay_del_range(struct super_bl
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


