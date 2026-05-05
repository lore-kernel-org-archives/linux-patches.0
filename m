Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A712346781;
	Tue,  5 May 2026 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974781; cv=none; b=np1mgSRnfoCj9LQpk9NCHZdszy4IoowlvjEfDFYVVQOYxJiQc3W+yZrfp6liHNjBS+T5N+j+XW7CDn4KK3jAAKn0lMMhie1VZFuhKPIOqbJjzsfAvEqQrshxS+fKeoYa7xMgWPiRLsNO+GjZIYHuAzjQPPNtv3h1GWs4P1XN3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974781; c=relaxed/simple;
	bh=QBzZmYUcpNCYiyIxFh+Hi+aDsC1DjHYpZKnmfJi7hmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rMSvXELZjIK/6K6Gm+t8YTtimLRicHq5c9REaPqJMw/mfrGaC/4+FQ5Lqbp5WAmiMNoJW5SuKIpp4gXKTcWWeKofb/uAl8tM7XD6pQg3cJ32Q1PeapXRCdyW2GZ/AxxpZq5l5jpq7TYJTLbmpIbGKQJEF07fLHceyv2vbc1gaRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfnhMwVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfnhMwVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E4C2BCB4;
	Tue,  5 May 2026 09:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974781;
	bh=QBzZmYUcpNCYiyIxFh+Hi+aDsC1DjHYpZKnmfJi7hmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfnhMwVMiLI4zive/7bgmId0J338sNq+qd8Qea7H7eG3RhJLapBpjTU33kLW0Td3f
	 z3vb4AoL5EBCt+vrpkObOihmYrSIr6N7kRNtQ8tWsPwmlGAf8dsJVdnL+HXEAUAe2j
	 GZ21lSH+P+dVqkLIcd/tFQVEpRbgb20QJybqcqENViFIsyvye61XDERqnZmSNnF+Mp
	 f2Mh57kr3bGcsUnRBdq7zMMcG+3Zke55l+jZHdM2oyzuP8zPDuWz/++gMVUSzuhdfK
	 pInrbgUOps+82wgENHGmOimAqrZ3axawJnRbDhiOH1gbmz6j1b+mfbFIbR6Miq6KYd
	 AEO4XYj8cIyrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] nvme-tcp: teardown circular locking fixes
Date: Tue,  5 May 2026 05:51:38 -0400
Message-ID: <20260505095149.512052-22-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 26bb12b9caafa2e62d638104bf2732f610cdbb0b ]

When a controller reset is triggered via sysfs (by writing to
/sys/class/nvme/<nvmedev>/reset_controller), the reset work tears down
and re-establishes all queues. The socket release using fput() defers
the actual cleanup to task_work delayed_fput workqueue. This deferred
cleanup can race with the subsequent queue re-allocation during reset,
potentially leading to use-after-free or resource conflicts.

Replace fput() with __fput_sync() to ensure synchronous socket release,
guaranteeing that all socket resources are fully cleaned up before the
function returns. This prevents races during controller reset where
new queue setup may begin before the old socket is fully released.

* Call chain during reset:
  nvme_reset_ctrl_work()
    -> nvme_tcp_teardown_ctrl()
      -> nvme_tcp_teardown_io_queues()
        -> nvme_tcp_free_io_queues()
          -> nvme_tcp_free_queue()       <-- fput() -> __fput_sync()
      -> nvme_tcp_teardown_admin_queue()
        -> nvme_tcp_free_admin_queue()
          -> nvme_tcp_free_queue()       <-- fput() -> __fput_sync()
    -> nvme_tcp_setup_ctrl()             <-- race with deferred fput

memalloc_noreclaim_save() sets PF_MEMALLOC which is intended for tasks
performing memory reclaim work that need reserve access. While PF_MEMALLOC
prevents the task from entering direct reclaim (causing __need_reclaim() to
return false), it does not strip __GFP_IO from gfp flags. The allocator can
therefore still trigger writeback I/O when __GFP_IO remains set, which is
unsafe when the caller holds block layer locks.

