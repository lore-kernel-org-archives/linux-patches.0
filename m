Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032249;
	b=hHgvStlAeVpfIxmAiCf4N28dAqd1u2lNu+pQznI5Y3dg+FQaRUm7y9EwBi6TPmSC9bFS
	 KvWj03niKodg28W0OEHTmcdx/ZT+hIcTXu9YoARiTJMyrQZ/WnB8YK97rnS5croU6BiDL
	 FFlNoTQQhhLtytxnrOrTgV3fDxcyaBGw/RXzkiXHAqADELi+NIvzjxdPeSO+hUYqjblS+
	 vePhyZrnMX++r3mpMvLceBcrBCsrO9dncaVZgEBxEsmp6AgkhChgPi0kAJp9t6ixUty29
	 YmWgHzPSGrGZUQ+afAfM2BeI0LmA2y/UkI5/8ZAl9O5lzB9/HHhkLPHbDBd0o50XTtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U8exOlNTn0pEeZCCXVfPqr+I5rBW4Hz8/UNq0Yg3IxM=;
	b=ziSmnVh043irSOqnUV/oXgeVUtjq9GOFfJVJFLIp7Zv/Jj6cbrqB837Koy9+aMDHx5oJ
	 aroJrmo25v+2XfnUIzqpORO6iH93oVAsorkeIwR0BXFer4PoMZze7S3cVoTbm3afOrZYR
	 oi7RDYlQGrGkjUL9VXqw4ubOXBGGq3/Z5DouJeGdUZMfkpHT8+PlvBVrv6/cLbdsNtiim
	 jgRNdFC1OsvoPWlaN66d7o4uPrOxISoH9vlMXI5v8GA7ntYibxnjxeLPMN6jr7J0imLmg
	 JG7GPsgo8iExwDb2WJbp7gcNwArirKHc9dHy0i1Gca2viwtER+C+TUnScKnhH5tmJMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fp8AV+Ov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6F2606A320;
	Wed, 18 Nov 2026 20:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fp8AV+Ov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20331F000C4;
	Wed, 18 Nov 2026 20:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032249;
	bh=U8exOlNTn0pEeZCCXVfPqr+I5rBW4Hz8/UNq0Yg3IxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fp8AV+OvRmsxYWJ9LEnbOA3BNo2yV0CMAqlRNcQLu4IVZoejmBpX2rCS/e3cL4f2h
	 KEJ25DbNXziLzwc+UUjMVzORDpDI3svrfUZmjKWjtpooXD65HMspWW4Lo/U50mwm+Y
	 eKGF751ODJtwjpD/4bX0zxHF4Or6LvC2sneM2FQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1345/1756] btrfs: update the inode item when removing a free space inode
Date: Wed, 18 Nov 2026 15:57:52 +0100
Message-ID: <20261118150102.881764190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 4e89aff9ad6fcbec555c38169807c4023f93450f ]

btrfs_remove_free_space_inode() adds an orphan item for the free space
inode and clears its link count in memory, but never writes the inode
item. The item is only removed once the delayed iput evicts the inode,
which happens in a later transaction, from the cleaner thread or a
throttled transaction end.

If we crash in between, or if evict can't reserve space for the
truncation and leaves the orphan item for the next mount, the on-disk
inode still has a link count of 1. btrfs_orphan_cleanup() then treats it
as an inode with links and only deletes the orphan item. The free space
header item is already gone at that point, so nothing ever finds the
inode again, and its data extents are leaked.

Write the zero link count to the inode item in the same transaction as
the orphan item, so the orphan cleanup evicts the inode instead. Account
for the extra tree root item update when removing a block group.

Fixes: 455757c322cc ("Btrfs: delay iput when deleting a block group")
Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c      |  6 ++++--
 fs/btrfs/free-space-cache.c | 10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a01c4a5b95db7..20df0965316df 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1326,12 +1326,14 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 	ASSERT(map->start == chunk_offset);
 
 	/*
-	 * We need to reserve 3 + N units from the metadata space info in order
+	 * We need to reserve 4 + N units from the metadata space info in order
 	 * to remove a block group (done at btrfs_remove_chunk() and at
 	 * btrfs_remove_block_group()), which are used for:
 	 *
 	 * 1 unit for adding the free space inode's orphan (located in the tree
 	 * of tree roots).
+	 * 1 unit for updating the free space inode's item (located in the tree
+	 * of tree roots).
 	 * 1 unit for deleting the block group item (located in the extent
 	 * tree).
 	 * 1 unit for deleting the free space item (located in tree of tree
@@ -1344,7 +1346,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 	 * more device items and remove one chunk item), but this is done at
 	 * btrfs_remove_chunk() through a call to check_system_chunk().
 	 */
-	num_items = 3 + map->num_stripes;
+	num_items = 4 + map->num_stripes;
 	btrfs_free_chunk_map(map);
 
 	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index effc8895516a5..ca16a8ccab545 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -266,6 +266,16 @@ int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 	clear_nlink(inode);
+	/*
+	 * Persist the zero link count, so that if the delayed iput below
+	 * doesn't get to evict the inode, the orphan cleanup on the next mount
+	 * evicts it instead of only deleting the orphan item.
+	 */
+	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+	if (ret) {
+		btrfs_add_delayed_iput(BTRFS_I(inode));
+		return ret;
+	}
 	/* One for the block groups ref */
 	spin_lock(&block_group->lock);
 	if (test_and_clear_bit(BLOCK_GROUP_FLAG_IREF, &block_group->runtime_flags)) {
-- 
2.53.0



