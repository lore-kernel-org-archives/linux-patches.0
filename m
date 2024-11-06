Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87DA1F9AA7;
	Wed,  6 Nov 2024 12:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897318; cv=none; b=FEJPBYTjdNEwnAkP5pdcbKFREHK6H1qyc340faa+xR/h/thH6BC7DKDp/qhT57i9jfh2boIcZ1S+XgR9jajnqWT9nNMVbM/QAKHvQOnnCQD9PPLFkG+jqKm2R8uMGcIaG/21tGdEtKZM4hScUvPj+wG2FFcNDi8ayCa+pXQEptk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897318; c=relaxed/simple;
	bh=SF94qhWKaRhgLCF8FJzvRsXAs5+40ppN7nzQtEqNclQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBYngDNFNHIhONh8XqL3cWxx1MFO2ask2VzC9d6dDZ+LdeiJ9srkcyMLiQY/vvppK4wYN+7LpWwwbh9TRPbBw5i25OQhGCcB8MAfU8Y1Ib3cHehelNABmy0KmkfYeN9QA24HmXkS/BqGPLc6AnflWVM9eNOhhehKM+waMbEZONg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYHVgx2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYHVgx2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6DBC4CECD;
	Wed,  6 Nov 2024 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897318;
	bh=SF94qhWKaRhgLCF8FJzvRsXAs5+40ppN7nzQtEqNclQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYHVgx2rIXquu6Q8id3rYV/R1LbL81HwM3binuiM/sR6FqhfRQa5KE2OUziNoc/BC
	 w19UXCGvHTkqfdc06q7jmmKbVhiOLc++Ley/BMp7KKCO5omaZPHFJLBVOrugF0/aut
	 r1SbY7rCR7KTs1jHSBsptnwIdZIt6CYrV9166lY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/151] RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down
Date: Wed,  6 Nov 2024 13:03:22 +0100
Message-ID: <20241106120309.229363416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2340baaba8e67..93d9b15cbbb98 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4272,14 +4272,14 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
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