Switch to memalloc_noio_save() which sets PF_MEMALLOC_NOIO. This causes
current_gfp_context() to strip __GFP_IO|__GFP_FS from every allocation in
the scope, making it safe to allocate memory while holding elevator_lock and
set->srcu.

* The issue can be reproduced using blktests:

  nvme_trtype=tcp ./check nvme/005
blktests (master) # nvme_trtype=tcp ./check nvme/005
nvme/005 (tr=tcp) (reset local loopback target)              [failed]
    runtime  0.725s  ...  0.798s
    something found in dmesg:
    [  108.473940] run blktests nvme/005 at 2025-11-22 16:12:20

    [...]
    ...
    (See '/root/blktests/results/nodev_tr_tcp/nvme/005.dmesg' for the entire message)
blktests (master) # cat /root/blktests/results/nodev_tr_tcp/nvme/005.dmesg
[  108.473940] run blktests nvme/005 at 2025-11-22 16:12:20
[  108.526983] loop0: detected capacity change from 0 to 2097152
[  108.555606] nvmet: adding nsid 1 to subsystem blktests-subsystem-1
[  108.572531] nvmet_tcp: enabling port 0 (127.0.0.1:4420)
[  108.613061] nvmet: Created nvm controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
[  108.616832] nvme nvme0: creating 48 I/O queues.
[  108.630791] nvme nvme0: mapped 48/0/0 default/read/poll queues.
[  108.661892] nvme nvme0: new ctrl: NQN "blktests-subsystem-1", addr 127.0.0.1:4420, hostnqn: nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349
[  108.746639] nvmet: Created nvm controller 2 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
[  108.748466] nvme nvme0: creating 48 I/O queues.
[  108.802984] nvme nvme0: mapped 48/0/0 default/read/poll queues.
[  108.829983] nvme nvme0: Removing ctrl: NQN "blktests-subsystem-1"
[  108.854288] block nvme0n1: no available path - failing I/O
[  108.854344] block nvme0n1: no available path - failing I/O
[  108.854373] Buffer I/O error on dev nvme0n1, logical block 1, async page read

[  108.891693] ======================================================
[  108.895912] WARNING: possible circular locking dependency detected
[  108.900184] 6.17.0nvme+ #3 Tainted: G                 N
[  108.903913] ------------------------------------------------------
[  108.908171] nvme/2734 is trying to acquire lock:
[  108.911957] ffff88810210e610 (set->srcu){.+.+}-{0:0}, at: __synchronize_srcu+0x17/0x170
[  108.917587]
               but task is already holding lock:
[  108.921570] ffff88813abea198 (&q->elevator_lock){+.+.}-{4:4}, at: elevator_change+0xa8/0x1c0
[  108.927361]
               which lock already depends on the new lock.

[  108.933018]
               the existing dependency chain (in reverse order) is:
[  108.938223]
               -> #4 (&q->elevator_lock){+.+.}-{4:4}:
[  108.942988]        __mutex_lock+0xa2/0x1150
[  108.945873]        elevator_change+0xa8/0x1c0
[  108.948925]        elv_iosched_store+0xdf/0x140
[  108.952043]        kernfs_fop_write_iter+0x16a/0x220
[  108.955367]        vfs_write+0x378/0x520
[  108.957598]        ksys_write+0x67/0xe0
[  108.959721]        do_syscall_64+0x76/0xbb0
[  108.962052]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  108.965145]
               -> #3 (&q->q_usage_counter(io)){++++}-{0:0}:
[  108.968923]        blk_alloc_queue+0x30e/0x350
[  108.972117]        blk_mq_alloc_queue+0x61/0xd0
[  108.974677]        scsi_alloc_sdev+0x2a0/0x3e0
[  108.977092]        scsi_probe_and_add_lun+0x1bd/0x430
[  108.979921]        __scsi_add_device+0x109/0x120
[  108.982504]        ata_scsi_scan_host+0x97/0x1c0
[  108.984365]        async_run_entry_fn+0x2d/0x130
[  108.986109]        process_one_work+0x20e/0x630
[  108.987830]        worker_thread+0x184/0x330
[  108.989473]        kthread+0x10a/0x250
[  108.990852]        ret_from_fork+0x297/0x300
[  108.992491]        ret_from_fork_asm+0x1a/0x30
[  108.994159]
               -> #2 (fs_reclaim){+.+.}-{0:0}:
