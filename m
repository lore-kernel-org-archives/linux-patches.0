Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCCE3BB48
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dddgETw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBB0C433C9;
	Wed, 15 Nov 2023 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078281;
	bh=jsyUMc0BAVcRpq41fSKuQcaIUWVLqqsVxRAlmbY6ee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dddgETw9b8RQewg5xJGkTfI9kSOmWla9ZSfT0zus/P0ry9iLcpJgSxwALa77oIin7
	 +quAnPti2oWzpGiRAXKDS8SycGXWJh7N3mMxzO7o27X6Hbpq5A4ZXOOk16GL57Qvmb
	 rmUzcxhZg7oUxe+YPF9lNi5NP0yxkq9X3bSYyKk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/379] IB/mlx5: Fix rdma counter binding for RAW QP
Date: Wed, 15 Nov 2023 14:24:52 -0500
Message-ID: <20231115192657.952709687@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit c1336bb4aa5e809a622a87d74311275514086596 ]

Previously when we had a RAW QP, we bound a counter to it when it moved
to INIT state, using the counter context inside RQC.

But when we try to modify that counter later in RTS state we used
modify QP which tries to change the counter inside QPC instead of RQC.

Now we correctly modify the counter set_id inside of RQC instead of QPC
for the RAW QP.

Fixes: d14133dd4161 ("IB/mlx5: Support set qp counter")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/2e5ab6713784a8fe997d19c508187a0dfecf2dfc.1696847964.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ac53ed79ca64c..e0df3017e241a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3960,6 +3960,30 @@ static unsigned int get_tx_affinity(struct ib_qp *qp,
 	return tx_affinity;
 }
 
+static int __mlx5_ib_qp_set_raw_qp_counter(struct mlx5_ib_qp *qp, u32 set_id,
+					   struct mlx5_core_dev *mdev)
+{
+	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
+	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+	u32 in[MLX5_ST_SZ_DW(modify_rq_in)] = {};
+	void *rqc;
+
+	if (!qp->rq.wqe_cnt)
+		return 0;
+
+	MLX5_SET(modify_rq_in, in, rq_state, rq->state);
+	MLX5_SET(modify_rq_in, in, uid, to_mpd(qp->ibqp.pd)->uid);
+
+	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
+	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RDY);
+
+	MLX5_SET64(modify_rq_in, in, modify_bitmask,
+		   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
+	MLX5_SET(rqc, rqc, counter_set_id, set_id);
+
+	return mlx5_core_modify_rq(mdev, rq->base.mqp.qpn, in);
+}
+
 static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 				    struct rdma_counter *counter)
 {
@@ -3975,6 +3999,9 @@ static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 	else
 		set_id = mlx5_ib_get_counters_id(dev, mqp->port - 1);
 
+	if (mqp->type == IB_QPT_RAW_PACKET)
+		return __mlx5_ib_qp_set_raw_qp_counter(mqp, set_id, dev->mdev);
+
 	base = &mqp->trans_qp.base;
 	MLX5_SET(rts2rts_qp_in, in, opcode, MLX5_CMD_OP_RTS2RTS_QP);
 	MLX5_SET(rts2rts_qp_in, in, qpn, base->mqp.qpn);
-- 
2.42.0



