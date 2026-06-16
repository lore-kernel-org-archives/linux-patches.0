Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B664169AD2;
	Tue, 16 Jun 2026 18:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635127; cv=none; b=OM0cXwkdOXXAHxaEptbwXAlnPTgYO9eO7BNlJgJR9uxR225G99B59DJKa8IhI4giXVDfKQ2H2JLWnCLL8aU722AEL+u1qwXY0Ct28G6MG9RukJwnnS6tg7eb2mWs+Ao0OUTY/KVxRzPudO6MlzNMFK4Zxf/BAUi3uUzW+Q6rlVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635127; c=relaxed/simple;
	bh=pq3BzsMoE3FehVi9/qkvJdOnUAij9rRyZjHDaNcYDXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5lddxqxg19VA2mAoa7Nvts/RWhSNB2dQjjUUaGbk351PGXoPCgrNNYavejVJv4bwdw2XipYO/G3o+dlawtnHJbPE3Twt+BSUsElVbr8soJnXdPj7vvGyZRsu7VocXfwvvFTJtFY+AIWgE09AVumpPUU5W31dFQCZUuCD3mlhyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArDIotzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArDIotzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C521F000E9;
	Tue, 16 Jun 2026 18:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635126;
	bh=cEsmPmNtyCOz40yosx4PPOB0ZfFkqINwEogbdcUIJD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArDIotzxWhISKrnxEYpgAvpX3SGwZzjI0zCHqaIc+B7a/qVTRQVWHYYnsEFwNit1Z
	 vkWeDszmg4eWmjKxjC/mkgerIvjzDwvBvxd6b2+yUv37qP9MPkz98+gjvcXOkPERhe
	 nsDa/9+57Du+dxOTaCsbrgxjCQpzYZeIklk9QL/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jens Axboe <axboe@kernel.dk>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 394/411] blk-cgroup: Fix NULL deref caused by blkg_policy_data being installed before init
Date: Tue, 16 Jun 2026 20:30:32 +0530
Message-ID: <20260616145122.161051319@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ec14a87ee1999b19d8b7ed0fa95fea80644624ae upstream.

blk-iocost sometimes causes the following crash:

  BUG: kernel NULL pointer dereference, address: 00000000000000e0
  ...
  RIP: 0010:_raw_spin_lock+0x17/0x30
  Code: be 01 02 00 00 e8 79 38 39 ff 31 d2 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 65 ff 05 48 d0 34 7e b9 01 00 00 00 31 c0 <f0> 0f b1 0f 75 02 5d c3 89 c6 e8 ea 04 00 00 5d c3 0f 1f 84 00 00
  RSP: 0018:ffffc900023b3d40 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 00000000000000e0 RCX: 0000000000000001
  RDX: ffffc900023b3d20 RSI: ffffc900023b3cf0 RDI: 00000000000000e0
  RBP: ffffc900023b3d40 R08: ffffc900023b3c10 R09: 0000000000000003
  R10: 0000000000000064 R11: 000000000000000a R12: ffff888102337000
  R13: fffffffffffffff2 R14: ffff88810af408c8 R15: ffff8881070c3600
  FS:  00007faaaf364fc0(0000) GS:ffff88842fdc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000e0 CR3: 00000001097b1000 CR4: 0000000000350ea0
  Call Trace:
   <TASK>
   ioc_weight_write+0x13d/0x410
   cgroup_file_write+0x7a/0x130
   kernfs_fop_write_iter+0xf5/0x170
   vfs_write+0x298/0x370
   ksys_write+0x5f/0xb0
   __x64_sys_write+0x1b/0x20
   do_syscall_64+0x3d/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

This happens because iocg->ioc is NULL. The field is initialized by
ioc_pd_init() and never cleared. The NULL deref is caused by
blkcg_activate_policy() installing blkg_policy_data before initializing it.

blkcg_activate_policy() was doing the following:

1. Allocate pd's for all existing blkg's and install them in blkg->pd[].
2. Initialize all pd's.
3. Online all pd's.

