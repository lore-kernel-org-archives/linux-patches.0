Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED7146C4C7;
	Tue, 21 Jul 2026 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649493; cv=none; b=nyp1h0dDk0QGEQchbRkqYGOffIVYh70jfgLm0InFTu2uDfjCXcWIEAiNGRNU+a3qmcd+5JYj9HwkJWSI3zwS/k8sF1cd0MVu8oXsHIEgPwXWHNaHXTW1Kt8gR3QOghSs8TDbNi3sX/PzwVZ7v5TVCHo0mVxZgfOQPRqNx6kvnek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649493; c=relaxed/simple;
	bh=hRWrW0z/hka6rPiAuJfB+y+VIavZiFRt/SUIJNRCtLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsgpiEuPrwdTfoH5/IH7zTYbzoz0vXqGGhGDIcurWv6DHtbeVwFclt1DvGyFUcDy8k0l89N44O98U2sW2NTTD2J1FiPh69SpOSH8P8WPLV0YUGzgiq+xu3NCVP0tVaZY9jabEljbDFS5gKPODNGxUwGQUS289d9FE350LRxdoVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml2dniWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml2dniWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A515D1F00A3A;
	Tue, 21 Jul 2026 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649490;
	bh=EHX9WjOfcd6sOFEL9xPqUMjEWtjxYgnycnUmF8yVySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ml2dniWhVvrpapzJfW/TOnOaXC0VG5JI/VyizPckrFcB+hfseJ/QxE+wIkVKM2LC9
	 ThmWGGfnOdMSTJRl5+xKsVpuPupcMi6jjNAC9AGS3Zi657yM8X7GQDqSeCWEezWHWh
	 B1B4YXWrW3r0rP3RzIpLRKeCJW1xsuvp8NISfZ0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0554/2077] IB/mlx5: Dont mangle the mr->pd inside the rereg callback
Date: Tue, 21 Jul 2026 17:03:47 +0200
Message-ID: <20260721152605.878186198@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8e0a02a989c156ce17f06a645d5f075277e06b95 ]

The rereg protocol expects the core code to change mr->pd and synchronize
that change with the atomics and syncs. The driver should not touch it.

mlx5 needed to update it in umr_rereg_pas() because
mlx5r_umr_update_mr_pas() required the updated mr->pd to build the
UMR.

Simply switch mlx5r_umr_update_mr_pas() to use the pdn directly from
the new pd and remove the mr->pd update.

Fixes: 56e11d628c5d ("IB/mlx5: Added support for re-registration of MRs")
Link: https://patch.msgid.link/r/7-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Assisted-by: Codex:gpt-5-5
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index e29f5e628312b3..41ca3b1a6db079 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1130,10 +1130,8 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 	if (err)
 		return err;
 
-	if (flags & IB_MR_REREG_PD) {
-		mr->ibmr.pd = pd;
+	if (flags & IB_MR_REREG_PD)
 		upd_flags |= MLX5_IB_UPD_XLT_PD;
-	}
 	if (flags & IB_MR_REREG_ACCESS) {
 		mr->access_flags = access_flags;
 		upd_flags |= MLX5_IB_UPD_XLT_ACCESS;
@@ -1143,7 +1141,7 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 	mr->ibmr.length = new_umem->length;
 	mr->page_shift = order_base_2(page_size);
 	mr->umem = new_umem;
-	err = mlx5r_umr_update_mr_pas(mr, upd_flags, mlx5_mr_pdn(mr));
+	err = mlx5r_umr_update_mr_pas(mr, upd_flags, to_mpd(pd)->pdn);
 	if (err) {
 		/*
 		 * The MR is revoked at this point so there is no issue to free
-- 
2.53.0



