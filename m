Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030381;
	b=xZw8bIsWsYYaK6itysyps5rpvll6G8gkC8ZfLb5i7XryI5VG16y/hfuQk6gqjQG3Lrnp
	 qxKuzBVXVb45V+Pwv/fzsWbAWUicls5XMTF8sLZJ7/RFy2ld7Jm0YIu+ZZ2AD2DYxq1E7
	 sohpPtgbIBFakI4QuXMzAxLVh8eG1RsWM7jd7GuraERJEIJbChm3HyHYdZpnguZi+YAS7
	 GUecF3+CuxD8Y09IBEuvhls9t3oXwkrzwxl8OO3OLUcI3dUEtLiNcRj2Y+qx1wm/SK25W
	 cLz0uVEKxh2SRLyacOPlETandzI6vTsSLL4AZfYy6ftxf30u1B+Zr0o80DVY16wC8SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j4olxvdK5esROMBdZTyFzdU+VynQhIl1+xqvhr518cs=;
	b=LtKJwL2aDRPreWLvz/DcH7c+WLBzLYwvtjfA0S6D8r3DRCHp4YXvDJO2JHKAfObGldrM
	 m2jyT1aWSzfjmvJSSuXlBu8Cerv42bb8xADdgoSEjEw01HgQ5f0DNUhdlH1BI7tIvZXqd
	 CmOKtQoic4fI3++nwHGX2XJ2xssmWOXmCl9A3KaPqtfdXAZyVKQIKHUFczWY9IkHUj36D
	 lqIlLX8YHQl7EcVO756UYo7ymBRA+3BeXtgfZ2+DJrXJ9oaHlrNOJkIZtfQbOMTbgwC34
	 WMBaAD6s0IpIaFPBgAlolwYzlbcB9Fk6zSaR0eKvr+ziG3wV/ZUwzMVJvsnYmKsNmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYwRTVBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDFE606B120;
	Wed, 18 Nov 2026 19:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYwRTVBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B591F000C4;
	Wed, 18 Nov 2026 19:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030381;
	bh=j4olxvdK5esROMBdZTyFzdU+VynQhIl1+xqvhr518cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYwRTVBFoWJ36o/amSlEh277PdPWV0j14pc7bmZcjbGlXLBpWa2J28l+3Ri8I1mJU
	 fpg1CM2HvsvEmFRof+FW5i0HZ/xSitnUVe5WEUNetGnhLFSL4jQLfM+QV0ZEpb8UY7
	 T9zRyN9nF3KVo/Lt7c34ScE0z5e0yVLnHgGlioo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0683/1756] RDMA/bnxt_re: Fix integer overflow in send payload size computation
Date: Wed, 18 Nov 2026 15:46:50 +0100
Message-ID: <20261118150036.431519299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 8231fd9b665ce..2266eab78c22b 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -123,10 +123,11 @@ static void bnxt_re_check_and_set_relaxed_ordering(struct bnxt_re_dev *rdev,
 		qplib_mr->flags |= CMDQ_REGISTER_MR_FLAGS_ENABLE_RO;
 }
 
-static int bnxt_re_build_sgl(struct ib_sge *ib_sg_list,
+static u32 bnxt_re_build_sgl(struct ib_sge *ib_sg_list,
 			     struct bnxt_qplib_sge *sg_list, int num)
 {
-	int i, total = 0;
+	u32 total = 0;
+	int i;
 
 	for (i = 0; i < num; i++) {
 		sg_list[i].addr = ib_sg_list[i].addr;
@@ -2688,17 +2689,22 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 
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
@@ -2721,7 +2727,8 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 				       struct bnxt_re_qp *qp,
 				       const struct ib_send_wr *wr)
 {
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -2737,11 +2744,9 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
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
@@ -2782,7 +2787,8 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 {
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
 	struct bnxt_qplib_swqe wqe;
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -2799,11 +2805,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
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



