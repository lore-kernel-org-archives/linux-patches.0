Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214867;
	b=a7t1I2ahn6gzkGzgBnj5M1ZxE/QRVmpKtuu+235nC4jGVjtewuGwjY8nB1Dr1p1cYB7r
	 +SIKy+aCznVP7aECILdEWoa2FU2W+VzwgxZ5XRSloTZu0Gdh7DztiIq0HkBX0Cvas9qrI
	 s7wsyqzHObVTpHrZpbBFdHrQ4t0J90GAIpGxTaGgxy6dQvcNkeqHYI7meXP8skBO+P9pD
	 AJQY+nrAmYhqePV4015pO2+Gx/GwTnQp/y4jEH8rE2sWxHJbPQZU1cmcUjoeFGvvonSlw
	 iVTGfMKh4FTIniMazt3gbvopHmCzaYnFFJKHe//Ff9CklmcnJUH3MiU2ikUl0xrkCkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sV3QV47797ohXeNS3xo4ia+pu+5voErYOBo/w6CMO9k=;
	b=vuL13+nYvR14FGW11Q4wBo1p+PhqH7t1t8SwvrT74363jstzyVMP4a+mt6SM1QhsiQHC
	 q10l7NCA/qbCaadbZKk3WIxKUrlFjx1vBl1LloSkN+/U84D3E9UCwCcK5cnX4Gn/JHfkF
	 rhEYxq/ogj282widQ/DtXigBAVALYm/1TCZUpwCyt57PcO+tWSPpcdYPROk1AxVvo1LV7
	 fnR6c+rssghyURENS1FEooMJrPq42Uc3o8uXBi53OAuRXWPeo4mapsSBHS3CHAujOYO6n
	 /ZaG1fh0btqqIGrwg59w/ERfZryfzecFKwl5ZzP5GGBXw9Yo6p8hnf/XaelmnXZRVKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bs77mBSX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4679606A329;
	Wed, 28 Oct 2026 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bs77mBSX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB61F01825;
	Wed, 28 Oct 2026 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214866;
	bh=sV3QV47797ohXeNS3xo4ia+pu+5voErYOBo/w6CMO9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bs77mBSX/dztnixj3JB+N1SEYRWXy1HZPL5L5LTkciFA/q3euIRvsEiipwrspp+Sv
	 IcyjarktQJaloKrisZo/AJkSIb0nqMmQMLb57qlWJrWfxjOaQ/WUm1dKeYNJVIh4Bk
	 aeuGLM2AFYWA38uRTwWjP0voAjeTxDsC4QEBmRWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1011/1887] btrfs: reserve enough transaction items for qgroup ioctls
Date: Wed, 28 Oct 2026 17:51:47 +0100
Message-ID: <20261028170522.421874876@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit f9a4e3015db1aeafbef407650eb8555445ca943e ]

Currently our qgroup ioctls don't reserve any space, they just do a
transaction join, which does not reserve any space, neither for the quota
tree updates nor for the delayed refs generated when updating the quota
tree. The quota root uses the global block reserve, which is fine most of
the time since we don't expect a lot of updates to the quota root, or to
be too close to -ENOSPC such that other critical metadata updates need to
resort to the global reserve.

However this is not optimal, as not reserving proper space may result in a
transaction abort due to not reserving space for delayed refs and then
abusing the use of the global block reserve.

For example, the following reproducer (which is unlikely to model any
real world use case, but just to illustrate the problem), triggers such a
transaction abort due to -ENOSPC when running delayed refs:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/nullb0
  MNT=/mnt/nullb0

  umount $DEV &> /dev/null
  # Limit device to 1G so that it's much faster to reproduce the issue.
  mkfs.btrfs -f -b 1G $DEV
  mount -o commit=600 $DEV $MNT

  fallocate -l 800M $MNT/filler
  btrfs quota enable $MNT

  for ((i = 1; i <= 400000; i++)); do
      btrfs qgroup create 1/$i $MNT
  done

  umount $MNT

