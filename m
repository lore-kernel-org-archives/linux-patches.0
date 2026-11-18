Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055529;
	b=mlw1K2c0mrtl87GtNmXoNuu4rYYkMBxDUc/4Mls7o9U4I1lFcHe08vd/P1z8zq/39/iF
	 LDi5CQpkRi+PZ49F32Zh5sKM/Z4H3OXU/0QMGJvE/jB/I9GYCmaEjvd0aUT04T/E9bF//
	 dDgmbg71m+ENlNMPuaT4ZweNGgohsHNQlelToUBXAcNTHPgFFpIz0+0ixXNrxkQ7Mgn17
	 ebi3UrX8XsAVuNzVmnMorjsC31iK6vW8xXE7qVkHJTScaIZbz/GZuf54gV6DI5fqu5qNp
	 k4H/V0jpbBMuKHPdhBzezE/3YJC/OamDJ038J3+cugC1ysNG9FWMQOJ6fBD2Q4aFwlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ljo+H3I5ofZLcggQzQYt0IE2LQuDQRtLmy+//xmJcGg=;
	b=dFf/fsXtxkFcr/iq+GxLGAC2ERmBAZBhiE8MzgmzL/XxeSEmiihGIwxnfYTFmxb3tG0Z
	 3HsuJgfeOZP33QuaF3Gn7BkF5N1GRGA490BaMr3DaysLjiFHyRzjuACl0XQDuhnfNUDdu
	 lEXgu6FI1pcNh79TyvOLbNeVCpo5wSRiOwKU3Wcz0Qi5LgK+tjf51A+IsmDljZcBsNkdS
	 F6heBpH63LwrjrdLnc0p6mqnutW0IO4LlFGPdDqwE3ET44Ox7XqdLZ9huFdpXkQCjrX8w
	 RVBRLgD2Qlb34LTNUu/DBJNoqKm58peafT+Y7Xl0mX2w/vF2HUUJK78Qdlw98wsZPTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w93hOx49;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF686606A325;
	Thu, 19 Nov 2026 02:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w93hOx49
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3F11F000C4;
	Thu, 19 Nov 2026 02:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055529;
	bh=ljo+H3I5ofZLcggQzQYt0IE2LQuDQRtLmy+//xmJcGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w93hOx49R2AUYxZTSfDqALh47ZxgHCUhkXvrJWWyKuamjLW2ZWBr0B/+5A1ML4QT7
	 icjwAULvwYf6h1M9VKFjkDqJD0/v3gVVUwpPBjLcUzG+UckiM1uIELZ0utZ6Qy5zLI
	 vsv+yoimZkKvkx4OsJhk7MFJ4tIxu12qzMdmigBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1664/2214] RDMA/bnxt_re: Fix integer overflow in send payload size computation
Date: Wed, 18 Nov 2026 15:55:40 +0100
Message-ID: <20261118150118.428553193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 3483cbbd7487163345b4b4d5eb8cad8540d1c3ba ]

bnxt_re_build_sgl() summed SGE lengths into a signed int, which could
overflow. Make it return u32, and have bnxt_re_copy_wr_payload() report
the size via a u32 out-parameter with the return value carrying only
the error status, instead of overloading a signed int with both.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 44 +++++++++++++-----------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c7c329cf4d50b..3b821b6913253 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -104,10 +104,11 @@ static enum ib_access_flags __to_ib_access_flags(int qflags)
 	return iflags;
 };
 
-static int bnxt_re_build_sgl(struct ib_sge *ib_sg_list,
+static u32 bnxt_re_build_sgl(struct ib_sge *ib_sg_list,
 			     struct bnxt_qplib_sge *sg_list, int num)
 {
-	int i, total = 0;
+	u32 total = 0;
+	int i;
 
 	for (i = 0; i < num; i++) {
 		sg_list[i].addr = ib_sg_list[i].addr;
@@ -2528,17 +2529,22 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 
 static int bnxt_re_copy_wr_payload(struct bnxt_re_dev *rdev,
 				   const struct ib_send_wr *wr,
-				   struct bnxt_qplib_swqe *wqe)
+				   struct bnxt_qplib_swqe *wqe,
+				   u32 *payload_sz)
 {
-	int payload_sz = 0;
+	int rc;
 
-	if (wr->send_flags & IB_SEND_INLINE)
-		payload_sz = bnxt_re_copy_inline_data(rdev, wr, wqe);
-	else
-		payload_sz = bnxt_re_build_sgl(wr->sg_list, wqe->sg_list,
-					       wqe->num_sge);
+	if (wr->send_flags & IB_SEND_INLINE) {
+		rc = bnxt_re_copy_inline_data(rdev, wr, wqe);
+		if (rc < 0)
+			return rc;
+		*payload_sz = rc;
+	} else {
+		*payload_sz = bnxt_re_build_sgl(wr->sg_list, wqe->sg_list,
+						wqe->num_sge);
+	}
 
-	return payload_sz;
+	return 0;
 }
 
 static void bnxt_ud_qp_hw_stall_workaround(struct bnxt_re_qp *qp)
@@ -2561,7 +2567,8 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 				       struct bnxt_re_qp *qp,
 				       const struct ib_send_wr *wr)
 {
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -2577,11 +2584,9 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 			goto bad;
 		}
 
-		payload_sz = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe);
-		if (payload_sz < 0) {
-			rc = -EINVAL;
+		rc = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe, &payload_sz);
+		if (rc)
 			goto bad;
-		}
 		wqe.wr_id = wr->wr_id;
 
 		wqe.type = BNXT_QPLIB_SWQE_TYPE_SEND;
@@ -2609,7 +2614,8 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 {
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
 	struct bnxt_qplib_swqe wqe;
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -2626,11 +2632,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 			goto bad;
 		}
 
-		payload_sz = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe);
-		if (payload_sz < 0) {
-			rc = -EINVAL;
+		rc = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe, &payload_sz);
+		if (rc)
 			goto bad;
-		}
 		wqe.wr_id = wr->wr_id;
 
 		switch (wr->opcode) {
-- 
2.53.0



