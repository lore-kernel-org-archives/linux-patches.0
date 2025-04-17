Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C3256C67;
	Thu, 17 Apr 2025 18:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914224; cv=none; b=tl5T2V7tE0F4fHF5RFajDMyymHL3DzKBjXW3FRmFtZgUce1ex/9sGvtGQoZNcVMMCdV2nC4614lHY2Dy+sggjsL2hHzSSWYpVEtD/5yXa6hQCkdagE8eoP02/cEgf/gooAnWyFRTG6LZZfm5zGZz5iNaNjl+QDUTgJGQEWf3CfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914224; c=relaxed/simple;
	bh=KJ81qr0h6ZuHP0pPExd+nnMVqkCycMo1b5NpBsJHzLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0VeJZQWlji+eyZFuB01JAu3nZjWPWZtW5vW9tdu0g4eoahirVBQRNjQfkACMpg0toma7xbHewupxN+XmAdJs5N7M2uE1ULQI4lZB/ac947k8cWc/s+AA2j8pLDNnF0yUnsh6yc8ltK8h23cKo4vMwGC+25WHiOGMB2oXphZL1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0XY4JpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0XY4JpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3EFC4CEE4;
	Thu, 17 Apr 2025 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914223;
	bh=KJ81qr0h6ZuHP0pPExd+nnMVqkCycMo1b5NpBsJHzLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0XY4JpT/IJtqluiBSKlGFxv/9nNlmLRKJ92i2YBASNB+LM3qFbULlXEAET+cxwQH
	 Ms4kYJS0lsgDY0uF3gISLSc68H3LAYJVUeaBOd4ksMi7wkVLv6Qw1/mTNeJuNNERJO
	 j6aD5IYvgcwM+ouM5Yihj2TOstnaZLGKQFi9c69w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 116/414] btrfs: harden block_group::bg_list against list_del() races
Date: Thu, 17 Apr 2025 19:47:54 +0200
Message-ID: <20250417175116.099558284@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3c6f7fecbb9aa..840e7959b0772 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2873,7 +2873,15 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
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
index 914a22cc950b5..7c789b4b946b3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -160,7 +160,13 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
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
@@ -2097,7 +2103,13 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
 
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