[  108.996320]        fs_reclaim_acquire+0x99/0xd0
[  108.998058]        kmem_cache_alloc_node_noprof+0x4e/0x3c0
[  109.000123]        __alloc_skb+0x15f/0x190
[  109.002195]        tcp_send_active_reset+0x3f/0x1e0
[  109.004038]        tcp_disconnect+0x50b/0x720
[  109.005695]        __tcp_close+0x2b8/0x4b0
[  109.007227]        tcp_close+0x20/0x80
[  109.008663]        inet_release+0x31/0x60
[  109.010175]        __sock_release+0x3a/0xc0
[  109.011778]        sock_close+0x14/0x20
[  109.013263]        __fput+0xee/0x2c0
[  109.014673]        delayed_fput+0x31/0x50
[  109.016183]        process_one_work+0x20e/0x630
[  109.017897]        worker_thread+0x184/0x330
[  109.019543]        kthread+0x10a/0x250
[  109.020929]        ret_from_fork+0x297/0x300
[  109.022565]        ret_from_fork_asm+0x1a/0x30
[  109.024194]
               -> #1 (sk_lock-AF_INET-NVME){+.+.}-{0:0}:
[  109.026634]        lock_sock_nested+0x2e/0x70
[  109.028251]        tcp_sendmsg+0x1a/0x40
[  109.029783]        sock_sendmsg+0xed/0x110
[  109.031321]        nvme_tcp_try_send_cmd_pdu+0x13e/0x260 [nvme_tcp]
[  109.034263]        nvme_tcp_try_send+0xb3/0x330 [nvme_tcp]
[  109.036375]        nvme_tcp_queue_rq+0x342/0x3d0 [nvme_tcp]
[  109.038528]        blk_mq_dispatch_rq_list+0x297/0x800
[  109.040448]        __blk_mq_sched_dispatch_requests+0x3db/0x5f0
[  109.042677]        blk_mq_sched_dispatch_requests+0x29/0x70
[  109.044787]        blk_mq_run_work_fn+0x76/0x1b0
[  109.046535]        process_one_work+0x20e/0x630
[  109.048245]        worker_thread+0x184/0x330
[  109.049890]        kthread+0x10a/0x250
[  109.051331]        ret_from_fork+0x297/0x300
[  109.053024]        ret_from_fork_asm+0x1a/0x30
[  109.054740]
               -> #0 (set->srcu){.+.+}-{0:0}:
[  109.056850]        __lock_acquire+0x1468/0x2210
[  109.058614]        lock_sync+0xa5/0x110
[  109.060048]        __synchronize_srcu+0x49/0x170
[  109.061802]        elevator_switch+0xc9/0x330
[  109.063950]        elevator_change+0x128/0x1c0
[  109.065675]        elevator_set_none+0x4c/0x90
[  109.067316]        blk_unregister_queue+0xa8/0x110
[  109.069165]        __del_gendisk+0x14e/0x3c0
[  109.070824]        del_gendisk+0x75/0xa0
[  109.072328]        nvme_ns_remove+0xf2/0x230 [nvme_core]
[  109.074365]        nvme_remove_namespaces+0xf2/0x150 [nvme_core]
[  109.076652]        nvme_do_delete_ctrl+0x71/0x90 [nvme_core]
[  109.078775]        nvme_delete_ctrl_sync+0x3b/0x50 [nvme_core]
[  109.081009]        nvme_sysfs_delete+0x34/0x40 [nvme_core]
[  109.083082]        kernfs_fop_write_iter+0x16a/0x220
[  109.085009]        vfs_write+0x378/0x520
[  109.086539]        ksys_write+0x67/0xe0
[  109.087982]        do_syscall_64+0x76/0xbb0
[  109.089577]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  109.091665]
               other info that might help us debug this:

[  109.095478] Chain exists of:
                 set->srcu --> &q->q_usage_counter(io) --> &q->elevator_lock

