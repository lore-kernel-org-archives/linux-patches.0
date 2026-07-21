Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03AD415F14;
	Tue, 21 Jul 2026 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661585; cv=none; b=a73TjsO2idUg9d/fUCGMqmQfEnsnwuDLEZ7WI6O37YToIzCiabjBKU5rPzzmNdFBUK1B86xTx3/RPr+DXYl9RY3K+hbFztkeUWTxVS179uHFL1S5aY74soIPMhyqL4M3ZuG3IRAQcIrNSFg+HdFecyObOctIcbaCJcpwWP4KDvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661585; c=relaxed/simple;
	bh=qvnUA+wPAGABT8EQCWbO81Qfhn77I7T4p55aG+uzVjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZRx6DVD1FfM2XWnH5zOZWzEvg++e+U0728elxyAFN3aPMuqgd3KnFW0sgpHHMotGmNemxLUlBp4zBtk0kveI46xhooF9f1lhQassZoZq83boukJJS9RjdjuMpgaC1rjzjOw7bccaH8d0uc6/uYbgDBo8x0emCQouVndNO0C8y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BhCBd1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BhCBd1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4305E1F00A3A;
	Tue, 21 Jul 2026 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661584;
	bh=3g14ArYF0A7Y9DblgPs9tPDxuxAMh/X0Tr9oDFKICRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BhCBd1SG0cbBhhydkBAOxgKrFJtXTFQCeFqpyHmQVX/vhMsn11yFDn1R5GufIfY0
	 pdpSqEfCTIE3PYT+bnNi3cgowPg+YLVT30hg0JkfTbDpHM3QoboLXHbl/AqyGIN0H/
	 qiYdnqv/lzDxawbgLkYOmiGax2BSS1QWpP1f4Q7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0121/1276] IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier
Date: Tue, 21 Jul 2026 17:09:24 +0200
Message-ID: <20260721152448.811713255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index b0a0e11ef721f9..3f5d0eb60db2a4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1915,9 +1915,13 @@ static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn,
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
@@ -4164,6 +4168,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		dev->port[i].roce.last_port_state = IB_PORT_DOWN;
 	}
 
+	mutex_init(&dev->lb.mutex);
+
 	err = mlx5r_cmd_query_special_mkeys(dev);
 	if (err)
 		return err;
@@ -4378,11 +4384,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
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



