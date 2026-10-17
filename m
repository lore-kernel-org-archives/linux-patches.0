Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B837A2D7D3A;
	Sat, 17 Oct 2026 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257975; cv=none; b=qAlMaKlm0rh5alkAR6EIkBY2NrSgroWFaklgvsG2SmGIgPu+C+WRvu3KEG9/SlxUrc1dTpvaIFnwU1OJbAheARuGRBbWPgVwUE/UO4SbY78fB6DW5p1JaJFaLorLxMmza4LjkkbFzFmxYZQNmLbcmYEyOXDoAKNGB4WWblktQ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257975; c=relaxed/simple;
	bh=IOKps5CU1dbKsGAoQZOrAQrJBsjExCS3BETn7Qqg3Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNx3OFjgMwpzhYrAZPdmqqIzUYEho83Sjishg0ey/55WB9P/VCn4yb/1LyrVioxIs1nsYOdHHAdr9In5W1/1whGvvS495gsGF3R7Z3xsXBFOoacg616q9/UIK85FkcywxF87XRHWpFm68AO6oCNldJVe72BUHy4jHVM5Ztwbj48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaGpTfc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaGpTfc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D0D1F000C4;
	Sat, 17 Oct 2026 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257974;
	bh=6eO6DtOwyFuSk3o831aobu/1rHtj1tCUEs8SRctjyDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaGpTfc4aIsrmubkUTi84+1II9wK5+C3FnQ7QzbN5pjRDCHgIjA4e1QEF7G2O7Am/
	 bq6JTbyBJMj8LEd/jaWc4nAxFB7Fc9jiq6Tmk0rVAI37FrzFFQ0nllEirKrnina1cc
	 8zzqmwMP5IGeoQ0IByeyOgZ1t7hukaSa4MQPV6fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0731/1674] btrfs: harden block_group::bg_list against list_del() races
Date: Sat, 17 Oct 2026 17:50:03 +0200
Message-ID: <20261017160449.867586027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 163f73538cf76..7c4e3b87f608e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2884,7 +2884,15 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
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
index 3fbf85cf3ad97..6dce8c299d699 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -164,7 +164,13 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
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
@@ -2113,7 +2119,13 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
 
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
2.53.0



