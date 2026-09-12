Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F52A361DD0;
	Sat, 12 Sep 2026 10:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208273; cv=none; b=VI6AySqLLA3X1h0Z/I0EIWQpzABK7engN2q4CYhoVSeqNhS5pWoHivzsOqRNAdLOGXmq0RKjIgPDuPgQ50YxqZOAy8LAJ3WMUmcUUlVscKvpUdjv2pGyp3GSqNZU52nwNw5fY91Ccc483S/PHJ4cGZiz21WedwP73N0+/7SmSo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208273; c=relaxed/simple;
	bh=72RkQiziyJhJ8sOMkipuycZAlNk8XgI3b/5Ho4U5poU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/D8nV9l5gPahWQrdq+R/+ha6Co9rzDLBwu7lqzWYpYjL1Gh949yQTIu+PlHr3qiRP42rUwOT0t2dcheS2vFVfFaOR6fkBJrVbJZzGhktmDpVaD04oNbZiwnICPOfmIamLmTfksHlihMTuhQbSxa6xmoRqLwbtbjM2F+D5zUG/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDuY2lcF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDuY2lcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72A31F00893;
	Sat, 12 Sep 2026 10:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208271;
	bh=uBo96gxdj0Fv+6dE3KysYV6K4NNahfxZIFz79c927JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDuY2lcF5VTQrlUitfVl5E708511aL8brn+p/YVSzwBmDfzk3yvG2ZtiIWKUXi+Pz
	 9l44qShWbRw1DbuQdS81kvVpvTm4S810r4RjZoouLcGZEBJlTUGWoHjp/IdIXuGoOP
	 OoR8/Wsc4o0pdHRP8mM4+TmLXdeQUJ98vLxPZ0f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0583/1518] RDMA/mlx5: Fix integer overflow of user QP buffer size
Date: Sat, 12 Sep 2026 08:45:52 +0200
Message-ID: <20260912065636.614289806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02a0f4920cabf..50b20264c4bdd 100644
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



