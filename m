Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65AD1B4247;
	Sun,  7 Sep 2025 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276591; cv=none; b=p8Ey0zRc57Mc7iazuPN222yCsqeJk3/LuTdylpn5duf6AyMNZbhnO/oAJUp/ewC3brbXP4MVCX9zpN4J08jiuLBpw4uMx2qxo+/h9BFtrVKQLgC9/sx2i/j6HM0Qih5UORYKiFk7C6JtFW+V7JvwR8fXTBwmKhmDv0j1F4D2AkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276591; c=relaxed/simple;
	bh=I9+1jUGFLDZr9+ne+r7O9gmqTZ34PAfZPLtdb3bXPj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWyskqswU1qwIBas2RSSrRMVbMTO09LXhVbQNo8irgHjTCtPu0HZFoRyDh8uqskOqU5YWM4mj+ZIjs2FWiuWAIAVoboPTwvVa/PQlPf9YybJu7K9lUWGKvE4HDMb6TNJ6mex0nYFsx8j/YvfUDmvWYYCofCXdBLUC1EMv308/bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwdxqaxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwdxqaxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1676AC4CEF0;
	Sun,  7 Sep 2025 20:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276591;
	bh=I9+1jUGFLDZr9+ne+r7O9gmqTZ34PAfZPLtdb3bXPj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwdxqaxB6+0GjkLri6JTaWf5n02QrCDglDJOG/Ua1MRWbNuI7qVTJ5jLy7qrof9/q
	 yFSYepazBuInCxbmC+8o9dPlEUNoEPGYic2lXFj4koPxC96rrOU2jmO652P9WooSmC
	 Gm/4j8PLv5l8fixKCkXlEFmawwBJfuJNfYo1ijhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/121] btrfs: fix race between logging inode and checking if it was logged before
Date: Sun,  7 Sep 2025 21:57:21 +0200
Message-ID: <20250907195609.954352876@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ef07b74e1be56f9eafda6aadebb9ebba0743c9f0 ]

There's a race between checking if an inode was logged before and logging
an inode that can cause us to mark an inode as not logged just after it
was logged by a concurrent task:

1) We have inode X which was not logged before neither in the current
   transaction not in past transaction since the inode was loaded into
   memory, so it's ->logged_trans value is 0;

2) We are at transaction N;

3) Task A calls inode_logged() against inode X, sees that ->logged_trans
   is 0 and there is a log tree and so it proceeds to search in the log
   tree for an inode item for inode X. It doesn't see any, but before
   it sets ->logged_trans to N - 1...

3) Task B calls btrfs_log_inode() against inode X, logs the inode and
   sets ->logged_trans to N;

4) Task A now sets ->logged_trans to N - 1;

5) At this point anyone calling inode_logged() gets 0 (inode not logged)
   since ->logged_trans is greater than 0 and less than N, but our inode
   was really logged. As a consequence operations like rename, unlink and
   link that happen afterwards in the current transaction end up not
   updating the log when they should.

Fix this by ensuring inode_logged() only updates ->logged_trans in case
the inode item is not found in the log tree if after tacking the inode's
lock (spinlock struct btrfs_inode::lock) the ->logged_trans value is still
zero, since the inode lock is what protects setting ->logged_trans at
btrfs_log_inode().

Fixes: 0f8ce49821de ("btrfs: avoid inode logging during rename and link when possible")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9439abf415ae3..26036cf4f51c0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3356,6 +3356,31 @@ int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static bool mark_inode_as_not_logged(const struct btrfs_trans_handle *trans,
+				     struct btrfs_inode *inode)
+{
+	bool ret = false;
+
+	/*
+	 * Do this only if ->logged_trans is still 0 to prevent races with
+	 * concurrent logging as we may see the inode not logged when
+	 * inode_logged() is called but it gets logged after inode_logged() did
+	 * not find it in the log tree and we end up setting ->logged_trans to a
+	 * value less than trans->transid after the concurrent logging task has
+	 * set it to trans->transid. As a consequence, subsequent rename, unlink
+	 * and link operations may end up not logging new names and removing old
+	 * names from the log.
+	 */
+	spin_lock(&inode->lock);
+	if (inode->logged_trans == 0)
+		inode->logged_trans = trans->transid - 1;
+	else if (inode->logged_trans == trans->transid)
+		ret = true;
+	spin_unlock(&inode->lock);
+
+	return ret;
+}
+
 /*
  * Check if an inode was logged in the current transaction. This correctly deals
  * with the case where the inode was logged but has a logged_trans of 0, which
@@ -3390,10 +3415,8 @@ static int inode_logged(const struct btrfs_trans_handle *trans,
 	 * transaction's ID, to avoid the search below in a future call in case
 	 * a log tree gets created after this.
 	 */
-	if (!test_bit(BTRFS_ROOT_HAS_LOG_TREE, &inode->root->state)) {
-		inode->logged_trans = trans->transid - 1;
-		return 0;
-	}
+	if (!test_bit(BTRFS_ROOT_HAS_LOG_TREE, &inode->root->state))
+		return mark_inode_as_not_logged(trans, inode);
 
 	/*
 	 * We have a log tree and the inode's logged_trans is 0. We can't tell
@@ -3447,8 +3470,7 @@ static int inode_logged(const struct btrfs_trans_handle *trans,
 		 * Set logged_trans to a value greater than 0 and less then the
 		 * current transaction to avoid doing the search in future calls.
 		 */
-		inode->logged_trans = trans->transid - 1;
-		return 0;
+		return mark_inode_as_not_logged(trans, inode);
 	}
 
 	/*
@@ -3456,7 +3478,9 @@ static int inode_logged(const struct btrfs_trans_handle *trans,
 	 * the current transacion's ID, to avoid future tree searches as long as
 	 * the inode is not evicted again.
 	 */
+	spin_lock(&inode->lock);
 	inode->logged_trans = trans->transid;
+	spin_unlock(&inode->lock);
 
 	/*
 	 * If it's a directory, then we must set last_dir_index_offset to the
-- 
2.50.1



