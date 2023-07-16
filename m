Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805A8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091A2C433C7;
	Sun, 16 Jul 2023 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540104;
	bh=p0AwJQQnmfSA6VDdFZlwD0hKUQWU3qXco1wuZvc0aaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI3AK4+0ndvNY76gR3UlVZjQ+GR1FT5lxEPzFI37fJDTPQuJh9M1ZUwxk/F9eCYDQ
	 Q0wmkyGg2LoK8Bsx0SaOpuyVL3HStNKgOvr/ztvnnSr552UmkhJ/FOR9HLRwvC7SCt
	 DNfCqu9dkiWWoPL4uUl5OtOZVknX3lUOaBMBeJOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/591] RDMA/rxe: Replace pr_xxx by rxe_dbg_xxx in rxe_mw.c
Date: Sun, 16 Jul 2023 21:46:23 +0200
Message-ID: <20230716194930.183703248@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit e8a87efdf87455454d0a14fd486c679769bfeee2 ]

Replace calls to pr_xxx() int rxe_mw.c with rxe_dbg_xxx().

Link: https://lore.kernel.org/r/20221103171013.20659-6-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 425e1c9018fd ("RDMA/rxe: Fix access checks in rxe_check_bind_mw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mw.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 902b7df7aaedb..70252991320a0 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -52,14 +52,14 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 {
 	if (mw->ibmw.type == IB_MW_TYPE_1) {
 		if (unlikely(mw->state != RXE_MW_STATE_VALID)) {
-			pr_err_once(
+			rxe_dbg_mw(mw,
 				"attempt to bind a type 1 MW not in the valid state\n");
 			return -EINVAL;
 		}
 
 		/* o10-36.2.2 */
 		if (unlikely((mw->access & IB_ZERO_BASED))) {
-			pr_err_once("attempt to bind a zero based type 1 MW\n");
+			rxe_dbg_mw(mw, "attempt to bind a zero based type 1 MW\n");
 			return -EINVAL;
 		}
 	}
@@ -67,21 +67,21 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	if (mw->ibmw.type == IB_MW_TYPE_2) {
 		/* o10-37.2.30 */
 		if (unlikely(mw->state != RXE_MW_STATE_FREE)) {
-			pr_err_once(
+			rxe_dbg_mw(mw,
 				"attempt to bind a type 2 MW not in the free state\n");
 			return -EINVAL;
 		}
 
 		/* C10-72 */
 		if (unlikely(qp->pd != to_rpd(mw->ibmw.pd))) {
-			pr_err_once(
+			rxe_dbg_mw(mw,
 				"attempt to bind type 2 MW with qp with different PD\n");
 			return -EINVAL;
 		}
 
 		/* o10-37.2.40 */
 		if (unlikely(!mr || wqe->wr.wr.mw.length == 0)) {
-			pr_err_once(
+			rxe_dbg_mw(mw,
 				"attempt to invalidate type 2 MW by binding with NULL or zero length MR\n");
 			return -EINVAL;
 		}
@@ -92,13 +92,13 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		return 0;
 
 	if (unlikely(mr->access & IB_ZERO_BASED)) {
-		pr_err_once("attempt to bind MW to zero based MR\n");
+		rxe_dbg_mw(mw, "attempt to bind MW to zero based MR\n");
 		return -EINVAL;
 	}
 
 	/* C10-73 */
 	if (unlikely(!(mr->access & IB_ACCESS_MW_BIND))) {
-		pr_err_once(
+		rxe_dbg_mw(mw,
 			"attempt to bind an MW to an MR without bind access\n");
 		return -EINVAL;
 	}
@@ -107,7 +107,7 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	if (unlikely((mw->access &
 		      (IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_ATOMIC)) &&
 		     !(mr->access & IB_ACCESS_LOCAL_WRITE))) {
-		pr_err_once(
+		rxe_dbg_mw(mw,
 			"attempt to bind an Writable MW to an MR without local write access\n");
 		return -EINVAL;
 	}
@@ -115,7 +115,7 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	/* C10-75 */
 	if (mw->access & IB_ZERO_BASED) {
 		if (unlikely(wqe->wr.wr.mw.length > mr->ibmr.length)) {
-			pr_err_once(
+			rxe_dbg_mw(mw,
 				"attempt to bind a ZB MW outside of the MR\n");
 			return -EINVAL;
 		}
@@ -123,7 +123,7 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		if (unlikely((wqe->wr.wr.mw.addr < mr->ibmr.iova) ||
 			     ((wqe->wr.wr.mw.addr + wqe->wr.wr.mw.length) >
 			      (mr->ibmr.iova + mr->ibmr.length)))) {
-			pr_err_once(
+			rxe_dbg_mw(mw,
 				"attempt to bind a VA MW outside of the MR\n");
 			return -EINVAL;
 		}
-- 
2.39.2



