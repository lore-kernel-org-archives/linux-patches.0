Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245619C542;
	Wed,  5 Mar 2025 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197975; cv=none; b=gQUdlk5P0rJ471zBljl6M72o4rACKtMx4BeV2elpQRZ8zHL0c0neTDwj+kuQ3nThyPZ/yfzZZ71BA4LD8t/5RKMjwNwdK2zWBUCgIJgdJFrI5Rfk2WqLIDhOJf1SNXs7j0GYe7M4la5odD1pKxt13AuZTac5SUNve8AY6iABs50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197975; c=relaxed/simple;
	bh=9+kxyz16AMhJGOy4ELXxxJMUD/HAiOeocdY+tVc3IYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItnlsjEs0tbCDSKtmKPLlDqS/AS+jMVlgiunN7UnAlZeivukHG0RqVa9wh/v/PpocYEKcqv8LeyPhzCdIh3RNjDmp0fwInkHLTC9Vay/2K8aXl2VEZr+A1vr9mUsloRniHoU2GCXg9tlekYDslhU/+R6NOpu6kjgdH+LZ1yTPqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNlvIQpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNlvIQpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21F2C4CEEC;
	Wed,  5 Mar 2025 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197975;
	bh=9+kxyz16AMhJGOy4ELXxxJMUD/HAiOeocdY+tVc3IYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNlvIQpFfXY15frpB8C3Let2wjysFSQXcG03TmSpfrDgMTAHV2f+aBdLXOVgX82SR
	 leN12Ax5CME0BpbtjVhJsdB9fKKp15IIdNFbIO88cuXKJP8DkuMjBG2Z1bh7exCghz
	 xAXuMBAgrBtWZJWfwitfuEHffO4QNAIZg3McxbHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/150] RDMA/mlx5: Fix AH static rate parsing
Date: Wed,  5 Mar 2025 18:47:31 +0100
Message-ID: <20250305174504.702665498@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit c534ffda781f44a1c6ac25ef6e0e444da38ca8af ]

Previously static rate wasn't translated according to our PRM but simply
used the 4 lower bytes.

Correctly translate static rate value passed in AH creation attribute
according to our PRM expected values.

In addition change 800GB mapping to zero, which is the PRM
specified value.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Link: https://patch.msgid.link/18ef4cc5396caf80728341eb74738cd777596f60.1739187089.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/ah.c | 3 ++-
 drivers/infiniband/hw/mlx5/qp.c | 6 +++---
 drivers/infiniband/hw/mlx5/qp.h | 1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 505bc47fd575d..99036afb3aef0 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -67,7 +67,8 @@ static void create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
 		ah->av.tclass = grh->traffic_class;
 	}
 
-	ah->av.stat_rate_sl = (rdma_ah_get_static_rate(ah_attr) << 4);
+	ah->av.stat_rate_sl =
+		(mlx5r_ib_rate(dev, rdma_ah_get_static_rate(ah_attr)) << 4);
 
 	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		if (init_attr->xmit_slave)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0d8a8b109a751..ded139b4e87aa 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3420,11 +3420,11 @@ static int ib_to_mlx5_rate_map(u8 rate)
 	return 0;
 }
 
-static int ib_rate_to_mlx5(struct mlx5_ib_dev *dev, u8 rate)
+int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate)
 {
 	u32 stat_rate_support;
 
-	if (rate == IB_RATE_PORT_CURRENT)
+	if (rate == IB_RATE_PORT_CURRENT || rate == IB_RATE_800_GBPS)
 		return 0;
 
 	if (rate < IB_RATE_2_5_GBPS || rate > IB_RATE_800_GBPS)
@@ -3569,7 +3569,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		       sizeof(grh->dgid.raw));
 	}
 
-	err = ib_rate_to_mlx5(dev, rdma_ah_get_static_rate(ah));
+	err = mlx5r_ib_rate(dev, rdma_ah_get_static_rate(ah));
 	if (err < 0)
 		return err;
 	MLX5_SET(ads, path, stat_rate, err);
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index b6ee7c3ee1ca1..2530e7730635f 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -56,4 +56,5 @@ int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn);
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter);
 int mlx5_ib_qp_event_init(void);
 void mlx5_ib_qp_event_cleanup(void);
+int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate);
 #endif /* _MLX5_IB_QP_H */
-- 
2.39.5



