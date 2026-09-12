Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073BC377ABA;
	Sat, 12 Sep 2026 18:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239253; cv=none; b=g0DjNE4CDxF+VFRWpROYxm2fIglDsoxLztvolnsNRw9p6TPcsiEmERqflnuCLVPn1oe6hMzVDPFWIjbo9UT3NAlhvH0Sq199NXL9t1WEwVxb7uypzmMoXTiCteeVK74S1OHDTsQcqbn6ms8BpUwLru8YpNsArTni0fa/35gs8+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239253; c=relaxed/simple;
	bh=MsqZQ8SD8nJYvbg+Hz4IvOmlo0s3Ks0RcCkyLlBJKxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2XPQ3KwGDZ70nvClcsqNGlcCzqQo2H2h8cyGcdhiqxbBcHCpkTDpGiWJp2I4CpXyikNsuoxlQmiMBfgA+Aup5K04PaKe5/jy7V7XHXygdBbpP0I1NJ3KI+rEEJeCan6pEEF6Ffhk7u8LU+T9QP4Bfh6VXHo3n9/wDtcw2Wv3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH2ESLiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH2ESLiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271841F000FF;
	Sat, 12 Sep 2026 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239251;
	bh=DOxWkG7gvhxIBglFdNLI9yUVu7s7Z2aoObMR073+J8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mH2ESLiMLuqV9HDABHSnpo8U+0q/A0jGHwrSvBcdsLpW4ueMsHDZqSfSHW2danm/r
	 Ag3ty30zdAAbDSIdK3YnLesWYIK+DGXS3EgtBcoX7kiqqIiWyPP1bq5ctWyKUS0NDT
	 6Tzv3BVjvIgvffX05y9M03qf9j/9cA7M6jyohM6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 625/935] RDMA/mlx5: Send cong param changes to the resolved port mdev
Date: Sat, 12 Sep 2026 09:00:55 +0200
Message-ID: <20260912065541.172982521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 033a79e308e4fe832b0924347eda8c4364055174 ]

mlx5_ib_set_cc_params() resolves the port-specific mlx5_core_dev via
mlx5_ib_get_native_port_mdev() but issued MLX5_CMD_OP_MODIFY_CONG_PARAMS
through dev->mdev. On an affiliated secondary RoCE port those pointers
refer to different devices, so a write to the secondary port's cc_params
debugfs file either altered the master port or failed with a master-side
command error, while the read path already used the resolved mdev and
returned the unchanged secondary value.

Issue the command to the resolved mdev, the same device whose capabilities
were checked when its debugfs directory was created. It is already
referenced by the get/put pair, so its lifetime is safe.

Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
Link: https://patch.msgid.link/20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 80dac4496e1d2..3aaf0b4262d4f 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -339,7 +339,7 @@ static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u32 port_num,
 	MLX5_SET(field_select_r_roce_rp, field, field_select_r_roce_rp,
 		 attr_mask);
 
-	err = mlx5_cmd_exec_in(dev->mdev, modify_cong_params, in);
+	err = mlx5_cmd_exec_in(mdev, modify_cong_params, in);
 	kvfree(in);
 alloc_err:
 	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
-- 
2.53.0



