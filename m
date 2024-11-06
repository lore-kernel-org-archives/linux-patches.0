Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410421CC89D;
	Wed,  6 Nov 2024 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899135; cv=none; b=eq9rpeeeFkhiC6iXoWonobnvh0yRvN8hliJEhFJDk74v+nrEXOSy9TWszzdtVSKma/EvZJqulGjKckVL9G7JP0sCEMboPs5cyn35K5t2KYQZJGCmod/TxjokRCrxwviI2aCr0nIpbV9zl1rRNMaNuk0o8iGmSIM5RBwvD76uiCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899135; c=relaxed/simple;
	bh=X7r8GxgCWwOOCiIro1NNEhL7PVboIg51Qp6UCGnDNqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua0KSIdp3Pn3QLeQQtlInNarQrlUH2RI/l0KrwDw64GXf9OGfIr28QZLRYcs2rYnPKGInVGEiLETJmAIylUw/bCLolDzT8he2734f+lReIG6xMNR0XNafT7/rs9UgITx2M3OjZthYfjE5xM7BWaMtbF2rKkwy+QPvxa0Pn7c44k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlJ41PSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlJ41PSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9706C4CECD;
	Wed,  6 Nov 2024 13:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899135;
	bh=X7r8GxgCWwOOCiIro1NNEhL7PVboIg51Qp6UCGnDNqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlJ41PSOvIsnC0HCGUubGx5cOJMID3G2aNwYkpnikAlgCEF4oLFkDTPZRDPq96krh
	 LiVcRDwKPTloeRlHaBmjypnU0ZXlNcATIBny4ErwrxbaLkvYjHZ4jBmp3iTkMmI2d+
	 u5yZg8OG6DAEwk2+VxLrk06Fe0dfO+O+Zv5c28Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/73] RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down
Date: Wed,  6 Nov 2024 13:05:15 +0100
Message-ID: <20241106120300.299958229@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d4b5ce37c2cbd..d2b4db783b254 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4182,14 +4182,14 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
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



