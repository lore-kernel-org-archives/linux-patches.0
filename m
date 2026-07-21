Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B063C1081;
	Tue, 21 Jul 2026 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671678; cv=none; b=XYhHwQAjTwroKUTUmoUSTy7lCV5x7s33ICIzNAj6m5D3Dovc8Vxq+jQutaDK1UiSdZRi7f7GXpezul4sdLtllD9MljzDphYEJYfC4iqW9r9sxwxmy1Lakcey6jSfwy0AD5SaxdYbIDd7ri/cu5OLYpJWhXbWQEwo5+0RRjIW+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671678; c=relaxed/simple;
	bh=AnwralXb6wlrtt+zMF+CsWbrTzz+xMH+UwWRJ6lKSKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEEgiW6pvLjtqf2CvR9bx0B+T2FHCK/2dVAiLNXnQGIQUmxjIPwPCuNgqLtURwvve7KE9+tQsvx0GQv5Xk3kzhgweAhr1ticAZZ3vjY3KcragzmJi3OKQKwWYemnsT2D/o2zLY+9WXSAAs0eFBBlgRMlIyu0HoPXHljNO+InRDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSpCvNej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSpCvNej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CFA1F000E9;
	Tue, 21 Jul 2026 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671677;
	bh=kK20lNvZWlwhRvp4LbRxZWT4EgSJtKGhTBqP1b2Y/Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSpCvNej9+tYB3rOfYVrEDSmfebOX9vx2kQaGCV02qlaj7iYLC0D1ZSsYF2thPqIG
	 AzersEuaab8cMPJK7B82IEZvVJfNrCoykCkDtCjYuzVbMPPkRlYXEO2osAKQDMyIoj
	 tF+kf+TE5JjH4nPQiL+XJO9MHUuGBivXmb2NfOTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/843] RDMA/mlx5: Fix undefined shift of user RQ WQE size
Date: Tue, 21 Jul 2026 17:19:32 +0200
Message-ID: <20260721152413.603599663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit d881d60223aac8fdc12b227d89c76e131e92a9cd ]

set_rq_size() computes the RQ WQE size as "1 << rq_wqe_shift" based on
the user-provided rq_wqe_shift, which is only checked to be greater than
32, so shifts of 32 are still accepted. A shift of 31 also overflows a
signed integer, leading to undefined behavior.

Use check_shl_overflow() to compute the RQ WQE size and reject any
invalid values.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://patch.msgid.link/r/20260611-maher-sec-fixes-v1-1-cd8eb2542869@nvidia.com
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f15b89be3b0b92..127468dd06a015 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -369,16 +369,13 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 
 		if (ucmd) {
 			qp->rq.wqe_cnt = ucmd->rq_wqe_count;
-			if (ucmd->rq_wqe_shift > BITS_PER_BYTE * sizeof(ucmd->rq_wqe_shift))
-				return -EINVAL;
 			qp->rq.wqe_shift = ucmd->rq_wqe_shift;
-			if ((1 << qp->rq.wqe_shift) /
-				    sizeof(struct mlx5_wqe_data_seg) <
-			    wq_sig)
+			if (check_shl_overflow(1, qp->rq.wqe_shift, &wqe_size))
+				return -EINVAL;
+			if (wqe_size / sizeof(struct mlx5_wqe_data_seg) < wq_sig)
 				return -EINVAL;
 			qp->rq.max_gs =
-				(1 << qp->rq.wqe_shift) /
-					sizeof(struct mlx5_wqe_data_seg) -
+				wqe_size / sizeof(struct mlx5_wqe_data_seg) -
 				wq_sig;
 			qp->rq.max_post = qp->rq.wqe_cnt;
 		} else {
-- 
2.53.0



