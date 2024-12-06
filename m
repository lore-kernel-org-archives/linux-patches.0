Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3B353A7;
	Fri,  6 Dec 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497556; cv=none; b=epmJrO5i8jKyufpC9dSBN8wGTnTjoYxZRc9ujghm2s3kxsGHmCulHepfgBSKUvPWscjC9Pqc8QLT8homWr8RjTJWwA59KNOKLoXwDVmoKXhKi/7Ez5Z6IAPZl2aPMbsNlWdb4knl0k3hUY8T9GbOyYU7kYFO20qqKI6gbC4OHVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497556; c=relaxed/simple;
	bh=rYnij2zkF+m2FkMHZ2NBYRmWRubtAVuD1C72tKXyjdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cejR+76OyRIOadQ41/wAuiiLuTBCJlN7yVu4S4rySaz/gN7nsa1Jg/vDIQI93kgiPm5Bhq+YbnP7xVioWWE0ZPhrQDOL58hs7wgP7uchwMiyMYm+PxhzyCMocUV+1HG5ScDNQh221OH381JikfKb0OiMl4kGWQNYfvFtZR8pLII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChFsk/8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChFsk/8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4A4C4CED1;
	Fri,  6 Dec 2024 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497556;
	bh=rYnij2zkF+m2FkMHZ2NBYRmWRubtAVuD1C72tKXyjdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChFsk/8YZUj7SVVcP6ebzXe8f8IO9skrmlKnzdOJqRZ9m+sCy58SNsfln2vKFcela
	 L0dR5h1v0AMXy6Y/U5Ob2izuzx+jlZTNBPSd/gbUEVitmDWjxmduk2tzxVCxwjkPPv
	 3pf4X6Bbus8TIy7NdbbCjoG6yZJL4h0ytOjOF9Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 324/676] IB/mlx5: Allocate resources just before first QP/SRQ is created
Date: Fri,  6 Dec 2024 15:32:23 +0100
Message-ID: <20241206143706.001401287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 5895e70f2e6e8dc67b551ca554d6fcde0a7f0467 ]

Previously, all IB dev resources are initialized on driver load. As
they are not always used, move the initialization to the time when
they are needed.

To be more specific, move PD (p0) and CQ (c0) initialization to the
time when the first SRQ is created. and move SRQs（s0 and s1)
initialization to the time first QP is created. To avoid concurrent
creations, two new mutexes are also added.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Link: https://lore.kernel.org/r/98c3e53a8cc0bdfeb6dec6e5bb8b037d78ab00d8.1717409369.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ede132a5cf55 ("RDMA/mlx5: Move events notifier registration to be after device registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 149 +++++++++++++++++++--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   4 +
 drivers/infiniband/hw/mlx5/qp.c      |   4 +
 drivers/infiniband/hw/mlx5/srq.c     |   4 +
 4 files changed, 118 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 296af7a5c2794..bc38af6cda6ee 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2796,37 +2796,72 @@ static u8 mlx5_get_umr_fence(u8 umr_fence_cap)
 	}
 }
 
-static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
+int mlx5_ib_dev_res_cq_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
-	struct ib_srq_init_attr attr;
-	struct ib_device *ibdev;
 	struct ib_cq_init_attr cq_attr = {.cqe = 1};
-	int port;
+	struct ib_device *ibdev;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
 	int ret = 0;
 
-	ibdev = &dev->ib_dev;
 
-	if (!MLX5_CAP_GEN(dev->mdev, xrc))
-		return -EOPNOTSUPP;
+	/*
+	 * devr->c0 is set once, never changed until device unload.
+	 * Avoid taking the mutex if initialization is already done.
+	 */
+	if (devr->c0)
+		return 0;
 
-	devr->p0 = ib_alloc_pd(ibdev, 0);
-	if (IS_ERR(devr->p0))
-		return PTR_ERR(devr->p0);
+	mutex_lock(&devr->cq_lock);
+	if (devr->c0)
+		goto unlock;
 
-	devr->c0 = ib_create_cq(ibdev, NULL, NULL, NULL, &cq_attr);
-	if (IS_ERR(devr->c0)) {
-		ret = PTR_ERR(devr->c0);
-		goto error1;
+	ibdev = &dev->ib_dev;
+	pd = ib_alloc_pd(ibdev, 0);
+	if (IS_ERR(pd)) {
+		ret = PTR_ERR(pd);
+		mlx5_ib_err(dev, "Couldn't allocate PD for res init, err=%d\n", ret);
+		goto unlock;
 	}
 
-	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn0, 0);
-	if (ret)
-		goto error2;
+	cq = ib_create_cq(ibdev, NULL, NULL, NULL, &cq_attr);
+	if (IS_ERR(cq)) {
+		ret = PTR_ERR(cq);
+		mlx5_ib_err(dev, "Couldn't create CQ for res init, err=%d\n", ret);
+		ib_dealloc_pd(pd);
+		goto unlock;
+	}
 
-	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn1, 0);
+	devr->p0 = pd;
+	devr->c0 = cq;
+
+unlock:
+	mutex_unlock(&devr->cq_lock);
+	return ret;
+}
+
+int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_ib_resources *devr = &dev->devr;
+	struct ib_srq_init_attr attr;
+	struct ib_srq *s0, *s1;
+	int ret = 0;
+
+	/*
+	 * devr->s1 is set once, never changed until device unload.
+	 * Avoid taking the mutex if initialization is already done.
+	 */
+	if (devr->s1)
+		return 0;
+
+	mutex_lock(&devr->srq_lock);
+	if (devr->s1)
+		goto unlock;
+
+	ret = mlx5_ib_dev_res_cq_init(dev);
 	if (ret)
