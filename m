Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15213770B;
	Thu, 17 Apr 2025 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915401; cv=none; b=YpOQOXFakNmVjm2nvxe4yWTTRNH2Z6FPUSoMY2vF/Hn8fnW8vCNVox3w+/0fTMwkaZs9keL+KUdDQeLzHYjNmj2sX3fHicnoC8039f+RBOzizbSoQe8KG3rpsYqbfRMFR/cjh7JXhdtr8WhsXhx7ztJYM+3vfGHqg63vC7e16+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915401; c=relaxed/simple;
	bh=F+vKp0oZzWuF0b8XLRQOvQbrSdik5uPx6XEFP9DmXng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3Da7gtRk8XLpvg2SyxmnWhdOHGUQ8RWybqC3avARteyGd0dqIOK7L6jtIdpjNTqXNG3/vbCsnPwuP934jgGpwcp0OXxriz36YM29LrbrZ9UO8jri+2izDIoLKMBr2nHABluCoFRHLRjJjOXxTjss+NF8wq9Mu0zrWBoeH0p+TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I57HKwmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I57HKwmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F87C4CEEA;
	Thu, 17 Apr 2025 18:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915400;
	bh=F+vKp0oZzWuF0b8XLRQOvQbrSdik5uPx6XEFP9DmXng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I57HKwmQ9AnXc4R6yn8yynCWhiqc+7lGv/0xkilQKWkF3j97ne5zea9iTVxS84TQU
	 tTP7YDmtPungyZik1UH9JLN+dxWtzAOQ0FIqdEMk0KWGyyDhRFqcDEBw7JdHQlDFHR
	 IT0vhQ+puXtFnar45zc7VwAbXLHwjni+dNgcVePE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/393] btrfs: harden block_group::bg_list against list_del() races
Date: Thu, 17 Apr 2025 19:48:44 +0200
Message-ID: <20250417175112.211669120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 7511e29cf1355b2c47d0effb39e463119913e2f6 ]

As far as I can tell, these calls of list_del_init() on bg_list cannot
run concurrently with btrfs_mark_bg_unused() or btrfs_mark_bg_to_reclaim(),
as they are in transaction error paths and situations where the block
group is readonly.

However, if there is any chance at all of racing with mark_bg_unused(),
or a different future user of bg_list, better to be safe than sorry.

Otherwise we risk the following interleaving (bg_list refcount in parens)

T1 (some random op)                       T2 (btrfs_mark_bg_unused)
                                        !list_empty(&bg->bg_list); (1)
list_del_init(&bg->bg_list); (1)
                                        list_move_tail (1)
btrfs_put_block_group (0)
                                        btrfs_delete_unused_bgs
                                             bg = list_first_entry
                                             list_del_init(&bg->bg_list);
                                             btrfs_put_block_group(bg); (-1)

Ultimately, this results in a broken ref count that hits zero one deref
early and the real final deref underflows the refcount, resulting in a WARNING.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c |  8 ++++++++
 fs/btrfs/transaction.c | 12 ++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f3e93ba7ec97f..4ceffbef32987 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2897,7 +2897,15 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 						   block_group->length,
 						   &trimmed);
 
+		/*
+		 * Not strictly necessary to lock, as the block_group should be
+		 * read-only from btrfs_delete_unused_bgs().
+		 */
+		ASSERT(block_group->ro);
+		spin_lock(&fs_info->unused_bgs_lock);
 		list_del_init(&block_group->bg_list);
+		spin_unlock(&fs_info->unused_bgs_lock);
+
 		btrfs_unfreeze_block_group(block_group);
 		btrfs_put_block_group(block_group);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 82dd9ee89fbc5..24806e19c7c41 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -161,7 +161,13 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 			cache = list_first_entry(&transaction->deleted_bgs,
 						 struct btrfs_block_group,
 						 bg_list);
+			/*
+			 * Not strictly necessary to lock, as no other task will be using a
+			 * block_group on the deleted_bgs list during a transaction abort.
+			 */
+			spin_lock(&transaction->fs_info->unused_bgs_lock);
 			list_del_init(&cache->bg_list);
+			spin_unlock(&transaction->fs_info->unused_bgs_lock);
 			btrfs_unfreeze_block_group(cache);
 			btrfs_put_block_group(cache);
 		}
@@ -2099,7 +2105,13 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
 
        list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
                btrfs_dec_delayed_refs_rsv_bg_inserts(fs_info);
+		/*
+		* Not strictly necessary to lock, as no other task will be using a
+		* block_group on the new_bgs list during a transaction abort.
+		*/
+	       spin_lock(&fs_info->unused_bgs_lock);
                list_del_init(&block_group->bg_list);
+	       spin_unlock(&fs_info->unused_bgs_lock);
        }
 }
 
-- 
2.39.5



