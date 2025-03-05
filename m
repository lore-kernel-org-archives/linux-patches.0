Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E5253338;
	Wed,  5 Mar 2025 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198411; cv=none; b=bfzLvAIH3MF3+HKdzzNXe42ftRyHjap1F1h+pvA4oAFk8Lqr/kmf2dJ7YhHOPvDrQQ5ijZrPrBkIDXshH8Vz5VPlbaXky7UfZwKTD+sBgHMHyQcWqq6wlIGmjwrGj0jJcPDmPjDjk4QC8jTBME9ZoMF1LKb9l5Wg/8hvHmEZd7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198411; c=relaxed/simple;
	bh=Ukw6pboOhDJhKJZBg+G92epl4WdExiZegRiNeXx7+1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOHsEfkg4ILPTJ/ab/01UNClygaxA3qmDzf2vV6S50iQDSKOg0PSDkBgsROPztFhnCV5B6Dwyz3AWzea0h95hGsLofv9ODPYSQui6o6PZH3sLHdXftm/caMj6J1u2cPN4Uq1oqUYeRV04GzV9SdjXOgIV0BGyAm6U4mRk7XSz2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsSKRtny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsSKRtny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15647C4CED1;
	Wed,  5 Mar 2025 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198410;
	bh=Ukw6pboOhDJhKJZBg+G92epl4WdExiZegRiNeXx7+1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsSKRtnySPebMVPr7EoovThMD/2k0l2FMEUWq9FAM2TSqK8LaYYdCtLa6TvsLOyzc
	 yptpJ/brLGEiu0JjvKoTJ3KKRsZnKBTEArCGVzujithXH9U68rPTYyGB1XbYp+O1cn
	 NVuJXIEBKceD/vGClpX8KdoLwKPp1Xyulv2L8hR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 019/157] RDMA/mlx5: Fix AH static rate parsing
Date: Wed,  5 Mar 2025 18:47:35 +0100
Message-ID: <20250305174506.062530355@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 08d22db8dca91..88724d15705d4 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3447,11 +3447,11 @@ static int ib_to_mlx5_rate_map(u8 rate)
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
@@ -3596,7 +3596,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
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



