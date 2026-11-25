Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625205;
	b=W1CIpv/sAIrYnU0IOlmy7J/9mA37V4vFGbz5CEqi4FAA44tDymsce4e2noNRXH2GnLK2
	 LwmwSrYg8tNufcAeENAeX+NKmlCufsxlaXpeo/aOsfFniKPqnSlpnTE3yj4/q4h1BJcXZ
	 D8lNpCHQTXK33poVpipDaFLrftKIyxdU/yjxjJQtwWnlbI9ujHOdBi4szTcLa3ibSUpSH
	 KzOVNqy0P5XaIFe6YJ9UpQ8pt7Eq7tRmsqsfW+AfgDwfchd3dr8lU+dKOLHG7VuOEdFcD
	 FJJYKtz6w7MAE3Unp2wD64ugKlefNx8URunop/8K1u6FfkdOp6JS975iMr9YhkrJ70g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GisvJYoPTosf5318KzhzqSw5QYWc9eW+8W44X3tFE50=;
	b=18OEsmMrezOFpYDbmqPU9thJHPcVEApo+N8BYmIYt5RI9vVql0kD9/2H2X3Ui0Y+XM/A
	 6Lci9YcQf5qY9EK5Dxm6ZG35EaeCGiuCDxn8voPrHQPan0QlEtDRIe6Qq74/QFqKUVo/b
	 3YFfx5QTjLi8NDRPVDdNHlYRXIcE4tWqDzb0M+Gv4lgQ8N5XIkHFL4lb5BNHLXXkcrePZ
	 6JDClqFmqcCr1UNHMe78l4XL1XhpybGZknXUkxrxIDugPl1C/+Q1EhjpG+ZeFnl0Ty/Sc
	 LoXRYq6Sz6SG+UkVNl9Ss26UvUHjJhTou3mT7YCRpJN8U1fUPJPxvEqp8CQul51mK4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D58+uJFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27A6606A323;
	Wed, 25 Nov 2026 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D58+uJFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390EF1F000CA;
	Wed, 25 Nov 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625204;
	bh=GisvJYoPTosf5318KzhzqSw5QYWc9eW+8W44X3tFE50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D58+uJFMw+TOTYXW//9Dv4Lgt4xo2Ke4QWmB4FwJgkz/b15kGeruMx2w0V00Zghus
	 SIm5qHf64HcagCLe8h61DosKjisufYO12E14mLwFqWjo2VxdT5dT8pqLSz36ME/26S
	 pnPsNo/pwVzI/PAsnMjnuCewQTT2I/GEl2sXv7Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 440/816] RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
Date: Wed, 25 Nov 2026 15:33:08 +0100
Message-ID: <20261125143859.374317443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 4354ab7a85d1ddd45a8a3337227fad5b37b44902 ]

mlx5_ib_dev_res_init() returns -EOPNOTSUPP when the firmware XRC
capability is absent, failing driver probe on XRC-less devices.

Make XRC optional throughout the devr resource path: initialize cq_lock
and srq_lock unconditionally (needed for every QP creation), skip xrcd
allocation and the XRC-type placeholder SRQ (s0) when xrc=0, and guard
their cleanup paths accordingly.

Fixes: f4375443b786 ("RDMA/mlx5: Get XRCD number directly for the internal use")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-9-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Wrapped SRQ 0 creation in an XRC capability check as upstream does, but kept this tree's older err=%d, ret error message format instead of upstream's err=%pe. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 52 +++++++++++++++++++------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 95d65d74dc912..ee58dc153eedc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3101,7 +3101,7 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	struct ib_srq_init_attr attr;
-	struct ib_srq *s0, *s1;
+	struct ib_srq *s0 = NULL, *s1;
 	int ret = 0;
 
 	/*
@@ -3119,17 +3119,25 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		goto unlock;
 
-	memset(&attr, 0, sizeof(attr));
-	attr.attr.max_sge = 1;
-	attr.attr.max_wr = 1;
-	attr.srq_type = IB_SRQT_XRC;
-	attr.ext.cq = devr->c0;
-
-	s0 = ib_create_srq(devr->p0, &attr);
-	if (IS_ERR(s0)) {
-		ret = PTR_ERR(s0);
-		mlx5_ib_err(dev, "Couldn't create SRQ 0 for res init, err=%d\n", ret);
-		goto unlock;
+	/*
+	 * s0 is an XRC-type placeholder SRQ used as the default XRQN for
+	 * XRC QPs.  Skip it when XRC is absent; all devr->s0 accesses in
+	 * qp.c are inside XRC QP paths that the verbs layer blocks before
+	 * reaching this driver when xrc=0, so NULL is safe.
+	 */
+	if (MLX5_CAP_GEN(dev->mdev, xrc)) {
+		memset(&attr, 0, sizeof(attr));
+		attr.attr.max_sge = 1;
+		attr.attr.max_wr = 1;
+		attr.srq_type = IB_SRQT_XRC;
+		attr.ext.cq = devr->c0;
+
+		s0 = ib_create_srq(devr->p0, &attr);
+		if (IS_ERR(s0)) {
+			ret = PTR_ERR(s0);
+			mlx5_ib_err(dev, "Couldn't create SRQ 0 for res init, err=%d\n", ret);
+			goto unlock;
+		}
 	}
 
 	memset(&attr, 0, sizeof(attr));
@@ -3141,7 +3149,8 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 	if (IS_ERR(s1)) {
 		ret = PTR_ERR(s1);
 		mlx5_ib_err(dev, "Couldn't create SRQ 1 for res init, err=%d\n", ret);
-		ib_destroy_srq(s0);
+		if (s0)
+			ib_destroy_srq(s0);
 		goto unlock;
 	}
 
@@ -3158,8 +3167,11 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int ret;
 
+	mutex_init(&devr->cq_lock);
+	mutex_init(&devr->srq_lock);
+
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
-		return -EOPNOTSUPP;
+		return 0;
 
 	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn0, 0);
 	if (ret)
@@ -3171,9 +3183,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 		return ret;
 	}
 
-	mutex_init(&devr->cq_lock);
-	mutex_init(&devr->srq_lock);
-
 	return 0;
 }
 
@@ -3184,10 +3193,13 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 	/* After s0/s1 init, they are not unset during the device lifetime. */
 	if (devr->s1) {
 		ib_destroy_srq(devr->s1);
-		ib_destroy_srq(devr->s0);
+		if (devr->s0)
+			ib_destroy_srq(devr->s0);
+	}
+	if (MLX5_CAP_GEN(dev->mdev, xrc)) {
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
 	}
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
 	/* After p0/c0 init, they are not unset during the device lifetime. */
 	if (devr->c0) {
 		ib_destroy_cq(devr->c0);
-- 
2.53.0



