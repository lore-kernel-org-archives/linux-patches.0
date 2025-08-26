Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088BF1F4C90;
	Tue, 26 Aug 2025 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218253; cv=none; b=T1nFEDporcRGfSmoe+5lfR02OsomNsoPWhvHGacMHlh9SDIG8XBXcvtnY3Ws3SzYA3aqxe6Dy4tWg69QyW1e4ktiN778gkvdPovZlxrH76JeD8ksf1sGUdpKD5kFJZyG/yx8vCIW3XZ2gwCz8bGqg9TN5NWgXFC6HlYerdAeh0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218253; c=relaxed/simple;
	bh=+1V7gUO2K53aaKmdJ+4ILULt2fZmBi42MbW/B0BAOVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrAMYg4u4swnrKnsevrWp6XWo3fvliLqyFzmU6baOBQgLiCZK3wVGdVg/WMALP1d5A92W1fU8sOfRpXqLXPQXLCkDfj05r5KgGXMOG6BOFD89VlnxnmWlCcETMLS8FwUu8peSAgqfgLZv9pN3YrJvYGxXLJvOYQ2AyC38e3jyZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZAprrYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZAprrYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90758C4CEF1;
	Tue, 26 Aug 2025 14:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218252;
	bh=+1V7gUO2K53aaKmdJ+4ILULt2fZmBi42MbW/B0BAOVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZAprrYWzmowHrPdVKWCHxGndvXzzygIsvSA/3j8sdndapg7YkrFdU1YzwOU4jFWd
	 S6bpbeK0OhNfBfva51W98ACG4gvBTkctmzb2mTUyVRMqtofO+cx8bcBr84tMb1gWtw
	 Fblz8VncVhcXQkVCQH4Cv1VJ/d7ZO5VsUqqjZNzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 452/523] RDMA/rxe: Return CQE error if invalid lkey was supplied
Date: Tue, 26 Aug 2025 13:11:02 +0200
Message-ID: <20250826110935.599545988@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit dc07628bd2bbc1da768e265192c28ebd301f509d ]

RXE is missing update of WQE status in LOCAL_WRITE failures.  This caused
the following kernel panic if someone sent an atomic operation with an
explicitly wrong lkey.

[leonro@vm ~]$ mkt test
test_atomic_invalid_lkey (tests.test_atomic.AtomicTest) ...
 WARNING: CPU: 5 PID: 263 at drivers/infiniband/sw/rxe/rxe_comp.c:740 rxe_completer+0x1a6d/0x2e30 [rdma_rxe]
 Modules linked in: crc32_generic rdma_rxe ip6_udp_tunnel udp_tunnel rdma_ucm rdma_cm ib_umad ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core ptp pps_core
 CPU: 5 PID: 263 Comm: python3 Not tainted 5.13.0-rc1+ #2936
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:rxe_completer+0x1a6d/0x2e30 [rdma_rxe]
 Code: 03 0f 8e 65 0e 00 00 3b 93 10 06 00 00 0f 84 82 0a 00 00 4c 89 ff 4c 89 44 24 38 e8 2d 74 a9 e1 4c 8b 44 24 38 e9 1c f5 ff ff <0f> 0b e9 0c e8 ff ff b8 05 00 00 00 41 bf 05 00 00 00 e9 ab e7 ff
 RSP: 0018:ffff8880158af090 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff888016a78000 RCX: ffffffffa0cf1652
 RDX: 1ffff9200004b442 RSI: 0000000000000004 RDI: ffffc9000025a210
 RBP: dffffc0000000000 R08: 00000000ffffffea R09: ffff88801617740b
 R10: ffffed1002c2ee81 R11: 0000000000000007 R12: ffff88800f3b63e8
 R13: ffff888016a78008 R14: ffffc9000025a180 R15: 000000000000000c
 FS:  00007f88b622a740(0000) GS:ffff88806d540000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f88b5a1fa10 CR3: 000000000d848004 CR4: 0000000000370ea0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  rxe_do_task+0x130/0x230 [rdma_rxe]
  rxe_rcv+0xb11/0x1df0 [rdma_rxe]
  rxe_loopback+0x157/0x1e0 [rdma_rxe]
  rxe_responder+0x5532/0x7620 [rdma_rxe]
  rxe_do_task+0x130/0x230 [rdma_rxe]
  rxe_rcv+0x9c8/0x1df0 [rdma_rxe]
  rxe_loopback+0x157/0x1e0 [rdma_rxe]
  rxe_requester+0x1efd/0x58c0 [rdma_rxe]
  rxe_do_task+0x130/0x230 [rdma_rxe]
  rxe_post_send+0x998/0x1860 [rdma_rxe]
  ib_uverbs_post_send+0xd5f/0x1220 [ib_uverbs]
  ib_uverbs_write+0x847/0xc80 [ib_uverbs]
  vfs_write+0x1c5/0x840
  ksys_write+0x176/0x1d0
  do_syscall_64+0x3f/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/11e7b553f3a6f5371c6bb3f57c494bb52b88af99.1620711734.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -346,13 +346,15 @@ static inline enum comp_state do_read(st
 	ret = copy_data(qp->pd, IB_ACCESS_LOCAL_WRITE,
 			&wqe->dma, payload_addr(pkt),
 			payload_size(pkt), to_mem_obj, NULL);
-	if (ret)
+	if (ret) {
+		wqe->status = IB_WC_LOC_PROT_ERR;
 		return COMPST_ERROR;
+	}
 
 	if (wqe->dma.resid == 0 && (pkt->mask & RXE_END_MASK))
 		return COMPST_COMP_ACK;
-	else
-		return COMPST_UPDATE_COMP;
+
+	return COMPST_UPDATE_COMP;
 }
 
 static inline enum comp_state do_atomic(struct rxe_qp *qp,
@@ -366,10 +368,12 @@ static inline enum comp_state do_atomic(
 	ret = copy_data(qp->pd, IB_ACCESS_LOCAL_WRITE,
 			&wqe->dma, &atomic_orig,
 			sizeof(u64), to_mem_obj, NULL);
-	if (ret)
+	if (ret) {
+		wqe->status = IB_WC_LOC_PROT_ERR;
 		return COMPST_ERROR;
-	else
-		return COMPST_COMP_ACK;
+	}
+
+	return COMPST_COMP_ACK;
 }
 
 static void make_send_cqe(struct rxe_qp *qp, struct rxe_send_wqe *wqe,


