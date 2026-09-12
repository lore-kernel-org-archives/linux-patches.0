Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF88E39524B;
	Sat, 12 Sep 2026 07:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199884; cv=none; b=XB5lF21xNHkYiaYMefW6SfQLu6dF4jD2ypEBFYHBenjMrqKYMAuHHP659ey1eX2cuaqapJhyBfzEP81OaVqKA4K9UqVJ8gD4Nc/ceUzVxeOypi1BMRCUob2HFVvyxGvBn1Y6LbAdGY0qmm2hXZado6737pI4O/XG+KbPWKlx2O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199884; c=relaxed/simple;
	bh=Wo2NcQU+0HIfnIbpt1Lme/tKo0XcuV0LlgV+b1DOBmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBEywmrTiQaddsEolKsNqSgod4LSFy1ULd25INp4Filu6bIvB3OeP7fTpBf8+pBW1tfaY7kyabBO3S7J4adM920Suxm2BZ3PG5V2BkSBY4w6bMXzGZicNct9eycHiW+KkPjARokSoTmTSgwaFJLNJndfnJtp3BJzBSeybejrDbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqiyjPa6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqiyjPa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA78A1F000FF;
	Sat, 12 Sep 2026 07:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199882;
	bh=/NVJwTHUF6hkZmGnQIZ24UT/hRN4RTmDLaNw12twLn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqiyjPa6LYdgUee5J12bmjbV94O2dQLaqYHMP8Foh0eE2zrtMqETDDQvx7ipF6r45
	 i0qT8J+BDa+vzsOep+eRUoHNQuELEn6W8SaK00bfcAfoMjavy7bxEht1TMf+2D2ZbZ
	 MgaCnqN9Op6pk71YR9Ws0XCy23jNvP7yek4aG2h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0675/1815] RDMA/mlx5: Fix integer overflow of user QP buffer size
Date: Sat, 12 Sep 2026 08:40:25 +0200
Message-ID: <20260912065704.733306024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7ff02d89c31d5..e25ac139e43f0 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -647,6 +647,7 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 			    struct ib_qp_init_attr *attr)
 {
 	int desc_sz = 1 << qp->sq.wqe_shift;
+	int rq_buf_size, sq_buf_size;
 
 	if (desc_sz > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq)) {
 		mlx5_ib_warn(dev, "desc_sz %d, max_sq_desc_sz %d\n",
@@ -671,11 +672,21 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 
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
@@ -1004,7 +1015,11 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
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



