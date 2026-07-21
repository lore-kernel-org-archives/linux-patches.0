Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F17474AE1;
	Tue, 21 Jul 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656672; cv=none; b=aLdXacith3Afz3CtQ4IxdL+ka0wyQbWugo2J1oE2UJ3SbEwhnfx3qOxN0+q06lKMFYI6eT8x3aRtFE++ViSf9CMwXApZ2A313KFnYA+kzSBnDSm7RTeM9wueU308DSccTRPmrswTszyhdbgn3+u1Ji08sp++apRkeqcziNcIuA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656672; c=relaxed/simple;
	bh=F2xuvSqcZMuCkymRSXkM/dO1aOx6uDndi/AG2pIOpds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5p67kAJRyW2RbizDvxVZb09TDGRgCXQ4Q7Hzdf9n+4kAPsE5XUeD7HYca1MOXA98Wf+b8W7Ki8a6AAbOMQOsrput0zq3+ON72zSdo6PbPdwwQL/f30NprUcx+Q7NW7e/H6BfzRo58y5fm2+P34kCas4hgpwFxg/5WEfRaqf4NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA6+hQUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA6+hQUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213401F000E9;
	Tue, 21 Jul 2026 17:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656668;
	bh=W2bNPju3EATBdLfONSVYruRcWk1qOaRdcfGmXseM8o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA6+hQUHGGABsUZyZH4EfBXd48aJ/XaOuuWU9aaxqeUisAxbJsO3eo5fdTKHSSj6+
	 CEbFL54PtH/s0sUPPB9+6joD/JFdrXMmkK1vyWWkCEiyrsLo/S6hL5SYQHkwn3Dgjd
	 wyO3pYeyIQmEqLrpPUap+xw7mz8NoDc2/446aqP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0475/1611] RDMA/mlx5: Fix undefined shift of user RQ WQE size
Date: Tue, 21 Jul 2026 17:09:51 +0200
Message-ID: <20260721152526.011811974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 49566479f70474..02a0f4920cabf1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -451,16 +451,13 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 
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



