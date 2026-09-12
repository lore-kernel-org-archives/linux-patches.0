Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D8E38F620;
	Sat, 12 Sep 2026 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242781; cv=none; b=jigutfoSl3UTU9sFQTmuQhGrgznzagYPpAccvANLd77d3c2iUYz8HzDr7oZv27z3RLw7DhcjheoZgsS0+bRtng+qAhbgZY0102Ckz42trSXWZTgm1WjVO1th6xEDlumDApoIWqxjyEAr0c1H7W7wq7pkJE7FU+d6XzW1l5PDEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242781; c=relaxed/simple;
	bh=3CxN8HyleAd4/i3A+fAXpOW/G4DKoiXpz7Ijl2REbRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mqs2gM266hjdiThxEzop9ufRO1mDoT3uy1MK6q0QGBxTFxcTlh8dFGuMQ5/X5gHopUI4fdnrAodGfeXlPQEeUUlKavCLeCV3GpWnGV+b3erRDZ84EXymNDu85YQC925aOdOAzj1IyVD/GNcA1bUKhyQpUYWDoGnNHORn7XBsmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCHR3SRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCHR3SRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8D91F000FF;
	Sat, 12 Sep 2026 19:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242779;
	bh=X3RbQwiedKnJ21hi5AXiWUG4v8qGJ5R8PJIWwkIWiog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCHR3SRE85MV7Ud56wxlOIgo7bA2plCe0M8DqnJJ6TQiT5u/HMgo55F2VOA8yaVD1
	 ovi+cssTcjqhhapWq9lU4+fQ0iNCuC56EHnPjwbzEsgMCyJNre4mI07MBOkLgxHqn7
	 NwDjL6ZBFCJGqfHVhTWiAEhQy+zQwWNMVhTZnjHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 517/798] RDMA/mlx5: Fix integer overflow of user QP buffer size
Date: Sat, 12 Sep 2026 09:02:25 +0200
Message-ID: <20260912065528.984827246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f83629ceb8af..0eee841596049 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -555,6 +555,7 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 			    struct ib_qp_init_attr *attr)
 {
 	int desc_sz = 1 << qp->sq.wqe_shift;
+	int rq_buf_size, sq_buf_size;
 
 	if (desc_sz > MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq)) {
 		mlx5_ib_warn(dev, "desc_sz %d, max_sq_desc_sz %d\n",
@@ -579,11 +580,21 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 
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
@@ -939,7 +950,11 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
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



