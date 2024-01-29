Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275ED15D5B3;
	Mon, 29 Jan 2024 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548184; cv=none; b=YAvdqYq9Gnjkv2+ZISayMV0xabqTYQb7a5uN4OhOPiXF+BUnFyBhyqajQbK2LcrJBD28DyszF5rUHEyRaUC23oJkPjPWsGhM5T8jV3ujCXRdjn+P8sSRQSVoQ5YTChzy0aeVoM0kts3TsstkahXv3Iim2CB+FUsUjXEYn1UREps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548184; c=relaxed/simple;
	bh=/9X5zQGYsmqdDuqF2GiymcJ5oXoYVqsi+F85ULQeelM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6qQhQh/nnTKQQIo14Yn07rfhdbyRLO20k/AywTFKOg2ZDMqvh0mlPF7LMLUw3TvKbuHp/T7sjSzyeuONil/0GZy1XbYRXZynvpz/U+ItH5C1aAFl7wUl094IfMTkmG5ah+2jPlacm8hdKA7aEzfec9Xqq++oM1ddWcK1Tu2X/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ia8UjsJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ia8UjsJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46A5C43394;
	Mon, 29 Jan 2024 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548184;
	bh=/9X5zQGYsmqdDuqF2GiymcJ5oXoYVqsi+F85ULQeelM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ia8UjsJjW0m3XmddwNmoDg1ORLIRj+x8yoguoAnWlUpsi0jVGEti4085erhu2yPWr
	 V++MnHyIwtGm949w/lxiq2UFnPYvNSav7ZezEgI3LMqqX231m3O5UV5vUr4urZ5kLj
	 uAWzckLGziMX5IGab+YE2yuytdhT6Tude1ImVyJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Anand Jain <anand.jain@oracle.com>,
	Omar Sandoval <osandov@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 228/346] btrfs: dont abort filesystem when attempting to snapshot deleted subvolume
Date: Mon, 29 Jan 2024 09:04:19 -0800
Message-ID: <20240129170023.107065231@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Omar Sandoval <osandov@fb.com>

commit 7081929ab2572920e94d70be3d332e5c9f97095a upstream.

If the source file descriptor to the snapshot ioctl refers to a deleted
subvolume, we get the following abort:

  BTRFS: Transaction aborted (error -2)
  WARNING: CPU: 0 PID: 833 at fs/btrfs/transaction.c:1875 create_pending_snapshot+0x1040/0x1190 [btrfs]
  Modules linked in: pata_acpi btrfs ata_piix libata scsi_mod virtio_net blake2b_generic xor net_failover virtio_rng failover scsi_common rng_core raid6_pq libcrc32c
  CPU: 0 PID: 833 Comm: t_snapshot_dele Not tainted 6.7.0-rc6 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-1.fc39 04/01/2014
  RIP: 0010:create_pending_snapshot+0x1040/0x1190 [btrfs]
  RSP: 0018:ffffa09c01337af8 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff9982053e7c78 RCX: 0000000000000027
  RDX: ffff99827dc20848 RSI: 0000000000000001 RDI: ffff99827dc20840
  RBP: ffffa09c01337c00 R08: 0000000000000000 R09: ffffa09c01337998
  R10: 0000000000000003 R11: ffffffffb96da248 R12: fffffffffffffffe
  R13: ffff99820535bb28 R14: ffff99820b7bd000 R15: ffff99820381ea80
  FS:  00007fe20aadabc0(0000) GS:ffff99827dc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000559a120b502f CR3: 00000000055b6000 CR4: 00000000000006f0
  Call Trace:
   <TASK>
   ? create_pending_snapshot+0x1040/0x1190 [btrfs]
   ? __warn+0x81/0x130
   ? create_pending_snapshot+0x1040/0x1190 [btrfs]
   ? report_bug+0x171/0x1a0
   ? handle_bug+0x3a/0x70
   ? exc_invalid_op+0x17/0x70
   ? asm_exc_invalid_op+0x1a/0x20
   ? create_pending_snapshot+0x1040/0x1190 [btrfs]
   ? create_pending_snapshot+0x1040/0x1190 [btrfs]
   create_pending_snapshots+0x92/0xc0 [btrfs]
   btrfs_commit_transaction+0x66b/0xf40 [btrfs]
   btrfs_mksubvol+0x301/0x4d0 [btrfs]
   btrfs_mksnapshot+0x80/0xb0 [btrfs]
   __btrfs_ioctl_snap_create+0x1c2/0x1d0 [btrfs]
   btrfs_ioctl_snap_create_v2+0xc4/0x150 [btrfs]
   btrfs_ioctl+0x8a6/0x2650 [btrfs]
   ? kmem_cache_free+0x22/0x340
   ? do_sys_openat2+0x97/0xe0
   __x64_sys_ioctl+0x97/0xd0
   do_syscall_64+0x46/0xf0
   entry_SYSCALL_64_after_hwframe+0x6e/0x76
  RIP: 0033:0x7fe20abe83af
  RSP: 002b:00007ffe6eff1360 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fe20abe83af
  RDX: 00007ffe6eff23c0 RSI: 0000000050009417 RDI: 0000000000000003
  RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fe20ad16cd0
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 00007ffe6eff13c0 R14: 00007fe20ad45000 R15: 0000559a120b6d58
   </TASK>
  ---[ end trace 0000000000000000 ]---
  BTRFS: error (device vdc: state A) in create_pending_snapshot:1875: errno=-2 No such entry
  BTRFS info (device vdc: state EA): forced readonly
  BTRFS warning (device vdc: state EA): Skipping commit of aborted transaction.
  BTRFS: error (device vdc: state EA) in cleanup_transaction:2055: errno=-2 No such entry

This happens because create_pending_snapshot() initializes the new root
item as a copy of the source root item. This includes the refs field,
which is 0 for a deleted subvolume. The call to btrfs_insert_root()
therefore inserts a root with refs == 0. btrfs_get_new_fs_root() then
finds the root and returns -ENOENT if refs == 0, which causes
create_pending_snapshot() to abort.

Fix it by checking the source root's refs before attempting the
snapshot, but after locking subvol_sem to avoid racing with deletion.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -790,6 +790,9 @@ static int create_snapshot(struct btrfs_
 		return -EOPNOTSUPP;
 	}
 
+	if (btrfs_root_refs(&root->root_item) == 0)
+		return -ENOENT;
+
 	if (!test_bit(BTRFS_ROOT_SHAREABLE, &root->state))
 		return -EINVAL;
 


