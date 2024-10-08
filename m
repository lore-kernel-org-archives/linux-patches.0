Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98CE1DA60C;
	Tue,  8 Oct 2024 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389626; cv=none; b=mXgu1UM0kEnp90IGaAQ8+8dpolERZNQQoyTeyIiozyrTxRa7f/lPnGEILnkqnMcpsD24BqWilHPI2nqGW/q8TK624lJNWGmN1uyTA2O6nXT20KUQbg4RPHSL7YMUL9uHgfx2FsXQLPe1m9BOLirY0dRif6v0friRa0WB6trfHG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389626; c=relaxed/simple;
	bh=90XqiSIL8RE/vKE9B1yNLS9BX8CNNeOjGc1SasQzv8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV4YbpNq+zQWujEAFqnox6sYDW6oQJJEONINrqORPRFnGLjAcoFD1r3oUu/GI0P7QW4VvCuMfaJmWXi1clVW5nReBxFfVdAxRhuIs9vA/S52USRaV/ipEv6yfuIitMMKu3vyVmeJozSSB5wJSNbILIJNBN1MsEyQnSgrgLwXNlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKsJVfDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKsJVfDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55920C4CECC;
	Tue,  8 Oct 2024 12:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389625;
	bh=90XqiSIL8RE/vKE9B1yNLS9BX8CNNeOjGc1SasQzv8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKsJVfDbS+TQch2Lv9jb/VGLTN9g/oJiysst1vNWxrKbTblwG+s+fo/bU4LCfdSLK
	 w1c72YHKzXigg7Y+NhJc7bqfwkJktdGnuNsjlrLPrtqd1upeZ5bsrU+vmI48kmHc/6
	 aKmKSyiRpIDUbcN4pqWa8L1ViIjDlAyECOKZCMxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/482] net/mlx5e: Fix crash caused by calling __xfrm_state_delete() twice
Date: Tue,  8 Oct 2024 14:01:24 +0200
Message-ID: <20241008115649.133707235@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 7b124695db40d5c9c5295a94ae928a8d67a01c3d ]

The km.state is not checked in driver's delayed work. When
xfrm_state_check_expire() is called, the state can be reset to
XFRM_STATE_EXPIRED, even if it is XFRM_STATE_DEAD already. This
happens when xfrm state is deleted, but not freed yet. As
__xfrm_state_delete() is called again in xfrm timer, the following
crash occurs.

To fix this issue, skip xfrm_state_check_expire() if km.state is not
XFRM_STATE_VALID.

 Oops: general protection fault, probably for non-canonical address 0xdead000000000108: 0000 [#1] SMP
 CPU: 5 UID: 0 PID: 7448 Comm: kworker/u102:2 Not tainted 6.11.0-rc2+ #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Workqueue: mlx5e_ipsec: eth%d mlx5e_ipsec_handle_sw_limits [mlx5_core]
 RIP: 0010:__xfrm_state_delete+0x3d/0x1b0
 Code: 0f 84 8b 01 00 00 48 89 fd c6 87 c8 00 00 00 05 48 8d bb 40 10 00 00 e8 11 04 1a 00 48 8b 95 b8 00 00 00 48 8b 85 c0 00 00 00 <48> 89 42 08 48 89 10 48 8b 55 10 48 b8 00 01 00 00 00 00 ad de 48
 RSP: 0018:ffff88885f945ec8 EFLAGS: 00010246
 RAX: dead000000000122 RBX: ffffffff82afa940 RCX: 0000000000000036
 RDX: dead000000000100 RSI: 0000000000000000 RDI: ffffffff82afb980
 RBP: ffff888109a20340 R08: ffff88885f945ea0 R09: 0000000000000000
 R10: 0000000000000000 R11: ffff88885f945ff8 R12: 0000000000000246
 R13: ffff888109a20340 R14: ffff88885f95f420 R15: ffff88885f95f400
 FS:  0000000000000000(0000) GS:ffff88885f940000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f2163102430 CR3: 00000001128d6001 CR4: 0000000000370eb0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  ? die_addr+0x33/0x90
  ? exc_general_protection+0x1a2/0x390
  ? asm_exc_general_protection+0x22/0x30
  ? __xfrm_state_delete+0x3d/0x1b0
  ? __xfrm_state_delete+0x2f/0x1b0
  xfrm_timer_handler+0x174/0x350
  ? __xfrm_state_delete+0x1b0/0x1b0
  __hrtimer_run_queues+0x121/0x270
  hrtimer_run_softirq+0x88/0xd0
  handle_softirqs+0xcc/0x270
  do_softirq+0x3c/0x50
  </IRQ>
  <TASK>
  __local_bh_enable_ip+0x47/0x50
  mlx5e_ipsec_handle_sw_limits+0x7d/0x90 [mlx5_core]
  process_one_work+0x137/0x2d0
  worker_thread+0x28d/0x3a0
  ? rescuer_thread+0x480/0x480
  kthread+0xb8/0xe0
  ? kthread_park+0x80/0x80
  ret_from_fork+0x2d/0x50
  ? kthread_park+0x80/0x80
  ret_from_fork_asm+0x11/0x20
  </TASK>

Fixes: b2f7b01d36a9 ("net/mlx5e: Simulate missing IPsec TX limits hardware functionality")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3d274599015be..ca92e518be766 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -67,7 +67,6 @@ static void mlx5e_ipsec_handle_sw_limits(struct work_struct *_work)
 		return;
 
 	spin_lock_bh(&x->lock);
-	xfrm_state_check_expire(x);
 	if (x->km.state == XFRM_STATE_EXPIRED) {
 		sa_entry->attrs.drop = true;
 		spin_unlock_bh(&x->lock);
@@ -75,6 +74,13 @@ static void mlx5e_ipsec_handle_sw_limits(struct work_struct *_work)
 		mlx5e_accel_ipsec_fs_modify(sa_entry);
 		return;
 	}
+
+	if (x->km.state != XFRM_STATE_VALID) {
+		spin_unlock_bh(&x->lock);
+		return;
+	}
+
+	xfrm_state_check_expire(x);
 	spin_unlock_bh(&x->lock);
 
 	queue_delayed_work(sa_entry->ipsec->wq, &dwork->dwork,
-- 
2.43.0



