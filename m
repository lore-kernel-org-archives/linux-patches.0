Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60183BC666;
	Mon, 23 Mar 2026 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283361; cv=none; b=QT6NeKmwQrgJG65EHcH26nF0n3lNqt+ko2XWWxx1Yg9bvhZI5HuXgqHEH1/riL8MgkUyQtCKcXOHjzYSF+Sm9gXzGMgoPsbWVbUxuPhhrKS6z2lkS5R3ImPXiwCCZHQxDmFfJ0o3J6Pi0AggsLiBC6AAeOwA469UgFSveTjQt0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283361; c=relaxed/simple;
	bh=paEX3DabM3vKS9FUF1cBv73PIJI1Z+t1iFAyjzOEIF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSvNYca8wstoVaQTdk93GvSvk+UPBFpPzAIK48Qq0sdsQKTKrDtQ2CagK2o85ZdeWzBrSEshrFLu4yDdzlL7vzc5tYxQpxymIk7foasFKo+93kHCPFk/JIGb/N3UXNsqEJWY6ZVyoOMc8IgG1+GS6ynRMXsU3baI3nitIlNfagA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViMgJJww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViMgJJww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388E7C4CEF7;
	Mon, 23 Mar 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283361;
	bh=paEX3DabM3vKS9FUF1cBv73PIJI1Z+t1iFAyjzOEIF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViMgJJwwz2Leb2bA6ohnlJXwV4oKC6xbm2wOTLQ12rKmNUCdUOG8qMHoBt/L+mydq
	 6uw5ZR0d4nDhv1Hw+mMXeuYY7cx8DD59Bs24GLIYwzPTCuwc2IgdoeH03zeAT/7/Ro
	 txG1emF7wqdEyHrcq9rCz/0sTZUFjkPnF3ZXLCFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Chen <cachen@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 468/481] nvme: fix admin request_queue lifetime
Date: Mon, 23 Mar 2026 14:47:30 +0100
Message-ID: <20260323134536.623356162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 03b3bcd319b3ab5182bc9aaa0421351572c78ac0 ]

The namespaces can access the controller's admin request_queue, and
stale references on the namespaces may exist after tearing down the
controller. Ensure the admin request_queue is active by moving the
controller's 'put' to after all controller references have been released
to ensure no one is can access the request_queue. This fixes a reported
use-after-free bug:

  BUG: KASAN: slab-use-after-free in blk_queue_enter+0x41c/0x4a0
  Read of size 8 at addr ffff88c0a53819f8 by task nvme/3287
  CPU: 67 UID: 0 PID: 3287 Comm: nvme Tainted: G            E       6.13.2-ga1582f1a031e #15
  Tainted: [E]=UNSIGNED_MODULE
  Hardware name: Jabil /EGS 2S MB1, BIOS 1.00 06/18/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4f/0x60
   print_report+0xc4/0x620
   ? _raw_spin_lock_irqsave+0x70/0xb0
   ? _raw_read_unlock_irqrestore+0x30/0x30
   ? blk_queue_enter+0x41c/0x4a0
   kasan_report+0xab/0xe0
   ? blk_queue_enter+0x41c/0x4a0
   blk_queue_enter+0x41c/0x4a0
   ? __irq_work_queue_local+0x75/0x1d0
   ? blk_queue_start_drain+0x70/0x70
   ? irq_work_queue+0x18/0x20
   ? vprintk_emit.part.0+0x1cc/0x350
   ? wake_up_klogd_work_func+0x60/0x60
   blk_mq_alloc_request+0x2b7/0x6b0
   ? __blk_mq_alloc_requests+0x1060/0x1060
   ? __switch_to+0x5b7/0x1060
   nvme_submit_user_cmd+0xa9/0x330
   nvme_user_cmd.isra.0+0x240/0x3f0
   ? force_sigsegv+0xe0/0xe0
   ? nvme_user_cmd64+0x400/0x400
   ? vfs_fileattr_set+0x9b0/0x9b0
   ? cgroup_update_frozen_flag+0x24/0x1c0
   ? cgroup_leave_frozen+0x204/0x330
   ? nvme_ioctl+0x7c/0x2c0
   blkdev_ioctl+0x1a8/0x4d0
   ? blkdev_common_ioctl+0x1930/0x1930
   ? fdget+0x54/0x380
   __x64_sys_ioctl+0x129/0x190
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f765f703b0b
  Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 52 0f 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffe2cefe808 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007ffe2cefe860 RCX: 00007f765f703b0b
  RDX: 00007ffe2cefe860 RSI: 00000000c0484e41 RDI: 0000000000000003
  RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
  R10: 00007f765f611d50 R11: 0000000000000202 R12: 0000000000000003
  R13: 00000000c0484e41 R14: 0000000000000001 R15: 00007ffe2cefea60
   </TASK>

Reported-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ The context change is due to the commit 2b3f056f72e5
("blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue")
in v6.2 which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5180,6 +5180,8 @@ static void nvme_free_ctrl(struct device
 		container_of(dev, struct nvme_ctrl, ctrl_device);
 	struct nvme_subsystem *subsys = ctrl->subsys;
 
+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 


