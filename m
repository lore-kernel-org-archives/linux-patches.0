Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2041205501;
	Thu, 12 Dec 2024 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020537; cv=none; b=WaLcXp/sMUceM9eKCIZBA5x7puOvczJXZX7gZfd+DL11o4MWF/W41YXURofIwfXBW9hC4UIgNUVsYfyKOKPZ+zbZ529NWqxzsABlseoGy4JnwQlKN3MFJI/4VTRAMgZvBlx+W2S4ADyEjtyCHKiAVs/3cg3dgpV914ib2SdDgJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020537; c=relaxed/simple;
	bh=0EA392AUP8ikCJtmPrEUzAKOYZgvgFqvQ7kkMEMjrtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS40/aaWuAxJkRuAyQ1Zm3O99vGscH+2r9OU7Cjx935CsjbtRAd5nuX64S2s0d6Lx79+G9V05ss8qfq1ZRK/wlQkgrPzois5tHuIo3zQ49q5kIZpcS5yGdSf8iBH2/sOgbype+961YyVSXU1T5kTvHxgKg8L2iaPOVL6+C871kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHiWkEN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHiWkEN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38FDC4CECE;
	Thu, 12 Dec 2024 16:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020536;
	bh=0EA392AUP8ikCJtmPrEUzAKOYZgvgFqvQ7kkMEMjrtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHiWkEN0UM6Ne6hSPyh2nUyDZcldugTKRr/ln0A7GKLs8X/DOwSZdPQicEUhJ0yEs
	 C0nbBRarDIxilb/5gbK6yx7DWitQZpkcvkLj8QGJ14bwDi966qJ4sYq9yJRhZ+yYhi
	 L67WkcKedTed5WlfRxSUCSNje18fgceVxKlsP3XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 452/772] btrfs: add might_sleep() annotations
Date: Thu, 12 Dec 2024 15:56:37 +0100
Message-ID: <20241212144408.606274309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit a4c853af0c511d7e0f7cb306bbc8a4f1dbdb64ca ]

Add annotations to functions that might sleep due to allocations or IO
and could be called from various contexts. In case of btrfs_search_slot
it's not obvious why it would sleep:

    btrfs_search_slot
      setup_nodes_for_search
        reada_for_balance
          btrfs_readahead_node_child
            btrfs_readahead_tree_block
              btrfs_find_create_tree_block
                alloc_extent_buffer
                  kmem_cache_zalloc
                    /* allocate memory non-atomically, might sleep */
                    kmem_cache_alloc(GFP_NOFS|__GFP_NOFAIL|__GFP_ZERO)
              read_extent_buffer_pages
                submit_extent_page
                  /* disk IO, might sleep */
                  submit_one_bio

Other examples where the sleeping could happen is in 3 places might
sleep in update_qgroup_limit_item(), as shown below:

  update_qgroup_limit_item
    btrfs_alloc_path
      /* allocate memory non-atomically, might sleep */
      kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS)

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 3ed51857a50f ("btrfs: add a sanity check for btrfs root in btrfs_search_slot()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 66d1f34c3fc69..46550c26e6844 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -78,6 +78,8 @@ size_t __attribute_const__ btrfs_get_num_csums(void)
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
+	might_sleep();
+
 	return kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS);
 }
 
@@ -1984,6 +1986,8 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int min_write_lock_level;
 	int prev_cmp;
 
+	might_sleep();
+
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
-- 
2.43.0



