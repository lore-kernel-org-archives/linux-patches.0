Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214278;
	b=iG5ssS2qm1svvrKSAaGTWuhS5dbxBdRQD2rdVhU5QAP031yuLxxpHZgGpGP4HKEtW7sd
	 o3Hw6DUuOwaIslhbxpjk/7MWnH/YN/+Z0O/5QpWL5aB0AhAqqAEQzOX/3Hp1/Wu39hJQ3
	 CMg+mWZkOQr+Kr1kSEm0vuBnbPKc9XsNFScL15qE5RYQwm1k8bs6CKxueTjNqMHXfQGmh
	 cOsysotIs6omfGYiU0XFCbIwfMlJajLyknb55gDhOpN8+X1e1u2vXA9mbW+lCxuEm7AKI
	 3bQ9rApudDzVk8do2MP5f4iFMAXv+0K04SMJ2tCKT9ntsKFoDux6aU1Z/4toiRywClQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mh79I7iB3lXL1kMOr8CAHMIJ0mQS2Sh560i8SHxfBAI=;
	b=zkhPA4lvaFt5i2Il3HEfr9yO6ijtgq78g0hOkUpKjzpzXMVur3ykp/LdyifdtpVdwol0
	 trpKr8tuRgH5vNSIvYSzl5+hGBFkxaWAnmsF5DPAZVDkCP8SG/FcJ6ieexV8ywsm4sEsa
	 Wo0KrUBhH5AmbHGvAVbb+Ppcw+FbD+1D7RQg5vBmCPBAXXg58iijxxsX8XWpLL4Poyhh9
	 N1g9TPTzcLZ1lGjeqZKJtb6eTJlQV1yjLNcm4vyU6VSF9mI5YQGy3FBSMvgEAtxmWSAry
	 IKV77LIFn/lT8ICTyL4oAnrmalBiW4zTmlfutcHnRPzfLpnZYNm1i0VahFLDhZH3oPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idcadBIX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5850B60A5BD2;
	Wed, 28 Oct 2026 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idcadBIX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F0B1F01825;
	Wed, 28 Oct 2026 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214278;
	bh=Mh79I7iB3lXL1kMOr8CAHMIJ0mQS2Sh560i8SHxfBAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idcadBIXbZiX9ETpQ3I7vviMSY8aIcS3D20a63OvZCJLM/KKO6p7ocFEEpP/4M1uy
	 wsfiZWV0JQ0TjIpEvnA/ofTTMaW29C1DsHqg13R8HOpAo+dV6O2mOEWVwPqCWCUVfh
	 PpuT5GEB/EFJQLq38YOFV3nB2637abyGQpt0eC4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0765/1887] btrfs: fix block group refcount race in btrfs_create_pending_block_groups()
Date: Wed, 28 Oct 2026 17:47:41 +0100
Message-ID: <20261028170516.849367977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 2d8e5168d48a91e7a802d3003e72afb4304bebfa ]

Block group creation is done in two phases, which results in a slightly
unintuitive property: a block group can be allocated/deallocated from
after btrfs_make_block_group() adds it to the space_info with
btrfs_add_bg_to_space_info(), but before creation is completely completed
in btrfs_create_pending_block_groups(). As a result, it is possible for a
block group to go unused and have 'btrfs_mark_bg_unused' called on it
concurrently with 'btrfs_create_pending_block_groups'. This causes a
number of issues, which were fixed with the block group flag
'BLOCK_GROUP_FLAG_NEW'.

However, this fix is not quite complete. Since it does not use the
unused_bg_lock, it is possible for the following race to occur:

btrfs_create_pending_block_groups            btrfs_mark_bg_unused
                                           if list_empty // false
        list_del_init
        clear_bit
                                           else if (test_bit) // true
                                                list_move_tail

And we get into the exact same broken ref count and invalid new_bgs
state for transaction cleanup that BLOCK_GROUP_FLAG_NEW was designed to
prevent.

