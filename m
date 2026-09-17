Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E0D4F85BE;
	Thu, 17 Sep 2026 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667959; cv=none; b=UEk/WH3mV50fBsWG5yE7uIN0xusYOpFbyetlEkZEAkGDwCZH+zPpPvfD5J5Eyna1Aaf6a4/jvZBYhsoGJfPj3u904+6tq/aDjb0mexPQqL7znoZvPdOcVgdirjpkukyvaulv+YTFHLHtUmhMQZE09gmrXEnfdYnyYR8RxjqMZe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667959; c=relaxed/simple;
	bh=xUc1EC/mKirqzp9zj4OoZmrUyLf4oK+qs0amjgwTwoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uhi+ORqfyAwT8xIihJfpcTd01PgyHbGkyZV2w1k01vdRYoB6T0dmmMkTLb/OVerCtzFJ2Uia8mLcqBs1HgLsi+vbRqbA0CLDbHkc6P4VAu9X4OQ4gYwr0HAwLjI0SW1eJ0ZZMCnNK2VDkAGxNqZnDyK4Hamm0h7jRtFh6lZgdM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KADrCgAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KADrCgAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AF21F000FF;
	Thu, 17 Sep 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667957;
	bh=LV83pEV9EIDie8yZMBmVKCgaUXpyvw8tVZIx5QtxHQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KADrCgAn1dRZPr7PafV4nT5NLU6kTrRIcfVkh3WNfqK9OgIY5L/LizYyro1kZIwJu
	 7mqwt/9zmwaEEJfOcqSMEckS3iNWwUqlR8usJScMlP5bnl0wQ+Cdl33mp5JXdwh/aV
	 q9oJ4uFlEWTvKh1DdVCkIj9TTbVsNUuCXOVnAfEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0249/1102] RDMA/mlx5: Create ODP EQ for non-pinned dmabuf MRs
Date: Thu, 17 Sep 2026 16:03:12 +0100
Message-ID: <20260917151545.846264024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 93e64c7a33ff6679d4d1c0a03021a2ff0e2b6c98 ]

DMABUF generally relies on the ODP EQ mechanism to safely implement the
move semantics. ODP requires a device-global one time startup of the ODP
machinery when the first MR is created, and this was missed on the DMABUF
path.

Call mlx5r_odp_create_eq() when creating a ODP'able DMABUF.

The core code prevents using IB_ACCESS_ON_DEMAND unless the driver
advertises IB_ODP_SUPPORT, so until now, mlx5r_odp_create_eq() cannot be
called unless the device has ODP support.

However, DMABUF has no such protection and a second bug was allowing
DMABUFs to be created on non-ODP capable HW. Add a guard at the start of
mlx5r_odp_create_eq(). This is necessary here anyhow as the
dev->odp_eq_mutex is not initialized without IB_ODP_SUPPORT.

Link: https://patch.msgid.link/r/2-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c  | 4 ++++
 drivers/infiniband/hw/mlx5/odp.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 76d2238ea5e7d..aa4e088de6793 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1616,6 +1616,10 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 	atomic_add(ib_umem_num_pages(mr->umem), &dev->mdev->priv.reg_pages);
 	umem_dmabuf->private = mr;
 	if (!pinned_mode) {
+		err = mlx5r_odp_create_eq(dev, &dev->odp_pf_eq);
+		if (err)
+			goto err_dereg_mr;
+
 		err = mlx5r_store_odp_mkey(dev, &mr->mmkey);
 		if (err)
 			goto err_dereg_mr;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 98a76c9db7aba..4fb1b24da97e8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1780,6 +1780,9 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	struct mlx5_eq_param param = {};
 	int err = 0;
 
+	if (!(dev->odp_caps.general_caps & IB_ODP_SUPPORT))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&dev->odp_eq_mutex);
 	if (eq->core)
 		goto unlock;
-- 
2.53.0