blkcg_activate_policy() only grabs the queue_lock and may release and
re-acquire the lock as allocation may need to sleep. ioc_weight_write()
grabs blkcg->lock and iterates all its blkg's. The two can race and if
ioc_weight_write() runs during #1 or between #1 and #2, it can encounter a
pd which is not initialized yet, leading to crash.

The crash can be reproduced with the following script:

  #!/bin/bash

  echo +io > /sys/fs/cgroup/cgroup.subtree_control
  systemd-run --unit touch-sda --scope dd if=/dev/sda of=/dev/null bs=1M count=1 iflag=direct
  echo 100 > /sys/fs/cgroup/system.slice/io.weight
  bash -c "echo '8:0 enable=1' > /sys/fs/cgroup/io.cost.qos" &
  sleep .2
  echo 100 > /sys/fs/cgroup/system.slice/io.weight

with the following patch applied:

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index fc49be622e05..38d671d5e10c 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1553,6 +1553,12 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
> 		pd->online = false;
> 	}
>
> +       if (system_state == SYSTEM_RUNNING) {
> +               spin_unlock_irq(&q->queue_lock);
> +               ssleep(1);
> +               spin_lock_irq(&q->queue_lock);
> +       }
> +
> 	/* all allocated, init in the same order */
> 	if (pol->pd_init_fn)
> 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)

I don't see a reason why all pd's should be allocated, initialized and
onlined together. The only ordering requirement is that parent blkgs to be
initialized and onlined before children, which is guaranteed from the
walking order. Let's fix the bug by allocating, initializing and onlining pd
for each blkg and holding blkcg->lock over initialization and onlining. This
ensures that an installed blkg is always fully initialized and onlined
removing the the race window.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Breno Leitao <leitao@debian.org>
Fixes: 9d179b865449 ("blkcg: Fix multiple bugs in blkcg_activate_policy()")
Link: https://lore.kernel.org/r/ZN0p5_W-Q9mAHBVY@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1337,7 +1337,7 @@ int blkcg_activate_policy(struct request
 retry:
 	spin_lock_irq(&q->queue_lock);
 
-	/* blkg_list is pushed at the head, reverse walk to allocate parents first */
+	/* blkg_list is pushed at the head, reverse walk to initialize parents first */
 	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
 		struct blkg_policy_data *pd;
 
@@ -1375,21 +1375,20 @@ retry:
 				goto enomem;
 		}
 
-		blkg->pd[pol->plid] = pd;
+		spin_lock(&blkg->blkcg->lock);
+
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
-		pd->online = false;
-	}
+		blkg->pd[pol->plid] = pd;
 
-	/* all allocated, init in the same order */
-	if (pol->pd_init_fn)
-		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
-			pol->pd_init_fn(blkg->pd[pol->plid]);
+		if (pol->pd_init_fn)
+			pol->pd_init_fn(pd);
 
-	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
 		if (pol->pd_online_fn)
-			pol->pd_online_fn(blkg->pd[pol->plid]);
-		blkg->pd[pol->plid]->online = true;
+			pol->pd_online_fn(pd);
+		pd->online = true;
+
+		spin_unlock(&blkg->blkcg->lock);
 	}
 
 	__set_bit(pol->plid, q->blkcg_pols);
@@ -1406,14 +1405,19 @@ out:
 	return ret;
 
 enomem:
-	/* alloc failed, nothing's initialized yet, free everything */
+	/* alloc failed, take down everything */
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
+		struct blkg_policy_data *pd;
 
 		spin_lock(&blkcg->lock);
-		if (blkg->pd[pol->plid]) {
-			pol->pd_free_fn(blkg->pd[pol->plid]);
+		pd = blkg->pd[pol->plid];
+		if (pd) {
+			if (pd->online && pol->pd_offline_fn)
+				pol->pd_offline_fn(pd);
+			pd->online = false;
+			pol->pd_free_fn(pd);
 			blkg->pd[pol->plid] = NULL;
 		}
 		spin_unlock(&blkcg->lock);


