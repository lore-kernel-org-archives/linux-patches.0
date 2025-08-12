Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7F422425B;
	Tue, 12 Aug 2025 19:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025395; cv=none; b=EfotCQV4oggdLk/14nIXU9PrItxNVAbcw2w2QFlWoTQ2Az2t5ZThziNbpLeDbLtL30TQ7F9/kTQPy1n3eRwNzGAMmiLMsYNUYVb2HEhb5nHOlTA1NMtHvuleclriaKogViOh1ceT1Ecf3c11oM4dBcoJXnnYnNVbr6FFobZEqIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025395; c=relaxed/simple;
	bh=MxMXoDI5BztNXVx6/F5kWzcdUXVFvQxOMBwR6hw9RDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIw2eXhCJNf2SL7Kq8mhmcw9CeRhTwSs1AobyxWVK8dN3v7qdcyMpATCo4/yow5pQophrjE7Cdew/W506ejr2MJoX7n9QHbQlkzR60XtantCsg1vKveJPyDMCL5R0v4fsiqRFPegIQNDcDEYnjE+JNpbzJtYv/jVVsJiVBH9jgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zum2cRmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zum2cRmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F41BC4CEF0;
	Tue, 12 Aug 2025 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025394;
	bh=MxMXoDI5BztNXVx6/F5kWzcdUXVFvQxOMBwR6hw9RDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zum2cRmXc/z1rskP4uynX0nU8mem5JBu+gFb3RcaOD+grzpHGRtLcBT7YzUsYhZCF
	 sxO5qsgpWfn1BqBQhCn+GU0/xQtUxCzn+HPTXaF4LM/RwJny9VctfJfWdXJyEauCde
	 JYmfa2UVJatLlPhpHENGHACbjHPz5kMHdfJj+8S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunk67188@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 028/480] btrfs: remove partial support for lowest level from btrfs_search_forward()
Date: Tue, 12 Aug 2025 19:43:56 +0200
Message-ID: <20250812174358.498097700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sun YangKai <sunk67188@gmail.com>

[ Upstream commit 27260dd1904bb409cf84709928ba9bc5506fbe8e ]

Commit 323ac95bce44 ("Btrfs: don't read leaf blocks containing only
checksums during truncate") changed the condition from `level == 0` to
`level == path->lowest_level`, while its original purpose was just to do
some leaf node handling (calling btrfs_item_key_to_cpu()) and skip some
code that doesn't fit leaf nodes.

After changing the condition, the code path:

1. Also handles the non-leaf nodes when path->lowest_level is nonzero,
   which is wrong. However btrfs_search_forward() is never called with a
   nonzero path->lowest_level, which makes this bug not found before.

2. Makes the later if block with the same condition, which was originally
   used to handle non-leaf node (calling btrfs_node_key_to_cpu()) when
   lowest_level is not zero, dead code.

Since btrfs_search_forward() is never called for a path with a
lowest_level different from zero, just completely remove the partial
support for a non-zero lowest_level, simplifying a bit the code, and
assert that lowest_level is zero at the start of the function.

Suggested-by: Qu Wenruo <wqu@suse.com>
Fixes: 323ac95bce44 ("Btrfs: don't read leaf blocks containing only checksums during truncate")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Sun YangKai <sunk67188@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a2e7979372cc..648531fe0900 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4585,16 +4585,13 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 /*
  * A helper function to walk down the tree starting at min_key, and looking
- * for nodes or leaves that are have a minimum transaction id.
+ * for leaves that have a minimum transaction id.
  * This is used by the btree defrag code, and tree logging
  *
  * This does not cow, but it does stuff the starting key it finds back
  * into min_key, so you can call btrfs_search_slot with cow=1 on the
  * key and get a writable path.
  *
- * This honors path->lowest_level to prevent descent past a given level
- * of the tree.
- *
  * min_trans indicates the oldest transaction that you are interested
  * in walking through.  Any nodes or leaves older than min_trans are
  * skipped over (without reading them).
@@ -4615,6 +4612,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 	int keep_locks = path->keep_locks;
 
 	ASSERT(!path->nowait);
+	ASSERT(path->lowest_level == 0);
 	path->keep_locks = 1;
 again:
 	cur = btrfs_read_lock_root_node(root);
@@ -4636,8 +4634,8 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			goto out;
 		}
 
-		/* at the lowest level, we're done, setup the path and exit */
-		if (level == path->lowest_level) {
+		/* At level 0 we're done, setup the path and exit. */
+		if (level == 0) {
 			if (slot >= nritems)
 				goto find_next_key;
 			ret = 0;
@@ -4678,12 +4676,6 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 				goto out;
 			}
 		}
-		if (level == path->lowest_level) {
-			ret = 0;
-			/* Save our key for returning back. */
-			btrfs_node_key_to_cpu(cur, min_key, slot);
-			goto out;
-		}
 		cur = btrfs_read_node_slot(cur, slot);
 		if (IS_ERR(cur)) {
 			ret = PTR_ERR(cur);
@@ -4699,7 +4691,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 out:
 	path->keep_locks = keep_locks;
 	if (ret == 0)
-		btrfs_unlock_up_safe(path, path->lowest_level + 1);
+		btrfs_unlock_up_safe(path, 1);
 	return ret;
 }
 
-- 
2.39.5



