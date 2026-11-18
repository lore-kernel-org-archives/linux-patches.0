Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019450;
	b=DZ8pXgWA7SPH6H4l9GEpj4wNF4jcbsllX1Eaa1B/fGGGm4chZv4GTAkkB8oSgZ1qFvNb
	 3zXfB3w768cNHOTSUisJJyq8zsB15HnY+AIJ6f6hYi520YGrqoYIt3dIRhYZcfPszRfqB
	 M1vOFjPuJCVqoH2TxmHaRHWpiCUHcoFa6RaDbOmSTgCNoZxylK6jKCDA66ZkobxP0MgyC
	 Xnpp83kRRGAckqwFHNWQd3XWAbzVymakvATZ9qpE4q59vPr4d7J5q7wUN7//AkiczmAoM
	 vwycvDVHY1D+CcSucXSswBuvdAiwQgDICCLTXpbhH06+MRyks2Yjuvmh5ncZOE+VkeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HbsFyBWv8F3VFWOlOdyq7b8eaX7Fw74zx4cjg3nd53U=;
	b=aGRkxMKV7N4GnbjXPNCc9iezKqRUyKH1nfEuv8CX8HkmHMUZAxfrOHHijD31NDRumLn+
	 bGWny+s/Ut32IACJ1dVk7agodc71JHymVXARQ1nuLM+TGq246J7e+ksO/OZJthj8HTmS8
	 7myEdcpDhPMlzBo8TXyxauWJ/aAoid76p/OJbiWKnNt86MpXx8+kxsFs96hBIKvOuuU9K
	 pVf2z7YBJlE0ngP/AEbOFzVm0rkXleqsmSWVBBUD0KCvzanuxZdey6Auf9UM+LNA2k9v+
	 5O+sfXWTZBJsMl+YXFmvP44kqz7xjIGgjnneDo5BZEtxPk+dCYiFySLk/KTcCyim+kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVK8M4OC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECCC606B55A;
	Wed, 18 Nov 2026 16:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVK8M4OC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3A81F000C5;
	Wed, 18 Nov 2026 16:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019450;
	bh=HbsFyBWv8F3VFWOlOdyq7b8eaX7Fw74zx4cjg3nd53U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVK8M4OCAPbXH4cSEGsqKJoKW4mZBvJi+QQ2NEIksFQBBWebAvdcytbtPvSUdGn8O
	 Pw45OnCfRsO9xMEIq55zCiJamp7op7tjQZlRipjtXJYb5Axsa46A3wVo2iFyNzx0O9
	 HifePOZOx2aiPTd7HaS2D71GSoCpTbl2RuJNhGwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1599/2651] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118150345.431413123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 45 +++++++++-----------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5050895477e69..a908745af1a98 100644
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
-			rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
-				 ERR_PTR(err));
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
@@ -1704,7 +1689,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		clt_path->s.dev_ref++;
 		/* QD * (REQ + RSP + FR REGS or INVS) + drain */
 		max_send_wr = min(wr_limit, clt_path->queue_depth * 4 + 1);
-		max_recv_wr = min(wr_limit, clt_path->queue_depth * 3 + 1);
+		max_recv_wr = min(wr_limit, clt_path->queue_depth * 2 + 1);
 		max_send_sge = 2;
 	}
 	atomic_set(&con->c.sq_wr_avail, max_send_wr);
-- 
2.53.0