[  109.099544]  Possible unsafe locking scenario:

[  109.101708]        CPU0                    CPU1
[  109.103402]        ----                    ----
[  109.105103]   lock(&q->elevator_lock);
[  109.106530]                                lock(&q->q_usage_counter(io));
[  109.109022]                                lock(&q->elevator_lock);
[  109.111391]   sync(set->srcu);
[  109.112586]
                *** DEADLOCK ***

[  109.114772] 5 locks held by nvme/2734:
[  109.116189]  #0: ffff888101925410 (sb_writers#4){.+.+}-{0:0}, at: ksys_write+0x67/0xe0
[  109.119143]  #1: ffff88817a914e88 (&of->mutex#2){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x10f/0x220
[  109.123141]  #2: ffff8881046313f8 (kn->active#185){++++}-{0:0}, at: sysfs_remove_file_self+0x26/0x50
[  109.126543]  #3: ffff88810470e1d0 (&set->update_nr_hwq_lock){++++}-{4:4}, at: del_gendisk+0x6d/0xa0
[  109.129891]  #4: ffff88813abea198 (&q->elevator_lock){+.+.}-{4:4}, at: elevator_change+0xa8/0x1c0
[  109.133149]
               stack backtrace:
[  109.134817] CPU: 6 UID: 0 PID: 2734 Comm: nvme Tainted: G                 N  6.17.0nvme+ #3 PREEMPT(voluntary)
[  109.134819] Tainted: [N]=TEST
[  109.134820] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[  109.134821] Call Trace:
[  109.134823]  <TASK>
[  109.134824]  dump_stack_lvl+0x75/0xb0
[  109.134828]  print_circular_bug+0x26a/0x330
[  109.134831]  check_noncircular+0x12f/0x150
[  109.134834]  __lock_acquire+0x1468/0x2210
[  109.134837]  ? __synchronize_srcu+0x17/0x170
[  109.134838]  lock_sync+0xa5/0x110
[  109.134840]  ? __synchronize_srcu+0x17/0x170
[  109.134842]  __synchronize_srcu+0x49/0x170
[  109.134843]  ? mark_held_locks+0x49/0x80
[  109.134845]  ? _raw_spin_unlock_irqrestore+0x2d/0x60
[  109.134847]  ? kvm_clock_get_cycles+0x14/0x30
[  109.134853]  ? ktime_get_mono_fast_ns+0x36/0xb0
[  109.134858]  elevator_switch+0xc9/0x330
[  109.134860]  elevator_change+0x128/0x1c0
[  109.134862]  ? kernfs_put.part.0+0x86/0x290
[  109.134864]  elevator_set_none+0x4c/0x90
[  109.134866]  blk_unregister_queue+0xa8/0x110
[  109.134868]  __del_gendisk+0x14e/0x3c0
[  109.134870]  del_gendisk+0x75/0xa0
[  109.134872]  nvme_ns_remove+0xf2/0x230 [nvme_core]
[  109.134879]  nvme_remove_namespaces+0xf2/0x150 [nvme_core]
[  109.134887]  nvme_do_delete_ctrl+0x71/0x90 [nvme_core]
[  109.134893]  nvme_delete_ctrl_sync+0x3b/0x50 [nvme_core]
[  109.134899]  nvme_sysfs_delete+0x34/0x40 [nvme_core]
[  109.134905]  kernfs_fop_write_iter+0x16a/0x220
[  109.134908]  vfs_write+0x378/0x520
[  109.134911]  ksys_write+0x67/0xe0
[  109.134913]  do_syscall_64+0x76/0xbb0
[  109.134915]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  109.134916] RIP: 0033:0x7fd68a737317
[  109.134917] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  109.134919] RSP: 002b:00007ffded1546d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  109.134920] RAX: ffffffffffffffda RBX: 000000000054f7e0 RCX: 00007fd68a737317
[  109.134921] RDX: 0000000000000001 RSI: 00007fd68a855719 RDI: 0000000000000003
[  109.134921] RBP: 0000000000000003 R08: 0000000030407850 R09: 00007fd68a7cd4e0
[  109.134922] R10: 00007fd68a65b130 R11: 0000000000000246 R12: 00007fd68a855719
[  109.134923] R13: 00000000304074c0 R14: 00000000304074c0 R15: 0000000030408660
[  109.134926]  </TASK>
[  109.962756] Key type psk unregistered

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis

### Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem is `nvme-tcp` under
`drivers/nvme/host/tcp.c`; action is a fix for teardown circular
locking. Claimed intent is to make socket teardown synchronous during
reset and use a NOIO allocation scope during socket release.

Step 1.2 Record: candidate tags present are:
- `Reviewed-by: Christoph Hellwig <hch@lst.de>`
- `Reviewed-by: Sagi Grimberg <sagi@grimberg.me>`
- `Reviewed-by: Hannes Reinecke <hare@suse.de>`
- `Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>`
- `Signed-off-by: Keith Busch <kbusch@kernel.org>`

No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable`, or `Link:` tag
is present in the supplied commit message. `b4 am` additionally found
review trailers from Hannes Reinecke, Daniel Wagner, and Nilay Shroff on
the v4 thread.

Step 1.3 Record: the commit describes a real reset-time race and lockdep
issue. The verified reproducer is `nvme_trtype=tcp ./check nvme/005`.
The supplied dmesg shows a “possible circular locking dependency
detected” involving `set->srcu`, `q->elevator_lock`, `fs_reclaim`, and
NVMe/TCP socket teardown through `delayed_fput`. The root cause is that
`fput()` defers `__fput()` and `memalloc_noreclaim_save()` does not
strip `__GFP_IO`.

Step 1.4 Record: this is not merely cleanup. It is a synchronization and
deadlock-prevention fix, with a claimed possible UAF/resource conflict
from deferred socket release. The UAF aspect is verified as
author/reviewer rationale, while the lockdep circular dependency is
directly backed by the reported trace.

### Phase 2: Diff Analysis
Step 2.1 Record: one file changed: `drivers/nvme/host/tcp.c`, 21
insertions and 7 deletions in the v4 patch. Functions modified:
`nvme_tcp_free_queue()` and the `err_sock` path in
`nvme_tcp_alloc_queue()`. Scope is a single-file surgical driver fix.

Step 2.2 Record:
- In `nvme_tcp_free_queue()`, before: drain page fragments, enter
  `memalloc_noreclaim_save()`, call deferred `fput()`, clear
  `queue->sock`, restore noreclaim. After: enter `memalloc_noio_save()`,
  call `__fput_sync()`, clear `queue->sock`, restore NOIO.
- In `nvme_tcp_alloc_queue()` error handling, before: failed queue setup
  used `fput()`. After: it uses `__fput_sync()`.

Step 2.3 Record: bug categories are race condition, lockdep/deadlock
prevention, and allocation-context correctness. The race mechanism is
deferred file/socket destruction via `fput()` while reset immediately
re-enters queue setup. The deadlock mechanism is socket close allocating
memory with I/O allowed while block teardown paths hold locks.

Step 2.4 Record: the fix is minimal and understandable. Risk is low to
medium: `__fput_sync()` is intentionally special-purpose and
`fs/file_table.c` warns not to blindly convert callers, but here the
code has a concrete need and subsystem reviewers accepted it.
`memalloc_noio_save()` is the right primitive for suppressing
`__GFP_IO|__GFP_FS`, verified in `include/linux/sched/mm.h`.

### Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows:
- `nvme_tcp_free_queue()` dates to `3f2304f8c6d6` (“nvme-tcp: add NVMe
  over TCP host driver”), described as first contained around
  `v5.0-rc1`.
- `memalloc_noreclaim_save()` in this area came from `83e1226b0ee2`
  (“nvme-tcp: fix possible circular locking when deleting a controller
  under memory pressure”), first contained around `v6.1-rc3`.
- `fput(queue->sock->file)` came from `e40d4eb84089` (“nvme-tcp:
  allocate socket file”), first contained around `v6.7-rc1`.

Step 3.2 Record: no `Fixes:` tag in the candidate. I inspected related
commits instead. `83e1226b0ee2` fixed an earlier lockdep circular
locking report by adding `memalloc_noreclaim_save()`, but this candidate
corrects that to `memalloc_noio_save()` for the newer lock chain.
`e40d4eb84089` introduced socket files for TLS upcalls and therefore the
`fput()` path.

Step 3.3 Record: recent file history shows active NVMe/TCP maintenance,
including queue teardown, TLS, request handling, and UAF/race fixes. No
required multi-patch series dependency was found for the exact current-
tree patch.

Step 3.4 Record: Chaitanya Kulkarni has multiple recent NVMe/block fixes
in `drivers/nvme/host`; the strongest quality signal is that Christoph
Hellwig, Sagi Grimberg, Hannes Reinecke, Daniel Wagner, and Nilay Shroff
reviewed/tested or reviewed the patch thread.

Step 3.5 Record: dependencies are existing core APIs: `__fput_sync()` is
exported in `fs/file_table.c`, and `memalloc_noio_save()` is available
in `include/linux/sched/mm.h`. For older stable branches, the exact
`fput(queue->sock->file)` part only exists where `e40d4eb84089` is
present.

### Phase 4: Mailing List And External Research
Step 4.1 Record: I could not use `b4 dig -c` because the exact applied
commit hash was not present in local `master`, `linus-next/master`,
`storage-next`, or `pending-7.0`; `b4 dig` only accepts a commitish. I
used the message-id with `b4 am -c`, which found the v4 patch at
`https://patch.msgid.link/20260413171628.6204-1-kch@nvidia.com`.

