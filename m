Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F34949F0;
	Mon, 31 Aug 2026 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185196; cv=none; b=Hg7Hkcz2pm5ERCwEZ9OA9MB+j1KcUTZRVChFGpikR34AVajzHyoj6/eq44ymEZGmHxOtWWOfpcPI9ycQxEPv2kmsMvPA5fSYSAL5+yJapqeLIL/Q7+Ylsb1yV6LjggAiw3QJSBO5OaV9a1PNijsJg3zPEMUAM4zUcgEJjnt1OLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185196; c=relaxed/simple;
	bh=eVBcbBvCHux89xnD//vl7NZARqzc0MABYCqSZfyBXOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2h6uhim6aJ7DP53ndojJaTy5tzH7Tn3ofTSyUEQZnimfHizPBJTJLQDoroMhpdHIIS8FOxdU2CMsp5bE95NMWvx8TpQXl+Xm/j4aIHFGPLjPQTDtrK/h5S9Mb6+mKu9vbLYXUnjzsQ3xhAiqFelAzzvWMH7ULVJQ5/89p+3wdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgowc5fY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgowc5fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1915B1F000E9;
	Mon, 31 Aug 2026 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185194;
	bh=4b6K8uWYBo75dT2gjpyVeQPJCqB+l7H4UrdrZKm+y08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgowc5fY1xBl5k2c/1okSAhPOYidTiPDJvxRQotYm5lTUypO/uIeETHuQXI6j3oJ8
	 2q69k6/xvA7md4bfI3PN+LvZjpL+tS5889taz+V80ea2mn3TuE74IDUMpAPsadkr9t
	 BxLYbRAIS6EKl/+SL+XX+aXQq9d1kknBCX/3GwJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/43] ext4: propagate errors from fast commit range replay
Date: Mon, 31 Aug 2026 15:35:25 +0200
Message-ID: <20260831133359.278948288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1678,8 +1678,10 @@ static int ext4_fc_replay_add_range(stru
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
@@ -1741,9 +1743,10 @@ next:
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
@@ -1804,9 +1807,10 @@ ext4_fc_replay_del_range(struct super_bl
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);
+	ret = 0;
 out:
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 static inline const char *tag2str(u16 tag)


