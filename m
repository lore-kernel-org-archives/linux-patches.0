Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033CC48C3E5;
	Mon, 31 Aug 2026 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185041; cv=none; b=Nv8KzBmiRsRgIKblwE5mUlBSfMYnjmZYPXvJ2kZx9HjKVX+T5Y7yorwdbuNABfC9iDqo+Vsuw+mAu1VPPiasYGnLs/0dT+EBBgNAPfaj03ldyc5yHdCEEI9sjAlFtGARPcKdDxI6dB4aYg8xfVSd+L3voQuClsZ3ZvbUQlHI0KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185041; c=relaxed/simple;
	bh=8LEVLYL8IczxKt+zkDXclWfmPp0nMHkoagbQTofl0BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YghyyEfm1SqO3aO1qT03fsnyYZMNXxvvJi6XJXto9aQZs3n+ugM4P7cjlEEArpHO9DpjU+n9+JfIAi2uNUTuXqB9qqqT1eTkXjZu1fvQV/h/2x/pAbn5HTFFo9lET8DJDtBS2Zncba/REklEEXoKYknFVic6RSZk3FQT37H+9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veJK9H8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veJK9H8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0861F000E9;
	Mon, 31 Aug 2026 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185038;
	bh=+o4a0tzS4vm8wK/5EHUXyKm/fKtg8i8g28IqE+8J0Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veJK9H8Pe4+WyUZ78eIWGGi5PguWkiwy1qywa72uKKJ906YkdEz+CnJ3ZGDe46Rra
	 CXKBMVhgixzD9BGeGEkFTyLs7254a9Ujw99EtEmHj9neVs6x5pgf/iEStlq7ohlvRS
	 7hKnw9bbVeebFPMsbTGiquut/JFGrwq9xLA6+ZkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/69] ext4: propagate errors from fast commit range replay
Date: Mon, 31 Aug 2026 15:34:58 +0200
Message-ID: <20260831133359.694422014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1780,8 +1780,10 @@ static int ext4_fc_replay_add_range(stru
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
@@ -1843,9 +1845,10 @@ next:
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
@@ -1906,9 +1909,10 @@ ext4_fc_replay_del_range(struct super_bl
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


