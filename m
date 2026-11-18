Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040549;
	b=jsCQGoUUjyekJkLLyn6RDXGyd41127w73f1ef0xFYd1iSC2oVgf+nZL+bpduUsi3MwIt
	 OKFsfXc4BARbU6n3BKqY/rTq8bwLhRlYwvVJ+2cVYvqigexKKhKnNca6ssB3nm01EImjC
	 ggQB+pIppoAPtIKYKPM8L+B9Qg7WdsRSBFP1m02trRImhW5taqn0vFcKFQUMatejYkXk6
	 E/8LrycJpjpQbKQpWr5Z8uxLG5fa9zf0jLoZsVYEBzypA/XjK+JbMGDgoO27Ruhd+j7EZ
	 1KWIAaVQpxx87bq+kM2gYJ/4SrGg2k2Co1M3JpdSJOupZTZoWCspr1oLpIvSl5pHfEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6oEZeWq7KXM55SdccgYwtW6h0MIrJifC6TKWyYcqlI=;
	b=wBJhiuwIq/CqMF4Wp38W8342/nBHJ6SA3FS85zN21FobvlkrUQS6NaDEUMaAYFcuXjua
	 f3xRVETfBdDXaTxMlX7/fd9C5c9SiJoEHjEGYA5p/px1Zt5B6AQfn2TVDj5NYtG6X4Aom
	 oBom9hwGeBO+fltfsIbmpK5TKvUxZl6f7wZgQMwj61kkYuZdZGMJDLGg5NE51NPS+1wwW
	 RKvm7wb7uCEGVEuC81H90TOaCLLKMzQQWYyt/XJCq049IWgtbwG8MFiesiwcxSxrGsAHq
	 5WxTZE45U1PaQBFe6stak84nEinNxex9EHbrzBuGognbjslMGy4UeImoflMOKtyojsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJEK+ulf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922B4606A31C;
	Wed, 18 Nov 2026 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJEK+ulf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA33D1F000C4;
	Wed, 18 Nov 2026 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040549;
	bh=O6oEZeWq7KXM55SdccgYwtW6h0MIrJifC6TKWyYcqlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJEK+ulfAroKgYMv8TfXJncwC0cospqIGMadlCwhIucqHhKpb9dWe2nDx/TEWF1IC
	 oXg6XnYnXutI5kuJQ4i5hRcKMo7pLa5uKzyUWnoHWMHPJLrGKVxDlXepmdk/r3DyDB
	 5pgB7Gm6kgX+tmHHNaObadRVwoK+kOrjkGqGH9pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2446/3318] RDMA/bnxt_re: Fix integer overflow in send payload size computation
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150434.826308493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6a074ec2908d..db5571af5c759 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -114,10 +114,11 @@ static enum ib_access_flags __to_ib_access_flags(int qflags)
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
@@ -2644,17 +2645,22 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 
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
@@ -2677,7 +2683,8 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 				       struct bnxt_re_qp *qp,
 				       const struct ib_send_wr *wr)
 {
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -2693,11 +2700,9 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
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
@@ -2738,7 +2743,8 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 {
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
 	struct bnxt_qplib_swqe wqe;
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -2755,11 +2761,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
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



