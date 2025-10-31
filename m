Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF7521FF25;
	Fri, 31 Oct 2025 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919500; cv=none; b=ozrgsOjtN+2qanQ9h1FN6wSsSYAfRpq2TJfgYAZR/kifY9kSvfjkQm820Ci2Q3s6tGky7KizrrHAaKxL+utq0Db6Cmg4f2OCLZAXvmc1s9AeMPODb6lFsqodETFFS2PejWJqKsNaTdF21TIz1Uh2zP5c2jKOEUl8Zhyl/1GRRcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919500; c=relaxed/simple;
	bh=MmbUKYhZOYj8sbWfhivSqxQtfjYMKJHm2mgbXUEU6EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dM/McfRV0uXwFyj/Uvd+BbGw+x2T97XTmQf4sM4Z7xegOZi3UWH2T5UJuE1r5R8okbByrRNYfHkzJpW/+U9FZkgkYNMCzUdRbtrT/Y/Kg2sGXPIgLLy4rKqYrvaSZdJZ99uMkRYgDCq3Jkk2uf8J24Opbh+wG9YpxgfnxZb4nZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4fwnhkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4fwnhkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E9AC4CEE7;
	Fri, 31 Oct 2025 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919499;
	bh=MmbUKYhZOYj8sbWfhivSqxQtfjYMKJHm2mgbXUEU6EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4fwnhkVfal5dDdV9qa/KHz4pKqejIhJPP/qugsMg5uCnc5NDuUUcakpDDSVx6wGX
	 VHa5UU240Z8jxwGrYoskNGY0JYBn1hNmeMzBDd3qT7fhT1YnhsQQP6Q/pim4ZYieCF
	 hU3Dus1jqI5s1Ir4v9GFL/mxhm5bpe2PfU6nGUIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 12/40] btrfs: abort transaction on specific error places when walking log tree
Date: Fri, 31 Oct 2025 15:01:05 +0100
Message-ID: <20251031140044.319177388@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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
index 0022ad003791f..f3ca530f032df 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2612,15 +2612,24 @@ static int unaccount_log_buffer(struct btrfs_fs_info *fs_info, u64 start)
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
@@ -2656,8 +2665,14 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
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
@@ -2672,6 +2687,10 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				ret = btrfs_read_extent_buffer(next, &check);
 				if (ret) {
 					free_extent_buffer(next);
+					if (trans)
+						btrfs_abort_transaction(trans, ret);
+					else
+						btrfs_handle_fs_error(fs_info, ret, NULL);
 					return ret;
 				}
 
@@ -2687,6 +2706,10 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
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