When running this, we can see in dmesg/syslog that a transaction abort
happened:

  [436.490] BTRFS error (device nullb0): failed to run delayed ref for logical 30408704 num_bytes 16384 type 176 action 1 ref_mod 1: -28
  [436.493] ------------[ cut here ]------------
  [436.494] BTRFS: Transaction aborted (error -28)
  [436.495] WARNING: fs/btrfs/extent-tree.c:2247 at btrfs_run_delayed_refs+0xd9/0x110 [btrfs], CPU#4: umount/2495372
  [436.497] Modules linked in: btrfs loop (...)
  [436.508] CPU: 4 UID: 0 PID: 2495372 Comm: umount Tainted: G        W           6.19.0-rc8-btrfs-next-225+ #1 PREEMPT(full)
  [436.510] Tainted: [W]=WARN
  [436.511] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [436.513] RIP: 0010:btrfs_run_delayed_refs+0xdf/0x110 [btrfs]
  [436.514] Code: 0f 82 ea (...)
  [436.518] RSP: 0018:ffffd511850b7d78 EFLAGS: 00010292
  [436.519] RAX: 00000000ffffffe4 RBX: ffff8f120dad37e0 RCX: 0000000002040001
  [436.520] RDX: 0000000000000002 RSI: 00000000ffffffe4 RDI: ffffffffc090fd80
  [436.522] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffffc04d1867
  [436.523] R10: ffff8f18dc1fffa8 R11: 0000000000000003 R12: ffff8f173aa89400
  [436.524] R13: 0000000000000000 R14: ffff8f173aa89400 R15: 0000000000000000
  [436.526] FS:  00007fe59045d840(0000) GS:ffff8f192e22e000(0000) knlGS:0000000000000000
  [436.527] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [436.528] CR2: 00007fe5905ff2b0 CR3: 000000060710a002 CR4: 0000000000370ef0
  [436.530] Call Trace:
  [436.530]  <TASK>
  [436.530]  btrfs_commit_transaction+0x73/0xc00 [btrfs]
  [436.531]  ? btrfs_attach_transaction_barrier+0x1e/0x70 [btrfs]
  [436.532]  sync_filesystem+0x7a/0x90
  [436.533]  generic_shutdown_super+0x28/0x180
  [436.533]  kill_anon_super+0x12/0x40
  [436.534]  btrfs_kill_super+0x12/0x20 [btrfs]
  [436.534]  deactivate_locked_super+0x2f/0xb0
  [436.534]  cleanup_mnt+0xea/0x180
  [436.535]  task_work_run+0x58/0xa0
  [436.535]  exit_to_user_mode_loop+0xed/0x480
  [436.536]  ? __x64_sys_umount+0x68/0x80
  [436.536]  do_syscall_64+0x2a5/0xf20
  [436.537]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [436.537] RIP: 0033:0x7fe5906b6217
  [436.538] Code: 0d 00 f7 (...)
  [436.540] RSP: 002b:00007ffcd87a61f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
  [436.541] RAX: 0000000000000000 RBX: 00005618b9ecadc8 RCX: 00007fe5906b6217
  [436.541] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00005618b9ecb100
  [436.542] RBP: 0000000000000000 R08: 00007ffcd87a4fe0 R09: 00000000ffffffff
  [436.544] R10: 0000000000000103 R11: 0000000000000246 R12: 00007fe59081626c
  [436.544] R13: 00005618b9ecb100 R14: 0000000000000000 R15: 00005618b9ecacc0
  [436.545]  </TASK>
  [436.545] ---[ end trace 0000000000000000 ]---

Fix this by changing the qgroup ioctls to use start transaction instead of
joining so that proper space is reserved for the delayed refs generated
for the updates to the quota root. This way we don't get any transaction
abort.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bc1f605e55a20..cae064c262cc9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4667,7 +4667,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	trans = btrfs_join_transaction(root);
+	/* 2 BTRFS_QGROUP_RELATION_KEY items. */
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
@@ -4729,7 +4730,11 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto out;
 	}
 
-	trans = btrfs_join_transaction(root);
+	/*
+	 * 1 BTRFS_QGROUP_INFO_KEY item.
+	 * 1 BTRFS_QGROUP_LIMIT_KEY item.
+	 */
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
@@ -4775,7 +4780,8 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	trans = btrfs_join_transaction(root);
+	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
+	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
-- 
2.53.0



