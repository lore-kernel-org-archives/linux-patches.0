Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE30646C4C7;
	Tue, 21 Jul 2026 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649763; cv=none; b=fxotRF5F7eM0axV2dlOkrhXfwgpRVhbFVFEFaDQ/85sg68agCrSAgaBNMPXn1G0Iffigs+VtGmfwXOrZVovDtBjnDn6dydvg7sChvZITFj3eCmiX7BO1ym6BQk3D8e9XkCTNbH9PX8bMPdQw/m4upXRfh5zNjwzlQVlrD59rz9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649763; c=relaxed/simple;
	bh=bGaZ/vK4W4i5Jxq/blWmBtUzaFrZO/ZvnpxRTGUHGJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/T37JKiEl+zeGs9BJk/Hw1LYrk4IRitp6RTc0c8Prs3mDntpkgrQOYvB8A5dRAH5k2C3XrP6KouEYvYzQKb880VG4LZ1Wcp9d/rjhzRDX7/lqemIhengnjqIu83aUNAw2OTKbIMrcAJChgolJgxJDql90NQOXeHVJOBy+TTbMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeRUmsq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeRUmsq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA2E1F000E9;
	Tue, 21 Jul 2026 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649761;
	bh=M1EvFt1r5yLmtk/Dprh4h59qeHFkgCAesA6s1QhGQf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeRUmsq7HzowkqMeYTf+hqHqHXdF0u2IuXnRF5iF0g3lsNEBJBiDzPGsVMhkIDXrU
	 4qj5y0EUHC6ZerfC0e7SzVOc2LJ9Xf8+F1JIfaIqNAJ7ICcKCqOzhkCF31Md6vddv1
	 5P4IakXGw+3HMlQXIohWlXMyszER8pqxs360Vxxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0698/2077] RDMA/mlx5: Fix undefined shift of user RQ WQE size
Date: Tue, 21 Jul 2026 17:06:11 +0200
Message-ID: <20260721152609.257673292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 767444bcbce5d2..3dc0c85587fffd 100644
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