Step 4.2 Record: original recipients/reviewers verified from the raw
thread: To `kbusch`, `sagi`; Cc `hch`, `linux-nvme`. Review trailers
found: Christoph Hellwig, Sagi Grimberg, Hannes Reinecke, Daniel Wagner,
Nilay Shroff. Keith Busch replied “applied to nvme-7.1”.

Step 4.3 Record: no syzbot/bugzilla report. The bug report evidence is
the included blktests `nvme/005` failure and lockdep trace. Daniel
Wagner replied that he tested locally with blktests and it passed,
though he could not reproduce the original failure.

Step 4.4 Record: patch evolution was v2 to v3 to v4. v2 only converted
`fput()` to `__fput_sync()`. v3 added the `memalloc_noio_save()` change
after feedback from Nilay/Christoph/Hannes. v4 rebased/retested and
added review tags. No NAKs found.

Step 4.5 Record: direct lore stable search was blocked by Anubis; web
search did not find stable-specific objections or a known reason to
avoid stable.

### Phase 5: Code Semantic Analysis
Step 5.1 Record: key functions modified are `nvme_tcp_free_queue()` and
`nvme_tcp_alloc_queue()`.

Step 5.2 Record: callers verified:
- `nvme_tcp_free_admin_queue()` calls `nvme_tcp_free_queue(ctrl, 0)`.
- `nvme_tcp_free_io_queues()` calls `nvme_tcp_free_queue()` for I/O
  queues.
- `nvme_tcp_teardown_ctrl()` calls I/O teardown then admin teardown.
- `nvme_reset_ctrl_work()` calls `nvme_tcp_teardown_ctrl()` followed
  immediately by `nvme_tcp_setup_ctrl()`.
- `nvme_sysfs_reset()` calls `nvme_reset_ctrl_sync()`, which queues and
  flushes `ctrl->reset_work`.

Step 5.3 Record: important callees are `fput()`/`__fput_sync()`, socket
close through `__fput()`, `tcp_close()`, `tcp_disconnect()`, and
allocations in `tcp_send_active_reset()` as shown in the trace.
`current_gfp_context()` strips `__GFP_IO|__GFP_FS` only for
`PF_MEMALLOC_NOIO`, not plain `PF_MEMALLOC`.

Step 5.4 Record: reachability is real. The reset path is reachable from
writable sysfs `reset_controller` and from NVMe reset ioctl paths; both
are privileged/admin operations. The send-side lock chain is reachable
through normal NVMe/TCP block I/O via `nvme_tcp_queue_rq()` ->
`nvme_tcp_queue_request()` -> workqueue send.

