Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F019614A4E6;
	Tue, 20 Feb 2024 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464452; cv=none; b=NJMMONPGZEdi2EKq8ZBF4ogu++tGG28pNN1dG7MLfTH073PteF2ZCyxgSY2Fjf4LKvDfT3AWYsd3YoJuauatmbT1NQYNezRjV655giHnMJ3fZ/RRzBIsFH6DMehipcUhu+mfxULHiPW7w3n47OglWhpHGagv9IpSqk80aodBNRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464452; c=relaxed/simple;
	bh=aiESXFjm+RBJTCFCzs/1keE5i8P8oO7/2pZNsmohBIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f75i7KJ2QQ3E+JneefKObOFy386FNsinXSepCQAz7DwKVuAnw1ADNaKbcwvjHCdM3zxy8gNUKGnb2u7yKUNMK4NN95rLfeCHJ8LdKahb76l8uiX9Ie6j+l606SDLPT8ixWtVoQPdVHCxdR8qkSRBRxgX44pMn2EXHU4bgA3ZT9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2FekAhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2FekAhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E6DC433F1;
	Tue, 20 Feb 2024 21:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464451;
	bh=aiESXFjm+RBJTCFCzs/1keE5i8P8oO7/2pZNsmohBIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2FekAhGvsjvzmZsrBkwdHJMBgECJ+owS9dnouf6fCX/Qm/iNxBl4XHInGQV/ctOf
	 1E0vmD2yOW09ob5mZKYYCteUSJzRk4UOd0cB5yiezNeEf7FEh1z0thfcheqt/unuQK
	 tnNTwhYPrN4grwV8NDgje1pHin5AbZcTLe/jnyK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 007/309] btrfs: add new unused block groups to the list of unused block groups
Date: Tue, 20 Feb 2024 21:52:46 +0100
Message-ID: <20240220205633.359255553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 12c5128f101bfa47a08e4c0e1a75cfa2d0872bcd upstream.

Space reservations for metadata are, most of the time, pessimistic as we
reserve space for worst possible cases - where tree heights are at the
maximum possible height (8), we need to COW every extent buffer in a tree
path, need to split extent buffers, etc.

For data, we generally reserve the exact amount of space we are going to
allocate. The exception here is when using compression, in which case we
reserve space matching the uncompressed size, as the compression only
happens at writeback time and in the worst possible case we need that
amount of space in case the data is not compressible.

This means that when there's not available space in the corresponding
space_info object, we may need to allocate a new block group, and then
that block group might not be used after all. In this case the block
group is never added to the list of unused block groups and ends up
never being deleted - except if we unmount and mount again the fs, as
when reading block groups from disk we add unused ones to the list of
unused block groups (fs_info->unused_bgs). Otherwise a block group is
only added to the list of unused block groups when we deallocate the
last extent from it, so if no extent is ever allocated, the block group
is kept around forever.

This also means that if we have a bunch of tasks reserving space in
parallel we can end up allocating many block groups that end up never
being used or kept around for too long without being used, which has
the potential to result in ENOSPC failures in case for example we over
allocate too many metadata block groups and then end up in a state
without enough unallocated space to allocate a new data block group.

This is more likely to happen with metadata reservations as of kernel
6.7, namely since commit 28270e25c69a ("btrfs: always reserve space for
delayed refs when starting transaction"), because we started to always
reserve space for delayed references when starting a transaction handle
for a non-zero number of items, and also to try to reserve space to fill
the gap between the delayed block reserve's reserved space and its size.

So to avoid this, when finishing the creation a new block group, add the
block group to the list of unused block groups if it's still unused at
that time. This way the next time the cleaner kthread runs, it will delete
the block group if it's still unused and not needed to satisfy existing
space reservations.

Reported-by: Ivan Shapovalov <intelfx@intelfx.name>
Link: https://lore.kernel.org/linux-btrfs/9cdbf0ca9cdda1b4c84e15e548af7d7f9f926382.camel@intelfx.name/
CC: stable@vger.kernel.org # 6.7+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2757,6 +2757,37 @@ next:
 		btrfs_dec_delayed_refs_rsv_bg_inserts(fs_info);
 		list_del_init(&block_group->bg_list);
 		clear_bit(BLOCK_GROUP_FLAG_NEW, &block_group->runtime_flags);
+
+		/*
+		 * If the block group is still unused, add it to the list of
+		 * unused block groups. The block group may have been created in
+		 * order to satisfy a space reservation, in which case the
+		 * extent allocation only happens later. But often we don't
+		 * actually need to allocate space that we previously reserved,
+		 * so the block group may become unused for a long time. For
+		 * example for metadata we generally reserve space for a worst
+		 * possible scenario, but then don't end up allocating all that
+		 * space or none at all (due to no need to COW, extent buffers
+		 * were already COWed in the current transaction and still
+		 * unwritten, tree heights lower than the maximum possible
+		 * height, etc). For data we generally reserve the axact amount
+		 * of space we are going to allocate later, the exception is
+		 * when using compression, as we must reserve space based on the
+		 * uncompressed data size, because the compression is only done
+		 * when writeback triggered and we don't know how much space we
+		 * are actually going to need, so we reserve the uncompressed
+		 * size because the data may be uncompressible in the worst case.
+		 */
+		if (ret == 0) {
+			bool used;
+
+			spin_lock(&block_group->lock);
+			used = btrfs_is_block_group_used(block_group);
+			spin_unlock(&block_group->lock);
+
+			if (!used)
+				btrfs_mark_bg_unused(block_group);
+		}
 	}
 	btrfs_trans_release_chunk_metadata(trans);
 }


