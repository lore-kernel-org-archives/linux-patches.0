Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EDE1A3174;
	Wed,  5 Mar 2025 18:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197984; cv=none; b=p8WpUlMcFVdPluY5I0JZmS415LN44D0lvxgb4S9jDy4ITWL6iJF//dk4IvBnr5fRoSG12Q5lnlPXkBiK2ugEunYu+8umpR/49Nty8NhlJnEA0HJyinY0/qa11xDjzMF3z5G+utSBKUcBYAYdkMqTl3i+AHUEidWLlYj+M87bO/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197984; c=relaxed/simple;
	bh=Hfg68BAVngC5OVh4ZPIvJMMYRVulObG4r/wjmUu/wrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8qPvs734v7NpgVoZ6lj9UhF8gkqTw9LiNQwL6rI3qWhhvhKuxKt0+lqB4PqfaWViomThXsDt2gb6gs21JLzee7EvygVH9hOwohzOPrBErCXNUewkvbTDYZtmaf2Ael5F1WfNo0hcHtI9OaCpDDFvxWf7XNRRaGbNX7p1BHVCAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMWrTjm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMWrTjm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86369C4CED1;
	Wed,  5 Mar 2025 18:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197983;
	bh=Hfg68BAVngC5OVh4ZPIvJMMYRVulObG4r/wjmUu/wrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMWrTjm+QphvLjJ8FMuaiMTqh/Wr26KsbrJS2KyzFbJmzo51aXDal/Ery9LLVp6vH
	 AdeXgXUsrm4X+KKrR2ScoqzbsDARIQcGThIY6kzKvSaVYEiXMIydTUCIgHKYGZP/1i
	 kfLlZlCQEaaulhGBXwpAnlituZzA2ude9kURUvQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/150] RDMA/mlx5: Fix bind QP error cleanup flow
Date: Wed,  5 Mar 2025 18:47:34 +0100
Message-ID: <20250305174504.825004897@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit e1a0bdbdfdf08428f0ede5ae49c7f4139ac73ef5 ]

When there is a failure during bind QP, the cleanup flow destroys the
counter regardless if it is the one that created it or not, which is
problematic since if it isn't the one that created it, that counter could
still be in use.

Fix that by destroying the counter only if it was created during this call.

Fixes: 45842fc627c7 ("IB/mlx5: Support statistic q counter configuration")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://patch.msgid.link/25dfefddb0ebefa668c32e06a94d84e3216257cf.1740033937.git.leon@kernel.org
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 4f6c1968a2ee3..81cfa74147a18 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -546,6 +546,7 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 				   struct ib_qp *qp)
 {
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	bool new = false;
 	int err;
 
 	if (!counter->id) {
@@ -560,6 +561,7 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 			return err;
 		counter->id =
 			MLX5_GET(alloc_q_counter_out, out, counter_set_id);
+		new = true;
 	}
 
 	err = mlx5_ib_qp_set_counter(qp, counter);
@@ -569,8 +571,10 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 	return 0;
 
 fail_set_counter:
-	mlx5_ib_counter_dealloc(counter);
-	counter->id = 0;
+	if (new) {
+		mlx5_ib_counter_dealloc(counter);
+		counter->id = 0;
+	}
 
 	return err;
 }
-- 
2.39.5



