Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209315CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BD5C433C1;
	Tue,  8 Nov 2022 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916462;
	bh=imdr08jhcuWNPJuTwkNLaJQyHDKFBbAgOxjYU8kzW0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uzjAQR4oIolmLwssvZXVVXuIVqkAUBd2V0o2u35WO65bWUjNC6+olwy+bKIbRoUM
	 rqeUDgL1RPFOfPmNUv3JlH83LeKU7LHAd94BXyIJjWbsTxg0pN2MyNvR3nJyHtT0su
	 2Jwyw0EO/WQx1otWg9EHI6Uu78uoC3PE8GkJ0Vfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 009/197] RDMA/rxe: Fix mr leak in RESPST_ERR_RNR
Date: Tue,  8 Nov 2022 14:37:27 +0100
Message-Id: <20221108133355.209954823@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit b5f9a01fae42684648c2ee3cd9985f80c67ab9f7 ]

rxe_recheck_mr() will increase mr's ref_cnt, so we should call rxe_put(mr)
to drop mr's ref_cnt in RESPST_ERR_RNR to avoid below warning:

  WARNING: CPU: 0 PID: 4156 at drivers/infiniband/sw/rxe/rxe_pool.c:259 __rxe_cleanup+0x1df/0x240 [rdma_rxe]
...
  Call Trace:
   rxe_dereg_mr+0x4c/0x60 [rdma_rxe]
   ib_dereg_mr_user+0xa8/0x200 [ib_core]
   ib_mr_pool_destroy+0x77/0xb0 [ib_core]
   nvme_rdma_destroy_queue_ib+0x89/0x240 [nvme_rdma]
   nvme_rdma_free_queue+0x40/0x50 [nvme_rdma]
   nvme_rdma_teardown_io_queues.part.0+0xc3/0x120 [nvme_rdma]
   nvme_rdma_error_recovery_work+0x4d/0xf0 [nvme_rdma]
   process_one_work+0x582/0xa40
   ? pwq_dec_nr_in_flight+0x100/0x100
   ? rwlock_bug.part.0+0x60/0x60
   worker_thread+0x2a9/0x700
   ? process_one_work+0xa40/0xa40
   kthread+0x168/0x1a0
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x22/0x30

Link: https://lore.kernel.org/r/20221024052049.20577-1-lizhijian@fujitsu.com
Fixes: 8a1a0be894da ("RDMA/rxe: Replace mr by rkey in responder resources")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 7c336db5cb54..f8b1d9fa0494 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -806,8 +806,10 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
-	if (!skb)
+	if (!skb) {
+		rxe_put(mr);
 		return RESPST_ERR_RNR;
+	}
 
 	rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
 		    payload, RXE_FROM_MR_OBJ);
-- 
2.35.1



