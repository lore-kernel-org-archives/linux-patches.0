Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47532224F6;
	Tue, 10 Sep 2024 09:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961955; cv=none; b=dh+y2w4rcvnqTfr03WAqqyzh4bqLc4KjIs3YbgO935pxJNkf36tf2ZP6AaW/viSSCnYE1cqIMDFHThXGM7cMAbecpCyyHcy2f8Lc9jQ8cSaVahRd4DAKSQ5yKQGthdpc4o9grQNvr08Eed9rMsKck9na6xiDn/y73wKiCFYX6jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961955; c=relaxed/simple;
	bh=bUeBP8omTkx3B9cGUqOH3ooagufij4Lp0IjDSMvR/0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFsogrR7hXVdQA+SsJ2JKUsjCuwVRrf6e1e7FvXS+f08A7dsBvMNYB73xF3jq20QhqdlUBlSVD+Hsw4w9lafLyi12hvPocuyxivzwllm/ft6REtC7v8RiEGl/iyLCALkBwr4yIfuReJI1HgoWjddVmQxbGT010Hm6m71SI60qWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzFXHosK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzFXHosK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13FCC4CEC3;
	Tue, 10 Sep 2024 09:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961955;
	bh=bUeBP8omTkx3B9cGUqOH3ooagufij4Lp0IjDSMvR/0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzFXHosKtOgi3UGKj4noZOLc6PdeMCfNjc2BxEMQIJkjM0+QIHwM/g+TwRxIyi/4y
	 yU1nZ7DkDWfq6DZYHTc8FAIjKN9cChQliajIE+kJVWufKmKJ4IBF+cA2dOzVgd2ep9
	 GcReSTdYbXpQPfrq5qb8HyRwMz4d48WSTvHaYYnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 245/375] btrfs: dont BUG_ON() when 0 reference count at btrfs_lookup_extent_info()
Date: Tue, 10 Sep 2024 11:30:42 +0200
Message-ID: <20240910092630.780087688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 28cb13f29faf6290597b24b728dc3100c019356f ]

Instead of doing a BUG_ON() handle the error by returning -EUCLEAN,
aborting the transaction and logging an error message.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 033eb428ffcd..55be8a7f0bb1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -173,9 +173,16 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 
 		ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 		num_refs = btrfs_extent_refs(leaf, ei);
+		if (unlikely(num_refs == 0)) {
+			ret = -EUCLEAN;
+			btrfs_err(fs_info,
+		"unexpected zero reference count for extent item (%llu %u %llu)",
+				  key.objectid, key.type, key.offset);
+			btrfs_abort_transaction(trans, ret);
+			goto out_free;
+		}
 		extent_flags = btrfs_extent_flags(leaf, ei);
 		owner = btrfs_get_extent_owner_root(fs_info, leaf, path->slots[0]);
-		BUG_ON(num_refs == 0);
 	} else {
 		num_refs = 0;
 		extent_flags = 0;
@@ -205,10 +212,19 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			goto search_again;
 		}
 		spin_lock(&head->lock);
-		if (head->extent_op && head->extent_op->update_flags)
+		if (head->extent_op && head->extent_op->update_flags) {
 			extent_flags |= head->extent_op->flags_to_set;
-		else
-			BUG_ON(num_refs == 0);
+		} else if (unlikely(num_refs == 0)) {
+			spin_unlock(&head->lock);
+			mutex_unlock(&head->mutex);
+			spin_unlock(&delayed_refs->lock);
+			ret = -EUCLEAN;
+			btrfs_err(fs_info,
+			  "unexpected zero reference count for extent %llu (%s)",
+				  bytenr, metadata ? "metadata" : "data");
+			btrfs_abort_transaction(trans, ret);
+			goto out_free;
+		}
 
 		num_refs += head->ref_mod;
 		spin_unlock(&head->lock);
-- 
2.43.0



