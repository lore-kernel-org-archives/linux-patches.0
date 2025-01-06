Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7353F81728;
	Mon,  6 Jan 2025 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178951; cv=none; b=QZuuEZz+sWxdRfu2yuJwBYCVeZNx8xU5lWUm4R866C7GRu9UOVDzmUxvXxwgklHmDgieEO7I3XxTmavs/S+Tu6K4GQjWGQMNlB5m5bem+O4R3E6wqGHOQ0OtRcEaumSEMwwAiC0JwkbgnDaqIS633SYDH3XqCPqGcq5cJ/SadCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178951; c=relaxed/simple;
	bh=hjKqbXSBYBVcm6WeUzR9yNUlIx1f7dUn6RUi81Nw0ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoWH0ux2aBQzrAwkMjxkGdjQ2KKPe5Ej0svjOc/bkbndLbIpd6a9Th8+ANYh+ar8X9I3tqdXgetlkJqDYVrM1bXNpmb7CN+brLSVpEAYOkDrDC3a0Z9SXPMGgQoUcJV64PtSPFrCYqm7icBMam0JF2JkOkKtYyqX22vHUIM/AXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQzP/ays; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQzP/ays"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC12C4CED2;
	Mon,  6 Jan 2025 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178951;
	bh=hjKqbXSBYBVcm6WeUzR9yNUlIx1f7dUn6RUi81Nw0ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQzP/aysFGGzmQ6jE93FY/vRs6j/finBAa/BXiv6WCuhvwE3aG+mM9uHyHXntni2j
	 GVaQE+DIIH+MJrmhD5chVgqUgGTW1XNcvc6pjLLIKixwu1EZ8PrE5vNnd+3a56X6VB
	 XtKe0DpAH+xcIPM29Nm2WtXE07cGqwxtrChcjybM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8517da8635307182c8a5@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/168] btrfs: fix use-after-free when COWing tree bock and tracing is enabled
Date: Mon,  6 Jan 2025 16:17:34 +0100
Message-ID: <20250106151143.950865606@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 42562c61f52e..b12c5ca0580e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -502,6 +502,8 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
 				      parent_start, last_ref);
 	}
+
+	trace_btrfs_cow_block(root, buf, cow);
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
 	free_extent_buffer_stale(buf);
@@ -553,7 +555,6 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 search_start;
-	int ret;
 
 	if (unlikely(test_bit(BTRFS_ROOT_DELETING, &root->state))) {
 		btrfs_abort_transaction(trans, -EUCLEAN);
@@ -594,12 +595,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
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



