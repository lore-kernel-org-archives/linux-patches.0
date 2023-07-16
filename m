Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584D78F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE38C433C7;
	Sun, 16 Jul 2023 20:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540991;
	bh=8YHpGOYYcivm7vR4sEnD5xVCGDzQ7X7JjO/CG8A+6nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sji/+2rHqX6SmqGnmRkUTWqQD41WyGw6svMwYx7PnoQPxK9ncfG6UrBv0JiawaRr7
	 HjZNn+luXRLZYcebRj2DRauzW/PkGPkPSLGg92DJFn/6JJ9hUBoYczY4Z94GHQq4U6
	 VezhSDW2msaRp8ZBQLvtHIGPhKPpsh9jVWNDtVY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 561/591] btrfs: fix race when deleting quota root from the dirty cow roots list
Date: Sun, 16 Jul 2023 21:51:40 +0200
Message-ID: <20230716194938.371031901@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit b31cb5a6eb7a48b0a7bfdf06832b1fd5088d8c79 upstream.

When disabling quotas we are deleting the quota root from the list
fs_info->dirty_cowonly_roots without taking the lock that protects it,
which is struct btrfs_fs_info::trans_lock. This unsynchronized list
manipulation may cause chaos if there's another concurrent manipulation
of this list, such as when adding a root to it with
ctree.c:add_root_to_dirty_list().

This can result in all sorts of weird failures caused by a race, such as
the following crash:

  [337571.278245] general protection fault, probably for non-canonical address 0xdead000000000108: 0000 [#1] PREEMPT SMP PTI
  [337571.278933] CPU: 1 PID: 115447 Comm: btrfs Tainted: G        W          6.4.0-rc6-btrfs-next-134+ #1
  [337571.279153] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
  [337571.279572] RIP: 0010:commit_cowonly_roots+0x11f/0x250 [btrfs]
  [337571.279928] Code: 85 38 06 00 (...)
  [337571.280363] RSP: 0018:ffff9f63446efba0 EFLAGS: 00010206
  [337571.280582] RAX: ffff942d98ec2638 RBX: ffff9430b82b4c30 RCX: 0000000449e1c000
  [337571.280798] RDX: dead000000000100 RSI: ffff9430021e4900 RDI: 0000000000036070
  [337571.281015] RBP: ffff942d98ec2000 R08: ffff942d98ec2000 R09: 000000000000015b
  [337571.281254] R10: 0000000000000009 R11: 0000000000000001 R12: ffff942fe8fbf600
  [337571.281476] R13: ffff942dabe23040 R14: ffff942dabe20800 R15: ffff942d92cf3b48
  [337571.281723] FS:  00007f478adb7340(0000) GS:ffff94349fa40000(0000) knlGS:0000000000000000
  [337571.281950] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [337571.282184] CR2: 00007f478ab9a3d5 CR3: 000000001e02c001 CR4: 0000000000370ee0
  [337571.282416] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [337571.282647] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [337571.282874] Call Trace:
  [337571.283101]  <TASK>
  [337571.283327]  ? __die_body+0x1b/0x60
  [337571.283570]  ? die_addr+0x39/0x60
  [337571.283796]  ? exc_general_protection+0x22e/0x430
  [337571.284022]  ? asm_exc_general_protection+0x22/0x30
  [337571.284251]  ? commit_cowonly_roots+0x11f/0x250 [btrfs]
  [337571.284531]  btrfs_commit_transaction+0x42e/0xf90 [btrfs]
  [337571.284803]  ? _raw_spin_unlock+0x15/0x30
  [337571.285031]  ? release_extent_buffer+0x103/0x130 [btrfs]
  [337571.285305]  reset_balance_state+0x152/0x1b0 [btrfs]
  [337571.285578]  btrfs_balance+0xa50/0x11e0 [btrfs]
  [337571.285864]  ? __kmem_cache_alloc_node+0x14a/0x410
  [337571.286086]  btrfs_ioctl+0x249a/0x3320 [btrfs]
  [337571.286358]  ? mod_objcg_state+0xd2/0x360
  [337571.286577]  ? refill_obj_stock+0xb0/0x160
  [337571.286798]  ? seq_release+0x25/0x30
  [337571.287016]  ? __rseq_handle_notify_resume+0x3ba/0x4b0
  [337571.287235]  ? percpu_counter_add_batch+0x2e/0xa0
  [337571.287455]  ? __x64_sys_ioctl+0x88/0xc0
  [337571.287675]  __x64_sys_ioctl+0x88/0xc0
  [337571.287901]  do_syscall_64+0x38/0x90
  [337571.288126]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
  [337571.288352] RIP: 0033:0x7f478aaffe9b

So fix this by locking struct btrfs_fs_info::trans_lock before deleting
the quota root from that list.

Fixes: bed92eae26cc ("Btrfs: qgroup implementation and prototypes")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1296,7 +1296,9 @@ int btrfs_quota_disable(struct btrfs_fs_
 		goto out;
 	}
 
+	spin_lock(&fs_info->trans_lock);
 	list_del(&quota_root->dirty_list);
+	spin_unlock(&fs_info->trans_lock);
 
 	btrfs_tree_lock(quota_root->node);
 	btrfs_clean_tree_block(quota_root->node);


