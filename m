Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020853;
	b=q7pmaNRPSfWR21MOailqR6RT3Hww8gRmPxhkiqv/YlC1r21TtGyAOnSTpF2TKG0YOx64
	 9T5Zz1QRi2hW+6UP91Rj+JLf+9gHYCY2ix+9LNjcuozjLeFrkW3yxcgAmluiZk52jJ2xl
	 e37Aft1CQ7CEcaCPHV3BwF6zjd06yoCJmd8wuky3jFr75GP8F3YiAukgSzEolpmzbEn04
	 s/tLHrB5HLhV7L8MUJ88uydQVjS6lPg33lYBSQpJYt/SzDkZ5ND7MoYz3lpB7zyPbIX6g
	 DFISAJWUsHt4mVEDk8/X4f09gB20AAQPmPy4FM72JVatZJa1gtj+HJa1DRxS9C+sigg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fwI6RCT5QUfSSfIuoWW5SKsNKJbMlaBMn0ytMTYiRwg=;
	b=4KSTZ0WtQMVoTPUGH5sw+IMCmT9DMA0jlAquDfwcWkS0qSR7XrR80bdjEEVfChgigzb/
	 q5Q3Ujogr5QjbmB3jfQQimlPtn7/0KBQvjELHMNUj2g9770lFEY80WtbA4gVxU+Dhwwof
	 49l48/+jD657Wax4x/M9xBzFKMo+73dvoV25YZoJ6l/mf+edINh/Prt4Aac+s1Z34EeJq
	 ajrXqNvwMUsGiAN1juTrdJl6DvDziizQXsXOeOl+rDUFupN2IUxTfuKRkg/XVQkhSiZhn
	 2MowvYRt9RNpnLCnX9HY+4cpqbL6HIfdXcAvqmdv9pQ/kWAsnHPyEyQeZmShxaEYr4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAhlgrKa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C483606B589;
	Wed, 18 Nov 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAhlgrKa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992161F000C4;
	Wed, 18 Nov 2026 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020853;
	bh=fwI6RCT5QUfSSfIuoWW5SKsNKJbMlaBMn0ytMTYiRwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAhlgrKa7qmUPltV5MjRIFOuTN/Z2DrpTmHCYXmlJuPE0vB3S3c74tN+SNHj1PZF3
	 NfyzAdsXcdcuIT1xkAfpCXdzT/Apr3ISHiZCI9ohe7d8ARVrrtt2mQkixNtln/7oCm
	 ozTxXWV9+jvbkfCmVrXi8Ldc0rFFxQ06tTrTlod0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2057/2651] btrfs: update the inode item when removing a free space inode
Date: Wed, 18 Nov 2026 15:54:57 +0100
Message-ID: <20261118150400.104368891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ee182369254c0..483a309255758 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1397,12 +1397,14 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
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
@@ -1415,7 +1417,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 	 * more device items and remove one chunk item), but this is done at
 	 * btrfs_remove_chunk() through a call to check_system_chunk().
 	 */
-	num_items = 3 + map->num_stripes;
+	num_items = 4 + map->num_stripes;
 	btrfs_free_chunk_map(map);
 
 	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e2af75a205ea5..4572b3d64210f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -266,6 +266,16 @@ int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
 		return ret;
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



