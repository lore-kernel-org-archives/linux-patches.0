Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4E014B07E;
	Mon,  6 Jan 2025 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178445; cv=none; b=Lg6LreUDsJswyWBHkVgDLy6EADNVeJJL3rr0fxflZp4QncILKMiIhMp4Ih/R/wW5UArZVqYNhAdsMWYPIJ9CNexV0FTvd5FYV6RcLrnIYeqBOkccXFpTHSJmAXsJfJSKIT5pHgREFfi4wbI9yiNsEkmB5VCqnxiKqCsZu7R7TFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178445; c=relaxed/simple;
	bh=Vyg9Dr/pXUv3JvQEIn3fvb4EW5B3mNoUi1finDrOep8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb6Eqx4V7TP+RC+WeKj0Biq1cssgmfnmr2A7XvCjSJ/mPBzGZPzzICISDqRd0ebOgB8HWvvP02debVZsM8EC1gFToESIvheeRpl9u906qpYcVKs+dU5+OEKkePY0weOo+USa5A5+fFd4D6Qu39JIHlSpbPMXEQ8Dq4ZqTafsMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2MP9KYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2MP9KYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0E8C4CED2;
	Mon,  6 Jan 2025 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178445;
	bh=Vyg9Dr/pXUv3JvQEIn3fvb4EW5B3mNoUi1finDrOep8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2MP9KYWM5EgM1GFREGfM02ZTPHpkNXqLa8PJWlVG0kJKxa/4La2Cp3DT8oob0/3h
	 m5b1fH9eqwUw6AY5AM1Ndl+tjERcIqSJ+nS0QOytFldBRBdrDTSqhBcuOHAGeifY1Z
	 jwrXZUDTnKArvkYec7+l6CxhzBwoopFUHVcx+b3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8517da8635307182c8a5@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/138] btrfs: fix use-after-free when COWing tree bock and tracing is enabled
Date: Mon,  6 Jan 2025 16:17:23 +0100
Message-ID: <20250106151137.734398470@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a376e42de9b2..5db0e078f68a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1119,6 +1119,8 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
+
+	trace_btrfs_cow_block(root, buf, cow);
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
 	free_extent_buffer_stale(buf);
@@ -1481,7 +1483,6 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 search_start;
-	int ret;
 
 	if (test_bit(BTRFS_ROOT_DELETING, &root->state))
 		btrfs_err(fs_info,
@@ -1511,12 +1512,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
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
 
 /*
-- 
2.39.5



