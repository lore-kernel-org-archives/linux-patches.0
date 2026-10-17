Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D175355F49;
	Sat, 17 Oct 2026 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253517; cv=none; b=pqZh9ry10gKLCPquhWCK+jprtUX7065S3LkatzFtOunzCfqceUS6HrrLPJBpVA5cZNBogEqXjz5AwakguhfIAM+ihzG0Y14gTFQt9ZTYzetIWq/nxWMIqbUsUZS7lzblLEqnJVRYGmnJr0ZLs3BGjCM3Qe16O4p5DDQARZdci7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253517; c=relaxed/simple;
	bh=f28+ocmSjCrJJoGgnYRPGQrNk90pJidKgRSFm238p4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsiNXfGlMX7NJ+hjM8KVcfseKKBQNHdpvRINGRZiq5DaXoNJOtsIsOF2SaxZISo38+p/9yUALUhtsIvn8bGzdgOm8SWn0qMoGK9g6qOpaMaZD9TxoS6mpzR2ua4VqhwJh0r1PIgdT+nb1SGsqkPad00zilJTNMb27C3tFVuCU2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiqrnUpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiqrnUpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B840F1F000C5;
	Sat, 17 Oct 2026 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253516;
	bh=vaoA6Atq+DjPgjC1H4YECc4BDUnHirJGgOcNa+ujUt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiqrnUpKdPahvNP+OUjmbbFYDWWUKpgHrEA7cFsVv27WwnHmcO21nppav1i7xFAc5
	 va8PcJOCmzPNlYBfhLjLmGt3xCENRSlARs3NAXIE78xa86sm8nqwzl5WXCQ5I8JlTH
	 Vbc8UuB+1Ks0UWjydBkZh9U02ZXd+Zrj6CgkZDYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Fan Li <fanl@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/869] RDMA/mlx5: Remove the redundant MLX5_IB_STAGE_UAR stage
Date: Sat, 17 Oct 2026 17:49:44 +0200
Message-ID: <20261017160040.708031591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 972db388d40ded1a5ef8ce09d92ef1e2b9e40f07 ]

The MLX5_IB_STAGE_UAR stage in the RDMA driver is redundant and should
be removed.

Responsibility for initializing the device's UAR pointer
(mdev->priv.uar) lies with mlx5_core, which already sets it during the
mlx5_load() process.

At present, the RDMA UAR stage overwrites this pointer, which was
correctly initialized by mlx5_core, creating the risk of inconsistency.

Ownership and management of the UAR pointer should remain exclusively
within mlx5_core.

In the current upstream code, we luckily receive the same pointer, since
mlx5_get_uars_page() still finds available BF registers for that UAR,
allowing it to be shared.

However, future changes in mlx5_core may expose this flaw.
For instance, if mlx5_alloc_bfreg() is invoked twice before the RDMA UAR
stage runs, the RDMA driver may overwrite the UAR allocated by
mlx5_core.

This could lead to real bugs. For example, if mlx5_ib is unloaded
(rmmod), it might free the UAR, leaving mlx5_core with a dangling
reference to an invalid UAR.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Fan Li <fanl@nvidia.com>
Link: https://patch.msgid.link/feaa84ec6f20468b4935c439923e9266122a93d0.1747134130.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: e5eba42f0134 ("mlx5: Fix default values in create CQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 17 -----------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2d1cb516d8450..42a917c2d0d7f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4502,17 +4502,6 @@ static void mlx5_ib_stage_cong_debugfs_cleanup(struct mlx5_ib_dev *dev)
 				     mlx5_core_native_port_num(dev->mdev) - 1);
 }
 
-static int mlx5_ib_stage_uar_init(struct mlx5_ib_dev *dev)
-{
-	dev->mdev->priv.uar = mlx5_get_uars_page(dev->mdev);
-	return PTR_ERR_OR_ZERO(dev->mdev->priv.uar);
-}
-
-static void mlx5_ib_stage_uar_cleanup(struct mlx5_ib_dev *dev)
-{
-	mlx5_put_uars_page(dev->mdev, dev->mdev->priv.uar);
-}
-
 static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 {
 	int err;
@@ -4742,9 +4731,6 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_CONG_DEBUGFS,
 		     mlx5_ib_stage_cong_debugfs_init,
 		     mlx5_ib_stage_cong_debugfs_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_UAR,
-		     mlx5_ib_stage_uar_init,
-		     mlx5_ib_stage_uar_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_BFREG,
 		     mlx5_ib_stage_bfrag_init,
 		     mlx5_ib_stage_bfrag_cleanup),
@@ -4805,9 +4791,6 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_CONG_DEBUGFS,
 		     mlx5_ib_stage_cong_debugfs_init,
 		     mlx5_ib_stage_cong_debugfs_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_UAR,
-		     mlx5_ib_stage_uar_init,
-		     mlx5_ib_stage_uar_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_BFREG,
 		     mlx5_ib_stage_bfrag_init,
 		     mlx5_ib_stage_bfrag_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 3135519f1cfdf..5c0efac217eac 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -975,7 +975,6 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_ODP,
 	MLX5_IB_STAGE_COUNTERS,
 	MLX5_IB_STAGE_CONG_DEBUGFS,
-	MLX5_IB_STAGE_UAR,
 	MLX5_IB_STAGE_BFREG,
 	MLX5_IB_STAGE_PRE_IB_REG_UMR,
 	MLX5_IB_STAGE_WHITELIST_UID,
-- 
2.53.0



