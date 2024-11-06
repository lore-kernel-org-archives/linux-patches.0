Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF87C1F130F;
	Wed,  6 Nov 2024 12:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896763; cv=none; b=oBA5LhRFINHrAdUvXlQl4eO+oBKJAF8Ual1a9Jra6DVkoAcl69oTqIVVX6K1WAB95CDES4HuZP0DTS1wgVLVsox7mxC9pW9UKJZO/kv51oujPWZxVYJAPs6QuEianD5XBK98zJP4etwSR53y0tJc18bmHWDtm/zP4Lap6TC6jhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896763; c=relaxed/simple;
	bh=dSLiZLGxjUMR6LMF/j1c33vZyfb8+ZM1i2JHwSzJB5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3Ulzp7u7q9DtkV7gq2Cf+OttoemCI6vVQ+x6HGJvDhPscq0ZJ2GjcLaw0jokreMawcmAVxisyA0MsUD0Q2dN5LI7C15ktXoyUyaSLRnDxJ80olXpgzw7tt9DvSgmEfMkXjlfpCvJNz2Rymrt6+q6ggr8NN/rs/L2epAnHnHUA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogwcox5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogwcox5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE70C4CED5;
	Wed,  6 Nov 2024 12:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896763;
	bh=dSLiZLGxjUMR6LMF/j1c33vZyfb8+ZM1i2JHwSzJB5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogwcox5TY5dPd3dCmIAAiy+Q1zJy2mI66rNxph4TMcAV740QLOI6JudGlKU9UepAc
	 BMXWhr2RC09FtG9udFjLVJucxKRDWLYkUO0VlA2U5UgBqK7VOXKUrOPaNh4t4rwaIn
	 m9yLQnlbqs5P8hUP1fyGoY7RZgwTu/0yGlglVZLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/110] RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down
Date: Wed,  6 Nov 2024 13:04:29 +0100
Message-ID: <20241106120304.936755477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 78ed28e08e74da6265e49e19206e1bcb8b9a7f0d ]

After the cited commit below max_dest_rd_atomic and max_rd_atomic values
are being rounded down to the next power of 2. As opposed to the old
behavior and mlx4 driver where they used to be rounded up instead.

In order to stay consistent with older code and other drivers, revert to
using fls round function which rounds up to the next power of 2.

Fixes: f18e26af6aba ("RDMA/mlx5: Convert modify QP to use MLX5_SET macros")
Link: https://patch.msgid.link/r/d85515d6ef21a2fa8ef4c8293dce9b58df8a6297.1728550179.git.leon@kernel.org
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e3cc856e70e5d..e0db91d1e7492 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3940,14 +3940,14 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC && attr->max_rd_atomic)
-		MLX5_SET(qpc, qpc, log_sra_max, ilog2(attr->max_rd_atomic));
+		MLX5_SET(qpc, qpc, log_sra_max, fls(attr->max_rd_atomic - 1));
 
 	if (attr_mask & IB_QP_SQ_PSN)
 		MLX5_SET(qpc, qpc, next_send_psn, attr->sq_psn);
 
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC && attr->max_dest_rd_atomic)
 		MLX5_SET(qpc, qpc, log_rra_max,
-			 ilog2(attr->max_dest_rd_atomic));
+			 fls(attr->max_dest_rd_atomic - 1));
 
 	if (attr_mask & (IB_QP_ACCESS_FLAGS | IB_QP_MAX_DEST_RD_ATOMIC)) {
 		err = set_qpc_atomic_flags(qp, attr, attr_mask, qpc);
-- 
2.43.0