The broken refcount aspect will result in a warning like:

  [1272.943527] refcount_t: underflow; use-after-free.
  [1272.943967] WARNING: CPU: 1 PID: 61 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x110
  [1272.944731] Modules linked in: btrfs virtio_net xor zstd_compress raid6_pq null_blk [last unloaded: btrfs]
  [1272.945550] CPU: 1 UID: 0 PID: 61 Comm: kworker/u32:1 Kdump: loaded Tainted: G        W          6.14.0-rc5+ #108
  [1272.946368] Tainted: [W]=WARN
  [1272.946585] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
  [1272.947273] Workqueue: btrfs_discard btrfs_discard_workfn [btrfs]
  [1272.947788] RIP: 0010:refcount_warn_saturate+0xba/0x110
  [1272.949532] RSP: 0018:ffffbf1200247df0 EFLAGS: 00010282
  [1272.949901] RAX: 0000000000000000 RBX: ffffa14b00e3f800 RCX: 0000000000000000
  [1272.950437] RDX: 0000000000000000 RSI: ffffbf1200247c78 RDI: 00000000ffffdfff
  [1272.950986] RBP: ffffa14b00dc2860 R08: 00000000ffffdfff R09: ffffffff90526268
  [1272.951512] R10: ffffffff904762c0 R11: 0000000063666572 R12: ffffa14b00dc28c0
  [1272.952024] R13: 0000000000000000 R14: ffffa14b00dc2868 R15: 000001285dcd12c0
  [1272.952850] FS:  0000000000000000(0000) GS:ffffa14d33c40000(0000) knlGS:0000000000000000
  [1272.953458] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [1272.953931] CR2: 00007f838cbda000 CR3: 000000010104e000 CR4: 00000000000006f0
  [1272.954474] Call Trace:
  [1272.954655]  <TASK>
  [1272.954812]  ? refcount_warn_saturate+0xba/0x110
  [1272.955173]  ? __warn.cold+0x93/0xd7
  [1272.955487]  ? refcount_warn_saturate+0xba/0x110
  [1272.955816]  ? report_bug+0xe7/0x120
  [1272.956103]  ? handle_bug+0x53/0x90
  [1272.956424]  ? exc_invalid_op+0x13/0x60
  [1272.956700]  ? asm_exc_invalid_op+0x16/0x20
  [1272.957011]  ? refcount_warn_saturate+0xba/0x110
  [1272.957399]  btrfs_discard_cancel_work.cold+0x26/0x2b [btrfs]
  [1272.957853]  btrfs_put_block_group.cold+0x5d/0x8e [btrfs]
  [1272.958289]  btrfs_discard_workfn+0x194/0x380 [btrfs]
  [1272.958729]  process_one_work+0x130/0x290
  [1272.959026]  worker_thread+0x2ea/0x420
  [1272.959335]  ? __pfx_worker_thread+0x10/0x10
  [1272.959644]  kthread+0xd7/0x1c0
  [1272.959872]  ? __pfx_kthread+0x10/0x10
  [1272.960172]  ret_from_fork+0x30/0x50
  [1272.960474]  ? __pfx_kthread+0x10/0x10
  [1272.960745]  ret_from_fork_asm+0x1a/0x30
  [1272.961035]  </TASK>
  [1272.961238] ---[ end trace 0000000000000000 ]---

Though we have seen them in the async discard workfn as well. It is
most likely to happen after a relocation finishes which cancels discard,
tears down the block group, etc.

Fix this fully by taking the lock around the list_del_init + clear_bit
so that the two are done atomically.

Fixes: 0657b20c5a76 ("btrfs: fix use-after-free of new block group that became unused")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 1f9fbec887c03..a8f096b46b7b2 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2586,8 +2586,11 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 		/* Already aborted the transaction if it failed. */
 next:
 		btrfs_delayed_refs_rsv_release(fs_info, 1);
+
+		spin_lock(&fs_info->unused_bgs_lock);
 		list_del_init(&block_group->bg_list);
 		clear_bit(BLOCK_GROUP_FLAG_NEW, &block_group->runtime_flags);
+		spin_unlock(&fs_info->unused_bgs_lock);
 	}
 	btrfs_trans_release_chunk_metadata(trans);
 }
-- 
2.53.0