-		goto error3;
+		goto unlock;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.attr.max_sge = 1;
@@ -2834,10 +2869,11 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 	attr.srq_type = IB_SRQT_XRC;
 	attr.ext.cq = devr->c0;
 
-	devr->s0 = ib_create_srq(devr->p0, &attr);
-	if (IS_ERR(devr->s0)) {
-		ret = PTR_ERR(devr->s0);
-		goto err_create;
+	s0 = ib_create_srq(devr->p0, &attr);
+	if (IS_ERR(s0)) {
+		ret = PTR_ERR(s0);
+		mlx5_ib_err(dev, "Couldn't create SRQ 0 for res init, err=%d\n", ret);
+		goto unlock;
 	}
 
 	memset(&attr, 0, sizeof(attr));
@@ -2845,29 +2881,48 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 	attr.attr.max_wr = 1;
 	attr.srq_type = IB_SRQT_BASIC;
 
-	devr->s1 = ib_create_srq(devr->p0, &attr);
-	if (IS_ERR(devr->s1)) {
-		ret = PTR_ERR(devr->s1);
-		goto error6;
+	s1 = ib_create_srq(devr->p0, &attr);
+	if (IS_ERR(s1)) {
+		ret = PTR_ERR(s1);
+		mlx5_ib_err(dev, "Couldn't create SRQ 1 for res init, err=%d\n", ret);
+		ib_destroy_srq(s0);
+	}
+
+	devr->s0 = s0;
+	devr->s1 = s1;
+
+unlock:
+	mutex_unlock(&devr->srq_lock);
+	return ret;
+}
+
+static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_ib_resources *devr = &dev->devr;
+	int port;
+	int ret;
+
+	if (!MLX5_CAP_GEN(dev->mdev, xrc))
+		return -EOPNOTSUPP;
+
+	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn0, 0);
+	if (ret)
+		return ret;
+
+	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn1, 0);
+	if (ret) {
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
+		return ret;
 	}
 
 	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
 		INIT_WORK(&devr->ports[port].pkey_change_work,
 			  pkey_change_handler);
 
-	return 0;
+	mutex_init(&devr->cq_lock);
+	mutex_init(&devr->srq_lock);
 
-error6:
-	ib_destroy_srq(devr->s0);
-err_create:
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
-error3:
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
-error2:
-	ib_destroy_cq(devr->c0);
-error1:
-	ib_dealloc_pd(devr->p0);
-	return ret;
+	return 0;
 }
 
 static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
@@ -2884,12 +2939,20 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port)
 		cancel_work_sync(&devr->ports[port].pkey_change_work);
 
-	ib_destroy_srq(devr->s1);
-	ib_destroy_srq(devr->s0);
+	/* After s0/s1 init, they are not unset during the device lifetime. */
+	if (devr->s1) {
+		ib_destroy_srq(devr->s1);
+		ib_destroy_srq(devr->s0);
+	}
 	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
 	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
-	ib_destroy_cq(devr->c0);
-	ib_dealloc_pd(devr->p0);
+	/* After p0/c0 init, they are not unset during the device lifetime. */
+	if (devr->c0) {
+		ib_destroy_cq(devr->c0);
+		ib_dealloc_pd(devr->p0);
+	}
+	mutex_destroy(&devr->cq_lock);
+	mutex_destroy(&devr->srq_lock);
 }
 
 static u32 get_core_cap_flags(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 43a963e205eb4..1c83d132197f5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -820,11 +820,13 @@ struct mlx5_ib_port_resources {
 
 struct mlx5_ib_resources {
 	struct ib_cq	*c0;
+	struct mutex cq_lock;
 	u32 xrcdn0;
 	u32 xrcdn1;
 	struct ib_pd	*p0;
 	struct ib_srq	*s0;
 	struct ib_srq	*s1;
+	struct mutex srq_lock;
 	struct mlx5_ib_port_resources ports[2];
 };
 
@@ -1270,6 +1272,8 @@ to_mmmap(struct rdma_user_mmap_entry *rdma_entry)
 		struct mlx5_user_mmap_entry, rdma_entry);
 }
 
+int mlx5_ib_dev_res_cq_init(struct mlx5_ib_dev *dev);
+int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev);
 int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context, unsigned long virt,
 			struct mlx5_db *db);
 void mlx5_ib_db_unmap_user(struct mlx5_ib_ucontext *context, struct mlx5_db *db);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 93d9b15cbbb98..71a856409cee2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3247,6 +3247,10 @@ int mlx5_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	enum ib_qp_type type;
 	int err;
 
+	err = mlx5_ib_dev_res_srq_init(dev);
+	if (err)
+		return err;
+
 	err = check_qp_type(dev, attr, &type);
 	if (err)
 		return err;
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 84be0c3d56995..bcb6b324af506 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -216,6 +216,10 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 		return -EINVAL;
 	}
 
+	err = mlx5_ib_dev_res_cq_init(dev);
+	if (err)
+		return err;
+
 	mutex_init(&srq->mutex);
 	spin_lock_init(&srq->lock);
 	srq->msrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);
-- 
2.43.0



