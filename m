Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2BC22A4FE;
	Fri, 31 Oct 2025 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919577; cv=none; b=av4jfE6mSi4TedddNBibJ09SWquLr5stn1jKtQwy+L9IEog2laTcsysW1N6m1gSv1XxW3VKRQJe4MVSogpsgyUq6FzLWF1wP+t+IYoiw/quI972CsuXE4YgXzFXzCcDJOuqWaWiz2aEJQJEd/TSNXolFCderx1zJ7nSkDUANoCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919577; c=relaxed/simple;
	bh=tlXC9tsPHdtHd5dX+uy+qcIM3XKCEVJe8bVdsWbsOGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koKCkfj35KdziB/egsjBw11f0AxTAb8wq/7s4L9ez7gvqOuWpD1O6MRlo61xd1ghUtS16U84ZSPXr/ebGX7PZ1zkKRboiQxaqQk8IgZA9IBFPVTpmdxR875PLEXBThpvEFHm5A/uIajlbNJQvdwlb2A72IpwCWjZa4kg8qYzZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9C5mKNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9C5mKNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8197CC4CEE7;
	Fri, 31 Oct 2025 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919576;
	bh=tlXC9tsPHdtHd5dX+uy+qcIM3XKCEVJe8bVdsWbsOGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9C5mKNkV+pBFkdrrzCxBLujHylPEjH+jzTbGZmBhKGYX5qcC/AhE3bBjJh+YKF1Z
	 69fgk9pYfM173O71cj3qZplCoX7LhdN1932pWCbsyFQ+0hUtfKXlOjoVUOaOjke1Wp
	 zvIBSLExzg9uBEN0bPGYGXG5+cA/q7Kl6qm/Sfzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 24/35] btrfs: abort transaction on specific error places when walking log tree
Date: Fri, 31 Oct 2025 15:01:32 +0100
Message-ID: <20251031140044.146853736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6ebd726b104fa99d47c0d45979e6a6109844ac18 ]

We do several things while walking a log tree (for replaying and for
freeing a log tree) like reading extent buffers and cleaning them up,
but we don't immediately abort the transaction, or turn the fs into an
error state, when one of these things fails. Instead we the transaction
abort or turn the fs into error state in the caller of the entry point
function that walks a log tree - walk_log_tree() - which means we don't
get to know exactly where an error came from.

Improve on this by doing a transaction abort / turn fs into error state
after each such failure so that when it happens we have a better
understanding where the failure comes from. This deliberately leaves
the transaction abort / turn fs into error state in the callers of
walk_log_tree() as to ensure we don't get into an inconsistent state in
case we forget to do it deeper in call chain. It also deliberately does
not do it after errors from the calls to the callback defined in
struct walk_control::process_func(), as we will do it later on another
patch.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7a63afedd01e6..6d92326a1a0c7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2630,15 +2630,24 @@ static int unaccount_log_buffer(struct btrfs_fs_info *fs_info, u64 start)
 static int clean_log_buffer(struct btrfs_trans_handle *trans,
 			    struct extent_buffer *eb)
 {
+	int ret;
+
 	btrfs_tree_lock(eb);
 	btrfs_clear_buffer_dirty(trans, eb);
 	wait_on_extent_buffer_writeback(eb);
 	btrfs_tree_unlock(eb);
 
-	if (trans)
-		return btrfs_pin_reserved_extent(trans, eb);
+	if (trans) {
+		ret = btrfs_pin_reserved_extent(trans, eb);
+		if (ret)
+			btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
 
-	return unaccount_log_buffer(eb->fs_info, eb->start);
+	ret = unaccount_log_buffer(eb->fs_info, eb->start);
+	if (ret)
+		btrfs_handle_fs_error(eb->fs_info, ret, NULL);
+	return ret;
 }
 
 static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
@@ -2674,8 +2683,14 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		next = btrfs_find_create_tree_block(fs_info, bytenr,
 						    btrfs_header_owner(cur),
 						    *level - 1);
-		if (IS_ERR(next))
-			return PTR_ERR(next);
+		if (IS_ERR(next)) {
+			ret = PTR_ERR(next);
+			if (trans)
+				btrfs_abort_transaction(trans, ret);
+			else
+				btrfs_handle_fs_error(fs_info, ret, NULL);
+			return ret;
+		}
 
 		if (*level == 1) {
 			ret = wc->process_func(root, next, wc, ptr_gen,
@@ -2690,6 +2705,10 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				ret = btrfs_read_extent_buffer(next, &check);
 				if (ret) {
 					free_extent_buffer(next);
+					if (trans)
+						btrfs_abort_transaction(trans, ret);
+					else
+						btrfs_handle_fs_error(fs_info, ret, NULL);
 					return ret;
 				}
 
@@ -2705,6 +2724,10 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		ret = btrfs_read_extent_buffer(next, &check);
 		if (ret) {
 			free_extent_buffer(next);
+			if (trans)
+				btrfs_abort_transaction(trans, ret);
+			else
+				btrfs_handle_fs_error(fs_info, ret, NULL);
 			return ret;
 		}
 
-- 
2.51.0