Step 5.5 Record: related pattern found: prior `83e1226b0ee2` was also an
NVMe/TCP circular locking fix around socket teardown under memory
pressure. No prior `__fput_sync()` fix in `drivers/nvme/host/tcp.c`
history was found.

### Phase 6: Stable Tree Analysis
Step 6.1 Record:
- `stable/linux-6.12.y`, `6.17.y`, `6.18.y`, `6.19.y`, and `7.0.y`
  contain `sock_alloc_file()`, `fput(queue->sock->file)`, and
  `memalloc_noreclaim_save()`, so they contain the exact bug pattern.
- `stable/linux-6.1.y` and `6.6.y` contain the
  `memalloc_noreclaim_save()` plus `sock_release(queue->sock)` teardown
  pattern, so the NOIO part is relevant but the exact `fput()` hunk does
  not apply.
- `stable/linux-5.10.y` and `5.15.y` in this repo did not show the
  specific `memalloc_noreclaim_save()` or `fput(queue->sock->file)`
  patterns.

Step 6.2 Record: `git apply --check` succeeds on the current `7.0.y`
checkout. Raw v4 patch does not apply cleanly to `6.12.y`, `6.6.y`, or
`5.10.y` test worktrees; `6.12.y` has the bug pattern but nearby context
differs, while `6.6.y`/`5.10.y` lack the `fput(queue->sock->file)` form.
Expected backport difficulty is clean for current 7.0, minor rework for
6.12+, and adapted/no partial backport for older branches.

Step 6.3 Record: related fix already in current history is
`83e1226b0ee2`; this candidate is a follow-up/correction rather than a
duplicate. I found no alternate `__fput_sync()` fix already in this file
history.

### Phase 7: Subsystem Context
Step 7.1 Record: subsystem is NVMe/TCP host driver, in storage/block.
Criticality is IMPORTANT: driver-specific, but it backs real block
devices and can affect I/O availability and teardown/reset reliability.

Step 7.2 Record: subsystem is active; recent `drivers/nvme/host/tcp.c`
history includes TLS, queue removal, congestion, stalls, UAF, and
failover fixes.

### Phase 8: Impact And Risk
Step 8.1 Record: affected users are systems using NVMe over TCP,
especially during controller reset/delete/reconnect or tests like
blktests `nvme/005`.

Step 8.2 Record: trigger is privileged/admin reset via sysfs or ioctl,
and teardown/delete paths. The I/O lock chain involves normal NVMe/TCP
request submission, but initiating reset/delete is not unprivileged in
the verified paths.

Step 8.3 Record: failure mode is at least HIGH and plausibly CRITICAL:
verified lockdep circular dependency with a possible deadlock scenario,
I/O failures in the reproducer trace, and a reviewed claim of possible
UAF/resource conflict from deferred socket cleanup.

Step 8.4 Record: benefit is high for affected NVMe/TCP stable users
because it prevents reset/teardown races and circular locking. Risk is
low-medium because the patch changes teardown/error paths only, is
small, and has strong review, though `__fput_sync()` is a sensitive
primitive.

### Phase 9: Final Synthesis
Step 9.1 Record:
Evidence for backporting: real reproduced lockdep issue, concrete
blktests reproducer, small single-file fix, no new API or feature,
strong subsystem review, exact bug pattern present in active stable
trees from 6.12+ and current 7.0.
Evidence against: exact patch does not apply to some older stable trees;
older branches need adaptation or may not contain the same bug pattern.
`__fput_sync()` has general cautionary documentation.
Unresolved: no applied upstream commit hash available locally, so `b4
dig -c` could not be performed; no direct stable-list discussion could
be fetched due lore Anubis.

Step 9.2 Record:
1. Obviously correct and tested: yes, based on direct code inspection,
   blktests discussion, and review/test replies.
2. Fixes a real bug: yes, verified lockdep circular dependency and reset
   teardown race.
3. Important issue: yes, possible deadlock/hang during NVMe/TCP
   reset/teardown.
