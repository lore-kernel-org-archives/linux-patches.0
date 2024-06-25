Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F96146592;
	Tue, 25 Jun 2024 10:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309662; cv=none; b=dh5Lf7uHhLVAYvPbl/nTD75yaevoYRxkny9Ib4dvjjlzLC2D5v1xaFABP1rHmPqXm2SC2UV3oVGwZLnmjtTMsRF1LPFAcd8rOBYGPBzimouVbx5MTDMmBVzeh70biBujrXYsfohtp/SmhDQ1DnwKwPQa2RxSBQcTt8R0BHLuUvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309662; c=relaxed/simple;
	bh=B5etV/LQxjtUFXe3zRggUCX2l4NPYWUgldTTqqGKLm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSfVc9GShG726JdhMzYmZUufuRhHbH3Su5lUJjsrODvHu6DOxNU6YC6SxFUsIMFY944Lsp0s5G7nlFtELUtZNjF0mvwghwo0kI0XmKg5MyuqZNFi9o1PUnfQHTJmS3+lRUP9aBdMDmvNjgpROxqwRBa9al5F+ptJI2vM22ObLI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=na0FrDxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="na0FrDxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B972FC32781;
	Tue, 25 Jun 2024 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309662;
	bh=B5etV/LQxjtUFXe3zRggUCX2l4NPYWUgldTTqqGKLm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=na0FrDxWPtLxXpCewICj6WAGmvqSb+oA0feJzxf6SSvL4kTR8xtzmjymRvdvH5bd/
	 Itj+LznJZ6P2NCsEKuYOlF3CXbOapMVSNWrnpQG76+X+OCWxkDFllOPOhlJzE//CFo
	 vXC+ua2qvQplXPz1aL8ahkidnriIrhz8mglKn+jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/131] RDMA/mlx5: Add check for srq max_sge attribute
Date: Tue, 25 Jun 2024 11:34:06 +0200
Message-ID: <20240625085529.395623570@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 36ab7ada64caf08f10ee5a114d39964d1f91e81d ]

max_sge attribute is passed by the user, and is inserted and used
unchecked, so verify that the value doesn't exceed maximum allowed value
before using it.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/277ccc29e8d57bfd53ddeb2ac633f2760cf8cdd0.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 09b365a98bbf3..731e6721a82bc 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -199,17 +199,20 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	int err;
 	struct mlx5_srq_attr in = {};
 	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
+			    sizeof(struct mlx5_wqe_data_seg);
 
 	if (init_attr->srq_type != IB_SRQT_BASIC &&
 	    init_attr->srq_type != IB_SRQT_XRC &&
 	    init_attr->srq_type != IB_SRQT_TM)
 		return -EOPNOTSUPP;
 
-	/* Sanity check SRQ size before proceeding */
-	if (init_attr->attr.max_wr >= max_srq_wqes) {
-		mlx5_ib_dbg(dev, "max_wr %d, cap %d\n",
-			    init_attr->attr.max_wr,
-			    max_srq_wqes);
+	/* Sanity check SRQ and sge size before proceeding */
+	if (init_attr->attr.max_wr >= max_srq_wqes ||
+	    init_attr->attr.max_sge > max_sge_sz) {
+		mlx5_ib_dbg(dev, "max_wr %d,wr_cap %d,max_sge %d, sge_cap:%d\n",
+			    init_attr->attr.max_wr, max_srq_wqes,
+			    init_attr->attr.max_sge, max_sge_sz);
 		return -EINVAL;
 	}
 
-- 
2.43.0



