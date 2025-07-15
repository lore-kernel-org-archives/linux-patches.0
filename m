Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB1C2E610D;
	Tue, 15 Jul 2025 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586494; cv=none; b=OAL1vtDMg/Ke28MoVJXKNxNhMf2CYtDPOtR69w7dYg74djoGmbe9Cr45VTcR4d64F0+zvJzScVT5vrtbqOiZ8KB8dz/sMXdpO9bTTLMODsPU4egmqXYvQCBjAmtmIPPgfX3dQXXRHUwYVnwQYP2jnDGxi1yNHovxYoypv40c4Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586494; c=relaxed/simple;
	bh=z9WuE6ZHF/PgEdkovItnMP21Vg96aAFJWFJ/8pCUo5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm+Hrviz8Ov/s6pMBaeJKO1SQXFc+TTuxPXYSeAAd3mjzCjkdXJTgL7Y6IhcXisPWaHl+iBY/mZxMEI0G1b8goS7eQWiBjgUB2HUfZDo/q4K0BfUs1GsJ+UbyGWl+EKc7waUnx1YReVio0sa2rGBMXdW1LzopymcuHpNirK9QfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrfnEc1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrfnEc1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FA8C4CEE3;
	Tue, 15 Jul 2025 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586494;
	bh=z9WuE6ZHF/PgEdkovItnMP21Vg96aAFJWFJ/8pCUo5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrfnEc1TNCsS1D1bdZbSEYytvfLWlZ6KmA5aBqxLHHlerseunEhfE+ovY845sNrVP
	 0IQ414X6z4xIVn1d+NJ6NL4WfG26bes2Lo3uCF2kV7l1P60SgHpfoOH7AF7HDSlA26
	 06J8BhIxBQGvpmXz4oL4wNltIR15sCJUk16Y6YCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@mellanox.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/148] RDMA/core: Create and destroy counters in the ib_core
Date: Tue, 15 Jul 2025 15:13:28 +0200
Message-ID: <20250715130803.761648552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 3b023e1b680a56e84c22d43486875a5aa4c78afe ]

Move allocation and destruction of counters under ib_core responsibility

Link: https://lore.kernel.org/r/20200630101855.368895-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: acd245b1e33f ("RDMA/mlx5: Fix CC counters query for MPV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c              |  1 +
 .../core/uverbs_std_types_counters.c          | 17 ++++++++--------
 drivers/infiniband/hw/mlx5/main.c             | 20 ++++++-------------
 include/rdma/ib_verbs.h                       |  7 ++++---
 4 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c46d68e6ccd0e..cf3c0d6928ac2 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2683,6 +2683,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, unmap_fmr);
 
 	SET_OBJ_SIZE(dev_ops, ib_ah);
+	SET_OBJ_SIZE(dev_ops, ib_counters);
 	SET_OBJ_SIZE(dev_ops, ib_cq);
 	SET_OBJ_SIZE(dev_ops, ib_pd);
 	SET_OBJ_SIZE(dev_ops, ib_srq);
diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
index 35e41c5ca1bb1..95b66ce4943b4 100644
--- a/drivers/infiniband/core/uverbs_std_types_counters.c
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -46,7 +46,9 @@ static int uverbs_free_counters(struct ib_uobject *uobject,
 	if (ret)
 		return ret;
 
-	return counters->device->ops.destroy_counters(counters);
+	counters->device->ops.destroy_counters(counters);
+	kfree(counters);
+	return 0;
 }
 
 static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_CREATE)(
@@ -66,20 +68,19 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_CREATE)(
 	if (!ib_dev->ops.create_counters)
 		return -EOPNOTSUPP;
 
-	counters = ib_dev->ops.create_counters(ib_dev, attrs);
-	if (IS_ERR(counters)) {
-		ret = PTR_ERR(counters);
-		goto err_create_counters;
-	}
+	counters = rdma_zalloc_drv_obj(ib_dev, ib_counters);
+	if (!counters)
+		return -ENOMEM;
 
 	counters->device = ib_dev;
 	counters->uobject = uobj;
 	uobj->object = counters;
 	atomic_set(&counters->usecnt, 0);
 
-	return 0;
+	ret = ib_dev->ops.create_counters(counters, attrs);
+	if (ret)
+		kfree(counters);
 
-err_create_counters:
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fb5a1b4abcbce..d30c37688bdac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6113,7 +6113,7 @@ static int mlx5_ib_read_counters(struct ib_counters *counters,
 	return ret;
 }
 
-static int mlx5_ib_destroy_counters(struct ib_counters *counters)
+static void mlx5_ib_destroy_counters(struct ib_counters *counters)
 {
 	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
 
@@ -6121,24 +6121,15 @@ static int mlx5_ib_destroy_counters(struct ib_counters *counters)
 	if (mcounters->hw_cntrs_hndl)
 		mlx5_fc_destroy(to_mdev(counters->device)->mdev,
 				mcounters->hw_cntrs_hndl);
-
-	kfree(mcounters);
-
-	return 0;
 }
 
-static struct ib_counters *mlx5_ib_create_counters(struct ib_device *device,
-						   struct uverbs_attr_bundle *attrs)
+static int mlx5_ib_create_counters(struct ib_counters *counters,
+				   struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_ib_mcounters *mcounters;
-
-	mcounters = kzalloc(sizeof(*mcounters), GFP_KERNEL);
-	if (!mcounters)
-		return ERR_PTR(-ENOMEM);
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
 
 	mutex_init(&mcounters->mcntrs_mutex);
-
-	return &mcounters->ibcntrs;
+	return 0;
 }
 
 static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
@@ -6296,6 +6287,7 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
 	.resize_cq = mlx5_ib_resize_cq,
 
 	INIT_RDMA_OBJ_SIZE(ib_ah, mlx5_ib_ah, ibah),
+	INIT_RDMA_OBJ_SIZE(ib_counters, mlx5_ib_mcounters, ibcntrs),
 	INIT_RDMA_OBJ_SIZE(ib_cq, mlx5_ib_cq, ibcq),
 	INIT_RDMA_OBJ_SIZE(ib_pd, mlx5_ib_pd, ibpd),
 	INIT_RDMA_OBJ_SIZE(ib_srq, mlx5_ib_srq, ibsrq),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 30d50528d710e..7e5df8218689e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2468,9 +2468,9 @@ struct ib_device_ops {
 	struct ib_mr *(*reg_dm_mr)(struct ib_pd *pd, struct ib_dm *dm,
 				   struct ib_dm_mr_attr *attr,
 				   struct uverbs_attr_bundle *attrs);
-	struct ib_counters *(*create_counters)(
-		struct ib_device *device, struct uverbs_attr_bundle *attrs);
-	int (*destroy_counters)(struct ib_counters *counters);
+	int (*create_counters)(struct ib_counters *counters,
+			       struct uverbs_attr_bundle *attrs);
+	void (*destroy_counters)(struct ib_counters *counters);
 	int (*read_counters)(struct ib_counters *counters,
 			     struct ib_counters_read_attr *counters_read_attr,
 			     struct uverbs_attr_bundle *attrs);
@@ -2563,6 +2563,7 @@ struct ib_device_ops {
 	int (*counter_update_stats)(struct rdma_counter *counter);
 
 	DECLARE_RDMA_OBJ_SIZE(ib_ah);
+	DECLARE_RDMA_OBJ_SIZE(ib_counters);
 	DECLARE_RDMA_OBJ_SIZE(ib_cq);
 	DECLARE_RDMA_OBJ_SIZE(ib_pd);
 	DECLARE_RDMA_OBJ_SIZE(ib_srq);
-- 
2.39.5



