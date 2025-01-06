Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDD015A86A;
	Mon,  6 Jan 2025 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177247; cv=none; b=iRMf/dnnI9YszY9ocUXJ7KayBcBzgK+HI1MUaTM8kd66u+5sEb83C64KE3onJ6FkuVHbLsGo1f0NV3Q9YSqvfn99aA5Cadj3W1bicqNr3jaQDzGmfEa7BPlhhEpaSp6Jg6zRge3Him6sM3ie8LbGHALMn9vIXa35pNejfu8ATLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177247; c=relaxed/simple;
	bh=X33T8Fiva+Ey9/rL4aJOt/KcdeNP9D53+0kaIrHKV0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNyu1v2RebBuHOgSbevp6xFxNrZLW9ZAZYXCoJeaV2jj0j/DI/qg7QL5vJPqf2YGjI4640vEkHlp8xnqCuBdmZb5pB+9KTA3Pwyu3O8zbsyK2oH8JHflKEJJWo71vGp7ZHvsgQM97tv347AXlxyfnZqMD1S8NFcqNAWUV5IOiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Byp8w901; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Byp8w901"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C646FC4CED2;
	Mon,  6 Jan 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177247;
	bh=X33T8Fiva+Ey9/rL4aJOt/KcdeNP9D53+0kaIrHKV0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Byp8w901fyUPqI/gGyiqMe6XTKoUfR8nVdeJTiaUV/w/T49yAk1o6p2e0Bf4n0MLU
	 2nO9q5yNOOznF1ELToKUNK0lQpo3vQ6iN+myAKDfHZIeo/mzB+l246sacT+vCoigT0
	 nhOSk84QZz3mUUWsR92WjUMGlFE77QSrxuNrZisk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8517da8635307182c8a5@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/222] btrfs: fix use-after-free when COWing tree bock and tracing is enabled
Date: Mon,  6 Jan 2025 16:15:05 +0100
Message-ID: <20250106151154.418519689@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

[ Upstream commit 44f52bbe96dfdbe4aca3818a2534520082a07040 ]

When a COWing a tree block, at btrfs_cow_block(), and we have the
tracepoint trace_btrfs_cow_block() enabled and preemption is also enabled
(CONFIG_PREEMPT=y), we can trigger a use-after-free in the COWed extent
buffer while inside the tracepoint code. This is because in some paths
that call btrfs_cow_block(), such as btrfs_search_slot(), we are holding
the last reference on the extent buffer @buf so btrfs_force_cow_block()
drops the last reference on the @buf extent buffer when it calls
free_extent_buffer_stale(buf), which schedules the release of the extent
buffer with RCU. This means that if we are on a kernel with preemption,
the current task may be preempted before calling trace_btrfs_cow_block()
and the extent buffer already released by the time trace_btrfs_cow_block()
is called, resulting in a use-after-free.

Fix this by moving the trace_btrfs_cow_block() from btrfs_cow_block() to
btrfs_force_cow_block() before the COWed extent buffer is freed.
This also has a side effect of invoking the tracepoint in the tree defrag
code, at defrag.c:btrfs_realloc_node(), since btrfs_force_cow_block() is
called there, but this is fine and it was actually missing there.

Reported-by: syzbot+8517da8635307182c8a5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6759a9b9.050a0220.1ac542.000d.GAE@google.com/
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 62032d3fda85..4b21ca49b666 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -660,6 +660,8 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 			return ret;
 		}
 	}
+
+	trace_btrfs_cow_block(root, buf, cow);
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
 	free_extent_buffer_stale(buf);
@@ -711,7 +713,6 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 search_start;
-	int ret;
 
 	if (unlikely(test_bit(BTRFS_ROOT_DELETING, &root->state))) {
 		btrfs_abort_transaction(trans, -EUCLEAN);
@@ -752,12 +753,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	 * Also We don't care about the error, as it's handled internally.
 	 */
 	btrfs_qgroup_trace_subtree_after_cow(trans, root, buf);
-	ret = btrfs_force_cow_block(trans, root, buf, parent, parent_slot,
-				    cow_ret, search_start, 0, nest);
-
-	trace_btrfs_cow_block(root, buf, *cow_ret);
-
-	return ret;
+	return btrfs_force_cow_block(trans, root, buf, parent, parent_slot,
+				     cow_ret, search_start, 0, nest);
 }
 ALLOW_ERROR_INJECTION(btrfs_cow_block, ERRNO);
 
-- 
2.39.5



