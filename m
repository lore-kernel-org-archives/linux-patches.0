Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBAB342CBA;
	Sat, 17 Oct 2026 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254750; cv=none; b=XZY5XDYqzIdYRv0D7k+Clh3V8ubSGl2vo53Lp2SE7KVy9g53q2/fDEwaVwWbrxezbvwT8Ogsp0xSwBEzg68Q250qFI9Xis2MGgXMvtlmz533K5A65M0pLlePLrMbM/SbClFxTh1/bpZz1MYXbiwivEeZAjDWr79DTG2KA4OQ2m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254750; c=relaxed/simple;
	bh=BEyiFkl49Qg4/9JKUPLBL5p8XRa7bALEfvMknFTFwEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0TALRghgl9jR+oPe0kxZ6OpAf6ekE5FQSsm1G4ntH2yT4fWTn0O8xWrWHSYykN4Cm3X97d7B4OpH2tR8Ey7lKNlFbJtoe2xhjIxx2DpW3aMPb9flu+yvPVeqO7wcHgEAhfWa+zXJj2U5TKpksKf/MYkWDiPvnncdrOeF6Ax7+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVkAW/zU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVkAW/zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A51E1F000C4;
	Sat, 17 Oct 2026 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254748;
	bh=wS6SR4SJQPcbMqE8qGhkTIaA8s/VFKucyBiaLLEd0Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVkAW/zUV0Z2kgLrYTe7BS4pBiEb4hton7WR1DCUsS7l3QgGNaMjrzHvZV4HsJGLx
	 JMayRHLI22xU5XttiIhqPsTklcvXUcbJFT3DYuNnaaC/252BL1RuW9Ss4NVmEBAcwW
	 5vsJtw/GcC+qBR+nVp0nfqwpa+mtByWbqObal2tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 548/869] btrfs: initialize inode mapping flags for cached inodes
Date: Sat, 17 Oct 2026 17:56:29 +0200
Message-ID: <20261017160051.140647196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 0ef349734a93227b45f65fc50a3311d1cc5f03e9 ]

[BUG]
When running generic/795 with 8K block size, 4K page size, the test
always fails, triggering some ASSERT()s related to folio size:

  795 (241074): drop_caches: 3
  assertion failed: IS_ALIGNED(start, blocksize) && IS_ALIGNED(end + 1, blocksize), in extent_io.c:1404 (blocksize=8192 root=262 ino=258 start=16826368 end=16830463 mapping min order=0)
  ------------[ cut here ]------------
  kernel BUG at extent_io.c:1404!
  Oops: invalid opcode: 0000 [#1] SMP
  CPU: 8 UID: 0 PID: 241105 Comm: fsstress Tainted: G           OE       7.2.0-rc5-custom+ #442 PREEMPT(full)  f4bfb352566f3949f29c233ce6f735050a03b245
  Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:assert_folio_range.cold+0x3d/0x3f [btrfs]
  Call Trace:
   <TASK>
   btrfs_read_folio+0x9e/0x170 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
   prepare_one_folio.constprop.0+0x104/0x2a0 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
   btrfs_buffered_write+0x285/0xa50 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
   btrfs_do_write_iter+0x1aa/0x210 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
   iter_file_splice_write+0x31a/0x540
   direct_splice_actor+0x53/0x170
   splice_direct_to_actor+0xe9/0x240
   do_splice_direct+0x76/0xb0
   vfs_copy_file_range+0x1fd/0x630
   __x64_sys_copy_file_range+0xf9/0x220
   do_syscall_64+0xe1/0x790
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  ---[ end trace 0000000000000000 ]---

The ASSERT() itself is added by a later patch.
The crash is triggered with that new debug patch, and without this fix.

[CAUSE]
In the above case, the start 16826368 is properly 8K aligned, but the
end (16830463 + 1) is not 8K aligned.
Furthermore the mapping's minimal folio order is 0, not the expected 1
for 8K block size with 4K page size.

So this means some inodes do not have btrfs_set_inode_mapping_order()
called on it.

The missing btrfs_set_inode_mapping_order() call happens for cached
inodes, through the following events:

- btrfs_create_new_inode() called for inode X
  Which properly sets minimal folio order for the VFS inode.

- btrfs_update_inode() called for inode X
  Which calls btrfs_delayed_update_inode() to create a delayed_node
  into root->delayed_nodes xarray.

- Drop cache/memory pressure, evicting in-memory inode X
  Which evicted the inode X, but delayed_node is still in
  root->delayed_nodes for future reuse.

- btrfs_iget() for inode X called again

  btrfs_iget()
  |- btrfs_iget_locked()
  |  |- iget5_locked_rcu()
  |     Which creates a new vfs_inode for btrfs, whose mapping still
  |     has the minimal order as 0.
  |
  |- btrfs_read_locked_inode()
     |- btrfs_fill_inode()
     |  |- btrfs_get_delayed_node()
     |     Which found out the previous node, and use that delayed
     |     node to initialize the new inode.
     |
     |- filled = true;
     |- if (filled) goto cache_index;
        Which skips the btrfs_update_inode_mapping_flags() and
	btrfs_set_inode_mapping_order() calls.
	So the inode still has minimal folio order set as 0, not
	the required 1.

Thus later page cache read will get a folio whose size is smaller than
block size, as the mapping has its minimal folio order set as 0 not 1,
then trigger the ASSERT().

[FIX]
Move the btrfs_update_inode_mapping_flags() and
btrfs_set_inode_mapping_order() calls under cache_index label,
so that the mapping flags and minimal folio order is always set
no matter if we have a cached inode.

Assisted-by: LLM (analysis)
Fixes: ecde48a1a6b3 ("btrfs: expose per-inode stable writes flag")
Fixes: cc38d178ff33 ("btrfs: enable large data folio support under CONFIG_BTRFS_EXPERIMENTAL")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 68bea533bb49d..9f3881db076fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3854,12 +3854,13 @@ static int btrfs_read_locked_inode(struct inode *inode,
 
 	btrfs_inode_split_flags(btrfs_inode_flags(leaf, inode_item),
 				&BTRFS_I(inode)->flags, &BTRFS_I(inode)->ro_flags);
+
+cache_index:
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		mapping_clear_stable_writes(inode->i_mapping);
 	else
 		mapping_set_stable_writes(inode->i_mapping);
 
-cache_index:
 	/*
 	 * If we were modified in the current generation and evicted from memory
 	 * and then re-read we need to do a full sync since we don't have any
-- 
2.53.0



