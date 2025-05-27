Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD327A900;
	Tue, 27 May 2025 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364728; cv=none; b=r14DjXfm0L60oaolAT+DAuCwcF299EVck31/VlYEljASkN2WYay2PbJ3SQlzNWtqG9ktko/BNE4U6ygD7ZFnzLagb9VSjWK9QzSwm1Dq2Qjc7jdDmOghxpvag/axOpdzYujxxWdwLbVKW6YzEiTu8gnrGKhUOvJlMLrMB0U5qCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364728; c=relaxed/simple;
	bh=NCijPsK97U6+fwk8BGu1yzrndsL9QvdLDmlWJvEwjj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcwpqyprJCHOWRft6FR0+//CcmrEp9j/C5oGCTnX+lWsKfwznmFurec+YMOgXBNLu/C4Wh7OhDIe5fIQacNB/t/+PCPV21hJFWh5kmuOYbb4VDAPWQaD1O90KgVFW3cLLM0GOr2Cw9bovUcpH0DKXSRnKTL+HQO+D+09J+a5jVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmJYqG7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmJYqG7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B22C4CEEB;
	Tue, 27 May 2025 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364728;
	bh=NCijPsK97U6+fwk8BGu1yzrndsL9QvdLDmlWJvEwjj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmJYqG7gEQPNFxSypwZleyFO+Pf4cUcQ5frTqXjyXiG7+oR/m/eBCiJ9mRTf8L40e
	 fcv1/x1Jz6Ea/24EW89RoRCVLZqQxdfX9XFKTHHXSSryet8p0EVl4qFiWwCzTyzIs+
	 4Z9d1Nfgpsf0E0NvMev/Pa54E/caVvq+I9ZOYr6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/626] btrfs: run btrfs_error_commit_super() early
Date: Tue, 27 May 2025 18:20:09 +0200
Message-ID: <20250527162449.749275131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit df94a342efb451deb0e32b495d1d6cd4bb3a1648 ]

[BUG]
Even after all the error fixes related the
"ASSERT(list_empty(&fs_info->delayed_iputs));" in close_ctree(), I can
still hit it reliably with my experimental 2K block size.

[CAUSE]
In my case, all the error is triggered after the fs is already in error
status.

I find the following call trace to be the cause of race:

           Main thread                       |     endio_write_workers
---------------------------------------------+---------------------------
close_ctree()                                |
|- btrfs_error_commit_super()                |
|  |- btrfs_cleanup_transaction()            |
|  |  |- btrfs_destroy_all_ordered_extents() |
|  |     |- btrfs_wait_ordered_roots()       |
|  |- btrfs_run_delayed_iputs()              |
|                                            | btrfs_finish_ordered_io()
|                                            | |- btrfs_put_ordered_extent()
|                                            |    |- btrfs_add_delayed_iput()
|- ASSERT(list_empty(delayed_iputs))         |
   !!! Triggered !!!

The root cause is that, btrfs_wait_ordered_roots() only wait for
ordered extents to finish their IOs, not to wait for them to finish and
removed.

[FIX]
Since btrfs_error_commit_super() will flush and wait for all ordered
extents, it should be executed early, before we start flushing the
workqueues.

And since btrfs_error_commit_super() now runs early, there is no need to
run btrfs_run_delayed_iputs() inside it, so just remove the
btrfs_run_delayed_iputs() call from btrfs_error_commit_super().

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 19e5f8eaae772..e0e740e4d7c75 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4254,6 +4254,14 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	/*
+	 * Handle the error fs first, as it will flush and wait for all ordered
+	 * extents.  This will generate delayed iputs, thus we want to handle
+	 * it first.
+	 */
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
+		btrfs_error_commit_super(fs_info);
+
 	/*
 	 * Wait for any fixup workers to complete.
 	 * If we don't wait for them here and they are still running by the time
@@ -4343,9 +4351,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 			btrfs_err(fs_info, "commit super ret %d", ret);
 	}
 
-	if (BTRFS_FS_ERROR(fs_info))
-		btrfs_error_commit_super(fs_info);
-
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -4468,10 +4473,6 @@ static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info)
 	/* cleanup FS via transaction */
 	btrfs_cleanup_transaction(fs_info);
 
-	mutex_lock(&fs_info->cleaner_mutex);
-	btrfs_run_delayed_iputs(fs_info);
-	mutex_unlock(&fs_info->cleaner_mutex);
-
 	down_write(&fs_info->cleanup_work_sem);
 	up_write(&fs_info->cleanup_work_sem);
 }
-- 
2.39.5



