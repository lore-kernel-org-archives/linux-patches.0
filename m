Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B8F2E54D1;
	Mon, 13 Apr 2026 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098074; cv=none; b=RglUqo7WgYEeRw7BgmHmfYjDprotK4BAT8Yu1xpEdmvO5bAxzPks3qOlQcyNwXJvMvxeKtveCA+r7g16S3nspkFm+QbsFpMWpmvWmnK4WnRXHCLeGyZlS+AFRcdeF+VMIGsuEDM+4jNJo3U4putm93f2I79rqCn22ArA8CymF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098074; c=relaxed/simple;
	bh=1R90otRC61UKouH7tMOYWBtXrzlxFordpLyWgodLGEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJXkYkAIWL31RJM94NIECOlXo0s1lYo2dWTP5/FVhxnmZhuMYtbniOpvkBowb2tQjM00aCkvfeyfWFMQ0D61l1sOO8R428cwU9zNRWKSGFcYuyVGYabJwcHmAaVDE8U1ZusBkZFko2ExuD7VKLenssQwpU5TqvZr7OJthRwdGOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAmiOvhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAmiOvhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E0FC2BCB0;
	Mon, 13 Apr 2026 16:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098073;
	bh=1R90otRC61UKouH7tMOYWBtXrzlxFordpLyWgodLGEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAmiOvhdOEaAhCGdQdCSH1B9HbYKYPNgd96FJKiaxNNZYIACRZpBQkQKWnvEOuAPa
	 GXaXMeKfObxynmK86WM/DYSzzFUkO94exHC+d64skonO5wjhntqwApViXSNweTj6Cj
	 phF4B0v8Sb1Ygyz8u9o5fIhLxuQwe2ubCCSzPoCw=
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
Subject: [PATCH 5.15 384/570] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths
Date: Mon, 13 Apr 2026 17:58:35 +0200
Message-ID: <20260413155844.863584974@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -1582,19 +1582,21 @@ static int ext4_fc_replay_inode(struct s
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
@@ -1610,13 +1612,14 @@ static int ext4_fc_replay_inode(struct s
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


