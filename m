Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622492;
	b=I9BuQuciEi42ZLapFw9JeCIggPm60rJ2vGLsPKcS3UxYeaqA19yRoFbT+Jgs6fexn8FU
	 k3h7hGsJU0dnlFSV02jXmN973BhczkXBo+Eenl9jRsIlrl1QJw4/yDuNz+9vdJF9WS0iu
	 1xPS3iPdpwU/Ox3vmyyD4NKfnFfPFofJ6h+Sd5qv3q47X+mvShsFld9qKEXHyznboiftp
	 l2aBNtJ5CN9LUQRpCv9pnLt4KzrPicpHf8ubejRclCntdSNxrUuNE3+45KIBomrXGYlQ2
	 /VojrC5zmJXR1qtdTfpT73zCMoPFmAEI9oZRBqZQU22FbnRI0Mxq74MEZkhpfK5keQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xR3u3abMU0VyUUZW41ptPNq/3QZv39hPpfigBKiY1zw=;
	b=Z7H/wFJ8cpnLOajcsE8/tRR5C4wSTlKP+JuU9dvAoEGTYgRWxtUIFPj+DpKQFpidSIX3
	 DeaA0nqQfTy+4a+AR5q1CppL1jaqY0rb9kCxP+Issg5eL/v1Oi0EW0ry++JZjopNOSdQk
	 iXl8KRPK+HshG/DiFYW+XLWqU/f42Md0Yq7S15SEw83XOLSNfg3oKXwWS2iBLTHtMHp7C
	 3rl7Lqv99X84zcJ8o/I9yv/+OSuKz6W5MQGbAJIagrKAxWbVxvNsu1vUs1KyjbtNZPZYX
	 RVkP/s5gKLDV5VXVYITXuQcElhR2xQRVVvcyDNm/odMXTGVvb7lvB+Ds2bKNDg2FjNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rFouUp/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114BA606A331;
	Wed, 25 Nov 2026 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFouUp/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E281F000D3;
	Wed, 25 Nov 2026 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622491;
	bh=xR3u3abMU0VyUUZW41ptPNq/3QZv39hPpfigBKiY1zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFouUp/+ITu2Q1l//hWt7wNjMSw7LEWFUj1+P4O29XgIKISm7ntDbTWlFki2FYGWU
	 gj3vyEyr1f6kP2v7KLTNedXFE4TJbwvSfjs5Cj86zofTHl581d+ZuGvr2xmkA/wbaJ
	 0zQrnDhFEXIYPtONg6aLVoXCIMZpbOOReBm+6PGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/990] RDMA/mlx5: Set QP event handler before firmware QPC insertion
Date: Wed, 25 Nov 2026 15:32:03 +0100
Message-ID: <20261125143835.120972494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 05a078c97eb0bb7158526dae414b853737692485 ]

Four QP creation paths assigned base->container_mibqp and
base->mqp.event after the firmware create call that inserts the QP into
dev->qp_table.tree. A firmware error EQE in that window reaches
qp->event() with a NULL pointer.

Move both assignments before the firmware call.

Also set ibqp.qp_num inside mlx5_qpc_create_qp() before
create_resource_common() so an EQE arriving early does not observe
qp_num==0.

In addition, add a WARN_ON_ONCE(!qp->event) guard in
rsc_event_notifier() as a safeguard for future regressions.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-14-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Moved the base->container_mibqp and mqp.event assignments ahead of the firmware QP creation call, with context adjusted for the older base (no attrs argument in create_raw_packet_qp_sq()). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c  | 22 ++++++++++------------
 drivers/infiniband/hw/mlx5/qpc.c | 10 ++++++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 865000d1a2c52..5a6aede3f138a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1599,6 +1599,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			return err;
 
+		sq->base.container_mibqp = qp;
+		sq->base.mqp.event = mlx5_ib_qp_event;
 		err = create_raw_packet_qp_sq(dev, udata, sq, in, pd,
 					      to_mcq(init_attr->send_cq));
 		if (err)
@@ -1610,9 +1612,6 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			resp->sqn = sq->base.mqp.qpn;
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_SQN;
 		}
-
-		sq->base.container_mibqp = qp;
-		sq->base.mqp.event = mlx5_ib_qp_event;
 	}
 
 	if (qp->rq.wqe_cnt) {
@@ -2062,13 +2061,13 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	base = &qp->trans_qp.base;
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
 		return err;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2206,14 +2205,14 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
 	}
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 
 	kvfree(in);
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2402,6 +2401,8 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
 	}
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	if (init_attr->qp_type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN) {
 		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd->sq_buf_addr;
@@ -2415,8 +2416,6 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2545,14 +2544,13 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	    MLX5_CAP_GEN(mdev, go_back_n))
 		MLX5_SET(qpc, qpc, retry_mode, MLX5_QP_RM_GO_BACK_N);
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
-
 	get_cqs(qp->type, attr->send_cq, attr->recv_cq,
 		&send_cq, &recv_cq);
 	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 67ed45f3ae17f..9272e1ef81135 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -146,6 +146,8 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	case MLX5_RES_RQ:
 	case MLX5_RES_SQ:
 		qp = (struct mlx5_core_qp *)common;
+		if (WARN_ON_ONCE(!qp->event))
+			goto out;
 		qp->event(qp, event_type);
 		/* Need to put resource in event handler */
 		return NOTIFY_OK;
@@ -258,6 +260,14 @@ int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 
 	qp->uid = MLX5_GET(create_qp_in, in, uid);
 	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
+	/* Set ibqp.qp_num before create_resource_common() inserts the QP into
+	 * the radix tree and makes it visible to EQE processing.  The
+	 * assignment in create_qp() happens only after this function returns,
+	 * leaving a window where an arriving EQE would observe qp_num == 0.
+	 * create_qp() still overrides this with 0/1 for QP0/QP1, and sets it
+	 * independently for DCT (which does not go through this function).
+	 */
+	to_mibqp(qp)->ibqp.qp_num = qp->qpn;
 
 	err = create_resource_common(dev, qp, MLX5_RES_QP);
 	if (err)
-- 
2.53.0



