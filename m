Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E6F1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085BEC433C8;
	Tue,  1 Aug 2023 09:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883135;
	bh=bGiYOeR4ENs+Wwb5oTB4lhBqNrRMs90QIB4bCSX46mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwYsRpwEF+iecWm2yycUssSQts1dByNWSXNqzI9cm94wI/OtJ71JS/IY6gYWTjQfF
	 EnPsGhmFPIDtbn68xEgDQcNOy7cH1yQu+suvCZiizOKMepbb2m5wTVtgl5KwhkwkNa
	 fPUkStZMsXC6X4O+WqlJicFf+/0g7DWn8gXC/Nxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 099/239] RDMA/mlx4: Make check for invalid flags stricter
Date: Tue,  1 Aug 2023 11:19:23 +0200
Message-ID: <20230801091929.296890593@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d64b1ee12a168030fbb3e0aebf7bce49e9a07589 ]

This code is trying to ensure that only the flags specified in the list
are allowed.  The problem is that ucmd->rx_hash_fields_mask is a u64 and
the flags are an enum which is treated as a u32 in this context.  That
means the test doesn't check whether the highest 32 bits are zero.

Fixes: 4d02ebd9bbbd ("IB/mlx4: Fix RSS hash fields restrictions")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/233ed975-982d-422a-b498-410f71d8a101@moroto.mountain
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 456656617c33f..9d08aa99f3cb0 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -565,15 +565,15 @@ static int set_qp_rss(struct mlx4_ib_dev *dev, struct mlx4_ib_rss *rss_ctx,
 		return (-EOPNOTSUPP);
 	}
 
-	if (ucmd->rx_hash_fields_mask & ~(MLX4_IB_RX_HASH_SRC_IPV4	|
-					  MLX4_IB_RX_HASH_DST_IPV4	|
-					  MLX4_IB_RX_HASH_SRC_IPV6	|
-					  MLX4_IB_RX_HASH_DST_IPV6	|
-					  MLX4_IB_RX_HASH_SRC_PORT_TCP	|
-					  MLX4_IB_RX_HASH_DST_PORT_TCP	|
-					  MLX4_IB_RX_HASH_SRC_PORT_UDP	|
-					  MLX4_IB_RX_HASH_DST_PORT_UDP  |
-					  MLX4_IB_RX_HASH_INNER)) {
+	if (ucmd->rx_hash_fields_mask & ~(u64)(MLX4_IB_RX_HASH_SRC_IPV4	|
+					       MLX4_IB_RX_HASH_DST_IPV4	|
+					       MLX4_IB_RX_HASH_SRC_IPV6	|
+					       MLX4_IB_RX_HASH_DST_IPV6	|
+					       MLX4_IB_RX_HASH_SRC_PORT_TCP |
+					       MLX4_IB_RX_HASH_DST_PORT_TCP |
+					       MLX4_IB_RX_HASH_SRC_PORT_UDP |
+					       MLX4_IB_RX_HASH_DST_PORT_UDP |
+					       MLX4_IB_RX_HASH_INNER)) {
 		pr_debug("RX Hash fields_mask has unsupported mask (0x%llx)\n",
 			 ucmd->rx_hash_fields_mask);
 		return (-EOPNOTSUPP);
-- 
2.40.1



