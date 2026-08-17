Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F162B32ED40;
	Mon, 17 Aug 2026 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973987; cv=none; b=atBi8qlq67RHKd2Fq56Z/hw5/XvrtiJIaRuL1NSt/Flr7V98Vvg2vAgBpcwS9pkDwzRNUq06mf+Xb5kvaSFWWuYclhbz/HB2mtzVsqAY38pWiRpYfpEpgbLzVDVM2Nw3TRCIrqXf7hURa45dTyOHRQ4estgSCpV76Fm2wTRu/mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973987; c=relaxed/simple;
	bh=cN4IKV6Yj/UPGURqPFVWyhdyZWAgQdXq04uArvLSKXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L432N6h0w4YFQ5Sgg6v5b+tKJgd1FC5Lq5IvyqGrzJmWfUqvQ/pgGrZrAfNbcLydOF5UYEPoeJJqR0lOmS1r/zWxDDrrvK74G6837W9hZMRIPWhiYr8rN7wDQ4TvJ5Y9H1jc3HyosJ2PhXobWu4ZLPh7zwmZmW+sNCt+hDU4n0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6TtyYmo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6TtyYmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D08F1F000E9;
	Mon, 17 Aug 2026 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973985;
	bh=pVwlrZBUcaE7gWl7+Nn5qCdgLG1zUjtrIFsn8D5roeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6TtyYmoGJW/WpCAj8jcRNAiuFWgM5RABzrnz4fDrPGSvvF6/Z/I9OY9SgvaA+jaW
	 KK24+6B8mtrvzGH/BjWBGmQss+x8zXtOFaNJsWH2HqTYMVRz26NkYG2UelBsKWzRp9
	 XnhCyl4DJzm8cSzAZ/MMMUn2s+Kv+DNIexrmv26s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 050/271] btrfs: initialize inode mapping flags for cached inodes
Date: Mon, 17 Aug 2026 15:29:35 +0200
Message-ID: <20260817132538.795333332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a953d47eb2dd5..1271be0fbfcfa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4167,10 +4167,11 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
 
 	btrfs_inode_split_flags(btrfs_inode_flags(leaf, inode_item),
 				&inode->flags, &inode->ro_flags);
+
+cache_index:
 	btrfs_update_inode_mapping_flags(inode);
 	btrfs_set_inode_mapping_order(inode);
 
-cache_index:
 	/*
 	 * If we were modified in the current generation and evicted from memory
 	 * and then re-read we need to do a full sync since we don't have any
-- 
2.53.0



