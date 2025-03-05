Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3217B505;
	Wed,  5 Mar 2025 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197940; cv=none; b=KR46VTyK5mfjC2Sg1/SkQhDUr7Meusoi5Si9fKJl8aWbzqVcym1kSTA0Z/aeZuSbYhXlnzVeXtLG1Kks5B87NzFPBJi4LILEuP6Jvtij987/qFK+NmzrIzo5lfmD0USWSB9KDZTZHGh9Fm2ryLO3D3PerOoFI3Gg779v8l6DKL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197940; c=relaxed/simple;
	bh=xB1s/k9NyB8zelPArUqxvjcoZOJL+K6AjPgv5hZMzc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBt2r0PNjzAFr5mueQoj0LcxKla3anHn9bnerYv6knLGJ2qs7Euz+B9xPo5jtRKd63OxIgbXbwU4uOMheRhqI3pXDbtfY/Lp9OKkto1zp3/0k47EmDP9uqs4ZcgO0PaWFuXKya4pkoldLjZVbcf9PqqpfgLmrXP7ySl7aW2vV1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BtB+lBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BtB+lBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F74C4CED1;
	Wed,  5 Mar 2025 18:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197939;
	bh=xB1s/k9NyB8zelPArUqxvjcoZOJL+K6AjPgv5hZMzc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BtB+lBJ3Ip5Q0+rTWXnJ8SGUsrl073BXtFvu0tsbH+Qdgt4lOJwMPxBKAVie1k2m
	 Ac335KoNBln+RB1t6cfUGh18d0DgIUr7cpyFsMOufoXFIKKvO/mdaVgeKAaYslw3gB
	 Wn3bRO7/oTCW+vy4Fc4zodRkXPmgTfDWFVoNssQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/150] IB/mlx5: Set and get correct qp_num for a DCT QP
Date: Wed,  5 Mar 2025 18:47:11 +0100
Message-ID: <20250305174503.902492104@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 12d044770e12c4205fa69535b4fa8a9981fea98f ]

When a DCT QP is created on an active lag, it's dctc.port is assigned
in a round-robin way, which is from 1 to dev->lag_port. In this case
when querying this QP, we may get qp_attr.port_num > 2.
Fix this by setting qp->port when modifying a DCT QP, and read port_num
from qp->port instead of dctc.port when querying it.

Fixes: 7c4b1ab9f167 ("IB/mlx5: Add DCT RoCE LAG support")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/94c76bf0adbea997f87ffa27674e0a7118ad92a9.1737290358.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 10ce3b44f645f..0d8a8b109a751 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4547,6 +4547,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 		set_id = mlx5_ib_get_counters_id(dev, attr->port_num - 1);
 		MLX5_SET(dctc, dctc, counter_set_id, set_id);
+
+		qp->port = attr->port_num;
 	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
 		struct mlx5_ib_modify_qp_resp resp = {};
 		u32 out[MLX5_ST_SZ_DW(create_dct_out)] = {};
@@ -5033,7 +5035,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 	}
 
 	if (qp_attr_mask & IB_QP_PORT)
-		qp_attr->port_num = MLX5_GET(dctc, dctc, port);
+		qp_attr->port_num = mqp->port;
 	if (qp_attr_mask & IB_QP_MIN_RNR_TIMER)
 		qp_attr->min_rnr_timer = MLX5_GET(dctc, dctc, min_rnr_nak);
 	if (qp_attr_mask & IB_QP_AV) {
-- 
2.39.5



