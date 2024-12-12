Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745113792B;
	Thu, 12 Dec 2024 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022961; cv=none; b=HzEOaUTBE8tps/8x/GrCKS5ZxgDRKBvU4c183PDYQUdOpA80gcSZ9qrg66/liUuImP4GwVmkVj3YhkASQeVcRYJZ0PJhUESV5ZGI/RAers7qyORXCuHPpcrV0Nz9zGlg6Pcrh5G+OXXSu5bVo69pvkTpB8+++5LDJfPyODkawLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022961; c=relaxed/simple;
	bh=qxldSlyTcpncQFNWoY7Xe6eBw3tGit6eQ7d37inimeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+k4nuPWpYFDIol8LTyY54dlkeI7q35KemrprLuiU7leaB0Jkgw8SgqR4WgFrN8nAUgX/h7rsKgQTWjwZoHLH718EeWPAJc1OGGqWDbr+QrqtshCDlGNhW0NMnkVqGHjuExE4QLFyeh3zDK2AxCh/NeD5YTJRXygY3o6uJXWnak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hi9fcK/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hi9fcK/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77349C4CECE;
	Thu, 12 Dec 2024 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022961;
	bh=qxldSlyTcpncQFNWoY7Xe6eBw3tGit6eQ7d37inimeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hi9fcK/iPcmlTvXQ701n2CAwCUkMNioSEW7feHdlk8u+IGkQTQJOCLHXL7wd/vJjk
	 92XHmC/6c9T0b3XE+f8AX55hREHpbSFWbSq5grpr3Qhal4AWVuqkaaXqOdxLPNTBTp
	 9ze1Op2P4x1b/NdBPVxEjkEZsWHzmypmDG5zfX3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/565] btrfs: add might_sleep() annotations
Date: Thu, 12 Dec 2024 15:59:34 +0100
Message-ID: <20241212144326.611703513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0b8c8b5094efb..af6ddf1f913ae 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -76,6 +76,8 @@ size_t __attribute_const__ btrfs_get_num_csums(void)
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
+	might_sleep();
+
 	return kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS);
 }
 
@@ -1774,6 +1776,8 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int min_write_lock_level;
 	int prev_cmp;
 
+	might_sleep();
+
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
-- 
2.43.0



