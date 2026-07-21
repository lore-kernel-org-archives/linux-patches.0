Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7253F12CE;
	Tue, 21 Jul 2026 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655819; cv=none; b=H5AXnqAklHZbVlWUVwvH+rdwaLBQkEfDcGkH44ij40BFyj/E+D7wVKouwWsDcnN2s7XhsZ6amf2iXJjQjwEWIkRDeUpIe1m4LethUoH719Dm+IF8AnHWMteOf1ozBapElhk/RV9HJAbkdvBthIGtH0RrVFLQhvCfYLfoxBr22/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655819; c=relaxed/simple;
	bh=++2GMNFowqbv3b9E4Fipjolj4OXM7rLXK/cu5cJxa94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpwySSqQF/dHfKHpXlWIQGgCm81tU++zXYMs0xi5usVKHBQgaeZwZNQVeV6F0RJ03KlB2XdupRxC5VmPoL0IQdmTkEbh2I13x3A+JE9m5B2jxNwj/eo+SJw3cVNvfwGKS8Ea5nYJB5OoV0nFg6vd/uBrWULYsenylPI9WI2voFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm/+G/1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm/+G/1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD351F000E9;
	Tue, 21 Jul 2026 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655818;
	bh=Tier9jfUU8dnDVWRd4M30bm11cFihIiW21znd8PGXsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm/+G/1mO4CuPW/vouc20q78wHeDV04WD+oOdkdC0ABvzfbKXEyzpfvi49CYTbQ4w
	 GQYd0cUdhKftXeHZZJHH2kr2T1zubhCTus1mrswr6Y6BitVhTtxjricTq4jo3mIm86
	 fNZ6npq+zGr66xfUxmVi6v8j8t4oeqgwkO6jbEWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0154/1611] IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier
Date: Tue, 21 Jul 2026 17:04:30 +0200
Message-ID: <20260721152518.342464538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit e79389115b9d27287ff6230a9750675106ed7668 ]

mlx5_ib_alloc_transport_domain() allocates a transport domain and then
may fail in mlx5_ib_enable_lb(). In that case, the allocated TD is leaked.

Fix this by deallocating the TD when mlx5_ib_enable_lb() returns an
error. Also return 0 explicitly in the no-loopback-capability success
branch, and move dev->lb.mutex initialization to mlx5_ib_stage_init_init().

Fixes: 146d2f1af324 ("IB/mlx5: Allocate a Transport Domain for each ucontext")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 984c258ab0a89e..012386e8cdd4ad 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1941,9 +1941,13 @@ static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn,
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
 	    (!MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) &&
 	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		return err;
+		return 0;
+
+	err = mlx5_ib_enable_lb(dev, true, false);
+	if (err)
+		mlx5_cmd_dealloc_transport_domain(dev->mdev, *tdn, uid);
 
-	return mlx5_ib_enable_lb(dev, true, false);
+	return err;
 }
 
 static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn,
@@ -4246,6 +4250,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		dev->port[i].roce.last_port_state = IB_PORT_DOWN;
 	}
 
+	mutex_init(&dev->lb.mutex);
+
 	err = mlx5r_cmd_query_special_mkeys(dev);
 	if (err)
 		return err;
@@ -4506,11 +4512,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
-	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
-	    (MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) ||
-	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		mutex_init(&dev->lb.mutex);
-
 	if (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
 			MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
 		err = mlx5_ib_init_var_table(dev);
-- 
2.53.0