4. Small and contained: yes, one file and two localized hunks.
5. No new features/APIs: yes.
6. Can apply to stable: yes for current 7.0; needs minor/adapted
   backports for some older branches.

Step 9.3 Record: no exception category such as device ID, quirk, DT,
build, or docs applies.

Step 9.4 Record: this should be backported to stable trees that contain
the affected NVMe/TCP socket-file teardown path, with branch-specific
adjustment where necessary.

## Verification
- Phase 1: Parsed supplied tags and verified additional review trailers
  via `b4 am -c`.
- Phase 2: Verified diff scope from v4 patch: `drivers/nvme/host/tcp.c`,
  21 insertions, 7 deletions.
- Phase 3: Ran `git blame` on both changed areas; identified
  `83e1226b0ee2`, `e40d4eb84089`, and `3f2304f8c6d6`.
- Phase 3: Ran `git show` on `83e1226b0ee2` and `e40d4eb84089`;
  confirmed prior circular-locking context and socket-file introduction.
- Phase 4: Fetched v2, v3, and v4 threads from public mirrors; verified
  reviewer feedback and no NAKs.
- Phase 5: Read `nvme_reset_ctrl_work()`, queue teardown/setup
  functions, sysfs reset, and `nvme_reset_ctrl_sync()` to verify
  reachability.
- Phase 5: Read `fs/file_table.c` and `include/linux/sched/mm.h` to
  verify `fput()` deferral, `__fput_sync()`, and NOIO semantics.
- Phase 6: Checked stable branch code patterns for `5.10.y`, `5.15.y`,
  `6.1.y`, `6.6.y`, `6.12.y`, `6.17.y`, `6.18.y`, `6.19.y`, and `7.0.y`.
- Phase 6: Ran `git apply --check`; current `7.0.y` applies, older
  tested branches need rework or lack exact context.
- Unverified: exact applied upstream commit hash was not available
  locally, so `b4 dig -c`, `b4 dig -a`, and `b4 dig -w` could not be
  run.

**YES**

 drivers/nvme/host/tcp.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 02c95c32b07e3..15d36d6a728e8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1438,18 +1438,32 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
-	unsigned int noreclaim_flag;
+	unsigned int noio_flag;
 
 	if (!test_and_clear_bit(NVME_TCP_Q_ALLOCATED, &queue->flags))
 		return;
 
 	page_frag_cache_drain(&queue->pf_cache);
 
-	noreclaim_flag = memalloc_noreclaim_save();
-	/* ->sock will be released by fput() */
-	fput(queue->sock->file);
+	/**
+	 * Prevent memory reclaim from triggering block I/O during socket
+	 * teardown. The socket release path fput -> tcp_close ->
+	 * tcp_disconnect -> tcp_send_active_reset may allocate memory, and
+	 * allowing reclaim to issue I/O could deadlock if we're being called
+	 * from block device teardown (e.g., del_gendisk -> elevator cleanup)
+	 * which holds locks that the I/O completion path needs.
+	 */
+	noio_flag = memalloc_noio_save();
+
+	/**
+	 * Release the socket synchronously. During reset in
+	 * nvme_reset_ctrl_work(), queue teardown is immediately followed by
+	 * re-allocation. fput() defers socket cleanup to delayed_fput_work
+	 * in workqueue context, which can race with new queue setup.
+	 */
+	__fput_sync(queue->sock->file);
 	queue->sock = NULL;
-	memalloc_noreclaim_restore(noreclaim_flag);
+	memalloc_noio_restore(noio_flag);
 
 	kfree(queue->pdu);
 	mutex_destroy(&queue->send_mutex);
@@ -1901,8 +1915,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 err_rcv_pdu:
 	kfree(queue->pdu);
 err_sock:
-	/* ->sock will be released by fput() */
-	fput(queue->sock->file);
+	/* Use sync variant - see nvme_tcp_free_queue() for explanation */
+	__fput_sync(queue->sock->file);
 	queue->sock = NULL;
 err_destroy_mutex:
 	mutex_destroy(&queue->send_mutex);
-- 
2.53.0

