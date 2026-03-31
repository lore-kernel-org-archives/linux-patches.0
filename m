Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315E03D75B3;
	Tue, 31 Mar 2026 16:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974584; cv=none; b=PXGuY5BX7H/cICXj43MkrqEaw8SoOzKTWIGVmSCBaN5waqltckYqK1MiJJx+13EHE0fFjYsrpsamDRW3yUEBcI70EPM9XOI4s0Vu6cSbqNvikRC/cVt5ns5+M/J4e5NNg6DETTEedLGhM/fTkRzsOdbetf3zD+Ypbx0IzdVP90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974584; c=relaxed/simple;
	bh=jgpBOI791hZKPhfPn26fg028ammvLrk7WKy10RFtPUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2oua+GbNMbQifrzkK/ek1sOMYrIWb52QmATi4z2IamZPiagyaKPFkk+J72BtNwj39b+fsJfGXnf9NIkPRqzWg4Zb8CBGY5ILsvBVsAnHPdzkBhRNbIjyXfw1CFVgn95AQ32XrLAt60vS8K/E3VhPEq/v0+T1klhEo1bHnEd00c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gifb6z2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gifb6z2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C101C19423;
	Tue, 31 Mar 2026 16:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974583;
	bh=jgpBOI791hZKPhfPn26fg028ammvLrk7WKy10RFtPUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gifb6z2or5jFTZ9LG01ZPHxWnD3/Eb8HSzuQVEMgB4NVk2aWjj83KZiXbGykluNkq
	 OZTNUQLxd7qZ+YwQOwLmzot1BIXAPCUBG74oySNw6u6cSAoOshGGIx3wF+F8f9rwpp
	 +UbI8/tsGJWRHmz9bdLpMvj4AD5IKmOX9leBHsis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 140/175] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths
Date: Tue, 31 Mar 2026 18:22:04 +0200
Message-ID: <20260331161734.928665640@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit ec0a7500d8eace5b4f305fa0c594dd148f0e8d29 upstream.

During code review, Joseph found that ext4_fc_replay_inode() calls
ext4_get_fc_inode_loc() to get the inode location, which holds a
reference to iloc.bh that must be released via brelse().

However, several error paths jump to the 'out' label without
releasing iloc.bh:

 - ext4_handle_dirty_metadata() failure
 - sync_dirty_buffer() failure
 - ext4_mark_inode_used() failure
 - ext4_iget() failure

Fix this by introducing an 'out_brelse' label placed just before
the existing 'out' label to ensure iloc.bh is always released.

Additionally, make ext4_fc_replay_inode() propagate errors
properly instead of always returning 0.

Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260323060836.3452660-1-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1601,19 +1601,21 @@ static int ext4_fc_replay_inode(struct s
 	/* Immediately update the inode on disk. */
 	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
 	if (ret)
-		goto out;
+		goto out_brelse;
 	ret = sync_dirty_buffer(iloc.bh);
 	if (ret)
-		goto out;
+		goto out_brelse;
 	ret = ext4_mark_inode_used(sb, ino);
 	if (ret)
-		goto out;
+		goto out_brelse;
 
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		ext4_debug("Inode not found.");
-		return -EFSCORRUPTED;
+		inode = NULL;
+		ret = -EFSCORRUPTED;
+		goto out_brelse;
 	}
 
 	/*
@@ -1630,13 +1632,14 @@ static int ext4_fc_replay_inode(struct s
 	ext4_inode_csum_set(inode, ext4_raw_inode(&iloc), EXT4_I(inode));
 	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
 	sync_dirty_buffer(iloc.bh);
+out_brelse:
 	brelse(iloc.bh);
 out:
 	iput(inode);
 	if (!ret)
 		blkdev_issue_flush(sb->s_bdev);
 
-	return 0;
+	return ret;
 }
 
 /*


