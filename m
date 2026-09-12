Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B1737EFE5;
	Sat, 12 Sep 2026 19:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243076; cv=none; b=iay/I0mF/OEfHIZetWQjap9Bn+w8EQ0ye9ZFbNfYMyKku97ZwNa5j6f1/Jxb6tTkyGG6P0YRJqkg19LRxckgkqIY3c150mRxeKVMm2533uWpDjHMioPR2tY4YsUB0mcbnRpNrIyW5pJfLG+NMIxEof1L5Gx/3cOaK5eB1ZueGLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243076; c=relaxed/simple;
	bh=zm6WUa2cV7qxPjKR0bmC/eb4yoENSzKRvFF9S97joE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRNGeHWWhSg7QoP6bbt1OEbW2MNUxEmqgBdMghiWkO0R9eANbhXsXVWQz6eW16DXUM0bammKjUz7z1teXEc+89dMCC83kt+nLCNdby4Sw2+Eo3wogt2Chr1vrKLymerpeiMYTKu6BWkTjNo06yrBmALgFNjsJBIZNxHKkmHOQbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5GfbxKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5GfbxKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A1E1F000FF;
	Sat, 12 Sep 2026 19:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243075;
	bh=0gumhbTfPuk63j3sfPLpuJx8S6HLbsxE7QuQIRZLQ4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5GfbxKyJ6thiRcT1hZJlIVrgmJ5GytgnSqVL29PwFdHxpr2LPuxeyehWZfyFnUxn
	 vWDbCr1EkyO9fZNBTgTcsh7VqWf1aP/YSOHKwZg66kwrFINAggyIL9h471qELsIKGx
	 X0AYVRRI+LKLWXFwUqz1nBgC2Bt+WN3gcLyg9iMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 628/798] IB/isert: delay the final Login Response until the session is registered
Date: Sat, 12 Sep 2026 09:04:16 +0200
Message-ID: <20260912065531.518127968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

[ Upstream commit 464f5afa92d071a226f88424803b0fcf88093ede ]

isert_put_login_tx() puts the final Login Response on the wire before
__transport_register_session(), which iscsi_post_login_handler() reaches
only after iscsi_target_do_login() returns.  An initiator that issues a
SCSI command as soon as it sees that response can have it executed against
an se_session whose se_tpg is still NULL, and the ib-comp-wq worker oopses
on the NULL dereference.

 Oops: general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f]
 CPU: 0 UID: 0 PID: 178 Comm: kworker/0:1H Not tainted 7.2.0-rc5-V2CTL-gf5098b6bae76 #10 PREEMPT(lazy)
 Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: ib-comp-wq ib_cq_poll_work
 RIP: 0010:target_submit+0xbe/0x390
 Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 89 02 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 64 24 18 49 8d 7c 24 78 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 5a 02 00 00 48 8d 7b 78 4d 8b 6c 24 78 48 b8 00
 RSP: 0018:ffff8881058cfa78 EFLAGS: 00010206
 RAX: dffffc0000000000 RBX: ffff88810c78c6f0 RCX: ffffffff964bb363
 RDX: 000000000000000f RSI: 00000000fffffe00 RDI: 0000000000000078
 RBP: 1ffff11020b19f52 R08: 0000000000000001 R09: ffffed1020b19f52
 R10: 0000000000000003 R11: ffff88810596c000 R12: 0000000000000000
 R13: ffff88810c61b000 R14: ffff88810c6a3400 R15: ffff88810c61b044
 FS:  0000000000000000(0000) GS:ffff8881822b2000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f1f1b83c000 CR3: 000000006fe72001 CR4: 0000000000770ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? __pfx__raw_spin_lock_bh+0x10/0x10
  ? __pfx_target_submit+0x10/0x10
  ? mutex_lock+0x81/0xe0
  ? __pfx_mutex_lock+0x10/0x10
  ? iscsit_execute_cmd+0x650/0x850
  iscsit_sequence_cmd+0x186/0x3d0
  iscsit_process_scsi_cmd+0x87/0x300
  isert_recv_done+0x1002/0x2390
  ? __pfx_isert_recv_done+0x10/0x10
  ? rxe_poll_cq+0x253/0x3d0
  ? finish_task_switch.isra.0+0x1dc/0xa70
  __ib_process_cq+0xe1/0x390
  ib_cq_poll_work+0x46/0x150
  process_one_work+0x633/0x1030
  ? assign_work+0x11d/0x370
  worker_thread+0x45b/0xd10
  ? __pfx_worker_thread+0x10/0x10
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

Delay the final Login Response instead.  isert_get_rx_pdu() runs from
iscsi_target_rx_thread() after conn->rx_login_comp, completed by
iscsi_post_login_handler() after __transport_register_session(); iscsi-TCP
and cxgbit already take PDUs from that thread, isert alone does not.  The
buffers are still posted first, so the initiator's first command does not
meet an empty receive queue and nothing depends on RNR flow control, and
the header and payload live in isert_conn, not in the struct iscsi_login
that iscsi_target_nego_release() frees first.

Over rxe, 400 login cycles per run, the oops appeared in 10 of 20
unpatched runs and in none of 20 runs with this patch.  An
initiator that never waits is handled by the next patch.

Not tested: iWARP, discovery sessions over iSER, and real HCAs.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260731041212.1733364-1-yhlee@isslab.korea.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 20 ++++++++++++++++++--
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index c2f789edd200d..0b624c1f6d737 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -58,6 +58,8 @@ static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_send_done(struct ib_cq *cq, struct ib_wc *wc);
+static void isert_unmap_tx_desc(struct iser_tx_desc *tx_desc,
+				struct ib_device *ib_dev);
 
 static int isert_sg_tablesize_set(const char *val, const struct kernel_param *kp)
 {
@@ -500,6 +502,8 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->qp)
 		isert_destroy_qp(isert_conn);
 
+	isert_unmap_tx_desc(&isert_conn->login_tx_desc, device->ib_device);
+
 	if (isert_conn->login_desc)
 		isert_free_login_buf(isert_conn);
 
@@ -960,14 +964,17 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 			mutex_lock(&isert_conn->mutex);
 			isert_conn->state = ISER_CONN_FULL_FEATURE;
 			mutex_unlock(&isert_conn->mutex);
-			goto post_send;
+
+			/* Sent from isert_get_rx_pdu() after registration. */
+			isert_conn->login_rsp_pending = true;
+			return 0;
 		}
 
 		ret = isert_login_post_recv(isert_conn);
 		if (ret)
 			return ret;
 	}
-post_send:
+
 	ret = isert_login_post_send(isert_conn, tx_desc);
 	if (ret)
 		return ret;
@@ -2618,8 +2625,17 @@ static void isert_free_conn(struct iscsi_conn *conn)
 
 static void isert_get_rx_pdu(struct iscsi_conn *conn)
 {
+	struct isert_conn *isert_conn = conn->context;
 	struct completion comp;
 
+	/* The session is registered by now; see isert_put_login_tx(). */
+	if (isert_conn->login_rsp_pending) {
+		isert_conn->login_rsp_pending = false;
+		if (isert_login_post_send(isert_conn,
+					  &isert_conn->login_tx_desc))
+			return;
+	}
+
 	init_completion(&comp);
 
 	wait_for_completion_interruptible(&comp);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index ca8cfebe26ca7..4c2f7d78008f7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -178,6 +178,7 @@ struct isert_conn {
 	struct completion	login_comp;
 	struct completion	login_req_comp;
 	struct iser_tx_desc	login_tx_desc;
+	bool			login_rsp_pending;
 	struct rdma_cm_id	*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
-- 
2.53.0



