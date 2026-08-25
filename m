Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2896535F185;
	Tue, 25 Aug 2026 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665456; cv=none; b=u8FEeduqEZ5Tj4eaFRcUzvgBejnp6qcyLokkGYdINuf1NkclGrI9dgdnE+dUovuowMISMeARxjx5iASkHJn3RUHpJxM20Wu6F9J1e1ztPFrC5vQTypU0X/PwyEVkqknjYFSlAZyjykf550XA3Khr1z+V77Pc+YqBBhs7ZrrcxGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665456; c=relaxed/simple;
	bh=6hLbIzC5Wjp8DcDt+Vo4CuNQnEclMaSy2S3X5W2BPx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8Ua6TQmqfxkIzQezJGpNjgJKSzdjfXaretwYnnPbhVP7Yv8A5GWNbnqNBYwwWgiZmqKaNASonjX/5vWxuVtJ7INDMAw0wfeEHTA98jIqxIRAqVAeH04uPvZGG0r6ZT8C+VFjJTEfh3UFM6dAoL5bpytMtNpeRx8BwZMxiDnp34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzY/JIhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzY/JIhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A0C1F000E9;
	Tue, 25 Aug 2026 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665455;
	bh=+uGX2z3KbX2aZfgStVdlDC1HwUZc052RbSkMRPqgtOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzY/JIhhcW/vc2198Wqc+2zhenCY9bPzgYg3iphpCPd6qSExnUeI1q3Q0055dDFZf
	 U/mHWMcPJGdm1uSRaPRazpoOLmCabM00JutyE3/mHZTCV4M7DNov3jIwrA9DdeGEuN
	 IkDnzjgMxJSq5t/McUdq4P3KWIUlvpyEhnj8JlYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 31/77] ext4: propagate errors from fast commit range replay
Date: Tue, 25 Aug 2026 15:25:53 +0200
Message-ID: <20260825132542.780793654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1799,8 +1799,11 @@ static int ext4_fc_replay_add_range(stru
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
@@ -1812,8 +1815,11 @@ static int ext4_fc_replay_add_range(stru
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
 
@@ -1860,10 +1866,11 @@ next:
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
@@ -1924,9 +1931,10 @@ ext4_fc_replay_del_range(struct super_bl
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


