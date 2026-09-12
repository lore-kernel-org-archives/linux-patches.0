Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321C778C9C;
	Sat, 12 Sep 2026 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223934; cv=none; b=U6SGkVYV0A071cU7Gg+WjR6cqht6WkW3SkphRkULkUNQzb0XnBts74vnvyMeO1Ci5+TJBpNkNdhVzxsDuk2bMD1XhEUyfAGJibpm01Kvqdy7EEf9ZuwAruPQF8A+UVcTCA74ir0son/DWEagnWJUTMFfJappOQWwI+ELf9MGVag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223934; c=relaxed/simple;
	bh=4poC5pmV3Obw7lDXx2PJAMf7rqh9jYNbIYAaSen8M/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOHQ2XAMktUeKuuMNLBUqwMfGchRf0xeaQkvB/A9sTrJcswrBXFw2ckOpi5RO9OWxk3GMbzsS+g649LqODWkLpbW+txNctFy2oSW8fOn0jKwGsi05eo+DZ6ArDlhZ5zsy+wmjbUBdCGuEKMnqfrWE4tbJJPC6Ascy+cyKkBGgeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTFMjl0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTFMjl0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E61C1F000FF;
	Sat, 12 Sep 2026 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223933;
	bh=CFGi3qA7Dcrvu8OjOXQPTxEK+SJKTx6TcMnoymyp+4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTFMjl0fMb+0Xefv9t83PK1aqjOqGa3Hsn6fNMIrpHuTFjHN4skzmlDz32woprd+n
	 k/bBafFZW9RVSfk3kbBuaUKX17JHSTYbGharWpfIoOQjp5C1IgHagA7JqEsfXmR7kU
	 6BCCr6LukCZWs4weeyRGV0HsR9hP9Nf4g6f5lF6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0889/1424] RDMA/mlx5: Fix integer overflow of user QP buffer size
Date: Sat, 12 Sep 2026 08:55:21 +0200
Message-ID: <20260912065627.237587252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit dec47e4b0fe34afdf38caa72b4408ba95502e5de ]

set_user_buf_size() computes the QP buffer size by left-shifting the
user-supplied rq.wqe_cnt and rq.wqe_shift values as signed integers.
A sufficiently large rq.wqe_cnt causes signed integer overflow, which
is undefined behavior, and yields a small or negative buf_size, causing
ib_umem_get() to map a buffer smaller than the hardware will actually
write into.

Replace the shifts and addition with check_shl_overflow() and
check_add_overflow(), rejecting invalid user inputs.

Moreover, guard the identical shift computing qp->sq.offset in
_create_user_qp() before set_user_buf_size() is reached.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260723-fix-qp-buf-size-overflow-v1-1-ccb05ee43a7b@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 6bbf12732051d..83661a393136c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -637,6 +637,7 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 			    struct ib_qp_init_attr *attr)
 {
 	int desc_sz = 1 << qp->sq.wqe_shift;
+	int rq_buf_size, sq_buf_size;
 
 	if (desc_sz > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq)) {
 		mlx5_ib_warn(dev, "desc_sz %d, max_sq_desc_sz %d\n",
@@ -661,11 +662,21 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 
 	if (attr->qp_type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN) {
-		base->ubuffer.buf_size = qp->rq.wqe_cnt << qp->rq.wqe_shift;
-		qp->raw_packet_qp.sq.ubuffer.buf_size = qp->sq.wqe_cnt << 6;
+		if (check_shl_overflow(qp->rq.wqe_cnt, qp->rq.wqe_shift,
+				       &base->ubuffer.buf_size))
+			return -EINVAL;
+		if (check_shl_overflow(qp->sq.wqe_cnt, 6,
+				       &qp->raw_packet_qp.sq.ubuffer.buf_size))
+			return -EINVAL;
 	} else {
-		base->ubuffer.buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
-					 (qp->sq.wqe_cnt << 6);
+		if (check_shl_overflow(qp->rq.wqe_cnt, qp->rq.wqe_shift,
+				       &rq_buf_size))
+			return -EINVAL;
+		if (check_shl_overflow(qp->sq.wqe_cnt, 6, &sq_buf_size))
+			return -EINVAL;
+		if (check_add_overflow(rq_buf_size, sq_buf_size,
+				       &base->ubuffer.buf_size))
+			return -EINVAL;
 	}
 
 	return 0;
@@ -989,7 +1000,11 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	qp->rq.offset = 0;
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
-	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+	if (check_shl_overflow(qp->rq.wqe_cnt, qp->rq.wqe_shift,
+			       &qp->sq.offset)) {
+		err = -EINVAL;
+		goto err_bfreg;
+	}
 
 	err = set_user_buf_size(dev, qp, ucmd, base, attr);
 	if (err)
-- 
2.53.0



