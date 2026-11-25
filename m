Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625325;
	b=PovsXkx91efL087QgDvWJIJA/V/9zrusQvvn6Nc1UOpX6aHfmiqU0mpZhYtUqJgG6Wed
	 FumDmPj7dDW1a9BllMYeO0UvJouUHTHLN7EDy+hzSPHPss7NkgM4kWprwYS0TMhUdGTQl
	 QZClxF+lQhoP1zdrtc4iMU5fFUE5KIF6CqpPJra/S8LNKDKe1QIbzv7ZfQDEKpbuae2vm
	 sgGT6vqcAgVBIuXvOLPU6KHL39caDHO47xxKPn4/JVsAOFIwqg4WBYqBauZM1HPfAEa2F
	 ZXGIsfyivq+xuCY4HuCtPsnq/57HexuliNV+7sbaXgh+OaHpNUtoCMQZk94gs3jwkmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y18emVxe+QRFPrmqoOCf9kEKRq+R0CYpvSVPDpS7cAQ=;
	b=KD4FUY0k08ASBYJLsVENrDXlTMWtwl6NpKTigUZOf/IS1Vn6hlsJ4+VmIl6GZzPu/j/A
	 VvEitx5rc+AOkzo7qC6JFTtV/rnPB51Aivn+Av2YNksyok7t4WzE0ElYnbFE4kgPHc2dr
	 fBaPswczpBs4YGY6iTFrz//fVMPf8bv7+9mHL/Ty/MJMbJ2cjN0/RCRQLPipkWsYYA5kI
	 XhjiG1Xfpu6vZxH9ts7GooYZjdjWwiEmqA+2t0CSIYRxWk7cB/ct0XaYFPLJWxZhwiaRs
	 GwlzoDILPvYpNLpmPTyNkzDWGjJAeEqkA7H/uKg4mwYn+uP1uuvZWr48RwavsX8scEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5H7Li82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0B606A31E;
	Wed, 25 Nov 2026 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5H7Li82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56E51F000C4;
	Wed, 25 Nov 2026 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625325;
	bh=Y18emVxe+QRFPrmqoOCf9kEKRq+R0CYpvSVPDpS7cAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5H7Li82OagCwaDC7Av7Gq43J8Fe45nue3qpdS9N9q92XP+xSdq02GJW1D9Hcjr57
	 HwshFvRs27gV4ZKZgDy4eZ3W9ix7gAbIhA3STnlD0ZyuTM8dXauN7dYQQbReArUCWk
	 9joXlQlcY40RDMVjjgCwp7Tznoky/ffP4eL/sfMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 480/816] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
Date: Wed, 25 Nov 2026 15:33:48 +0100
Message-ID: <20261125143900.308115997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 3255d6b83491574b115806ec958d8f6ca090fa9c ]

On disconnect the client error recovery path calls ib_drain_qp(), which
requires one free RQ slot and that no recv WQEs are posted while the
queue is being drained.

When the server is loaded with always_invalidate=N, the path does not
advertise RTRS_MSG_NEW_RKEY_F.  A client-requested invalidation is then
a standalone SEND_WITH_INV.  The recv completion path did not repost
that WQE; it posted two empty recv WQEs later, when the RDMA-with-IMM
response carried RTRS_IO_RSP_W_INV_IMM.  If the invalidate receive
never arrived, each such response increased RQ occupancy by one until
ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed
with:

  failed to drain recv queue: -12

Repost one empty recv WQE for every receive completion, including
SEND_WITH_INV completions on the always_invalidate=N path, and only
while the path is still connected so CQ polling cannot race with
ib_drain_qp().  Size IO connection RQs to 2 * queue_depth + 1 to match
the posted recv count and leave the drain slot.

Tested with a synthetic RTRS client flooding unpaired
RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
__ib_drain_rq() warnings.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Link: https://lore.kernel.org/linux-rdma/CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com
Link: https://patch.msgid.link/20261005-rtrs-fix-ib-drain-rq-v2-1-35535a3ed115@proton.me
Tested-by: Quanye Yang <quanyeyang@proton.me>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Kept this tree's min_t(int, ...) formatting in create_con_cq_qp() while changing the multiplier from 3 to 2, and dropped the removed block's %d error print in favor of the helper's %pe print. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 45 +++++++++-----------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index dbce23eabcfd1..3525508fe0321 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -582,25 +582,21 @@ static struct ib_cqe io_comp_cqe = {
 	.done = rtrs_clt_rdma_done
 };
 
-/*
- * Post x2 empty WRs: first is for this RDMA with IMM,
- * second is for RECV with INV, which happened earlier.
- */
-static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_cqe *cqe)
+static int rtrs_clt_repost_recv(struct rtrs_clt_con *con)
 {
-	struct ib_recv_wr wr_arr[2], *wr;
-	int i;
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
+	int err;
 
-	memset(wr_arr, 0, sizeof(wr_arr));
-	for (i = 0; i < ARRAY_SIZE(wr_arr); i++) {
-		wr = &wr_arr[i];
-		wr->wr_cqe  = cqe;
-		if (i)
-			/* Chain backwards */
-			wr->next = &wr_arr[i - 1];
-	}
+	if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
+		return 0;
 
-	return ib_post_recv(con->qp, wr, NULL);
+	err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
+	if (err) {
+		rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
+			 ERR_PTR(err));
+		rtrs_rdma_error_recovery(con);
+	}
+	return err;
 }
 
 static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -661,19 +657,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
 				  imm_type);
 		}
-		if (w_inval)
-			/*
-			 * Post x2 empty WRs: first is for this RDMA with IMM,
-			 * second is for RECV with INV, which happened earlier.
-			 */
-			err = rtrs_post_recv_empty_x2(&con->c, &io_comp_cqe);
-		else
-			err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
-		if (err) {
-			rtrs_err(con->c.path, "rtrs_post_recv_empty(): %d\n",
-				  err);
-			rtrs_rdma_error_recovery(con);
-		}
+		rtrs_clt_repost_recv(con);
 		break;
 	case IB_WC_RECV:
 		/*
@@ -689,6 +673,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 
 			return  rtrs_clt_rkey_rsp_done(con, wc);
 		}
+		rtrs_clt_repost_recv(con);
 		break;
 	case IB_WC_RDMA_WRITE:
 		/*
@@ -1710,7 +1695,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 			      /* QD * (REQ + RSP + FR REGS or INVS) + drain */
 			      clt_path->queue_depth * 4 + 1);
 		max_recv_wr = min_t(int, wr_limit,
-			      clt_path->queue_depth * 3 + 1);
+			      clt_path->queue_depth * 2 + 1);
 		max_send_sge = 2;
 	}
 	atomic_set(&con->c.sq_wr_avail, max_send_wr);
-- 
2.53.0



