Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77610511E6B;
	Wed, 30 Sep 2026 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783459; cv=none; b=DNwZfw/YFupq4mPnfrjxiFtD02La0HrYyKtT/yMdDQr7LXDcGkhGxQe5sOSBf7KmnUqVstHxUPDcr0epp+fUYZBGDwkj9ldnCqjeP+InuaUoo5UzyxqNr6iQ3uTkVpZjjeWelTwoubgyGxHqWxugmK9jarbjV30tmwXsPRMUqNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783459; c=relaxed/simple;
	bh=1E9Ut6QFKi9UGADJ6ItF2BpuFT9jDS9bP1mQmLrGIv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/FbvlmwpkI7q15PDrmsws3+0CojPWZYwsyYkXivi7m2OS37ayawv/xAig2+mR6li7WniPoQ9uoMD6M5eYc0kOhM/hvrwVu5rabpbq3csLi0Z7MGCaHt4EqjzPP2Myx5A2lns0cKbovb6244nLJJhEIMMKTcKncYqdhUyXxH0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJmw9Yb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJmw9Yb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2251F000FF;
	Wed, 30 Sep 2026 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783455;
	bh=N/d8m6TS2vXcFKrDrYxxkFS6dWM/da6oG0FB7PgZoTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJmw9Yb3KNWunolH5bX7Ca+4D+lqIBGZaeP0rbepmUF4kD7K5S17zqSVJ6pydxql6
	 KrbM9SjxZGn4GBqq67Sr1iVizCgZExkmnVCvj8Diu+zlfy3qCM8GGPxIOBMnWdZ53D
	 XAE8T+0DELYv3Y4Y55WFh9NvcY6Wvogm4csxKrG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/595] IB/iser: reject a remote invalidation of an unregistered direction
Date: Wed, 30 Sep 2026 17:24:13 +0200
Message-ID: <20260930152355.421531181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit d85f0f0a7c85756fc992c70d869706f19dac9259 ]

A write command whose data is sent entirely as immediate data is not
registered.  iser_reg_mem_fastreg() takes the DMA key path and leaves
rdma_reg[ISER_DIR_OUT].desc at NULL, while iser_dma_map_task_data() has
already set dir[ISER_DIR_OUT].

iser_check_remote_inv() looks at dir[] alone and hands the descriptor to
iser_inv_desc(), which reads desc->sig_protected.  A target that answers
such a command with IB_WR_SEND_WITH_INV faults the initiator.
Leaving those commands unregistered is deliberate.

The same function already terminates the connection when a target sends
a remote invalidation the initiator did not ask for.  A target that
invalidates a direction that was never registered is in the same class,
so give it the same answer.

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
  CPU: 0 UID: 0 PID: 40 Comm: kworker/u8:2 Not tainted 7.2.0-rc5-ISERHOST-gf5098b6bae76-dirty #3 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: rxe_wq do_work
  RIP: 0010:iser_task_rsp+0x6d6/0xec0
  Code: 48 c1 ea 03 80 3c 02 00 0f 85 ba 06 00 00 48 8b 9b 78 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 76 06 00 00 80 7b 20 00 0f 84 3d 04
  RSP: 0018:ffff88811b008db8 EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000001848
  RDX: 0000000000000004 RSI: 1ffff11021587b12 RDI: 0000000000000020
  RBP: ffff88810adc1ae4 R08: ffff888109b7f860 R09: ffffffff90a922c0
  R10: ffff88810adc1a1c R11: 000000000000003c R12: ffff888109b7f800
  R13: ffff88810adc1acc R14: ffff888109b7f820 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88818a676000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000005afe2b CR3: 000000010af23005 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   __ib_process_cq+0xe1/0x390
   ib_poll_handler+0x6e/0x200
   irq_poll_softirq+0x1df/0x480
   ? clockevents_program_event+0x2ba/0x860
   ? __pfx_irq_poll_softirq+0x10/0x10
   handle_softirqs+0x18e/0x590
   ? __pfx_handle_softirqs+0x10/0x10
   ? __hrtimer_rearm_deferred+0x156/0x450
   do_softirq+0x3b/0x60
   </IRQ>
   <TASK>
   __local_bh_enable_ip+0x61/0x70
   __alloc_skb+0x732/0x890
   ? _raw_spin_lock_irqsave+0x85/0xe0
   ? __pfx___alloc_skb+0x10/0x10
   ? _raw_read_unlock_irqrestore+0x16/0x50
   rxe_init_packet+0x16b/0x4f0
   prepare_ack_packet+0xb8/0x830
   rxe_receiver+0x499/0x9980
   ? __pfx_rxe_receiver+0x10/0x10
   ? rxe_completer+0x29e5/0x38c0
   ? hrtimer_start_range_ns_common+0x75f/0x1730
   ? hrtimer_start_range_ns+0xa6/0x2c0
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? __pfx_rxe_receiver+0x10/0x10
   do_work+0x144/0x470
   process_one_work+0x633/0x1030
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c6/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Modules linked in:
  ---[ end trace 0000000000000000 ]---

Fixes: 59caaed7a72a ("IB/iser: Support the remote invalidation exception")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260819010804.641772-1-yhlee@isslab.korea.ac.kr
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 351f1db394f1c..2b720b00a4cfa 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -613,11 +613,8 @@ static int iser_check_remote_inv(struct iser_conn *iser_conn, struct ib_wc *wc,
 		iser_dbg("conn %p: remote invalidation for rkey %#x\n",
 			 iser_conn, rkey);
 
-		if (unlikely(!iser_conn->snd_w_inv)) {
-			iser_err("conn %p: unexpected remote invalidation, terminating connection\n",
-				 iser_conn);
-			return -EPROTO;
-		}
+		if (unlikely(!iser_conn->snd_w_inv))
+			goto bad_inv;
 
 		task = iscsi_itt_to_ctask(iser_conn->iscsi_conn, hdr->itt);
 		if (likely(task)) {
@@ -626,12 +623,16 @@ static int iser_check_remote_inv(struct iser_conn *iser_conn, struct ib_wc *wc,
 
 			if (iser_task->dir[ISER_DIR_IN]) {
 				desc = iser_task->rdma_reg[ISER_DIR_IN].desc;
+				if (unlikely(!desc))
+					goto bad_inv;
 				if (unlikely(iser_inv_desc(desc, rkey)))
 					return -EINVAL;
 			}
 
 			if (iser_task->dir[ISER_DIR_OUT]) {
 				desc = iser_task->rdma_reg[ISER_DIR_OUT].desc;
+				if (unlikely(!desc))
+					goto bad_inv;
 				if (unlikely(iser_inv_desc(desc, rkey)))
 					return -EINVAL;
 			}
@@ -642,6 +643,11 @@ static int iser_check_remote_inv(struct iser_conn *iser_conn, struct ib_wc *wc,
 	}
 
 	return 0;
+
+bad_inv:
+	iser_err("conn %p: unexpected remote invalidation, terminating connection\n",
+		 iser_conn);
+	return -EPROTO;
 }
 
 
-- 
2.53.0



