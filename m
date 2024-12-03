Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3887F1F7545;
	Tue,  3 Dec 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238848; cv=none; b=LIKUSmnjals+TIr9VEmW/Cy+JZa14IWbZ4qjYHRiuYXsNrIl4v9WYNe7hWUejaeSH0xV21mzkHBaqtjtgtMpquLtLRQMncmc5pFBcdcVlnYreiLt+8AmGI9O92fNC23YfeEx1lW6rxdlUTaY91imxpO9gjwGyALy7hvkraLkX9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238848; c=relaxed/simple;
	bh=2Mu9H1R9f/DI76gs4JP/ry9GkiByGws1ArVxKg/52TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAaHxtb8plIIbgWRFMv+2RPOv6vgv6xHr2X24+nnWdhIPdMrutogcvb+2YMaaMnIgNYHf2TeFV7M3coV253rhBJ8AbZyuWmZzY2SRhcDJYCPMmlyiZ04uo40B7zDnAvbBirFyn6LkHAYuQaocqfHH753NhQDr/303d7vFE0i18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3WUfsjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3WUfsjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83C9C4CECF;
	Tue,  3 Dec 2024 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238848;
	bh=2Mu9H1R9f/DI76gs4JP/ry9GkiByGws1ArVxKg/52TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3WUfsjPu99MpyQeimhSojtkSZqfzPpwId94dHiV8H9ca32yq/5cNRuDq6A0BIfkF
	 7tP6Etfs8B2F0JcidTi9QXTT21S87BmxONYEtO69MrEPaG34I8ZcDgy42QGCpV3jje
	 E1ddkvHVXiw26zR7nZWmb3VywUNRgj4f1L4I1Yjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 418/817] RDMA/rxe: Fix the qp flush warnings in req
Date: Tue,  3 Dec 2024 15:39:50 +0100
Message-ID: <20241203144012.196040899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit ea4c990fa9e19ffef0648e40c566b94ba5ab31be ]

When the qp is in error state, the status of WQEs in the queue should be
set to error. Or else the following will appear.

[  920.617269] WARNING: CPU: 1 PID: 21 at drivers/infiniband/sw/rxe/rxe_comp.c:756 rxe_completer+0x989/0xcc0 [rdma_rxe]
[  920.617744] Modules linked in: rnbd_client(O) rtrs_client(O) rtrs_core(O) rdma_ucm rdma_cm iw_cm ib_cm crc32_generic rdma_rxe ip6_udp_tunnel udp_tunnel ib_uverbs ib_core loop brd null_blk ipv6
[  920.618516] CPU: 1 PID: 21 Comm: ksoftirqd/1 Tainted: G           O       6.1.113-storage+ #65
[  920.618986] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[  920.619396] RIP: 0010:rxe_completer+0x989/0xcc0 [rdma_rxe]
[  920.619658] Code: 0f b6 84 24 3a 02 00 00 41 89 84 24 44 04 00 00 e9 2a f7 ff ff 39 ca bb 03 00 00 00 b8 0e 00 00 00 48 0f 45 d8 e9 15 f7 ff ff <0f> 0b e9 cb f8 ff ff 41 bf f5 ff ff ff e9 08 f8 ff ff 49 8d bc 24
[  920.620482] RSP: 0018:ffff97b7c00bbc38 EFLAGS: 00010246
[  920.620817] RAX: 0000000000000000 RBX: 000000000000000c RCX: 0000000000000008
[  920.621183] RDX: ffff960dc396ebc0 RSI: 0000000000005400 RDI: ffff960dc4e2fbac
[  920.621548] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffffac406450
[  920.621884] R10: ffffffffac4060c0 R11: 0000000000000001 R12: ffff960dc4e2f800
[  920.622254] R13: ffff960dc4e2f928 R14: ffff97b7c029c580 R15: 0000000000000000
[  920.622609] FS:  0000000000000000(0000) GS:ffff960ef7d00000(0000) knlGS:0000000000000000
[  920.622979] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  920.623245] CR2: 00007fa056965e90 CR3: 00000001107f1000 CR4: 00000000000006e0
[  920.623680] Call Trace:
[  920.623815]  <TASK>
[  920.623933]  ? __warn+0x79/0xc0
[  920.624116]  ? rxe_completer+0x989/0xcc0 [rdma_rxe]
[  920.624356]  ? report_bug+0xfb/0x150
[  920.624594]  ? handle_bug+0x3c/0x60
[  920.624796]  ? exc_invalid_op+0x14/0x70
[  920.624976]  ? asm_exc_invalid_op+0x16/0x20
[  920.625203]  ? rxe_completer+0x989/0xcc0 [rdma_rxe]
[  920.625474]  ? rxe_completer+0x329/0xcc0 [rdma_rxe]
[  920.625749]  rxe_do_task+0x80/0x110 [rdma_rxe]
[  920.626037]  rxe_requester+0x625/0xde0 [rdma_rxe]
[  920.626310]  ? rxe_cq_post+0xe2/0x180 [rdma_rxe]
[  920.626583]  ? do_complete+0x18d/0x220 [rdma_rxe]
[  920.626812]  ? rxe_completer+0x1a3/0xcc0 [rdma_rxe]
[  920.627050]  rxe_do_task+0x80/0x110 [rdma_rxe]
[  920.627285]  tasklet_action_common.constprop.0+0xa4/0x120
[  920.627522]  handle_softirqs+0xc2/0x250
[  920.627728]  ? sort_range+0x20/0x20
[  920.627942]  run_ksoftirqd+0x1f/0x30
[  920.628158]  smpboot_thread_fn+0xc7/0x1b0
[  920.628334]  kthread+0xd6/0x100
[  920.628504]  ? kthread_complete_and_exit+0x20/0x20
[  920.628709]  ret_from_fork+0x1f/0x30
[  920.628892]  </TASK>

Fixes: ae720bdb703b ("RDMA/rxe: Generate error completion for error requester QP state")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20241025152036.121417-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 479c07e6e4ed3..87a02f0deb000 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -663,10 +663,12 @@ int rxe_requester(struct rxe_qp *qp)
 	if (unlikely(qp_state(qp) == IB_QPS_ERR)) {
 		wqe = __req_next_wqe(qp);
 		spin_unlock_irqrestore(&qp->state_lock, flags);
-		if (wqe)
+		if (wqe) {
+			wqe->status = IB_WC_WR_FLUSH_ERR;
 			goto err;
-		else
+		} else {
 			goto exit;
+		}
 	}
 
 	if (unlikely(qp_state(qp) == IB_QPS_RESET)) {
-- 
2.43.0



